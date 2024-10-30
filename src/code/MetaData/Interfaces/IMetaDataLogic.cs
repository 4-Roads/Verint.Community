using System.Collections;
using FourRoads.VerintCommunity.MetaData.Logic;
using System;

namespace FourRoads.VerintCommunity.MetaData.Interfaces
{
    public interface IMetaDataLogic
    {
        MetaDataConfiguration GetConfig();
        void UpdateConfiguration(MetaDataConfiguration metaConfig);
        Logic.MetaData GetCurrentMetaData();
        string GetDynamicFormXml();
        string[] GetAvailableExtendedMetaTags();
        void SaveMetaDataConfiguration(string title, string description, string keywords,bool inherit, IDictionary extendedTags);
        bool CanEdit { get; }
        string FormatMetaString(string rawFieldValue, string seperator, IDictionary namedParameters);
        string GetBestImageUrlForCurrent();
        string GetBestImageUrlForContent(Guid contentId, Guid contentTypeId);
    }
}