import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Motion tokens (spec 039): three durations and one curve, so the app
/// moves the same way everywhere.
abstract final class NyayaMotion {
  static const quick = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 600);
  static const curve = Curves.easeOutCubic;

  /// True when the learner asked the OS to reduce motion.
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// [duration], or zero when motion is reduced.
  static Duration of(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;
}

/// Haptic feedback with one meaning per pattern (spec 039).
abstract final class NyayaHaptics {
  /// A choice: picking an answer, switching tabs.
  static Future<void> select() => HapticFeedback.selectionClick();

  /// A right answer.
  static Future<void> correct() => HapticFeedback.lightImpact();

  /// A wrong answer.
  static Future<void> wrong() => HapticFeedback.mediumImpact();

  /// A strong result at the end of a quiz.
  static Future<void> celebrate() => HapticFeedback.heavyImpact();
}
