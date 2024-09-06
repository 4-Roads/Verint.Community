using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using FourRoads.VerintCommunity.MigratorFramework.Interfaces;
using Telligent.Evolution.Components;
using Telligent.Evolution.Extensibility.Content.Version1;
using Telligent.Evolution.Extensibility.Version1;
using PluginManager = Telligent.Evolution.Extensibility.Version1.PluginManager;

namespace FourRoads.VerintCommunity.MigratorFramework
{
    public class PluginDisabler : IDisposable
    {
        private readonly IMigrationRepository _repository;
        private List<IPlugin> _disabledPlugins = new List<IPlugin>();

        public PluginDisabler(IMigrationRepository repository)
        {
            _repository = repository;
            //Moderation
            IEnumerable<IPlugin> plugins = PluginManager.Get<IPlugin>();
            List<IPlugin> pluginsFiltered = new List<IPlugin>();

            foreach (var plugin in plugins)
            {
                if (PluginManager.IsEnabled(plugin))
                {
                    if (plugin is IAbuseDetector ||
                        plugin is INotificationType ||
                        plugin is IActivityStoryType ||
                        plugin is INotificationDistributionType)
                    {
                        _disabledPlugins.Add(plugin);
                    }
                    else
                    {
                        pluginsFiltered.Add(plugin);
                    }
                }
            }

            var pluginsNames = string.Join(", ", _disabledPlugins.Select(p => p.Name));
            _repository.CreateLogEntry($"The following plugins were disabled:{pluginsNames}" , EventLogEntryType.Information);

            ServiceLocation.CreateServiceLocator().Get<IPluginManager>().SetEnabled(pluginsFiltered);
        }

        public void Dispose()
        {
            IEnumerable<IPlugin> plugins = PluginManager.Get<IPlugin>();

            List<IPlugin> revertList = new List<IPlugin>(plugins.Where(p => PluginManager.IsEnabled(p)));

            revertList.AddRange(_disabledPlugins);

            var pluginsNames = string.Join(", ", _disabledPlugins.Select(p => p.Name));
            _repository.CreateLogEntry($"The following plugins were enabled:{pluginsNames}", EventLogEntryType.Information);

            ServiceLocation.CreateServiceLocator().Get<IPluginManager>().SetEnabled(revertList);
        }
    }
}