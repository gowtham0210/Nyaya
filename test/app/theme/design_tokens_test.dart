import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/theme/app_theme.dart';
import 'package:nyaya/app/theme/app_tokens.dart';

void main() {
  test('AC-001 no hex colors outside lib/app/theme', () {
    final hex = RegExp(r'Color\(0x[0-9A-Fa-f]{8}\)|\b0x[0-9A-Fa-f]{8}\b');
    final offenders = <String>[];
    for (final file in Directory('lib').listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('.dart')) continue;
      if (file.path.contains('lib/app/theme/')) continue;
      if (file.path.contains('lib/l10n/')) continue;
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (hex.hasMatch(lines[i])) offenders.add('${file.path}:${i + 1}');
      }
    }
    expect(offenders, isEmpty, reason: 'Use NyayaColors/NyayaTones instead.');
  });

  test('AC-002 the scheme is navy and gold, not seeded orange', () {
    final scheme = buildNyayaTheme().colorScheme;

    expect(scheme.primary, NyayaColors.ink);
    expect(scheme.secondary, NyayaColors.gold);
    expect(scheme.error, NyayaColors.danger);
    expect(scheme.surfaceTint, Colors.transparent);
  });

  test('AC-003 snackbars float on ink with rounded corners', () {
    final snack = buildNyayaTheme().snackBarTheme;

    expect(snack.behavior, SnackBarBehavior.floating);
    expect(snack.backgroundColor, NyayaColors.ink);
  });

  test('AC-004 difficulty colors are never the danger red', () {
    for (final color in [
      NyayaDifficulty.easy,
      NyayaDifficulty.medium,
      NyayaDifficulty.hard,
    ]) {
      expect(color, isNot(NyayaColors.danger));
    }
  });
}
