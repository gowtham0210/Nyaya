# 007-signup-screen Sign Up Screen Design Specification

Status: Draft
Last Updated: 2026-05-10
Source Screenshot: Provided by user (Sign Up Screen design)

## Design Overview

The Sign Up Screen is the visual counterpart to the existing sign-in experience, but with a more action-oriented form and slightly softer onboarding tone. The screen should feel premium, trustworthy, and easy to complete: illustration-led at the top, form-led in the main interaction area, and always anchored by Nyaya's navy-and-gold identity.

This document follows the intended spirit of a "UI/UX pro max" implementation: high visual fidelity, disciplined spacing, clear hierarchy, tactile form controls, and minimal visual noise.

## Design Principles

- Prioritize trust before speed. The brand, serif headline, and calm ivory background should make account creation feel credible and safe.
- Keep a single dominant action. `SIGN UP` must read as the primary conversion point at a glance.
- Let the illustration support, not compete. The hero art adds aspiration, but the form card remains the visual center of gravity.
- Preserve generous breathing room. Avoid compressed vertical rhythm even though the form is long.
- Use gold as an accent, not a fill-everywhere color. Gold should highlight keywords, links, helper accents, and secondary decoration.
- Match the mockup closely. Do not introduce extra chips, helper banners, tertiary links, or additional icons beyond what is shown.

## Visual Components

### 1. Back Navigation

- **Element**: Minimal chevron/back icon.
- **Position**: Top-left inside the safe area.
- **Color**: Dark navy `#1A2C3D`.
- **Touch target**: At least 48x48dp even if the visible glyph is smaller.

### 2. Brand Lockup

- **Composition**: Existing Nyaya logo mark, wordmark, gold divider, and tagline.
- **Reuse**: Reuse the shared `BrandLockup` widget where possible.
- **Position**: Upper-left quadrant, below the back button, aligned to the content column.
- **Scale**: Similar overall visual weight to sign-in; slightly reduced on narrow devices rather than wrapping.

### 3. Hero Illustration

- **Composition**:
  - Stack of law books labeled `LAW`, `JUSTICE`, and `KNOWLEDGE`
  - Dark polished gavel and sound block
  - Gold laurel leaves behind/around the stack
- **Position**: Right side of the top section, overlapping the intro area vertically.
- **Style**: Soft 3D/rendered look, warm highlights, transparent background.
- **Recommended asset**: `assets/auth/signup_hero.png`
- **Fallback**: The current sign-in hero may be reused temporarily if the dedicated signup illustration is not yet available.

### 4. Background Watermark and Ornaments

- **Temple watermark**:
  - Asset: `assets/backgrounds/temple_bg.png`
  - Position: Upper-right, partially off-canvas
  - Opacity: ~0.10 to 0.16
- **Background wave**:
  - Reuse `BackgroundWave`
  - Warm ivory and beige layered curves along the lower canvas
- **Bottom-left dots**:
  - Reuse `DotPattern`
  - Light gold, low-contrast, decorative only
- **Bottom-right star**:
  - Reuse `assets/icons/star.png`
  - Gold sparkle accent positioned near the lower wave

### 5. Intro Copy

- **Heading**: `Create Your Account`
  - Font: Serif
  - Weight: Bold / `w700`
  - Size: ~26-30sp
  - Color: Dark navy `#1A2C3D`
  - Tracking: Slightly tight (`-0.4` to `-0.7`)
- **Body**: `Start your legal learning journey with Nyaya`
  - Font: Sans-serif
  - Size: ~15-16sp
  - Color: `#4A5568`
  - Highlight: `Nyaya` in gold `#C89B3C`
- **Alignment**: Left-aligned
- **Width**: Constrained so the text does not collide with the hero art

### 6. Sign-Up Card

- **Container**:
  - Background: White with subtle warm tint, close to `#FFFFFF`
  - Radius: ~28-32dp
  - Border: Soft off-white or warm-beige stroke at low contrast
  - Shadow: Two-layer soft shadow, navy-tinted primary with faint gold ambient lift
- **Placement**: Pulled slightly upward into the space below the intro section, visually similar to sign-in
- **Padding**: ~24dp horizontal, ~28dp top, ~24dp bottom

### 7. Card Header

- **Heading**: `Let's get you started`
  - Font: Serif
  - Weight: `w700`
  - Size: ~24-28sp
  - Color: Navy
  - Alignment: Center
- **Subtext**: `Create an account to begin your journey`
  - Font: Sans-serif
  - Weight: `w400`
  - Size: ~14-15sp
  - Color: `#4A5568`
  - Alignment: Center

