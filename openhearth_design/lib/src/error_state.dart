import 'dart:async';

import 'package:flutter/material.dart';

import 'errors/io_errors_stub.dart'
    if (dart.library.io) 'errors/io_errors_io.dart';
import 'errors/messages.dart';
import 'spacing.dart';
import 'typography.dart';

export 'errors/messages.dart';

/// Maps a caught exception to one plain sentence a person can act on.
///
/// Never returns the exception's own text: that belongs behind "Details"
/// (see [OhErrorState]) or in a log, not on the glass. Unknown errors get
/// [OhErrorMessages.generic].
String ohFriendlyErrorMessage(Object error) {
  if (error is TimeoutException) return OhErrorMessages.timeout;
  if (error is FormatException) return OhErrorMessages.format;
  return ohIoErrorMessage(error) ?? OhErrorMessages.generic;
}

/// The fleet's one failure state: a friendly [title], a plain [message], an
/// optional Retry, and the technical [error] revealed only when the person
/// asks for "Details".
///
/// Replaces `Text('Error: $e')` and friends. The raw exception is never the
/// main text; it sits behind Details as selectable text so it can be copied
/// into a bug report.
///
/// ```dart
/// error: (e, st) => OhErrorState.fromError(e, stackTrace: st,
///     title: "Couldn't load your pantry", onRetry: () => ref.invalidate(p)),
/// ```
class OhErrorState extends StatefulWidget {
  const OhErrorState({
    super.key,
    this.title = OhErrorState.defaultTitle,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Try again',
    this.error,
    this.stackTrace,
    this.icon = Icons.cloud_off_outlined,
  });

  /// Builds the state from a caught exception, using
  /// [ohFriendlyErrorMessage] for the sentence unless [message] is given.
  OhErrorState.fromError(
    Object this.error, {
    super.key,
    this.stackTrace,
    this.title = OhErrorState.defaultTitle,
    String? message,
    this.onRetry,
    this.retryLabel = 'Try again',
    this.icon = Icons.cloud_off_outlined,
  }) : message = message ?? ohFriendlyErrorMessage(error);

  static const defaultTitle = "That didn't work";

  /// Short and human: what did not happen, e.g. "Couldn't load your list".
  final String title;

  /// One plain sentence: what happened and what to do next.
  final String message;

  /// Shows a Retry button when non-null.
  final VoidCallback? onRetry;
  final String retryLabel;

  /// The technical error, shown only behind Details. Null hides Details.
  final Object? error;
  final StackTrace? stackTrace;

  final IconData icon;

  @override
  State<OhErrorState> createState() => _OhErrorStateState();
}

class _OhErrorStateState extends State<OhErrorState> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final error = widget.error;

    return Center(
      child: SingleChildScrollView(
        padding: OhSpacing.insetLg,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(widget.icon, size: 48, color: scheme.onSurfaceVariant),
              const SizedBox(height: OhSpacing.md),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: OhSpacing.sm),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: scheme.onSurface),
              ),
              if (widget.onRetry != null) ...[
                const SizedBox(height: OhSpacing.lg),
                Center(
                  child: FilledButton.icon(
                    onPressed: widget.onRetry,
                    icon: const Icon(Icons.refresh),
                    label: Text(widget.retryLabel),
                    style: FilledButton.styleFrom(
                      foregroundColor: scheme.onPrimary,
                      iconColor: scheme.onPrimary,
                      minimumSize: const Size(48, 48),
                    ),
                  ),
                ),
              ],
              if (error != null) ...[
                const SizedBox(height: OhSpacing.sm),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        setState(() => _showDetails = !_showDetails),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 48),
                    ),
                    child: Text(_showDetails ? 'Hide details' : 'Details'),
                  ),
                ),
                if (_showDetails)
                  Container(
                    padding: OhSpacing.insetMd,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      [
                        '$error',
                        if (widget.stackTrace != null) '${widget.stackTrace}',
                      ].join('\n\n'),
                      // The ladder's code face (monospace; Nunito on web). Not
                      // bodySmall.copyWith(fontFamily:): a themed style
                      // carries package: 'openhearth_design', so copyWith
                      // would prefix the family into one nobody bundles.
                      style: OhTypography.code(color: scheme.onSurface),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
