﻿using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Web;
using DryIoc;
using FourRoads.Common.VerintCommunity.Plugins.Base;
using FourRoads.Common.VerintCommunity.Plugins.Interfaces;
using FourRoads.VerintCommunity.Installer.Plugins;
using FourRoads.VerintCommunity.Mfa.DataProvider;
using FourRoads.VerintCommunity.Mfa.Interfaces;
using FourRoads.VerintCommunity.Mfa.Logic;
using FourRoads.VerintCommunity.Mfa.Model;
using FourRoads.VerintCommunity.Mfa.Resources;
using Telligent.DynamicConfiguration.Components;
using Telligent.Evolution.Components;
using Telligent.Evolution.Extensibility;
using Telligent.Evolution.Extensibility.Api.Version1;
using Telligent.Evolution.Extensibility.Urls.Version1;
using Telligent.Evolution.Extensibility.Version1;
using Telligent.Evolution.Extensibility.Version2;
using IPluginConfiguration = Telligent.Evolution.Extensibility.Version2.IPluginConfiguration;
using PluginManager = Telligent.Evolution.Extensibility.Version1.PluginManager;
using Property = Telligent.Evolution.Extensibility.Configuration.Version1.Property;
using PropertyGroup = Telligent.Evolution.Extensibility.Configuration.Version1.PropertyGroup;
using PropertyValue = Telligent.Evolution.Extensibility.Configuration.Version1.PropertyValue;

namespace FourRoads.VerintCommunity.Mfa.Plugins
{
    public class MfaPluginCore : IPluginGroup, IBindingsLoader, IConfigurablePlugin, ITranslatablePlugin, IHttpRequestFilter
    {
        private IPluginConfiguration _configuration;
        private ITranslatablePluginController _translations;

        public void Initialize()
        {
            Injector.Get<IMfaLogic>().Initialize(_configuration.GetBool("emailVerification").Value ,
                PluginManager.Get<VerifyEmailPlugin>().FirstOrDefault() , 
                PluginManager.Get<EmailVerifiedSocketMessage>().FirstOrDefault(),
                _configuration.GetDateTime("emailCutoffDate").GetValueOrDefault(DateTime.MinValue),
                PersistenceType,
                PersistenceDuration,
                _configuration.GetInt("emailVerificationExpirePeriod").GetValueOrDefault(0),
                RequiredMfaRoles,
                _configuration.GetString("cookieSameSite") ?? nameof(SameSiteMode.Lax),
                _configuration.GetString("whiteListPages").Split([',',';','\n'],StringSplitOptions.RemoveEmptyEntries)
            );
        }

        private string[] FromNavigation(string inputXml)
        {
            List<string> urls = new List<string>();
            
            var results = Injector.Get<ICustomNavigationService>().Deserialize(inputXml);

            foreach(var result in results)
            {
                urls.Add(result.Url);
            }
            return urls.ToArray();
        }
        public PersitenceEnum PersistenceType
        {
            get
            {
                  string persistenceType =_configuration.GetString("isPersistent") ?? nameof(PersitenceEnum.Authentication);

                  PersitenceEnum enumPersistenceType;

                  if (!Enum.TryParse(persistenceType, true, out enumPersistenceType))
                  {
                      switch (persistenceType.ToLower())
                      {
                          case "true":
                              enumPersistenceType = PersitenceEnum.Authentication;
                              break;
                          default:
                              enumPersistenceType = PersitenceEnum.Off;
                              break;
                      }
                  }

                  return enumPersistenceType;

            }
        }
     

        public int PersistenceDuration => _configuration.GetInt("persistentDuration").GetValueOrDefault(1);

        private int[] RequiredMfaRoles
        {
            get
            {
                if (_configuration == null)
                    return Array.Empty<int>();

                try
                {
                    return (_configuration.GetCustom("requireAllUsers") ?? string.Empty).Split(new[]
                    {
                        ','
                    }, StringSplitOptions.RemoveEmptyEntries).Select(int.Parse).ToArray();
                }
                catch (Exception ex)
                {
                    Apis.Get<IExceptions>().Log(ex);

                    return Array.Empty<int>();
                }
            }
        }

