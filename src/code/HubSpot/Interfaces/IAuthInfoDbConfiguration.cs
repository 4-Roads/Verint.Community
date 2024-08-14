using System;
using FourRoads.VerintCommunity.HubSpot.Models;

namespace FourRoads.VerintCommunity.HubSpot.Interfaces
{
    public interface IAuthInfoDbConfiguration
    {
        AuthInfo Get(string clientId);
        void Clear(string clientId);
        AuthInfo Update(string clientId, string accessToken, string refreshToken, DateTime expiryUtc);
    }
}