using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;
using FourRoads.Common.VerintCommunity.Plugins.Base;
using FourRoads.VerintCommunity.Installer.Components.Interfaces;
using FourRoads.VerintCommunity.Installer.Components.Utility;
using FourRoads.VerintCommunity.Installer.Plugins;
using Telligent.Evolution.Components.Jobs;
using Telligent.Evolution.Extensibility;
using Telligent.Evolution.Extensibility.Api.Version1;
using Telligent.Evolution.Extensibility.Configuration.Version1;
using Telligent.Evolution.Extensibility.Jobs.Version1;
using Telligent.Evolution.Extensibility.Storage.Version1;
using Telligent.Evolution.Extensibility.UI.Version1;
using Telligent.Evolution.Extensibility.Version1;
using Telligent.Jobs;
using File = System.IO.File;
using IConfigurablePlugin = Telligent.Evolution.Extensibility.Version2.IConfigurablePlugin;
using IPluginConfiguration = Telligent.Evolution.Extensibility.Version2.IPluginConfiguration;

namespace FourRoads.VerintCommunity.Installer
{
    /// <summary>
    /// - How this works-
    /// Theme source files are located in themefiles/
    /// </summary>

    public abstract class FactoryDefaultThemeInstaller : IHttpCallback, IInstallablePlugin, IConfigurablePlugin, IEvolutionJob, IPluginGroup
    {
        #region IPlugin Members

        private bool _enableFilewatcher = false;
        private FileSystemWatcher _fileSystemWatcher;
        //private static readonly object _updateLocker = new object();
        private static readonly object _pageLocker = new object();
        private IHttpCallbackController _callbackController;

        protected abstract string ProjectName { get; }
        protected abstract string BaseResourcePath { get; }
        protected abstract EmbeddedResourcesBase EmbeddedResources { get; }
        protected abstract ICallerPathVistor CallerPath();

        public string Name => ProjectName + " - Theme";

        public string Description => "Installs the default theme for " + ProjectName + ".";

        public void Initialize()
        {
            EnsureMomentoExists();

            if (IsDebugBuild)
            {
                if (_enableFilewatcher)
                {
                    InitializeFilewatcher();
                }

                ScheduleInstall();
            }
        }

        #endregion

        public IEnumerable<Type> Plugins => new[] { typeof(InstallerCore) };

        private void EnumerateResourceFolder(string basePath, string extension, Action<string, string> handleResource)
        {
            basePath = BaseResourcePath + basePath;

            EmbeddedResources.EnumerateResources(
                basePath,
                extension,
                resourceName =>
                {
                    Apis.Get<IUsers>()
                        .RunAsUser(
                            Apis.Get<IUsers>().ServiceUserName,
                            () =>
                            {
                                handleResource(basePath, resourceName);
                            });
                });
        }

        /// <summary>
        /// Set this to false to prevent the installer from installing when version numbers are lower
        /// </summary>
        protected virtual bool SupportAutoInstall => true;

        #region IInstallablePlugin Members

        private ThemeTypeMomento _themeTypeMomento;

        protected ThemeTypeMomento ThemeTypeMomento => _themeTypeMomento;
        protected virtual void EnsureMomentoExists()
        {
            //Store the theme files 
            _themeTypeMomento = new ThemeTypeMomento();

            ParseAllFilesIntoMomento();

            ParseThemeDefsIntoMomento();
        }

        protected virtual void ParseThemeDefsIntoMomento()
        {

            //store the theme definitions
            EnumerateResourceFolder("themefiles.d.", "", (a, b) => _themeTypeMomento.ProcessDefinitions(EmbeddedResources, a, b));
        }

        protected virtual void ParseAllFilesIntoMomento()
        {
            //Create a map of the files in the theme
            EnumerateResourceFolder("themefiles.fd.", "", (a, b) => _themeTypeMomento.ProcessFile(a, b, EmbeddedResources));

        }

        public virtual void Install(Version lastInstalledVersion)
        {
            EnsureMomentoExists();

            if (SupportAutoInstall)
            {
                if (lastInstalledVersion < Version)
                {
                    ScheduleInstall();
                }
            }
        }

