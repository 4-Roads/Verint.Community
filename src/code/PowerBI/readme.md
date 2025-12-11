# Power BI Connector for Verint Community

## Overview

The Power BI Connector for Verint Community enables you to push community data directly into Microsoft Power BI. This allows you to create rich visualizations and reports based on your community's activity and user data. The plugin synchronizes content (forum threads, replies, blog posts, wiki pages, comments) and user profiles to a Power BI dataset.

It also integrates with Azure Text Analytics and IBM Watson NLP to automatically extract key phrases from your content, enabling sentiment and topic analysis within Power BI.

## Features

*   **Content Synchronization**: Automatically pushes new and updated content (Threads, Replies, Blog Posts, Wiki Pages, Comments) to Power BI as they are indexed.
*   **User Profile Synchronization**: Periodically synchronizes user profile data to Power BI via a background job.
*   **NLP Integration**: Supports Azure Text Analytics and IBM Watson NLP for keyword extraction from content.
*   **Automatic Dataset Creation**: Automatically creates the necessary Dataset, Tables, and Relationships in Power BI if they don't exist.
*   **Customizable User Fields**: Allows you to select which User Profile fields to synchronize.

## Configuration

After installing the plugin, navigate to the plugin configuration in the Control Panel to set up the connection.

### Power BI Settings

*   **Power BI User Name**: The username for the Power BI account.
*   **Power BI User Password**: The password for the Power BI account.
*   **App Client Id**: The Client ID of the Azure AD application registered for Power BI access.
*   **Group Name (optional)**: The name of the Power BI Workspace (Group) to use. If left blank, it uses "My Workspace".
*   **Dataset Name**: The name of the dataset to create/use in Power BI (Default: "Community").
*   **Table Name**: The name of the table to store content posts (Default: "Posts").

### URLs

These settings typically do not need to be changed unless you are using a specific environment.

*   **Azure AD authority Url**: Default: `https://login.windows.net/common/oauth2/authorize/`
*   **Azure AD resource Url**: Default: `https://analysis.windows.net/powerbi/api`
*   **API Url**: Default: `https://api.powerbi.com/`

### Azure Analytics (Optional)

Configure this section to use Azure Text Analytics for keyword extraction.

*   **Azure Analytics Region**: The region where your Azure Text Analytics resource is deployed (e.g., "Westeurope").
*   **Text Analytics API Key**: The API Key for your Azure Text Analytics resource.
*   **Test Integration**: Use the provided button to test the connection to Azure Text Analytics.

### Watson Analytics (Optional)

Configure this section to use IBM Watson NLP for keyword extraction.

*   **NLP Url**: The URL for the Watson Natural Language Understanding API.
*   **NLP API Key**: The API Key for your Watson service.
*   **Test Integration**: Use the provided button to test the connection to Watson NLP.

### User Profile Fields

*   **Fields**: Select the User Profile fields you want to synchronize to Power BI.

## Setup & Prerequisites

1.  **Azure AD App Registration**: You must register an application in Azure Active Directory to allow the plugin to authenticate with Power BI.
    *   The application requires permissions to access the Power BI Service.
    *   You will need the **Client ID** from this registration.
    *   **Note**: Since the plugin uses the "User Password" flow, you may need to grant permissions in the Azure Portal (click "Grant permissions" in the "Required permissions" blade).

2.  **Power BI Account**: A Power BI account is required. The configured user must have access to the specified Workspace (Group).

## How it Works

### Content Sync
The plugin hooks into the `BeforeBulkIndex` event of the search indexing process. Whenever content (Threads, Replies, Blogs, Wikis, Comments) is indexed, it is also pushed to the configured Power BI Dataset.

### User Sync
A background job ("4 Roads - Power BI - User Update Job") runs periodically (default: every 12 hours) to synchronize user profile data. This job pushes user details and selected profile fields to the "UserProfiles" table in Power BI.

### Data Model
The plugin creates a Dataset with the following tables:
*   **Posts**: Contains content data (Title, Content, Author, Date, etc.) and extracted Key Phrases.
*   **UserProfiles**: Contains user data (UserName, Join Date, Total Posts, etc.).
*   **Keywords**: Contains individual keywords extracted from content for easier filtering.

Relationships are automatically created:
*   `Posts.Author` -> `UserProfiles.UserName`
*   `Posts.Id` -> `Keywords.Id`

