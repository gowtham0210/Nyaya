import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shared elevation shadows so cards read as gently lifted surfaces
/// instead of flat bordered boxes — used consistently across the app.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> get card => [
        BoxShadow(color: AppColors.navy.withValues(alpha: 0.06), blurRadius: 14, offset: const Offset(0, 4)),
      ];

  static List<BoxShadow> get raised => [
        BoxShadow(color: AppColors.navy.withValues(alpha: 0.10), blurRadius: 20, offset: const Offset(0, 8)),
      ];

  static List<BoxShadow> get highlighted => [
        BoxShadow(color: AppColors.gold.withValues(alpha: 0.18), blurRadius: 12, offset: const Offset(0, 4)),
      ];
}
