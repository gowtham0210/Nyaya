# 005-onboarding-screen-3 Onboarding Screen 3 Design Specification

Status: Draft
Last Updated: 2026-04-29
Source Screenshot: Provided by user (Onboarding Screen 3 design)

## Design Overview

Onboarding Screen 3 is the **final screen** in the onboarding flow. It shifts focus to **gamification and progress tracking** — the app's key engagement features. The illustration is the most complex of all screens, featuring a mobile progress dashboard mockup alongside a trophy and law books. This screen replaces the SKIP/NEXT navigation with a prominent **"GET STARTED"** call-to-action button and a **"Sign in"** link for existing users.

---

## Visual Components

### 1. Hero Illustration (Top Section)

- **Composition**: A rich, multi-layered 3D-style illustration featuring:
  - A **mobile phone/tablet mockup** (center-right) with a dark navy bezel and notch, displaying a progress dashboard:
    - Header text: `YOUR PROGRESS` in navy bold uppercase, centered at the top of the card.
    - A large **circular progress ring** (~85% filled) in gold/amber, with `85%` in bold navy text centered inside, and `Mastery` label below.
    - Three stat rows below the ring, each with an icon + value + label:
      - 🔥 **12** `Day Streak` — flame icon in gold/amber
      - 📋 **26** `Quizzes Completed` — clipboard/document icon in navy
      - 🏅 **8** `Badges Earned` — badge/medal icon in gold
    - The stat values are bold navy, the labels are regular lighter text.
    - The phone mockup has rounded corners (~16px radius) and a subtle shadow.
  - A **golden trophy** (left side) — a classic cup trophy with a star emblem on it, polished gold surface with reflections, positioned slightly overlapping the phone mockup.
  - **Golden laurel/olive branches** framing the left and right sides of the trophy and phone, creating a wreath-like framing effect.
  - A stack of **three law books** at the bottom-center:
    - Top book: dark navy labeled `JUSTICE` in gold serif text
    - Middle book: dark navy labeled `KNOWLEDGE` in gold serif text
    - Bottom book: dark navy labeled `IMPACT` in gold serif text
    - All books have gold decorative spine lines.
- **Background accents behind illustration**:
  - A faded **courthouse/temple pillar** image on the right side, very low opacity (~10–15%), same as previous screens.
  - A **soft beige radial glow** behind the illustration center.
- **Size**: The illustration occupies roughly the top **45–50%** of the screen height.
- **Width**: The illustration spans approximately **85–90%** of the screen width, centered.
- **Vertical position**: Starts roughly **20px** below the safe area top edge.

### 2. Primary Heading

- **Line 1**: `Track Progress.`
  - **Color**: Dark Navy `#1A2C3D`
  - **Font**: Serif (e.g., Cinzel or similar), Bold / FontWeight.w700
  - **Font size**: ~24–26sp
  - **Letter spacing**: -0.5
  - **Alignment**: Center
- **Line 2**: `Achieve Excellence.`
  - **Color**: Gold `#C89B3C`
  - **Font**: Serif, Bold / FontWeight.w700
  - **Font size**: ~24–26sp
  - **Alignment**: Center
- **Spacing**: ~6px gap between line 1 and line 2.
- **Position**: Immediately below the illustration, with ~16–20px top margin from illustration bottom.

### 3. Decorative Divider (Below Heading)

- **Style**: Same as Screen 2 — horizontal gold divider line with a **centered outlined diamond** icon (rotated 45° square, stroke only).
- **Width**: ~60% of screen width, centered.
- **Diamond**: ~12×12px, gold outline, 1.5px stroke, centered on the divider line.
- **Color**: Gold `#C89B3C`
- **Vertical spacing**: ~12px below the heading, ~12px above the body text.
- **Reuse**: Same `ContentDivider` widget from Screen 2.

### 4. Body Text (Description)

