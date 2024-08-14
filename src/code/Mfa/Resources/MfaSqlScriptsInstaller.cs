using FourRoads.VerintCommunity.Installer.Components.Utility;

namespace FourRoads.VerintCommunity.Mfa.Resources
{
    public class MfaSqlScriptsInstaller : Installer.SqlScriptsInstaller
    {
        protected override string ProjectName => "MFA SQL Installer";

        protected override string BaseResourcePath => "FourRoads.VerintCommunity.Mfa.Resources.";

        protected override EmbeddedResourcesBase EmbeddedResources => new EmbeddedResources();
    }
}
