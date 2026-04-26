# 002-splash-screen Design Review

Status: In Review
Last Updated: 2026-04-26
Source Screenshots:
- `screenshots/Expected_splash_screen_design.png`
- `screenshots/current_implemented_design.png`

## Comparison Basis

- Compare the Flutter-rendered canvas only.
- Ignore screenshot chrome differences such as clock text, notch or camera cutout
  shape, and rounded screenshot masking.
- Treat `Expected_splash_screen_design.png` as the source of truth.
- Treat `current_implemented_design.png` as the current Flutter output.

## Executive Summary

The current splash screen does not match the expected design. The main problem
is not small spacing drift; it is a different visual hierarchy. The expected
screen is a premium branded composition built around the crest emblem, a serif
`NYAYA` wordmark, the gold divider and tagline, a centered book icon, a short
loading bar, a subtle temple watermark, decorative star and dot accents, and a
stronger lower wave. The implemented screen keeps the background tone and some
ornaments, but it replaces the primary brand lockup with a simplified bold sans
placeholder and drops key artwork from the center of the composition.

There is also documentation drift. The current `spec.md`, `plan.md`,
`tasks.md`, and splash tests describe a stripped-down target that removes the
crest, book icon, and most ornamentation. That direction is the opposite of the
expected screenshot and should not be used for further design decisions until it
is corrected.

## Visual Diff

| Area | Expected Design | Current Implementation | Required Correction |
| --- | --- | --- | --- |
| Primary brand lockup | Large crest emblem with scales and serif `N` centered above the `NYAYA` wordmark | Crest emblem is missing entirely | Restore the crest emblem above the wordmark using the approved asset |
| Wordmark typography | Large dark navy serif `NYAYA` with premium legal-brand tone | Heavy sans-serif `NYAYA` that reads like a placeholder | Replace with the approved wordmark styling or a dedicated exported wordmark asset |
| Divider and tagline block | Gold divider with centered diamond, then gold tagline under it | Divider and tagline exist, but they sit under the wrong wordmark treatment | Keep the divider and tagline, but retune them against the restored brand lockup |
| Secondary center icon | Gold book-and-quill icon between the tagline and progress bar | Missing | Reintroduce the centered book icon using `assets/icons/book_icon.png` |
| Loading area | Short, thin progress bar placed below the book icon with about one-third fill | Progress bar sits too high because the book icon is absent | Move the loading bar lower and restore the icon-and-bar stack |
| Temple watermark | Soft, low-opacity temple crop at the upper-right, present but restrained | Temple is larger and more intrusive behind the wordmark | Reduce its visual weight by tuning size, crop, and opacity |
| Decorative accents | Top-left dots, top-right sparkle, lower-right sparkle, lower-right dots | Top-left dots, top-right sparkle, and lower-right dots exist; lower-right sparkle is missing | Keep the approved accents and add the missing lower-right sparkle |
| Bottom wave | Beige lower wave with a clear white highlight ribbon and stronger presence | Wave exists but feels lighter and less intentional | Increase the wave height, curvature, and highlight prominence |
| Overall composition | Taller, more ceremonial brand stack with generous top whitespace | Simpler mid-screen stack with less brand depth | Rebuild the vertical rhythm around the full logo, wordmark, book icon, and lower bar |

## What Must Be Preserved

- Warm ivory background
- Dark navy for primary branding
- Gold for divider, tagline, brand accents, and loading fill
- Top-left and lower-right dotted ornaments
- Top-right sparkle
- Subtle upper-right temple watermark
- Decorative lower wave with white highlight
- Minimal accessibility noise from decorative layers

## What Must Change

- Restore the crest emblem above the wordmark
- Replace the current sans `NYAYA` with the approved serif wordmark treatment
- Add the book icon between the tagline and progress bar
- Add the missing lower-right sparkle
- Reposition and soften the temple watermark
- Strengthen the bottom wave
- Retune vertical spacing so the whole stack matches the expected composition

## Layout Targets

These are composition targets, not exact pixels:

- Brand lockup should occupy the visual center of the upper-middle screen rather
  than reading like a small text block.
- Crest emblem should be large enough to feel intentional and distinct from the
  divider, not a tiny badge.
- Wordmark should be materially wider than the current text treatment and must
  read as a premium serif brand, not a default app heading.
- Book icon should create a dedicated middle layer between the tagline and the
  progress bar.
- Progress bar should stay short and thin, centered, and visually secondary to
  the brand lockup.
