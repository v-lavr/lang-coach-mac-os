# Architecture

## Overview

English Coach consists of two main applications:

macOS Client
    ↓
Laravel API
    ↓
AI services + MySQL

## macOS

Technology:

- Swift
- SwiftUI
- AppKit when necessary
- macOS Accessibility API / AXUIElement
- URLSession
- UserDefaults

Responsibilities:

- run as menu-bar application
- detect active editable element
- detect completed sentences
- communicate with backend
- display correction popup
- replace text after user confirmation
- display settings and statistics

The macOS client should not contain business logic that belongs to the backend.

## Backend

Technology:

- Laravel
- MySQL

Responsibilities:

- receive sentences
- perform grammar correction
- normalize AI responses
- store corrections and errors
- calculate statistics
- generate learning recommendations

## AI

Two types of AI processing are planned.

### Grammar Correction

A small/local model should eventually handle frequent sentence corrections.

Initial development may use OpenAI if that allows the end-to-end flow to be implemented faster.

### Recommendations

OpenAI is used for higher-level analysis:

- recurring error analysis
- explanations
- learning recommendations

## API

Initial endpoints:

POST `/api/check`

Checks one completed sentence.

GET `/api/stats`

Returns correction/error statistics.

GET `/api/recommendations`

Returns personalized learning recommendations.

When enabled, `POST /api/check` accepts `{ "text": "completed sentence" }` and returns `changed`,
`original`, `corrected`, and an `errors` array with `type`, `original`, `replacement`,
and `explanation`. The macOS client uses URLSession and gets its base URL and bearer
token from settings. The token is sent as an `Authorization: Bearer <token>` header.

The bearer token is a development-only setting. Production authentication should use
Google sign-in or another production authentication flow, with credentials stored in
Keychain rather than UserDefaults.

## Persistence

MySQL stores:

- users
- corrections
- individual detected errors

Laravel is the source of truth for correction history and statistics.
