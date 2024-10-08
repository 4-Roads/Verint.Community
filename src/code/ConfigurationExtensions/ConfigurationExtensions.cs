﻿using System;
using System.Collections.Generic;
using System.Linq;
using Telligent.Evolution.Extensibility.Api.Entities.Version1;
using Telligent.Evolution.Extensibility.Api.Version1;
using Telligent.Evolution.Extensibility;
using FourRoads.VerintCommunity.ConfigurationExtensions.Jobs;
using FourRoads.VerintCommunity.ConfigurationExtensions.Api.Public.Entities;
using FourRoads.VerintCommunity.ConfigurationExtensions.Api.Internal.Data;
using Telligent.Evolution.Extensions.Calendar.Extensibility.Api.Version1;
using Telligent.Evolution.Extensibility.Jobs.Version1;

namespace FourRoads.VerintCommunity.ConfigurationExtensions
{
    public class ConfigurationExtensions
    {
        public void UpdateDefaultForumSubscripiton(int forumId, string newState)
        {
            var forum = Apis.Get<IForums>().Get(forumId);

            ExtendedAttribute currentSetting = forum.ExtendedAttributes.Get("DefaultSubscriptionSetting");
            if (currentSetting == null)
            {
                forum.ExtendedAttributes.Add(new ExtendedAttribute() { Key = "DefaultSubscriptionSetting", Value = newState });
            }
            else
            {
                currentSetting.Value = newState;
            }

            Apis.Get<IForums>().Update(forumId, new ForumsUpdateOptions() { ExtendedAttributes = forum.ExtendedAttributes });
        }

        public void ResetDefaultForumSubscripiton(int forumId , int groupId)
        {
            //Enumerate all of the users and for this forum set there notification setting
            //Get all of the forums of this group and get the default subscription and assign the user
            Apis.Get<IJobService>().Schedule(typeof(SubscriptionUpdateJob), DateTime.UtcNow, new Dictionary<string, string>()
            {
                {"GroupId" , groupId.ToString()},
                {"ForumId" , forumId.ToString()},
                {"processForums" , bool.TrueString},
            });
        }


        public void UpdateDefaultBlogSubscripiton(int blogId, string newState)
        {
            var blog = Apis.Get<IBlogs>().Get(new BlogsGetOptions() { Id = blogId });

            ExtendedAttribute currentSetting = blog.ExtendedAttributes.Get("DefaultSubscriptionSetting");
            if (currentSetting == null)
            {
                blog.ExtendedAttributes.Add(new ExtendedAttribute() { Key = "DefaultSubscriptionSetting", Value = newState });
            }
            else
            {
                currentSetting.Value = newState;
            }

            Apis.Get<IBlogs>().Update(blogId, new BlogsUpdateOptions() { ExtendedAttributes = blog.ExtendedAttributes });
        }

        public void ResetDefaultBlogSubscripiton(int blogId, int groupId)
        {
            //Enumerate all of the users and for this forum set there notification setting
            //Get all of the forums of this group and get the default subscription and assign the user
            Apis.Get<IJobService>().Schedule(typeof(SubscriptionUpdateJob), DateTime.UtcNow, new Dictionary<string, string>()
            {
                {"GroupId" , groupId.ToString()},
                {"BlogId" , blogId.ToString()},
                {"processBlogs" , bool.TrueString},
            });
        }

        public void UpdateDefaultGroupDigestSubscripiton(int groupId, string newState)
        {
            var group = Apis.Get<IGroups>().Get(new GroupsGetOptions(){Id=groupId});
            ExtendedAttribute currentSetting = group.ExtendedAttributes.Get("DefaultDigestSetting");
            if (currentSetting == null)
            {
                group.ExtendedAttributes.Add(new ExtendedAttribute() { Key = "DefaultDigestSetting", Value = newState });
            }
            else
            {
                currentSetting.Value = newState;
            }

            Apis.Get<IGroups>().Update(groupId, new GroupsUpdateOptions() { ExtendedAttributes = group.ExtendedAttributes });
        }

        public void ResetDefaultGroupDigestSubscripiton(int groupId)
        {
            Apis.Get<IJobService>().Schedule(typeof(SubscriptionUpdateJob), DateTime.UtcNow, new Dictionary<string, string>()
            {
                {"GroupId" , groupId.ToString()},
                {"processGroups" , bool.TrueString},
            });
        }

