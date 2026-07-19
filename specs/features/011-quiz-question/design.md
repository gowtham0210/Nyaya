# 011-quiz-question Quiz Question Design Specification

Status: Implemented
Last Updated: 2026-07-19
Source Mockups: `mockups/ChatGPT Image Jul 18, 2026, 11_09_46 PM.png` (unanswered), `11_14_18 PM.png` (correct), `11_17_46 PM.png` (wrong)
Design decisions: wayfinder tickets #7 (question and feedback model) and #12 (approved screen prompts).

## Design Overview

The instant-feedback loop on the ivory canvas: one MCQ, four lettered cards, answer locks on tap, feedback renders in place, explanation card slides in beneath the options. Full-screen session — no bottom nav.

## Visual Components

### 1. Top Bar and Progress
- Navy X left (exit, standard pop); grey `Question N of M` centered.
- Segmented progress bar: one 6px rounded segment per question, gold through the current question, track beige beyond.

### 2. Question Card
- White card, 20px radius, soft shadow; stem in bold navy 19sp, 1.4 line height.

### 3. Option Cards (A–D)
- White, 16px radius, muted border; 36px letter circle with gold ring, navy letter; option text navy 15sp.
- Locked correct: green 1.6px border, light green tint, letter circle becomes solid green with white check.
- Locked wrong: red border, light red tint, solid red circle with white X.
- Revealed correct (when the pick was wrong): green border and green letter ring on white.
- Semantics: explicit label "Option X. <text>. <state>"; child text excluded.

### 4. Explanation Card
- White, 16px radius, 4px gold left accent border.
- Verdict row: green check + "Correct!" or red X + "Not quite" (17sp bold).
- Core explanation bodyGrey 14sp 1.5; grey book-icon reference row ("BNSS §35 (formerly CrPC §41)"); gold scales-icon takeaway row. Reference/takeaway rows render only when the question has them.

### 5. Bottom Bar
- Before answering: full-width disabled pill, grey tint, `SELECT AN ANSWER` in grey uppercase.
- After: gold pill `NEXT`, white bold uppercase, 2.0 tracking, 54px, 30px radius.

## Sample Content

12 authored BNSS arrest/bail/FIR questions (citizen lens); the mockup's Ravi warrant question sits at position 4 with its exact copy, options, explanation, reference, and takeaway.

## Interaction

- Tap option → locks instantly; later taps ignored.
- NEXT → next question with fresh state; after the last, `onQuizCompleted(outcomes)` fires (provisionally pops back to topic detail until the Phase 8 result screen exists).
- X → exit the session.

## Validation Checklist

- [x] Three states match the three mockups (unanswered, correct, wrong-with-reveal).
- [x] Explanation card carries verdict, core, reference, takeaway with mockup styling.
- [x] Progress bar and counter track position.
- [x] Bottom bar is state-driven.
- [x] Option state semantics exposed.
