# Implementation Plan - 005-onboarding-screen-3

This plan outlines the steps to implement the third (final) onboarding screen for the Nyaya app, following the design and functional specifications.

## Proposed Changes

### 1. Asset Preparation
- Add the new hero illustration to `assets/onboarding/onboarding_3_hero.png` (phone dashboard mockup + trophy + law books + laurel branches).
- Verify the asset is covered by the existing `assets/onboarding/` directory declaration in `pubspec.yaml`.

### 2. New Shared Widget: GetStartedButton
- Create a reusable `GetStartedButton` widget for the full-width gold pill-shaped CTA button.
- Properties: `onTap` callback, optional `label` text (defaults to "GET STARTED").
- Styling: gold background, white bold uppercase text, pill border radius (~30px), height ~52–56px.

### 3. Screen 3 Page Implementation
- Add Screen 3 as the third page in the existing `PageView` in `OnboardingPage`.
- Layout structure:
  1. **Expanded illustration** at the top (no brand lockup, no SKIP/NEXT).
  2. **Heading** — two lines: "Track Progress." (navy) + "Achieve Excellence." (gold).
  3. **Content divider** with outlined diamond (reuse `ContentDivider`).
  4. **Body text** — description paragraph in muted grey.
  5. **GET STARTED button** — full-width gold pill button.
  6. **Sign in link** — "Already have an account? Sign in" with tappable gold "Sign in".
  7. **Page indicator** — 4 dots, index 2 active.

### 4. Bottom Controls Update
- On Screen 3 (final screen), the shared bottom overlay should:
  - **Hide** the SKIP/NEXT nav bar.
  - Show only the page indicator.
- The GET STARTED button and Sign in link are part of the screen content itself (not the shared overlay), so they scroll with the page.

### 5. Navigation Logic
- Wire GET STARTED button to navigate to signup/registration (placeholder for now).
- Wire "Sign in" link to navigate to login screen (placeholder for now).
- Ensure swiping right from Screen 3 returns to Screen 2.
- Ensure the PageView does NOT allow swiping past Screen 3 (it's the last page).

### 6. State Management
- On completing onboarding (GET STARTED or Sign in), store a completion flag in local storage so the user does not see onboarding again on next launch (future task).

## Verification Plan

### Automated Tests
- **Widget Tests**:
    - Verify that Screen 3 does NOT render `BrandLockup`.
    - Verify that Screen 3 does NOT render SKIP/NEXT buttons.
    - Verify heading text "Track Progress." and "Achieve Excellence." with correct colors.
    - Verify body text content.
    - Verify GET STARTED button is present with correct styling.
    - Verify "Already have an account? Sign in" text and link presence.
    - Verify `PageIndicator` shows index 2 as active.
    - Verify `ContentDivider` is rendered.
- **Golden Tests**:
    - Capture and compare the visual output of Screen 3 against the design reference.

### Manual Verification
- Run the app on emulator and physical device.
- Verify swipe navigation between Screen 2 and Screen 3.
- Verify GET STARTED and Sign in button functionality.
- Confirm no forward swiping beyond Screen 3.
- Validate responsiveness on different screen aspect ratios.
- Confirm decorative elements match previous screens.
