import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../localization/app_strings.dart';
import '../models/article.dart';
import '../state/app_language.dart';
import '../repositories/articles_repository.dart';
import '../services/api_exceptions.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../widgets/article_accordion_item.dart';
import '../widgets/legal_updates_section.dart';
import '../widgets/nyaya_app_bar.dart';
import 'article_detail_screen.dart';
import 'login_screen.dart';
import 'placeholder_screen.dart';

enum _Tab { articles, legalUpdates }

enum _Status { loading, unauthenticated, error, empty, loaded }

/// The NYAYA Articles screen — entirely driven by GET /api/v1/articles via
/// [ArticlesRepository]. No hardcoded titles or descriptions: every state
/// (loading, signed-out, error, empty, loaded) reflects the real backend.
/// See backend_wiring_instructions.md for the endpoint this expects.
class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  final _repository = ArticlesRepository();
  final _searchController = TextEditingController();

  _Tab _tab = _Tab.articles;
  _Status _status = _Status.loading;
  List<Article> _articles = const [];
  String? _errorMessage;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
    AppLanguage.current.addListener(_load);
  }

  @override
  void dispose() {
    AppLanguage.current.removeListener(_load);
    _searchController.dispose();
    super.dispose();
  }

  List<Article> get _visibleArticles {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return _articles;
    return _articles.where((article) {
      return article.title.toLowerCase().contains(query) ||
          article.description.toLowerCase().contains(query) ||
          article.articleRange.toLowerCase().contains(query) ||
          article.partTitle.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _load() async {
    setState(() => _status = _Status.loading);
    try {
      final articles = await _repository.getArticles();
      setState(() {
        _articles = articles;
        _status = articles.isEmpty ? _Status.empty : _Status.loaded;
      });
    } on UnauthenticatedException {
      setState(() => _status = _Status.unauthenticated);
    } on ApiException catch (e) {
      setState(() {
        _status = _Status.error;
        _errorMessage = e.message;
      });
    } on NetworkException catch (e) {
      setState(() {
        _status = _Status.error;
        _errorMessage = e.message;
      });
    }
  }

  Future<void> _openSignIn() async {
    final signedIn = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const LoginScreen()));
    if (signedIn == true) _load();
  }

  void _openPlaceholder(String title) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaceholderScreen(title: title)));
  }

  void _openArticle(int number, Article article) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ArticleDetailScreen(number: number, article: article)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NyayaAppBar(
        onNotificationTap: () => _openPlaceholder(tr('label_notifications')),
        searchController: _searchController,
        searchHint: tr('articles_search_hint'),
        onSearchChanged: (value) => setState(() => _query = value),
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.only(top: 14),
            children: [
              _buildHero(),
              const SizedBox(height: 14),
              _buildTabs(),
              const SizedBox(height: 14),
              _buildBody(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 128,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/articles_hero_photo.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.navy.withValues(alpha: 0.85),
                    AppColors.navy.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tr('articles_hero_title'),
                    style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    tr('articles_hero_subtitle'),
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 10.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.beigeBorder),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            _tabButton(tr('nav_articles'), Icons.menu_book_outlined, _Tab.articles),
            _tabButton(tr('tab_legal_updates'), Icons.balance_rounded, _Tab.legalUpdates),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String label, IconData icon, _Tab tab) {
    final selected = _tab == tab;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => setState(() => _tab = tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.navy : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: selected ? AppColors.gold : AppColors.muted),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<(String, String, List<Article>)> _groupedByPart(List<Article> articles) {
    final groups = <(String, String, List<Article>)>[];
    for (final article in articles) {
      if (groups.isNotEmpty && groups.last.$1 == article.part) {
        groups.last.$3.add(article);
      } else {
        groups.add((article.part, article.partTitle, [article]));
      }
    }
    return groups;
  }

  Widget _buildBody() {
    if (_tab == _Tab.legalUpdates) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: LegalUpdatesSection(),
      );
    }

    switch (_status) {
      case _Status.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );

      case _Status.unauthenticated:
        return _StatusCard(
          icon: Icons.lock_outline,
          message: tr('msg_signin_articles'),
          actionLabel: tr('button_sign_in'),
          onAction: _openSignIn,
        );

      case _Status.error:
        return _StatusCard(
          icon: Icons.wifi_off_rounded,
          message: _errorMessage ?? tr('msg_error_articles_default'),
          actionLabel: tr('button_retry'),
          onAction: _load,
        );

      case _Status.empty:
        return _StatusCard(icon: Icons.inbox_outlined, message: tr('msg_empty_articles'));

      case _Status.loaded:
        final visible = _visibleArticles;
        if (visible.isEmpty) {
          return _StatusCard(icon: Icons.search_off_rounded, message: tr('msg_no_search_results'));
        }
        var number = 0;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final part in _groupedByPart(visible)) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 8),
                  child: Text(
                    '${tr('word_part')} ${part.$1} · ${part.$2}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.navy),
                  ),
                ),
                for (final article in part.$3)
                  Builder(builder: (context) {
                    final itemNumber = ++number;
                    return ArticleAccordionItem(
                      number: itemNumber,
                      article: article,
                      onTap: () => _openArticle(itemNumber, article),
                    );
                  }),
                const SizedBox(height: 6),
              ],
            ],
          ),
        );
    }
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.icon, required this.message, this.actionLabel, this.onAction});

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.beigeBorder),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.muted, size: 30),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
            if (actionLabel != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                  minimumSize: const Size(0, 42),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