        public void Execute(JobData jobData)
        {
            InstallNow();
        }

        protected void ScheduleInstall()
        {
            JobInfo[] jobs = null;
            try
            {
                var runAllJobsLocally = ConfigurationManager.AppSettings["RunJobsInternally"] != null && ConfigurationManager.AppSettings["RunJobsInternally"].ToLower() == "true";

                PeekFilter filter = new PeekFilter()
                {
                    JobNameTypeFilter = GetType().FullName,
                    SortBy = JobSortBy.StateAndName,
                    SortOrder = Telligent.Jobs.SortOrder.Ascending
                };

                if (runAllJobsLocally)
                {
                    Injector.Get<IJobCoreService>().LocalJobStore.Peek(out jobs, 0, 500, filter);
                }
                else
                {
                    Injector.Get<IJobCoreService>().RemoteJobStore.Peek(out jobs, 0, 500, filter);
                }
            }
            catch (Exception)
            {
                // failed to determine if we have an existing job queued
            }

            if (jobs == null || jobs.Count(j => j.State == JobState.Ready) == 0)
            {
                Apis.Get<IJobService>().Schedule(GetType(), DateTime.UtcNow.AddSeconds(15));
            }
        }

        /// <summary>Telligents type IDs for the various theme segments.</summary>

        public virtual void InstallNow()
        {
            EnsureMomentoExists();

            Uninstall();

            #region Install custom theme

            ThemeInstallerVisitor installerVisitor = new ThemeInstallerVisitor();

            _themeTypeMomento.AcceptThemeVistor(installerVisitor);

            Caching.ExpireUICaches();
            Caching.ExpireAllCaches();

            #endregion
        }

        public void Uninstall()
        {

        }

        #endregion

        private bool IsDebugBuild => Diagnostics.IsDebug(GetType().Assembly);

        public Version Version => GetType().Assembly.GetName().Version;

        public void Update(IPluginConfiguration configuration)
        {
            if (IsDebugBuild)
            {
                _enableFilewatcher = configuration.GetBool("filewatcher").HasValue ? configuration.GetBool("filewatcher").Value : false;
            }
        }

        public PropertyGroup[] ConfigurationOptions
        {
            get
            {
                PropertyGroup pg = new PropertyGroup() { Id = "options", LabelText = "Options" };

                var updateStatusProp = new Property()
                {
                    Id = "widgetRefresh",
                    LabelText = "Update Custom Widgets",
                    DescriptionResourceName = "Request a background job to refresh the custom widgets",
                    DataType = "custom",
                    Template = "installer_triggerAction",
                    DefaultValue = ""
                };
                if (_callbackController != null)
                {
                    updateStatusProp.Options.Add("callback", _callbackController.GetUrl());
                }
                updateStatusProp.Options.Add("resturl", "");
                updateStatusProp.Options.Add("data", "refresh:true");
                updateStatusProp.Options.Add("label", "Trigger Refresh");
                pg.Properties.Add(updateStatusProp);

                if (IsDebugBuild)
                {
                    var statusMappingProp = new Property()
                    {
                        Id = "filewatcher",
                        LabelText = "Resource Watcher for Development",
                        DescriptionText = "During development automatically refresh widgets when the are edited",
                        DataType = "Bool",
                        Template = "bool",
                        DefaultValue = bool.TrueString
                    };
                    pg.Properties.Add(statusMappingProp);
                }

                return new[] { pg };
            }
        }


