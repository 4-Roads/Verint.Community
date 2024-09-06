using System.Collections.Generic;
using FourRoads.VerintCommunity.MigratorFramework.Interfaces;

namespace FourRoads.VerintCommunity.MigratorFramework.Entities
{
    public class PagedList<T> :  List<T>, IPagedList<T>
    {
        public int Total { get; set; }
    }
}