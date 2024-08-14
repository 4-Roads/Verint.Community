using Microsoft.Web.Infrastructure.DynamicModuleHelper;

namespace FourRoads.VerintCommunity.ApplicationInsights
{
    public class ExceptionHandlerStart
    {
        /// <summary>
        /// Dynamically registers HTTP Module
        /// </summary>
        public static void Start()
        {
            DynamicModuleUtility.RegisterModule(typeof(ExceptionHandler));
        }
    }
}