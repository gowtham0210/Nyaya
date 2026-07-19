# 004-onboarding-screen-2 Onboarding Screen 2 Design Specification

Status: Draft
Last Updated: 2026-04-29
Source Screenshot: Provided by user (Onboarding Screen 2 design)

## Design Overview

Onboarding Screen 2 is the second step in the onboarding flow. It shifts focus from the brand introduction (Screen 1) to the app's educational value proposition: **learning and applying law**. The screen removes the brand lockup (Nyaya logo/wordmark/tagline) and replaces it with a larger illustration area and descriptive body text. Navigation controls (SKIP / NEXT) appear for the first time.

---

## Visual Components

### 1. Hero Illustration (Top Section)

- **Composition**: A 3D-style realistic illustration featuring:
  - A balanced **golden scale of justice** at the top, mounted on a vertical stand.
  - A stack of **three law books** — the top book is dark navy/blue labeled "LAW" in gold serif text, the middle is brown/leather-toned, the bottom is cream/beige. All books have gold decorative lines on the spine.
  - A **wooden gavel** with a brass band resting on its sound block, positioned in front/right of the books.
  - A **golden olive/laurel branch** extending from the left side behind the books.
- **Background accents behind illustration**:
  - A faded **courthouse/temple pillar** image on the right side, very low opacity (~10–15%), showing classical columns and a pediment.
  - A **soft beige radial glow** behind the illustration center to create depth and focus.
- **Size**: The illustration occupies roughly the top **45–50%** of the screen height.
- **Width**: The illustration spans approximately **85–90%** of the screen width, centered horizontally.
- **Vertical position**: The illustration starts roughly **80px** below the safe area top edge (accounting for status bar).

### 2. Primary Heading

- **Line 1**: `Learn. Understand.`
  - **Color**: Dark Navy `#1A2C3D`
  - **Font**: Serif (e.g., Cinzel or similar), Bold / FontWeight.w700
  - **Font size**: ~24–26sp
  - **Letter spacing**: -0.5
  - **Alignment**: Center
- **Line 2**: `Apply Law.`
  - **Color**: Gold `#C89B3C` (same as brand gold)
  - **Font**: Serif, Bold / FontWeight.w700
  - **Font size**: ~24–26sp
  - **Alignment**: Center
- **Spacing**: ~6px gap between line 1 and line 2.
- **Position**: Immediately below the illustration, with ~16–20px top margin from illustration bottom.

### 3. Decorative Divider (Below Heading)

- **Style**: A horizontal gold divider line with a **centered diamond icon** (rotated 45° square).
- **Width**: ~60% of screen width, centered.
- **Diamond**: Small gold outlined diamond shape (~14×14px), centered on the line. The diamond appears to be an **outlined/stroke style** (not filled), unlike the solid diamond in the brand lockup divider.
- **Color**: Gold `#C89B3C`
- **Vertical spacing**: ~12px below the heading, ~12px above the body text.
- **Reuse note**: This is a **different divider** from the `NyayaDivider` in the BrandLockup — the diamond here appears outlined/hollow rather than solid. A new `ContentDivider` widget or a variant parameter may be needed.

### 4. Body Text (Description)