        protected virtual void InitializeFilewatcher()
        {
            _fileSystemWatcher?.Dispose();
            string path = CallerPath().GetPath();

            //Rebase the path
            string assemblyName = GetType().Assembly.GetName().Name;

            path = path.Substring(0, path.IndexOf(assemblyName, StringComparison.Ordinal) + assemblyName.Length + 1);

            if (string.IsNullOrWhiteSpace(path))
            {
                return;
            }

            path = Path.GetDirectoryName(path);
            string resourcePath = path;

            //RTODO: Assumption is that this class is in the root of the project for now
            // Built XML output goes in the Resources folder:
            resourcePath = Path.Combine(resourcePath, "Resources");
            resourcePath = Path.Combine(resourcePath, "themefiles");

            if (!Directory.Exists(resourcePath))
            {
                return;
            }

            _fileSystemWatcher = new FileSystemWatcher();
            _fileSystemWatcher.Path = resourcePath;
            _fileSystemWatcher.NotifyFilter = NotifyFilters.FileName;
            _fileSystemWatcher.Filter = "*.*";
            _fileSystemWatcher.IncludeSubdirectories = true;
            _fileSystemWatcher.EnableRaisingEvents = true;

            _fileSystemWatcher.Renamed += (sender, e) => OnRenamed(sender, e, resourcePath);
            _fileSystemWatcher.Deleted += (sender, args) => OnDeleted(sender, args, resourcePath);
        }

        internal void OnDeleted(object source, FileSystemEventArgs e, string path)
        {


        }

        internal void OnRenamed(object source, FileSystemEventArgs e, string path)
        {
            // Needs to run as the service user otherwise it runs as 
            // any random online user and can then get "file upload" errors..
            var _userService = Apis.Get<IUsers>();

            _userService.RunAsUser(
                _userService.ServiceUserName,
                () =>
                {

                    try
                    {
                        lock (_pageLocker)
                        {
                            // Get the relative path:
                            var themeRelativePath = e.FullPath.Substring(path.Length + 1);

                            FileChangedVisitor fileChange = new FileChangedVisitor(e.FullPath, themeRelativePath);

                            _themeTypeMomento.AcceptThemeVistor(fileChange);

                            Caching.ExpireUICaches();
                            Caching.ExpireAllCaches();
                        }
                    }
                    catch (Exception pe)
                    {
                        Apis.Get<IEventLog>().Write(pe.ToString(), new EventLogEntryWriteOptions() { Category = "4 Roads", EventType = "Error" });
                    }
                });
        }

        public void ProcessRequest(HttpContextBase httpContext)
        {
            ScheduleInstall();
        }

        public void SetController(IHttpCallbackController controller)
        {
            this._callbackController = controller;
        }
    }

    internal class FileChangedVisitor : IThemeVistor
    {
        private string _file;
        private string _fullPath;
        private ICentralizedFileStorageProvider _fileStore;
        public FileChangedVisitor(string fullPath, string file)
        {
            _file = file;
            _fullPath = fullPath;
            _fileStore = CentralizedFileStorage.GetFileStore("themefiles");
        }

        public void Visit(ThemeMomento themeMomento)
        {
            foreach (string fileListsKey in themeMomento.FileLists.Keys)
            {
                if (!_file.StartsWith("fd\\"))
                {
                    if (themeMomento.ThemeDefinitionFile.FileNamePath == _file.Substring(2))
                    {
                        XmlDocument newDocument = new XmlDocument();

                        newDocument.Load(_fullPath);

                        themeMomento.UpdateThemeDefinition(newDocument);

                        using (MemoryStream ms = new MemoryStream())
                        {
                            newDocument.Save(ms);

                            ms.Seek(0, SeekOrigin.Begin);

                            try
                            {
                                _fileStore.AddUpdateFile(
                                    CentralizedFileStorage.MakePath(Path.Combine("d",
                                            Path.GetDirectoryName(themeMomento.ThemeDefinitionFile.FileNamePath))
                                        .Split('\\')), themeMomento.ThemeDefinitionFile.FileName, ms);
                            }
                            catch (Exception e)
                            {
                                Apis.Get<IEventLog>().Write($"Error updating file {themeMomento.ThemeDefinitionFile.FileName} - {e.ToString()}",
                                    new EventLogEntryWriteOptions() { Category = "4 Roads", EventType = "Error" });
                            }
                        }
                    }
                }
                else
                {
                    //Handle all of the files
                    foreach (var file in themeMomento.FileLists[fileListsKey])
                    {
                        if (file.FileNamePath == _file.Substring(3))
                        {
                            using (var stream = File.OpenRead(_fullPath))
                            {
                                try
                                {
                                    _fileStore.AddUpdateFile(CentralizedFileStorage.MakePath(Path.Combine("fd", Path.GetDirectoryName(file.FileNamePath)).Split('\\')), file.FileName, stream);
                                }
                                catch (Exception e)
                                {
                                    Apis.Get<IEventLog>().Write($"Error updating file {file.FileName} - {e.ToString()}",
                                        new EventLogEntryWriteOptions() { Category = "4 Roads", EventType = "Error" });
                                }

                            }
                        }
                    }
                }

            }
        }
    }

