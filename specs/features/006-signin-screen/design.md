# 006-signin-screen Sign In Screen Design Specification

Status: Draft
Last Updated: 2026-04-29
Source Screenshot: Provided by user (Sign In Screen design)

## Design Overview

The Sign In Screen provides a visually rich and secure-feeling authentication gateway. It combines the strong brand identity of Nyaya with a clean, structured form inside an elevated card. The screen balances aesthetics (illustrations, background elements) with functional clarity, offering clear paths for both existing and new users.

---

## Visual Components

### 1. Brand Lockup (Top Left)

- **Composition**: The complete Nyaya brand lockup.
  - **Logo**: Golden scales of justice intertwined with a dark navy serif 'N'.
  - **Wordmark**: `NYAYA` in large, bold dark navy serif text.
  - **Divider**: A thin gold horizontal line with a small outlined diamond in the center.
  - **Tagline**: `LAW BASED QUIZ APP` in gold, sans-serif, uppercase, widely tracked text.
- **Position**: Top-left aligned, starting just below the safe area.

### 2. Hero Illustration (Middle Right)

- **Composition**: A 3D-style illustration featuring:
  - A stack of three law books:
    - Top book: Navy blue with `LAW` in gold.
    - Middle book: Brown/Bronze with `JUSTICE` in gold.
    - Bottom book: Beige/Ivory with `KNOWLEDGE` in gold.
  - A dark brown wooden gavel and sound block resting next to the books.
  - Golden laurel branches extending upward from behind the books.
- **Position**: Anchored to the right side of the screen, slightly overlapping the brand area and welcome text vertically.

### 3. Welcome Messaging (Middle Left)

- **Heading**: `Welcome to Nyaya`
  - **Color**: Dark Navy `#1A2C3D`
  - **Font**: Serif, Bold
  - **Font size**: ~24–28sp
- **Subtext Line 1**: `Test your knowledge.`
  - **Color**: Muted Grey `#4A5568`
  - **Font**: Sans-serif, Regular
- **Subtext Line 2**: `Master justice.`
  - `Master` in Muted Grey `#4A5568`.
  - `justice.` in Gold `#C89B3C`.
- **Position**: Left-aligned, below the brand lockup.

### 4. Sign-In Card (Container)

- **Style**: White `#FFFFFF` container with rounded corners (~20px radius).
- **Shadow**: Subtle, soft drop shadow to elevate it above the background.
- **Padding**: Generous inner padding (~24px).
- **Width**: Almost full screen width with horizontal margins (~16-20px).
- **Position**: Centered, starting below the welcome messaging and illustration.

### 5. Card Header

- **Heading**: `Already have an account?`
  - **Color**: Dark Navy `#1A2C3D`
  - **Font**: Serif, Bold
  - **Alignment**: Center
- **Subtext**: `Sign in to continue your learning journey`
  - `Sign in to continue your ` in Muted Grey `#4A5568`.
  - `learning journey` in Gold `#C89B3C`.
  - **Font**: Sans-serif, Regular
  - **Alignment**: Center

### 6. Form Fields

#### Email / Phone Number Field
- **Label**: `Email / Phone Number` (Dark Navy `#1A2C3D`, Sans-serif, Bold, small size).
- **Input Box**:
  - Border: Thin, light grey rounded rectangle.
  - Prefix Icon: User outline icon (Grey).
  - Placeholder: `Enter your email or phone number` (Light Grey).

#### Password Field
- **Label**: `Password` (Dark Navy `#1A2C3D`, Sans-serif, Bold, small size).
- **Input Box**:
  - Border: Thin, light grey rounded rectangle.
  - Prefix Icon: Lock outline icon (Grey).
  - Placeholder: `Enter your password` (Light Grey).
  - Suffix Icon: Eye outline icon (Grey, for toggling visibility).

#### Forgot Password Link
- **Text**: `Forgot Password?`
- **Color**: Gold `#C89B3C`
- **Font**: Sans-serif, Regular, small size.
- **Alignment**: Right-aligned below the password field.

### 7. Actions

#### SIGN IN Button
- **Style**: Full-width rounded rectangle (pill shape).
- **Background**: Dark Navy `#1A2C3D`.
- **Text**: `SIGN IN` (White `#FFFFFF`, Sans-serif, Bold, Uppercase).

