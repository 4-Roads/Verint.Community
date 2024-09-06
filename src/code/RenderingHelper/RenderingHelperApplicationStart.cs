using Microsoft.Web.Infrastructure.DynamicModuleHelper;

namespace FourRoads.VerintCommunity.RenderingHelper
{
    public class RenderingHelperApplicationStart
    {
        /// <summary>
        /// Dynamically registers HTTP Module
        /// </summary>
        public static void Start()
        {
            DynamicModuleUtility.RegisterModule(typeof(RenderingHelperModule));
        }
    }
}
