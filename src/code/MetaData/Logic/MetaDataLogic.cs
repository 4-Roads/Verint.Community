﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;
using System.Xml.Serialization;
using FourRoads.Common;
using FourRoads.VerintCommunity.MetaData.Interfaces;
using FourRoads.VerintCommunity.MetaData.Security;
using Telligent.DynamicConfiguration.Components;
using Telligent.Evolution.Extensibility.Api.Entities.Version1;
using Telligent.Evolution.Extensibility.Api.Version1;
using Telligent.Evolution.Extensibility;
using Telligent.Evolution.Extensibility.Caching.Version1;
using Telligent.Evolution.Extensibility.Content.Version1;
using Telligent.Evolution.Extensibility.Storage.Version1;
using Telligent.Evolution.Extensibility.Version1;

namespace FourRoads.VerintCommunity.MetaData.Logic
{
    public class MetaDataLogic : IMetaDataLogic
    {
        private static string _imageRegEx = @"<img[^>]*src=(?:(""|')(?<url>[^\1]*?)\1|(?<url>[^\s|""|'|>]+))";
        private static Regex _regex = new Regex(_imageRegEx, RegexOptions.IgnoreCase | RegexOptions.Compiled);
        public const string FILESTORE_KEY = "fourroads.metadata";
        private ICentralizedFileStorageProvider _metaDataStore = null;
        private readonly XmlSerializer _metaDataSerializer = new XmlSerializer(typeof(MetaData));

        private static readonly Regex MakeSafeFileNameRegEx =
            new Regex(CentralizedFileStorage.ValidFileNameRegexPattern, RegexOptions.Compiled);

        private MetaDataConfiguration _metaConfig;

        public bool CanEdit
        {
            get
            {
                if (Apis.Get<IUrl>().CurrentContext != null && Apis.Get<IUrl>().CurrentContext.ContextItems != null &&
                    Apis.Get<IUsers>().AccessingUser != null)
                {
                    if (Apis.Get<IPermissions>().Get(PermissionRegistrar.SiteEditMetaDataPermission,
                            Apis.Get<IUsers>().AccessingUser.Id.GetValueOrDefault(0)).IsAllowed)
                    {
                        return true;
                    }

                    var items = Apis.Get<IUrl>().CurrentContext.ContextItems.GetAllContextItems();

                    if (items.Any())
                    {
                        foreach (var context in items)
                        {
                            if (context.ContentId.HasValue && context.ContainerTypeId.HasValue &&
                                Apis.Get<IUsers>().AccessingUser.Id.HasValue)
                            {
                                if (Apis.Get<IPermissions>().Get(PermissionRegistrar.EditMetaDataPermission,
                                        Apis.Get<IUsers>().AccessingUser.Id.Value, context.ContentId.Value,
                                        context.ContainerTypeId.Value).IsAllowed)
                                {
                                    return true;
                                }
                            }
                        }
                    }
                }

                return false;
            }
        }

        private static Regex matchFields = new Regex(@"({(?!{)\w+}(?!}))", RegexOptions.Compiled);

        public string FormatMetaString(string rawFieldValue, string seperator, IDictionary namedParameters)
        {
            return matchFields.Replace(rawFieldValue, match =>
            {
                string trimmend = match.Value.Trim(new char[] { ' ', '}', '{' });

                if (namedParameters.Contains(trimmend))
                {
                    string repsonse = string.Empty;

                    if (match.Index > 0 && string.IsNullOrEmpty((string)namedParameters[trimmend]))
                        repsonse += seperator;

                    return repsonse + namedParameters[trimmend];
                }

                return match.Value;
            });
        }

        public string GetBestImageUrlForContent(Guid contentId, Guid contentTypeId)
        {
            ContentDetails details = GetContentDetails(contentId, contentTypeId);

            return GetBestImageUrlForContentDetails(details);
        }

        public string GetBestImageUrlForCurrent()
        {
            ContentDetails details = GetCurrentContentDetails();

            return GetBestImageUrlForContentDetails(details);
        }

