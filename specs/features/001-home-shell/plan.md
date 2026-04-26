# 001-home-shell Technical Plan

Status: Implemented
Last Updated: 2026-04-26
Feature Spec: `spec.md`

## Scope

Replace the blank starter screen with a small feature-oriented home shell and
restructure the codebase into an app bootstrap area plus feature directories.

## Architecture

- Create `lib/app/` for app bootstrap and shared theme.
- Create `lib/features/home/` for the home feature.
- Keep feature data in a lightweight immutable view model because the screen is
  static today.
- Mirror the feature path under `test/`.

## Data and State

- No remote or persistent state.
- The view model exposes static UI copy and ordered step metadata.
- The page renders directly from the view model.

## UI Flow

- App launch shows `HomePage`.
- `HomePage` renders one headline card and three step cards.
- No loading, empty, or error state is required for this baseline feature.

## Test Plan

- Unit test for view model metadata and feature ID.
- Widget tests for visible content and step titles.
- No integration test yet because there is no multi-step user flow.

## Rollout Notes

- No migration needed.
- Rollback is a simple revert of the feature files if the baseline needs to be
  replaced.

## Risks

- Static copy can drift from the documented process if the process changes and
  the screen is not updated.
