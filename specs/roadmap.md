# Nyaya Product Roadmap

Last updated: 2026-04-26
Source: `specs/Nyaya Quiz App User Flow.png`

## Roadmap Principle

Implement Nyaya in thin vertical slices that follow the user flow from left to
right. Each phase should be small enough to spec, build, test, and review
independently.

## Phase 0. App Foundation

Goal: establish the app shell and shared infrastructure.

Deliverables:

- app bootstrap, theme, navigation shell
- feature folder conventions under `lib/features/`
- baseline analytics, error logging, and local persistence strategy ADRs

## Phase 1. Splash and Onboarding

Goal: deliver the first-run education flow.

Deliverables:

- splash screen
- onboarding 1: value proposition
- onboarding 2: how learning works
- onboarding 3: trust and motivation

## Phase 2. Authentication Entry

Goal: handle the account decision cleanly.

Deliverables:

- `User has account?` decision flow
- login screen
- create-account screen
- session bootstrap and auth state handling

## Phase 3. Goal and Exam Track Selection

Goal: personalize the experience immediately after sign-up.

Deliverables:

- choose-goal flow
- choose exam track flow
- persistence of selected study direction

## Phase 4. Home and Learning Path

Goal: give the user a stable study starting point after authentication.

Deliverables:

- home / learning path screen
- next-action surface
- bottom navigation shell for Quiz, Nyaya AI / Learn, and Profile

## Phase 5. Topic Discovery

Goal: let users enter practice through structured legal topics.

Deliverables:

- select law topic screen
- topic detail screen
- progress, difficulty, and quiz set summaries

## Phase 6. Quiz Start and Question Engine

Goal: enable a minimal end-to-end quiz loop.

Deliverables:

- start quiz flow
- quiz question screen
- answer selection state
- guardrails for unanswered questions

## Phase 7. Instant Feedback Loop

Goal: close the loop on each question.

Deliverables:

- correct / incorrect feedback state
- move-to-next-question behavior
- question progress handling across a set

## Phase 8. Quiz Completion

Goal: finish a quiz set with understandable outcomes.

Deliverables:

- `More questions?` decision handling
- quiz result summary
- score, accuracy, and completion status presentation

## Phase 9. Review and Explanations

Goal: convert quiz output into learning.

Deliverables:

- review answers and explanations screen
- per-question explanation display
- navigation between answered questions

## Phase 10. Weak-Question Retry

Goal: turn mistakes into targeted follow-up practice.

Deliverables:

- identify weak or incorrect questions
- retry weak questions entry point
- filtered quiz restart flow

## Phase 11. Notes and Bookmarks

Goal: let users retain useful learning artifacts.

Deliverables:

- save notes action from relevant learning surfaces
- notes / bookmarks screen
- retrieval and management of saved items

## Phase 12. Nyaya AI / Learn

Goal: support concept-first learning that leads back into practice.

Deliverables:

- ask legal concept question screen
- AI explanation response view
- related-quiz handoff into the quiz flow

## Phase 13. Profile and Motivation

Goal: expose progress identity and account context.

Deliverables:

- profile overview
- streaks and badges
- settings summary

## Phase 14. Goal, Language, and Notifications

Goal: let users tune their study experience.

Deliverables:

- edit goal flow
- language preferences
- notification preferences

## Phase 15. Flow Hardening

Goal: make the entire product reliable enough for repeated use.

Deliverables:

- resume interrupted sessions
- empty, loading, and error states across major paths
- instrumentation for funnel drop-off and quiz completion
- accessibility and performance passes on core journeys

## Recommended Build Order

Prioritize the first usable learning loop before optional depth:

1. Phases 0 through 4
2. Phases 5 through 9
3. Phase 10
4. Phases 11 and 12
5. Phases 13 through 15

## Spec Mapping Rule

Each roadmap phase should become one or more numbered feature specs under
`specs/features/` before implementation starts.
