using System.Runtime.CompilerServices;
using FourRoads.VerintCommunity.Installer.Components.Interfaces;

namespace FourRoads.VerintCommunity.Mfa.Plugins
{
    public class CommunityCallerPath : ICallerPathVistor
    {
        public string GetPath()
        {
            return InternalGetPath();
        }

        protected string InternalGetPath([CallerFilePath] string path = null)
        {
            return path;
        }
    }
}