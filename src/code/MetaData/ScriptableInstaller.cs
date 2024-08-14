using System;
using FourRoads.VerintCommunity.Installer;
using FourRoads.VerintCommunity.Installer.Components.Interfaces;
using FourRoads.VerintCommunity.Installer.Components.Utility;
using FourRoads.VerintCommunity.MetaData.Interfaces;
using FourRoads.VerintCommunity.MetaData.ScriptedFragmentss;

namespace FourRoads.VerintCommunity.MetaData
{
    public class ScriptableInstaller : FactoryDefaultWidgetProviderInstaller<AdministrationPanel>, IApplicationPlugin
    {
        public override Guid ScriptedContentFragmentFactoryDefaultIdentifier => AdministrationPanel._scriptedFragmentGuid;
        protected override string ProjectName => "Meta Data Scripted Panel";

        protected override string BaseResourcePath { get; } = "FourRoads.VerintCommunity.MetaData.Resources.";

        protected override EmbeddedResourcesBase EmbeddedResources => new EmbeddedResources();
        protected override ICallerPathVistor CallerPath()
        {
            return new InternalCallerPath();
        }
    }
}