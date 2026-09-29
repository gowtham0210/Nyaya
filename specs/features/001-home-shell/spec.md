# 001-home-shell Home Shell

Status: Implemented
Last Updated: 2026-04-26
Owner:
Related ADRs: `../../adr/0001-adopt-spec-driven-development.md`

## Problem

The repository started from a default Flutter template with no durable product
or engineering workflow. The app needed a first feature that demonstrates the
spec-driven baseline and gives future work a stable structure.

## Goals

- Provide a small but intentional home screen instead of the default starter.
- Establish a feature ID that can be traced from spec to code and tests.
- Make the app structure match the documented SDD workflow.

## Non-Goals

- Implement authentication, networking, or persistence.
- Introduce production state management complexity before a real feature needs
  it.
- Add integration tests before user journeys exist.

## Actors

- Developer starting new Nyaya features
- Reviewer validating that process and code stay aligned

## Assumptions

- Nyaya is still in early development.
- The first shipped feature should optimize for clarity over breadth.

## Functional Requirements

- FR-001: When the Nyaya app launches, the Nyaya app shall display a home shell
  titled `Nyaya`.
- FR-002: When the home shell is visible, the Nyaya app shall explain the
  adopted spec-driven workflow in plain language.
- FR-003: When the home shell is visible, the Nyaya app shall show three
  ordered adoption steps for feature work.

## Non-Functional Requirements

- NFR-001: The feature shall fit inside Flutter's recommended feature-oriented
  structure so later features can scale without immediate reorganization.
- NFR-002: The feature shall have automated widget and unit coverage for its
  acceptance criteria.

## UX Notes

- The screen should feel intentional, not like the stock Flutter counter app.
- Content should remain readable on phones and larger screens.
- The page should expose a feature identifier for traceability.

## Data and Integration Impact

- Local storage: None
- Remote APIs: None
- Analytics/telemetry: None

## Acceptance Criteria

- AC-001: The app shows the Nyaya title, the home shell headline, and the home
  shell summary.
- AC-002: The app shows exactly three adoption steps with clear titles.
- AC-003: The feature exposes a stable feature ID and step metadata through the
  view model.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Widget | `test/features/home/presentation/home_page_test.dart` |
| AC-002 | Widget | `test/features/home/presentation/home_page_test.dart` |
| AC-003 | Unit | `test/features/home/presentation/home_view_model_test.dart` |

## Open Questions

- None at the current app size.
