# 013-categories Categories Design Specification

Status: Implemented
Last Updated: 2026-08-10
Source Mockup: user-supplied reference screenshot (tinted category cards), applied 2026-08-10.

## Design Overview

A main-tab screen matching Home's ivory background and navy/gold palette: serif navy header with a decorative emblem, search field with a filter button, two-column grid of color-tinted category cards, and the shared bottom nav with "Categories" active.

## Visual Components

### 1. Header
- Serif navy "Categories" title, bodyGrey two-line supporting copy ("Explore topics and strengthen your legal knowledge.").
- Right-aligned decorative emblem: 84px gold-tinted circle, faint temple watermark, gold balance icon, two small sparkle accents.
- No back arrow (top-level tab).

### 2. Search Row
- Rounded white search field (search icon, "Search categories" hint) plus a 52px ivory filter button (`Icons.tune_rounded`) to its right.

### 3. Category Grid
- Two columns, 14px gaps. Each card fills with a pastel tint color (`category.tintHex`) instead of a white card — no border.
- 52px white/translucent circle icon avatar with a category-specific icon color (`category.iconHex`).
- Bold navy label (2 lines max), bodyGrey "N topics" meta on the same row as a 32px white circular arrow-forward button.

### 4. Empty State
- Centered icon + "No categories match your search" when filtered list is empty.

### 5. Bottom Nav
- Owned by the tab shell (spec 016); Categories is tab index 1.

## Color and Type

Shared constants from `nyaya_widgets.dart` and `nyaya_bottom_nav.dart` (navy/heroBackground `#11233B`, gold `#C89B3C`, cardBorder `#ECE5DB`, bodyGrey). Each category carries its own pastel tint/icon color pair (blue, red, green, purple, amber, teal, pink) cycled across the sample data. Serif via `fontFamily: 'serif'` for the header, matching Home/Topic Detail.

## Interaction

- Tap category card → `onCategorySelected(categoryId)`.
- Type in search → filters grid in place.
- Tap filter button → placeholder ("Filters are not wired yet.") until filtering is scoped.
- Tap bottom nav item → `onNavigationSelected(index)`.

## Validation Checklist

- [x] Header and bottom nav render with Categories tab active.
- [x] Grid renders all sample categories with topic counts, tint, and icon colors.
- [x] Search filters live; empty state shows on no match.
- [x] Card tap and nav tap report correctly.
