import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// The NYAYA design language: Playfair Display for editorial headlines
/// (hero banners, screen titles) paired with Inter for everything else
/// (body copy, labels, buttons) — a classic serif/sans pairing that reads
/// as a legal-editorial product rather than a generic app template.
class AppTheme {
  AppTheme._();

  static TextTheme get _textTheme {
    final inter = GoogleFonts.interTextTheme();
    final playfair = GoogleFonts.playfairDisplayTextTheme();
    return inter.copyWith(
      displayLarge: playfair.displayLarge?.copyWith(fontWeight: FontWeight.w800, color: AppColors.navy),
      displayMedium: playfair.displayMedium?.copyWith(fontWeight: FontWeight.w800, color: AppColors.navy),
      displaySmall: playfair.displaySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.navy),
      headlineLarge: playfair.headlineLarge?.copyWith(fontWeight: FontWeight.w800, color: AppColors.navy),
      headlineMedium: playfair.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.navy),
      headlineSmall: playfair.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.navy),
      titleLarge: inter.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: AppColors.navy),
      titleMedium: inter.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.navy),
      titleSmall: inter.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.navy),
      bodyLarge: inter.bodyLarge?.copyWith(color: AppColors.textPrimary),
      bodyMedium: inter.bodyMedium?.copyWith(color: AppColors.textPrimary),
      bodySmall: inter.bodySmall?.copyWith(color: AppColors.textSecondary),
      labelLarge: inter.labelLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.2),
      labelMedium: inter.labelMedium?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.2),
      labelSmall: inter.labelSmall?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.2),
    );
  }

  static final _radius = BorderRadius.circular(14);

  static ThemeData get light {
    final textTheme = _textTheme;

    final elevatedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppColors.navy,
      foregroundColor: Colors.white,
      disabledBackgroundColor: AppColors.navy.withValues(alpha: 0.4),
      disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
      minimumSize: const Size(64, 50),
      shape: RoundedRectangleBorder(borderRadius: _radius),
      elevation: 2,
      shadowColor: AppColors.navy.withValues(alpha: 0.28),
      textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.2),
    ).copyWith(
      overlayColor: WidgetStatePropertyAll(AppColors.gold.withValues(alpha: 0.14)),
    );

    final outlinedButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: AppColors.navy,
      backgroundColor: AppColors.cardBackground,
      side: const BorderSide(color: AppColors.beigeBorder, width: 1.3),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
      minimumSize: const Size(64, 50),
      shape: RoundedRectangleBorder(borderRadius: _radius),
      textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.2),
    ).copyWith(
      overlayColor: WidgetStatePropertyAll(AppColors.navy.withValues(alpha: 0.06)),
    );

    final textButtonStyle = TextButton.styleFrom(
      foregroundColor: AppColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700),
    ).copyWith(
      overlayColor: WidgetStatePropertyAll(AppColors.gold.withValues(alpha: 0.12)),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navy,
        primary: AppColors.navy,
        secondary: AppColors.gold,
        surface: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      splashFactory: InkRipple.splashFactory,
    );

    return base.copyWith(
      textTheme: textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(style: outlinedButtonStyle),
      textButtonTheme: TextButtonThemeData(style: textButtonStyle),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.navy,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy),
        iconTheme: const IconThemeData(color: AppColors.navy),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 3,
        shadowColor: AppColors.navy.withValues(alpha: 0.10),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.beigeBorder)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.inter(fontSize: 13.5, color: AppColors.muted),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.beigeBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.beigeBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.gold, width: 1.6)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.goldDark, width: 1.3)),
      ),
      dividerColor: AppColors.beigeBorder,
      dividerTheme: const DividerThemeData(color: AppColors.beigeBorder, thickness: 1, space: 1),
      iconTheme: const IconThemeData(color: AppColors.navy),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.gold),
      visualDensity: VisualDensity.standard,
    );
  }
}
