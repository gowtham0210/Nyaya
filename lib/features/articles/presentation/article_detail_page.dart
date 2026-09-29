import 'package:flutter/material.dart';

import '../../category_detail/data/category_content.dart';
import '../../home/presentation/home_page.dart';
import '../../home/presentation/home_view_model.dart';

/// A single Article topic: icon, title, and its brief explanation — pure
/// reading, no quiz. Distinct from [CategoryDetailPage], which is the
/// Categories grid's landing page and jumps straight into a quiz.
class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({
    super.key,
    required this.category,
    this.content,
    this.onBackPressed,
  });

  final HomeCategoryData category;
  final CategoryContent? content;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final resolvedContent = content ?? categoryContentFor(category.id);

    return Scaffold(
      backgroundColor: HomePage.pageBackground,
      body: SafeArea(
        child: ListView(
          key: ValueKey('articleDetail.scroll.${category.id}'),
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
          children: [
            Row(
              children: [
                IconButton(
                  key: const ValueKey('articleDetail.back'),
                  onPressed: () {
                    final callback = onBackPressed;
                    if (callback != null) {
                      callback();
                      return;
                    }
                    Navigator.of(context).maybePop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: HomePage.heroBackground,
                  ),
                ),
                const Text(
                  'Article',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: HomePage.heroBackground,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: HomePage.heroBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: HomeIcon(
                type: category.icon,
                size: 34,
                color: Colors.white,
                accentColor: HomePage.heroHighlight,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              category.label,
              key: ValueKey('articleDetail.title.${category.id}'),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: HomePage.heroBackground,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              resolvedContent.articleContent.isNotEmpty
                  ? resolvedContent.articleContent
                  : resolvedContent.description,
              key: ValueKey('articleDetail.body.${category.id}'),
              style: const TextStyle(
                fontSize: 15,
                color: HomePage.heroBackground,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
