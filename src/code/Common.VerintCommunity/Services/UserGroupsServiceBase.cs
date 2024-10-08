﻿using FourRoads.Common.VerintCommunity.Components;
using FourRoads.Common.VerintCommunity.Plugins.Base;
using FourRoads.Common.VerintCommunity.Services.Interfaces;
using System;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Web;
using Telligent.Evolution.Extensibility.Api.Entities.Version1;
using Telligent.Evolution.Extensibility.Api.Version1;
using Telligent.Evolution.Extensibility.Caching.Version1;

namespace FourRoads.Common.VerintCommunity.Services
{
    public abstract class UserGroupsServiceBase : IUserGroupsService
    {
        protected readonly IEventLog _eventLog;
        protected readonly IGroups _groupsService;
        private IGroupFileService _groupFileService;
        protected readonly IGroupUserMembers _groupUserService;
        protected readonly IProcess _process;
        protected readonly IUsers _users;

        protected abstract string CacheKey { get; }
        protected abstract string BaseResourcePath { get; }

        protected IGroupFileService GroupFileService
        {
            get
            {
                if (_groupFileService == null)
                {
                    _groupFileService = Injector.Get<IGroupFileService>();
                }
                return _groupFileService;
            }
        }

        public UserGroupsServiceBase(IEventLog eventLog,
            IGroups groupsService,
            IGroupUserMembers groupUserService,
            IProcess process,
            IUsers users)
        {
            _eventLog = eventLog;
            _groupsService = groupsService;
            _groupUserService = groupUserService;
            _process = process;
            _users = users;
        }

        public virtual void AddUser(User user, Group group)
        {
            _users.RunAsUser("admin", () =>
            {
                if (!_groupUserService.List(new GroupUserMembersListOptions() { IncludeRoleMembers = false, GroupId = group.Id, UserId = user.Id.Value }).Any())
                {
                    // Silently add the user to the role
                    _process.RunProcessWithDisabledActivityStories(() =>
                    {
                        _process.RunProcessWithDisabledNotifications(() =>
                        {
                            var addedMember = _groupUserService.Create(
                                group.Id.Value,
                                user.Id.Value,
                                new GroupUserMembersCreateOptions() { GroupMembershipType = "Member" });

                            if (addedMember != null && addedMember.HasErrors())
                            {
                                _eventLog.Write($"Added userid {user.Id} to group {group.Name}", new EventLogEntryWriteOptions() { Category = "Connect", EventType = "Information" });
                            }
                        });
                    });
                }
            });
        }

        public virtual Group CreateGroup(string groupName, string groupDescription, string groupType, NameValueCollection configuration, bool createApps, int? parentGroupId = null)
        {
            if (string.IsNullOrWhiteSpace(groupDescription))
            {
                groupDescription = $"{groupName} Group";
            }

            var groupOptions = new GroupsCreateOptions
            {
                Description = groupDescription,
                ParentGroupId = parentGroupId,
            };

            ConfigureGroupsCreateOptions(groupOptions, configuration);

            _process.RunProcessWithDisabledActivityStories(() =>
            {
                _process.RunProcessWithDisabledNotifications(() =>
                {
                    _groupsService.Create(groupName, groupType, groupOptions);
                });
            });

            // as we suppress activity stores when creating group 
            //it raises an error trying to create it
            // so have to try and read to ensure it exists
            var newGroup = GetGroup(groupName);

            if (newGroup != null && !newGroup.HasErrors())
            {
                ConfigureGroup(newGroup, configuration);

                if (createApps)
                {
                    CreateApplications(newGroup);
                }
            }

            return newGroup;
        }

        /// <summary>
        /// Configures a new group using a set of custom configuration values
        /// </summary>
        /// <param name="group"></param>
        /// <param name="configuration"></param>
        protected virtual void ConfigureGroup(Group group, NameValueCollection configuration) { }

        /// <summary>
        /// Creates child applications for a group
        /// </summary>
        /// <param name="group"></param>
        protected abstract void CreateApplications(Group group);

