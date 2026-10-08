import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_tokens.dart';

/// Bundled brand font families (spec 034). Scripts these fonts don't cover
/// (Devanagari, Tamil, Telugu, Kannada) fall back to the platform's fonts.
abstract final class NyayaFonts {
  /// Serif for display headings, scores and section titles.
  static const display = 'CormorantGaramond';

  /// Sans for body text, labels and controls.
  static const body = 'Inter';
}

/// Default text color, also used by the shared widgets.
const nyayaInk = NyayaColors.ink;

/// The app's type scale. Display and headline styles use the serif; title,
/// body and label styles use the sans. Body text has no extra tracking —
/// Material 3's defaults were tuned for Roboto and look loose in Inter.
TextTheme buildNyayaTextTheme() {
  TextStyle serif(double size, double height) => TextStyle(
    fontFamily: NyayaFonts.display,
    fontSize: size,
    height: height,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: nyayaInk,
  );

  TextStyle sans(
    double size,
    double height,
    FontWeight weight, {
    double letterSpacing = 0,
  }) => TextStyle(
    fontFamily: NyayaFonts.body,
    fontSize: size,
    height: height,
    fontWeight: weight,
    letterSpacing: letterSpacing,
    color: nyayaInk,
  );

  return TextTheme(
    displayLarge: serif(60, 1.05),
    displayMedium: serif(52, 1.05),
    displaySmall: serif(40, 1.1),
    headlineLarge: serif(34, 1.12),
    headlineMedium: serif(30, 1.15),
    headlineSmall: serif(26, 1.2),
    titleLarge: sans(20, 1.3, FontWeight.w700),
    titleMedium: sans(17, 1.4, FontWeight.w600),
    titleSmall: sans(15, 1.35, FontWeight.w600),
    bodyLarge: sans(16, 1.5, FontWeight.w400),
    bodyMedium: sans(14, 1.45, FontWeight.w400),
    bodySmall: sans(12, 1.35, FontWeight.w400),
    labelLarge: sans(15, 1.3, FontWeight.w600),
    labelMedium: sans(13, 1.3, FontWeight.w600),
    labelSmall: sans(11, 1.3, FontWeight.w600, letterSpacing: 0.6),
  );
}

/// Adds the bundled fonts' OFL licenses to the app's license page, as the
/// license requires when the fonts ship with the app.
void registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final font in const ['CormorantGaramond', 'Inter']) {
      final text = await rootBundle.loadString('assets/fonts/OFL-$font.txt');
      yield LicenseEntryWithLineBreaks([font], text);
    }
  });
}
