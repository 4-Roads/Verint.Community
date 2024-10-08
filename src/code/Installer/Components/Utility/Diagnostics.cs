﻿using System.Diagnostics;
using System.Reflection;

namespace FourRoads.VerintCommunity.Installer.Components.Utility
{
    public class Diagnostics
    {
        public static bool IsDebug(Assembly assembly)
        {
            object[] attributes = assembly.GetCustomAttributes(typeof(DebuggableAttribute), true);
          
            if (attributes.Length == 0)
                return true;

            var d = (DebuggableAttribute)attributes[0];

            if (d.IsJITTrackingEnabled) 
                return true;

            return false;
        }

    }
}