        private string GetBestImageUrlForContentDetails(ContentDetails details)
        {
            string imageUrl = string.Empty;

            if (details.ContentId.HasValue && details.ContentTypeId.HasValue)
            {
                //Look for first image in content
                Content content = Apis.Get<IContents>().Get(details.ContentId.Value, details.ContentTypeId.Value);

                if (!content.HasErrors())
                {
                    imageUrl = ExtractImage(content.HtmlDescription(""));
                }
            }

            if (details.ApplicationId.HasValue && string.IsNullOrWhiteSpace(imageUrl))
            {
                //Look for first image in application description
                var app = Apis.Get<IApplications>().Get(details.ApplicationId.Value, details.ApplicationTypeId.Value);

                if (!app.HasErrors())
                {
                    imageUrl = ExtractImage(app.HtmlDescription(""));
                }
            }

            if (details.ContainerId.HasValue && details.ContainerTypeId.HasValue && string.IsNullOrWhiteSpace(imageUrl))
            {
                //Get image from group avatar
                //Look for first image in application description
                var container = Apis.Get<IContainers>().Get(details.ContainerId.Value, details.ContainerTypeId.Value);

                if (!container.HasErrors())
                {
                    imageUrl = ExtractImage(container.AvatarUrl);
                }
            }

            return imageUrl;
        }

        private string ExtractImage(string content)
        {
            List<string> results = new List<string>();
            if (content != null)
            {
                Regex regex = _regex;

                MatchCollection matches = regex.Matches(content);

                foreach (Match match in matches)
                {
                    Uri result;
                    if (Uri.TryCreate(Apis.Get<IUrl>().Absolute(match.Groups["url"].Value), UriKind.Absolute,
                            out result))
                    {
                        if (_metaConfig.EmbeddedImageExclusions.Any(s => result.AbsoluteUri.IndexOf(s, StringComparison.InvariantCultureIgnoreCase) != -1))
                        {
                            continue;
                        }

                        results.Add(result.AbsoluteUri);
                    }
                }
            }

            return results.FirstOrDefault();
        }

        public ICentralizedFileStorageProvider MetaDataStore
        {
            get
            {
                if (_metaDataStore == null)
                {
                    _metaDataStore = CentralizedFileStorage.GetFileStore(FILESTORE_KEY);
                }

                return _metaDataStore;
            }
        }

        private class ContentDetails
        {
            public Guid? ContainerId;
            public Guid? ApplicationId;

            public string FileName => MakeSafeFileName(
                PageName +
                (ContainerId.GetValueOrDefault(Guid.Empty) != Guid.Empty ? "_" + ContainerId : string.Empty) +
                (ApplicationId.GetValueOrDefault(Guid.Empty) != Guid.Empty ? "_" + ApplicationId : string.Empty) +
                (ContentId.GetValueOrDefault(Guid.Empty) != Guid.Empty ? "_" + ContentId : string.Empty));

            public string PageName;
            public Guid? ContainerTypeId { get; set; }
            public Guid? ContentId { get; set; }
            public Guid? ContentTypeId { get; set; }
            public Guid? ApplicationTypeId { get; set; }
        }

        private ContentDetails GetCurrentContentDetails()
        {
            CacheService.TryGet("ContentDetails", CacheScope.All, out ContentDetails details);

            if (details == null)
                details = new ContentDetails() { PageName = "default" };

            if (Apis.Get<IUrl>().CurrentContext != null && details.PageName == "default")
            {
                details.PageName = Apis.Get<IUrl>().CurrentContext.PageName;

                ContextualItem(coa =>
                {
                    details.ContentId = coa.ContentId;
                    details.ContentTypeId = coa.ContentTypeId;
                }, a =>
                {
                    details.ApplicationId = a.ApplicationId;
                    details.ApplicationTypeId = a.ApplicationTypeId;
                }, c =>
                {
                    details.ContainerId = c.ContainerId;
                    details.ContainerTypeId = c.ContainerTypeId;
                });
            }

            CacheService.Put("ContentDetails", details, CacheScope.Context);

            return details;
        }

