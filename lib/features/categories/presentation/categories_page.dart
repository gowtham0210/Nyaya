import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/widgets/load_state_view.dart';
import '../../../core/presentation/widgets/nyaya_icon.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import 'categories_view_model.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({
    super.key,
    required this.viewModel,
    this.onCategorySelected,
  });

  final CategoriesViewModel viewModel;
  final ValueChanged<CategoryData>? onCategorySelected;

  static const pageBackground = Color(0xFFF8F6F2);
  static const heroBackground = Color(0xFF11233B);
  static const supportText = Color(0xFF5E6878);
  static const cardBorder = Color(0xFFECE5DB);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    widget.viewModel.load();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: CategoriesPage.pageBackground,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.navCategories,
                          key: const ValueKey('categories.header.title'),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: CategoriesPage.heroBackground,
                            fontFamily: 'serif',
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.categoriesSubtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: CategoriesPage.supportText,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const _HeaderEmblem(),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _SearchField(
                      controller: _searchController,
                      hint: l10n.categoriesSearchHint,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _FilterButton(
                    onTap: () => _showPlaceholder(
                      context,
                      l10n.featureComingSoon(l10n.categoriesFilters),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListenableBuilder(
                  listenable: viewModel,
                  builder: (context, _) => LoadStateView<List<CategoryData>>(
                    state: viewModel.state,
                    onRetry: viewModel.load,
                    emptyMessage: l10n.categoriesEmpty,
                    emptyIcon: Icons.grid_view_rounded,
                    builder: (context, categories) => _buildGrid(
                      viewModel.filter(categories, _searchController.text),
                      l10n.categoriesNoMatch,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(List<CategoryData> visible, String emptySearchMessage) {
    return visible.isEmpty
        ? _EmptyState(message: emptySearchMessage)
        : GridView.builder(
            key: const ValueKey('categories.grid'),
            padding: const EdgeInsets.only(bottom: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.92,
            ),
            itemCount: visible.length,
            itemBuilder: (context, index) {
              final category = visible[index];
              return _CategoryCard(
                category: category,
                onTap: () {
                  final callback = widget.onCategorySelected;
                  if (callback != null) {
                    callback(category);
                    return;
                  }
                  _showPlaceholder(
                    context,
                    context.l10n.featureComingSoon(category.label),
                  );
                },
              );
            },
          );
  }

  void _showPlaceholder(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _HeaderEmblem extends StatelessWidget {
  const _HeaderEmblem();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      height: 84,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: gold.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            right: -6,
            bottom: -2,
            child: Opacity(
              opacity: 0.18,
              child: Image.asset(
                'assets/backgrounds/temple_bg.png',
                width: 54,
                fit: BoxFit.contain,
                excludeFromSemantics: true,
              ),
            ),
          ),
          const Icon(Icons.balance_rounded, size: 40, color: gold),
          const Positioned(
            top: 2,
            left: 8,
            child: Icon(Icons.auto_awesome_rounded, size: 12, color: gold),
          ),
          const Positioned(
            bottom: 10,
            left: -2,
            child: Icon(Icons.auto_awesome_rounded, size: 8, color: gold),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const ValueKey('categories.filter'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: ivory,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CategoriesPage.cardBorder),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.tune_rounded,
          color: CategoriesPage.heroBackground,
          size: 22,
          semanticLabel: context.l10n.categoriesFilters,
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('categories.search'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: CategoriesPage.cardBorder),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: CategoriesPage.supportText,
            fontSize: 15,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: CategoriesPage.supportText,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.onTap});

  final CategoryData category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = Color(category.iconHex);
    final quizCount = category.quizCount;

    return InkWell(
      key: ValueKey('categories.card.${category.slug}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: Color(category.tintHex),
          borderRadius: BorderRadius.circular(22),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: NyayaIcon(
                type: category.icon,
                size: 26,
                color: iconColor,
                accentColor: iconColor,
              ),
            ),
            const Spacer(),
            Text(
              category.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: CategoriesPage.heroBackground,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: quizCount == null
                      ? const SizedBox.shrink()
                      : Text(
                          context.l10n.quizCount(quizCount),
                          key: ValueKey(
                            'categories.card.${category.slug}.meta',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: CategoriesPage.supportText,
                          ),
                        ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: CategoriesPage.heroBackground,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('categories.empty'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 40,
            color: CategoriesPage.supportText,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: CategoriesPage.supportText,
            ),
          ),
        ],
      ),
    );
  }
}
