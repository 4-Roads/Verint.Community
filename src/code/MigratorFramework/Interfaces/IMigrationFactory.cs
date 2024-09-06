using System.Collections.Generic;

namespace FourRoads.VerintCommunity.MigratorFramework.Interfaces
{
    public interface IMigrationFactory
    {
        void SignalMigrationStarting();
        IEnumerable<string> GetOrderObjectHandlers();
        IMigrationObjectHandler GetHandler(string objectType);
        void SignalMigrationFinshing();
    }
}