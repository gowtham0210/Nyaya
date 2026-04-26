# 002-splash-screen Splash Screen

Status: Implemented
Last Updated: 2026-04-26
Owner:
Related ADRs: `../../adr/0001-adopt-spec-driven-development.md`

## Problem

Nyaya needs a branded Flutter splash screen that feels calm, premium, and
trustworthy on first launch. The previous Flutter implementation drifted away
from the approved screenshot by collapsing the primary brand lockup into a
generic text treatment and by misplacing key decorative layers.

## Goals

- Match the approved splash reference using the full Nyaya brand composition.
- Keep the screen visually calm with generous negative space and restrained
  decorative treatment.
- Preserve the approved hierarchy: crest emblem, serif `NYAYA` wordmark,
  divider, tagline, book icon, and short loading bar.
- Preserve responsive behavior across common phone sizes without clipping or
  flattening the composition.

## Non-Goals

- Replace the platform-native Android or iOS launch screen in this feature.
- Add startup logic beyond the current splash-to-next-screen handoff.
- Introduce new decorative assets beyond those visible in the approved
  screenshot.

## Actors

- App user launching Nyaya on a mobile device
- Developer aligning the Flutter splash implementation with the approved design
- Reviewer validating visual fidelity against the approved screenshot

## Assumptions

- `screenshots/Expected_splash_screen_design.png` is the visual source of truth.
- The approved v1 splash includes the crest emblem, serif wordmark, temple
  watermark, book icon, dot patterns, star accents, and lower wave.
- If the exact approved wordmark export is unavailable, the implementation may
  use a generated asset that approximates the approved typography until design
  supplies a final export.

## Functional Requirements

- FR-001: When the app reaches the first Flutter-rendered screen, the Nyaya app
  shall display a dedicated splash screen before the main experience.
- FR-002: When the splash screen is visible, the Nyaya app shall render a full
  screen warm ivory background with restrained visual noise.
- FR-003: When the splash screen is visible, the Nyaya app shall render a
  centered branding stack composed of the crest emblem, the `NYAYA` wordmark, a
  gold divider with a centered diamond, the `LAW BASED QUIZ APP` tagline, a
  centered book icon, and a horizontal loading bar.
- FR-004: When the splash screen is visible, the Nyaya app shall place the
  branding stack in the upper-middle portion of the screen with significant
  empty space above it.
- FR-005: When the splash screen is visible, the Nyaya app shall render a soft
  temple watermark in the upper-right background without letting it compete with
  the primary lockup.
- FR-006: When the splash screen is visible, the Nyaya app shall render top-left
  and lower-right dot patterns plus top-right and lower-right sparkle accents
  that match the approved screenshot.
- FR-007: When the splash screen is visible, the Nyaya app shall render a soft
  lower background wave using a beige base curve and a white highlight curve
  that occupy a meaningful portion of the bottom area.
- FR-008: When the splash screen is visible, the Nyaya app shall show loading
  progress near one-third completion using a gold fill over a pale beige track.
- FR-009: When the splash screen is visible, the Nyaya app shall keep all
  decorative treatments non-interactive and excluded from accessibility
  announcements.
- FR-010: When splash loading completes, the Nyaya app shall keep the splash
  visible until the user taps to continue.

## Non-Functional Requirements

- NFR-001: The feature shall size and position the splash composition using
  screen proportions derived from `MediaQuery` rather than device-specific fixed
  pixels.
- NFR-002: The feature shall preserve the approved visual hierarchy on phones in
  the approximate range from 360 x 780 to 430 x 932 logical pixels without
  clipping the crest emblem, wordmark, divider, tagline, book icon, progress
  bar, or lower wave.
- NFR-003: The feature shall bias toward premium restraint rather than visual
  density or generic app-heading styling.
- NFR-004: The feature shall expose accessibility semantics for app identity and
  loading state while excluding decorative assets from announcements.
- NFR-005: The feature shall include regression coverage strong enough to catch
  structural layout drift and shall pair that with emulator screenshot review
  because the current widget-golden rasterizer does not faithfully surface all
  image assets.

## UX Notes

- Navigation: The splash screen appears immediately after Flutter initializes,
  then hands off to the next route after the startup delay and tap-to-continue
  signal.
- Approved target emphasis: The expected screenshot is a branded ceremonial
  composition, not a stripped-down placeholder.
- Composition notes:
  - The crest emblem and serif wordmark are the primary focal point.
  - The divider, tagline, book icon, and progress bar form a centered vertical
    rhythm beneath the wordmark.
  - The temple watermark, sparkles, dot patterns, and lower wave are present
    but visually subordinate.
- Accessibility expectations: Decorative assets and curves are ignored by
  screen readers, while splash identity and loading state remain announced.

## Data and Integration Impact

- Local storage: None required for the visual splash layout itself
- Remote APIs: None required for the visual splash layout itself
- Analytics/telemetry: Optional future event for splash impression timing, not
  required for this revision

## Acceptance Criteria

- AC-001: On app launch, the first Flutter-rendered screen shows the crest
  emblem, `NYAYA` wordmark, divider, `LAW BASED QUIZ APP` tagline, book icon,
  progress bar, and lower curved background treatment.
- AC-002: The splash screen shows the approved temple watermark, dot patterns,
  and sparkle accents without overpowering the brand lockup.
- AC-003: The book icon and progress bar appear below the tagline with spacing
  that matches the approved composition more closely than the previous build.
- AC-004: The lower beige wave and white highlight occupy a stronger visual
  presence near the bottom of the screen than in the previous build.
- AC-005: On tall and moderately compact phone layouts, the logo, wordmark,
  book icon, and progress bar remain centered, readable, and unclipped while
  preserving large negative space above.
- AC-006: Screen readers announce the splash identity and loading state without
  announcing decorative background shapes.
- AC-007: Widget regression checks, golden coverage, and emulator screenshot
  review validate the splash layout against the approved reference.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Widget | `test/features/splash/presentation/splash_page_test.dart` |
| AC-002 | Widget | `test/features/splash/presentation/splash_page_test.dart` |
| AC-003 | Widget | `test/features/splash/presentation/splash_page_test.dart` |
| AC-004 | Golden | `test/features/splash/presentation/splash_page_golden_test.dart` |
| AC-005 | Widget | `test/features/splash/presentation/splash_page_test.dart` |
| AC-006 | Widget | `test/features/splash/presentation/splash_page_test.dart` |
| AC-007 | Golden + Manual | `test/features/splash/presentation/splash_page_golden_test.dart` and emulator screenshot review |

## Open Questions

- Should design replace the generated serif wordmark asset with an approved
  vector or transparent export for exact typography fidelity?
- Should the progress indicator remain fixed near 33 percent in version one, or
  should it animate independently of real initialization state?
