# ADR 0002 Data Layer: API Client → Repository → View Model

Status: Accepted
Date: 2026-09-28
Supersedes:
Superseded By:

## Context

Nyaya now talks to its own backend (`/api/v1`) for categories, articles,
legal updates, profile and help resources. The `nisha-frontend` branch had
one HTTP service per domain, each repeating URL building, token handling,
language query and error mapping. `main` had only the auth API client.

## Options Considered

1. One shared `ApiClient` in core; one repository per domain; view models
   load through repositories.
2. One service class per domain, each owning its own HTTP code (Nisha's
   approach).
3. A code-generated client from the backend OpenAPI schema.

## Decision

Adopt option 1.

- `ApiClient` (core/network) owns base URL, JSON encoding, bearer token,
  one refresh-and-retry on 401, the `lang` query for non-English content,
  and maps every failure to a small sealed `ApiException` set.
- Repositories (feature `data/`) map JSON to plain models. No UI state.
- View models (feature `presentation/`) expose a load state
  (loading, loaded, empty, error) and are injected into pages.
- Tests fake the backend at one seam only: `ApiClient` takes an
  `http.Client`, and tests pass `package:http`'s `MockClient`.

## Consequences

- Positive: One place for auth, errors and language; features stay small.
- Positive: One test seam; no per-repository mocks.
- Negative: Tests carry canned JSON that must track the backend schema.
- Negative: Option 3 would catch schema drift at build time; deferred until
  the backend schema is stable.

## Links

- `../features/014-api-client/spec.md`
- `../porting-plan.md`