    internal class ThemeInstallerVisitor : IThemeVistor
    {
        private ICentralizedFileStorageProvider _fileStore;
        public ThemeInstallerVisitor()
        {
            _fileStore = CentralizedFileStorage.GetFileStore("themefiles");
        }

        public void Visit(ThemeMomento themeMomento)
        {
            foreach (string fileListsKey in themeMomento.FileLists.Keys)
            {
                //Handle all of the files
                foreach (var file in themeMomento.FileLists[fileListsKey])
                {
                    var resourceFile = file.Resources.GetStream(file.ResourceName);

                    try
                    {
                        _fileStore.AddUpdateFile(
                            CentralizedFileStorage.MakePath(Path.Combine("fd", Path.GetDirectoryName(file.FileNamePath))
                                .Split('\\')), file.FileName, resourceFile);
                    }
                    catch (Exception e)
                    {
                        Apis.Get<IEventLog>().Write($"Error updating file {file.FileName} - {e.ToString()}", new EventLogEntryWriteOptions() { Category = "4 Roads", EventType = "Error" });
                    }
                }
            }

            //Handle the theme definition
            using (MemoryStream ms = new MemoryStream())
            {
                themeMomento.ThemeDefinitionDocument.Save(ms);
                ms.Seek(0, SeekOrigin.Begin);
                try
                {
                    _fileStore.AddUpdateFile(CentralizedFileStorage.MakePath(Path.Combine("d", Path.GetDirectoryName(themeMomento.ThemeDefinitionFile.FileNamePath)).Split('\\')), themeMomento.ThemeDefinitionFile.FileName, ms);
                }
                catch (Exception e)
                {
                    Apis.Get<IEventLog>().Write($"Error updating file {themeMomento.ThemeDefinitionFile.FileName} - {e.ToString()}", new EventLogEntryWriteOptions() { Category = "4 Roads", EventType = "Error" });
                }
            }
        }
    }

    public class ThemeResourceFileInformation
    {
        public ThemeResourceFileInformation(string fileName, string resourceName, string fileNamePath, EmbeddedResourcesBase resources)
        {
            FileName = fileName;
            ResourceName = resourceName;
            FileNamePath = fileNamePath;
            Resources = resources;
        }
        public string FileName { get; set; }
        public string ResourceName { get; set; }
        public string FileNamePath { get; set; }
        public EmbeddedResourcesBase Resources { get; set; }
    }

    public class ThemeMomento
    {
        public ThemeMomento(Guid themeTypeId, Guid themeId)
        {
            FileLists = new Dictionary<string, List<ThemeResourceFileInformation>>();
            ThemeId = themeId;
            ThemeTypeId = themeTypeId;
        }

        public void ProcessFile(string realFileNameAndPath, string[] fileParts, string resourceName, EmbeddedResourcesBase resources)
        {
            if (!FileLists.ContainsKey(fileParts[0]))
            {
                FileLists.Add(fileParts[0], new List<ThemeResourceFileInformation>());
            }

            FileLists[fileParts[0]].Add(new ThemeResourceFileInformation(fileParts[fileParts.Length - 1], resourceName, realFileNameAndPath, resources));
        }

        public Guid ThemeTypeId { get; }
        public Guid ThemeId { get; }
        public Dictionary<string, List<ThemeResourceFileInformation>> FileLists { get; }

        public ThemeResourceFileInformation ThemeDefinitionFile { get; private set; }

        public XmlDocument ThemeDefinitionDocument { get; private set; }

        public void UpdateThemeDefinition(XmlDocument document)
        {
            ThemeDefinitionDocument = document;

            ProcessThemeDefinitions();
        }