#### Divider
- **Style**: Thin horizontal light beige/grey line with text `or` in the middle (Muted Grey `#4A5568`).

#### SIGN UP Section
- **Heading**: `New to Nyaya?` (Dark Navy `#1A2C3D`, Serif, Bold).
- **Subtext**: `Create an account and start your ` (Grey) + `legal learning journey` (Gold).
- **SIGN UP Button**:
  - **Style**: Full-width rounded rectangle (pill shape), outlined.
  - **Border**: Gold `#C89B3C`.
  - **Background**: Transparent/White.
  - **Icon**: Add user outline icon (Gold).
  - **Text**: `SIGN UP` (Gold `#C89B3C`, Sans-serif, Bold, Uppercase).

### 8. Footer Trust Badge

- **Composition**: Shield icon with a checkmark + text `Secure & trusted by learners`.
- **Color**: Muted Grey `#4A5568`.
- **Font**: Sans-serif, small size.
- **Alignment**: Center, below the sign-in card.

### 9. Background & Decorative Ornaments

- **Background color**: Warm Ivory `#FBF7F1`.
- **Top Right Background**: Faded courthouse/temple pillar image (opacity ~10-15%).
- **Bottom Waves**: Smooth swooping shapes in warm beige/light gold at the bottom of the screen.
- **Dot Pattern**: 5x4 dot grid pattern on the bottom left (light gold).
- **Star Accent**: A 4-point gold sparkle star overlapping the bottom wave on the right.

---

## Layout & Composition

### Proportions

- The top section (Brand, Illustration, Welcome text) takes up about ~35-40% of the vertical space.
- The sign-in card takes up the majority of the remaining space (~55-60%).
- The layout must be enclosed within a scrollable view to accommodate smaller devices or when the keyboard is open.

### Key Spacing Values

| Element | Spacing / Gap |
|---|---|
| Brand Lockup → Welcome Heading | ~32px |
| Welcome Heading → Subtext | ~8px |
| Subtext → Sign-in Card | ~24px |
| Card Header → Form Fields | ~24px |
| Form Fields Spacing | ~16px |
| Password Field → Forgot Password | ~8px |
| Forgot Password → SIGN IN Button | ~16px |
| SIGN IN Button → Divider | ~24px |
| Divider → SIGN UP Heading | ~24px |
| SIGN UP Heading → Button | ~16px |
| Card Bottom → Trust Badge | ~24px |

---

## Color Reference

| Token | Hex | Usage |
|---|---|---|
| `ivory` | `#FBF7F1` | Background |
| `navy` | `#1A2C3D` | Text, Logos, SIGN IN button |
| `gold` | `#C89B3C` | Highlights, Outlines, Links, Sign up button |
| `bodyGrey` | `#4A5568` | Subtext, Labels, Trust badge |
| `lightGrey` | `#E2E8F0` | Input borders, placeholders (approx) |
| `white` | `#FFFFFF` | Card background, SIGN IN text |

---

## Typography Reference

| Element | Font | Weight | Color |
|---|---|---|---|
| Brand Wordmark | Serif | Bold | navy |
| Brand Tagline | Sans-serif | Medium/Bold | gold |
| Headings | Serif | Bold | navy |
| Subtext/Body | Sans-serif | Regular | bodyGrey/gold |
| Input Labels | Sans-serif | Bold | navy |
| Button Text | Sans-serif | Bold | white/gold |
| Small Links | Sans-serif | Regular | gold |

---

## Asset Requirements

| Asset | Path | Notes |
|---|---|---|
| Brand Lockup | `assets/brand/logo_lockup.png` | Or composed via widgets. |
| Hero illustration | `assets/images/signin_hero.png` | Books, gavel, laurel. |
| Temple background | `assets/backgrounds/temple_bg.png` | Existing — reuse. |
| User Icon | (Flutter icon) | Outline |
| Lock Icon | (Flutter icon) | Outline |
| Eye Icon | (Flutter icon) | Outline |
| Add User Icon | (Flutter icon) | Outline |
| Shield Check Icon | (Flutter icon) | Outline |
