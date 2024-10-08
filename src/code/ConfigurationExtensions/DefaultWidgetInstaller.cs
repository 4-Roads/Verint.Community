﻿using System;
using System.Runtime.CompilerServices;
using FourRoads.VerintCommunity.ConfigurationExtensions.Interfaces;
using FourRoads.VerintCommunity.Installer;
using FourRoads.VerintCommunity.Installer.Components.Interfaces;
using FourRoads.VerintCommunity.Installer.Components.Utility;
using Telligent.Evolution.Extensibility.UI.Version1;
using Telligent.Evolution.Extensibility.Version1;

namespace FourRoads.VerintCommunity.ConfigurationExtensions
{
    internal class InternalCallerPath : ICallerPathVistor
    {
        public string GetPath() => InternalGetPath();

        protected string InternalGetPath([CallerFilePath] string path = null) => path;
    }

    public class DefaultWidgetInstaller : FactoryDefaultWidgetProviderInstaller<DefaultWidgetInstaller>, IApplicationPlugin, IScriptedContentFragmentFactoryDefaultProvider
    {
        private readonly Guid _scriptedContentFragmentFactoryDefaultIdentifier = new Guid("2e58b526724841b19a9908764342c024");

        public override Guid ScriptedContentFragmentFactoryDefaultIdentifier
        {
            get { return _scriptedContentFragmentFactoryDefaultIdentifier; }
        }

        protected override string ProjectName
        {
            get { return "Configuration Extensions"; }
        }

        protected override string BaseResourcePath
        {
            get { return "FourRoads.VerintCommunity.ConfigurationExtensions.Resources."; }
        }

        protected override EmbeddedResourcesBase EmbeddedResources
        {
            get { return new EmbeddedResources(); }
        }

        protected override ICallerPathVistor CallerPath()
        {
            return new InternalCallerPath();
        }
    }
}
