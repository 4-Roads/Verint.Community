using System;
using System.Runtime.CompilerServices;
using FourRoads.VerintCommunity.InlineContent.ScriptedContentFragments;
using FourRoads.VerintCommunity.Installer;
using FourRoads.VerintCommunity.Installer.Components.Interfaces;
using FourRoads.VerintCommunity.Installer.Components.Utility;

namespace FourRoads.VerintCommunity.InlineContent
{
    internal class InternalCallerPath : ICallerPathVistor
    {
        public string GetPath() => InternalGetPath();

        protected string InternalGetPath([CallerFilePath] string path = null) => path;
    }

    public class InlinePanelInstaller : FactoryDefaultWidgetProviderInstaller<InlineContentPanel>
    {
        public override Guid ScriptedContentFragmentFactoryDefaultIdentifier => InlineContentPanel._scriptedFragmentGuid;
        protected override string ProjectName => "Inline Content Panel";

        protected override string BaseResourcePath { get; } = "FourRoads.VerintCommunity.InlineContent.Resources.";

        protected override EmbeddedResourcesBase EmbeddedResources => new EmbeddedResources();
        protected override ICallerPathVistor CallerPath()
        {
            return new InternalCallerPath();
        }
    }
}