import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

/// A top-bar command with a name you can read: an icon plus a short label.
///
/// The fleet ruling on top bars is "icon plus a short visible label; rare
/// actions in a worded menu ([OhBarOverflow]); a tooltip is never a
/// command's only name". Reckon, Trellis and StillLife each grew their own
/// copy of this widget; this is the one they share.
///
/// ## The fold rule (by space)
///
/// Inside an [OhBarActions] row, words stay on screen **whenever they fit
/// beside a whole title**. Only when the row would squeeze the title does a
/// command fold, the rightmost first: its word moves into the tooltip and
/// the screen-reader name and it shows as its 48 dp icon. The row measures
/// the AppBar's title in the title's own style and text scale, the leading
/// button and the title spacing, and folds as few commands as it must. So a
/// lone "Undo" beside "Lilt" keeps its word at 3.0x, and a busy bar folds
/// its More menu first.
///
/// **Long titles.** A title that cannot be whole even with every command
/// folded (a book's name) will ellipsize whatever the row does, so folding
/// it all would drop words for nothing. Then the row folds only to keep the
/// title a floor of [OhBarActions.minTitleShare] (30%) of the bar.
///
/// Why: an AppBar is one fixed row. At the fleet's worst case, a 320 dp
/// phone at 3.0x text, a title plus three worded controls cannot fit, and
/// apps that kept every word paid with the title (porch's became "Po…").
/// Folding by space keeps the title whole without dropping words that fit.
///
/// **Fallback (the fixed rule).** When the row cannot measure the title (the
/// title is not a plain `Text`, and no `titleReserve` was given) or the
/// command is not in an [OhBarActions] row, the word shows up to and
/// including [labelMaxScale] (1.5x) and folds above it.
///
/// ## The name
///
/// A screen reader hears one button named [semanticLabel] (default:
/// [label]) in both modes, with its enabled state and tap action. The
/// visible word and the tooltip do not add a second copy.
///
/// ## Look
///
/// Neutral ink: the surrounding [IconTheme] colour (inside an AppBar, the
/// bar's foreground), the same as [OhThemeToggle], so glyphs and words in a
/// bar match. Warmth is for a screen's one primary action. At least
/// 48 x 48 dp in both modes; 8 dp side padding.
class OhBarAction extends StatelessWidget {
  const OhBarAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.semanticLabel,
    this.tooltip,
  });

  /// The glyph, shown in both modes.
  final IconData icon;

  /// The short word on screen, one or two words ("Refresh", "Group vote").
  final String label;

  /// Null disables the command (and says so to a screen reader).
  final VoidCallback? onPressed;

  /// A fuller name for screen readers, when the short word is ambiguous out
  /// of context ("Refresh the vote"). Defaults to [label].
  final String? semanticLabel;

  /// The long-press / hover hint. Defaults to [label] when folded; when the
  /// word is visible, a tooltip is only shown if you pass one.
  final String? tooltip;

  /// The fallback rule's threshold: the largest text scale at which the
  /// label shows when the row cannot measure the space.
  static const double labelMaxScale = 1.5;

  /// The fallback rule: folded above [labelMaxScale], worded at or below.
  static bool collapsesAt(TextScaler scaler) =>
      scaler.scale(10) > 10 * labelMaxScale + 1e-9;

  /// The fallback rule in this [context].
  static bool collapsed(BuildContext context) =>
      collapsesAt(MediaQuery.textScalerOf(context));

  /// The bar's neutral ink in this [context].
  static Color inkOf(BuildContext context) =>
      IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurface;

  @override
  Widget build(BuildContext context) {
    final ink = inkOf(context);
    final Widget worded = TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label, maxLines: 1, softWrap: false),
      style: TextButton.styleFrom(
        foregroundColor: ink,
        iconColor: ink,
        disabledForegroundColor: ink.withValues(alpha: 0.38),
        disabledIconColor: ink.withValues(alpha: 0.38),
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
    // One name in both modes. Excluding the child's semantics also drops
    // its tap action, so it is handed back here.
    return Semantics(
      container: true,
      button: true,
      enabled: onPressed != null,
      label: semanticLabel ?? label,
      onTap: onPressed,
      excludeSemantics: true,
      child: OhBarFoldable(
        worded:
            tooltip == null ? worded : Tooltip(message: tooltip, child: worded),
        folded: Tooltip(
          message: tooltip ?? label,
          child: IconButton(onPressed: onPressed, color: ink, icon: Icon(icon)),
        ),
      ),
    );
  }
}