        private ContentDetails GetContentDetails(Guid contentId, Guid contentTypeId)
        {
            string cacheKey = string.Format("ContentDetails::{0}::{1}", contentId, contentTypeId);
            ContentDetails details;
            
            CacheService.TryGet(cacheKey, CacheScope.Distributed , out details);

            if (details == null)
            {
                details = new ContentDetails() { PageName = "default" };

                var content = Apis.Get<IContents>().Get(contentId, contentTypeId);

                if (content != null)
                {
                    details.ContentId = content.ContentId;
                    details.ContentTypeId = content.ContentTypeId;
                    details.ApplicationId = content.Application.ApplicationId;
                    details.ApplicationTypeId = content.Application.ApplicationTypeId;
                    details.ContainerId = content.Application.Container.ContainerId;
                    details.ContainerTypeId = content.Application.Container.ContainerTypeId;
                }
            }
            CacheService.Put(cacheKey, CacheScope.All, details, new PutOptions() { ExpiresAfter = TimeSpan.FromMinutes(15) });


            return details;
        }

        public static byte[] GetHash(string inputString)
        {
            HashAlgorithm algorithm = MD5.Create(); //or use SHA1.Create();
            return algorithm.ComputeHash(Encoding.UTF8.GetBytes(inputString));
        }

        public static string GetHashString(string inputString)
        {
            StringBuilder sb = new StringBuilder();

            foreach (byte b in GetHash(inputString))
                sb.Append(b.ToString("X2"));

            return sb.ToString();
        }

        protected void ContextualItem(Action<IContent> contentUse, Action<IApplication> applicationUse,
            Action<IContainer> containerUse)
        {
            IApplication currentApplication = null;
            IContainer currentContainer = null;
            IContent currentContent = null;

            foreach (var contextItem in Apis.Get<IUrl>().CurrentContext.ContextItems.GetAllContextItems())
            {
                var container = PluginManager.Get<IWebContextualContainerType>()
                    .FirstOrDefault(a => a.ContainerTypeId == contextItem.ContainerTypeId);

                if (container != null && contextItem.ContainerId.HasValue &&
                    contextItem.ContainerTypeId == Apis.Get<IGroups>().ContainerTypeId)
                {
                    currentContainer = container.Get(contextItem.ContainerId.Value);
                }
                else
                {
                    //Only interested in context in groups
                    break;
                }

                var app = PluginManager.Get<IWebContextualApplicationType>().FirstOrDefault(a =>
                    a.ApplicationTypeId == contextItem.ApplicationTypeId &&
                    a.ContainerTypes.Any(ct => ct == contextItem.ContainerTypeId));

                if (app != null && contextItem.ApplicationId.HasValue)
                {
                    IApplication application = app.Get(contextItem.ApplicationId.Value);

                    if (application != null)
                    {
                        if (application.Container.ContainerId != application.ApplicationId)
                            currentApplication = application;
                    }
                }

                var content = PluginManager.Get<IContentType>().FirstOrDefault(a =>
                    a.ContentTypeId == contextItem.ContentTypeId &&
                    a.ApplicationTypes.Any(at => at == contextItem.ApplicationTypeId));

                if (content != null && contextItem.ContentId.HasValue && contextItem.ContentTypeId.HasValue)
                {
                    currentContent = content.Get(contextItem.ContentId.Value);
                }
            }

            if (currentApplication != null)
                applicationUse(currentApplication);

            if (currentContent != null)
                contentUse(currentContent);

            if (currentContainer != null)
                containerUse(currentContainer);
        }

        private MetaData GetCurrentMetaData(ContentDetails details)
        {
            var cacheKey = GetCacheKey(details.FileName);

            var metaData = CacheService.Get(cacheKey, () =>
            {
                MetaData data = null;
                var file = MetaDataStore?.GetFile("", details.FileName + ".xml");

                if (file != null)
                {
                    using (var stream = file.OpenReadStream())
                    {
                        data = (MetaData)_metaDataSerializer.Deserialize(stream);

                        //Filter out any tags that have previously been configured but then removed
                        var configured = _metaConfig.ExtendedEntries.ToLookup(f => f);
                        //create a copy, so we can iterate collection and mutate the original
                        var actual = new SerializableDictionary<string, string>(data.ExtendedMetaTags);

                        foreach (var tag in actual.Keys.Where(tag => !configured.Contains(tag)))
                        {
                            data.ExtendedMetaTags.Remove(tag);
                        }
                    }
                }

                return data ?? new MetaData
                {
                    InheritData = true,
                    ApplicationId = details.ApplicationId.GetValueOrDefault(Guid.Empty),
                    ApplicationTypeId = details.ApplicationTypeId.GetValueOrDefault(Guid.Empty),
                    ContainerId = details.ContainerId.GetValueOrDefault(Guid.Empty),
                    ContainerTypeId = details.ContainerTypeId.GetValueOrDefault(Guid.Empty)
                };
            }, CacheScope.All);

            return metaData;
        }


