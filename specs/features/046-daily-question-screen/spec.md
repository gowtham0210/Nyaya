# 046-daily-question-screen Today's Question: Home Card + Own Screen

Status: Implemented
Last Updated: 2026-10-06
Owner: Gowtham
Extends: `../045-daily-question-today/spec.md`

## Problem

The full question (options, verdict, explanation) filled the first Home
screen and pushed everything else down.

## Decisions

- Home shows a compact card (≈100 pt): gold bulb, "Today's Question", a
  one-line question preview, "category · +10 points" and an "Answer now"
  pill. With large text the pill moves below.
- Answered: green check / red cross, "Answered · Correct!" (or "Not
  quite"), "+10 earned · New question tomorrow", chevron.
- Tapping a loaded card opens `DailyQuestionPage` (app bar title + the
  045 view). It shares Home's view model, so answering updates the card.
- Loading: a two-line skeleton. Empty: a quiet, non-tappable card. Failed:
  one line with Retry.

## Acceptance Criteria

- AC-001: The card shows the preview and Answer now, no options; it is a
  labelled button under 140 pt tall.
- AC-002: Tap → screen → answer → back: the card shows the result.
- AC-003: An answered day shows the result; no question shows a quiet card
  that doesn't open.
- AC-004: Offline shows Retry, which loads; large text fits; Hindi.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001–AC-004 | Widget | `test/features/home/presentation/daily_questions_section_test.dart`, `learning_localization_test.dart` |
| 045 flows on the screen | Widget | `test/features/home/presentation/daily_question_page_test.dart` |
