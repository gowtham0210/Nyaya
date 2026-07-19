# 012-quiz-result Quiz Result Summary Screen

Status: Implemented
Last Updated: 2026-07-19
Owner:
Related ADRs: `../../adr/0001-adopt-spec-driven-development.md`
Source: mockup `mockups/ChatGPT Image Jul 18, 2026, 11_19_16 PM.png`; wayfinder issue #12 (Prompt D — result summary).

## Problem

Finishing a quiz dead-ends: the last NEXT fires `onQuizCompleted` and the app silently pops back to topic detail. The learner never sees how they did or picks a next move.

## Solution

A full-screen result summary after the last question. A gold score ring is the hero ("9/12" with "75%" beneath); a serif "Well Done!" headline names the completed topic; a stats card shows correct and wrong counts; a strip reports how many questions were added to the weak list; two stacked CTAs let the learner review answers or return to the topic. It consumes the `List<QuizOutcome>` that `onQuizCompleted` already reports and replaces the current pop-back.

## Goals

- Score ring hero: `<correct>/<total>` fraction and rounded percent, derived from outcomes.
- Serif navy "Well Done!" headline with a grey "<topic> — completed" subline.
- Stats card with two columns: correct (green check) and wrong (red X), counts derived from outcomes.
- Weak-list strip: "N questions added to your weak list", N = wrong count; hidden when zero.
- Stacked CTAs: gold "REVIEW ANSWERS" and navy-outlined "BACK TO TOPIC".
- Replace the provisional pop-back: completion pushes this screen.

## Non-Goals

- **Time stat** — omitted this phase. The quiz session tracks no elapsed time and the `onQuizCompleted` seam carries only outcomes; the mockup's Time column is dropped until a real timer feature exists.
- Review answers screen (Phase 9) — REVIEW ANSWERS fires a callback wired provisionally (no-op) until it lands.
- Retry / weak-list persistence (Phase 10): the strip is derived-and-displayed only; nothing is written.
- Confetti/animation, share, ratings, streaks; result persistence; localization; score-band copy variants beyond the single "Well Done!" headline.

## Actors

- Learner who has just answered the last question of a quiz session.

## Assumptions

- `List<QuizOutcome>` is non-empty and ordered; each carries `isCorrect`.
- Correct = count where `isCorrect`; wrong = total − correct; percent = round(correct / total × 100).
- Topic title is supplied by the caller (the flow that launched the quiz); a sensible default covers the provisional wiring.

## Functional Requirements

- FR-001 Score ring hero shows `<correct>/<total>` and the rounded percent beneath, flanked by decorative gold laurels (excluded from semantics).
- FR-002 Serif navy "Well Done!" headline with a grey "<topic> — completed" subline.
- FR-003 Stats card, two columns: correct count with green check, wrong count with red X.
- FR-004 Weak-list strip "N questions added to your weak list" where N = wrong count; the strip is hidden when N is zero.
- FR-005 Gold full-width "REVIEW ANSWERS" pill invokes `onReviewAnswers`.
- FR-006 Navy-outlined full-width "BACK TO TOPIC" pill invokes `onBackToTopic`.
- FR-007 On quiz completion the app pushes this screen (replacing the pop-back); BACK TO TOPIC returns to topic detail.
- FR-008 The score ring, counts, and weak-list count are announced to screen readers; decorative laurels/ornaments are excluded.

## Non-Functional Requirements

- Injectable `QuizResultViewModel` per the established feature pattern; shared color/ornament constants from `nyaya_widgets` (never redefined). Serif headings via `fontFamily: 'serif'`.

## Data and Integration Impact

- Pure consumer of `List<QuizOutcome>`; no new persistence, no seam widening. `QuizQuestionPage.onQuizCompleted` is unchanged.
- `post_sign_up_flow._startQuiz` changes: `onQuizCompleted` pushes `QuizResultPage` (topic title from the launching topic) instead of popping; BACK TO TOPIC pops to topic detail; REVIEW ANSWERS is a provisional no-op.

## Acceptance Criteria

- AC-001 Given 9 correct of 12, the ring shows "9/12" and "75%".
- AC-002 Stats card shows correct and wrong counts matching the outcomes.
- AC-003 Weak-list strip shows the wrong count; with zero wrong, the strip is absent.
- AC-004 REVIEW ANSWERS invokes `onReviewAnswers`; BACK TO TOPIC invokes `onBackToTopic`.
- AC-005 Completing a live quiz session lands on this screen; BACK TO TOPIC returns to topic detail.
- AC-006 Ring, counts, and weak count are exposed to semantics; ornaments are not.

## Test Traceability

- `test/features/quiz_result/presentation/quiz_result_view_model_test.dart` — score/percent/correct/wrong/weak-count derivation, zero-wrong edge case, rounding.
- `test/features/quiz_result/presentation/quiz_result_page_test.dart` — AC-001 through AC-004 and AC-006 via keyed finders.

## Open Questions

- Headline is fixed "Well Done!" this phase; score-band copy variants (e.g. low-score encouragement) deferred pending copy.
- Weak-list wording assumes every wrong question is "added"; revisit when weak-list persistence (Phase 10) defines real membership.
