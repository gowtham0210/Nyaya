import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/presentation/widgets/load_state_view.dart';
import '../../../../core/presentation/widgets/nyaya_icon.dart';
import '../../../categories/presentation/categories_view_model.dart';

const _navy = NyayaColors.ink;
const _supportText = NyayaColors.inkMuted;
const _cardBorder = NyayaColors.hairline;

/// Home's "Explore by Category" strip of backend categories (specs 026,
/// 040). Shares the Categories tab's view model.
class RecommendedSection extends StatelessWidget {
  const RecommendedSection({
    super.key,
    required this.viewModel,
    required this.onCategorySelected,
  });

  final CategoriesViewModel viewModel;
  final ValueChanged<CategoryData> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => LoadStateView<List<CategoryData>>(
        key: const ValueKey('home.recommended'),
        state: viewModel.state,
        onRetry: viewModel.load,
        emptyMessage: context.l10n.categoriesEmpty,
        emptyIcon: Icons.grid_view_rounded,
        builder: (context, categories) => SizedBox(
          height: recommendedCardHeight(context),
          child: ListView.separated(
            key: const ValueKey('home.recommended.strip'),
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) => SizedBox(
              width: 150,
              child: RecommendedCard(
                category: categories[index],
                onPressed: () => onCategorySelected(categories[index]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Card height for the strip; grows with the text size.
double recommendedCardHeight(BuildContext context) =>
    70 + MediaQuery.textScalerOf(context).scale(95);

/// A category card for Home's category strip.
class RecommendedCard extends StatelessWidget {
  const RecommendedCard({
    super.key,
    required this.category,
    required this.onPressed,
  });

  final CategoryData category;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final quizCount = category.quizCount;
    final iconColor = Color(category.iconHex);
    final l10n = context.l10n;
    return Semantics(
      key: ValueKey('home.recommended.${category.slug}'),
      button: true,
      label: quizCount == null
          ? category.label
          : '${category.label}, ${l10n.quizCount(quizCount)}',
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NyayaRadii.md),
          side: const BorderSide(color: _cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color(category.tintHex),
                      borderRadius: BorderRadius.circular(NyayaRadii.sm),
                    ),
                    alignment: Alignment.center,
                    child: NyayaIcon(
                      type: category.icon,
                      size: 24,
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
                      height: 1.25,
                      color: _navy,
                    ),
                  ),
                  if (quizCount != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.quizCount(quizCount),
                      style: const TextStyle(fontSize: 12, color: _supportText),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
