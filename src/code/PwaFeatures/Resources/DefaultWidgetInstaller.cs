using System;
using System.Collections.Generic;
using FourRoads.Common.VerintCommunity.Controls;
using FourRoads.VerintCommunity.Installer;
using FourRoads.VerintCommunity.Installer.Components.Interfaces;
using FourRoads.VerintCommunity.Installer.Components.Utility;
using FourRoads.VerintCommunity.PwaFeatures.Plugins;
using Telligent.Evolution.Extensibility.Version1;

namespace FourRoads.VerintCommunity.PwaFeatures.Resources
{
    public class DefaultWidgetInstaller : FactoryDefaultWidgetProviderInstaller<WidgetScriptedFragmentPlugin>, IPluginGroup
    {
        protected override ICallerPathVistor CallerPath()
        {
            return new CommunityCallerPath();
        }

        public override Guid ScriptedContentFragmentFactoryDefaultIdentifier => WidgetScriptedFragmentPlugin.Id;
        protected override string ProjectName => "4 Roads PWA Features";
        protected override string BaseResourcePath => "FourRoads.VerintCommunity.PwaFeatures.Resources.";
        protected override EmbeddedResourcesBase EmbeddedResources => new EmbeddedResources();
        IEnumerable<Type> IPluginGroup.Plugins =>  new[] { typeof(WidgetScriptedFragmentPlugin), typeof(TriggerActionPropertyTemplate) };
    }
}