# Spec-Driven Development for Nyaya

Reviewed on 2026-04-26.

## Why Nyaya should use SDD

Nyaya is starting from a nearly blank Flutter app. That is the best time to make
specifications the source of truth instead of treating them as throwaway notes.
For this project, "spec-driven" means:

- each meaningful feature starts with a written spec before implementation
- acceptance criteria are explicit and traceable to tests
- architecture decisions are captured in ADRs near the codebase
- code structure matches the boundaries described in the spec

This keeps product intent visible even when the implementation changes.

## Research Summary

### 1. Keep specs as the primary artifact

The current Spec Kit documentation and spec-driven literature both argue for the
same inversion: specifications define intent first, then plans, tasks, and code
follow from that intent. That fits Nyaya because the app is still small enough
to establish the habit before feature growth makes retroactive cleanup expensive.

### 2. Write requirements in constrained natural language

Alistair Mavin's official EARS guidance is a practical fit for a mobile app
team. It keeps requirements readable while reducing ambiguity. We will use
lightweight EARS phrasing in feature specs:

- `When <trigger>, the Nyaya app shall <response>.`
- `While <state>, the Nyaya app shall <response>.`
- `If <condition>, the Nyaya app shall <response>.`

### 3. Use Flutter's current recommended architecture

Flutter's official architecture guidance recommends clear separation of
responsibilities, UI logic separated from business/data concerns, and feature
oriented organization in the UI layer. The official case study also recommends
that `test/` mirrors `lib/`. That is the most maintainable fit for Nyaya's
future growth.

### 4. Make tests the executable acceptance contract

Flutter's testing guidance still recommends the same pyramid:

- many unit and widget tests
- fewer integration tests for critical user flows

Nyaya should map each acceptance criterion to at least one planned test, then
keep the mapping in the feature spec.

### 5. Record irreversible technical decisions in ADRs

Google Cloud and Microsoft both recommend lightweight ADRs stored with the
workload documentation and maintained as append-only history. That is a good
fit for architecture, state management, API contract, persistence, auth, and
offline decisions in this app.

## Adopted Workflow

### Step 1. Create a feature folder

Run:

```bash
dart run tool/new_feature_spec.dart "Feature Name"
```

This creates a numbered folder in `specs/features/` with:

- `spec.md`
- `plan.md`
- `tasks.md`

### Step 2. Write the feature spec before code

The spec must include:

- problem and goals
- non-goals
- actors and assumptions
- functional requirements with IDs
- non-functional requirements
- acceptance criteria with IDs
- test traceability

Requirements should use EARS-style structure wherever practical.

### Step 3. Write the technical plan

The plan translates the approved spec into implementation detail:

- architecture and boundaries
- affected files
- state and data flow
- API or persistence contracts
- test plan
- rollout and rollback notes when applicable

### Step 4. Add ADRs for significant choices

Create or update an ADR when a change involves:

- architecture shape
- state management
- data storage
- authentication or authorization
- networking or API contracts
- observability
- performance or offline strategy

### Step 5. Break work into tasks

Tasks should be small enough to implement and review independently. Every task
must point back to a spec or plan section.

### Step 6. Implement with traceability

Implementation should reference the feature ID in commit or PR text, and test
names should reference acceptance criteria when that makes sense.

### Step 7. Verify and close the feature

At minimum:

```bash
flutter analyze
flutter test
```

For user-critical journeys, add `integration_test/` coverage before release.

## Repo Conventions

- All feature specs live under `specs/features/NNN-feature-slug/`.
- ADRs live under `specs/adr/`.
- Tests should mirror `lib/` paths as the codebase grows.
- The current baseline feature is `001-home-shell`.
- If implementation meaningfully diverges from a spec, update the spec first or
  immediately after the decision, not weeks later.

## Definition of Done

A feature is done only when:

- the spec status is no longer `Draft`
- the plan reflects the shipped design
- tasks are checked off
- code and tests are merged
- ADRs are written for significant decisions
- verification commands pass

## Sources

- Flutter architecture guide: https://docs.flutter.dev/app-architecture/guide
- Flutter architecture recommendations: https://docs.flutter.dev/app-architecture/recommendations
- Flutter architecture case study: https://docs.flutter.dev/app-architecture/case-study
- Flutter testing overview: https://docs.flutter.dev/testing/overview
- Flutter integration testing guide: https://docs.flutter.dev/testing/integration-tests
- GitHub Spec Kit overview: https://github.github.com/spec-kit/
- GitHub Spec Kit `spec-driven.md`: https://github.com/github/spec-kit/blob/main/spec-driven.md
- Spec-Driven Manifesto: https://specdriven.com/manifesto
- EARS official guide: https://alistairmavin.com/ears/
- Google Cloud ADR overview: https://cloud.google.com/architecture/architecture-decision-records
- Microsoft ADR guidance: https://learn.microsoft.com/en-us/azure/well-architected/architect-role/architecture-decision-record
