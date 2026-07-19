# 010-topic-detail Topic Detail Screen

Status: Implemented
Last Updated: 2026-07-19
Owner:
Related ADRs: `../../adr/0001-adopt-spec-driven-development.md`
Source: GitHub issue #21 (Spec: Topic detail screen (Phase 5)); wayfinder decisions on issues #6 and #11.

## Problem

A learner who has found a topic has nowhere to see what it covers, its statute grounding, which quizzes it contains, or where to resume before committing.

## Goals

- Full-screen topic detail (no bottom nav) with header, description, section-mapping strip, quiz list, and pinned continue CTA.
- Quiz states readable at a glance: completed check, in-progress Resume pill, not-started chevron.
- Derived continue target: first in-progress quiz, else first not-started.
- Bookmark icon toggling saved state (presentation-only).

## Non-Goals

- Topics tab / select-topic screen and route wiring into this page.
- Quiz engine; taps only report intent via callbacks.
- Bookmark persistence; real data sourcing; all-completed CTA state; localization.

## Actors

- Learner reviewing a topic before starting or resuming its quizzes.

## Assumptions

- Sample data is the approved mockup's BNSS topic until real data exists.
- New-code-first naming with old-code subtitles (taxonomy decision).

## Functional Requirements

- FR-001 Navy back arrow (standard pop) left; gold bookmark icon right, toggling filled/outline.
- FR-002 Serif navy title, grey old-code subtitle, metadata row: quiz count, difficulty chip, gold progress ring with percent.
- FR-003 Plain-language description in body grey.
- FR-004 Quiet ivory section strip: "Sections referenced: BNSS §35–§62 (formerly CrPC §41–§60)".
- FR-005 Numbered quiz rows with gold badge, bold title, "N Questions · difficulty" metadata, and status affordance (check / RESUME pill / chevron).
- FR-006 Tapping a row reports the quiz id; the pinned gold CTA labels the continue target by position ("CONTINUE QUIZ 2") and reports its id.
- FR-007 Quiz list scrolls under the pinned CTA.
- FR-008 Quiz rows announce title, question count, difficulty, and status to screen readers.

## Non-Functional Requirements

- Shared color constants and ornaments from the core widget library; serif headings match auth and goal selection.
- Injectable plain view model per the established feature pattern.

## Data and Integration Impact

- None; in-memory sample data. Callbacks (`onQuizSelected`, `onContinueQuiz`) are the integration surface for the quiz engine and Topics tab.

## Acceptance Criteria

- AC-001 Header, description, and section strip render with exact mockup copy.
- AC-002 Four quiz rows render with correct states (1 completed, 2 in progress, 3–4 not started).
- AC-003 Tapping a quiz row reports its id.
- AC-004 The CTA reads "CONTINUE QUIZ 2" and reports the in-progress quiz id.
- AC-005 Bookmark toggles between outline and filled.
- AC-006 Quiz rows expose status semantics.

## Test Traceability

- `test/features/topic_detail/presentation/topic_detail_view_model_test.dart` — topic data, quiz order/statuses, continue target, bookmark toggle.
- `test/features/topic_detail/presentation/topic_detail_page_test.dart` — AC-001 through AC-006.

## Open Questions

- Golden test deferred until the splash golden baseline is fixed.
- CTA behavior when every quiz is completed.
