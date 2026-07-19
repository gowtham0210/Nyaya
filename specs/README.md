# Specs Directory

This folder contains the source-of-truth artifacts for Nyaya's spec-driven
workflow.

## Layout

- `mission.md` product mission and flow-level product constitution
- `roadmap.md` high-level implementation order in small phases
- `project-constitution.md` project-wide engineering rules
- `templates/` reusable templates for features and ADRs
- `features/NNN-slug/` one folder per feature
- `adr/` append-only architecture decision records

## Feature Lifecycle

1. Create a feature folder with `dart run tool/new_feature_spec.dart "Name"`.
2. Write and review `spec.md`.
3. Write `plan.md`.
4. Add or update ADRs if the change introduces a significant technical choice.
5. Break the work into `tasks.md`.
6. Implement and map acceptance criteria to tests.
7. Update status fields when the feature ships.

## Naming Rules

- Feature folders use a three digit prefix: `001-home-shell`.
- Specs use stable IDs such as `FR-001`, `NFR-001`, and `AC-001`.
- ADRs use four digits: `0001-adopt-spec-driven-development.md`.

## Status Values

Use one of these values in specs and plans:

- `Draft`
- `In Review`
- `Approved`
- `Implemented`
- `Superseded`

## Current Baseline

- Product mission: [`mission.md`](mission.md)
- Product roadmap: [`roadmap.md`](roadmap.md)
- Feature: [`001-home-shell`](features/001-home-shell/spec.md)
- ADR: [`0001-adopt-spec-driven-development`](adr/0001-adopt-spec-driven-development.md)

next we want to implement this design onboarding screen 3. write pixel perfect spec so that the design is implemented extractly the the ui should be captured perfectly. also express the designs guidelines in design.md file. now you're task is to look into the image and write spec folder the exisitng templates in specs/ folder check it and create 004-onboarding-screen-3

implement onboarding screen 3 with given specs in specs/features/005-onboarding-screen-3 in this repo. assets has been updated in assets/onboarding folder you can use this