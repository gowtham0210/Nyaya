# Porting Plan: `nisha-frontend` → `main`

Last updated: 2026-09-28
Owner: Gowtham
Source branch: `origin/nisha-frontend` (Basheer0106, 0b62f60..5c50b9d). Unrelated history — cannot be git-merged.

## Approach

Rebuild each feature in `main`'s structure (spec → view model/repository → screen → tests), using Nisha's code as reference for UI and API shapes. Follow `project-constitution.md`.

## Decisions (2026-09-28)

- Auth: phone + OTP (Firebase) only. Nisha's email/password login is not ported.
- Tabs: Home, Categories, Leaderboard, Articles, Profile. Bookmarks dropped for now.
- Languages: en, hi, ta, te, kn in v1, via `flutter_localizations` + `.arb` files.
- Backend: shared repo, runs locally only (port 5000). All data features must handle backend-down gracefully.
- Porting: done by Gowtham.

## Phase 0 — Housekeeping

1. Commit categories work; push `main`.
2. Fix or re-approve the 6 failing splash tests; add `test/**/failures/` to `.gitignore`.
3. Clone the backend repo; document how to run it in `README.md`.
4. Ask Basheer to base new work on `main`.

## Phase 1 — Foundation

| Spec | Scope | Reference |
|---|---|---|
| ADR 0002 | Data layer: `ApiClient` → repository → view model | `services/*`, `repositories/*` |
| ADR 0003 | Localization with `flutter_localizations` + `.arb` | `localization/*`, `state/app_language.dart` |
| 014-api-client | Shared HTTP client in `lib/core/network/`: base URL, auth token, error mapping, offline state | `api_exceptions.dart`, `auth/data/auth_api_client.dart` |
| 015-localization | `.arb` files for 5 languages; migrate existing screens' strings | `app_strings.dart`, `*_strings.dart` |
| 016-bottom-nav-shell | One tab shell (5 tabs, state kept per tab); replaces pushes in `post_sign_up_flow.dart` | `root_screen.dart`, `nyaya_tabs.dart` |

Also: move theme colors/shadows to `lib/core/presentation/`, add assets under `assets/<feature>/`, add packages only when a feature needs them.

## Phase 2 — Features

| # | Spec | Reference | Notes |
|---|---|---|---|
| 1 | 017-categories-remote | `categories_api_service`, `categories_repository` | Spec 013 UI stays; real data |
| 2 | 018-daily-questions (#29); 020 (#30), 026-home-progress-recommended (#31) | `daily_questions_section`, `legal_updates_section`, `ask_nyaya_card`, `learning_progress_card` | Add to existing Home |
| 3 | 019-articles (#32) | `articles_screen`, `article_detail_screen`, `article_accordion_item` | Articles tab |
| 4 | 020-legal-updates (#30) | `legal_updates_*` | Home section + see-all |
| 5 | 021-profile (#33) | `profile_screen`, `edit_profile_screen`, `initials_avatar`, `profile_api_service` | Real logout replaces test hack; language picker |
| 6 | 022-settings | notifications, privacy & security, about, `logout_screen` | Drop change-password (no passwords with OTP) |
| 7 | 023-help-resources | `help_resources_*`, `help_support_screen` | From Profile |
| 8 | 024-search-filters | `filter_sheet`, `filter_results_screen`, `nyaya_search_bar` | Needs 017 |
| 9 | 025-leaderboard | — (placeholder in Nisha) | New design needed |

Not ported: `login_screen`, `auth_api_service`, `auth_storage`, `placeholder_screen`, `main.dart`, desktop/web folders.

## Per-feature loop

1. Read Nisha's screen + service for UI and fields.
2. Write `spec.md` + `design.md` (FRs, ACs).
3. View model + repository with unit tests (fake `ApiClient`).
4. Screen with widget tests per AC; all new strings in `.arb`.
5. Wire into the tab shell; `flutter analyze` + `flutter test` green.
6. One commit per feature: "ported from nisha-frontend <sha>".

## Open questions

- Leaderboard: design and backend endpoint exist?
- Backend auth: `/auth/signup` (main) vs `/auth/register` (Nisha) — which is current?
- Does backend accept Firebase phone tokens for `/users/me/*`?
- Translations: who writes/reviews hi, ta, te, kn text?
