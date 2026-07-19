# 003-onboarding-screens Onboarding Screen 1 Design Review

Status: Draft
Last Updated: 2026-04-26
Source Screenshot: `onboarding_1_expected.png` (Referencing the provided UI screen)

## Design Overview

Onboarding Screen 1 establishes the core value proposition of the Nyaya app. It uses a consistent visual language with the splash screen, maintaining the premium, legal-themed aesthetic while introducing content specific to the user's journey.

## Visual Components

### 1. Header Branding
- **Logo and Wordmark**: Reuses the brand lockup from the splash screen.
- **Tagline**: "LAW BASED QUIZ APP" in gold, uppercase, with generous letter spacing.
- **Divider**: Gold horizontal divider with a centered diamond, separating the wordmark from the tagline.

### 2. Central Illustration
- **Composition**: A stack of legal books with a prominent blue book titled "CONSTITUTION OF INDIA" in gold lettering. A wooden gavel sits in front of the books.
- **Style**: Realistic, high-quality 3D-style illustration with soft shadows.
- **Background Accent**: A soft beige circular glow/blob behind the books to provide depth and focus.

### 3. Messaging
- **Primary Heading**: "Test Your Knowledge."
  - **Color**: Dark Navy (#1A2C3D)
  - **Typography**: Bold Serif font.
  - **Alignment**: Centered.
- **Secondary Heading**: "Master Justice."
  - **Color**: Gold (#C99A45)
  - **Typography**: Bold Serif font.
  - **Alignment**: Centered.

### 4. Page Indicator
- **Style**: Horizontal segmented indicator.
- **Count**: 4 segments.
- **Active State (Page 1)**: The first segment is elongated and colored Gold.
- **Inactive State**: The remaining three segments are shorter and colored a light beige/ivory grey.

### 5. Background & Ornaments
- **Background Color**: Warm Ivory (#FBF7F1).
- **Dot Patterns**: Top-left and lower-right 5x5 dot grids in light gold.
- **Sparkle Accents**: Top-right and lower-right gold star icons.
- **Lower Wave**: Soft beige wave at the bottom with a white highlight ribbon, consistent with the splash screen.

## Layout & Composition

- **Vertical Rhythm**: The layout follows a centered vertical stack with generous whitespace between sections to maintain a premium feel.
- **Alignment**: All primary elements are horizontally centered.
- **Proportions**:
  - The brand lockup occupies the top 20-25% of the screen.
  - The illustration takes up the central 40%.
  - The messaging and page indicator occupy the remaining 35-40%.

## Technical Implementation Notes

- **Reuse**: The `SplashPage` components (dot patterns, stars, waves, brand lockup) should be extracted into shared widgets to ensure consistency and reduce duplication.
- **Assets**: 
  - Need `assets/onboarding/onboarding_1_hero_img.png` for the books and gavel.
  - Use existing `assets/branding/`, `assets/icons/star.png`, and `assets/backgrounds/temple_bg.png`.
- **Typography**: Ensure the Serif font (e.g., Cinzel or similar) is correctly configured in the theme for the headings.
- **PageIndicator**: A custom widget or a package like `smooth_page_indicator` can be used, styled to match the elongated active segment.

## Validation Checklist

- [ ] Brand lockup matches the splash screen exactly.
- [ ] Central illustration is high-resolution and correctly centered.
- [ ] Headings use the correct colors and serif typography.
- [ ] Page indicator shows 4 segments with the first one correctly highlighted.
- [ ] Background ornaments (dots, stars, waves) are present and match the reference.
- [ ] Overall spacing and vertical rhythm reflect the "premium" design intent.
