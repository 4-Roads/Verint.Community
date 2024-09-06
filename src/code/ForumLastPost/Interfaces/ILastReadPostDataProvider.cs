using System;

namespace FourRoads.VerintCommunity.ForumLastPost.Interfaces
{
    public interface ILastReadPostDataProvider
    {
        void UpdateLastReadPost(Guid appicationId, Guid contentId, int userId, Guid lastReadContentId , int replyCount , DateTime postDate);
        LastReadPostInfo GetLastReadPost(Guid appicationId, Guid contentId, int userId);
    }
}
