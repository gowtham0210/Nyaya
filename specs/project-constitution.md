# Nyaya Project Constitution

Last updated: 2026-04-26

## 1. Spec Before Code

Every material feature starts with a written spec in `specs/features/` before
implementation begins. Emergency bug fixes may start with code first, but they
must be backfilled with a spec update or bug record immediately afterward.

## 2. Requirements Must Be Testable

Functional requirements should use constrained natural language whenever
practical. Prefer EARS-style statements:

- `When <trigger>, the Nyaya app shall <response>.`
- `While <state>, the Nyaya app shall <response>.`
- `If <condition>, the Nyaya app shall <response>.`

Avoid vague language such as "fast", "simple", and "user friendly" unless the
spec makes them measurable.

## 3. Acceptance Criteria Must Trace to Tests

Each acceptance criterion needs at least one planned verification path:

- unit test
- widget test
- integration test
- manual verification only when automation is not yet practical

If a criterion is intentionally not automated, the spec must say why.

## 4. Significant Technical Choices Require ADRs

Write an ADR when choosing or changing:

- app architecture
- state management
- persistence
- API contracts
- auth or security boundaries
- offline behavior
- observability
- third-party platform dependencies

ADRs are append-only. If a decision changes, write a new ADR that supersedes the
old one.

## 5. Flutter Code Must Preserve Clear Boundaries

Nyaya follows Flutter's feature-oriented structure:

- `lib/app/` for bootstrap and shared theme
- `lib/features/<feature>/` for feature views and feature-local logic
- `test/` mirrors `lib/`

Views should stay focused on presentation. Business rules and reusable logic
must not spread arbitrarily across widget trees.

## 6. Done Means Specs, Code, and Tests Agree

A change is not done when only code compiles. It is done when:

- the feature spec is updated
- the plan still matches the shipped design
- tasks are complete
- tests cover the acceptance contract
- ADRs capture significant decisions
- `flutter analyze` and `flutter test` pass