        public void AddThemeDefinition(EmbeddedResourcesBase resources, string fileNameAndPath, string resourceName)
        {
            ThemeDefinitionFile = new ThemeResourceFileInformation(Path.GetFileName(fileNameAndPath), resourceName, fileNameAndPath, resources);

            ThemeDefinitionDocument = new XmlDocument();

            ThemeDefinitionDocument.LoadXml(resources.GetString(resourceName));

            ProcessThemeDefinitions();
        }

        private void ProcessThemeDefinitions()
        {
            //Now update the file lists in the document to match the files that are held in the dictionary
            //previewImage
            if (FileLists.ContainsKey("preview") && FileLists["preview"].Any())
            {
                ThemeDefinitionDocument.SelectSingleNode("/themes/theme/previewImage").Attributes["name"].Value = Path.GetFileName(FileLists["preview"].FirstOrDefault().FileNamePath);
            }

            void processSection(string parent, string child, string xpath)
            {
                if (FileLists.ContainsKey(parent) && FileLists[parent].Any())
                {
                    var filesNode = ThemeDefinitionDocument.SelectSingleNode(xpath);

                    foreach (var fileInfo in FileLists[parent])
                    {
                        string fileName = Path.GetFileName(fileInfo.FileNamePath);
                        //Does it already exist?
                        var node = ThemeDefinitionDocument.SelectSingleNode($"{xpath}/{child}[@name='{fileName}']");

                        if (node == null)
                        {
                            var fielNode = ThemeDefinitionDocument.CreateElement(child);
                            fielNode.Attributes.Append(ThemeDefinitionDocument.CreateAttribute("name")).Value = fileName;
                            filesNode.AppendChild(fielNode);
                        }
                    }
                }
            }

            processSection("files", "file", "/themes/theme/files");

            processSection("jsfiles", "file", "/themes/theme/javascriptFiles");

            processSection("stylesheetfiles", "file", "/themes/theme/styleFiles");
        }
    }

    public class ThemeListMomento
    {
        public ThemeListMomento()
        {
            ThemeDictionary = new Dictionary<Guid, ThemeMomento>();
        }
        public Dictionary<Guid, ThemeMomento> ThemeDictionary { get; }


        public void ProcessFile(Guid themeTypeId, string fileNameAndPath, string[] fileParts, string resourceName, EmbeddedResourcesBase resources, Guid? themeIdOverrride = null)
        {
            Guid themeId = themeIdOverrride ?? Guid.Parse(fileParts[0]);

            if (!ThemeDictionary.ContainsKey(themeId))
            {
                ThemeDictionary.Add(themeId, new ThemeMomento(themeTypeId, themeId));
            }

            ThemeDictionary[themeId].ProcessFile(fileNameAndPath, fileParts.Skip(1).ToArray(), resourceName, resources);
        }
    }

    public interface IThemeVistor
    {
        void Visit(ThemeMomento themeMomento);
    }

    public class ThemeTypeMomento
    {
        // see https://regex101.com/ for explanation of regex
        // locate theme files and extract path and name 
        // s._05ac58b49cce4ba38714c10e31880ac4.files.grouphome1.jpg
        // path -> s._05ac58b49cce4ba38714c10e31880ac4.files.
        // filename -> grouphome1.jpg
        private Regex _themeFileRegex = new Regex(@"(?<path>^s.+\.(?<type>files|jsfiles|preview|stylesheetfiles)\.)(?<filename>.*\.*?$)");
        public ThemeTypeMomento()
        {
            ThemeTypeThemeMomento = new Dictionary<Guid, ThemeListMomento>();
        }

        private Dictionary<string, Guid> _themeSegmentIds = new Dictionary<string, Guid>()
        {
            {"a", ThemeTypes.ArticleCollection},
            {"g", ThemeTypes.Group},
            {"b", ThemeTypes.Weblog},
            {"s", ThemeTypes.Site},
            {"u", ThemeTypes.User}
        };

        private Dictionary<Guid, ThemeListMomento> ThemeTypeThemeMomento { get; }

