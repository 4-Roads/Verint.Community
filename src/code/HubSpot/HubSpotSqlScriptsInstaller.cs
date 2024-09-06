using FourRoads.VerintCommunity.HubSpot.Resources;
using FourRoads.VerintCommunity.Installer.Components.Utility;

namespace FourRoads.VerintCommunity.HubSpot
{
    public class HubSpotSqlScriptsInstaller : Installer.SqlScriptsInstaller
    {
        protected override string ProjectName => "HubSpot SQL Installer";

        protected override string BaseResourcePath => "FourRoads.VerintCommunity.HubSpot.Resources.";

        protected override EmbeddedResourcesBase EmbeddedResources => new EmbeddedResources();
    }
}