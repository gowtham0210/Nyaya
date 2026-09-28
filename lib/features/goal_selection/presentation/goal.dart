import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';

/// Learning goals offered after sign-up. [id] is the stable value passed on;
/// [title] and [description] are what the learner sees.
enum Goal {
  learnLawForLife('learn-law-for-life', Icons.balance),
  crackAnExam('crack-an-exam', Icons.emoji_events_outlined),
  studyLaw('study-law', Icons.school_outlined);

  const Goal(this.id, this.icon);

  final String id;
  final IconData icon;

  String title(AppLocalizations l10n) => switch (this) {
    learnLawForLife => l10n.goalLearnLawTitle,
    crackAnExam => l10n.goalExamTitle,
    studyLaw => l10n.goalStudyTitle,
  };

  String description(AppLocalizations l10n) => switch (this) {
    learnLawForLife => l10n.goalLearnLawBody,
    crackAnExam => l10n.goalExamBody,
    studyLaw => l10n.goalStudyBody,
  };
}
