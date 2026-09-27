
# AGENTS.md

## Project

English Coach is a small macOS writing assistant.

The repository contains:

- `LangCoachApp/` — native macOS application written in Swift/SwiftUI.
- `docs/` — product and technical documentation.

## Before Writing Code

Always read the relevant files in `/docs` before implementing or changing functionality.

The documentation defines the current product scope and expected behavior.

Do not introduce functionality that contradicts the documentation.

## Documentation

Documentation must stay synchronized with the implementation.

If during implementation you decide that behavior, architecture, API contracts, or product functionality should change:

1. Make the necessary code changes.
2. Update the relevant file in `/docs`.
3. Keep documentation concise and describe the actual implemented behavior.

Do not leave documentation describing behavior that no longer exists.

Small implementation details that do not affect behavior or architecture do not require documentation updates.

## Development Principles

This is an MVP/prototype.

Prefer:
- simple implementations
- small classes/services
- native platform APIs
- working end-to-end functionality
- explicit code over unnecessary abstractions

Avoid:
- premature abstractions
- unnecessary dependencies
- speculative features
- infrastructure not required by the MVP
- production-scale solutions for prototype problems

Implement the smallest working vertical slice first.

## Build Verification

After modifying Swift code, build the project and resolve compiler errors before considering the task complete.

Do not report an implementation as complete if the Xcode project does not build.
