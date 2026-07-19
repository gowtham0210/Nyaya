# 008-home-page Home Page Design Specification

Status: Draft
Last Updated: 2026-05-10
Source Screenshot: Provided by user (Home Page design)

## Design Overview

The Home Page is the first fully featured authenticated dashboard in Nyaya. It should feel editorial, premium, and action-oriented: a polished top hero, fast category discovery, a strong resume surface, and a clean list of recommended quizzes. The page needs to preserve the Nyaya brand's navy-and-gold authority while remaining approachable and easy to scan.

This document follows the intended spirit of a "UI/UX pro max" implementation: crisp hierarchy, premium spacing, disciplined density, strong CTA priority, and minimal clutter despite the amount of information on screen.

## Design Principles

- Lead with momentum. The hero banner must immediately tell the user what Nyaya is for and what action to take next.
- Keep the scan path obvious. Users should be able to understand the page in this order: brand -> hero CTA -> categories -> resume -> popular quizzes -> nav.
- Use premium restraint. Rich legal imagery is welcome, but surfaces should still feel calm, clean, and intentional.
- Make cards do real work. Every card should communicate purpose, status, and action without decorative excess.
- Preserve strong contrast. Navy, gold, and white should be used to create visual anchors rather than soft ambiguous surfaces.
- Avoid generic dashboard aesthetics. This screen should feel distinctly Nyaya, not like a stock e-learning template.

## Visual Components

### 1. Top System/Header Area

- **Left content**: Nyaya brand lockup
  - Reuse the established logo mark + wordmark + tagline styling
  - Compact horizontal version, scaled for a header rather than a splash/auth hero
- **Right content**: Notification bell button
  - Circular or softly rounded background in pale ivory/grey
  - Dark navy bell icon
  - Small gold unread dot near the top-right corner
- **Alignment**: Vertically centered within the safe area
- **Padding**: ~24-28dp horizontal

### 2. Hero Banner

- **Container**:
  - Background: Deep navy, approximately `#0F2137` to `#13233A`
  - Radius: ~28-32dp
  - Padding: generous, ~22-28dp
  - Shadow: soft, subtle elevation only
- **Left copy block**:
  - Line 1: `Test Your`
  - Line 2: `Legal Knowledge.`
  - Line 3: `Master Justice.`
  - The middle emphasis line should be gold
  - Supporting copy: `Quizzes on Law. Insights for Life.`
- **CTA**:
  - Label: `Start Quiz`
  - Gold rounded button with white play icon inside a circular white accent
  - Placed lower-left within the hero
- **Right visual**:
  - Golden scales as the dominant vertical object
  - Dark law books at the bottom
  - Large gavel in the front-right foreground
  - Subtle courthouse silhouette in the background
- **Balance**: Copy occupies left half; illustration owns right half without obscuring CTA or headline

### 3. Section Headers

- **Style**:
  - Left-aligned title in dark navy
  - Right-aligned `View All` link in gold
  - Small chevron or arrow after `View All`
- **Typography**:
  - Title: sans-serif, bold, ~20-22sp
  - Action: sans-serif, medium, ~14-16sp
- **Spacing**: Consistent vertical rhythm between sections

### 4. Category Strip

- **Layout**:
  - Five evenly spaced tiles in a horizontal row within the viewport shown
  - Tiles may later support horizontal scrolling, but the first viewport should visually match the screenshot
- **Tile design**:
  - Soft warm-white or ivory card
  - Large rounded corners, ~18-22dp
  - Minimal shadow or soft border
  - Centered outline icon
  - Two-line centered label below or within the card block
- **Categories**:
  - Constitutional Law
  - Criminal Law
  - Civil Law
  - Contract Law
  - Legal Reasoning
- **Icon tone**:
  - Navy outline icons with small gold accent details where appropriate

### 5. Continue Learning Card

- **Container**:
  - White card with large rounded corners, ~22-26dp
  - Soft shadow for separation from background
  - Horizontal layout
- **Left area**:
  - Circular progress ring displaying `65%`
  - Gold progress arc over pale base ring
