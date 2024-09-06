using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web;
using FourRoads.VerintCommunity.Mfa.Interfaces;
using Telligent.Evolution.Extensibility;
using Telligent.Evolution.Extensibility.Api.Entities.Version1;
using Telligent.Evolution.Extensibility.Api.Version1;
using Telligent.Evolution.Extensibility.Email.Version1;
using Telligent.Evolution.Extensibility.Version1;
using ISendEmail = Telligent.Evolution.Extensibility.Api.Version2.ISendEmail;
using SendEmailOptions = Telligent.Evolution.Extensibility.Api.Version2.SendEmailOptions;

namespace FourRoads.VerintCommunity.Mfa.Plugins
{
    public class VerifyEmailPlugin : IScriptedEmail, IVerifyEmailProvider
    {
        private IScriptedEmailController _emailController;

        public string Name => "Verify Email";
        public string Description => "Verify Email for MFA Extension";

        public void Initialize()
        {

        }

        public string Template(string code, User user, EmailTarget target, string postTarget = "Web")
        {
            return _emailController.Render(target, new ScriptedEmailRenderOptions
            {
                Context = new Dictionary<string, object>
                {
                    {
                        "User", user
                    },
                    {
                        "Code", code
                    },
                    { 
                        "VerifyCodeUrl",
                        Apis.Get<IUrl>().Absolute($"/verifyemail?code={code}&username={HttpUtility.UrlDecode(user.Username)}")
                    }
                },
                Target = postTarget
            });
        }

        public IDictionary<string, object> GetSampleContext()
        {
            return new Dictionary<string, object>
            {
                {
                    "User", Apis.Get<IUsers>().AccessingUser
                },
                {
                    "Code", "00000"
                },
                {
                    "VerifyCodeUrl",
                    Apis.Get<IUrl>().Absolute($"/verifyemail?code=0000")
                }
            };
        }

        public void SetController(IScriptedEmailController controller)
        {
            _emailController = controller;
        }

        public Guid ScriptedEmailId { get; } = new Guid("20734E3F-7285-41AE-850B-A300663FD40D");

        public IDictionary<string, Type> ContextualData =>
            new Dictionary<string, Type>
            {
                ["User"] = typeof(User),
                ["Code"] = typeof(string)
            };

        public void SendEmail(User user, string code)
        {
            TaskUtility.QueueBackgroundWorkItem( async (cancellationToken) => await Apis.Get<ISendEmail>().SendAsync(new SendEmailOptions()
            {
                ToUserId = user.Id,
                Body = Template(code,user,EmailTarget.Body), 
                Subject = Template(code, user, EmailTarget.Subject),
                Footer = Template(code, user, EmailTarget.Footer),
                Header = Template(code, user, EmailTarget.Header),
            } , cancellationToken));
        }
    }

}