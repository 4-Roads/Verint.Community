using FourRoads.Common.VerintCommunity.Plugins.Base;
using FourRoads.Common.VerintCommunity.Services.Interfaces;
using Telligent.Evolution.Caching.Services;
using Telligent.Evolution.Components;
using Telligent.Evolution.Extensibility;
using Telligent.Evolution.Extensibility.Version1;
using Telligent.Evolution.Platform.Auditing;
using Telligent.Evolution.Platform.Scripting.Services;
using Telligent.Evolution.ScriptedContentFragments.Services;

namespace FourRoads.VerintCommunity.Installer.Components.Utility
{
    //based on calls from ExpireCachesAdministrationPanel
    public class Caching
    {
   
        public static void ExpireUICaches()
        {
            Injector.Get<IFactoryDefaultScriptedContentFragmentService>().ExpireCache();
            Injector.Get<IScriptedContentFragmentService>().ExpireCache();
            Injector.Get<IContentFragmentPageService>().RemoveAllFromCache();
            Injector.Get<IContentFragmentService>().RefreshContentFragments();
            Injector.Get<IScriptedExtensionProcessedFileVersioningService>().Update();
            SystemFileStore.RequestHostVersionedThemeFileRegeneration();
        }

        public static void ExpireAllCaches()
        {
            Injector.Get<ICacheService>().Clear(CacheScope.All);
        }

        public static void ReloadPlugins()
        {
            Injector.Get<IPluginManager>().Initialize(true);
            Injector.Get<ICacheService>().Clear(CacheScope.All);
        }

    }
}