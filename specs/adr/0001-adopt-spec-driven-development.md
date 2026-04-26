# ADR 0001 Adopt Spec-Driven Development

Status: Accepted
Date: 2026-04-26
Supersedes:
Superseded By:

## Context

Nyaya is at an early stage with minimal code and no stable product process. The
team wants to avoid ad hoc feature development and wants the repository itself
to preserve feature intent, architectural rationale, and test traceability.

The app is also a Flutter project, so any process choice should align with
Flutter's current architecture and testing guidance rather than fight it.

## Options Considered

1. Keep a lightweight repo-local SDD workflow with Markdown specs, plans, tasks,
   and ADRs.
2. Keep using ad hoc chat threads, TODO comments, and code-first iteration.
3. Adopt an external SDD toolkit immediately as a hard dependency.

## Decision

Adopt option 1.

Nyaya will use repo-local Markdown artifacts under `specs/` as the primary
source of truth. Each meaningful feature will have a numbered feature folder
with `spec.md`, `plan.md`, and `tasks.md`. Significant technical choices will
be documented as ADRs in `specs/adr/`.

This workflow is intentionally lightweight. It borrows the structure of modern
SDD toolkits without making Nyaya dependent on a specific external CLI or agent
workflow.

## Consequences

- Positive: Product intent, design rationale, and verification stay versioned
  with the codebase.
- Positive: The team can adopt stronger automation later without restructuring
  the repository again.
- Positive: Reviews can discuss spec drift explicitly instead of inferring
  intent from implementation only.
- Negative: Feature work now has a mandatory documentation step before code.
- Negative: The team must maintain specs and ADRs as living artifacts.

## Links

- `../README.md`
- `../project-constitution.md`
- `../features/001-home-shell/spec.md`
