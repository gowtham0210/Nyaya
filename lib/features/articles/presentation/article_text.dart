import '../../../core/localization/l10n.dart';
import 'articles_view_model.dart';

/// "Part III · Fundamental Rights", or just the title when the part is
/// blank; null when both are blank.
String? partLabel(AppLocalizations l10n, Article article) {
  if (article.part.isEmpty) {
    return article.partTitle.isEmpty ? null : article.partTitle;
  }
  return l10n.articlesPart(article.part, article.partTitle);
}

/// "2. Right to Equality".
String numberedTitle(int number, Article article) =>
    '$number. ${article.title}';

/// What the list shows when an article is expanded.
String previewText(Article article) =>
    article.whatItMeans ?? article.description;
