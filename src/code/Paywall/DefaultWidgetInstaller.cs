﻿using System;
using System.Runtime.CompilerServices;
using FourRoads.VerintCommunity.Installer;
using FourRoads.VerintCommunity.Installer.Components.Interfaces;
using FourRoads.VerintCommunity.Installer.Components.Utility;
using Telligent.Evolution.Extensibility.UI.Version1;

namespace FourRoads.VerintCommunity.Paywall
{
    internal class InternalCallerPath : ICallerPathVistor
    {
        public string GetPath() => InternalGetPath();
        protected string InternalGetPath([CallerFilePath] string path = null) => path;
    }

    public class DefaultWidgetInstaller : FactoryDefaultWidgetProviderInstaller<DefaultWidgetInstaller>, IScriptedContentFragmentFactoryDefaultProvider
    {
        public static Guid _scriptedContentFragmentFactoryDefaultIdentifier = new Guid("C2A9A6BD-2C06-4A18-975A-E7FB3D94FD77");

        public override Guid ScriptedContentFragmentFactoryDefaultIdentifier => _scriptedContentFragmentFactoryDefaultIdentifier;

        protected override string ProjectName => "Paywall";

        protected override string BaseResourcePath { get; } = "FourRoads.VerintCommunity.Paywall.Resources.";

        protected override EmbeddedResourcesBase EmbeddedResources => new EmbeddedResources();
        protected override ICallerPathVistor CallerPath()
        {
            return new InternalCallerPath();
        }
    }
}
