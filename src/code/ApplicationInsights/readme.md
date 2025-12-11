# Application Insights Plugin for Verint Community

## Overview

The Application Insights Plugin integrates [Azure Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) with Verint Community. It provides comprehensive telemetry, tracking key user and group events, unhandled exceptions, and web requests. This allows administrators and developers to monitor the health, performance, and usage patterns of their community.

## Features

*   **Telemetry Tracking**: Automatically sends telemetry data to Azure Application Insights.
*   **Event Tracking**: Captures specific community events related to Users and Groups.
*   **Exception Handling**: Automatically tracks unhandled exceptions in the web application and unobserved task exceptions.
*   **Request Filtering**: Includes built-in filtering to exclude synthetic requests (bots/crawlers) and specific URL paths (e.g., socket connections) to reduce noise and cost.
*   **User Context**: Enriches telemetry with User ID information where available.

## Configuration

Navigate to **Control Panel > System > Plugins > 4 Roads - Application Insights** to configure the plugin.

### Options

*   **Enabled**: Toggle to enable or disable the Application Insights integration. (Default: `False`)
*   **Instrumentation Key**: The Instrumentation Key from your Azure Application Insights resource.
*   **Exclude Synthetic Requests**: If enabled, requests identified as synthetic (e.g., availability tests, bots) will not be sent to Application Insights. (Default: `True`)
*   **Ignore Path Regex**: A regular expression to match URL paths that should be ignored. This is useful for filtering out high-volume, low-value traffic like socket connections or keep-alives.
    *   Default: `socket\.ashx|/utility/error-notfound\\.aspx`

## Tracked Events

The plugin automatically tracks the following custom events:

### User Events
*   `TelligentUserOnAfterCreate`: When a new user is created.
*   `TelligentUserOnAfterLockout`: When a user is locked out.
*   `TelligentUserOnBeforeDelete`: Before a user is deleted (includes reassigned user ID).
*   `TelligentUsersOnAfterAuthenticate`: When a user successfully logs in.

### Group Events
*   `TelligentGroupRoleAfterCreateEvent`: When a group role is created.
*   `TelligentGroupUserAfterCreateEvent`: When a user is added to a group.
*   `TelligentGroupUserAfterUpdateEvent`: When a group membership is updated.
*   `TelligentGroupUserAfterDeleteEvent`: When a user is removed from a group.

## Setup

1.  **Create Resource**: Create an Application Insights resource in the Azure Portal.
2.  **Get Key**: Copy the **Instrumentation Key** from the resource overview.
3.  **Install**: Install the plugin in your Verint Community site.
4.  **Configure**: Go to the plugin configuration, paste the Instrumentation Key, and check **Enabled**.
5.  **Save**: Save the configuration. Telemetry should start appearing in the Azure Portal shortly.
