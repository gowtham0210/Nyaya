import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import '../data/app_version.dart';
import '../../../core/presentation/widgets/detail_scaffold.dart';

/// About Nyaya (spec 030): what the app is for, and its version.
class AboutPage extends StatefulWidget {
  const AboutPage({super.key, required this.loadVersion});

  final AppVersionReader loadVersion;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  // Read once, not on every rebuild.
  late final Future<String> _version = widget.loadVersion();

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
    return DetailScaffold(
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
              color: brandNavy,
            ),
          ),
        ),
        Center(
          child: Text(
            l10n.aboutTagline,
            textAlign: TextAlign.center,
            style: const TextStyle(color: brandGold),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: FutureBuilder<String>(
            future: _version,
            builder: (context, snapshot) => Text(
              snapshot.hasData ? l10n.aboutVersion(snapshot.data!) : '',
              key: const ValueKey('about.version'),
              style: const TextStyle(color: brandSupportText),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.aboutDescription,
          style: const TextStyle(fontSize: 15, height: 1.5, color: brandNavy),
        ),
        DetailHeading(l10n.aboutFeaturesTitle),
        DetailCard(
          children: [
            for (final (icon, text) in features)
              ListTile(
                leading: Icon(icon, color: brandGold),
                title: Text(text),
              ),
          ],
        ),
      ],
    );
  }
}
