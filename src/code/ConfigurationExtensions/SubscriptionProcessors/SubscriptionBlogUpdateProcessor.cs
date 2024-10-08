using System.Linq;
using FourRoads.Common.VerintCommunity.Components.Extensions;
using FourRoads.VerintCommunity.ConfigurationExtensions.Enumerations;
using Telligent.Evolution.Extensibility.Api.Entities.Version1;
using Telligent.Evolution.Extensibility.Api.Version1;
using Telligent.Evolution.Extensibility;
using Telligent.Evolution.Extensibility.Content.Version1;
using Telligent.Evolution.Extensibility.Jobs.Version1;

namespace FourRoads.VerintCommunity.ConfigurationExtensions.SubscriptionProcessors
{
    public class SubscriptionBlogUpdateProcessor : SubscriptionUpdateProcessor
    {
        public override bool CanProcess(JobData jobData)
        {
            return jobData.Data.ContainsKey("processBlogs");
        }

        protected override void InternalProcess(User user, Group @group, JobData jobData)
        {
            int? blogId = jobData.Data.ContainsKey("BlogId") ? int.Parse(jobData.Data["BlogId"]) : default(int?);

            BlogEnumerate blogEnumerate = new BlogEnumerate(@group.Id.Value, blogId);

            foreach (Blog blog in blogEnumerate)
            {
                var lookups = blog.ExtendedAttributes.ToLookup(attribute => attribute.Key, val => (IExtendedAttribute)val);

                string setting = lookups.GetString("DefaultSubscriptionSetting", "unset");

                SetSubscriptionStatus(blog.ApplicationId, Apis.Get<IBlogs>().ApplicationTypeId, setting, user.Id.Value);
            }
        }

        public override string ProcessorName
        {
            get { return "Blog"; }
        }
    }
}