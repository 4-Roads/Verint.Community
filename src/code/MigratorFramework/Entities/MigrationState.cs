namespace FourRoads.VerintCommunity.MigratorFramework.Entities
{
    public enum MigrationState
    {
        Ready = 0,
        Pending = 1,
        Running = 2,
        Cancelling = 3,
        Finished = 4
    }
}