        public string Name => "4 Roads - MFA Plugin";

        public string Description => "Plugin for adding MFA using the google authenticator";
        public void FilterRequest(IHttpRequest request)
        {
            if (request?.HttpContext == null) 
                return;

            try
            {
                if (!(request.HttpContext.Request.Url is null))
                {
                   Injector.Get<IMfaLogic>().FilterRequest(request);
                }
            }
            catch
            {
                // ignored
            }
        }

        public IEnumerable<Type> Plugins => new[]
        {
            typeof (DependencyInjectionPlugin),
            typeof (InstallerCore),
            typeof (MfaSqlScriptsInstaller),
            typeof (DefaultWidgetInstaller),
            typeof (DefaultEmailInstaller),
            typeof (MfaAuthenticatorExtension),
            typeof (VerifyEmailPlugin),
            typeof (EmailVerifiedSocketMessage),
            typeof (DatePropertyTemplate)
        };

        public void LoadBindings(IContainer container)
        {
            container.Register<IMfaLogic, MfaLogic>(Reuse.Singleton);
            container.Register<IMfaDataProvider, MfaDataProvider>(Reuse.Singleton);
        }


        public int LoadOrder => 0;

        public void Update(IPluginConfiguration configuration)
        {
            _configuration = configuration;
        }

        public PropertyGroup[] ConfigurationOptions
        {
            get
            {
                PropertyGroup mfaOptions = new PropertyGroup {LabelResourceName = "MFAOptions" , Id="options"};

                var mfaProperty = new Property
                {
                    Id = "isPersistent",
                    LabelResourceName = "IsPersistent",
                    DescriptionResourceName = "IsPersistentDesc",
                    DataType = nameof(PropertyType.String),
                    DefaultValue = "true"
                };

                mfaProperty.SelectableValues.Add(new PropertyValue { LabelResourceName = "PersistentOff", Value = nameof(PersitenceEnum.Off), OrderNumber = 0});
                mfaProperty.SelectableValues.Add(new PropertyValue { LabelResourceName = "PersistentUserDefined", Value = nameof(PersitenceEnum.UserDefined), OrderNumber = 0 });
                mfaProperty.SelectableValues.Add(new PropertyValue { LabelResourceName = "PersistentAuthentication", Value = nameof(PersitenceEnum.Authentication), OrderNumber = 0 });

                mfaOptions.Properties.Add(mfaProperty);

                var persistentDurationProperty = new Property
                {
                    Id = "persistentDuration",
                    LabelResourceName = "PersistentDuration",
                    DescriptionResourceName = "PersistentDurationDesc",
                    DataType = nameof(PropertyType.Int),
                    DefaultValue = "90",
                };

                mfaOptions.Properties.Add(persistentDurationProperty);

                var cookieSameSiteProperty = new Property
                {
                    Id = "cookieSameSite",
                    LabelResourceName = "CookieSameSite",
                    DescriptionResourceName = "CookieSameSiteDesc",
                    DataType = nameof(PropertyType.String),
                    DefaultValue = nameof(SameSiteMode.Lax)
                };

                cookieSameSiteProperty.SelectableValues.Add(new PropertyValue
                    { LabelResourceName = "CookieSameSiteStrict", Value = nameof(SameSiteMode.Strict), OrderNumber = 1 });
                cookieSameSiteProperty.SelectableValues.Add(new PropertyValue
                    { LabelResourceName = "CookieSameSiteLax", Value = nameof(SameSiteMode.Lax), OrderNumber = 2 });
                cookieSameSiteProperty.SelectableValues.Add(new PropertyValue
                    { LabelResourceName = "CookieSameSiteNone", Value = nameof(SameSiteMode.None), OrderNumber = 3 });
                mfaOptions.Properties.Add(cookieSameSiteProperty);


                var whitelistPages = new Property
                {
                    Id = "whiteListPages",
                    LabelResourceName = "WhiteListPages",
                    DescriptionResourceName = "WhiteListPagesDesc",
                    Template= "string",
                    DataType = "string",
                    DefaultValue = "",
                    Options = new NameValueCollection { { "rows", "10"}, { "cols", "80" } }
                };

                mfaOptions.Properties.Add(whitelistPages);

                mfaOptions.Properties.Add(new Property
                {
                    Id = "requireAllUsers",
                    LabelResourceName = "RequireAllUsers",
                    DescriptionResourceName = "RequireAllUsersDesc",
                    DataType = "custom",
                    Template = "core_v2_roleLookup",
                    Options = new NameValueCollection
                    {
                        { "enableCurrent", "false" },
                        { "maxSelections", "100" },
                        { "format", "csv" }
                    }
                });

                PropertyGroup group = new PropertyGroup { LabelResourceName = "EmailOptions", Id = "options" };

                group.Properties.Add(new Property
                {
                    Id = "emailVerification",
                    LabelResourceName = "EmailVerification",
                    DataType = nameof(PropertyType.Bool),
                    DefaultValue = "true"
                });

                group.Properties.Add(new Property
                {
                    Id = "emailVerificationExpirePeriod",
                    LabelResourceName = "EmailVerificationExpirePeriod",
                    DescriptionResourceName = "EmailVerificationExpirePeriodDesc",
                    DataType = nameof(PropertyType.Int),
                    DefaultValue = "0"
                });

                group.Properties.Add(new Property
                {
                    Id = "emailCutoffDate",
                    LabelResourceName = "EmailCutoffDate",
                    DescriptionResourceName = "EmailCutoffDateDescription",
                    DataType = nameof(PropertyType.Date),
                    Template = "mfadate",
                    DefaultValue = ""
                });

                return new[] { mfaOptions, group };
            }
        }

