# 028-language-picker Language Picker in Profile

Status: Implemented
Last Updated: 2026-09-29
Owner: Gowtham
Related ADRs: `../../adr/0003-localization.md`
Source: GitHub issue #35 (parent #24). Ported from `nisha-frontend`
(language section of `profile_screen`). Closes the "reload on language
change" non-goal of specs 017–020.

## Problem

Learners can't change the app language after the first launch.

## Goals

- Profile → Language lists the five languages in their own scripts.
- Picking one switches the whole app at once and is remembered.
- Backend content already on screen reloads in the new language.

## Assumptions

- `AppLanguage.select` persists the choice (spec 015) and the app's
  `MaterialApp` rebuilds from `AppLanguage.current`.
- `ApiClient` sends `lang` from the current language (ADR 0002).

## Functional Requirements

- FR-001: The picker shall list English, हिन्दी, தமிழ், తెలుగు, ಕನ್ನಡ,
  marking the current one (check icon and selected state).
- FR-002: Picking a language shall switch the app immediately and return
  to Profile.
- FR-003: The choice shall persist across launches.
- FR-004: When the language changes, categories, daily questions, legal
  updates and articles that have loaded shall reload; ones not yet opened
  load in the new language when opened.

## Acceptance Criteria

- AC-001: The picker lists the five names and marks the current one.
- AC-002: Tapping a language reports its code.
- AC-003: In the shell, picking Hindi shows Profile in Hindi and refetches
  categories with `lang=hi`.
- AC-004: A view model reloads on a language change only if it had loaded.
- AC-005: A saved language is restored on launch (existing
  `app_language_test.dart`).

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001, AC-002 | Widget | `test/features/settings/presentation/language_page_test.dart` |
| AC-003 | Widget | `test/app/main_shell_test.dart` |
| AC-004 | Unit | `test/core/presentation/load_state_notifier_test.dart` |
| AC-005 | Unit | `test/core/localization/app_language_test.dart` |
