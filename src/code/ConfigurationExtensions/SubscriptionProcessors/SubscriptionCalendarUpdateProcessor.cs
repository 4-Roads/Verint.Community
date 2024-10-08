using System.Linq;
using FourRoads.Common.VerintCommunity.Components.Extensions;
using FourRoads.VerintCommunity.ConfigurationExtensions.Enumerations;
using Telligent.Evolution.Calendar.Plugins;
using Telligent.Evolution.Extensibility.Api.Entities.Version1;
using Telligent.Evolution.Extensibility.Api.Version1;
using Telligent.Evolution.Extensibility;
using Telligent.Evolution.Extensibility.Content.Version1;
using Telligent.Evolution.Extensibility.Jobs.Version1;
using Telligent.Evolution.Extensions.Calendar.Extensibility.Api.Entities.Version1;
using Telligent.Evolution.Extensibility.Version1;
using Telligent.Evolution.Extensions.Calendar.Extensibility.Api.Version1;

namespace FourRoads.VerintCommunity.ConfigurationExtensions.SubscriptionProcessors
{
    public class SubscriptionCalendarUpdateProcessor : SubscriptionUpdateProcessor
    {
        public override bool CanProcess(JobData jobData)
        {
            bool retval = false;
            IPlugin calendars = PluginManager.Get<CalendarApplicationType>().FirstOrDefault();
            if(calendars != null && PluginManager.IsEnabled(calendars) && jobData.Data.ContainsKey("processCalendars"))
            {
                retval = true;
            }
            return retval;
        }

        protected override void InternalProcess(User user, Group @group, JobData jobData)
        {
            int? calendarId = jobData.Data.ContainsKey("CalendarId") ? int.Parse(jobData.Data["CalendarId"]) : default(int?);

            CalendarEnumerate calendarEnumerate = new CalendarEnumerate(@group.Id.Value, calendarId);

            foreach (Calendar calendar in calendarEnumerate)
            {
                //Because calendars don't support extended attributes we need to store them on the group
                var lookups = calendar.Group.ExtendedAttributes.ToLookup(attribute => attribute.Key, val => (IExtendedAttribute)val);

                string setting = lookups.GetString("DefaultSubscriptionSetting" + calendar.NodeId, "unset");

                SetSubscriptionStatus(calendar.Id.Value, setting, user.Id.Value);
            }
        } 

        public override string ProcessorName
        {
            get { return "Calendar"; }
        }
         
        protected void SetSubscriptionStatus(int calendarId, string setting, int userId)
        {
            Apis.Get<IUsers>().RunAsUser(userId, () =>
            {
                if (setting.ToLower() == "subscribed")
                {
                    Apis.Get<ICalendarSubscriptions>().Subscribe(userId, calendarId);
                }
                else if (setting.ToLower() == "unsubscribed")
                {
                    Apis.Get<ICalendarSubscriptions>().Unsubscribe(userId, calendarId);
                }
            });
        }
    }
}