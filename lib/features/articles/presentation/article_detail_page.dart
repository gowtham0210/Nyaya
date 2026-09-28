import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import 'articles_view_model.dart';

const _pageBackground = Color(0xFFF8F6F2);
const _navy = Color(0xFF11233B);
const _gold = Color(0xFFB9823A);
const _supportText = Color(0xFF5E6878);
const _cardBorder = Color(0xFFECE5DB);

/// One article's full text (spec 019). Empty sections are hidden.
class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({
    super.key,
    required this.number,
    required this.article,
  });

  final int number;
  final Article article;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final whatItMeans = article.whatItMeans;
    final whyItMatters = article.whyItMatters;
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        backgroundColor: _pageBackground,
        foregroundColor: _navy,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.articlesPart(article.part, article.partTitle),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        key: const ValueKey('articleDetail.scroll'),
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          Text(
            '$number. ${article.title}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.3,
              color: _navy,
            ),
          ),
          if (article.articleRange.isNotEmpty) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: Text(
                    article.articleRange,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _gold,
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (article.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              article.description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: _supportText,
              ),
            ),
          ],
          if (whatItMeans != null)
            _Section(
              icon: Icons.lightbulb_outline,
              heading: l10n.articleWhatItMeans,
              child: _Body(whatItMeans),
            ),
          if (whyItMatters != null)
            _Section(
              icon: Icons.balance_outlined,
              heading: l10n.articleWhyItMatters,
              child: _Body(whyItMatters),
            ),
          if (article.keyFeatures.isNotEmpty)
            _Section(
              icon: Icons.checklist_rounded,
              heading: l10n.articleKeyFeatures,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final feature in article.keyFeatures)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Icon(
                              Icons.check_circle_rounded,
                              size: 16,
                              color: _gold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: _Body(feature)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.heading,
    required this.child,
  });

  final IconData icon;
  final String heading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: _navy),
              const SizedBox(width: 8),
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    heading,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _navy,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 14, height: 1.5, color: _navy),
  );
}