/// A bar face with a worded and a folded form, for custom bar controls
/// (a menu that names its current choice) that must follow the same fold
/// rule as [OhBarAction]. Inside an [OhBarActions] row the row picks the
/// form by space; elsewhere the fixed rule ([OhBarAction.collapsesAt])
/// picks it. Both forms stay built; only the chosen one is laid out as the
/// face, painted, hit-tested, focusable and seen by screen readers.
class OhBarFoldable extends StatefulWidget {
  const OhBarFoldable({super.key, required this.worded, required this.folded});

  final Widget worded;
  final Widget folded;

  @override
  State<OhBarFoldable> createState() => _OhBarFoldableState();
}

class _OhBarFoldableState extends State<OhBarFoldable> {
  bool? _shown;

  void _onShown(bool folded) {
    if (_shown == folded) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted && _shown != folded) setState(() => _shown = folded);
    });
  }

  @override
  Widget build(BuildContext context) {
    final fixed = OhBarAction.collapsed(context);
    final shown = _shown ?? fixed;
    return _FoldPair(
      fixedFold: fixed,
      onShown: _onShown,
      children: [
        ExcludeFocus(excluding: shown, child: widget.worded),
        ExcludeFocus(excluding: !shown, child: widget.folded),
      ],
    );
  }
}

/// A top bar's row of commands, which folds by space (see [OhBarAction]).
///
/// Put all of a bar's actions in one row: it measures the room the title
/// needs from the enclosing [AppBar] (its title `Text`, title style and the
/// title's own 1.34x scale cap, the leading button and the title spacing).
/// If the title is not a plain `Text`, pass [titleReserve], the width the
/// title needs; without it the row falls back to the fixed 1.5x rule.
///
/// Inside the row [OhBarAction], [OhBarOverflow], [OhBarFoldable] and
/// [OhThemeToggle] fold by space, rightmost first. Words in the row stop
/// growing at [maxScale] (2x, the WCAG 200% floor).
class OhBarActions extends StatelessWidget {
  const OhBarActions({super.key, required this.children, this.titleReserve});

  final List<Widget> children;

  /// The width the title needs, for a title that is not a plain `Text`.
  final double? titleReserve;

  /// The text-scale cap for words in the row.
  static const double maxScale = 2.0;

  /// The AppBar's own cap on its title's text scale (Material's
  /// `_kMaxTitleTextScaleFactor`).
  static const double appBarTitleMaxScale = 1.34;

  /// Whether [context] sits inside an [OhBarActions] row. Widgets that also
  /// live outside bars (the theme toggle) fold only when they are in one.
  static bool inRow(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_OhBarScope>() != null;

  /// A title too long to be whole even with every command folded keeps at
  /// least this share of the bar; commands fold only to protect it.
  static const double minTitleShare = 0.3;

  /// What the title needs beside the actions: the fixed overhead (leading
  /// button, title spacing) and the title's own width (0 with no title), or
  /// null when the title cannot be measured.
  ({double overhead, double title})? _reserve(BuildContext context) {
    final bar = context.findAncestorWidgetOfExactType<AppBar>();
    if (bar == null) return null;
    final barTheme = AppBarTheme.of(context);
    final theme = Theme.of(context);
    final spacing = bar.titleSpacing ??
        barTheme.titleSpacing ??
        NavigationToolbar.kMiddleSpacing;

    var leading = 0.0;
    final implied = bar.automaticallyImplyLeading &&
        ((Scaffold.maybeOf(context)?.hasDrawer ?? false) ||
            (ModalRoute.of(context)?.impliesAppBarDismissal ?? false));
    if (bar.leading != null || implied) {
      leading = bar.leadingWidth ?? barTheme.leadingWidth ?? kToolbarHeight;
    }

    final title = bar.title;
    double titleWidth;
    if (title == null) {
      return (overhead: leading, title: 0);
    } else if (titleReserve != null) {
      titleWidth = titleReserve!;
    } else if (title is Text && title.data != null) {
      final base = bar.titleTextStyle ??
          barTheme.titleTextStyle ??
          theme.textTheme.titleLarge ??
          const TextStyle();
      final painter = TextPainter(
        text: TextSpan(text: title.data, style: base.merge(title.style)),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context)
            .clamp(maxScaleFactor: appBarTitleMaxScale),
        maxLines: 1,
      )..layout();
      titleWidth = painter.width;
      painter.dispose();
    } else {
      return null;
    }
    // One logical pixel of slack for rounding.
    return (overhead: leading + spacing * 2 + 1, title: titleWidth);
  }