        public MetaData GetCurrentMetaData()
        {
            ContentDetails details = GetCurrentContentDetails();

            MetaData data = GetCurrentMetaData(details);
            Guid containerId = data.ContainerId;
            Guid containerTypeId = data.ContainerTypeId;

            // are we starting with a piece of 'content', rather than application or container 
            var isContent = details.ContentId.HasValue && details.ContentId != details.ApplicationId && details.ContentId != details.ContainerId;

            var inheritData = data.InheritData;

            if (inheritData)
            {
                if (data.ApplicationId != Guid.Empty)
                {
                    // if the save point is at application level the content id is the application id
                    details.ContentId = data.ApplicationId;
                    details.ContentTypeId = data.ApplicationTypeId;

                    var application = Apis.Get<IApplications>().Get(data.ApplicationId, data.ApplicationTypeId);

                    if (!application.HasErrors())
                    {
                        var context = Apis.Get<IUrl>().ParsePageContext(application.Url);
                        if (context != null)
                        {
                            details.PageName = context.PageName;

                            inheritData = MergeMetaData(isContent, details, data);
                        }
                    }
                }

                details.ApplicationId = Guid.Empty;
                details.ApplicationTypeId = Guid.Empty;

                while (inheritData && containerId != Guid.Empty && containerId != Apis.Get<IGroups>().Root.ContainerId)
                {
                    var container = Apis.Get<IContainers>().Get(containerId, containerTypeId);

                    //Once we start inheriting we go to the group home page (dont inherit metadata from site root)
                    if (!container.HasErrors())
                    {
                        var context = Apis.Get<IUrl>().ParsePageContext(container.Url);

                        if (context != null && container.ParentContainer != null)
                        {
                            // if the save point is at container level the content id is the container id
                            details.ContentId = container.ContainerId;
                            details.ContentTypeId = container.ContainerTypeId;

                            details.ContainerId = container.ContainerId;
                            details.ContainerTypeId = container.ContainerTypeId;

                            details.PageName = context.PageName;

                            inheritData = MergeMetaData(isContent, details, data);

                            containerId = container.ParentContainer.ContainerId;
                            containerTypeId = container.ParentContainer.ContainerTypeId;
                        }
                        else
                        {
                            break;
                        }
                    }
                    else
                    {
                        break;
                    }
                }
            }

            return data;
        }

        private bool MergeMetaData(bool isContent, ContentDetails details, MetaData data)
        {
            var mergeData = GetCurrentMetaData(details);

            if ((!isContent || _metaConfig.CanInheritTitle) && string.IsNullOrWhiteSpace(data.Title))
            {
                data.Title = mergeData.Title;
            }

            if ((!isContent || _metaConfig.CanInheritDesc) && string.IsNullOrWhiteSpace(data.Description))
            {
                data.Description = mergeData.Description;
            }

            if ((!isContent || _metaConfig.CanInheritKeywords) && string.IsNullOrWhiteSpace(data.Keywords))
            {
                data.Keywords = mergeData.Keywords;
            }

            if (!isContent || _metaConfig.CanInheritTags)
            {
                foreach (var key in mergeData.ExtendedMetaTags.Keys)
                {
                    if (!string.IsNullOrWhiteSpace(mergeData.ExtendedMetaTags[key]))
                    {
                        if (!data.ExtendedMetaTags.ContainsKey(key) || string.IsNullOrWhiteSpace(data.ExtendedMetaTags[key]))
                        {
                            if (data.ExtendedMetaTags.ContainsKey(key))
                            {
                                data.ExtendedMetaTags[key] = mergeData.ExtendedMetaTags[key];
                            }
                            else
                            {
                                data.ExtendedMetaTags.Add(key, mergeData.ExtendedMetaTags[key]);
                            }
                        }
                    }
                }
            }

            return mergeData.InheritData;
        }

