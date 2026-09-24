import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../theme/app_colors.dart';
import '../widgets/settings_page.dart';

/// Matches `version:` in pubspec.yaml.
const _appVersion = '1.0.0';

class AboutNyayaScreen extends StatelessWidget {
  const AboutNyayaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      (Icons.menu_book_outlined, tr('about_feature_1')),
      (Icons.lightbulb_outline, tr('about_feature_2')),
      (Icons.campaign_outlined, tr('about_feature_3')),
      (Icons.emoji_events_outlined, tr('about_feature_4')),
      (Icons.language_rounded, tr('about_feature_5')),
    ];

    return SettingsPage(
      title: tr('placeholder_about_nyaya'),
      children: [
        SettingsCard(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
          child: Column(
            children: [
              Image.asset('assets/images/nyaya_logo.png', height: 64, fit: BoxFit.contain),
              const SizedBox(height: 12),
              Text(tr('about_tagline'), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: AppColors.goldLight, borderRadius: BorderRadius.circular(20)),
                child: Text('${tr('about_version')} $_appVersion', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.goldDark)),
              ),
              const SizedBox(height: 16),
              Text(
                tr('about_description'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12.5, height: 1.5, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SettingsSectionTitle(tr('about_features_title')),
        SettingsCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              for (var i = 0; i < features.length; i++) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                        child: Icon(features[i].$1, size: 16, color: AppColors.navy),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(features[i].$2, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.navy, height: 1.35))),
                    ],
                  ),
                ),
                if (i != features.length - 1) const Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
