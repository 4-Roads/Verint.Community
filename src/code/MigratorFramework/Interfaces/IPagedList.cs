using System.Collections.Generic;

namespace FourRoads.VerintCommunity.MigratorFramework.Interfaces
{
    public interface IPagedList<T> : IEnumerable<T>
    {
        int Total { get; }
    }
}