import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import 'widgets/settings_scaffold.dart';

/// About Nyaya (spec 030): what the app is for, and its version.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key, required this.loadVersion});

  /// e.g. `1.0.0 (1)`; the shell reads it from the platform (ADR 0004).
  final Future<String> Function() loadVersion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final features = [
      (Icons.menu_book_outlined, l10n.aboutFeatureArticles),
      (Icons.lightbulb_outline, l10n.aboutFeatureDaily),
      (Icons.campaign_outlined, l10n.aboutFeatureUpdates),
      (Icons.quiz_outlined, l10n.aboutFeatureQuizzes),
      (Icons.language_rounded, l10n.aboutFeatureLanguages),
    ];
    return SettingsScaffold(
      title: l10n.profileAbout,
      children: [
        Center(
          child: Image.asset(
            logoAsset,
            width: 72,
            height: 72,
            excludeFromSemantics: true,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            l10n.appTitle,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              fontFamily: 'serif',
              color: settingsNavy,
            ),
          ),
        ),
        Center(
          child: Text(
            l10n.aboutTagline,
            textAlign: TextAlign.center,
            style: const TextStyle(color: settingsGold),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: FutureBuilder<String>(
            future: loadVersion(),
            builder: (context, snapshot) => Text(
              snapshot.hasData ? l10n.aboutVersion(snapshot.data!) : '',
              key: const ValueKey('about.version'),
              style: const TextStyle(color: settingsSupportText),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.aboutDescription,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
            color: settingsNavy,
          ),
        ),
        SettingsHeading(l10n.aboutFeaturesTitle),
        SettingsCard(
          children: [
            for (final (icon, text) in features)
              ListTile(
                leading: Icon(icon, color: settingsGold),
                title: Text(text),
              ),
          ],
        ),
      ],
    );
  }
}
