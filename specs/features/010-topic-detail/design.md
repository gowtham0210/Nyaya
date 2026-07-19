# 010-topic-detail Topic Detail Design Specification

Status: Implemented
Last Updated: 2026-07-19
Source Mockup: `mockups/ChatGPT Image Jul 18, 2026, 11_06_43 PM.png`
Design decisions: wayfinder tickets #6 (topic taxonomy) and #11 (approved screen prompt).

## Design Overview

A pushed full-screen topic page in the Nyaya language: ivory background, serif navy title with old-code subtitle, quiet section-reference strip, numbered white quiz cards with at-a-glance states, and a pinned gold continue CTA. Temple watermark right, bottom wave; no bottom nav.

## Visual Components

### 1. Top Bar
- Navy back arrow left (standard pop).
- Gold bookmark icon right: outline when unsaved, filled when saved.

### 2. Topic Header
- Title: `Arrest, Bail & Police Powers` — navy, serif, bold.
- Subtitle: `Under BNSS — formerly CrPC` — bodyGrey, 14sp.
- Metadata row: `6 quizzes` (bodyGrey) · `MEDIUM` chip (warm gold pill, white uppercase) · 44px gold progress ring with `33%` in navy.

### 3. Description
- Two-to-three lines, bodyGrey 14sp, 1.5 line height.

### 4. Section Strip
- Ivory-tint rounded strip (`#F7EFE2`), gold book icon, bodyGrey 13sp text: `Sections referenced: BNSS §35–§62 (formerly CrPC §41–§60)`. Quiet reference, not a banner.

### 5. Quiz List
- Serif `Quizzes` heading.
- White cards, 18px radius, muted border, soft shadow, 12px gaps.
- Left: 40px gold circle with white position number.
- Middle: bold navy 16sp title; `N Questions · Difficulty` bodyGrey 13sp.
- Right by status: green check circle (completed) / navy `RESUME` pill (in progress) / grey chevron (not started).
- Row semantics: explicit label with title, count, difficulty, status; child text excluded.

### 6. Pinned CTA
- Full-width gold pill, 54px, 30px radius: `CONTINUE QUIZ 2` — white bold uppercase, 1.5 tracking. Names the derived continue target.

### 7. Ornaments
- Temple watermark right (~12% opacity), `BackgroundWave` bottom; both excluded from semantics.

## Color and Type

Shared constants (`ivory`, `navy`, `gold`, `bodyGrey`, `progressTrack`); difficulty colors green `#1FA35B` / warm gold `#D19A2E` / red `#D64545` matching home; serif via `fontFamily: 'serif'`.

## Interaction

- Tap quiz row → `onQuizSelected(quizId)`.
- Tap CTA → `onContinueQuiz(continueQuizId)` (first in-progress, else first not-started).
- Tap bookmark → toggles saved state locally.
- List scrolls under the pinned CTA.

## Validation Checklist

- [x] Header, metadata row, description, and section strip match mockup copy.
- [x] Four quiz rows with correct states and affordances.
- [x] CTA names the continue target by position.
- [x] Bookmark toggles outline/filled.
- [x] Status semantics exposed; ornaments non-semantic.
