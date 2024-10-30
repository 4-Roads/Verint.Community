using System.Collections.Generic;

namespace FourRoads.VerintCommunity.MetaData.Logic
{
    public class MetaDataConfiguration
    {
        public MetaDataConfiguration()
        {
            //Default extended entries
            ExtendedEntries = new List<string>();

            //snippets within embedded image urls to ignore
            EmbeddedImageExclusions = new List<string>();

            CanInheritTitle = false;
            CanInheritDesc = false;
            CanInheritKeywords = false;
            CanInheritTags = true;
        }

        public List<string> ExtendedEntries { get; set; }

        public List<string> EmbeddedImageExclusions { get; set; }

        /// <summary>
        /// When inheriting metadata from parent applications/groups for a content item such as a thread/blog post 
        /// should we update the title from the parents
        /// </summary>
        public bool CanInheritTitle { get; set; }

        /// <summary>
        /// When inheriting metadata from parent applications/groups for a content item such as a thread/blog post 
        /// should we update the description from the parents 
        /// </summary>
        public bool CanInheritDesc { get; set; }

        /// <summary>
        /// When inheriting metadata from parent applications/groups for a content item such as a thread/blog post 
        /// should we update the keywords from the parents 
        /// </summary>
        public bool CanInheritKeywords { get; set; }

        /// <summary>
        /// When inheriting metadata from parent applications/groups for a content item such as a thread/blog post 
        /// should we merge the tags from the parents 
        /// </summary>
        public bool CanInheritTags { get; set; }

    }
}