# ADR 0003 Localization with gen-l10n and ARB Files

Status: Accepted
Date: 2026-09-28
Supersedes:
Superseded By:

## Context

Version 1 must ship in English, Hindi, Tamil, Telugu and Kannada. The
`nisha-frontend` branch used a hand-written `tr('key')` table with one list
per key (`[en, hi, ta, te, kn]`) and a global language notifier. `main` had
hard-coded English strings.

## Options Considered

1. Flutter's `flutter_localizations` + `gen-l10n` with one ARB file per
   language.
2. Port Nisha's `tr()` table as-is.
3. A third-party package (easy_localization, slang).

## Decision

Adopt option 1.

- ARB files live in `lib/l10n/`; `app_en.arb` is the template.
- Code reads strings with `context.l10n.<key>`. When no localization
  delegate is present (plain widget tests), it falls back to English.
- `AppLanguage` holds the chosen locale, persists it in shared preferences,
  and defaults to the device language when supported, else English.
- The backend receives the same language as `lang=<code>` (ADR 0002).
- Nisha's tables are the source for translated text of ported screens.

## Consequences

- Positive: Compile-time checked keys, plurals and placeholders; Material
  widgets (date pickers, dialogs) localize too.
- Positive: Standard tooling; translators can edit ARB files directly.
- Negative: Each new string touches five files.
- Negative: Translations for `main`'s original screens are machine-drafted
  and need native-speaker review.

## Links

- `../features/015-localization/spec.md`
