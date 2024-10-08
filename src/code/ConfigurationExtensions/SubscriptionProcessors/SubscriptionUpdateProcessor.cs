using System;
using FourRoads.VerintCommunity.ConfigurationExtensions.Enumerations;
using FourRoads.VerintCommunity.ConfigurationExtensions.Interfaces;
using Telligent.Evolution.Extensibility.Api.Entities.Version1;
using Telligent.Evolution.Extensibility.Api.Version1;
using Telligent.Evolution.Extensibility;
using Telligent.Evolution.Extensibility.Jobs.Version1;

namespace FourRoads.VerintCommunity.ConfigurationExtensions.SubscriptionProcessors
{
    public abstract class SubscriptionUpdateProcessor : ISubscriptionUpdateProcessor
    {
        protected int? GroupId { get; private set; }
        protected string UserName { get; private set; }
        public abstract string ProcessorName { get; }

        public abstract bool CanProcess(JobData jobData);

        public void Process(JobData jobData)
        {
            GroupId = jobData.Data.ContainsKey("GroupId") ? int.Parse(jobData.Data["GroupId"]) : default(int?);
            UserName = jobData.Data.ContainsKey("UserName") ? jobData.Data["UserName"] : null;

            var userEnumerator = new UserEnumerate(UserName, GroupId);

            var groupEnumerate = new GroupEnumerate(GroupId);

            foreach (User user in userEnumerator)
            {
                foreach (Group group in groupEnumerate)
                {
                    InternalProcess(user, group, jobData);
                }
            }
        }

        public virtual void Initialize()
        {
        }

        public string Name
        {
            get { return "Subscription Processor for " + ProcessorName; }
        }

        public string Description
        {
            get { return "Processes subscription updates for" + ProcessorName; }
        }

        protected abstract void InternalProcess(User user, Group @group, JobData jobData);

        protected virtual void SetSubscriptionStatus(Guid contentId, Guid contentTypeId, string setting, int userId)
        {
            Apis.Get<IUsers>().RunAsUser(userId, () =>
            {
                if (setting.ToLower() == "subscribed")
                {
                    Apis.Get<IApplicationSubscriptions>().Create(contentId, contentTypeId);
                }
                else if (setting.ToLower() == "unsubscribed")
                {
                    Apis.Get<IApplicationSubscriptions>().Delete(contentId, contentTypeId);
                }
            });
        }
    }
}