        private static string GetCacheKey(string contentName)
        {
            return "4-roads-metadata:" + contentName;
        }

        private static string MakeSafeFileName(string name)
        {
            string result = string.Empty;

            foreach (Match match in MakeSafeFileNameRegEx.Matches(name))
            {
                result += match.Value;
            }

            return result;
        }

        public void UpdateConfiguration(MetaDataConfiguration metaConfig)
        {
            _metaConfig = metaConfig;
        }

        public string[] GetAvailableExtendedMetaTags()
        {
            return _metaConfig.ExtendedEntries.ToArray();
        }

        public MetaDataConfiguration GetConfig()
        {
            return _metaConfig;
        }

        public void SaveMetaDataConfiguration(string title, string description, string keywords, bool inherit,
            IDictionary extendedTags)
        {
            if (CanEdit)
            {
                ContentDetails details = GetCurrentContentDetails();

                string cacheKey = GetCacheKey(details.FileName);

                using (MemoryStream buffer = new MemoryStream(10000))
                {
                    var data = new MetaData()
                    {
                        InheritData = inherit,
                        ApplicationId = details.ApplicationId.GetValueOrDefault(Guid.Empty),
                        ApplicationTypeId = details.ApplicationTypeId.GetValueOrDefault(Guid.Empty),
                        ContainerId = details.ContainerId.GetValueOrDefault(Guid.Empty),
                        ContainerTypeId = details.ContainerTypeId.GetValueOrDefault(Guid.Empty),
                        Title = title,
                        Description = description,
                        Keywords = keywords,
                        ExtendedMetaTags = new SerializableDictionary<string, string>(extendedTags.Keys.Cast<string>()
                            .ToDictionary(name => name, name => extendedTags[name] as string))
                    };

                    //Translate the URL's if any have been uploaded
                    _metaDataSerializer.Serialize(buffer, data);

                    buffer.Seek(0, SeekOrigin.Begin);

                    MetaDataStore.AddFile("", details.FileName + ".xml", buffer, false);
                }

                CacheService.Remove(cacheKey, CacheScope.All);
            }
        }

        public string GetDynamicFormXml()
        {
            ContentDetails details = GetCurrentContentDetails();

            MetaData metaData = GetCurrentMetaData(details);

            PropertyGroup group = new PropertyGroup("Meta", "Meta Configuration", 0);

            PropertySubGroup subGroup = new PropertySubGroup("Options", "Options", 0)
            {
            };

            group.PropertySubGroups.Add(subGroup);

            int order = 0;

            subGroup.Properties.Add(new Property("Inherit", "Inherit from parent application/groups", PropertyType.Bool, order++,
                metaData.InheritData.ToString()));

            subGroup.Properties.Add(new Property("Title", "Title", PropertyType.String, order++, metaData.Title));
            subGroup.Properties.Add(new Property("Description", "Description", PropertyType.String, order++,
                metaData.Description));
            subGroup.Properties.Add(new Property("Keywords", "Keywords", PropertyType.String, order++,
                metaData.Keywords));

            PropertySubGroup extendedGroup = new PropertySubGroup("Options", "Extended Tags", 1);

            group.PropertySubGroups.Add(extendedGroup);

            foreach (string extendedEntry in _metaConfig.ExtendedEntries)
            {
                extendedGroup.Properties.Add(new Property(extendedEntry, extendedEntry, PropertyType.String, order++,
                    metaData.ExtendedMetaTags.ContainsKey(extendedEntry)
                        ? metaData.ExtendedMetaTags[extendedEntry]
                        : string.Empty));
            }

            StringBuilder sb = new StringBuilder();

            using (StringWriter sw = new StringWriter(sb))
            using (XmlTextWriter tw = new XmlTextWriter(sw))
                group.Serialize(tw);

            //Hack to make it render slightly nicer
            return sb.ToString().Replace("legend>", "h2>");
        }
    }
}