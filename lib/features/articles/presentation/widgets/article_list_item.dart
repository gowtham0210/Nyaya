import 'package:flutter/material.dart';

import '../../../../core/localization/l10n.dart';
import '../articles_view_model.dart';

const _navy = Color(0xFF11233B);
const _supportText = Color(0xFF5E6878);
const _cardBorder = Color(0xFFECE5DB);
const _badgeColors = [_navy, Color(0xFFB9823A)];

/// One article in the list: tap to expand a preview, then "Read article".
class ArticleListItem extends StatelessWidget {
  const ArticleListItem({
    super.key,
    required this.number,
    required this.article,
    required this.expanded,
    required this.onToggle,
    required this.onRead,
  });

  final int number;
  final Article article;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onRead;

  @override
  Widget build(BuildContext context) {
    final badgeColor = _badgeColors[(number - 1) % _badgeColors.length];
    final title = '$number. ${article.title}';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: expanded ? badgeColor : _cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            key: ValueKey('articles.item.${article.id}'),
            button: true,
            expanded: expanded,
            label: article.articleRange.isEmpty
                ? title
                : '$title, ${article.articleRange}',
            child: InkWell(
              onTap: onToggle,
              child: ExcludeSemantics(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: badgeColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.account_balance_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                                color: _navy,
                              ),
                            ),
                            if (article.articleRange.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                article.articleRange,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: _supportText,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: badgeColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.whatItMeans ?? article.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: _supportText,
                    ),
                  ),
                  TextButton.icon(
                    key: ValueKey('articles.item.${article.id}.read'),
                    onPressed: onRead,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    iconAlignment: IconAlignment.end,
                    label: Text(context.l10n.articlesReadArticle),
                    style: TextButton.styleFrom(
                      foregroundColor: badgeColor,
                      padding: EdgeInsets.zero,
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
