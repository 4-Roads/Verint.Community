using FourRoads.Common.VerintCommunity.Components;
using FourRoads.Common.VerintCommunity.Plugins.Base;
using FourRoads.VerintCommunity.Installer;
using FourRoads.VerintCommunity.Installer.Components.Utility;
using Telligent.Evolution.Extensibility.Storage.Version1;


namespace FourRoads.VerintCommunity.Nexus2
{
    public class FileInstaller : CfsFilestoreInstaller , ICentralizedFileStore
    {
        public const string FILESTOREKEY = "customoauthimages";

        private EmbeddedResources _resources = new EmbeddedResources();

        protected override string ProjectName
        {
            get { return "Nexus2"; }
        }

        protected override string BaseResourcePath
        {
            get { return "FourRoads.VerintCommunity.Nexus2.Resources"; }
        }

        protected override EmbeddedResourcesBase EmbeddedResources
        {
            get { return _resources; }
        }

        public string FileStoreKey {
            get { return FILESTOREKEY; }
        }
    }
}
