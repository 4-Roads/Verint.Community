﻿using System;
using FourRoads.VerintCommunity.Mfa.Model;

namespace FourRoads.VerintCommunity.Mfa.Interfaces
{
    public interface IMfaDataProvider
    {
        /// <summary>
        /// Returns true if code was valid. Marks the code as used to prevent reuse.
        /// </summary>
        /// <param name="userId">user Id</param>
        /// <param name="encryptedCode">One tim code hash value</param>
        /// <returns></returns>
        bool RedeemCode(int userId, string encryptedCode);

        void ClearCodes(int userId);

        OneTimeCode CreateCode(int userId, string encryptedCode);
        int CountCodesLeft(int userId);

        void SetUserKey(int userId, Guid key);
        Guid GetUserKey(int userId);
        void ClearUserKey(int value);
    }
}
