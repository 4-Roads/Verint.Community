using Telligent.Evolution.Extensibility.Api.Entities.Version1;
using Telligent.Evolution.Extensibility.Version1;

namespace FourRoads.Common.VerintCommunity.Plugins.Interfaces
{
    public interface ICrmPlugin : IPlugin
    {
        void SynchronizeUser(User u);
    }
}