- **Middle area**:
  - Title: `Indian Constitution Quiz`
  - Subtitle: `15 Questions`
  - Progress bar under metadata
  - Thin divider or spacing separation from progress ring if needed
- **Right area**:
  - Dark navy `Resume` button
  - Rounded rectangle, vertically centered
- **Priority**: Must read as an actionable "resume session" surface, not just a status card

### 6. Popular Quiz Cards

- **Container**:
  - White card
  - Large radius, ~22-26dp
  - Soft shadow
  - Vertical stack with comfortable spacing between cards
- **Left tile**:
  - Square icon block with rounded corners
  - Alternates between navy and gold fills depending on card
  - Simple gold/white legal icons centered
- **Center content**:
  - Quiz title in bold navy
  - Metadata row with question count and difficulty label
  - Short description in body grey
- **Right content**:
  - Rating pill with star icon and score
  - Chevron button or icon
- **Example content from mockup**:
  - `Fundamental Rights Quiz` -> `10 Questions` -> `Medium` -> rating `4.6`
  - `Indian Penal Code Quiz` -> `15 Questions` -> `Hard` -> rating `4.7`
  - `Contract Act Quiz` -> `12 Questions` -> `Easy` -> rating `4.5`

### 7. Difficulty Styling

- `Medium`: warm gold/orange
- `Hard`: red
- `Easy`: green
- Difficulty should be distinct but still harmonize with the page palette

### 8. Bottom Navigation

- **Structure**:
  - Five items: Home, Categories, Leaderboard, Bookmarks, Profile
  - Fixed at bottom, above safe-area inset
- **Active state**:
  - `Home` icon and label in navy
  - Small gold underline/indicator below the active label
- **Inactive state**:
  - Icons and labels in muted grey
- **Background**:
  - White with slight top shadow or top border

## Layout and Composition

### Vertical Flow

1. Safe-area top header
2. Hero banner
3. Category section
4. Continue Learning section
5. Popular Quizzes section
6. Scroll termination near bottom nav
7. Fixed bottom navigation

### Proportions

- Header + hero should dominate the upper half of the first viewport.
- Category section should feel compact and glanceable.
- Continue Learning should interrupt the scroll with a high-value status surface.
- Popular Quizzes should feel like a feed, but with premium card spacing rather than dense list compression.

### Key Spacing Values

| Element | Spacing / Gap |
| --- | --- |
| Safe area top -> header row | ~8-12dp |
| Header row -> hero banner | ~18-22dp |
| Hero banner -> first section header | ~24-28dp |
| Section header -> category row | ~14-16dp |
| Category row -> Continue Learning header | ~26-30dp |
| Continue Learning header -> resume card | ~14-16dp |
| Resume card -> Popular Quizzes header | ~24-28dp |
| Popular Quizzes header -> first quiz card | ~14-16dp |
| Quiz card -> next quiz card | ~14-18dp |
| Final card -> bottom nav breathing room | ~18-24dp |

## Color Reference

| Token | Hex | Usage |
| --- | --- | --- |
| `pageBg` | `#F8F6F2` | Main page background |
| `navy` | `#11233B` | Primary text, hero background, active nav, dark buttons |
| `gold` | `#D3A247` | CTA, emphasis, ratings, unread dot, links |
| `bodyGrey` | `#5E6878` | Supporting text |
| `softCard` | `#FFFDFC` | Light card surfaces |
| `mutedBorder` | `#ECE5DB` | Borders and separators |
| `easyGreen` | `#1FA35B` | Easy difficulty label |
| `hardRed` | `#D64545` | Hard difficulty label |
| `mediumGold` | `#D19A2E` | Medium difficulty label |
| `white` | `#FFFFFF` | Cards, nav background, CTA foreground |

## Typography Reference

