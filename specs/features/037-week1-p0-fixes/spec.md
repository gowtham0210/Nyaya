# 037-week1-p0-fixes Week 1 P0 Fixes

Status: Implemented
Last Updated: 2026-10-06
Owner: Gowtham
Related ADRs: `../../adr/0003-localization.md`
Source: UI/UX audit `docs/ui-audit/ui-ux-audit.md` §5 Week 1, items 2–5.

## Problem

Six visible bugs made the app look broken: quiz titles broke mid-word
("Fundamen-tal"), Home category tiles sat at different heights, the
"Leaderboar/d" nav label could wrap, the phone field took unlimited
digits, the result said "Well Done!" at 17%, and the answer explanation
sat hidden under the Next button.

## Non-Goals

- Making progress consistent across Home, topic and Profile (needs real
  attempt data; audit Week 1 item 6).
- Inline field errors on sign-in (still snackbars).
- Wiring Review answers (hidden since 035).

## Functional Requirements

- FR-001: Popular quiz titles shall use the card's full text width (max 2
  lines, ellipsis); the rating moves into the meta row as a small pill.
- FR-002: Home category tiles shall align at the top whatever their label
  length.
- FR-003: Bottom-nav labels shall stay on one line, scaling down to fit,
  with one fixed weight for active and inactive tabs.
- FR-004: Sign-in and sign-up phone fields shall show "+91", accept digits
  only and at most 10; sign-up and sign-in reject anything but 10 digits.
- FR-005: The result headline shall follow the score: ≥ 70% "Well Done!"
  (the mockup shows it at 9/12), 40–69% "Good progress!", < 40% "Keep
  going!", in all five languages.
- FR-006: After an answer, the explanation shall scroll into view above
  the footer; each new question starts at the top.

## Acceptance Criteria

- AC-001: Popular quiz layout (covered by the existing Home tests).
- AC-002: Category tiles share one top edge, even when only some labels
  wrap.
- AC-003: A long nav label is one line, no wrap, fixed weight.
- AC-004: A phone field keeps only the first 10 digits.
- AC-005: Bands map 100/75/70% → excellent, 60/40% → good, 17%/empty →
  keep going; a 2/12 page says "Keep going!".
- AC-006: After answering on a 667-pt-tall screen, the whole explanation
  sits above the footer.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-002 | Widget | Retired: spec 040 removed the sample tile strip and its test |
| AC-003 | Widget | `test/features/shell/presentation/tab_shell_page_test.dart` |
| AC-004 | Widget | `test/features/auth/presentation/widgets/auth_text_field_test.dart` |
| AC-005 | Unit / Widget | `quiz_result_view_model_test.dart`, `quiz_result_page_test.dart`, `learning_localization_test.dart` (Kannada) |
| AC-006 | Widget | `test/features/quiz_question/presentation/quiz_question_page_test.dart` |
| AC-001 | Manual | Pending: the section is hidden (035) and the simulator was off at the owner's request |

The AC-002 and AC-006 tests were checked to fail with the fix removed.
