# 015-localization Five-Language Support

Status: Implemented
Last Updated: 2026-09-28
Owner: Gowtham
Related ADRs: `../../adr/0003-localization.md`
Source: GitHub issue #24, user stories 49–54.

## Problem

Many learners think in Hindi, Tamil, Telugu or Kannada. The app is English
only, so legal ideas are harder to follow.

## Goals

- The whole app in en, hi, ta, te, kn.
- The language switches instantly and is remembered.
- First launch follows the phone's language when supported.

## Non-Goals

- Right-to-left languages.
- Translating backend content in the app (the backend returns it in the
  requested `lang`).

## Actors

- Learner choosing a language.

## Assumptions

- Translations are drafted from Nisha's tables where they exist, otherwise
  machine-drafted, and reviewed by native speakers before release.

## Functional Requirements

- FR-001: The app shall support en, hi, ta, te and kn locales.
- FR-002: On first launch, the app shall use the device language when it is
  supported, otherwise English.
- FR-003: When the learner picks a language, the app shall rebuild in it
  immediately and remember it across launches.
- FR-004: Backend requests shall carry the chosen language (ADR 0002).
- FR-005: All user-facing strings shall come from ARB files.

## Non-Functional Requirements

- NFR-001: Adding a string requires only ARB edits; no code tables.

## Data and Integration Impact

- Local storage: `app.languageCode` in shared preferences.
- Remote APIs: `lang` query parameter.

## Acceptance Criteria

- AC-001: Each supported locale loads its strings.
- AC-002: A fresh install with a supported device locale starts in it.
- AC-003: An unsupported device locale falls back to English.
- AC-004: A saved choice is restored on launch.
- AC-005: Selecting a language updates the current locale and persists it.
- AC-006: Splash (including screen-reader text), Welcome, onboarding,
  sign-in, sign-up and OTP render in a non-English locale with translated
  text (issue #27).
- AC-009: Goal selection, Home, Categories, Topic detail, Quiz question and
  Quiz result render UI text in a non-English locale (issue #28). Sample
  learning content (topic, quiz and question text) stays as is.
- AC-008: Auth error messages are the backend's own message or localized
  app text, never an English fallback.
- AC-007: Sign-up shows localized professions but sends the backend a stable
  English value.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/core/localization/app_localizations_test.dart` |
| AC-002–AC-005 | Unit | `test/core/localization/app_language_test.dart` |
| AC-006 | Widget | `test/features/onboarding/presentation/onboarding_localization_test.dart`, `test/features/auth/presentation/auth_localization_test.dart` |
| AC-007, AC-008 | Unit | `test/features/auth/presentation/auth_text_test.dart` |
| AC-009 | Widget | `test/features/learning_localization_test.dart` |

## Open Questions

- Who reviews hi, ta, te, kn text before release? **Every non-English
  string needs native review.** Reused from `nisha-frontend` tables: nav
  labels, Sign in, Retry, Cancel, Coming soon, Law Student, Lawyer /
  Advocate, and the Phone Number / Password / Profession / Full Name field
  labels where her tables had them; for issue #28, View All, Resume,
  Notifications, and the question-count and Quizzes words. Everything else
  was machine-drafted.

## Notes

- Issue #27 unified the Welcome/auth tagline "LAW BASIC QUIZ APP" to the
  splash's "LAW BASED QUIZ APP", and changed the sign-in password hint from
  "Create a strong password" to "Enter your password".
- Issue #28: view models hold data only; pages build UI text from ARB.
  Goals became a `Goal` enum (stable `id`, localized title) like
  `Profession`. All-caps buttons use sentence-case keys upper-cased in code.
  `categoryQuizCount` was renamed `quizCount`, shared by Categories and
  Topic detail. Placeholder snackbars now say "… coming soon." instead of
  "… is not wired yet.".
