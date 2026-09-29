# 009-goal-selection Goal Selection Design Specification

Status: Implemented
Last Updated: 2026-07-19
Source Mockup: `mockups/ChatGPT Image Jul 18, 2026, 10_52_40 PM.png`
Design decisions: wayfinder tickets #5 (goal taxonomy) and #9 (approved screen prompt).

## Design Overview

A single onboarding decision screen in the established Nyaya language: ivory background, serif navy/gold heading, three selectable white cards, gold pill CTA, and the recurring ornaments (dot grid, sparkle, temple watermark, bottom wave).

## Visual Components

### 1. Top Bar
- Navy back arrow left (standard pop).
- 4-segment gold `PageIndicator` right, last segment active (final onboarding step).

### 2. Heading Block
- Line 1: `What brings you` — navy, serif, bold, centered.
- Line 2: `to Nyaya?` — gold, serif, bold, centered.
- Helper: `Choose your goal — you can change it anytime.` — bodyGrey sans, 14sp.

### 3. Goal Cards (3, stacked)
- White, ~20px radius, soft shadow, 16px padding; 16px gaps.
- Left: 56×56 icon tile, `#F7EAD2` fill, 14px radius, navy icon (scales / trophy / graduation cap).
- Middle: bold navy 18sp title + bodyGrey 13sp description.
- Right: 28px radio — unselected: grey outlined circle; selected: gold filled circle with white check.
- Selected card: gold border 1.6px, `#FDF6E9` tint.
- Copy:
  - `Learn law for life` / `Everyday legal know-how for work, family and your rights` (default selected)
  - `Crack an exam` / `Sharpen exam-style MCQ practice and statute mastery`
  - `Study law` / `Master your LLB subjects, concept by concept`

### 4. CTA and Footnote
- `CONTINUE` — full-width gold pill, 54px, white bold uppercase, 1.5 tracking, 30px radius.
- Footnote: `You can switch goals later in Profile.` — bodyGrey 13sp, centered.

### 5. Background Ornaments
- Dot grid top-left (`DotPattern`), gold sparkle star, temple watermark right at ~12% opacity, `BackgroundWave` bottom. All excluded from semantics.

## Color and Type

Uses the shared constants from `nyaya_widgets.dart` (`ivory`, `navy`, `gold`, `bodyGrey`); serif via `fontFamily: 'serif'` on headings, matching auth screens.

## Interaction

- Tap card → selection moves (single-select radio behavior with mutually exclusive semantics).
- Tap CONTINUE → `onContinue(selectedGoalId)`; app shell replaces the route with home.
- Screen scrolls when space runs out; CONTINUE always reachable.

## Validation Checklist

- [x] Heading, helper, three cards, CTA, footnote match mockup copy exactly.
- [x] Default selection on "Learn law for life" with gold border + check.
- [x] Back arrow and 4-segment progress indicator present.
- [x] Temple, sparkle, dot-grid, wave ornaments present and non-semantic.
- [x] Selection semantics exposed as a mutually exclusive group.
