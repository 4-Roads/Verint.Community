# MicroData Extensions for Verint Community

## Overview

The MicroData Extensions plugin allows you to inject [Schema.org](http://schema.org) microdata attributes into your Verint Community pages. This helps search engines (like Google, Bing, Yahoo, and Yandex) understand the content of your site better, potentially improving your SEO and enabling rich snippets in search results.

The plugin works by post-processing the rendered HTML of your pages and adding attributes like `itemscope`, `itemtype`, and `itemprop` to elements that match specific CSS selectors.

## Features

*   **Dynamic Injection**: Injects microdata attributes into existing HTML without modifying themes or widgets.
*   **Content Type Targeting**: Apply rules globally or target specific content types (e.g., only Blog Posts, only Forum Threads).
*   **CSS Selector Based**: Uses standard CSS selectors to identify elements to annotate.
*   **Configurable**: Comes with a comprehensive default configuration for standard Verint Community themes, which can be customized via the Control Panel.
*   **Supported Attributes**:
    *   `itemscope`: Defines a new item.
    *   `itemprop`: Defines a property of an item.
    *   `rel`: Defines the relationship between the current document and the linked document.
    *   `boolean`: Sets a boolean attribute.

## Configuration

Navigate to **Control Panel > System > Plugins > 4 Roads - MicroData Extensions** to configure the plugin.

The configuration interface provides a grid where you can define the rules for injecting microdata.

### Rule Properties

*   **Content Type**: The specific content type this rule applies to. If left blank, the rule applies to all pages.
*   **Selector**: The CSS selector used to find the HTML element(s) to annotate.
*   **Type**: The type of microdata attribute to add:
    *   `itemscope`: Adds `itemscope` and sets `itemtype` to the specified **Value**.
    *   `itemprop`: Adds `itemprop="Value"`.
    *   `rel`: Adds `rel="Value"`.
    *   `boolean`: Adds the attribute specified in **Value** as a boolean attribute (e.g., `checked`).
*   **Value**: The value to assign to the attribute (e.g., the Schema.org URL for `itemscope`, or the property name for `itemprop`).

## Default Configuration

The plugin includes a default configuration optimized for the standard Verint Community theme structure. It covers:

*   **Blogs**:
    *   Marks the page as `http://schema.org/BlogPosting`.
    *   Annotates author, date published, name (title), and text (body).
*   **Forums**:
    *   Marks the page as `http://schema.org/Article`.
    *   Marks threads/replies as `http://schema.org/Comment`.
    *   Annotates creator, name, and text.
*   **Media Galleries**:
    *   Marks the page as `http://schema.org/MediaObject`.
    *   Annotates content URL, name, creator, and text.
*   **Comments**:
    *   Marks comments as `http://schema.org/Comment`.
    *   Annotates text and creator.
*   **Users**:
    *   Marks user links/avatars as `http://schema.org/Person`.
    *   Annotates name, author relationship, and image.

## Usage

1.  **Install** the plugin.
2.  **Enable** the plugin in the Control Panel.
3.  **Review** the default configuration. If you are using a custom theme, you may need to adjust the **Selectors** to match your theme's HTML structure.
4.  **Validate**: Use the [Google Rich Results Test](https://search.google.com/test/rich-results) or [Schema.org Validator](https://validator.schema.org/) to verify that your pages are correctly marked up.
