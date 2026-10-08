# 034-brand-typography Brand Typography

Status: Implemented
Last Updated: 2026-10-04
Owner: Gowtham
Related ADRs: `../../adr/0003-localization.md`
Source: UI/UX audit `docs/ui-audit/ui-ux-audit.md` §3.1 (priority 1).

## Problem

The app ships no fonts. The mockups' serif headings render in the system
sans, 12 files ask for a `'serif'` family that iOS doesn't resolve, and
Material 3's Roboto-tuned letter-spacing makes body text look loose. The
app reads as generic, not premium.

## Goals

- Bundle a serif for headings and a sans for UI text.
- One type scale in the theme; headings use the serif.
- No extra tracking on body text; sentence-case buttons.
- No broken `'serif'` references left.

## Non-Goals

- Moving every raw `fontSize` to named theme styles (audit step 8, design
  system). This spec only snaps off-scale sizes onto the scale.
- Colors, spacing, radii (separate audit items).
- Bundling Indic fonts.

## Decisions

- **Cormorant Garamond** (500/600/700) for display and headlines: the
  closest free match to the mockups. **Inter** (400–700) for everything
  else. Both are OFL, bundled as static TTFs in `assets/fonts/` (no
  runtime download, works offline).
- Hindi, Tamil, Telugu and Kannada fall back to the platform's system
  fonts, as before. This keeps the app about 2.2 MB smaller than bundling
  Noto, and the scripts were already rendering correctly.
- Cormorant looks smaller than a sans at the same size, so serif headings
  are about 15–25% larger than the sans sizes they replace.

## Functional Requirements

- FR-001: The theme shall use Inter as the default family and Cormorant
  Garamond for display and headline styles.
- FR-002: Body, title and label-large styles shall have zero letter
  spacing.
- FR-003: Page titles, section headings, profile name and stats, the
  result score and headline, and the article title shall use the serif.
- FR-004: Primary buttons shall show sentence-case labels at 16 pt with no
  extra tracking.
- FR-005: The about/licenses page shall include both fonts' OFL licenses.
- FR-006: Text in Hindi, Tamil, Telugu and Kannada shall still render.

## Acceptance Criteria

- AC-001: Display and headline styles use the serif; title, body and label
  styles use the sans.
- AC-002: Body and title styles have zero tracking.
- AC-003: The app theme and plain `Text` default to the sans with no
  tracking.
- AC-004: CTA labels are sentence case (quiz, goal, topic, result).
- AC-005: Layouts still fit large text and Indic scripts.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001–AC-003 | Unit / Widget | `test/app/theme/app_typography_test.dart` |
| AC-004 | Widget | `quiz_question_page_test`, `goal_selection_page_test`, `topic_detail_page_test`, `learning_localization_test` |
| AC-005 | Widget | `articles_page_test` (large text), `onboarding_localization_test` (Telugu), `quiz_result_page_test` |
| FR-005, FR-006 | Manual | iOS simulator: Language page shows all scripts; screenshots in `docs/ui-audit/after-034/` |

FR-005 and FR-006 are manual because widget tests render text with the
test font, not the bundled or system fonts.
