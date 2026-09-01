import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhearth_design/openhearth_design.dart';

/// The fleet audit found raw exceptions as the failure state in 15 apps
/// (`Text('Error: $e')`, `'$e'` in a SnackBar). `OhErrorState` is the one
/// shared replacement: a friendly title, a plain sentence, an optional
/// Retry, and the technical error only behind "Details".
void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    Size size = const Size(400, 800),
    double textScale = 1.0,
    ThemeData? theme,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: theme ?? OhTheme.light(),
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: TextScaler.linear(textScale),
          ),
          child: Scaffold(body: child),
        ),
      ),
    );
  }

  final error = StateError('Bad state: row 42 violates UNIQUE(id)');

  group('OhErrorState', () {
    testWidgets('shows the title and the plain sentence', (tester) async {
      await pump(
        tester,
        OhErrorState(
          title: "Couldn't load your list",
          message: 'Check your connection and try again.',
          error: error,
        ),
      );
      expect(find.text("Couldn't load your list"), findsOneWidget);
      expect(find.text('Check your connection and try again.'), findsOneWidget);
    });

    testWidgets('never renders the raw exception until Details is tapped',
        (tester) async {
      await pump(
        tester,
        OhErrorState(
          title: "Couldn't load your list",
          message: 'Check your connection and try again.',
          error: error,
        ),
      );
      expect(find.textContaining('UNIQUE(id)'), findsNothing);
      expect(find.text('Details'), findsOneWidget);

      await tester.tap(find.text('Details'));
      await tester.pumpAndSettle();

      final details = find.byType(SelectableText);
      expect(details, findsOneWidget);
      expect(
        tester.widget<SelectableText>(details).data,
        contains('UNIQUE(id)'),
      );

      // Tapping again hides it.
      await tester.tap(find.text('Hide details'));
      await tester.pumpAndSettle();
      expect(find.byType(SelectableText), findsNothing);
    });

    testWidgets('details text asks for a family that actually exists',
        (tester) async {
      // A family nobody bundles (it once asked for `JetBrains Mono`) does
      // not fail loudly — it silently renders in whatever the engine picks.
      // Hold the details to the bundled faces or the platform monospace the
      // type ladder's `code` style uses.
      await pump(tester, OhErrorState(message: 'Try again.', error: error));
      await tester.tap(find.text('Details'));
      await tester.pumpAndSettle();

      final family = tester
          .widget<SelectableText>(find.byType(SelectableText))
          .style
          ?.fontFamily;
      const available = {
        'monospace',
        'packages/openhearth_design/Lora',
        'packages/openhearth_design/Nunito',
      };
      expect(available, contains(family));
      expect(family, OhTypography.code().fontFamily,
          reason: 'raw error text is code; it reads in the code face');
    });

    testWidgets('offers no Details control when there is no error',
        (tester) async {
      await pump(
        tester,
        const OhErrorState(title: 'Nothing to show', message: 'Try later.'),
      );
      expect(find.text('Details'), findsNothing);
    });

    testWidgets('Retry is absent without a callback and calls it with one',
        (tester) async {
      await pump(
        tester,
        const OhErrorState(title: 'T', message: 'M'),
      );
      expect(find.text('Try again'), findsNothing);

      var retried = 0;
      await pump(
        tester,
        OhErrorState(title: 'T', message: 'M', onRetry: () => retried++),
      );
      expect(find.text('Try again'), findsOneWidget);
      await tester.tap(find.text('Try again'));
      expect(retried, 1);
    });

    testWidgets('Retry is at least 48dp tall', (tester) async {
      await pump(
        tester,
        OhErrorState(title: 'T', message: 'M', onRetry: () {}),
      );
      final size = tester.getSize(find.bySubtype<FilledButton>());
      expect(size.height, greaterThanOrEqualTo(48));
    });

    testWidgets('fromError maps the exception to a plain sentence',
        (tester) async {
      await pump(
        tester,
        OhErrorState.fromError(
          TimeoutException('socket read', const Duration(seconds: 5)),
        ),
      );
      expect(find.text(ohFriendlyErrorMessage(TimeoutException('x'))),
          findsOneWidget);
      expect(find.textContaining('socket read'), findsNothing);
    });

    testWidgets('survives 320dp at 2.0 text scale without overflow',
        (tester) async {
      await pump(
        tester,
        OhErrorState(
          title: "We couldn't open this household's shared shopping list",
          message: 'Something on this device stopped the list from loading. '
              'Your entries are still here; try again in a moment.',
          error: error,
          onRetry: () {},
        ),
        size: const Size(320, 640),
        textScale: 2.0,
      );
      expect(tester.takeException(), isNull);
      // Off-screen at this scale: scroll it in first, or the tap lands on
      // whatever owns that coordinate and the test tests nothing.
      await tester.ensureVisible(find.text('Details'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Details'));
      await tester.pumpAndSettle();
      expect(find.byType(SelectableText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    for (final entry in <String, ThemeData Function()>{
      'light': OhTheme.light,
      'hearthDark': OhTheme.hearthDark,
      'night': OhTheme.night,
    }.entries) {
      testWidgets('renders under OhTheme.${entry.key}()', (tester) async {
        await pump(
          tester,
          OhErrorState(title: 'T', message: 'M', error: error, onRetry: () {}),
          theme: entry.value(),
        );
        expect(tester.takeException(), isNull);
        // OhTheme's ambient iconTheme is primary, the Retry fill colour; the
        // glyph must not vanish into its own button (see OhIconButton).
        final ctx = tester.element(find.byIcon(Icons.refresh));
        expect(IconTheme.of(ctx).color, entry.value().colorScheme.onPrimary);
      });
    }
  });

  group('ohFriendlyErrorMessage', () {
    test('timeouts', () {
      expect(ohFriendlyErrorMessage(TimeoutException('x')),
          contains('took too long'));
    });

    test('network failures', () {
      expect(ohFriendlyErrorMessage(const SocketException('refused')),
          contains("Couldn't reach"));
      expect(ohFriendlyErrorMessage(const HttpException('503')),
          contains("Couldn't reach"));
    });

    test('file failures', () {
      expect(ohFriendlyErrorMessage(const FileSystemException('nope', '/x')),
          contains('file'));
      expect(ohFriendlyErrorMessage(const PathNotFoundException('/x', OSError())),
          contains('file'));
    });

    test('malformed data', () {
      expect(ohFriendlyErrorMessage(const FormatException('bad json')),
          contains("couldn't be read"));
    });

    test('anything else gets a generic sentence, never the exception text',
        () {
      final msg = ohFriendlyErrorMessage(StateError('secret internals'));
      expect(msg, isNot(contains('secret internals')));
      expect(msg, isNotEmpty);
    });
  });
}