        /// <summary>
        /// Configures group creation options.
        /// </summary>
        /// <param name="groupCreateOptions">The group creation options</param>
        /// <param name="configuration">A collection of configuration values</param>
        /// <returns></returns>
        protected abstract void ConfigureGroupsCreateOptions(GroupsCreateOptions groupCreateOptions, NameValueCollection configuration);

        protected virtual byte[] GetEmbeddedIcon(string type, string name)
        {
            var fullName = $"{BaseResourcePath}.Icons.{type}s.{name}";

            return GetEmbeddedResource(fullName);
        }

        protected virtual Stream GetEmbeddedBackgroundStream(string name)
        {
            var fullName = $"{BaseResourcePath}.Backgrounds.{name}";

            return GetEmbeddedResourceStream(fullName);
        }

        protected Stream GetEmbeddedResourceStream(string fullName)
        {
            var assembly = Assembly.GetExecutingAssembly();

            // check name ignoring case etc 
            var localName = assembly.GetManifestResourceNames().FirstOrDefault(n => n.Equals(fullName, StringComparison.InvariantCultureIgnoreCase));

            if (localName == null)
            {
                return null;
            }

            Stream stream = assembly.GetManifestResourceStream(localName);

            return stream;

        }

        private byte[] GetEmbeddedResource(string fullName)
        {
            using (Stream stream = GetEmbeddedResourceStream(fullName))
            {
                if (stream == null)
                {
                    return null;
                }
                byte[] ba = new byte[stream.Length];
                stream.Read(ba, 0, ba.Length);
                return ba;
            }
        }

        public virtual Group GetGroup(string groupName, int? groupId = null)
        {
            return _groupsService.List(
                new GroupsListOptions()
                {
                    PageIndex = 0,
                    PageSize = 500,
                    ParentGroupId = GetGroupOrRoot(groupId),
                    IncludeAllSubGroups = false
                }).FirstOrDefault(g => g.Name == HttpUtility.HtmlEncode(groupName));
        }

        public virtual int GetGroupOrRoot(int? groupId = null)
        {
            if (!groupId.HasValue)
            {
                groupId = _groupsService.GetRootGroup().Id;
            }
            else
            {
                Group group = _groupsService.Get(new GroupsGetOptions() { Id = groupId });

                if (group == null || group.HasErrors())
                    throw new TCException($"Invalid Group Specified {groupId}");

            }
            return groupId.Value;
        }

        public virtual void Initialise()
        {
        }

        public virtual bool IsMember(User user, Group group)
        {
            return ListMemberGroups(user).Any(g => g.Id == group.Id);
        }

        public virtual PagedList<Group> ListMemberGroups(User user)
        {
            PagedList<Group> groups;
            
            CacheService.TryGet(CacheKey + user.Id.Value, CacheScope.All ,out groups);

            if (groups == null)
            {
                groups = PopulateMemberGroups(user);
                
                CacheService.Put(CacheKey + user.Id.Value, CacheScope.All, groups , new PutOptions(){ExpiresAfter = TimeSpan.FromMinutes(15) });
            }

            return groups;
        }

        protected abstract PagedList<Group> PopulateMemberGroups(User user);

        public virtual void RemoveUser(User user, Group group)
        {
            _users.RunAsUser("admin", () =>
            {
                if (_groupUserService.List(new GroupUserMembersListOptions() { PageIndex = 0, PageSize = 5000, IncludeRoleMembers = false, GroupId = group.Id, UserId = user.Id.Value }).Any())
                {
                    // Silenty remove the user from the role
                    _process.RunProcessWithDisabledActivityStories(() =>
                    {
                        _process.RunProcessWithDisabledNotifications(() =>
                        {
                            var deletedMember = _groupUserService.Delete(
                                group.Id.Value,
                                new GroupUserMembersDeleteOptions() { UserId = user.Id.Value });

                            if (deletedMember != null && deletedMember.HasErrors())
                            {
                                _eventLog.Write($"Removed userid {user.Id} from group  {group.Name}", new EventLogEntryWriteOptions() { Category = "Connect", EventType = "Information" });
                            }
                        });
                    });
                }
            });
        }
    }
}
