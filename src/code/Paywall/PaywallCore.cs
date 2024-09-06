using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using Telligent.Evolution.Extensibility;
using Telligent.Evolution.Extensibility.Api.Version1;
using Telligent.Evolution.Extensibility.Api.Version2;
using Telligent.Evolution.Extensibility.Security.Version1;
using Telligent.Evolution.Extensibility.Urls.Version1;
using Telligent.Evolution.Extensibility.Version1;
using Telligent.Evolution.Urls.Routing;
using IPermissions = Telligent.Evolution.Extensibility.Api.Version2.IPermissions;
using PropertyGroup = Telligent.Evolution.Extensibility.Configuration.Version1.PropertyGroup;
using Property = Telligent.Evolution.Extensibility.Configuration.Version1.Property;
using IPluginConfiguration = Telligent.Evolution.Extensibility.Version2.IPluginConfiguration;
using IConfigurablePlugin = Telligent.Evolution.Extensibility.Version2.IConfigurablePlugin;

namespace FourRoads.VerintCommunity.Paywall
{
    // ReSharper disable once UnusedType.Global
    public class PaywallCore : IPermissionRegistrar, ITranslatablePlugin, IConfigurablePlugin, IPluginGroup
    {
        private ITranslatablePluginController _translationController;

        public void Initialize()
        {
            Apis.Get<IHtml>().Events.Render += EventsOnRender;
        }

        private void Log(string message)
        {
            if (!EnableDebugging) return;

            message += $" {TaggingEnabled} {TagNames.Count} {string.Join(",", TagNames)}";
            Apis.Get<IEventLog>().Write(message, new EventLogEntryWriteOptions
            {
                Category = "Paywall",
                EventType = "Information"
            });
        }

        private void EventsOnRender(HtmlRenderEventArgs e)
        {
            if (string.Compare(e.RenderedProperty, "Body", StringComparison.OrdinalIgnoreCase) != 0)
            {
                //not interested in anything other than the body
                return;
            }

            PageContext currentContext = Apis.Get<IUrl>().CurrentContext;
            if (currentContext?.ApplicationTypeId == null)
            {
                //not interested if we do not have an application page
                return;
            }

            var items = currentContext.ContextItems.GetAllContextItems();
            if (items == null || items.Count <= 0)
            {
                //not interested if we do not have any context items
                return;
            }

            var accessingUserId = Apis.Get<IUsers>().AccessingUser.Id.GetValueOrDefault(0);
            Log($"Paywall debug : {accessingUserId} {currentContext.PageName} " +
                $"{currentContext.UrlName} {currentContext.ApplicationTypeId} " +
                $"{JsonConvert.SerializeObject(items, Formatting.None)}");

            // are we viewing a piece of content ?
            IContextItem contextItem = items.FirstOrDefault(v =>
                v.ApplicationTypeId == currentContext.ApplicationTypeId &&
                v.ApplicationTypeId != v.ContentTypeId);
            if (contextItem?.ApplicationId == null)
            {
                //not interested if we do not have a content item
                return;
            }

            Log($"Paywall checking : {accessingUserId} {currentContext.PageName} " +
                $"{currentContext.UrlName} {currentContext.ApplicationTypeId}");

            var isUserAllowed = IsUserAllowed(accessingUserId, currentContext, contextItem);
            if (isUserAllowed || (TaggingEnabled && !ContentHasTag(contextItem.ContentId, contextItem.ContentTypeId)))
            {
                //user is allowed to view the content
                //tagging is enabled and content is not tagged with the tag name
                Log($"Paywall bypassed : {accessingUserId} {currentContext.PageName} " +
                    $"{currentContext.UrlName} {currentContext.ApplicationTypeId}");
                return;
            }

            //user is not allowed to view the content
            //tagging is enabled and the content is tagged with the tag name

            if (TruncateLength > 0)
            {
                Log($"Paywall truncating : {currentContext.PageName} {currentContext.UrlName} " +
                    $"{currentContext.ApplicationTypeId}");
                e.RenderedHtml = "<div class=\"paywall-restricted\">" +
                                 Apis.Get<ILanguage>().Truncate(e.RenderedHtml, TruncateLength,
                                     "",
                                     true) +
                                 "</div>";

                //render a small amount of javascript to post a message to notify subscribers that the content is restricted
                e.RenderedHtml +=
                    @"<script type=""text/javascript""> 
                    jQuery(function(){          
                            jQuery.telligent.evolution.messaging.subscribe('paywall.ready', function (data) {
                                   jQuery.telligent.evolution.messaging.publish('paywall.restricted', {
                                        contentId: '" + contextItem.ContentId + @"'     
                                   });  
                            }); 
                    });
                    </script>";
            }

            //optionally also display paywall message
            if (ShowPopup)
            {
                Log($"Paywall trigger popup : {accessingUserId} {currentContext.PageName} " +
                    $"{currentContext.UrlName} {currentContext.ApplicationTypeId}");
                //render a small amount of javascript to post a message to make the paywall widget display
                e.RenderedHtml +=
                    @"<script type=""text/javascript""> 
                    jQuery(function(){          
                            jQuery.telligent.evolution.messaging.subscribe('paywall.ready', function (data) {

                                   jQuery.telligent.evolution.messaging.publish('paywall.displayPopup', {  });  
                            }); 
                    });
                    </script>";
            }
        }

