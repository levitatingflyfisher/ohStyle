import 'dart:async';

import 'package:flutter/material.dart';

import 'spacing.dart';

// The fleet's delete policy (operator ruling, 2026-09-26):
//
// * An EASY gesture that deletes (a swipe, a long-press shortcut) asks first,
//   with showOhConfirm, because it is easy to do by accident.
// * A DELIBERATE delete (a Delete button, a menu item the person chose) does
//   not ask. It happens at once and offers Undo through OhUndoBar, and that
//   Undo never expires on a timer.
//
// Both sit on the app's soft delete. See the README section "Delete policy"
// for the contract an app must implement.

/// Confirm labels that do not name the act. "OK" answers nothing; a bare
/// "Delete" leaves the person to re-read the title to learn what goes.
const _genericLabels = {'ok', 'yes', 'confirm', 'continue', 'sure', 'delete'};

/// Asks before an easy-gesture delete (or any other act worth a pause).
///
/// Returns `true` only when the person taps the confirm button; Cancel, the
/// barrier and the back gesture all return `false`.
///
/// [confirmLabel] must name the act ("Delete 3 items", "Clear list"), so the
/// button answers the title on its own. The button is neutral unless
/// [destructive] is true, which paints it in `colorScheme.error` (or
/// [confirmColor], for apps whose palette law forbids red) and adds the
/// urgency icon, so the danger never rests on colour alone.
///
/// Parameter names match the five `showConfirmDialog` copies it replaces
/// (`title`, `message`, `confirmLabel`, `confirmColor`), but `confirmLabel`
/// no longer defaults to "Delete" and danger styling is now opt-in.
Future<bool> showOhConfirm(
  BuildContext context, {
  required String title,
  String? message,
  required String confirmLabel,
  bool destructive = false,
  String cancelLabel = 'Cancel',
  Color? confirmColor,
}) {
  // Not `async`: the assert must throw at the call site, not vanish into
  // the returned Future.
  assert(
    !_genericLabels.contains(confirmLabel.trim().toLowerCase()),
    'showOhConfirm: confirmLabel "$confirmLabel" does not name the act. '
    'Use a verb and its object, e.g. "Delete 3 items".',
  );
  return showDialog<bool>(
    context: context,
    builder: (ctx) {
      final scheme = Theme.of(ctx).colorScheme;
      final background =
          confirmColor ?? (destructive ? scheme.error : scheme.primary);
      final foreground = confirmColor == null
          ? (destructive ? scheme.onError : scheme.onPrimary)
          : (ThemeData.estimateBrightnessForColor(confirmColor) ==
                  Brightness.dark
              ? Colors.white
              : Colors.black);
      final style = FilledButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        minimumSize: const Size(48, 48),
      );
      return AlertDialog(
        title: Text(title),
        content: message == null ? null : Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            child: Text(cancelLabel),
          ),
          // Urgency is hue + icon + word (style guide §2.3): the octagon
          // keeps a destructive confirm legible as danger without colour.
          if (destructive)
            FilledButton.icon(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: style,
              icon: const Icon(Icons.report_outlined),
              label: Text(confirmLabel),
            )
          else
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: style,
              child: Text(confirmLabel),
            ),
        ],
      );
    },
  ).then((result) => result ?? false);
}

/// One pending, undoable delete.
@immutable
class OhUndoEntry {
  const OhUndoEntry({
    required this.message,
    required this.onUndo,
    this.onCommit,
    this.undoLabel = 'Undo',
  });

  /// What just happened, e.g. `Deleted "Soup"` or `Deleted 3 items`.
  final String message;

  /// Restores the soft-deleted rows (clears `deletedAt`).
  final Future<void> Function() onUndo;

  /// Runs when the offer lapses because the person moved on: they dismissed
  /// the bar, deleted something else, or left the screen. With a soft delete
  /// this is usually nothing at all; the rows stay in Recently deleted.
  final Future<void> Function()? onCommit;

  final String undoLabel;
}

/// Holds at most one pending [OhUndoEntry] for an [OhUndoBar].
///
/// There is no timer anywhere in this class. An offer ends only when the
/// person acts: [undo], [dismiss], a newer [show] (which commits the older
/// entry), or the bar leaving the screen.
class OhUndoController extends ChangeNotifier {
  OhUndoEntry? _pending;

  OhUndoEntry? get pending => _pending;

  /// Offers Undo for a delete that has already happened (soft-deleted).
  /// Any earlier pending offer is committed first.
  void show({
    required String message,
    required Future<void> Function() onUndo,
    Future<void> Function()? onCommit,
    String undoLabel = 'Undo',
  }) {
    final previous = _pending;
    _pending = OhUndoEntry(
      message: message,
      onUndo: onUndo,
      onCommit: onCommit,
      undoLabel: undoLabel,
    );
    if (previous?.onCommit != null) unawaited(previous!.onCommit!());
    notifyListeners();
  }

  /// Restores the pending delete and clears the offer.
  Future<void> undo() async {
    final entry = _pending;
    if (entry == null) return;
    _pending = null;
    notifyListeners();
    await entry.onUndo();
  }

  /// Ends the offer without restoring; runs the entry's `onCommit`.
  Future<void> dismiss() => _commit(notify: true);

  Future<void> _commit({required bool notify}) async {
    final entry = _pending;
    if (entry == null) return;
    _pending = null;
    if (notify) notifyListeners();
    await entry.onCommit?.call();
  }
}

/// A persistent Undo bar for deliberate deletes.
///
/// Place it where the screen's bottom edge is (e.g. `Scaffold.bottomSheet`
/// or the bottom of a `Column`). It is empty until [OhUndoController.show]
/// is called and then stays until the person taps Undo, taps the close
/// button, deletes something else, or leaves the screen. It never times out:
/// an Undo that vanishes while you are still reading it strands you.
class OhUndoBar extends StatefulWidget {
  const OhUndoBar({
    super.key,
    required this.controller,
    this.commitOnDispose = true,
  });

  final OhUndoController controller;

  /// When the bar leaves the tree (the person navigated on), commit the
  /// pending entry. Turn off only if the controller outlives the screen and
  /// another bar will keep showing the same offer.
  final bool commitOnDispose;

  @override
  State<OhUndoBar> createState() => _OhUndoBarState();
}

class _OhUndoBarState extends State<OhUndoBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_changed);
  }

  @override
  void didUpdateWidget(OhUndoBar old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_changed);
      widget.controller.addListener(_changed);
    }
  }

  @override
  void dispose() {
    // Stop listening first, so committing cannot notify a disposed state.
    widget.controller.removeListener(_changed);
    if (widget.commitOnDispose) {
      unawaited(widget.controller._commit(notify: false));
    }
    super.dispose();
  }

  void _changed() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final entry = widget.controller.pending;
    if (entry == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Semantics(
      liveRegion: true,
      container: true,
      child: Material(
        color: scheme.inverseSurface,
        elevation: 3,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                OhSpacing.md, OhSpacing.xs, OhSpacing.xs, OhSpacing.xs),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    entry.message,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: scheme.onInverseSurface),
                  ),
                ),
                TextButton(
                  onPressed: widget.controller.undo,
                  style: TextButton.styleFrom(
                    foregroundColor: scheme.inversePrimary,
                    minimumSize: const Size(64, 48),
                  ),
                  child: Text(entry.undoLabel),
                ),
                IconButton(
                  onPressed: widget.controller.dismiss,
                  tooltip: 'Dismiss',
                  color: scheme.onInverseSurface,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
