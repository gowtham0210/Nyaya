import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';

/// Professions offered at sign-up. [value] is what the backend stores, in
/// English whatever the app language; [label] is what the learner sees.
enum Profession {
  lawStudent('Law Student', Icons.school_outlined),
  lawyer('Lawyer / Advocate', Icons.balance_outlined),
  judge('Judge / Judicial Officer', Icons.gavel_rounded),
  legalProfessional('Legal Professional', Icons.work_outline_rounded),
  citizen('General Citizen', Icons.person_outline_rounded);

  const Profession(this.value, this.icon);

  final String value;
  final IconData icon;

  /// The profession the backend stored as [value], or null if unknown.
  static Profession? fromValue(String? value) {
    for (final profession in values) {
      if (profession.value == value) {
        return profession;
      }
    }
    return null;
  }

  String label(AppLocalizations l10n) => switch (this) {
    lawStudent => l10n.professionLawStudent,
    lawyer => l10n.professionLawyer,
    judge => l10n.professionJudge,
    legalProfessional => l10n.professionLegalProfessional,
    citizen => l10n.professionCitizen,
  };
}