### 8. Form Fields

- **General field style**:
  - Fill: Very light ivory/white, approximately `#FFFCF8`
  - Border: Warm light grey/beige, approximately `#E7DFD5`
  - Radius: ~18dp
  - Height: ~56-60dp
  - Leading icon color: Desaturated blue-grey at medium opacity
  - Hint color: Muted blue-grey, approximately `#8A94A6`
- **Labels**:
  - Font: Sans-serif
  - Weight: `w700`
  - Size: ~13-14sp
  - Color: Navy
- **Field list**:
  - `Full Name` -> placeholder `Enter your full name` -> person icon
  - `Email Address` -> placeholder `Enter your email address` -> mail icon
  - `Phone Number` -> placeholder `Enter your phone number` -> phone icon
  - `Password` -> placeholder `Create a password` -> lock icon + eye icon
  - `Confirm Password` -> placeholder `Confirm your password` -> lock icon + eye icon

### 9. Password Helper Row

- **Copy**: `Password must be at least 8 characters with letters and numbers`
- **Icon**: Small shield/security icon
- **Color**: Muted grey for text; icon may be slightly darker or gold-grey
- **Spacing**: Tight to the password field, about 8-10dp below
- **Tone**: Informational, not warning/error

### 10. Primary CTA

- **Text**: `SIGN UP`
- **Style**:
  - Full-width button
  - Height: ~54-56dp
  - Radius: ~18dp
  - Fill: Navy `#1A2C3D`
  - Text: White `#FFFFFF`, bold, uppercase
  - Letter spacing: ~1.0 to 1.2
- **Priority**: Highest visual emphasis in the card

### 11. Divider

- **Style**: Thin horizontal lines on both sides of centered `or`
- **Line color**: Warm beige/gold tint
- **Text color**: Navy or body grey, slightly darker than the line
- **Vertical spacing**: Generous enough to separate primary and secondary actions cleanly

### 12. Google CTA

- **Text**: `Continue with Google`
- **Style**:
  - Full-width outlined/soft-bordered button
  - White background
  - Same horizontal size family as other controls
  - Radius: ~16-18dp
  - Border: Light neutral stroke
  - Content centered horizontally
- **Icon**: Standard Google "G" mark to the left of the label
- **Hierarchy**: Clearly secondary to `SIGN UP`

### 13. Terms Row

- **Control**: Square checkbox with rounded corners
- **Mockup state**: Checked, filled gold
- **Text**: `I agree to the Terms of Service and Privacy Policy`
- **Link styling**: `Terms of Service` and `Privacy Policy` in gold
- **Base text styling**: Sans-serif, ~13-14sp, muted grey/navy-grey
- **Note**: Default checked state should be validated with product/legal before shipping

### 14. Footer Prompt

- **Text**: `Already have an account? Sign in`
- **Base text**: Body grey or navy-grey
- **Link text**: `Sign in` in gold
- **Alignment**: Centered beneath the card
- **Spacing**: Enough distance from the card to read as a separate tertiary path

## Layout and Composition

### Overall Structure

1. Safe area with back button
2. Brand lockup and hero illustration
3. Intro copy
4. Elevated sign-up card
5. Footer prompt
6. Decorative wave/dot/star accents

### Proportions

- The top visual/introduction area should occupy roughly 34-40% of the first viewport on common phones.
- The card owns the majority of the vertical space and may extend below the fold on shorter devices.
- The hero art should not push the intro copy so low that the screen feels top-heavy.

### Key Spacing Values

| Element | Spacing / Gap |
| --- | --- |
| Safe area top -> back button | ~8-12dp |
| Back button -> brand lockup | ~18-24dp |
| Brand lockup -> intro heading | ~28-36dp |
| Intro heading -> intro body | ~10-12dp |
| Intro body -> card top | ~24-28dp |
| Card heading -> card subtext | ~8dp |
| Card subtext -> first field | ~24dp |
| Label -> field | ~8dp |
| Field block -> next field block | ~16-18dp |
| Password field -> helper row | ~8dp |
| Helper row -> confirm password label | ~16-18dp |
| Confirm password field -> SIGN UP button | ~20-24dp |
| SIGN UP button -> divider | ~20-24dp |
| Divider -> Google CTA | ~20dp |
| Google CTA -> terms row | ~18-20dp |
| Card bottom -> footer prompt | ~22-28dp |

## Color Reference

