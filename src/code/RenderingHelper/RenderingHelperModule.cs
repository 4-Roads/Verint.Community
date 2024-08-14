// ------------------------------------------------------------------------------
// <copyright company=" 4 Roads LTD">
//     Copyright (c) 4 Roads LTD - 2013.  All rights reserved.
// </copyright>
// -----------------------------------------------------------------------------

using System;
using System.Web;
using FourRoads.Common.VerintCommunity.Components;
using Telligent.Evolution.Extensibility.Version1;

namespace FourRoads.VerintCommunity.RenderingHelper
{
    public class RenderingHelperModule : IHttpModule
    {
        private IRenderingObserverPlugin _renderingObserverPlugin;

        public void Init(HttpApplication context)
        {
            context.PreRequestHandlerExecute += ContextOnBeginRequest;
            
            PluginManager.AfterInitialization += PluginManagerAfterConfigurationChanged;
        }

        private void PluginManagerAfterConfigurationChanged(object sender, EventArgs eventArgs)
        {
            _renderingObserverPlugin = null;
        }

        private IRenderingObserverPlugin RenderingObserverPlugin
        {
            get
            {
                IRenderingObserverPlugin renderingObserverPlugin = PluginManager.GetSingleton<IRenderingObserverPlugin>();

                if (renderingObserverPlugin != null && PluginManager.IsEnabled(renderingObserverPlugin))
                {
                    _renderingObserverPlugin = renderingObserverPlugin;
                }
                else
                {
                    _renderingObserverPlugin = null;
                }

                return _renderingObserverPlugin;
            }
        }

        private void ContextOnBeginRequest(object sender, EventArgs eventArgs)
        {
            try
            {
            HttpResponse response = HttpContext.Current.Response;
            HttpRequest  reqeust = HttpContext.Current.Request;

            if (response.ContentType == "text/html" && !reqeust.Path.StartsWith("/tinymce") &&
                  string.Compare(HttpContext.Current.Request.HttpMethod, "GET", StringComparison.OrdinalIgnoreCase) == 0 && //Don't do post backs to avoid issues with callbacks etc
                  (reqeust.CurrentExecutionFilePathExtension == ".aspx" || reqeust.CurrentExecutionFilePathExtension == ".htm" || reqeust.CurrentExecutionFilePathExtension == string.Empty))
            {
                if (RenderingObserverPlugin != null)
                {
                        //EventLogs.Info(reqeust.RawUrl, "Microdata", 100);

                    response.Filter = new RenderingHelperFilter(response.Filter, RenderingObserverPlugin);
                }
            }
        }
            catch (Exception ex)
            {
                new TCException("Rendering Helper Module Failed", ex).Log();
            }
   
        }

        public void Dispose()
        {
        }
    }
}