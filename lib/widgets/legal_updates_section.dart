import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../localization/app_strings.dart';
import '../models/legal_update.dart';
import '../state/app_language.dart';
import '../repositories/legal_updates_repository.dart';
import '../screens/login_screen.dart';
import '../services/api_exceptions.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

enum _Status { loading, unauthenticated, error, empty, loaded }

// Canonical (English) category values — sent as-is to the backend's
// `category` filter param. Display text goes through [_categoryLabel]
// instead, so the filter keeps working regardless of the selected UI
// language.
const _categoryLabelKeys = {
  'All Updates': 'cat_all_updates',
  'Judgements': 'cat_judgements',
  'Legislation': 'cat_legislation',
  'Reforms': 'cat_reforms',
  'Notices': 'cat_notices',
};

String _categoryLabel(String category) => tr(_categoryLabelKeys[category] ?? category);

// A category illustration shown in each card's banner in place of a photo
// — decorative only, every other field on the card is real backend data.
const _categoryIcons = {
  'Judgements': Icons.account_balance_rounded,
  'Legislation': Icons.gavel_rounded,
  'Reforms': Icons.lock_outline_rounded,
  'Notices': Icons.description_outlined,
};

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

  // Canonical (English) values — sent as-is to the backend's `category`
  // filter param. Display text goes through [_labelFor] instead, so the
  // filter keeps working correctly regardless of the selected UI language.
  static const _categories = ['All Updates', 'Judgements', 'Legislation', 'Reforms', 'Notices'];

  String _selectedCategory = 'All Updates';
  _Status _status = _Status.loading;
  List<LegalUpdate> _updates = const [];
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
                    _categoryLabel(category),
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
          message: tr('msg_signin_legal'),
          actionLabel: tr('button_sign_in'),
          onAction: _openSignIn,
        );

      case _Status.error:
        return _StatusCard(
          icon: Icons.wifi_off_rounded,
          message: _errorMessage ?? tr('msg_error_legal_default'),
          actionLabel: tr('button_retry'),
          onAction: _load,
        );

      case _Status.empty:
        return _StatusCard(icon: Icons.inbox_outlined, message: tr('msg_empty_legal'));

      case _Status.loaded:
        return Column(
          children: [
            for (final update in _updates) ...[
              _LegalUpdateCard(update: update),
              const SizedBox(height: 12),
            ],
          ],
        );
    }
  }
}

class _LegalUpdateCard extends StatelessWidget {
  const _LegalUpdateCard({required this.update});

  final LegalUpdate update;

  static const _categoryTheme = {
    'Judgements': (bg: Color(0xFFFFF1DF), text: Color(0xFFC28135)),
    'Judgments': (bg: Color(0xFFFFF1DF), text: Color(0xFFC28135)),
    'Legislation': (bg: Color(0xFFE5F1F6), text: Color(0xFF437F92)),
    'Reforms': (bg: Color(0xFFEAF4E8), text: Color(0xFF568A4F)),
    'Notices': (bg: Color(0xFFF3EDF7), text: Color(0xFF7E5D9D)),
  };

  static String _formatDate(String rawDate) {
    try {
      final parsed = DateTime.tryParse(rawDate);
      if (parsed == null) return rawDate;
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year}';
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _categoryTheme[update.category] ?? (bg: const Color(0xFFF1F5F9), text: const Color(0xFF475569));
    final hasImage = update.imageUrl != null && update.imageUrl!.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.beigeBorder),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 96,
              height: 104,
              child: hasImage
                  ? Image.network(
                      update.imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: theme.bg,
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(theme.text.withValues(alpha: 0.5)),
                              ),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: theme.bg,
                        child: Center(
                          child: Icon(
                            _categoryIcons[update.category] ?? Icons.gavel_rounded,
                            size: 36,
                            color: theme.text.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      color: theme.bg,
                      child: Center(
                        child: Icon(
                          _categoryIcons[update.category] ?? Icons.gavel_rounded,
                          size: 36,
                          color: theme.text.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: theme.bg,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    _categoryLabel(update.category),
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: theme.text,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  update.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  update.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 11, color: AppColors.muted),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(update.updateDate),
                      style: const TextStyle(fontSize: 10, color: AppColors.muted, fontWeight: FontWeight.w500),
                    ),
                    if (update.source != null && update.source!.trim().isNotEmpty) ...[
                      const SizedBox(width: 6),
                      const Text('|', style: TextStyle(fontSize: 10, color: Color(0xFFCBD5E1))),
                      const SizedBox(width: 6),
                      const Icon(Icons.menu_book_outlined, size: 11, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          update.source!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10, color: AppColors.muted, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                    const Spacer(),
                    const Icon(
                      Icons.bookmark_border_rounded,
                      size: 16,
                      color: AppColors.muted,
                    ),
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
