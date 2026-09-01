import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/all_styles.dart';

/// Every TextStyle this package hands out must name a (family, weight,
/// style) that a real font file supplies.
///
/// Asking for a weight no file carries does not fail loudly: Flutter picks
/// the nearest face (Lora w600 renders as w700 or w500, depending on the
/// engine), or synthesises a fake bold or italic. The audit found w600 and
/// w300 requested and no Lora file for either anywhere in the fleet.
///
/// The truth here is the files in `fonts/` — the canonical set apps copy —
/// read from their own OS/2 tables (`usWeightClass`, the `fsSelection`
/// italic bit), not a Dart list that would only test itself. Platform
/// generic families (`monospace`) are exempt because no app bundles them.
typedef _Face = (String family, int weight, bool italic);

_Face _readFace(File f) {
  final b = ByteData.sublistView(f.readAsBytesSync());
  final numTables = b.getUint16(4);
  for (var i = 0; i < numTables; i++) {
    final rec = 12 + i * 16;
    final tag = String.fromCharCodes(
        [for (var k = 0; k < 4; k++) b.getUint8(rec + k)]);
    if (tag != 'OS/2') continue;
    final off = b.getUint32(rec + 8);
    final weight = b.getUint16(off + 4);
    final fsSelection = b.getUint16(off + 62);
    final family = f.uri.pathSegments.last.split('-').first;
    return (family, weight, fsSelection & 1 == 1);
  }
  throw StateError('${f.path} has no OS/2 table');
}

const _platformGenerics = {'monospace'};

void main() {
  final dir = Directory('fonts');
  final files =
      dir.listSync().whereType<File>().where((f) => f.path.endsWith('.ttf'));
  final faces = {for (final f in files) _readFace(f)};

  test('the canonical font set is on disk with its licence', () {
    // Cannot pass by finding nothing.
    expect(faces.length, greaterThanOrEqualTo(8));
    expect(File('fonts/OFL.txt').existsSync(), isTrue);
    expect(faces, contains(('Lora', 700, false)));
    expect(faces, contains(('Nunito', 400, false)));
  });

  test('pubspec declares every canonical face with its true weight/style', () {
    // Declaring the files as package fonts adds a new silent failure: a
    // `weight:` line that disagrees with the file makes Flutter serve the
    // wrong face for that weight. Hold each declaration to the file's own
    // OS/2 table, and require every canonical file to be declared.
    final declared = _declaredFaces(File('pubspec.yaml'));
    expect(declared, isNotEmpty, reason: 'no flutter: fonts: block');
    final byAsset = {
      for (final f in files) 'fonts/${f.uri.pathSegments.last}': _readFace(f)
    };
    expect(declared.keys.toSet(), byAsset.keys.toSet(),
        reason: 'declared assets must be exactly the canonical files');
    for (final MapEntry(key: asset, value: face) in declared.entries) {
      expect(face, byAsset[asset], reason: '$asset is declared as $face');
    }
  });

  final styles = allOhTextStyles();

  for (final MapEntry(key: name, value: s) in styles.entries) {
    test('$name requests a face a bundled file supplies', () {
      expect(s, isNotNull, reason: '$name is not set');
      final family = s!.fontFamily;
      expect(family, isNotNull, reason: '$name names no family');
      if (_platformGenerics.contains(family)) return;
      // Package styles name `packages/openhearth_design/<Family>`; the
      // file on disk is named by the bare family.
      const prefix = 'packages/openhearth_design/';
      expect(family!.startsWith(prefix), isTrue,
          reason: '$name names $family, not a package font — an app '
              'without its own copy would render the platform font');
      final face = (
        family.substring(prefix.length),
        (s.fontWeight ?? FontWeight.w400).value,
        s.fontStyle == FontStyle.italic,
      );
      expect(faces, contains(face),
          reason: '$name asks for $face; bundled faces are $faces');
    });
  }
}

/// asset path → (family, weight, italic) as `pubspec.yaml` declares it.
/// A deliberately small reader for the one `flutter: fonts:` shape we write.
Map<String, _Face> _declaredFaces(File pubspec) {
  final out = <String, _Face>{};
  String? family;
  String? asset;
  var weight = 400;
  var italic = false;
  var inFonts = false;
  void flush() {
    final (f, a) = (family, asset);
    if (f != null && a != null) out[a] = (f, weight, italic);
    asset = null;
    weight = 400;
    italic = false;
  }

  for (final line in pubspec.readAsLinesSync()) {
    if (line.trim().isEmpty || line.trimLeft().startsWith('#')) continue;
    if (line == '  fonts:') {
      inFonts = true;
      continue;
    }
    if (!inFonts) continue;
    if (!line.startsWith('  ')) break;
    final t = line.trim();
    if (t.startsWith('- family:')) {
      flush();
      family = t.substring('- family:'.length).trim();
    } else if (t.startsWith('- asset:')) {
      flush();
      asset = t.substring('- asset:'.length).trim();
    } else if (t.startsWith('weight:')) {
      weight = int.parse(t.substring('weight:'.length).trim());
    } else if (t.startsWith('style:')) {
      italic = t.substring('style:'.length).trim() == 'italic';
    }
  }
  flush();
  return out;
}
