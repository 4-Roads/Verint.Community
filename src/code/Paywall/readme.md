# Paywall Plugin for Verint Community

## Overview

The Paywall Plugin for Verint Community allows you to restrict access to content based on user permissions and tags. It can truncate the content body for unauthorized users and display a customizable popup widget prompting them to register or log in. This is useful for creating a "freemium" content model or encouraging user registration.

## Features

*   **Content Truncation**: Automatically truncates the body of content items (threads, blog posts, etc.) for users who do not have permission to bypass the paywall.
*   **Conditional Blocking**: Can be configured to block all content or only content tagged with specific tags.
*   **Paywall Popup Widget**: A configurable widget that appears when a user views restricted content, encouraging them to sign up.
*   **Bypass Permission**: A specific permission ("By Pass Paywall") allows designated roles (e.g., Premium Members) to view full content.
*   **View Limits**: The widget can be configured to allow a certain number of free views before appearing (cookie-based).
*   **Delay Timer**: The popup can be delayed by a configurable number of seconds.

## Configuration

### Plugin Configuration

Navigate to **Control Panel > System > Plugins > 4 Roads Paywall** to configure the core behavior:

*   **Truncate Text Length**: The number of characters to show before truncating the content (Default: 500). Set to 0 to disable truncation (though this is the primary mechanism).
*   **Show Paywall Popup**: Check this to enable the signaling for the popup widget (Default: true).
*   **Enable Debugging**: Logs detailed information to the Event Log for troubleshooting (Default: false).
*   **Tag Names**: A list of tags. If specified, only content tagged with one of these tags will be subject to the paywall. If left empty, **ALL** content is subject to the paywall (unless the user has the bypass permission).

### Widget Configuration

The **4 Roads - Paywall** widget should be added to the relevant pages (e.g., Blog Post View, Thread View) via the Widget Studio or Page Editor.

*   **Title**: The header text for the widget.
*   **Display Delay (Seconds)**: The number of seconds to wait before showing the popup after the page loads.
*   **Views Before Display**: The number of times a user can view restricted content before the popup starts appearing (uses a cookie).

## Permissions

The plugin registers a new permission called **By Pass Paywall**.

*   **Location**: This is an application-level permission.
*   **Usage**: Grant this permission to roles (e.g., Administrators, Moderators, Paid Subscribers) that should **NOT** see the paywall and should always see full content.
*   **Default**: Administrators, Managers, Moderators, Members, and Owners are typically granted this by default, but you should review and adjust this based on your needs (e.g., revoke it for "Members" if you want them to hit the paywall).

## Usage

1.  **Install** the plugin.
2.  **Configure** the plugin settings in the Control Panel (set truncation length and optional tags).
3.  **Grant/Revoke Permissions**: Go to the permissions for your community applications (e.g., a specific Blog or Forum) and configure the "By Pass Paywall" permission. Ensure that the "Everyone" or "Guest" roles do **not** have this permission if you want them to see the paywall.
4.  **Add the Widget**: Enter the site editor and add the "4 Roads - Paywall" widget to the content detail pages (e.g., "Blog - Post", "Forum - Thread").
5.  **Test**: Access a piece of content as a user without the bypass permission to verify the content is truncated and the popup appears.
