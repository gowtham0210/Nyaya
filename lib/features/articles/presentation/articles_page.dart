import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';

import '../../../app/theme/app_typography.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/widgets/load_state_view.dart';
import 'article_text.dart';
import 'articles_view_model.dart';
import 'widgets/article_list_item.dart';

const _pageBackground = NyayaColors.ivory;
const _navy = NyayaColors.ink;
const _gold = NyayaColors.goldDeep;

/// The Articles tab (spec 019): a hero, then articles grouped by part.
class ArticlesPage extends StatefulWidget {
  const ArticlesPage({
    super.key,
    required this.viewModel,
    required this.onArticleOpened,
  });

  final ArticlesViewModel viewModel;

  /// "Read article" on [article], shown as number [number] in the list.
  final void Function(Article article, int number) onArticleOpened;

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final viewModel = widget.viewModel;
    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) => ListView(
            key: const ValueKey('articles.scroll'),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            children: [
              const _Hero(),
              const SizedBox(height: 20),
              LoadStateView<List<Article>>(
                state: viewModel.state,
                onRetry: viewModel.load,
                emptyMessage: l10n.articlesEmpty,
                emptyIcon: Icons.menu_book_outlined,
                builder: (context, articles) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (index, article) in articles.indexed) ...[
                      if (index == 0 ||
                          articles[index - 1].part != article.part)
                        _PartHeader(article: article, first: index == 0),
                      ArticleListItem(
                        number: index + 1,
                        article: article,
                        expanded: viewModel.isExpanded(article.id),
                        onToggle: () => viewModel.toggle(article.id),
                        onRead: () =>
                            widget.onArticleOpened(article, index + 1),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      key: const ValueKey('articles.hero'),
      // A minimum, so large text grows the hero instead of overflowing.
      constraints: const BoxConstraints(minHeight: 140),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(NyayaRadii.md),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/articles/hero.png',
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _navy.withValues(alpha: 0.9),
                    _navy.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.6, 1],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Text(
                    l10n.articlesHeroTitle,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      fontFamily: NyayaFonts.display,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.articlesHeroSubtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.85),
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

class _PartHeader extends StatelessWidget {
  const _PartHeader({required this.article, required this.first});

  final Article article;
  final bool first;

  @override
  Widget build(BuildContext context) {
    final label = partLabel(context.l10n, article);
    if (label == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(top: first ? 0 : 12, bottom: 12),
      child: Semantics(
        header: true,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: _gold,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
