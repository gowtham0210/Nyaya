import 'package:flutter/material.dart';

const settingsNavy = Color(0xFF11233B);
const settingsGold = Color(0xFFB9823A);
const settingsSupportText = Color(0xFF5E6878);
const settingsDanger = Color(0xFFD64545);
const _pageBackground = Color(0xFFF8F6F2);
const _cardBorder = Color(0xFFECE5DB);

/// The shared frame for Profile's settings screens: title bar and a
/// padded, scrolling list.
class SettingsScaffold extends StatelessWidget {
  const SettingsScaffold({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        backgroundColor: _pageBackground,
        foregroundColor: settingsNavy,
        surfaceTintColor: Colors.transparent,
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: children,
      ),
    );
  }
}

/// A white rounded card; [children] are separated by dividers.
class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: _cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, child) in children.indexed) ...[
            if (index > 0) const Divider(height: 1, color: _cardBorder),
            child,
          ],
        ],
      ),
    );
  }
}

/// A section heading above a card.
class SettingsHeading extends StatelessWidget {
  const SettingsHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Semantics(
        header: true,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: settingsNavy,
          ),
        ),
      ),
    );
  }
}