| Element | Font | Weight | Size | Color |
| --- | --- | --- | --- | --- |
| Hero headline | Serif | w700 | 26-34sp | white/gold |
| Hero supporting copy | Sans-serif | w400 | 14-16sp | soft white |
| Section titles | Sans-serif | w700 | 20-22sp | navy |
| Section actions | Sans-serif | w500-w600 | 14-16sp | gold |
| Category labels | Sans-serif | w600-w700 | 13-15sp | navy |
| Resume title | Sans-serif | w700 | 18-20sp | navy |
| Resume metadata | Sans-serif | w400 | 13-15sp | bodyGrey |
| Quiz titles | Sans-serif | w700 | 18-20sp | navy |
| Quiz metadata | Sans-serif | w400-w500 | 13-15sp | bodyGrey/difficulty colors |
| Bottom-nav labels | Sans-serif | w500-w600 | 11-13sp | navy/muted grey |

## Interaction and State Guidance

- **Hero CTA**: strongest visual emphasis on the page after the hero headline
- **Category tiles**: tappable, slightly elevated or outlined on press/focus
- **Resume button**: dark navy fill with clear pressed state
- **Quiz cards**: entire card should feel tappable, not just the chevron
- **Bottom nav**: active state must remain obvious without relying only on color
- **Notification bell**: unread dot disappears when the unread state is cleared
- **Loading state**: preserve overall structure with skeleton placeholders instead of layout collapse
- **Empty state**: if no continue-learning session exists, the section should either hide cleanly or show a purposeful zero-state card

## Responsive Guidance

- Use a single vertical scroll view for page content with the bottom nav fixed separately.
- On smaller phones, preserve hero hierarchy by slightly reducing illustration footprint before shrinking headline typography.
- Category tiles may horizontally scroll on narrow devices, but spacing and first-frame presentation should still feel intentional.
- Quiz descriptions may wrap to two lines, but titles, ratings, and CTA affordances should remain aligned.
- Constrain content width on large devices so cards do not stretch into tablet-dashboard proportions prematurely.

## Asset Requirements

| Asset | Path | Notes |
| --- | --- | --- |
| Header brand lockup | Existing Nyaya branding assets | Use compact horizontal treatment |
| Hero banner illustration | `assets/home/home_hero_banner.png` or composed widgets | Preferred: transparent illustration layers or a single high-res composite |
| Category icons | `assets/home/categories/*.png` or vector/icon set | Outline legal/topic icons |
| Quiz card icons | `assets/home/quizzes/*.png` or vector/icon set | Consistent line-weight and brand palette |
| Bottom-nav icons | Vector/system icons or custom set | Must visually match each other |

## Implementation Notes

- This feature supersedes the current placeholder content in [specs/features/001-home-shell/spec.md](/Users/gowtham/StudioProjects/Nyaya/specs/features/001-home-shell/spec.md) from a UI perspective.
- Reuse Nyaya brand tokens, rounded surfaces, and gold-accent language established in onboarding/auth where appropriate.
- The page should feel like the first "real app" screen after login, so polish on spacing and card hierarchy matters more than decorative complexity.
- Prefer reusable subcomponents for hero banner, category tile, continue-learning card, quiz card, and bottom navigation item.

## Validation Checklist

- [ ] Header shows Nyaya branding on the left and bell button with unread dot on the right.
- [ ] Hero banner matches the screenshot's dark navy, gold-emphasis, legal-illustration composition.
- [ ] `Start Quiz` button is prominent and placed in the lower-left area of the hero.
- [ ] `Explore by Category` section is visible with `View All`.
- [ ] Five category tiles are shown in the correct order with centered legal icons.
- [ ] `Continue Learning` section displays `65%`, `Indian Constitution Quiz`, `15 Questions`, progress bar, and `Resume`.
- [ ] `Popular Quizzes` section displays three cards with the expected titles and descriptions.
- [ ] `Medium`, `Hard`, and `Easy` labels use distinct colors.
- [ ] Rating pills appear on the right side of quiz cards with star icons and numeric ratings.
- [ ] Bottom navigation contains Home, Categories, Leaderboard, Bookmarks, and Profile.
- [ ] `Home` is visibly active with navy emphasis and gold underline.
- [ ] Scroll behavior and fixed bottom nav both work correctly on compact mobile screens.
