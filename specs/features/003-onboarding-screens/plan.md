# Implementation Plan - 003-onboarding-screens

This plan outlines the steps to implement the first onboarding screen for the Nyaya app, following the design and functional specifications.

## Proposed Changes

### 1. Asset Preparation
- Add the onboarding illustration (books and gavel) to `assets/onboarding/onboarding_1.png`.
- Ensure all existing branding and decorative assets are available.

### 2. Shared Widgets Refactoring
- Move common decorative elements from `SplashPage` to `lib/core/presentation/widgets/`:
    - `DotPattern`
    - `SparkleAccent`
    - `BackgroundWave`
    - `BrandLockup` (containing logo, wordmark, and tagline)

### 3. Onboarding Components
- Create a `PageIndicator` widget in `lib/features/onboarding/presentation/widgets/`.
- Create the `OnboardingIllustration` widget to handle the book stack and glow effect.

### 4. Onboarding Page Implementation
- Create `lib/features/onboarding/presentation/onboarding_page.dart`.
- Use a `PageView` to manage the different onboarding steps (starting with Screen 1).
- Compose the screen using the shared and new components.

### 5. Navigation Integration
- Update the navigation logic to transition from `SplashPage` to `OnboardingPage`.

## Verification Plan

### Automated Tests
- **Widget Tests**:
    - Verify that `OnboardingPage` renders the correct heading and subheading text.
    - Verify that the `PageIndicator` shows the correct active index.
    - Verify the presence of the branding lockup and illustration.
- **Golden Tests**:
    - Capture and compare the visual output of the onboarding screen against the design spec.

### Manual Verification
- Run the app on an emulator and physical device.
- Verify the transition from the splash screen.
- Check responsiveness on different screen aspect ratios.
- Validate that the background wave and ornaments are correctly layered.
