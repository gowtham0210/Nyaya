# Tasks - 003-onboarding-screens

Tasks for implementing the first onboarding screen.

## Phase 1: Foundation & Assets
- [ ] Add `assets/onboarding/onboarding_1.png` (Constitution and Gavel illustration).
- [ ] Extract `DotPattern` widget to `lib/core/presentation/widgets/`.
- [ ] Extract `SparkleAccent` widget to `lib/core/presentation/widgets/`.
- [ ] Extract `BackgroundWave` widget to `lib/core/presentation/widgets/`.
- [ ] Extract `BrandLockup` widget to `lib/core/presentation/widgets/`.

## Phase 2: Widget Development
- [ ] Implement `PageIndicator` widget with elongated active state.
- [ ] Implement `OnboardingIllustration` widget with background glow.
- [ ] Update `AppTheme` if necessary to include the Serif font for onboarding headings.

## Phase 3: Screen Implementation
- [ ] Create `OnboardingPage` structure.
- [ ] Implement Screen 1 layout using extracted and new widgets.
- [ ] Add semantics for accessibility (headings, indicator).

## Phase 4: Integration & Navigation
- [ ] Update `AppRouter` or navigation logic to include `OnboardingPage`.
- [ ] Trigger navigation from `SplashPage` to `OnboardingPage` on user interaction.

## Phase 5: Testing & Refinement
- [ ] Add widget tests for `OnboardingPage`.
- [ ] Add golden tests for `OnboardingPage`.
- [ ] Perform manual UI review on multiple device sizes.
