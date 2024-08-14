using System.Reflection;
using System.Web;

// General Information about an assembly is controlled through the following 
// set of attributes. Change these attribute values to modify the information
// associated with an assembly.
[assembly: AssemblyTitle("FourRoads.VerintCommunity130.AmazonS3")]
[assembly: AssemblyProduct("FourRoads.VerintCommunity.AmazonS3")]
[assembly: AssemblyDescription("Amazon S3 provider for Telligent")]


[assembly: PreApplicationStartMethod(typeof(FourRoads.VerintCommunity.AmazonS3.FilestoreHelperApplicationStart), "Start")]