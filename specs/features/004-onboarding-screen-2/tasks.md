# Tasks - 004-onboarding-screen-2

Tasks for implementing the second onboarding screen.

## Phase 1: Assets & Shared Widgets
- [ ] Add `assets/onboarding/onboarding_2_hero_img.png` (scales, books, gavel, laurel illustration).
- [ ] Register the new asset in `pubspec.yaml` (if not using directory-level declaration).
- [ ] Create `ContentDivider` widget with outlined diamond style in `lib/core/presentation/widgets/`.
- [ ] Create `OnboardingNavBar` widget (SKIP/NEXT row) in `lib/features/onboarding/presentation/widgets/`.

## Phase 2: PageView Refactor
- [ ] Refactor `OnboardingPage` to use a `PageView` with a `PageController`.
- [ ] Extract current Screen 1 layout into a builder method or separate widget.
- [ ] Connect `PageIndicator` to the `PageController` for dynamic active index.

## Phase 3: Screen 2 Layout
- [ ] Implement Screen 2 layout as a PageView page:
  - [ ] Hero illustration (Expanded, top section, no brand lockup).
  - [ ] Heading: "Learn. Understand." (navy) + "Apply Law." (gold).
  - [ ] Content divider with outlined diamond.
  - [ ] Body text paragraph in muted grey sans-serif.
  - [ ] Navigation row (SKIP left, NEXT > right).
  - [ ] Page indicator (index 1 active).
- [ ] Ensure all decorative elements (dots, stars, wave, temple watermark) are present.

## Phase 4: Navigation Logic
- [ ] Wire NEXT button to advance PageView to the next page.
- [ ] Wire SKIP button to exit onboarding (navigate to home screen).
- [ ] Verify horizontal swipe gestures work between Screen 1 ↔ Screen 2.

## Phase 5: Testing & Refinement
- [ ] Add widget tests for Screen 2 content and navigation.
- [ ] Add golden tests for Screen 2 visual output.
- [ ] Perform manual UI review on multiple device sizes.
- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Update spec status from Draft to Implemented.