  @override
  Widget build(BuildContext context) => _OhBarScope(
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: maxScale,
          child: _FoldRow(reserve: _reserve(context), children: children),
        ),
      );
}

class _OhBarScope extends InheritedWidget {
  const _OhBarScope({required super.child});

  @override
  bool updateShouldNotify(_OhBarScope oldWidget) => false;
}

/// A top bar's worded overflow menu: the ruling's home for rare actions.
///
/// A drop-in for `PopupMenuButton<T>` whose face is [icon] plus the word
/// [label] ("More"), folding like [OhBarAction]. A screen reader hears one
/// button named [label].
class OhBarOverflow<T> extends StatefulWidget {
  const OhBarOverflow({
    super.key,
    required this.itemBuilder,
    this.onSelected,
    this.label = 'More',
    this.icon = Icons.more_vert,
    this.enabled = true,
  });

  final PopupMenuItemBuilder<T> itemBuilder;
  final PopupMenuItemSelected<T>? onSelected;
  final String label;
  final IconData icon;
  final bool enabled;

  @override
  State<OhBarOverflow<T>> createState() => _OhBarOverflowState<T>();
}

class _OhBarOverflowState<T> extends State<OhBarOverflow<T>> {
  final _menu = GlobalKey<PopupMenuButtonState<T>>();

