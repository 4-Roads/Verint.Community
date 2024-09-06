// //  ------------------------------------------------------------------------------
// //  <copyright company="4 Roads LTD">
// //  Copyright (c) 4 Roads LTD 2019.  All rights reserved.
// //  </copyright>
// //  ------------------------------------------------------------------------------

using System;
using FourRoads.Common.VerintCommunity.Components.Interfaces;
using Telligent.Evolution.Components;
using Telligent.Evolution.Extensibility.Api.Entities.Version1;
using Telligent.Evolution.Extensibility.UI.Version1;

namespace FourRoads.Common.VerintCommunity.Plugins.ScriptedContentFragments
{
    public class ContentScriptedContentFragment
    {
        public ContentScriptedContentFragment(IContentLogic contentLogic)
        {
            ContentLogic = contentLogic;
        }

        protected IContentLogic ContentLogic { get; private set; }

        public string GetBestImageUrl(Guid contentId , Guid contentTypeId)
        {
            return ContentLogic.GetBestImageUrl(contentId , contentTypeId);
        }

        public ApiList<string> GetAllImageUrls(Guid contentId, Guid contentTypeId)
        {
            return new ApiList<string> (ContentLogic.GetAllImageUrls(contentId, contentTypeId));
        }

        public ApiList<string> GetVideoUrls(Guid contentId, Guid contentTypeId)
        {
            return new ApiList<string>(ContentLogic.GetAllVideoUrls(contentId, contentTypeId));
        }

        public string GetFirstVideoUrl(Guid contentId, Guid contentTypeId)
        {
            return ContentLogic.GetFirstVideoUrl(contentId, contentTypeId);
        }
    }
}