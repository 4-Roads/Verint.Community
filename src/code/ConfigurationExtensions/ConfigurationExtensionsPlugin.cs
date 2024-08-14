using System;
using System.Collections.Generic;
using DryIoc;
using Telligent.Evolution.Extensibility.Version1;
using FourRoads.Common.VerintCommunity.Plugins.Base;
using FourRoads.VerintCommunity.ConfigurationExtensions.Interfaces;

namespace FourRoads.VerintCommunity.ConfigurationExtensions
{
    public class ConfigurationExtensionsPlugin : IConfigurationExtensionsPlugin, ICategorizedPlugin
    {
        private PluginGroupLoader _pluginGroupLoader;

        public void Initialize()
        {
  
        }

        public string Name
        {
            get { return "4 Roads - Configuration Extensions"; }
        }

        public string Description
        {
            get { return "This plugin provides configuration extensions so a user is able to specify advanced default options for individual areas of the site"; }
        }

        public void LoadBindings(IContainer module)
        {
            
        }

        public int LoadOrder {
            get { return 0; }
        }


        private class PluginGroupLoaderTypeVisitor : FourRoads.Common.VerintCommunity.Plugins.Base.PluginGroupLoaderTypeVisitor
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

                _pluginGroupLoader.Initialize(new PluginGroupLoaderTypeVisitor());

                return _pluginGroupLoader.GetPlugins();
            }
        }


        public string[] Categories
        {
            get
            {
                return new[]
                {
                    "Notifications"
                };
            }
        }
    }
}