        public void AcceptThemeVistor(IThemeVistor themeVistor)
        {
            foreach (Guid themTypeId in ThemeTypeThemeMomento.Keys)
            {
                foreach (Guid themeId in ThemeTypeThemeMomento[themTypeId].ThemeDictionary.Keys)
                {
                    var themeMomento = ThemeTypeThemeMomento[themTypeId].ThemeDictionary[themeId];
                    Apis.Get<IEventLog>().Write($"Installing theme '{themeId}'", new EventLogEntryWriteOptions() { Category = "4 Roads" });
                    themeVistor.Visit(themeMomento);
                }
            }
        }

        public void ProcessDefinitions(EmbeddedResourcesBase resources, string basePath, string resourceName, Guid? themeIdOverride = null)
        {
            string fileNameAndPath = GetFileNameFromResourceName(resourceName.Replace(basePath, ""));

            string[] fileParts = fileNameAndPath.Split('\\');

            if (fileParts.Length > 0)
            {
                Guid themeType = Guid.Parse(fileParts[0]);
                Guid themeId = themeIdOverride ?? Guid.Parse(fileParts[1].Replace(Path.GetExtension(fileParts[1]), ""));

                ThemeTypeThemeMomento[themeType].ThemeDictionary[themeId].AddThemeDefinition(resources, fileNameAndPath, resourceName);
            }
        }

        public void ProcessFile(string basePath, string resourceName, EmbeddedResourcesBase resources)
        {
            ProcessFile(basePath, resourceName, resources, null, null);
        }

        public void ProcessFile(string basePath, string resourceName, EmbeddedResourcesBase resources, Guid? themeIdOverrride, string pathNameToReplace)
        {
            string fileNameAndPath = GetFileNameFromResourceName(resourceName.Replace(basePath, ""));

            if (themeIdOverrride.HasValue && !string.IsNullOrWhiteSpace(pathNameToReplace))
            {
                fileNameAndPath = fileNameAndPath.Replace(pathNameToReplace, themeIdOverrride.Value.ToString("N").ToLower());
            }

            string[] fileParts = fileNameAndPath.Split('\\');

            if (fileParts.Length > 0)
            {
                if (_themeSegmentIds.ContainsKey(fileParts[0]))
                {
                    Guid themeTypeId = _themeSegmentIds[fileParts[0]];

                    if (!ThemeTypeThemeMomento.ContainsKey(themeTypeId))
                    {
                        ThemeTypeThemeMomento.Add(themeTypeId, new ThemeListMomento());
                    }

                    ThemeTypeThemeMomento[themeTypeId].ProcessFile(themeTypeId, fileNameAndPath, fileParts.Skip(1).ToArray(), resourceName, resources, themeIdOverrride);
                }
            }
        }

        private string GetFileNameFromResourceName(string resourceName)
        {

            // check if a regular theme file and if so extract the filename and pass over untouched
            // convert the path to replace . with \
            MatchCollection matches = _themeFileRegex.Matches(resourceName);
            if (matches.Count == 1 && matches[0].Groups["path"].Success && matches[0].Groups["type"].Success && matches[0].Groups["filename"].Success)
            {
                // filename replace _. for . is for vetsurgeon legacy filenames
                var filename = matches[0].Groups["filename"].Value.Replace("_.", ".");
                var path = matches[0].Groups["path"].Value.Replace(".", "\\").Replace("_", "");

                return path + filename;
            }

            // other files so parse char by char to replace . and escaped _ chars 
            // this will remove any single _ from filenames etc 
            StringBuilder sb = new StringBuilder();

            int numberOfDots = resourceName.Count(c => c == '.');
            bool escapedNext = false;


            for (int i = 0; i < resourceName.Length; i++)
            {
                bool isDot = resourceName[i] == '.';

                if (isDot)
                {
                    numberOfDots--;
                }

                if (!escapedNext && resourceName[i] == '_')
                {
                    escapedNext = true;
                    continue;
                }

                if (escapedNext)
                {
                    sb.Append(resourceName[i]);
                }
                else
                {
                    if (isDot && numberOfDots > 0)
                    {
                        sb.Append('\\');
                    }
                    else
                    {
                        sb.Append(resourceName[i]);
                    }
                }

                escapedNext = false;
            }

            return sb.ToString();
        }
    }
}
