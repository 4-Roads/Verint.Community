using System.Collections.Generic;

namespace FourRoads.VerintCommunity.MetaData.Logic
{
    public class MetaDataConfiguration
    {
        public MetaDataConfiguration()
        {
            //Default extended entries
            ExtendedEntries = new List<string>();
        }

        public List<string> ExtendedEntries;
    }
}