| Token | Hex | Usage |
| --- | --- | --- |
| `ivory` | `#FBF7F1` | Page background |
| `navy` | `#1A2C3D` | Primary text, primary CTA |
| `gold` | `#C89B3C` | Highlights, links, checkbox fill, accents |
| `bodyGrey` | `#4A5568` | Supporting text |
| `inputBorder` | `#E7DFD5` | Input borders |
| `hintGrey` | `#8A94A6` | Placeholder text |
| `inputFill` | `#FFFCF8` | Input background |
| `white` | `#FFFFFF` | Card and button foreground |

## Typography Reference

| Element | Font | Weight | Size | Color |
| --- | --- | --- | --- | --- |
| Intro heading | Serif | w700 | 26-30sp | navy |
| Intro body | Sans-serif | w400 | 15-16sp | bodyGrey/gold |
| Card heading | Serif | w700 | 24-28sp | navy |
| Card subtext | Sans-serif | w400 | 14-15sp | bodyGrey |
| Labels | Sans-serif | w700 | 13-14sp | navy |
| Input text | Sans-serif | w400 | 14-15sp | navy/bodyGrey |
| Primary button | Sans-serif | w700 | 15-16sp | white |
| Secondary button | Sans-serif | w500-w600 | 15sp | navy |
| Terms/footer text | Sans-serif | w400-w600 | 13-14sp | bodyGrey/gold |

## Interaction and State Guidance

- **Default field state**: soft border, pale fill, muted icon
- **Focused field state**: gold-tinted border at slightly heavier stroke
- **Error field state**: warm red border/error text without changing overall spacing
- **Visibility toggle**: icon remains aligned to the trailing edge; avoid layout shift when toggled
- **Primary button disabled state**: reduced emphasis but still readable; do not rely on opacity alone
- **Checkbox**: maintain consistent box size and alignment even when unchecked
- **Keyboard behavior**: use a scrollable layout with bottom inset padding so the confirm password field, CTA, and terms row remain reachable

## Responsive Guidance

- Constrain the content width on larger devices so the card never becomes visually stretched.
- Scale the brand lockup down slightly on narrow phones before reducing text size.
- Preserve the hero-to-copy relationship on small screens by reducing hero width first, not by collapsing spacing everywhere.
- Keep the card centered and readable in portrait tablet layouts with a sensible max width around 520-560dp.

## Asset Requirements

| Asset | Path | Notes |
| --- | --- | --- |
| Brand lockup | Shared `BrandLockup` widget | Reuse existing auth branding |
| Signup hero | `assets/auth/signup_hero.png` | New preferred asset; transparent background |
| Temple watermark | `assets/backgrounds/temple_bg.png` | Existing reusable asset |
| Gold star | `assets/icons/star.png` | Existing reusable asset |
| Google mark | Asset or vector/icon source | Must match standard Google brand colors |

## Implementation Notes

- Reuse the same foundational styling language as [`specs/features/006-signin-screen/design.md`](/Users/gowtham/StudioProjects/Nyaya/specs/features/006-signin-screen/design.md) for consistency.
- Reuse shared presentation tokens and ornaments from [lib/core/presentation/widgets/nyaya_widgets.dart](/Users/gowtham/StudioProjects/Nyaya/lib/core/presentation/widgets/nyaya_widgets.dart).
- Mirror the sign-in page card treatment, but extend it for the longer registration form rather than inventing a separate auth card style.
- Prefer a single scroll view with keyboard-aware bottom padding instead of nested scrolling regions.

## Validation Checklist

- [ ] Back navigation icon is visible and aligned to the safe area.
- [ ] Brand lockup appears in the upper-left area and matches the established Nyaya style.
- [ ] Temple watermark is visible at low opacity on the upper-right.
- [ ] Hero illustration shows books, gavel, and laurel accents without distortion.
- [ ] Intro heading reads `Create Your Account`.
- [ ] Intro body reads `Start your legal learning journey with Nyaya` with `Nyaya` highlighted in gold.
- [ ] Sign-up card has soft elevation, large radius, and warm-white styling.
- [ ] Card header reads `Let's get you started`.
- [ ] Card subtext reads `Create an account to begin your journey`.
- [ ] All five labeled fields are present in the correct order.
- [ ] Password and Confirm Password fields include trailing visibility toggles.
- [ ] Password helper text is present below the password field.
- [ ] `SIGN UP` is the most visually dominant control in the card.
- [ ] Divider with `or` separates primary and Google actions.
- [ ] Google button is full-width and visually secondary.
- [ ] Terms row includes checkbox plus gold-highlighted legal links.
- [ ] Footer reads `Already have an account? Sign in` with `Sign in` in gold.
- [ ] Decorative bottom wave, dot pattern, and star accent are present.
