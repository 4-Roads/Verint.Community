// ------------------------------------------------------------------------------
// <copyright company=" 4 Roads LTD">
//     Copyright (c) 4 Roads LTD - 2014.  All rights reserved.
// </copyright>
// -----------------------------------------------------------------------------

using System;
using System.Text;
using System.Web;
using Telligent.DynamicConfiguration.Components;

namespace FourRoads.VerintCommunity.SocialProfileControls
{
    public abstract class TextProfileControl : IProfilePlugin
    {
        private readonly object _eventKey = new object();

        public void Initialize()
        {
        }

        public abstract string Name { get; }

        public abstract string Description { get; }

        public abstract string FieldName { get; }

        public abstract string Template { get; }

        public virtual string FieldType { get { return "Url"; } }
    }
}