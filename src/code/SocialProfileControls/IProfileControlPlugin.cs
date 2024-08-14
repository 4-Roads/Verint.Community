using Telligent.Evolution.Extensibility.Configuration.Version1;
using Telligent.Evolution.Extensibility.Version1;
namespace FourRoads.VerintCommunity.SocialProfileControls
{
    public interface IProfileControlPlugin : IPlugin
    {
        string GetValueValidationScript(IPropertyTemplateOptions options, string inputElement, string apiChanged);
        string GetPlaceholder();
    }
}
