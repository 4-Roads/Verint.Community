﻿using FourRoads.Common.VerintCommunity.Components.Logic;
using Telligent.Evolution.Extensibility.Storage.Version1;

namespace FourRoads.VerintCommunity.InlineContent.CentralizedFileStore
{
    public class InlineContentStore : ICentralizedFileStore
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
            get { return InlineContentLogic.FILESTORE_KEY; }
        }
    }
}