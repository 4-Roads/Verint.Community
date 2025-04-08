using System;
using System.Collections.Generic;
using FourRoads.VerintCommunity.Mfa.Model;
using Telligent.Evolution.Extensibility.Api.Entities.Version1;
using Telligent.Evolution.Extensibility.Urls.Version1;

namespace FourRoads.VerintCommunity.Mfa.Interfaces
{
    public interface IMfaLogic
    {

        void Initialize(bool enableEmailVerification, IVerifyEmailProvider emailProvider,
            ISocketMessage socketMessenger, DateTime emailValidationCutoffDate, PersitenceEnum isPersistent,
            int persistentDuration, int timeTolerance, int emailVerificationExpiry, int[] requiredRoles, string sameSiteMode, string[] whitelistPages);
      
        bool IsTwoFactorEnabled(User user);
        bool EmailValidationEnabled { get; }
        bool EmailVerificationOutOfDate(User user);
        bool MfaRequiresSetup(int userId);
        void EnableTwoFactor(User user, bool enabled);
        bool ValidateTwoFactorCode(User user, string code, bool persist);
        bool ValidateEmailCode(User user, string code);
        bool SendValidationCode(User user);
        string GetAccountSecureKey(User user);
        void FilterRequest(IHttpRequest httpRequest);
        List<OneTimeCode> GenerateCodes(User user);
        OneTimeCodesStatus GetCodesStatus(User user);
        bool UserRequiresMfa(User user);
        void ValidateEmailRequest(PageContext context, IUrlAccessController accessController);
        void ValidateNonAnonymous(PageContext context, IUrlAccessController accessController);
        bool EmailValidationRequired(User user);
        string VerifiedEmail(User user);
        bool VerifyEmail(User user);
        bool CurrentState { get;}
    }
}