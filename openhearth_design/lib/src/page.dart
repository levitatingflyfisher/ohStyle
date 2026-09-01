import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'spacing.dart';

/// The centred live area for a screen's body.
///
/// Phone-shaped apps stretched edge to edge on a tablet or a 1024 px browser
/// window read as broken: lines too long to track, controls stranded at the
/// far edges. `OhPage` caps the content at [maxWidth], centres it, keeps it
/// top-aligned, applies the safe area (notches, cut-outs, gesture bar) and a
/// side gutter.
///
/// Use it as the `body:` of a `Scaffold`, around the screen's list or column:
///
/// ```dart
/// Scaffold(
///   appBar: AppBar(title: const Text('Pantry')),
///   body: OhPage(child: ListView(children: rows)),
/// )
/// ```
///
/// Backgrounds, app bars and bottom bars stay full width; only the content
/// is capped.
///
/// On a desktop or browser window the margins beside the live area still
/// scroll it: a mouse wheel over the margin is forwarded to the first
/// vertical scrollable inside [child]. Over the content itself the child's
/// own scrollable claims the wheel first, so nothing scrolls twice.
/// (Trackpad pan gestures over the margin are not forwarded.)
class OhPage extends StatefulWidget {
  const OhPage({
    super.key,
    required this.child,
    this.maxWidth = phoneMaxWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: OhSpacing.md),
    this.safeArea = true,
  });

  /// Default cap for phone-shaped screens (lists, forms, trackers).
  static const double phoneMaxWidth = 640;

  /// Cap for reading and prose pages (style guide §4.3, standard page).
  static const double proseMaxWidth = 720;

  /// Cap for wide content such as charts (style guide §4.3).
  static const double wideMaxWidth = 960;

  final Widget child;
  final double maxWidth;

  /// Inside the capped column. Defaults to the 16dp side gutter.
  final EdgeInsetsGeometry padding;

  /// Wrap in a [SafeArea]. Turn off when an enclosing widget already does.
  final bool safeArea;

  @override
  State<OhPage> createState() => _OhPageState();
}

class _OhPageState extends State<OhPage> {
  final _contentKey = GlobalKey();

  /// The first vertical [ScrollableState] under the content, outermost
  /// first. A `ListView` on desktop does not attach to the
  /// `PrimaryScrollController`, so it is found by walking the tree.
  ScrollableState? _findScrollable() {
    ScrollableState? found;
    void visit(Element e) {
      if (found != null) return;
      if (e is StatefulElement &&
          e.state is ScrollableState &&
          axisDirectionToAxis((e.state as ScrollableState).axisDirection) ==
              Axis.vertical) {
        found = e.state as ScrollableState;
        return;
      }
      e.visitChildElements(visit);
    }

    final root = _contentKey.currentContext as Element?;
    root?.visitChildElements(visit);
    return found;
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    // Registered after any scrollable under the pointer (hit-testing runs
    // innermost first, and the resolver keeps the first registration), so
    // this only runs when the wheel is over the margin.
    GestureBinding.instance.pointerSignalResolver.register(event, (e) {
      final state = _findScrollable();
      if (state == null) return;
      final position = state.position;
      // The same two checks Scrollable makes for a wheel over itself: a
      // list whose physics refuse user offsets stays put, and a reversed
      // axis flips the delta so the margin moves it the way the content
      // would.
      if (!position.physics.shouldAcceptUserOffset(position)) return;
      var dy = (e as PointerScrollEvent).scrollDelta.dy;
      if (axisDirectionIsReversed(state.axisDirection)) dy = -dy;
      if (dy == 0) return;
      position.pointerScroll(dy);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        key: _contentKey,
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
        child: Padding(padding: widget.padding, child: widget.child),
      ),
    );
    if (widget.safeArea) content = SafeArea(child: content);
    // Translucent: the margins are empty space, and an opaque-by-default
    // hit test would find nothing there to deliver the wheel to.
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerSignal: _onPointerSignal,
      child: content,
    );
  }
}
