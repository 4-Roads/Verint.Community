using System.Collections;
using FourRoads.VerintCommunity.Splash.Interfaces;

namespace FourRoads.VerintCommunity.Splash.Extensions
{
    public class SplashExtension
    {
        private ISplashLogic _splashLogic;

        public SplashExtension(ISplashLogic splashLogic)
        {
            _splashLogic = splashLogic;
        }

        public string GetUserListDownloadUrl()
        {
            return _splashLogic.GetUserListDownloadUrl();
        }

        public string ValidateAndHashAccessCode(string password)
        {
            return _splashLogic.ValidateAndHashAccessCode(password);
        }

        public bool SaveDetails(string email , IDictionary additionalFields)
        {
            return _splashLogic.SaveDetails(email, additionalFields);
        }
    }
}