using System;
using FourRoads.VerintCommunity.Installer;
using FourRoads.VerintCommunity.Installer.Components.Interfaces;
using FourRoads.VerintCommunity.Installer.Components.Utility;
using FourRoads.VerintCommunity.PwaFeatures.Plugins;

namespace FourRoads.VerintCommunity.PwaFeatures.Resources
{
    public class CustomUrlsPanelInstaller : FactoryDefaultWidgetProviderInstaller<PwaFeaturesPlugin>
    {
        protected override ICallerPathVistor CallerPath()
        {
            return new CommunityCallerPath();
        }

        public override Guid ScriptedContentFragmentFactoryDefaultIdentifier => new Guid("1fe74a21eab446279f261d167bd86d0a");
        protected override string ProjectName => "4 Roads PWA SW Features";
        protected override string BaseResourcePath => "FourRoads.VerintCommunity.PwaFeatures.Resources.";
        protected override EmbeddedResourcesBase EmbeddedResources => new EmbeddedResources();
    }
}