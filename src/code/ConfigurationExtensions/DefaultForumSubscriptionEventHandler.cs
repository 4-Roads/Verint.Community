﻿using System;
using System.Collections.Generic;
using FourRoads.VerintCommunity.ConfigurationExtensions.Interfaces;
using FourRoads.VerintCommunity.ConfigurationExtensions.Jobs;
using Telligent.Evolution.Extensibility.Api.Version1;
using Telligent.Evolution.Extensibility;
using Telligent.Evolution.Extensibility.Version1;
using Telligent.Evolution.Extensibility.Jobs.Version1;

namespace FourRoads.VerintCommunity.ConfigurationExtensions
{
    public class DefaultForumSubscriptionEventHandler : IPlugin , IApplicationPlugin
    {
        public void Initialize()
        {
            Apis.Get<IGroupUserMembers>().Events.AfterUpdate += Events_AfterUpdate;
            Apis.Get<IUsers>().Events.AfterCreate += EventsOnAfterCreate;
        }

        private void EventsOnAfterCreate(UserAfterCreateEventArgs userAfterCreateEventArgs)
        {
            //Find all of the joinless groups with forums and set the default subscription for this user
            Apis.Get<IJobService>().Schedule(typeof(SubscriptionUpdateJob) ,DateTime.UtcNow, new Dictionary<string,string>()
            {
                {"UserName" , userAfterCreateEventArgs.Username},
                {"processForums" , bool.TrueString},
                {"processBlogs" , bool.TrueString},
                {"processCalendars" , bool.TrueString},
                {"processGroups", bool.TrueString}
            });
        }

        private void Events_AfterUpdate(GroupUserAfterUpdateEventArgs e)
        {
            //Get all of the forums of this group and get the default subscription and assign the user
            Apis.Get<IJobService>().Schedule(typeof(SubscriptionUpdateJob), DateTime.UtcNow, new Dictionary<string, string>()
            {
                {"UserName" , e.User.Username},
                {"GroupId" , e.Group.Id.ToString()},
                {"processForums" , bool.TrueString},
                {"processCalendars" , bool.TrueString},
                {"processGroups", bool.TrueString}
            });
        }

        public string Name {
            get { return "Forum Subscription Events Handler"; }
        }

        public string Description {
            get { return "Handles the events to configure the default subscriptions"; }
        }


    }
}
