# Implementation Plan - 004-onboarding-screen-2

This plan outlines the steps to implement the second onboarding screen for the Nyaya app, following the design and functional specifications.

## Proposed Changes

### 1. Asset Preparation
- Add the new hero illustration to `assets/onboarding/onboarding_2_hero_img.png` (law books with scales of justice, gavel, and laurel branch — different composition from Screen 1).
- Verify all existing decorative assets are accessible (`star.png`, `temple_bg.png`).

### 2. New Shared Widgets
- Create a `ContentDivider` widget (or extend `NyayaDivider` with a variant parameter) to support the **outlined diamond** style used in Screen 2. The existing `NyayaDivider` uses a solid diamond; Screen 2's divider uses an outlined/stroke diamond.
- Create a reusable `OnboardingNavBar` widget for the SKIP / NEXT row, as this pattern will repeat on Screens 3 and 4.

### 3. Onboarding Screen 2 Page Implementation
- Create the Screen 2 content as part of the `OnboardingPage` `PageView` (or as a standalone builder method).
- Layout structure:
  1. **Expanded illustration** at the top (no brand lockup).
  2. **Heading** — two lines: "Learn. Understand." (navy) + "Apply Law." (gold).
  3. **Content divider** with outlined diamond.
  4. **Body text** — description paragraph in muted grey.
  5. **Spacer**.
  6. **Navigation row** — SKIP (left) + NEXT > (right).
  7. **Page indicator** — 4 dots, index 1 active.

### 4. Navigation Logic
- Wire SKIP button to exit onboarding (navigate to home/main app).
- Wire NEXT button to advance PageView to Screen 3.
- Ensure horizontal swipe gestures work via the PageView controller.

### 5. PageView Integration
- Refactor `OnboardingPage` from a single static screen to a `PageView`-based flow if not already done.
- Each page in the PageView builds a different onboarding screen.
- The `PageIndicator` receives the current page index from the `PageController`.

## Verification Plan

### Automated Tests
- **Widget Tests**:
    - Verify that Screen 2 does NOT render `BrandLockup`.
    - Verify heading text "Learn. Understand." and "Apply Law." with correct colors.
    - Verify body text content.
    - Verify SKIP and NEXT buttons are present and have tap handlers.
    - Verify `PageIndicator` shows index 1 as active.
    - Verify `ContentDivider` is rendered.
- **Golden Tests**:
    - Capture and compare the visual output of Screen 2 against the design reference.

### Manual Verification
- Run the app on emulator and physical device.
- Verify swipe navigation between Screen 1 and Screen 2.
- Check SKIP and NEXT button functionality.
- Validate responsiveness on different screen aspect ratios.
- Confirm decorative elements match Screen 1 (wave, dots, stars).
