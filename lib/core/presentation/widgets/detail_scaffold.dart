import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';

const brandNavy = NyayaColors.ink;
const brandGold = NyayaColors.goldDeep;
const brandSupportText = NyayaColors.inkMuted;
const brandDanger = NyayaColors.danger;
const brandSuccess = NyayaColors.success;
const brandBackground = NyayaColors.ivory;
const _cardBorder = NyayaColors.hairline;

/// The shared frame for detail screens opened from Profile: title bar and a
/// padded, scrolling list.
class DetailScaffold extends StatelessWidget {
  const DetailScaffold({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandBackground,
      appBar: AppBar(
        backgroundColor: brandBackground,
        foregroundColor: brandNavy,
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
class DetailCard extends StatelessWidget {
  const DetailCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NyayaRadii.md),
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
class DetailHeading extends StatelessWidget {
  const DetailHeading(this.text, {super.key});

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
            color: brandNavy,
          ),
        ),
      ),
    );
  }
}
