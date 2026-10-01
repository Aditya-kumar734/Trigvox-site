TRIGVOX — OFFLINE-FIRST WEB/PWA BUILD

Changes in this build:
- Contacts are cached on the device so the emergency flow can still work without internet.
- Call history is cached locally and synced to Supabase when a connection is available.
- The countdown, voice cancellation and phone hand-off do not require Supabase to be online.
- Live location cloud syncing only happens when a network connection exists.
- Added Online / Offline mode indicator.
- Added a clear explanation that a web/PWA cannot silently place a SIM call.
- The phone OS receives the number through tel:. A true one-tap direct SIM call requires a native Android app using the appropriate CALL_PHONE permission and Android rules.

Voice cancellation:
Settings -> Voice Cancellation Phrase. Browser speech recognition support varies by browser/device and is not guaranteed in the background or while the screen is locked.

Supabase:
Keep the anon/public key only. Never put a Supabase service_role key in the frontend.
