using System;
using System.Collections.Generic;
using System.IO;
using Telligent.Evolution.Extensibility.Configuration.Version1;
using Telligent.Evolution.Extensibility.Version1;

namespace FourRoads.VerintCommunity.SocialProfileControls.Controls
{
    public abstract class SocialProfileFieldControlPropertyTemplate : IPropertyTemplate, IProfileControlPlugin
    {
        public string[] DataTypes => new string[] { "custom", "string", "url" };

        public abstract string TemplateName { get; }

        public bool SupportsReadOnly => true;

        public PropertyTemplateOption[] Options
        {
            get
            {
                return new PropertyTemplateOption[0]
                {
                };
            }
        }

        public abstract string Name { get; }

        public abstract string Description { get; }

        public void Initialize()
        {
        }

        public abstract string GetValueValidationScript(IPropertyTemplateOptions options, string inputElement, string apiChanged);

        public abstract string GetPlaceholder();

        public void Render(TextWriter writer, IPropertyTemplateOptions options)
        {
            if (options.Property.Editable)
            {
                writer.Write($@"<input type=""text"" columns=""50"" id=""{options.UniqueId}"" value=""{options.Value}"" data-url placeholder=""{GetPlaceholder()}"" class=""empty"">");

                string action = string.Empty;
                
                writer.Write(
                        $@"<script type=""text/javascript"">
                                $(document).ready(function() {{
                                    var api = {(object)options.JsonApi};
                                    var i = $('#{(object)options.UniqueId}');
                                    api.register({{
                                        val: function(val) {{ return (typeof val == 'undefined') ? i.val() : i.val(val); }},
                                        hasValue: function() {{ return i.val() != null; }}
                                    }});

                                    i.on('change', function() {{ api.changed(i.val()); }});

                                    i.on('blur', function() {{ 
                                        {GetValueValidationScript(options, "i", "api.changed(i.val());")}
                                    }});

                                    i.on('keypress', function(e) {{ 
                                        if (e.which == 13) {{
                                            {GetValueValidationScript(options, "i", "api.changed(i.val());")}
                                        }}
                                    }});
                               }});
                          </script>
                ");
            }
            else
            {
                writer.Write($@"<a href=""{options.Value}"">{options.Value}</a>");
            }
        }
    }
}
