using Telligent.Evolution.Extensibility.Api.Entities.Version1;

namespace FourRoads.VerintCommunity.Mfa.Interfaces
{
    public interface ISocketMessage
    {
        void NotifyCodeAccepted(User user);
    }
}