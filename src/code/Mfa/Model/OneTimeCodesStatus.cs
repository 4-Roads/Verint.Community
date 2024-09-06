using System;

namespace FourRoads.VerintCommunity.Mfa.Model
{
    public class OneTimeCodesStatus
    {
        public DateTime CodesGeneratedOn { get; set; }
        public int CodesLeft { get; set; }

        public int Version { get; set; }
    }
}