- Temple watermark should sit behind the right side of the brand area without
  competing with the wordmark.
- Lower wave should begin slightly higher and carry more visual weight than the
  current implementation.

## Asset and Typography Decision

The repo already contains the following approved or reusable artwork:

- `assets/branding/logo.png` for the crest emblem
- `assets/icons/book_icon.png` for the center icon
- `assets/backgrounds/temple_bg.png` for the temple watermark
- `assets/icons/star.png` for sparkle accents

One asset is still missing for exact fidelity: the serif `NYAYA` wordmark. The
current app theme has no custom font configured in `pubspec.yaml`, so the
existing bold sans rendering cannot match the expected screenshot closely
enough.

Recommended order:

1. Preferred: add an approved transparent wordmark asset or a combined lockup
   asset that includes both the crest and the `NYAYA` wordmark.
2. Acceptable fallback: add the approved serif display font to `pubspec.yaml`
   and render the wordmark in Flutter with carefully tuned size and spacing.

## Correction Plan

### 1. Rebuild the center brand stack

- Update `lib/features/splash/presentation/splash_page.dart`.
- Restore a dedicated logo widget above the wordmark. Use
  `assets/branding/logo.png` unless a combined lockup asset is delivered.
- Replace the current `headlineLarge`-based wordmark with the approved serif
  treatment or a wordmark image.
- Keep the gold divider and tagline, but retune spacing after the logo and
  wordmark are in place.
- Reintroduce the centered book icon below the tagline.
- Move the progress bar below the book icon and shorten it to match the
  reference.

### 2. Tune decorative layers to the expected screenshot

- Keep the dot grids and top-right sparkle.
- Add a second sparkle near the lower-right wave crest.
- Reduce temple opacity and tune the crop so it feels atmospheric rather than
  foreground.
- Increase the lower wave's area and refine the highlight ribbon so the bottom
  of the screen matches the expected softness.

### 3. Make layout behavior more predictable

- Avoid relying on a single `FittedBox` to scale the entire composition.
- Size major elements with explicit width-based clamps so the crest, wordmark,
  book icon, and loading bar keep stable proportions across phone sizes.
- Preserve large top whitespace while keeping the brand lockup vertically
  centered.

### 4. Fix test coverage so it matches the real target

- Update `test/features/splash/presentation/splash_page_test.dart`.
- Reverse the current assertions that treat the crest, book icon, and approved
  ornaments as absent.
- Add presence and position checks for the crest emblem, book icon, and lower
  sparkle.
- Keep semantics assertions focused on splash identity and loading state only.

### 5. Replace the current golden reference

- Update `test/features/splash/presentation/splash_page_golden_test.dart`.
- Replace
  `test/features/splash/presentation/goldens/splash_page_reference.png` after
  the layout matches the expected screenshot.
- Do not reuse the current golden as an approval source; it encodes the wrong
  design direction.

### 6. Correct the feature documentation drift

- Realign `spec.md`, `plan.md`, and `tasks.md` with this review before treating
  the feature as implemented.
- The current documents incorrectly instruct the team to remove the emblem, book
  icon, and approved ornaments.

## File-Level Worklist

- `lib/features/splash/presentation/splash_page.dart`
  Restore logo and book layers, retune wordmark, reposition ornaments, and tune
  wave and temple treatment.
- `pubspec.yaml`
  Register a custom serif font if a wordmark asset is not provided.
- `assets/branding/`
  Add a wordmark or combined lockup asset if design wants exact fidelity.
- `test/features/splash/presentation/splash_page_test.dart`
  Update presence and spacing assertions to the correct target.
- `test/features/splash/presentation/splash_page_golden_test.dart`
  Keep golden coverage, but point it at the corrected reference.
- `test/features/splash/presentation/goldens/splash_page_reference.png`
  Regenerate after implementation matches the expected screenshot.

## Validation Checklist

- Crest emblem is visible and centered above the wordmark
- `NYAYA` reads as a serif premium brand, not a default sans heading
- Divider, diamond, and tagline align with the expected hierarchy
- Book icon is present between tagline and progress bar
- Progress bar is shorter, thinner, and placed lower than the current version
- Temple watermark is visible but subdued
- Top-left dots, top-right sparkle, lower-right sparkle, and lower-right dots
  are all present
- Lower wave and highlight match the expected visual weight
- Decorative layers are excluded from accessibility announcements
- Golden test and widget tests enforce the corrected composition
