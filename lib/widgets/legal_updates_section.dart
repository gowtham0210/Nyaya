import 'package:flutter/material.dart';

import '../models/legal_update.dart';
import '../repositories/legal_updates_repository.dart';
import '../screens/login_screen.dart';
import '../services/api_exceptions.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

enum _Status { loading, unauthenticated, error, empty, loaded }

/// The Articles screen's "Legal Updates" tab — entirely driven by
/// GET /api/v1/legal-updates via [LegalUpdatesRepository]. No sample
/// content: every state (loading, signed-out, error, empty, loaded)
/// reflects the real backend, and the category filter re-queries it.
class LegalUpdatesSection extends StatefulWidget {
  const LegalUpdatesSection({super.key});

  @override
  State<LegalUpdatesSection> createState() => _LegalUpdatesSectionState();
}

class _LegalUpdatesSectionState extends State<LegalUpdatesSection> {
  final _repository = LegalUpdatesRepository();

  static const _categories = ['All Updates', 'Judgements', 'Legislation', 'Reforms', 'Notices'];
  static const _categoryColors = {
    'Judgements': AppColors.navy,
    'Legislation': Color(0xFFB9823A), // goldDark
    'Reforms': Color(0xFF667183), // navySecondary
    'Notices': AppColors.gold,
  };

  String _selectedCategory = 'All Updates';
  _Status _status = _Status.loading;
  List<LegalUpdate> _updates = const [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _status = _Status.loading);
    try {
      final updates = await _repository.getUpdates(
        category: _selectedCategory == 'All Updates' ? null : _selectedCategory,
      );
      setState(() {
        _updates = updates;
        _status = updates.isEmpty ? _Status.empty : _Status.loaded;
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

  void _selectCategory(String category) {
    if (category == _selectedCategory) return;
    setState(() => _selectedCategory = category);
    _load();
  }

  Color _colorFor(String category) => _categoryColors[category] ?? AppColors.navy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final selected = category == _selectedCategory;
              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _selectCategory(category),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.navy : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: selected ? AppColors.navy : AppColors.beigeBorder),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        _buildBody(),
      ],
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case _Status.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );

      case _Status.unauthenticated:
        return _StatusCard(
          icon: Icons.lock_outline,
          message: 'Sign in to see legal updates.',
          actionLabel: 'Sign in',
          onAction: _openSignIn,
        );

      case _Status.error:
        return _StatusCard(
          icon: Icons.wifi_off_rounded,
          message: _errorMessage ?? 'Unable to load legal updates.',
          actionLabel: 'Retry',
          onAction: _load,
        );

      case _Status.empty:
        return const _StatusCard(icon: Icons.inbox_outlined, message: 'No legal updates available.');

      case _Status.loaded:
        return Column(
          children: [
            for (final update in _updates) ...[
              _LegalUpdateCard(update: update, accentColor: _colorFor(update.category)),
              const SizedBox(height: 12),
            ],
          ],
        );
    }
  }
}

class _LegalUpdateCard extends StatelessWidget {
  const _LegalUpdateCard({required this.update, required this.accentColor});

  final LegalUpdate update;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.beigeBorder),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (update.imageUrl != null && update.imageUrl!.isNotEmpty)
            SizedBox(
              height: 130,
              width: double.infinity,
              child: Image.network(
                update.imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(color: AppColors.background);
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.background,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported_outlined, color: AppColors.muted, size: 28),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        update.category,
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: accentColor),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.bookmark_border_rounded, color: AppColors.muted, size: 19),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  update.title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.navy, height: 1.35),
                ),
                const SizedBox(height: 6),
                Text(
                  update.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.muted),
                    const SizedBox(width: 4),
                    Text(update.updateDate, style: const TextStyle(fontSize: 10.5, color: AppColors.muted)),
                    if (update.source != null && update.source!.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      const Icon(Icons.account_balance_outlined, size: 12, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          update.source!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10.5, color: AppColors.muted),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
    );
  }
}