  @override
  Widget build(BuildContext context) {
    final ink = OhBarAction.inkOf(context);
    Widget face({required bool worded}) => ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: worded ? 8 : 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: ink),
                if (worded) ...[
                  const SizedBox(width: 8),
                  Text(
                    widget.label,
                    maxLines: 1,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: ink),
                  ),
                ],
              ],
            ),
          ),
        );
    // One name in both modes. Excluding the child's semantics also drops
    // its tap action, so it is handed back here.
    return Semantics(
      container: true,
      button: true,
      enabled: widget.enabled,
      label: widget.label,
      onTap: widget.enabled ? () => _menu.currentState?.showButtonMenu() : null,
      excludeSemantics: true,
      child: PopupMenuButton<T>(
        key: _menu,
        tooltip: widget.label,
        enabled: widget.enabled,
        itemBuilder: widget.itemBuilder,
        onSelected: widget.onSelected,
        child: OhBarFoldable(
          worded: face(worded: true),
          folded: face(worded: false),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Rendering: the pair (two faces, one shown) and the row that picks.

class _FoldPair extends MultiChildRenderObjectWidget {
  const _FoldPair({
    required this.fixedFold,
    required this.onShown,
    required super.children,
  });

  final bool fixedFold;
  final ValueChanged<bool> onShown;

  @override
  MultiChildRenderObjectElement createElement() => _FoldPairElement(this);

  @override
  _RenderFoldPair createRenderObject(BuildContext context) =>
      _RenderFoldPair(fixedFold: fixedFold, onShown: onShown);

  @override
  void updateRenderObject(BuildContext context, _RenderFoldPair renderObject) {
    renderObject
      ..fixedFold = fixedFold
      ..onShown = onShown;
  }
}

/// Only the shown face is "onstage": finders, like people, see one face.
class _FoldPairElement extends MultiChildRenderObjectElement {
  _FoldPairElement(super.widget);

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    final kids = children.toList();
    if (kids.length != 2) return super.debugVisitOnstageChildren(visitor);
    final folded = (renderObject as _RenderFoldPair).folded;
    visitor(folded ? kids[1] : kids[0]);
  }
}

class _FoldData extends ContainerBoxParentData<RenderBox> {}

class _RenderFoldPair extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _FoldData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _FoldData> {
  _RenderFoldPair({required bool fixedFold, required this.onShown})
      : _fixedFold = fixedFold;

  bool _fixedFold;
  set fixedFold(bool value) {
    if (value == _fixedFold) return;
    _fixedFold = value;
    markNeedsLayout();
  }

  ValueChanged<bool> onShown;

  /// Set by an enclosing row; null when no row governs this pair.
  bool? _rowFolded;

  bool get folded => _rowFolded ?? _fixedFold;

  double wordedWidth = 0;
  double foldedWidth = 0;

  RenderBox? get _shown => folded ? lastChild : firstChild;

  /// Called by the row inside a layout callback. Marks every render object
  /// between here and the row dirty, so relaying out the row's child
  /// reaches this pair even through a relayout boundary.
  void setRowFolded(bool? value) {
    if (value == _rowFolded) return;
    _rowFolded = value;
    RenderObject? node = this;
    while (node != null && node is! _RenderFoldRow) {
      node.markNeedsLayout();
      node = node.parent;
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _FoldData) child.parentData = _FoldData();
  }

  @override
  void performLayout() {
    final worded = firstChild, foldedFace = lastChild;
    if (worded == null || foldedFace == null) {
      size = constraints.smallest;
      return;
    }
    worded.layout(constraints, parentUsesSize: true);
    foldedFace.layout(constraints, parentUsesSize: true);
    wordedWidth = worded.size.width;
    foldedWidth = foldedFace.size.width;
    size = constraints.constrain(_shown!.size);
    onShown(folded);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _shown?.getDryLayout(constraints) ?? constraints.smallest;

  @override
  double computeMinIntrinsicWidth(double height) =>
      _shown?.getMinIntrinsicWidth(height) ?? 0;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _shown?.getMaxIntrinsicWidth(height) ?? 0;

  @override
  double computeMinIntrinsicHeight(double width) =>
      _shown?.getMinIntrinsicHeight(width) ?? 0;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _shown?.getMaxIntrinsicHeight(width) ?? 0;

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) =>
      _shown?.getDistanceToActualBaseline(baseline);

  @override
  void paint(PaintingContext context, Offset offset) {
    final shown = _shown;
    if (shown != null) context.paintChild(shown, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final shown = _shown;
    if (shown == null) return false;
    return shown.hitTest(result, position: position);
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    final shown = _shown;
    if (shown != null) visitor(shown);
  }
}

class _FoldRow extends MultiChildRenderObjectWidget {
  const _FoldRow({required this.reserve, required super.children});

  final ({double overhead, double title})? reserve;

  @override
  _RenderFoldRow createRenderObject(BuildContext context) =>
      _RenderFoldRow(reserve: reserve);

  @override
  void updateRenderObject(BuildContext context, _RenderFoldRow renderObject) {
    renderObject.reserve = reserve;
  }
}

class _RenderFoldRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _FoldData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _FoldData> {
  _RenderFoldRow({({double overhead, double title})? reserve})
      : _reserve = reserve;

  ({double overhead, double title})? _reserve;
  set reserve(({double overhead, double title})? value) {
    if (value == _reserve) return;
    _reserve = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _FoldData) child.parentData = _FoldData();
  }

  static void _collect(RenderObject node, List<_RenderFoldPair> out) {
    node.visitChildren((child) {
      if (child is _RenderFoldPair) {
        out.add(child);
      } else if (child is! _RenderFoldRow) {
        _collect(child, out);
      }
    });
  }

  /// The width the bar gives its actions: the nearest ancestor with a
  /// finite width (the AppBar's actions row, laid out loose to the bar).
  double _barWidth() {
    RenderObject? node = parent;
    while (node != null) {
      if (node is RenderBox && node.constraints.maxWidth.isFinite) {
        return node.constraints.maxWidth;
      }
      node = node.parent;
    }
    return double.infinity;
  }

  @override
  void performLayout() {
    final kids = getChildrenAsList();
    final pairs = [for (final k in kids) _pairsOf(k)];
    final childConstraints = BoxConstraints(maxHeight: constraints.maxHeight);

    void setAll(bool? Function(int i) state) {
      invokeLayoutCallback<BoxConstraints>((_) {
        for (var i = 0; i < kids.length; i++) {
          for (final p in pairs[i]) {
            p.setRowFolded(state(i));
          }
        }
      });
    }

    final reserve = _reserve;
    if (reserve == null) {
      // The title cannot be measured: every pair keeps the fixed rule.
      setAll((_) => null);
      for (final k in kids) {
        k.layout(childConstraints, parentUsesSize: true);
      }
    } else {
      final bar = _barWidth();
      // Estimate each child worded and folded from its pairs' two faces,
      // measured in one layout at the current state.
      setAll((i) =>
          pairs[i].isEmpty ? null : (pairs[i].first._rowFolded ?? false));
      for (final k in kids) {
        k.layout(childConstraints, parentUsesSize: true);
      }
      final worded = <double>[], folded = <double>[];
      for (var i = 0; i < kids.length; i++) {
        var w = kids[i].size.width, f = kids[i].size.width;
        for (final p in pairs[i]) {
          final now = p.folded ? p.foldedWidth : p.wordedWidth;
          w += p.wordedWidth - now;
          f += p.foldedWidth - now;
        }
        worded.add(w);
        folded.add(f);
      }
      // Two regimes. If the title can be whole with every command folded,
      // fold (rightmost first) only until it is. If it cannot, it will
      // ellipsize anyway: fold only to keep it a readable floor.
      final allFolded = folded.fold<double>(0, (a, b) => a + b);
      final wholeBudget = bar - reserve.overhead - reserve.title;
      final budget = allFolded <= wholeBudget
          ? wholeBudget
          : bar -
              reserve.overhead -
              (reserve.title < bar * OhBarActions.minTitleShare
                  ? reserve.title
                  : bar * OhBarActions.minTitleShare);
      final fold = List<bool>.filled(kids.length, false);
      var total = worded.fold<double>(0, (a, b) => a + b);
      for (var i = kids.length - 1; i >= 0 && total > budget; i--) {
        if (pairs[i].isEmpty) continue;
        fold[i] = true;
        total += folded[i] - worded[i];
      }
      setAll((i) => fold[i]);
      for (final k in kids) {
        k.layout(childConstraints, parentUsesSize: true);
      }
      // The estimate assumes a face's width adds straight through its
      // wrappers. If it did not, fold further on the real widths.
      double actual() => kids.fold<double>(0, (a, k) => a + k.size.width);
      for (var i = kids.length - 1; i >= 0 && actual() > budget; i--) {
        if (pairs[i].isEmpty || fold[i]) continue;
        fold[i] = true;
        setAll((j) => fold[j]);
        kids[i].layout(childConstraints, parentUsesSize: true);
      }
    }

    var x = 0.0, height = 0.0;
    for (final k in kids) {
      height = height < k.size.height ? k.size.height : height;
    }
    height = constraints.constrainHeight(height);
    for (final k in kids) {
      (k.parentData! as _FoldData).offset =
          Offset(x, (height - k.size.height) / 2);
      x += k.size.width;
    }
    size = constraints.constrain(Size(x, height));
  }

  static List<_RenderFoldPair> _pairsOf(RenderObject child) {
    if (child is _RenderFoldPair) return [child];
    final out = <_RenderFoldPair>[];
    _collect(child, out);
    return out;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    var w = 0.0;
    for (final k in getChildrenAsList()) {
      w += k.getMinIntrinsicWidth(height);
    }
    return w;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    var w = 0.0;
    for (final k in getChildrenAsList()) {
      w += k.getMaxIntrinsicWidth(height);
    }
    return w;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    var h = 0.0;
    for (final k in getChildrenAsList()) {
      final c = k.getMinIntrinsicHeight(double.infinity);
      if (c > h) h = c;
    }
    return h;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    var h = 0.0;
    for (final k in getChildrenAsList()) {
      final c = k.getMaxIntrinsicHeight(double.infinity);
      if (c > h) h = c;
    }
    return h;
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
