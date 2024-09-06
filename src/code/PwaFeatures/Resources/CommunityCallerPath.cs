using FourRoads.VerintCommunity.Installer.Components.Interfaces;
using System.Runtime.CompilerServices;

namespace FourRoads.VerintCommunity.PwaFeatures.Resources
{
    public class CommunityCallerPath : ICallerPathVistor
    {
        public string GetPath() => InternalGetPath();

        protected string InternalGetPath([CallerFilePath] string path = null) => path;
    }
}