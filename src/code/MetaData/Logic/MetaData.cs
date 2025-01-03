using System;
using FourRoads.Common;

namespace FourRoads.VerintCommunity.MetaData.Logic
{
    [Serializable]
    public class MetaData
    {
        public MetaData()
        {
            ExtendedMetaTags = new SerializableDictionary<string, string>();
        }

        public string Title { get; set; }
        public string Description { get; set; }
        public string Keywords { get; set; }
        public SerializableDictionary<string,string> ExtendedMetaTags { get; set; }
        public Guid ApplicationId { get; set; }
        public Guid ApplicationTypeId { get; set; }
        public Guid ContainerId { get; set; }
        public bool InheritData { get; set; }
        public Guid ContainerTypeId { get; set; }
    }
}