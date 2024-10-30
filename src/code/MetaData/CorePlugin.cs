using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using DryIoc;
using FourRoads.Common.VerintCommunity.Plugins.Base;
using FourRoads.Common.VerintCommunity.Plugins.Interfaces;
using FourRoads.VerintCommunity.Installer.Plugins;
using FourRoads.VerintCommunity.MetaData.Interfaces;
using FourRoads.VerintCommunity.MetaData.Logic;
using FourRoads.VerintCommunity.MetaData.ScriptedFragmentss;
using Telligent.Evolution.Extensibility.Configuration.Version1;
using Telligent.Evolution.Extensibility.Version1;
using IConfigurablePlugin = Telligent.Evolution.Extensibility.Version2.IConfigurablePlugin;

namespace FourRoads.VerintCommunity.MetaData
{
    public class CorePlugin : IBindingsLoader, IPluginGroup, IConfigurablePlugin
    {
        private IMetaDataLogic _metaDataLogic;
        private PluginGroupLoader _pluginGroupLoader;
        private MetaDataConfiguration _metaConfig = null;

        public void Initialize()
        {
            if (_metaConfig != null)
            {
                MetaDataLogic.UpdateConfiguration(_metaConfig);
            }
        }

        protected internal IMetaDataLogic MetaDataLogic
        {
            get
            {
                if (_metaDataLogic == null)
                {
                    _metaDataLogic = Injector.Get<IMetaDataLogic>();
                }
                return _metaDataLogic;
            }
        }

        public string Name => "4 Roads - MetaData Plugin";

        public string Description => "This plugin allows a user to specify metadata overrides for any specific page in the site";

        public int LoadOrder => 0;

        public void LoadBindings(IContainer module)
        {
            module.Register<IMetaDataLogic, MetaDataLogic>(Reuse.Singleton);
            module.Register<IMetaDataScriptedFragment, MetaDataScriptedFragment>(Reuse.Singleton);
        }

        private class PluginGroupLoaderTypeVisitor : Common.VerintCommunity.Plugins.Base.PluginGroupLoaderTypeVisitor
        {
            public override Type GetPluginType()
            {
                return typeof(IApplicationPlugin);
            }
        }

        public IEnumerable<Type> Plugins
        {
            get
            {
                if (_pluginGroupLoader == null)
                {
                    _pluginGroupLoader = new PluginGroupLoader();
                }

                Type[] priorityPlugins =
                {
                    typeof (DependencyInjectionPlugin),
                    typeof(InstallerCore),
                    typeof (DefaultWidgetInstaller)
                };

                _pluginGroupLoader.Initialize(new PluginGroupLoaderTypeVisitor(), priorityPlugins);

                return _pluginGroupLoader.GetPlugins();
            }
        }

        public void Update(Telligent.Evolution.Extensibility.Version2.IPluginConfiguration configuration)
        {
            if (_metaConfig == null)
            {
                _metaConfig = new MetaDataConfiguration();
            }

            _metaConfig.ExtendedEntries = configuration.GetString("extendedtags").Split(new[] { ",", Environment.NewLine, "\n" }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Trim()).ToList();

            _metaConfig.EmbeddedImageExclusions = configuration.GetString("imageExclusions").Split(new[] { ",", Environment.NewLine, "\n" }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Trim()).ToList();

            _metaConfig.CanInheritTitle = configuration.GetBool("canInheritTitle").HasValue
                   ? configuration.GetBool("canInheritTitle").Value
                   : false;

            _metaConfig.CanInheritDesc = configuration.GetBool("canInheritDesc").HasValue
                ? configuration.GetBool("canInheritDesc").Value
                : false;

            _metaConfig.CanInheritKeywords = configuration.GetBool("canInheritKeywords").HasValue
                ? configuration.GetBool("canInheritKeywords").Value
                : false;

            _metaConfig.CanInheritTags = configuration.GetBool("canInheritTags").HasValue
                ? configuration.GetBool("canInheritTags").Value
                : true;
        }

        public Telligent.Evolution.Extensibility.Configuration.Version1.PropertyGroup[] ConfigurationOptions
        {
            get
            {
                var propertyGroupArray = new PropertyGroup[]
                {
                    new PropertyGroup(){Id= "options",LabelText = "Options"}
                };

                propertyGroupArray[0].Properties.Add(new Property
                {
                    Id = "extendedtags",
                    LabelText = "Additional Tags",
                    DataType = "string",
                    DefaultValue = "og:title,og:type,og:image,og:url,og:description,fb:admins,twitter:card,twitter:url,twitter:title,twitter:description,twitter:image",
                    DescriptionText = "Provide a list of comma separated meta tags that will be available to the end user to configure",
                    Options = new NameValueCollection
                    {
                        { "rows", "10" },
                        { "columns", "80" }
                    }
                });

                propertyGroupArray[0].Properties.Add(new Property
                {
                    Id = "imageExclusions",
                    LabelText = "Embedded Image Exclusions",
                    DataType = "string",
                    DefaultValue = "communityserver-components-imagefileviewer/filetypeimages",
                    DescriptionText = "Provide a list of partial urls to exclude embedded images such as filetype icons",
                    Options = new NameValueCollection
                    {
                        { "rows", "10" },
                        { "columns", "80" }
                    }
                });

                propertyGroupArray[0].Properties.Add(new Property
                {
                    Id = "canInheritTitle",
                    LabelText = "Can Inherit Title",
                    DescriptionText = "Allow the title to be inherited for content items (warning this could override the page title with that from a parent group/application)",
                    DataType = "bool",
                    Template = "bool",
                    OrderNumber = 0,
                    DefaultValue = "false"
                });

                propertyGroupArray[0].Properties.Add(new Property
                {
                    Id = "canInheritDesc",
                    LabelText = "Can Inherit Description",
                    DescriptionText = "Allow the description to be inherited for content items (warning this could override the page description with that from a parent group/application)",
                    DataType = "bool",
                    Template = "bool",
                    OrderNumber = 0,
                    DefaultValue = "false"
                });

                propertyGroupArray[0].Properties.Add(new Property
                {
                    Id = "canInheritKeywords",
                    LabelText = "Can Inherit Keywords",
                    DescriptionText = "Allow the keywords to be inherited for content items",
                    DataType = "bool",
                    Template = "bool",
                    OrderNumber = 0,
                    DefaultValue = "false"
                });

                propertyGroupArray[0].Properties.Add(new Property
                {
                    Id = "canInheritTags",
                    LabelText = "Can Inherit Tags",
                    DescriptionText = "Allow the extended tags to be inherited for content items", 
                    DataType = "bool",
                    Template = "bool",
                    OrderNumber = 0,
                    DefaultValue = "true"
                });

                return propertyGroupArray;
            }
        }
    }
}
