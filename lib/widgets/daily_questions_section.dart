import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../models/daily_question.dart';
import '../state/app_language.dart';
import '../repositories/daily_questions_repository.dart';
import '../screens/login_screen.dart';
import '../services/api_exceptions.dart';
import '../theme/app_colors.dart';

enum _Status { loading, unauthenticated, error, empty, loaded }

/// "Daily Questions" — entirely driven by GET /api/v1/daily-questions/random
/// via [DailyQuestionsRepository]. Two real questions, chosen at random by
/// the backend on every load; no sample/fallback content.
class DailyQuestionsSection extends StatefulWidget {
  const DailyQuestionsSection({super.key});

  @override
  State<DailyQuestionsSection> createState() => _DailyQuestionsSectionState();
}

class _DailyQuestionsSectionState extends State<DailyQuestionsSection> {
  final _repository = DailyQuestionsRepository();

  _Status _status = _Status.loading;
  List<DailyQuestion> _questions = const [];
  String? _errorMessage;
  int? _expandedId;

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
      final questions = await _repository.getRandom(count: 2);
      setState(() {
        _questions = questions;
        _status = questions.isEmpty ? _Status.empty : _Status.loaded;
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

  static const _badgeColors = [AppColors.navy, Color(0xFFB9823A)];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.beigeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                child: const Icon(Icons.lightbulb_outline, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr('title_daily_questions'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.navy)),
                    const SizedBox(height: 3),
                    Text(
                      tr('daily_questions_subtitle'),
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              if (_status == _Status.loaded)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.goldLight, borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    '${_questions.length} ${_questions.length == 1 ? tr('word_question') : tr('word_questions')}',
                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.navy),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case _Status.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );

      case _Status.unauthenticated:
        return _StatusRow(
          icon: Icons.lock_outline,
          message: tr('msg_signin_daily'),
          actionLabel: tr('button_sign_in'),
          onAction: _openSignIn,
        );

      case _Status.error:
        return _StatusRow(
          icon: Icons.wifi_off_rounded,
          message: _errorMessage ?? tr('msg_error_daily_default'),
          actionLabel: tr('button_retry'),
          onAction: _load,
        );

      case _Status.empty:
        return _StatusRow(icon: Icons.inbox_outlined, message: tr('msg_empty_daily'));

      case _Status.loaded:
        return Column(
          children: [
            for (var i = 0; i < _questions.length; i++) ...[
              _QuestionTile(
                number: i + 1,
                badgeColor: _badgeColors[i % _badgeColors.length],
                question: _questions[i],
                expanded: _expandedId == _questions[i].id,
                onToggle: () => setState(() {
                  _expandedId = _expandedId == _questions[i].id ? null : _questions[i].id;
                }),
              ),
              if (i != _questions.length - 1) const SizedBox(height: 10),
            ],
          ],
        );
    }
  }
}

class _QuestionTile extends StatelessWidget {
  const _QuestionTile({
    required this.number,
    required this.badgeColor,
    required this.question,
    required this.expanded,
    required this.onToggle,
  });

  final int number;
  final Color badgeColor;
  final DailyQuestion question;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onToggle,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: expanded ? AppColors.gold : AppColors.beigeBorder, width: expanded ? 1.3 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
                    child: Text('$number', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.question,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.navy, height: 1.4),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: badgeColor.withValues(alpha: 0.35)),
                          ),
                          child: Text(
                            question.category,
                            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: badgeColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                    child: AnimatedRotation(
                      turns: expanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.navy),
                    ),
                  ),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border(left: BorderSide(color: badgeColor, width: 3)),
                  ),
                  child: Text(
                    question.answer,
                    style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.icon, required this.message, this.actionLabel, this.onAction});

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.muted, size: 24),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        if (actionLabel != null) ...[
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            child: Text(actionLabel!),
          ),
        ],
      ],
    );
  }
}
