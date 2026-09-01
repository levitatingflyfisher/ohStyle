import 'dart:convert';

import 'package:flutter/services.dart';

/// Registers this package's declared fonts under the names a CONSUMING app
/// sees them by: `packages/openhearth_design/<Family>`.
///
/// When ohStyle's own tests run, ohStyle is the root package, so Flutter's
/// FontManifest lists its fonts unprefixed (`Lora`, asset `fonts/...`). In
/// an app that depends on it, the same manifest entries arrive prefixed
/// (`packages/openhearth_design/Lora`, asset
/// `packages/openhearth_design/fonts/...`), and the fleet's canonical
/// `flutter_test_config.dart` loads each one under that name. This helper
/// reproduces the consumer's registration from the manifest itself, so a
/// style that resolves here resolves in an app.
Future<void> loadPackageFontsAsConsumerSees() async {
  final manifest = json.decode(await rootBundle.loadString('FontManifest.json'))
      as List<dynamic>;
  for (final entry in manifest.cast<Map<String, dynamic>>()) {
    final family = entry['family'] as String;
    if (family.startsWith('packages/') || family == 'MaterialIcons') continue;
    final loader = FontLoader('packages/openhearth_design/$family');
    for (final f in (entry['fonts'] as List).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(f['asset'] as String));
    }
    await loader.load();
  }
}