        /// <summary>
        /// If tah name is set then only content that is tagged with the tag name will be blocked
        /// </summary>
        private bool TaggingEnabled => TagNames.Count > 0;

        private bool ContentHasTag(Guid? contentId, Guid? contentTypeid)
        {
            Debug.Assert(contentId != null, nameof(contentId) + " != null");
            Debug.Assert(contentTypeid != null, nameof(contentTypeid) + " != null");
            Debug.Assert(TaggingEnabled, "TaggingEnabled");

            //get the tags for the content
            var tagsInContent = Apis.Get<ITags>().Get(contentId.Value, contentTypeid.Value, null)
                .Select(ct=>ct.TagName.ToLowerInvariant()).ToList();
            //check if the content has any of the tags in the TagNames list
            var tagInContent = tagsInContent.FirstOrDefault(tag => TagNames.Contains(tag));
            return tagInContent != null;
        }

        private bool IsUserAllowed(int userId, PageContext currentContext, IContextItem contextItem)
        {
            Debug.Assert(currentContext.ApplicationTypeId != null, "currentContext.ApplicationTypeId != null");
            return Apis.Get<IPermissions>().CheckPermission(currentContext.ApplicationTypeId.Value,
                    userId,
                    new PermissionCheckOptions
                    {
                        ApplicationTypeId = currentContext.ApplicationTypeId,
                        ApplicationId = contextItem.ApplicationId
                    })
                .IsAllowed;
        }

        public string Name => "4 Roads Paywall";
        public string Description => "This plugin adds the ability to add paywalls to any content on the site";
        public void RegisterPermissions(IPermissionRegistrarController permissionController)
        {
            var permissionConfiguration = new MembershipGroupPermissionConfiguration()
            { Administrators = true, Managers = true, Moderators = true, Members = true, Owners = true };

            //Register a application level permission for each application in the site
            foreach (var applicationType in Apis.Get<IApplicationTypes>().List())
            {
                Debug.Assert(applicationType.Id != null, "applicationType.Id != null");
                permissionController.Register(new Permission(applicationType.Id.Value, "ByPassPaywall",
                    "ByPassPaywallDescription", _translationController, applicationType.Id.Value,
                    new PermissionConfiguration()
                    {
                        Joinless = new JoinlessGroupPermissionConfiguration()
                            { Administrators = true, Owners = true, RegisteredUsers = true },
                        PrivateListed = permissionConfiguration,
                        PrivateUnlisted = permissionConfiguration,
                        PublicClosed = permissionConfiguration,
                        PublicOpen = permissionConfiguration
                    }));
            }
        }

        public void SetController(ITranslatablePluginController controller)
        {
            _translationController = controller;
        }

        public Translation[] DefaultTranslations
        {
            get
            {
                var translation = new Translation("en-us");

                translation.Set("Options", "Options");
                translation.Set("ByPassPaywall", "By Pass Paywall");
                translation.Set("ByPassPaywallDescription", "Set this to true to enable users to " +
                                                            "bypass seeing the paywall");
                translation.Set("TruncateLength", "Truncate Text Length");
                translation.Set("ShowPopup", "Show Paywall Popup");
                translation.Set("EnableDebugging", "Enable Debugging (see event log)");
                translation.Set("TagNames", "Tag Names");
                translation.Set("TagNames_Description", "Only block content tagged with any of the provided tag " +
                                                        "names, leave empty to block all content");

                return new[]
                {
                    translation
                };
            }
        }

        private int TruncateLength { get; set; }
        private bool ShowPopup { get; set; }
        private bool EnableDebugging { get; set; }
        private List<string> TagNames { get; set; } = new List<string>();

        public void Update(IPluginConfiguration configuration)
        {
            TruncateLength = configuration.GetInt("truncatelength").GetValueOrDefault(0);
            ShowPopup = configuration.GetBool("showpopup").GetValueOrDefault(true);
            EnableDebugging = configuration.GetBool("enableDebugging").GetValueOrDefault(false);
            TagNames = GetTagNames(configuration.GetString("tagNames"));
        }

        private List<string> GetTagNames(string tagNamesConfig)
        {
            if (string.IsNullOrWhiteSpace(tagNamesConfig))
            {
                return new List<string>();
            }

            return tagNamesConfig.Split(new[] { '&' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(t => t.Trim().Replace("Tag=", string.Empty).ToLowerInvariant())
                .ToList();
        }

        public PropertyGroup[] ConfigurationOptions => new[]
            {
                new PropertyGroup()
                {
                    LabelResourceName = "Options",
                    Properties =
                    {
                        new Property
                        {
                            LabelResourceName = "TruncateLength",
                            DataType = "Int",
                            Id = "truncatelength",
                            DefaultValue = "500"
                        },
                        new Property
                        {
                            LabelResourceName = "ShowPopup",
                            DataType = "Bool",
                            Id = "showpopup",
                            DefaultValue = "true"
                        },
                        new Property
                        {
                            LabelResourceName = "EnableDebugging",
                            DataType = "Bool",
                            Id = "enableDebugging",
                            DefaultValue = "false"
                        },

                        new Property
                        {
                            LabelResourceName = "TagNames",
                            DescriptionResourceName = "TagNames_Description",
                            DataType = "Custom",
                            Template = "core_v2_tagLookup",
                            Id = "tagNames",
                            DefaultValue = string.Empty
                        }
                    }
                }
            };

        public IEnumerable<Type> Plugins => new[] { typeof(DefaultWidgetInstaller) };
    }
}
