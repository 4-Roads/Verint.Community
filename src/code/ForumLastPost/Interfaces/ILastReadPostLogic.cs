﻿using System;

namespace FourRoads.VerintCommunity.ForumLastPost.Interfaces
{
    public interface ILastReadPostLogic
    {
        void UpdateLastReadPost(Guid appicationId, int userId, int threadId, int forumId, int replyId, Guid lastReadContentId, DateTime postDateTime);
        LastReadPostInfo GetLastReadPost(Guid appicationId, Guid contentId, int userId);
        void SetLastReadPost(Guid appicationId, Guid contentId);
    }
}
