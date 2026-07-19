# 012-quiz-result Quiz Result Summary Design Specification

Status: Implemented
Last Updated: 2026-07-19
Source Mockup: `mockups/ChatGPT Image Jul 18, 2026, 11_19_16 PM.png`
Design decisions: wayfinder issue #12 (Prompt D — result summary, approved).

## Design Overview

A calm celebratory summary on the ivory canvas, full-screen with no bottom nav. The gold score ring is the visual hero — larger than anything else — flanked by decorative gold laurels. Below it a serif headline, a stats card, a weak-list strip, and two stacked CTAs.

## Visual Components (top to bottom)

### 1. Score Ring Hero
- Large gold circular ring; inside, `<correct>/<total>` in serif navy (the fraction is the biggest type on screen), a thin gold divider, then the rounded percent beneath in serif navy.
- Decorative gold laurel branches flank the ring; laurels and stray sparkle ornaments are excluded from semantics.

### 2. Headline
- Serif navy "Well Done!" with a short gold divider ornament beneath.
- Grey subline "<topic> — completed" (e.g. "Arrest & Your Rights — completed").

### 3. Stats Card
- White card, rounded, soft shadow; two equal columns split by a hairline divider.
- Correct: green check icon over the count (green) over "CORRECT" (navy caps).
- Wrong: red X icon over the count (red) over "WRONG" (navy caps).
- Time column from the mockup is omitted this phase (see spec Non-Goals).

### 4. Weak-List Strip
- Slim ivory strip, gold bookmark/star icon, text "N questions added to your weak list" with the count in gold.
- Hidden entirely when the wrong count is zero.

### 5. CTAs
- Gold full-width pill "REVIEW ANSWERS", white bold uppercase, ~54px, 30px radius, letter-spaced.
- Below it a navy-outlined full-width pill "BACK TO TOPIC", navy bold uppercase, transparent fill, same size.

## Derivations (view model)

- `correctCount` = outcomes where `isCorrect`; `wrongCount` = total − correct; `total` = outcomes length.
- `scoreLabel` = "<correct>/<total>"; `percentLabel` = "<round(correct/total×100)>%".
- `weakCount` = `wrongCount`; `showWeakStrip` = `weakCount > 0`.
- `headline` = fixed "Well Done!" this phase.

## Interaction

- REVIEW ANSWERS → `onReviewAnswers` (provisional no-op until Phase 9).
- BACK TO TOPIC → `onBackToTopic` (pops to topic detail).
- Reached by `onQuizCompleted` pushing this screen, replacing the old pop-back.

## Keys (for widget tests)

- `result.ring`, `result.score`, `result.percent`, `result.correct`, `result.wrong`, `result.weakstrip`, `result.review`, `result.backtotopic`.

## Validation Checklist

- [ ] Ring is the largest element; fraction + percent match outcomes.
- [ ] Stats card shows correct/wrong counts; no Time column.
- [ ] Weak strip shows wrong count and hides at zero.
- [ ] Both CTAs invoke their callbacks.
- [ ] Ring/counts exposed to semantics; laurels and ornaments excluded.
