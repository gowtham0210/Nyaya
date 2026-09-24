import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../localization/app_strings.dart';
import '../repositories/categories_repository.dart';
import '../state/app_language.dart';
import '../screens/all_recommended_screen.dart';
import '../screens/login_screen.dart';
import '../screens/placeholder_screen.dart';
import '../services/api_exceptions.dart';
import '../theme/app_colors.dart';
import 'recommendation_card.dart';

enum _Status { loading, unauthenticated, error, empty, loaded }

/// Local NYAYA visuals to pair with whatever categories the backend
/// returns — cycled by a stable value (category id), never by matching
/// category display text, since the backend has no image field.
const categoryFallbackImages = [
  'assets/images/rec_constitution.png',
  'assets/images/rec_criminal_law.png',
  'assets/images/rec_contract_act.png',
];

/// Splits a category name at the space that makes the two lines most even.
(String, String) splitCategoryName(String name) {
  var best = -1;
  var bestWidth = name.length + 1;
  for (var i = 0; i < name.length; i++) {
    if (name[i] != ' ') continue;
    final widest = i > name.length - i - 1 ? i : name.length - i - 1;
    if (widest < bestWidth) {
      bestWidth = widest;
      best = i;
    }
  }
  if (best == -1) return (name, '');
  return (name.substring(0, best), name.substring(best + 1));
}

/// "Recommended for you" — entirely driven by GET /api/v1/categories via
/// [CategoriesRepository]. There is no sample/fallback data: every state
/// (loading, signed-out, error, empty, loaded) reflects the real backend.
class RecommendedForYouSection extends StatefulWidget {
  const RecommendedForYouSection({super.key});

  @override
  State<RecommendedForYouSection> createState() => _RecommendedForYouSectionState();
}

class _RecommendedForYouSectionState extends State<RecommendedForYouSection> {
  final _repository = CategoriesRepository();

  _Status _status = _Status.loading;
  List<CategoryRecommendation> _recommendations = const [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _load();
    AppLanguage.current.addListener(_load);
  }

  @override
  void dispose() {
    AppLanguage.current.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _status = _Status.loading);
    try {
      final recommendations = await _repository.getRecommended();
      setState(() {
        _recommendations = recommendations;
        _status = recommendations.isEmpty ? _Status.empty : _Status.loaded;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(tr('section_recommended_for_you'), style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const Spacer(),
            InkWell(
              onTap: _status != _Status.loaded
                  ? null
                  : () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AllRecommendedScreen(items: _recommendations)),
                      ),
              child: Text(tr('button_view_all'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.gold)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(height: 188, child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    switch (_status) {
      case _Status.loading:
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));

      case _Status.unauthenticated:
        return _StatusCard(
          icon: Icons.lock_outline,
          message: tr('msg_signin_categories'),
          actionLabel: tr('button_sign_in'),
          onAction: _openSignIn,
        );

      case _Status.error:
        return _StatusCard(
          icon: Icons.wifi_off_rounded,
          message: _errorMessage ?? tr('msg_error_recommendations_default'),
          actionLabel: tr('button_retry'),
          onAction: _load,
        );

      case _Status.empty:
        return _StatusCard(icon: Icons.inbox_outlined, message: tr('msg_empty_categories'));

      case _Status.loaded:
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          itemCount: _recommendations.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final entry = _recommendations[index];
            final (line1, line2) = splitCategoryName(entry.category.name);
            return RecommendationCard(
              imagePath: categoryFallbackImages[entry.category.id % categoryFallbackImages.length],
              imageUrl: entry.category.imageUrl == null ? null : '${ApiConfig.serverOrigin}${entry.category.imageUrl}',
              titleLine1: line1,
              titleLine2: line2,
              modulesLabel: '${entry.moduleCount} ${entry.moduleCount == 1 ? tr('word_module') : tr('word_modules')}',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PlaceholderScreen(title: entry.category.name)),
              ),
            );
          },
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.beigeBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.muted, size: 26),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
          if (actionLabel != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
                textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
