import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../state/nyaya_tabs.dart';
import '../theme/app_colors.dart';

/// A simple "Coming Soon" style placeholder used for screens that don't
/// have a dedicated implementation yet, so navigation never crashes.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    this.subtitle,
    this.showOwnBottomNav = true,
  });

  final String title;
  final String? subtitle;

  /// False when this screen is one of [RootScreen]'s own tab pages — that
  /// Scaffold already supplies the bottom nav, so this one must not add a
  /// second copy. True (default) when pushed standalone via Navigator.
  final bool showOwnBottomNav;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.navy,
        elevation: 0.5,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      bottomNavigationBar: showOwnBottomNav ? const GlobalBottomNav() : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: AppColors.navy.withValues(alpha: 0.06), shape: BoxShape.circle),
                child: const Icon(Icons.hourglass_top_rounded, color: AppColors.navy, size: 32),
              ),
              const SizedBox(height: 16),
              Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Text(
                subtitle ?? tr('placeholder_default_subtitle'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
