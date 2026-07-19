# Tasks - 005-onboarding-screen-3

Tasks for implementing the third (final) onboarding screen.

## Phase 1: Assets
- [ ] Add `assets/onboarding/onboarding_3_hero.png` (phone dashboard + trophy + books + laurel illustration).
- [ ] Verify asset is accessible via existing `assets/onboarding/` declaration in `pubspec.yaml`.

## Phase 2: Shared Widgets
- [ ] Create `GetStartedButton` widget in `lib/features/onboarding/presentation/widgets/`.
  - Full-width, gold `#C89B3C` background, white text, pill shape (~30px radius), ~52–56px height.
  - Accepts `onTap` callback.
- [ ] Reuse existing `ContentDivider` widget from `nyaya_widgets.dart`.

## Phase 3: Screen 3 Layout
- [ ] Add `_buildScreen3` method to `OnboardingPage`:
  - [ ] Hero illustration (Expanded, no brand lockup).
  - [ ] Heading: "Track Progress." (navy) + "Achieve Excellence." (gold).
  - [ ] Content divider with outlined diamond.
  - [ ] Body text paragraph in muted grey sans-serif.
  - [ ] GET STARTED gold pill button.
  - [ ] "Already have an account? Sign in" link row.
- [ ] Add Screen 3 as the third child of the `PageView`.
- [ ] Ensure all decorative elements (dots, stars, wave, temple watermark) are present.

## Phase 4: Bottom Controls Update
- [ ] Update shared bottom overlay logic:
  - Show SKIP/NEXT nav bar only on Screen 2 (hide on Screens 1 and 3).
  - Show page indicator on all screens.
- [ ] Verify page indicator dynamically reflects current page index.

## Phase 5: Navigation Logic
- [ ] Wire GET STARTED button to navigate to signup/registration (placeholder).
- [ ] Wire "Sign in" link to navigate to login screen (placeholder).
- [ ] Verify swiping right from Screen 3 returns to Screen 2.
- [ ] Verify no forward swiping beyond Screen 3.

## Phase 6: Testing & Refinement
- [ ] Add widget tests for Screen 3 content (headings, body, CTA, sign in link).
- [ ] Add widget tests verifying SKIP/NEXT are NOT present on Screen 3.
- [ ] Add golden tests for Screen 3 visual output.
- [ ] Perform manual UI review on multiple device sizes.
- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Update spec status from Draft to Implemented.
