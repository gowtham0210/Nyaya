import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_tokens.dart';
import 'app_typography.dart';

/// Brand color scheme (spec 036): navy primary, gold secondary. Set by hand
/// so Material defaults (focus rings, progress, snackbars) use the brand.
const nyayaColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: NyayaColors.ink,
  onPrimary: Colors.white,
  primaryContainer: NyayaColors.inkTint,
  onPrimaryContainer: NyayaColors.ink,
  secondary: NyayaColors.gold,
  onSecondary: NyayaColors.ink,
  secondaryContainer: NyayaColors.goldTint,
  onSecondaryContainer: NyayaColors.ink,
  tertiary: NyayaColors.goldDeep,
  onTertiary: Colors.white,
  error: NyayaColors.danger,
  onError: Colors.white,
  errorContainer: NyayaColors.dangerTint,
  onErrorContainer: NyayaColors.danger,
  surface: NyayaColors.surface,
  onSurface: NyayaColors.ink,
  onSurfaceVariant: NyayaColors.inkMuted,
  surfaceContainerLowest: NyayaColors.surface,
  surfaceContainerLow: NyayaColors.surfaceWarm,
  surfaceContainer: NyayaColors.ivory,
  surfaceContainerHigh: NyayaColors.goldWash,
  surfaceContainerHighest: NyayaColors.goldTint,
  outline: NyayaColors.inkDisabled,
  outlineVariant: NyayaColors.hairline,
  shadow: NyayaColors.shadow,
  scrim: NyayaColors.inkDeep,
  inverseSurface: NyayaColors.ink,
  onInverseSurface: Colors.white,
  inversePrimary: NyayaColors.goldBright,
  surfaceTint: Colors.transparent,
);

ThemeData buildNyayaTheme() {
  final text = buildNyayaTextTheme();
  return ThemeData(
    colorScheme: nyayaColorScheme,
    useMaterial3: true,
    fontFamily: NyayaFonts.body,
    textTheme: text,
    scaffoldBackgroundColor: NyayaColors.ivory,
    // One transition per platform for every route (spec 039).
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
      },
    ),
    dividerColor: NyayaColors.hairline,
    appBarTheme: AppBarTheme(
      backgroundColor: NyayaColors.ivory,
      foregroundColor: NyayaColors.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: text.titleMedium,
    ),
    cardTheme: CardThemeData(
      color: NyayaColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NyayaRadii.md),
        side: const BorderSide(color: NyayaColors.hairline),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: NyayaColors.ink,
      contentTextStyle: text.bodyMedium?.copyWith(color: Colors.white),
      actionTextColor: NyayaColors.goldBright,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NyayaRadii.sm),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: NyayaColors.gold,
      linearTrackColor: NyayaColors.track,
      circularTrackColor: NyayaColors.track,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(NyayaRadii.sm),
        borderSide: const BorderSide(color: NyayaColors.gold, width: 1.5),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: NyayaColors.ink,
      selectionHandleColor: NyayaColors.gold,
    ),
  );
}
