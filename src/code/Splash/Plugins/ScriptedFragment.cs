﻿using FourRoads.Common.VerintCommunity.Plugins.Base;
using FourRoads.VerintCommunity.Splash.Extensions;
using Telligent.Evolution.Extensibility.UI.Version1;

namespace FourRoads.VerintCommunity.Splash.Plugins
{
    public class ScriptedFragment : IScriptedContentFragmentExtension
    {
        public void Initialize()
        {
            
        }

        public string Name
        {
            get { return "Scripted Fragment Extension"; }
        }

        public string Description
        {
            get { return "Provides API access for the splash features"; }
        }


        public string ExtensionName {
            get { return "splash_v1"; }
        }

        public object Extension
        {
            get { return Injector.Get<SplashExtension>(); }
        }
    }
}