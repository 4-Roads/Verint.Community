using System;

namespace FourRoads.VerintCommunity.MicroData
{
    public class MicroDataEntry
    {
        public Guid? ContentType { get; set; }
        public string Selector { get; set; }
        public string Value { get; set; }
        public MicroDataType Type { get; set; }
    }
}