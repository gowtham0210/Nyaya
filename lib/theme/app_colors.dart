import 'package:flutter/material.dart';

/// Central color palette for the NYAYA app.
/// Built from exactly two brand colors — navy (0xFF142440) and
/// gold (0xFFDBA251) — plus pure white/black neutrals for legibility.
/// Every other shade here is a tint or shade of one of those two.
class AppColors {
  AppColors._();

  static const Color navy = Color(0xFF142440);
  static const Color navyDark = Color(0xFF0F1B30);
  static const Color navySecondary = Color(0xFF667183);
  static const Color navyMuted = Color(0xFFA1A7B3);
  static const Color navyTint = Color(0xFFECEDF0);

  static const Color gold = Color(0xFFDBA251);
  static const Color goldDark = Color(0xFFB9823A);
  static const Color goldLight = Color(0xFFEBCC9F);

  static const Color background = Color(0xFFF4F5F7);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color beigeBorder = Color(0xFFFBF4EA);

  static const Color textPrimary = navy;
  static const Color textSecondary = navySecondary;
  static const Color muted = navyMuted;

  static const Color soonRed = goldDark;
  static const Color soonRedBg = goldLight;
}
