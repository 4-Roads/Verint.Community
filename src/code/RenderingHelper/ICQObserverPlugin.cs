using System;

using Telligent.Evolution.Extensibility.Version1;
using AngleSharp.Html.Dom;

namespace FourRoads.Common.VerintCommunity.Plugins.Interfaces
{
	public interface ICQObserverPlugin:  IObserver<IHtmlDocument>, IPluginGroup, IDisposable 
	{
	}
}