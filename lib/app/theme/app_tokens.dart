import 'package:flutter/material.dart';

/// Brand colors (spec 036). The only place hex colors live; everything else
/// refers to these names.
abstract final class NyayaColors {
  // Ink: text and dark surfaces.
  static const ink = Color(0xFF11233B);
  static const inkDeep = Color(0xFF0E1C30);
  static const inkMuted = Color(0xFF5E6878);
  static const inkSubtle = Color(0xFF8B95A5);
  static const inkDisabled = Color(0xFFBFC5CE);
  static const inkTint = Color(0xFFE9EDF3);

  // Gold: brand accent.
  static const gold = Color(0xFFC89B3C);
  static const goldBright = Color(0xFFD3A247);
  static const goldDeep = Color(0xFFA97F2A);
  static const goldTint = Color(0xFFF3E9D7);
  static const goldWash = Color(0xFFFBF5EA);

  // Surfaces and lines.
  static const ivory = Color(0xFFFBF7F1);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceWarm = Color(0xFFFFFDF9);
  static const hairline = Color(0xFFECE5DB);

  // Decoration.
  static const ornament = Color(0xFFE8D4B8);
  static const wave = Color(0xFFF1E5D7);
  static const track = Color(0xFFE9DED0);

  // Meaning: only for right/wrong and errors, never for categories or
  // difficulty.
  static const success = Color(0xFF1F8F55);
  static const successTint = Color(0xFFE9F7EF);
  static const danger = Color(0xFFC2412F);
  static const dangerTint = Color(0xFFFDEEEE);
  static const info = Color(0xFF2B4468);

  /// Shadow ink, and preset alphas of it.
  static const shadow = Color(0xFF11233B);
  static const shadowSoft = Color(0x0F11233B);
  static const shadowMid = Color(0x1411233B);
  static const shadowStrong = Color(0x2211233B);

  /// White at low and high alpha, for text and lines on dark cards.
  static const onDarkFaint = Color(0x33FFFFFF);
  static const onDarkMuted = Color(0xCCFFFFFF);

  /// A raised navy, between [ink] and [inkDeep], for gradients.
  static const inkRaised = Color(0xFF172A45);
}

/// A muted brand tone: a light [tint] behind a darker [ink].
typedef NyayaTone = ({Color tint, Color ink});

/// Tonal palette for categories, update types and avatars, in place of
/// rainbow pastels. All tones sit with navy and gold.
abstract final class NyayaTones {
  static const navyTint = Color(0xFFE9EDF3);
  static const navyInk = Color(0xFF2B4468);
  static const bronzeTint = Color(0xFFF5ECDC);
  static const bronzeInk = Color(0xFFA97F2A);
  static const slateTint = Color(0xFFECEFF2);
  static const slateInk = Color(0xFF4A5B6E);
  static const oliveTint = Color(0xFFEDF0E4);
  static const oliveInk = Color(0xFF5B6B3A);
  static const plumTint = Color(0xFFF1EBF1);
  static const plumInk = Color(0xFF6E4A6B);
  static const tealTint = Color(0xFFE6F0EF);
  static const tealInk = Color(0xFF2F6B66);
  static const clayTint = Color(0xFFF5E9E4);
  static const clayInk = Color(0xFF9A5641);

  static const navy = (tint: navyTint, ink: navyInk);
  static const bronze = (tint: bronzeTint, ink: bronzeInk);
  static const slate = (tint: slateTint, ink: slateInk);
  static const olive = (tint: oliveTint, ink: oliveInk);
  static const plum = (tint: plumTint, ink: plumInk);
  static const teal = (tint: tealTint, ink: tealInk);
  static const clay = (tint: clayTint, ink: clayInk);

  static const all = <NyayaTone>[navy, bronze, slate, olive, plum, teal, clay];
}

/// Difficulty colors: calm, never red.
abstract final class NyayaDifficulty {
  static const easy = NyayaColors.success;
  static const medium = NyayaColors.goldDeep;
  static const hard = NyayaTones.clayInk;
}

/// Corner radii. `xs` is for small ornaments and badges only.
abstract final class NyayaRadii {
  static const double xs = 6;
  static const double sm = 12;
  static const double md = 20;
  static const double pill = 999;
}

/// Spacing scale (4-pt grid).
abstract final class NyayaSpace {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Elevation: one soft card shadow and one raised shadow.
abstract final class NyayaShadows {
  static const card = [
    BoxShadow(
      color: NyayaColors.shadowSoft,
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
  static const raised = [
    BoxShadow(
      color: NyayaColors.shadowStrong,
      blurRadius: 18,
      offset: Offset(0, 6),
    ),
  ];
}
