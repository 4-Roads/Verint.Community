using Telligent.Evolution.Extensibility.Version1;

namespace FourRoads.VerintCommunity.MigratorFramework.Interfaces
{
    public interface IMigratorProvider : ISingletonPlugin
    {
        IMigrationFactory GetFactory();
    }
}