﻿using System;
using System.Diagnostics;

namespace FourRoads.VerintCommunity.MigratorFramework.Entities
{
    public class MigrationLog
    {
        public DateTime Created { get; set; }
        public EventLogEntryType Type { get; set; }
        public string Message { get; set; }
    }
}