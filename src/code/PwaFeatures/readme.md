# PWA Features

Adds Progressive Web App (PWA) capabilities to a Verint Community (Telligent) site:

- Serves a `manifest.json` and `serviceworker.js` from your community.
- Provides an offline fallback page.
- Adds “Add to Home Screen” UX for supported browsers.
- Supports web push notifications via Firebase Cloud Messaging (FCM).

This plugin is designed to be installed alongside its included widgets.

## What it does

### 1) PWA manifest, service worker, and offline page
The plugin registers these public URLs:

- `/manifest.json` (PWA manifest)
- `/serviceworker.js` (service worker)
- `/offline` (offline fallback page)

Those URLs are backed by a scripted widget panel which renders the JSON/JS/HTML dynamically.

### 2) “Add to Home Screen” banner
The included PWA widget (typically placed in the theme footer) listens for the browser’s `beforeinstallprompt` event and displays a simple install banner.

Users can dismiss the prompt; the dismissal is stored in browser `localStorage`.

### 3) Push notifications (Firebase)
When enabled and configured, the plugin registers a Firebase service worker and:

- Requests notification permission from the browser for logged-in users.
- Retrieves an FCM registration token.
- Stores that token against the current user in the community database.
- Sends push notifications for new notifications via the platform’s notification distribution pipeline.

## Requirements

- Verint Community / Telligent with plugin support.
- A Firebase project configured for Web Push (FCM).
- Ability to install SQL objects (table + stored procedures) into the community database.
- HTTPS is strongly recommended (and effectively required for service workers in modern browsers).

## Configuration

Configure the plugin in the Control Panel under the plugin settings for **4 Roads - PWA Features**.

### Firebase Push Configuration

- **SenderId** (`FirebaseSenderId`)
  - The Firebase sender ID used by the web app/manifest.

- **Config** (`FirebaseConfig`)
  - The Firebase “web app” configuration snippet from Firebase Console.
  - This value is emitted into the service worker / page output, so it must be valid JavaScript.
  - Source: Firebase Console → Project settings → Your apps (Web app) → config.

- **Server Key [PRIVATE]** (`FirebaseAdminJson`)
  - The Firebase Admin SDK JSON (service account) used server-side to send push notifications.
  - Source: Firebase Console → Project settings → Service accounts.
  - Treat this as sensitive. Do not share it; restrict who can view plugin configuration.

### “Configured” state
The plugin reports itself as configured only if all three values above are present.

## Installation

### 1) Enable the plugin
Deploy the plugin assembly/package as you do for other extensions in this solution, then enable **4 Roads - PWA Features**.

### 2) Install database objects
This plugin stores per-user FCM tokens in SQL.

The installer creates:

- Table: `dbo.fr_PwaTokens` (UserId + Token)
- Stored procedures:
  - `dbo.fr_PwaSession_StoreToken`
  - `dbo.fr_PwaSession_RevokeToken`
  - `dbo.fr_PwaSession_ListTokens`

If your deployment process does not run the embedded SQL installer automatically, execute the SQL from:

- [src/code/PwaFeatures/Resources/Sql/PWA.install.sql](src/code/PwaFeatures/Resources/Sql/PWA.install.sql)

### 3) Add the widgets
Two widgets are provided by this plugin:

- **4 Roads - PWA Features Footer Control**
  - Folder: [src/code/PwaFeatures/Resources/Widgets/PWAFeatures](src/code/PwaFeatures/Resources/Widgets/PWAFeatures)
  - Purpose:
    - Adds the `<link rel="manifest">` reference.
    - Registers the service worker on the client.
    - Shows the “Add to Home Screen” banner.
    - For logged-in users, loads Firebase client scripts and registers/unregisters the user’s token.
  - Recommended placement: theme footer (site-wide).

- **4 Roads - PWA Service Worker and Manifest**
  - Folder: [src/code/PwaFeatures/Resources/Widgets/CustomUrls](src/code/PwaFeatures/Resources/Widgets/CustomUrls)
  - Purpose:
    - Renders the content behind `/manifest.json`, `/serviceworker.js`, and `/offline`.

If you only add the footer control widget but not the CustomUrls widget, the URLs may not render the expected content.

## REST API (token registration)

To associate an FCM token with the currently logged-in user, the plugin exposes REST endpoints:

- `POST api.ashx/v2/user/firebase_token.json`
  - Parameters: `userId`, `token`
  - Stores the token for the user.

- `DELETE api.ashx/v2/user/firebase_token.json`
  - Parameters: `userId`, `token`
  - Revokes the token for the user.

Important behavior:

- The endpoint only stores/revokes a token if `userId` matches the current authenticated user.
- The footer widget calls these endpoints automatically during service worker registration and logout.

## How push delivery works

When the platform raises a new notification for a user, this plugin:

- Looks up all stored tokens for that user.
- Sends a Firebase multicast message containing:
  - `title`
  - `body`
  - `url`
  - `targetUserId`

The service worker shows a notification and uses `url` as the click target.

## Troubleshooting

### Manifest or service worker not loading
- Confirm these URLs return content:
  - `/manifest.json`
  - `/serviceworker.js`
  - `/offline`
- Confirm the **CustomUrls** widget is installed/enabled.
- Confirm you’re serving the site over HTTPS.

### Users never receive push notifications
- Confirm browser permission is granted for notifications.
- Confirm tokens are being stored:
  - Check `dbo.fr_PwaTokens` for rows for a test user.
- Confirm Firebase Admin JSON is valid.
- Confirm the Firebase project is configured for Web Push/FCM.

### “Add to Home Screen” banner never appears
- The banner relies on the browser firing `beforeinstallprompt` (not all browsers/devices do).
- If the user previously dismissed it, the widget stores a flag in `localStorage` and won’t show it again.

## Security notes

- `FirebaseAdminJson` is a private service-account credential; limit who can access plugin configuration.
- Treat push tokens as sensitive identifiers; protect database backups accordingly.
