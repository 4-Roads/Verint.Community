using FourRoads.VerintCommunity.Installer;
using FourRoads.VerintCommunity.Installer.Components.Utility;

namespace FourRoads.VerintCommunity.PwaFeatures.Resources
{
    public class PwaSqlScriptsInstaller : Installer.SqlScriptsInstaller
    {
        protected override string ProjectName => "PWA";

        protected override string BaseResourcePath => "FourRoads.VerintCommunity.PwaFeatures.Resources.";

        protected override EmbeddedResourcesBase EmbeddedResources => new EmbeddedResources();
    }
}