        public void UpdateUserDefaultNotifications(String notificationType, String distributionType, bool enable)
        {
            if (Apis.Get<IRoleUsers>().IsUserInRoles(Apis.Get<IUsers>().AccessingUser.Username, new string[] { "Administrators" }))
            {
                Guid notificationTypeId = Guid.Parse(notificationType);
                Guid distributionTypeId = Guid.Parse(distributionType);
                Group rootGroup = Apis.Get<IGroups>().Root;
                List<SystemNotificationPreference> defaults = DefaultSystemNotifications.GetSystemNotificationPreferences();
                SystemNotificationPreference preference = (from p in defaults where p.NotificationTypeId == notificationTypeId && p.DistributionTypeId == distributionTypeId select p).FirstOrDefault();
                if (preference == null)
                {
                    preference = new SystemNotificationPreference(notificationTypeId, distributionTypeId, enable);
                    defaults.Add(preference);
                }
                else
                {
                    preference.IsEnabled = enable;
                }
                DefaultSystemNotifications.UpdateSystemNotificationPreferences(defaults);
            }
        }

        public void ResetUserNotifications(String notificationTypeId, String distributionTypes)
        {
            if (Apis.Get<IRoleUsers>().IsUserInRoles(Apis.Get<IUsers>().AccessingUser.Username, new string[] { "Administrators" }))
            {
                ApiList<NotificationDistributionTypeInfo> dTypes = Apis.Get<INotifications>().ListDistributionTypes();
                foreach (NotificationDistributionTypeInfo info in dTypes)
                {
                    Dictionary<string, string> data = new Dictionary<string, string>();
                    data.Add("NotificationTypeId", notificationTypeId.ToString());
                    data.Add("DistributionTypeId", info.DistributionTypeId.ToString());
                    if (distributionTypes.IndexOf(info.DistributionTypeId.ToString()) != -1)
                    {
                        data.Add("Enable", "true");
                    }
                    else
                    {
                        data.Add("Enable", "false");
                    }
                    Apis.Get<IJobService>().Schedule(typeof(ResetNotificationsJob), DateTime.UtcNow, data);
                }
            }
        }

        public void ResetUserNotifications(Guid notificationTypeId, Guid distributionTypeId, bool enable)
        {
            if (Apis.Get<IRoleUsers>().IsUserInRoles(Apis.Get<IUsers>().AccessingUser.Username, new string[] { "Administrators" }))
            {
                Dictionary<string, string> data = new Dictionary<string, string>();
                data.Add("NotificationTypeId", notificationTypeId.ToString());
                data.Add("DistributionTypeId", distributionTypeId.ToString());
                data.Add("Enable", enable.ToString());
                Apis.Get<IJobService>().Schedule(typeof(ResetNotificationsJob), DateTime.UtcNow, data);
            }
        }

        public List<SystemNotificationPreference> GetSystemDefaultNotifications()
        {
            List<SystemNotificationPreference> retval = DefaultSystemNotifications.GetSystemNotificationPreferences();
            return retval;
        }


        public void UpdateDefaultCalendarSubscripiton(int calendarId, string newState)
        {
            var calendar = Apis.Get<ICalendars>().Show(new CalendarsShowOptions() { Id = calendarId });

            ExtendedAttribute currentSetting = calendar.Group.ExtendedAttributes.Get("DefaultSubscriptionSetting" + calendar.NodeId);
     
            if (currentSetting == null)
            {
                calendar.Group.ExtendedAttributes.Add(new ExtendedAttribute() { Key = "DefaultSubscriptionSetting" + calendar.NodeId, Value = newState });
            }
            else
            {
                currentSetting.Value = newState;
            }

            Apis.Get<IGroups>().Update(calendar.Group.Id.Value, new GroupsUpdateOptions() { ExtendedAttributes = calendar.Group.ExtendedAttributes });
        }

        public void ResetDefaultCalendarSubscripiton(int calendarId, int groupId)
        {
            //Enumerate all of the users and for this forum set there notification setting
            //Get all of the forums of this group and get the default subscription and assign the user
            Apis.Get<IJobService>().Schedule(typeof(SubscriptionUpdateJob), DateTime.UtcNow, new Dictionary<string, string>()
            {
                {"GroupId" , groupId.ToString()},
                {"CalendarId" , calendarId.ToString()},
                {"processCalendars" , bool.TrueString},
            });
        }

    }
}
