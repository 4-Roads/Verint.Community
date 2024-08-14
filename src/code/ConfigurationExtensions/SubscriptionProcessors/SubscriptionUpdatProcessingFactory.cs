using System.Collections.Generic;
using System.Linq;
using FourRoads.VerintCommunity.ConfigurationExtensions.Interfaces;
using Telligent.Evolution.Extensibility.Jobs.Version1;
using Telligent.Evolution.Extensibility.Version1;

namespace FourRoads.VerintCommunity.ConfigurationExtensions.SubscriptionProcessors
{
    public class SubscriptionUpdatProcessingFactory
    {
        private SubscriptionUpdatProcessingFactory()
        {
        }

        public static List<ISubscriptionUpdateProcessor> GetProcessors(JobData jobData)
        {
            List<ISubscriptionUpdateProcessor> retval = PluginManager.Get<ISubscriptionUpdateProcessor>().Where(p => p.CanProcess(jobData)).ToList();
            return retval;
        }
    }
}