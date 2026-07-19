# 003-onboarding-screens Onboarding Screen 1

Status: Draft
Last Updated: 2026-04-26
Owner:
Related ADRs: `../../adr/0001-adopt-spec-driven-development.md`

## Problem

After the splash screen, users need to be introduced to the Nyaya app's value proposition through a series of onboarding screens. The first screen focuses on the core concept of testing knowledge and mastering justice.

## Goals

- Introduce the user to the app's primary purpose: law-based quizzes.
- Maintain the premium, legal-brand aesthetic established in the splash screen.
- Provide a clear visual transition from the splash screen into the app's onboarding flow.
- Ensure a consistent UI language across all onboarding steps.

## Non-Goals

- Detailed explanation of app features (reserved for later screens).
- User registration or login on this specific screen.
- Complex animations that might distract from the brand message.

## Actors

- New user opening the app for the first time.
- Returning user who has cleared app data.

## Assumptions

- The onboarding flow consists of multiple screens (implied by the 4-dot page indicator).
- The user reaches this screen automatically after the splash screen's "tap to continue" action.

## Functional Requirements

- FR-001: The screen shall display the Nyaya brand lockup (logo, wordmark, tagline) at the top.
- FR-002: The screen shall display a central illustration featuring the "Constitution of India" book and a gavel.
- FR-003: The screen shall display a primary heading "Test Your Knowledge." in dark navy.
- FR-004: The screen shall display a secondary heading "Master Justice." in gold.
- FR-005: The screen shall display a page indicator at the bottom with 4 dots.
- FR-006: The first dot of the page indicator shall be highlighted (longer and gold) to indicate the current page.
- FR-007: The screen shall support horizontal swiping to navigate between onboarding pages (future requirement for the flow).
- FR-008: The screen shall maintain the decorative elements from the splash screen: dot patterns, sparkle accents, and the lower background wave.

## Non-Functional Requirements

- NFR-001: The layout shall be responsive across various screen sizes, ensuring text and illustrations are not cramped or clipped.
- NFR-002: Typography and colors must strictly adhere to the brand guidelines (Navy: #1A2C3D, Gold: #C99A45, Ivory: #FBF7F1).
- NFR-003: Assets should be high-resolution and optimized for mobile performance.
- NFR-004: Accessibility semantics must be provided for the headings and the page indicator.

## UX Notes

- Transition: The transition from Splash to Onboarding 1 should feel seamless, as many visual elements are shared.
- Visual Rhythm: The vertical stack should follow: Brand -> Illustration -> Text -> Page Indicator.
- Emphasis: The illustration of the Constitution and gavel is the focal point, emphasizing the "Law Based" nature of the app.

## Acceptance Criteria

- AC-001: Brand lockup is correctly displayed at the top.
- AC-002: Central illustration of books and gavel is visible and matches the design.
- AC-003: Heading "Test Your Knowledge." is rendered in dark navy serif/bold font.
- AC-004: Subheading "Master Justice." is rendered in gold serif/bold font.
- AC-005: Page indicator shows 4 dots, with the first dot active (gold, elongated).
- AC-006: Decorative elements (dots, stars, wave) are present and positioned according to the design.
- AC-007: Screen background is the warm ivory color.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Widget | Verify presence of logo, wordmark, and tagline |
| AC-002 | Widget | Verify presence of onboarding illustration |
| AC-003 | Widget | Verify text content and color for primary heading |
| AC-004 | Widget | Verify text content and color for secondary heading |
| AC-005 | Widget | Verify page indicator state (index 0 active) |
| AC-006 | Golden | Visual regression for decorative alignment |
| AC-007 | Widget | Verify background color |
