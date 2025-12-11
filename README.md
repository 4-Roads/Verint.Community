# Verint Community Extensions

## Overview
This repository hosts a comprehensive collection of open-source extensions and plugins for Verint Community (formerly Telligent Community). Developed and maintained by 4 Roads, these plugins extend the platform's core capabilities across various domains including analytics, security, content management, SEO, and third-party integrations.

## Included Plugins

### Analytics & Data
*   **ApplicationInsights**: Integrates Azure Application Insights for deep telemetry, error tracking, and usage analytics.
*   **PowerBI**: Synchronizes community data (content and users) to Microsoft Power BI for advanced reporting.

### Security & Spam Protection
*   **Mfa**: Adds Multi-Factor Authentication support to user logins.
*   **StopForumSpam**: Integrates with StopForumSpam.org to automatically detect and block spammer registrations.
*   **GPTZero**: Detects AI-generated content using the GPTZero API to help maintain content authenticity.
*   **Paywall**: Implements a configurable paywall system to restrict content access based on permissions or tags.

### SEO & Metadata
*   **MicroData**: Injects Schema.org microdata attributes into pages to improve SEO and search result appearance.
*   **MetaData**: Advanced metadata management for pages.
*   **ExtendedSearch**: Enhancements to the native search capabilities.

### Integrations
*   **AmazonS3**: Enables file storage offloading to Amazon S3 buckets.
*   **HubSpot**: Integration with the HubSpot platform.
*   **VidYardViewer**: Components for embedding and viewing VidYard videos.

### Community Features
*   **ForumLastPost**: Enhances forum listings to show detailed last post information.
*   **GroupDataExport**: Tools for exporting group-specific data.
*   **GroupMentionActivity**: Better handling of mentions within groups.
*   **PwaFeatures**: Adds Progressive Web App (PWA) capabilities to the community site.
*   **SocialProfileControls**: Additional UI controls for user profiles.
*   **Splash**: Functionality for splash screens or welcome modals.

### Developer & Utility
*   **ConfigurationExtensions**: Helper extensions for advanced configuration scenarios.
*   **RenderingHelper**: Utilities to assist with content rendering.
*   **MigratorFramework**: A framework to assist with data migration tasks.
*   **Installer**: Utilities to help with the installation of these components.

## Compatibility
This version is the development branch for Verint Community 13 (Telligent 13).

## Dependencies
The Verint Community Extensions require that you have installed and are running Verint Community. As such, this library has dependencies on assemblies that for licensing reasons are not made available as part of this solution. You will need to obtain these assemblies from the `\Web\bin` folder under the installation directory and copy all the dlls to the `\src\lib\Telligent` folder before compiling. If you would like to develop please add your Telligent web project to the folder `\src\code\_Website`.

.Net Framework 4.7.2

## Documentation
Each plugin folder in `src/code/` typically contains a `readme.md` with specific documentation for that component. Please refer to those files for detailed configuration and usage instructions.

#### How do I report a bug?
You can use the [issues section](https://github.com/4-Roads/FourRoads.Common.TelligentCommunity/issues/) of this repository to report any issues.

#### Can I contribute?
Please fork this project and make your own changes and enhancements, we can then review the pull requests and integrate features that you add.

#### Build status
![TeamCity build status](https://img.shields.io/teamcity/https/ci.4-roads.com/s/FourRoadsTelligentCommunity_Build.svg?style=plastic)

#### Support
This library is free. 4 Roads does offer support to all Telligent customers which is available through a support agreement. if you would like to join the many Telligent customers that partner with 4 Roads for support and enhancements and you would like to have a supported version of the library, please send an email to support@4-roads.com
