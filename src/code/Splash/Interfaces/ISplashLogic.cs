using System.Collections;
using FourRoads.VerintCommunity.RenderingHelper;
using FourRoads.VerintCommunity.Splash.Logic;
using Telligent.Evolution.Extensibility.Urls.Version1;

namespace FourRoads.VerintCommunity.Splash.Interfaces
{
    public interface ISplashLogic : ICQProcessor
    {
        void UpdateConfiguration(SplashConfigurationDetails configuration);
        void RegisterUrls(IUrlController controller);
        string ValidateAndHashAccessCode(string password);
        bool SaveDetails(string email, IDictionary additionalFields);
        string GetUserListDownloadUrl();
    }
}
