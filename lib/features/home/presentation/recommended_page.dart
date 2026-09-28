import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/widgets/load_state_view.dart';
import '../../categories/presentation/categories_view_model.dart';
import 'widgets/recommended_section.dart';

const _pageBackground = Color(0xFFF8F6F2);
const _navy = Color(0xFF11233B);

/// Every recommended category as a grid, opened from Home's "View All"
/// (spec 026). Shares Home's categories view model.
class RecommendedPage extends StatelessWidget {
  const RecommendedPage({
    super.key,
    required this.viewModel,
    required this.onCategorySelected,
  });

  final CategoriesViewModel viewModel;
  final ValueChanged<CategoryData> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        backgroundColor: _pageBackground,
        foregroundColor: _navy,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.homeRecommended,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) => LoadStateView<List<CategoryData>>(
          state: viewModel.state,
          onRetry: viewModel.load,
          emptyMessage: l10n.categoriesEmpty,
          emptyIcon: Icons.grid_view_rounded,
          builder: (context, categories) => GridView.builder(
            key: const ValueKey('recommended.grid'),
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisExtent: recommendedCardHeight(context),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) => RecommendedCard(
              category: categories[index],
              onPressed: () => onCategorySelected(categories[index]),
            ),
          ),
        ),
      ),
    );
  }
}