        public void SetController(ITranslatablePluginController controller)
        {
            _translations = controller;
        }

        public Translation[] DefaultTranslations
        {
            get
            {
                Translation translation = new Translation("en-us");

                translation.Set("RequireAllUsers", "Mandatory Accounts");
                translation.Set("RequireAllUsersDesc", "Select the roles that are required to have MFA enabled");
                translation.Set("EmailVerificationExpirePeriod", "Email Verification Expires After");
                translation.Set("EmailVerificationExpirePeriodDesc", "The number of days after which email verification expires and the member must re-validate their email");
                translation.Set("EmailVerification", "Enable Email Verification");
                translation.Set("EmailCutoffDate", "Email Cutoff Date");
                translation.Set("EmailCutoffDateDescription", "When enabled on an existing community this date prevents users that have joined the site before this date being asked to authenticate email address");
                translation.Set("MFAOptions", "MFA Options");
                translation.Set("EmailOptions", "Email Options");
                translation.Set("IsPersistent", "When enabled the MFA cookie is persistent to the same expiry date of the session cookie");
                translation.Set("IsPersistentDesc", "When enabled, sets MFA cookie expiration date to match Community, otherwise MFA cookie is set for the duration of browser session");
                translation.Set("PersistentOff", "Off (any new browser session)");
                translation.Set("PersistentUserDefined", "User Defined (valid for a defined period)");
                translation.Set("PersistentAuthentication", "Authentication Session (The same period as the logon session)");
                translation.Set("PersistentDuration", "Persistence Duration");
                translation.Set("PersistentDurationDesc", "Number of days that the MFA cookie remains persistent");

                translation.Set("CookieSameSite", "MFA Cookie Same Site Setting");
                translation.Set("CookieSameSiteDesc", "Specifies how the MFA cookie is handled, when set to strict the cookie is only accepted when it is sent from this domain");
                translation.Set("CookieSameSiteStrict", "Strict");
                translation.Set("CookieSameSiteLax", "Lax");
                translation.Set("CookieSameSiteNone", "None");

                translation.Set("WhiteListPages", "Whitelist pages");
                translation.Set("WhiteListPagesDesc", "A list of pages that do not have MFA applied to them, for example terms and conditions or privacy, seperated by , ; or carriage retyurn");

                return new[] {translation};
            }
        }
    }
}