- **Text**: `Track your performance, build streaks, earn badges and become the best version of your legal knowledge.`
- **Color**: Muted dark grey/charcoal `#4A5568`
- **Font**: Sans-serif (system default or app's primary sans-serif), Regular / FontWeight.w400
- **Font size**: ~14–15sp
- **Line height**: ~1.5 (generous line spacing for readability)
- **Alignment**: Center
- **Max width**: Text block constrained to approximately **80%** of screen width.
- **Position**: Below the decorative divider, with ~12px top margin.

### 5. GET STARTED Button (Primary CTA)

- **Style**: Full-width rounded rectangle button (pill shape).
- **Background color**: Gold `#C89B3C` — solid fill.
- **Text**: `GET STARTED`
  - **Color**: White `#FFFFFF`
  - **Font**: Sans-serif, Bold / FontWeight.w700
  - **Font size**: ~16sp
  - **Letter spacing**: ~1.5 (uppercase tracking)
  - **Text transform**: Uppercase
- **Border radius**: ~30px (fully rounded/pill shape).
- **Height**: ~52–56px
- **Width**: Spans full available width within horizontal padding (~24px each side), approximately **85%** of screen width.
- **Vertical position**: ~20px below body text.
- **Shadow**: Subtle elevation shadow (optional, ~2dp).
- **Tap behavior**: Navigates to login/signup or main app.

### 6. Sign In Link

- **Text**: `Already have an account? Sign in`
  - The prefix `Already have an account?` is in muted grey `#4A5568`, regular weight.
  - `Sign in` is in Gold `#C89B3C`, bold / FontWeight.w600, acting as a tappable link.
- **Font**: Sans-serif, ~13–14sp.
- **Alignment**: Center.
- **Position**: ~12px below the GET STARTED button.
- **Tap behavior**: `Sign in` navigates to the login screen.

### 7. Page Indicator

- **Style**: Same `PageIndicator` widget — horizontal segmented dots.
- **Count**: 4 segments.
- **Active state (Page 3)**: The **third segment** is elongated (20px wide) and colored Gold `#C89B3C`.
- **Inactive state**: Remaining three segments are 6px wide, colored light beige `#F1E5D7` (waveBeige).
- **Position**: Centered horizontally, positioned below the Sign In link with appropriate bottom padding.

### 8. Background & Decorative Ornaments

- **Background color**: Warm Ivory `#FBF7F1` (same as all screens).
- **Background wave**: Same `BackgroundWave` custom paint at the bottom.
- **Dot pattern (top-left)**: 5×5 gold dot grid, positioned at `left: 16, top: 80`, opacity ~0.15.
- **Star accent (top-right)**: Small gold sparkle star at `right: 20, top: ~100`, opacity ~0.95, size ~18–22px.
- **Star accent (bottom-right)**: Small gold sparkle star at `right: 20, bottom: ~140`, opacity ~0.94, size ~18–22px.
- **Temple/courthouse watermark (right)**: Faded temple background at `right: -20, top: ~120`, width ~45%, opacity ~0.10–0.15.

---

## Layout & Composition

### Vertical Stack Order (Top to Bottom)

```
┌─────────────────────────────────────┐
│  [SafeArea top]                     │
│                                     │
│  ┌─────────────────────────────┐    │
│  │   Hero Illustration          │    │  ← Expanded (flex: 5)
│  │   (phone + trophy + books)   │    │
│  └─────────────────────────────┘    │
│                                     │
│  "Track Progress."                  │  ← Fixed
│  "Achieve Excellence."              │  ← Fixed
│                                     │
│  ──────── ◇ ────────               │  ← Content Divider (fixed)
│                                     │
│  Body description text              │  ← Fixed
│                                     │
│  ┌─────────────────────────────┐    │
│  │      GET STARTED             │    │  ← Fixed (primary CTA)
│  └─────────────────────────────┘    │
│                                     │
│  Already have an account? Sign in   │  ← Fixed
│                                     │
│       ● ● ━━ ●                      │  ← Page indicator
│                                     │
│  [Bottom padding]                   │
└─────────────────────────────────────┘
```

### Proportions (on ~812px height screen)

| Section | Approximate % |
|---|---|
| Status bar + safe area | ~5% |
| Illustration area | ~45% |
| Heading + divider + body | ~18% |
| CTA button + Sign in link | ~12% |
| Page indicator + bottom padding | ~20% |

### Key Spacing Values

| Between | Gap |
|---|---|
| Safe area → Illustration top | 20px |
| Illustration bottom → Heading | 16px |
| Heading line 1 → line 2 | 6px |
| Heading → Divider | 12px |
| Divider → Body text | 12px |
| Body text → GET STARTED button | 20px |
| GET STARTED button → Sign in text | 12px |
| Sign in text → Page indicator | 16px |
| Page indicator → bottom edge | flexible/bottom padding |

---

## Key Differences from Screen 2

| Aspect | Screen 2 | Screen 3 |
|---|---|---|
| Illustration theme | Legal books, scales, gavel | Progress dashboard mockup, trophy, books |
| Heading text | "Learn. Understand." / "Apply Law." | "Track Progress." / "Achieve Excellence." |
| Body text | Learning-focused description | Gamification-focused description |
| Navigation | SKIP / NEXT > text buttons | ❌ Removed |
| Primary CTA | ❌ Not present | ✅ "GET STARTED" gold pill button |
| Sign in link | ❌ Not present | ✅ "Already have an account? Sign in" |
| Page indicator active index | 1 (second dot) | 2 (third dot) |
| Illustration asset | `onboarding_2_hero.png` | `onboarding_3_hero.png` (new asset needed) |

---

## Color Reference

| Token | Hex | Usage |
|---|---|---|
| `ivory` | `#FBF7F1` | Background |
| `navy` | `#1A2C3D` | Heading line 1 |
| `gold` | `#C89B3C` | Heading line 2, CTA button background, Sign in link, active indicator, divider |
| `waveBeige` | `#F1E5D7` | Inactive indicators, wave background |
| `bodyGrey` | `#4A5568` | Body text, "Already have an account?" prefix |
| `white` | `#FFFFFF` | CTA button text |
| `dotGold` | `#E8D4B8` | Dot pattern dots |

---

## Typography Reference

| Element | Font | Weight | Size | Color | Spacing |
|---|---|---|---|---|---|
| Heading line 1 | Serif | w700 | 24sp | navy | -0.5 |
| Heading line 2 | Serif | w700 | 24sp | gold | 0 |
| Body text | Sans-serif | w400 | 14sp | bodyGrey | 0 |
| CTA button text | Sans-serif | w700 | 16sp | white | 1.5 |
| Sign in prefix | Sans-serif | w400 | 13sp | bodyGrey | 0 |
| Sign in link | Sans-serif | w600 | 13sp | gold | 0 |

---

## Asset Requirements

| Asset | Path | Notes |
|---|---|---|
| Hero illustration | `assets/onboarding/onboarding_3_hero.png` | New asset: phone dashboard mockup + trophy + law books + laurel. High-res PNG with transparency. |
| Star icon | `assets/icons/star.png` | Existing — reuse |
| Temple background | `assets/backgrounds/temple_bg.png` | Existing — reuse |

---

## Validation Checklist

- [ ] No brand lockup is shown on this screen.
- [ ] No SKIP/NEXT text navigation buttons are shown (replaced by CTA).
- [ ] Hero illustration (phone dashboard, trophy, books, laurel) is correctly rendered and centered.
- [ ] Courthouse/temple watermark is visible on the right at low opacity.
- [ ] Heading "Track Progress." is rendered in navy serif bold.
- [ ] Heading "Achieve Excellence." is rendered in gold serif bold.
- [ ] Outlined diamond divider is centered below the heading (same as Screen 2).
- [ ] Body text matches the exact copy and is styled in muted grey sans-serif.
- [ ] "GET STARTED" button is a full-width gold pill-shaped button with white uppercase text.
- [ ] "Already have an account? Sign in" is displayed below the button, with "Sign in" in gold.
- [ ] Page indicator shows 4 segments with the **third** dot active.
- [ ] Background ornaments (dots, stars, wave) are present and match previous screens.
- [ ] Overall spacing and vertical rhythm match the design screenshot.
- [ ] Tapping GET STARTED navigates to login/signup or main app.
- [ ] Tapping "Sign in" navigates to the login screen.
