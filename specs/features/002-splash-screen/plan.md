# 002-splash-screen Technical Plan

Status: Implemented
Last Updated: 2026-04-26
Feature Spec: `spec.md`

## Scope

Implement the approved branded splash screen in Flutter so it matches the
expected screenshot instead of the earlier stripped-down placeholder.

## Architecture

- Keep the splash feature module under `lib/features/splash/`.
- Rework `SplashPage` around the approved asset stack:
  `logo_mark.png`, `wordmark.png`, `book_icon.png`, `temple_bg.png`, and
  `star.png`.
- Preserve the custom-painted background wave and dot-pattern treatments, but
  retune them to the approved proportions.
- Keep the splash transition hook self-contained so visual refinement does not
  affect routing behavior.
- Pair widget and golden coverage with emulator screenshot review because the
  widget-golden rasterizer does not fully surface the image-based layers.

## Data and State

- Input state: screen size from `MediaQuery`, startup completion signal, and a
  static initial progress value.
- Derived UI state: proportional sizing and placement for the crest emblem,
  wordmark, divider, book icon, progress bar, temple watermark, and lower wave.
- Persistence or network impact: none for the visual splash implementation.

## UI Flow

- App startup hands off from the native launch surface to `SplashPage`.
- `SplashPage` renders the approved Nyaya brand composition with large top
  whitespace and restrained decorative support layers.
- Once startup work completes, the splash remains visible until the user taps to
  continue.
- The app then navigates to the next route defined by the broader shell flow.
- No empty or error state is introduced in this feature.

## Test Plan

- Widget test for visible crest emblem, wordmark, divider, tagline, book icon,
  and progress bar.
- Widget test for the approved temple watermark, star accents, and dot patterns.
- Widget test for vertical spacing between tagline, book icon, and progress bar.
- Widget test for accessibility semantics so only splash identity and loading
  state are announced.
- Widget test with compact and tall phone sizes to validate layout bounds.
- Golden regression test for the overall composition structure.
- Emulator screenshot capture for final review of raster assets that are not
  faithfully surfaced by the widget-golden output.

## Rollout Notes

- No data migration is required.
- Rollback can revert the splash visuals without affecting persisted user data
  or navigation behavior.

## Risks

- The current serif wordmark is generated from a local font approximation and
  may need replacement if design supplies an exact export.
- The widget-golden path remains imperfect for image-asset review, so future
  visual sign-off should continue to include emulator or device screenshots.
- Small decorative offsets can still drift if future edits focus only on
  structure tests and ignore screenshot comparison.
