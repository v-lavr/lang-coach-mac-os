# MVP Scope

## Required

The MVP should demonstrate this complete flow:

User types incorrect English
→ sentence is detected
→ backend checks sentence
→ correction appears
→ user presses Replace
→ text is replaced
→ error is stored by the backend.

The first implemented vertical slice stops after replacement. Statistics and
recommendations remain later phases, as described by the development priority below.

## Security / Privacy

Do not process secure or password fields.

Send only the completed sentence required for correction.

Do not send the entire document or input contents when only one sentence needs checking.

## Not in MVP

Do NOT implement unless the scope is explicitly changed:

- App Store distribution
- billing
- subscriptions
- registration UI
- OAuth/social login
- password reset
- teams/organizations
- Windows application
- iOS application
- browser extension
- cloud synchronization beyond the backend API
- rich text editing
- document editor
- translation
- autocomplete
- text generation
- full Grammarly feature parity
- complex user profiles
- admin panel
- notifications
- CoreData/SwiftData persistence
- complex dependency injection
- analytics infrastructure
- microservices unless required for local AI inference
- queues unless a real need appears

## Compatibility

Do not attempt to support every macOS application during MVP development.

Start with a small number of applications where Accessibility API integration works reliably.

TextEdit or another simple native text field should be used as the first integration target.

Additional applications can be tested after the complete flow works.

## Development Priority

Always prioritize:

1. Read active text.
2. Detect completed sentence.
3. Call backend.
4. Show correction.
5. Replace text.

Only then implement:

6. Persistence.
7. Statistics.
8. Recommendations.
9. UI polish.

If a feature threatens the prototype timeline, simplify it rather than expanding the architecture.
