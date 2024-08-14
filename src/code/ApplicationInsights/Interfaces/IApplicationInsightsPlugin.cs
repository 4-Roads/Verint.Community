using System.Text.RegularExpressions;
using Microsoft.ApplicationInsights;

namespace FourRoads.VerintCommunity.Sentrus.Interfaces
{
    using Telligent.Evolution.Extensibility.Version1;

    public interface IApplicationInsightsFilter
    {
        bool ExludeSynthetic { get; set; }
        Regex IgnorePathsRegex { get; set; }
    }
    public interface IApplicationInsightsApplication
    {
        
    }

    public interface IApplicationInsightsPlugin : IPluginGroup, ISingletonPlugin
    {
        TelemetryClient TelemetryClient { get; }
    }
}