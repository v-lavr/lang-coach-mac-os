# LangCoach macOS app

LangCoach is a menu-bar writing assistant for macOS. It uses Accessibility permission
to detect a completed sentence in the focused editable field, sends that sentence to
the LangCoach API, and offers a correction popup. Text is changed only after the user
selects **Replace**.

## Requirements

- macOS 14 or later
- Xcode 15 or later
- A running LangCoach Laravel API, normally `https://lang-coach-s.test`
- A development Bearer token from `php artisan app:create-development-token`

## Run

1. Open `LangCoachApp.xcodeproj` in Xcode.
2. Select the **LangCoachApp** scheme and run it.
3. Grant Accessibility permission when macOS asks.
4. Open **Settings** from the menu-bar icon and enter:
   - **API URL:** `https://lang-coach-s.test`
   - **Bearer token:** your development token
5. Type a completed sentence in TextEdit. A correction popup appears when the API
   returns a changed result.

The app never reads or processes secure/password fields.

## API

The app sends `POST /api/check` with:

```json
{ "text": "I didn't knew about this." }
```

It sends the token as `Authorization: Bearer <token>`. The token field is for local
development only. Production should use Google sign-in or another secure authentication
flow and store credentials in Keychain.

## Build from Terminal

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  xcodebuild -project LangCoachApp.xcodeproj \
  -scheme LangCoachApp \
  -configuration Debug \
  build
```
