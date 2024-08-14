using System;
using System.Text;
using System.Collections.Generic;
using FourRoads.Common.VerintCommunity.Components;
using FourRoads.VerintCommunity.ConfigurationExtensions.SubscriptionProcessors;
using Telligent.Evolution.Extensibility.Jobs.Version1;
using FourRoads.VerintCommunity.ConfigurationExtensions.Interfaces;

namespace FourRoads.VerintCommunity.ConfigurationExtensions.Jobs
{
    public class SubscriptionUpdateJob : IEvolutionJob 
    {
        public void Execute(JobData jobData)
        {
            List<ISubscriptionUpdateProcessor> processors = SubscriptionUpdatProcessingFactory.GetProcessors(jobData);
            foreach (ISubscriptionUpdateProcessor p in processors)
            {
                try
                {
                    p.Process(jobData);
                }
                catch (Exception e) 
                { 
                    StringBuilder msg = new StringBuilder(p.Name);
                    msg.Append(" threw Exception ");
                    msg.Append(e.ToString());
                    new TCException( msg.ToString()).Log();
                }
            }
        }
    }
}