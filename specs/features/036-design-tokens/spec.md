# 036-design-tokens Design Tokens

Status: Implemented
Last Updated: 2026-10-06
Owner: Gowtham
Related ADRs: —
Source: UI/UX audit `docs/ui-audit/ui-ux-audit.md` §3.2–3.3 (priority 3).

## Problem

58 hard-coded colors (5 navies, 7 golds) across 29 files, a theme seeded
from orange (`0xFFD66A33`), 16 corner radii, rainbow category pastels, red
for "Hard" and for the "Soon" pill, and a card that renders grey with
square shadow corners. Screens look close to each other but not the same.

## Goals

- One token file holds every color, radius, spacing step and shadow.
- An explicit navy/gold color scheme drives Material defaults.
- Brand-safe tones replace rainbow pastels; red means only "wrong/error".
- A test stops new hex colors appearing outside the theme.

## Non-Goals

- Moving every `EdgeInsets`/`SizedBox` onto `NyayaSpace` (tokens exist;
  adoption is incremental).
- Moving the remaining 10 ad-hoc `BoxShadow`s onto `NyayaShadows`.
- Dark mode.

## Decisions

- `lib/app/theme/app_tokens.dart`: `NyayaColors`, `NyayaTones`,
  `NyayaDifficulty`, `NyayaRadii`, `NyayaSpace`, `NyayaShadows`.
- Ivory is `#FBF7F1` (the splash's approved warm cream, closest to the
  mockups), so the splash golden is unchanged.
- Radii: 10–16 → `sm` 12, 18–26 → `md` 20, 30/999 → `pill`, 6–8 → `xs`.
  Three tiny ornament radii (1.2, 2, 3) stay literal.
- Tones: navy, bronze, slate, olive, plum, teal, clay (tint + ink each).
  Categories, legal-update types and avatars use them.
- Difficulty: easy = success green, medium = deep gold, hard = clay.

## Functional Requirements

- FR-001: No `Color(0x…)` or 8-digit hex shall appear in `lib/` outside
  `lib/app/theme/`.
- FR-002: The theme shall use an explicit color scheme: primary ink,
  secondary gold, error danger, no surface tint.
- FR-003: Snackbars shall float on ink with rounded corners; app bars,
  progress, inputs and cards shall use brand tokens.
- FR-004: Category tiles, update chips and avatars shall use brand tones.
- FR-005: Difficulty and "Soon" shall never use the danger red.
- FR-006: The popular-quiz card shall be white with its shadow outside the
  clipped material.

## Acceptance Criteria

- AC-001: A source scan finds no hex colors outside the theme folder.
- AC-002: The scheme is navy/gold, not seeded orange.
- AC-003: Snackbars float on ink.
- AC-004: Difficulty colors are never the danger red.
- AC-005: Existing widget and golden tests still pass.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001–AC-004 | Unit | `test/app/theme/design_tokens_test.dart` |
| AC-005 | Widget / Golden | full suite, incl. `splash_page_golden_test.dart`, `initials_avatar_test.dart` |
| FR-004, FR-006 | Manual | Pending: simulator check was skipped at the owner's request (2026-10-06) |
