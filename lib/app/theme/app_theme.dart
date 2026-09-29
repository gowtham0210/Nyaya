import 'package:flutter/material.dart';

ThemeData buildNyayaTheme() {
  const seedColor = Color(0xFFD66A33);
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF7F0E7),
    cardTheme: CardThemeData(
      color: Colors.white.withValues(alpha: 0.86),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
  );
}
