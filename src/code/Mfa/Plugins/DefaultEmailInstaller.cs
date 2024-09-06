using FourRoads.VerintCommunity.Installer;
using FourRoads.VerintCommunity.Installer.Components.Interfaces;
using FourRoads.VerintCommunity.Installer.Components.Utility;
using FourRoads.VerintCommunity.Mfa.Resources;

namespace FourRoads.VerintCommunity.Mfa.Plugins
{
    public class DefaultEmailInstaller : FactoryDefaultEmailInstallerBase
    {
        protected override string ProjectName => "MFA Widget Installer";

        protected override string BaseResourcePath => "FourRoads.VerintCommunity.Mfa.Resources.";

        protected override EmbeddedResourcesBase EmbeddedResources => new EmbeddedResources();
        protected override ICallerPathVistor CallerPath()
        {
            return new CommunityCallerPath();
        }
    }
}