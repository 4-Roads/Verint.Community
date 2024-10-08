﻿using System;
using FourRoads.VerintCommunity.ConfigurationExtensions.Enumerations;
using Telligent.Evolution.Extensibility.Jobs.Version1;
using Telligent.Evolution.Extensibility.Api.Version1;
using Telligent.Evolution.Extensibility;
using Entities = Telligent.Evolution.Extensibility.Api.Entities.Version1;

namespace FourRoads.VerintCommunity.ConfigurationExtensions.Jobs
{
    public class ResetNotificationsJob : IEvolutionJob
    {
        public void Execute(JobData jobData)
        {
            Guid notificationTypeId = Guid.Parse(jobData.Data["NotificationTypeId"]);
            Guid distributionTypeId = Guid.Parse(jobData.Data["DistributionTypeId"]);
            bool enable = bool.Parse(jobData.Data["Enable"]);

            UserEnumerate enumerateUsers = new UserEnumerate(null, null);

            foreach (Entities.User user in enumerateUsers)
            {
                Apis.Get<IUsers>().RunAsUser(user.Id.Value, () => Apis.Get<INotifications>().UpdatePreference(notificationTypeId, distributionTypeId, enable));
            }
        }
    }

}