- **Text**: `Nyaya makes legal learning simple with case-based quizzes, real-life scenarios and expertly crafted content.`
- **Color**: Muted dark grey/charcoal `#4A5568` (softer than the heading navy)
- **Font**: Sans-serif (system default or the app's primary sans-serif), Regular / FontWeight.w400
- **Font size**: ~14–15sp
- **Line height**: ~1.5 (generous line spacing for readability)
- **Alignment**: Center
- **Max width**: Text block is constrained to approximately **80%** of the screen width to maintain comfortable reading line lengths.
- **Position**: Below the decorative divider, with ~12px top margin.

### 5. Navigation Controls (SKIP & NEXT)

- **Layout**: A horizontal `Row` spanning the full width (with horizontal padding ~24px), with SKIP on the left and NEXT on the right.
- **SKIP button**:
  - **Text**: `SKIP`
  - **Color**: Dark Navy `#1A2C3D`
  - **Font**: Sans-serif, Bold / FontWeight.w700
  - **Font size**: ~14sp
  - **Letter spacing**: ~1.0 (slight tracking for uppercase)
  - **Style**: Plain text button (no border, no background). Uses `TextButton` or `GestureDetector`.
- **NEXT button**:
  - **Text**: `NEXT` followed by a **right chevron** icon `>`
  - **Text color**: Gold `#C89B3C`
  - **Icon color**: Gold `#C89B3C`
  - **Font**: Sans-serif, Bold / FontWeight.w700
  - **Font size**: ~14sp
  - **Letter spacing**: ~1.0
  - **Icon**: Right-pointing chevron (`Icons.chevron_right` or `>` character), ~18px, placed immediately after the text with ~4px gap.
  - **Style**: Plain text button with icon.
- **Vertical position**: The navigation row sits above the page indicator, with ~12px gap between them.

### 6. Page Indicator

- **Style**: Same `PageIndicator` widget from Screen 1 — horizontal segmented dots.
- **Count**: 4 segments.
- **Active state (Page 2)**: The **second segment** is elongated (20px wide) and colored Gold `#C89B3C`.
- **Inactive state**: Remaining three segments are 6px wide, colored light beige `#F1E5D7` (waveBeige).
- **Position**: Centered horizontally, positioned at the bottom with ~80px bottom padding (matching Screen 1).

### 7. Background & Decorative Ornaments

- **Background color**: Warm Ivory `#FBF7F1` (same as all screens).
- **Background wave**: Same `BackgroundWave` custom paint — a soft beige wave at the bottom ~15–20% of the screen with a white highlight ribbon stroke.
- **Dot pattern (top-left)**: 5×5 gold dot grid, positioned at `left: 16, top: 80`, opacity ~0.15. Same `DotPattern` widget.
- **Star accent (top-right)**: Small gold sparkle star at `right: 20, top: ~100`, opacity ~0.95, size ~18–22px.
- **Star accent (bottom-right)**: Small gold sparkle star at `right: 20, bottom: ~140`, opacity ~0.94, size ~18–22px.
- **Temple/courthouse watermark (right)**: Faded temple background image positioned at `right: -20, top: ~120`, width ~45% of screen, opacity ~0.10–0.15. Same as Screen 1.
- **Olive branch**: Part of the illustration asset itself (not a separate positioned element).

---

## Layout & Composition

### Vertical Stack Order (Top to Bottom)

```
┌─────────────────────────────────────┐
│  [SafeArea top]                     │
│                                     │
│  ┌─────────────────────────────┐    │
│  │   Hero Illustration          │    │  ← Expanded (flex: 3)
│  │   (scales/books/gavel)       │    │
│  └─────────────────────────────┘    │
│                                     │
│  "Learn. Understand."               │  ← Fixed
│  "Apply Law."                       │  ← Fixed
│                                     │
│  ──────── ◇ ────────               │  ← Content Divider (fixed)
│                                     │
│  Body description text              │  ← Fixed
│                                     │
│  [Spacer]                           │  ← Flexible space
│                                     │
│  SKIP              NEXT >           │  ← Fixed
│                                     │
│       ● ━━ ● ●                      │  ← Page indicator (fixed)
│                                     │
│  [Bottom padding: 80px]             │
└─────────────────────────────────────┘
```

### Proportions (on ~812px height screen)

| Section | Approximate % |
|---|---|
| Status bar + safe area | ~5% |
| Illustration area | ~45% |
| Heading + divider + body | ~20% |
| Spacer | ~10% |
| Navigation + indicator + bottom padding | ~20% |

### Key Spacing Values

| Between | Gap |
|---|---|
| Illustration bottom → Heading | 16–20px |
| Heading line 1 → line 2 | 6px |
| Heading → Divider | 12px |
| Divider → Body text | 12px |
| Body text → (Spacer) → Nav row | Flexible |
| Nav row → Page indicator | 12px |
| Page indicator → bottom edge | 80px |

---

## Key Differences from Screen 1

| Aspect | Screen 1 | Screen 2 |
|---|---|---|
| Brand lockup (logo/wordmark/tagline) | ✅ Present at top | ❌ Removed |
| Illustration position | Below brand lockup | At the top of screen |
| Illustration size | Constrained by brand above | Larger, dominates top half |
| Heading text | "Test Your Knowledge." / "Master Justice." | "Learn. Understand." / "Apply Law." |
| Decorative divider below heading | ❌ Not present | ✅ Outlined diamond divider |
| Body description text | ❌ Not present | ✅ Present |
| Navigation controls (SKIP/NEXT) | ❌ Not present | ✅ Present |
| Page indicator active index | 0 (first dot) | 1 (second dot) |
| Illustration asset | `onboarding_1_hero_img.png` | `onboarding_2_hero_img.png` (new asset needed) |

---

## Color Reference

| Token | Hex | Usage |
|---|---|---|
| `ivory` | `#FBF7F1` | Background |
| `navy` | `#1A2C3D` | Heading line 1, SKIP text |
| `gold` | `#C89B3C` | Heading line 2, NEXT text, divider, active indicator |
| `waveBeige` | `#F1E5D7` | Inactive indicators, wave background |
| `bodyGrey` | `#4A5568` | Body description text |
| `dotGold` | `#E8D4B8` | Dot pattern dots |

---

## Typography Reference

| Element | Font | Weight | Size | Color | Spacing |
|---|---|---|---|---|---|
| Heading line 1 | Serif | w700 | 24sp | navy | -0.5 |
| Heading line 2 | Serif | w700 | 24sp | gold | 0 |
| Body text | Sans-serif | w400 | 14sp | bodyGrey | 0 |
| SKIP label | Sans-serif | w700 | 14sp | navy | 1.0 |
| NEXT label | Sans-serif | w700 | 14sp | gold | 1.0 |

---

## Asset Requirements

| Asset | Path | Notes |
|---|---|---|
| Hero illustration | `assets/onboarding/onboarding_2_hero_img.png` | New asset: law books with scales, gavel, and laurel branch. Must be high-res PNG with transparency. |
| Star icon | `assets/icons/star.png` | Existing — reuse |
| Temple background | `assets/backgrounds/temple_bg.png` | Existing — reuse |

---

## Validation Checklist

- [ ] No brand lockup (logo/wordmark/tagline) is shown on this screen.
- [ ] Hero illustration (scales, books, gavel, laurel) is correctly rendered and centered.
- [ ] Courthouse/temple watermark is visible on the right at low opacity.
- [ ] Heading "Learn. Understand." is rendered in navy serif bold.
- [ ] Heading "Apply Law." is rendered in gold serif bold.
- [ ] Outlined diamond divider is centered below the heading.
- [ ] Body text matches the exact copy and is styled in muted grey sans-serif.
- [ ] SKIP button (left) and NEXT > button (right) are positioned correctly.
- [ ] Page indicator shows 4 segments with the **second** dot active.
- [ ] Background ornaments (dots, stars, wave) are present and match Screen 1 positioning.
- [ ] Overall spacing and vertical rhythm match the design screenshot.
- [ ] Screen transitions correctly from Screen 1 via swipe or NEXT button.
