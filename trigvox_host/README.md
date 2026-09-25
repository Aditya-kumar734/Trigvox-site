# Trigvox Web

A browser-hostable Trigvox prototype with:
- account creation and login (local browser demo)
- per-user contacts and settings
- call history
- 10-second safety countdown with beep
- voice cancellation with a user-defined phrase where browser speech recognition is supported
- optional browser location permission and Google Maps location link
- SMS compose action for sharing location
- optional emergency fallback number (default 112)
- Vercel-ready static hosting

## Deploy
Upload this folder to Vercel, or import it into a GitHub repository and deploy as a static site. No build command is required.

## Important production note
This version's login/data are stored in localStorage, so it is NOT a production secure authentication system and users do not share a cloud account database. For real multi-device accounts, encrypted server-side data, admin controls, and production security, connect the UI to Supabase/Firebase or a custom HTTPS backend.

The browser cannot silently send SMS or place an automatic emergency call. It opens the device's normal phone/SMS interface. Native Android is required for deeper Telecom/SIM/background-location capabilities.

## Updated Trigvox safety flow
- User-defined voice cancellation phrase.
- Louder countdown beep with short duration.
- Countdown remains visible and cancellation stops the pending call before the phone action.
- Added PWA manifest and service worker for installable web-app testing.

## Important calling limitation
A hosted web page cannot guarantee a silent, direct SIM call. `tel:` is handled by the operating system/browser and may open the dialer or confirmation UI. A true one-tap/direct call after the countdown requires a native Android build with the appropriate `CALL_PHONE` permission and device/OS rules. Do not treat the web prototype as a guaranteed emergency-call mechanism.
