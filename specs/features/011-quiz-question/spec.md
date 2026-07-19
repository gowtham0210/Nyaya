# 011-quiz-question Quiz Question Screen

Status: Implemented
Last Updated: 2026-07-19
Owner:
Related ADRs: `../../adr/0001-adopt-spec-driven-development.md`
Source: GitHub issue #22 (Spec: Quiz question screen (Phases 6-7)); wayfinder decisions on issues #7 and #12.

## Problem

The learning loop the app is built around — answer an MCQ, get instant feedback, read why — had no screen.

## Goals

- Full-screen instant-feedback quiz loop: one MCQ at a time, answer locks on first tap.
- Correct pick turns green; wrong pick turns red while the correct option is revealed green.
- Inline three-part explanation card (verdict, plain-language core, legal reference, gold takeaway).
- Segmented progress bar and "Question N of M" counter; state-driven bottom bar.
- Session completion reports ordered per-question outcomes for the future result screen and weak-question retry.

## Non-Goals

- Result summary screen (Phase 8), review (Phase 9), retry (Phase 10), bookmarking from a question.
- Outcome persistence; real question sourcing; timers/exam mode; exit confirmation; localization.

## Actors

- Learner answering a quiz launched from topic detail.

## Assumptions

- MCQ-only, four options, one correct (question model decision).
- Sample content: 12 authored BNSS arrest/bail questions with the mockup's Ravi warrant question at position 4.

## Functional Requirements

- FR-001 Top bar: navy X (standard pop) left, grey counter centered; gold segmented progress bar beneath (one segment per question, filled through the current one).
- FR-002 Stem on a white card; four lettered option cards (A–D) with gold letter rings.
- FR-003 First tap locks: correct = green border/tint with white check badge; wrong = red border/tint with white X badge plus the correct option outlined green. Later taps are ignored.
- FR-004 Explanation card appears inline after answering: gold left accent; green "Correct!" or red "Not quite" verdict; core text; grey reference row and gold takeaway row rendered only when present.
- FR-005 Bottom bar: disabled grey "SELECT AN ANSWER" before answering; gold "NEXT" after.
- FR-006 NEXT advances to a fresh unanswered question; after the last question the session completes and reports ordered outcomes (question id, chosen option, correct/wrong).
- FR-007 `next()` is a no-op while unanswered; content scrolls so NEXT stays reachable.
- FR-008 Options announce letter, text, and state (your answer correct/wrong, correct answer) to screen readers.

## Non-Functional Requirements

- Injectable session view model per the established feature pattern; shared color constants.

## Data and Integration Impact

- `onQuizCompleted(outcomes)` is the integration surface for the Phase 8 result screen and Phase 10 retry. Provisional wiring: topic detail's quiz taps push this screen; completion pops back.

## Acceptance Criteria

- AC-001 Unanswered state renders stem, four options, counter, progress, disabled bar.
- AC-002 Correct pick shows "Correct!" card with reference and takeaway, and NEXT.
- AC-003 Wrong pick shows "Not quite" and reveals the correct option.
- AC-004 Locked answers ignore further taps.
- AC-005 NEXT advances with state reset; last NEXT fires the completion callback with ordered outcomes.
- AC-006 X exits the quiz; option semantics expose state.

## Test Traceability

- `test/features/quiz_question/presentation/quiz_session_view_model_test.dart` — session shape, locking, correctness, advancing, completion outcomes.
- `test/features/quiz_question/presentation/quiz_question_page_test.dart` — AC-001 through AC-006.

## Open Questions

- Golden test deferred until the splash golden baseline is fixed.
- Exit mid-session currently discards progress silently; revisit with persistence.
