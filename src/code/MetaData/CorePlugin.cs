﻿using System;
using System.Collections.Generic;
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

            _metaConfig.ExtendedEntries = configuration.GetString("extendedtags").Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Trim()).ToList();
        }

        public Telligent.Evolution.Extensibility.Configuration.Version1.PropertyGroup[] ConfigurationOptions
        {
            get
            {
                var propertyGroupArray = new PropertyGroup[]
                {
                    new PropertyGroup(){Id= "options",LabelText = "Options"}
                };

                var property1 = new Property(){Id= "extendedtags", LabelText = "Additional Tags", DataType = "string", DefaultValue = "og:title,og:type,og:image,og:url,og:description,fb:admins,twitter:card,twitter:url,twitter:title,twitter:description,twitter:image"};
                property1.DescriptionText = "Provide a list of comma separated meta tags that will be available to the end user to configure";
                property1.Options.Add("rows", "40");

                propertyGroupArray[0].Properties.Add(property1);

                return propertyGroupArray;


            }
        }
    }
}
