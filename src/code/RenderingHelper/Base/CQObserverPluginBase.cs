using System;
using System.Collections.Generic;
using System.Linq;
using FourRoads.Common.VerintCommunity.Components;
using FourRoads.Common.VerintCommunity.Plugins.Base;
using FourRoads.Common.VerintCommunity.Plugins.Interfaces;
using AngleSharp.Html.Dom;
using Telligent.Evolution.Extensibility.Version1;

namespace FourRoads.VerintCommunity.RenderingHelper
{
    public interface ICQProcessor 
    {
        void Process(IHtmlDocument document);
    }

	public abstract class CQObserverPluginBase : ICQObserverPlugin
	{
		protected IDisposable Observer;

		#region IObserver<CQ> Members
         
		public virtual void OnCompleted()
		{

		}

		public virtual void OnError(Exception error)
		{
		}

		public void OnNext(IHtmlDocument value)
		{
            try
            {
                if (PluginManager.IsEnabled(this))
                {
                    //Decouple the processing of the document from the plugin
                    GetProcessor().Process(value);
                }
            }
            catch(Exception ex)
            {
                new TCException( "Rendering observer plugin error", ex).Log();
            }
		}

        protected abstract ICQProcessor GetProcessor();

		#endregion

		#region IPluginGroup Members

		public virtual IEnumerable<Type> Plugins
		{
			get
			{
				return new[]
				       	{
				       		typeof (RenderingObserverPlugin),
                            typeof (DependencyInjectionPlugin)
				       	};
			}
		}

		#endregion

		#region IPlugin Members

		public abstract string Description { get; }

		public virtual void Initialize()
		{
            PluginManager.AfterInitialization += (sender, args) =>
            {
                if (Observer != null)
                {
                    Observer.Dispose();
                    Observer = null;
                }

                IRenderingObserverPlugin renderingObserverPlugin = PluginManager.Get<IRenderingObserverPlugin>().FirstOrDefault();

                if (renderingObserverPlugin != null)
                {
                    Observer = renderingObserverPlugin.RenderObservable.Subscribe(this);
                }
            };
		}

		public abstract string Name { get; }

		#endregion

		#region IDisposable Members

		public virtual void Dispose()
		{
			if (Observer != null)
				Observer.Dispose();
		}

		#endregion
	}
}