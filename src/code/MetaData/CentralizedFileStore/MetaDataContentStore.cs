using FourRoads.VerintCommunity.MetaData.Interfaces;
using FourRoads.VerintCommunity.MetaData.Logic;
using Telligent.Evolution.Extensibility.Storage.Version1;

namespace FourRoads.VerintCommunity.MetaData.CentralizedFileStore
{
    public class MetaDataContentStore : ICentralizedFileStore, IApplicationPlugin
    {
        public void Initialize()
        {
        }

        public string Name
        {
            get { return "Filestore"; }
        }

        public string Description
        {
            get { return "Handles the filestorage for inline content"; }
        }

        public string FileStoreKey
        {
            get { return MetaDataLogic.FILESTORE_KEY; }
        }
    }

}