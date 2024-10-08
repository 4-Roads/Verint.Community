﻿using System.Text.RegularExpressions;
using FourRoads.VerintCommunity.Sentrus.Interfaces;
using Microsoft.ApplicationInsights.Channel;
using Microsoft.ApplicationInsights.DataContracts;
using Microsoft.ApplicationInsights.Extensibility;

namespace FourRoads.VerintCommunity.ApplicationInsights
{

    public class ApplicationInsightsTelemetaryFilter : ITelemetryProcessor , IApplicationInsightsFilter
    {
        private ITelemetryProcessor Next { get; set; }

        public ApplicationInsightsTelemetaryFilter(ITelemetryProcessor next)
        {
            Next = next;
        }

        public void Process(ITelemetry item)
        {
            if (ExludeSynthetic)
            {
                if (!string.IsNullOrEmpty(item?.Context?.Operation?.SyntheticSource))
                {
                    return;
                }
            }

            if (IgnorePathsRegex != null)
            {
                var request = item as RequestTelemetry;
                if (request != null)
                {
                    // Determine tenant
                    string url = request.Url?.PathAndQuery.ToLower();

                    if (IgnorePathsRegex.IsMatch(url?? string.Empty))
                        return;
                }
            }

            Next?.Process(item);
        }

        public bool ExludeSynthetic { get; set; }

        public Regex IgnorePathsRegex { get; set; }
    }
}