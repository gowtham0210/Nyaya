# 019-articles Articles Tab

Status: Implemented
Last Updated: 2026-09-28
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`, `../../adr/0003-localization.md`
Source: GitHub issue #32 (parent #24). Ported from `nisha-frontend`
(`articles_screen`, `article_accordion_item`, `article_detail_screen`,
`articles_hero_photo.png`).

## Problem

The Articles tab is a "coming soon" placeholder, so learners can only learn
through quizzes.

## Goals

- The Articles tab lists backend articles, grouped by Constitution part,
  under a hero image.
- A learner can expand an article in place to skim it.
- An article detail screen shows the full text.

## Non-Goals

- Search in the tab (issue #40).
- Legal Updates tab inside Articles (Legal Updates live on Home, spec 020).
- Reloading when the language changes (done in spec 028, issue #35).

## Assumptions

- `GET /articles` returns `{ items: Article[] }` with `id`, `part`,
  `partTitle`, `title`, `slug`, `articleRange`, `description`,
  `whatItMeans`, `whyItMatters`, `keyFeatures` (`;`-separated) and
  `displayOrder`, in the `lang` language.

## Functional Requirements

- FR-001: When the Articles tab opens, the app shall load articles and show
  a loading indicator.
- FR-002: Articles shall be listed in `displayOrder`, under a header per
  part ("Part III · Fundamental Rights"), each numbered.
- FR-003: Tapping an article shall expand it in place to show its preview
  (`whatItMeans`, else `description`) and a "Read article" button; tapping
  again collapses it.
- FR-004: "Read article" shall open a detail screen with the title, article
  range, description, and the sections What it means, Why it matters and Key features;
  empty sections are hidden.
- FR-005: No articles shows an empty state; a failure shows the shared
  failure message with Retry.

## Acceptance Criteria

- AC-001: The repository maps articles, sorted by `displayOrder`; key
  features split on `;`.
- AC-002: The view model moves loading → loaded / empty / error, `load()`
  recovers, and tracks which article is expanded.
- AC-003: The tab shows the hero, part headers and numbered articles.
- AC-004: Tapping expands and collapses a preview; each article is a labelled
  button with expanded state.
- AC-005: "Read article" opens the detail with all non-empty sections.
- AC-006: Empty and error-with-Retry states render.
- AC-007: Strings are localized (e.g. Hindi); articles load with `lang`.
- AC-008: A blank part shows only its title; articles without an order go
  last; an expanded article fits large text on a small phone; the list
  shows a spinner while loading.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/features/articles/data/articles_repository_test.dart` |
| AC-002 | Unit | `test/features/articles/presentation/articles_view_model_test.dart` |
| AC-003–AC-007 | Widget | `test/features/articles/presentation/articles_page_test.dart` |
| AC-005 | Widget | `test/features/articles/presentation/article_detail_page_test.dart` |

## Open Questions

- Should the backend page long article lists?
