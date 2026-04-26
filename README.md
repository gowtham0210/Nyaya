# Nyaya

Nyaya is a Flutter application being set up with a spec-driven development
workflow. The project keeps feature specifications, plans, tasks, ADRs, code,
and tests in the same repository so product intent stays traceable as the app
grows.

## Quick Start

1. Create a feature folder:

   ```bash
   dart run tool/new_feature_spec.dart "Feature Name"
   ```

2. Fill in the generated `spec.md`, then add the technical `plan.md`,
   `tasks.md`, and any required ADRs before coding.
3. Implement only after the spec is reviewed.
4. Verify the change:

   ```bash
   flutter analyze
   flutter test
   ```

## Repo Guide

- Process and research: [`docs/spec-driven-development.md`](docs/spec-driven-development.md)
- Spec workflow and folder layout: [`specs/README.md`](specs/README.md)
- Project rules: [`specs/project-constitution.md`](specs/project-constitution.md)
- Current starter feature: [`specs/features/001-home-shell/spec.md`](specs/features/001-home-shell/spec.md)

## Flutter Structure

This repo follows Flutter's current architecture guidance:

- `lib/app/` for app bootstrap and shared theme
- `lib/features/<feature>/` for feature UI and feature-local logic
- `test/` mirroring `lib/` so acceptance criteria can be traced to test files

The current app is intentionally small, but the structure is now ready for
incremental feature work.
