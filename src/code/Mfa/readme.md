# MFA (Multi-Factor Authentication) Plugin

## Overview

The MFA plugin adds multi-factor authentication (MFA) to Verint Community using time-based one-time passwords (TOTP) compatible with authenticator apps such as Google Authenticator and Microsoft Authenticator.

When MFA is enabled for a user, the platform will require a second-step verification after the user successfully signs in. The plugin also supports:

- Backup **one-time recovery codes** (for when a user loses access to their authenticator)
- Optional **email verification** (to validate an email address before allowing access)
- Role-based enforcement (require MFA for specific roles)
- Admin tools to disable MFA and/or force email re-validation for a user

## What users will experience

- After signing in, users who have MFA enabled (or are required to use MFA) are redirected to an MFA verification step.
- Users can set up MFA by scanning a QR code (or copying a manual setup key) into their authenticator app.
- Users can generate a set of backup one-time codes (10 codes) and use them if they cannot access their authenticator.

## Configuration (Control Panel)

Go to **Control Panel → System → Plugins → 4 Roads - MFA Plugin**.

### MFA Options

- **Mandatory Accounts** (`requireAllUsers`)
  - Select the roles that must have MFA enabled.
  - Users in these roles will be prompted to set up MFA.

- **Persistence** (`isPersistent`)
  - Controls how long a successful MFA verification is “remembered” via the MFA cookie.
  - Values:
    - **Off** (`Off`): MFA is required for any new browser session.
    - **User Defined** (`UserDefined`): Users can choose “Remember for N days”.
    - **Authentication Session** (`Authentication`): MFA cookie lifetime matches the platform authentication/session lifetime.

- **Persistence Duration** (`persistentDuration`)
  - Number of days to remember MFA when `isPersistent = UserDefined`.
  - Default: `90`

- **Time Tolerance** (`timeTolerance`)
  - Allows clock drift between servers when validating TOTP codes.
  - Unit: seconds
  - Default: `15`

- **MFA Cookie Same Site Setting** (`cookieSameSite`)
  - Controls the `SameSite` attribute for the MFA cookie.
  - Values: `Strict`, `Lax`, `None`
  - Default: `Lax`

- **Whitelist pages** (`whiteListPages`)
  - A list of paths that should not be blocked by MFA enforcement (one per line or separated by `,` / `;`).
  - Useful for pages like terms/privacy.
  - Note: the plugin already treats these as safe by default: `/login`, `/logout`, `/mfa`, `/user/changepassword`, `/verifyemail`, `/user/consent`, `/msgs`, `/register`.

### Email Options

- **Enable Email Verification** (`emailVerification`)
  - If enabled, users may be required to verify their email address (via a code sent by email) before continuing.
  - Default: `true`

- **Email Verification Expires After** (`emailVerificationExpirePeriod`)
  - Number of days after which an email verification expires and the user must re-validate.
  - Default: `0` (no expiration)

- **Email Cutoff Date** (`emailCutoffDate`)
  - For existing communities, this date can prevent users who joined before the cutoff date from being forced through email verification.

## Widgets and placement

This plugin ships with multiple scripted widgets. Typical placements:

- **4 Roads - MFA Validation** (ValidateMfa)
  - Shown during the MFA step to enter the authenticator code.
  - If `isPersistent = UserDefined`, shows a “Remember for N days” checkbox.

- **4 Roads - MFA Configuration** (SyncMfa)
  - User-facing setup/configuration screen.
  - Guides users through installing an authenticator app, scanning the QR code, and confirming the initial code.
  - Also provides backup code generation/regeneration.

- **4 Roads - MFA Settings** (MfaSettings)
  - Adds a “Manage MFA” link into the user settings page.

- **4 Roads - Email Validation** (ValidateEmail)
  - Lets a user enter an email verification code and request a new code.

- **4 Roads - Admin Disable MFA** (AdminDisableMfa)
  - Appears on user profile pages for administrators.
  - Allows admins to disable MFA for a user and (when required) trigger email validation.

- **User Consent**
  - Supports a consent step (`/user/consent`) used by the flow.

Exact placement depends on your site theme and login flow, but at minimum you typically need the MFA validation and MFA configuration pages available.

## Database / installation requirements

The plugin installs SQL objects used to store MFA secrets and one-time codes.

- SQL script: `src/code/Mfa/Resources/Sql/GoogleMFA.install.sql`
- Tables:
  - `fr_MfaKeys` (per-user MFA secret key)
  - `fr_MfaOTCodes` (per-user one-time recovery codes)

If your environment requires manual DB deployment, ensure these objects are applied and accessible.

## Operational notes

- The plugin uses TOTP, so server clocks should be kept accurate (NTP recommended), especially in multi-server environments.
- If you change cookie policy or reverse proxy behavior, review the `cookieSameSite` setting.

## Troubleshooting

- **Users stuck in a loop**: Check that the MFA validation page is reachable and that MFA cookies are not being blocked by `SameSite` or domain policy.
- **Codes never validate**: Verify server time sync; consider increasing `timeTolerance` slightly.
- **User lost access to authenticator**: Use backup one-time codes, or an administrator can disable MFA from the user profile using the Admin Disable MFA widget.
