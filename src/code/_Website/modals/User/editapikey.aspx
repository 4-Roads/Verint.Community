<%@ Page Async="true" EnableViewState="false" Language="C#" AutoEventWireup="true" MasterPageFile="~/modals/modal.Master" %>
<%@ Import Namespace="Telligent.Evolution.Components"%>

<asp:Content ContentPlaceHolderID="content" runat="server">
    <script type="text/javascript" language="javascript">
    	// <![CDATA[

		$(function() {
			var selector = '#<%= CSControlUtility.Instance().FindControl(this, "SaveApiKey").ClientID %>';
			var validation = new Telligent_Validation(selector, { onValidatedFunction: function(isValid, buttonClicked, context) { if (isValid) $(selector).removeClass('disabled'); else $(selector).addClass('disabled'); }, onSuccessfulClickFunction: function(e) { $('.processing', $(selector).parent()).css("visibility", "visible"); $(selector).addClass('disabled');} });

			validation.AddField('#<%= CSControlUtility.Instance().FindControl(this, "ApiKeyName").ClientID %>', { required: true }, '.field-item.api-key-name .field-item-validation', null);

		});

        function CloseModal()
        {
            var opener = window.parent.Telligent_Modal.GetWindowOpener(window);
            opener.location = opener.location;
            opener.Telligent_Modal.Close(null, opener);
        }
        // ]]>
   </script>

    <TEControl:Title runat="server" ResourceName="ApiKeys_EditApiKey" />

    <TEControl:EditApiKeyForm runat="server" NameTextBoxId="ApiKeyName" IsEnabledCheckBoxId="IsEnabled" SaveButtonId="SaveApiKey">
        <SuccessActions>
            <TEControl:ExecuteScriptAction runat="server" Script="CloseModal();" />
        </SuccessActions>
        <FormTemplate>
            <div class="field-list-header"></div>
            <fieldset class="field-list">
                <ul class="field-list">
                    <li class="field-item api-key-name">
                        <TEControl:FormLabel LabelForId="ApiKeyName" LabelCssClass="field-item-header" runat="server" ResourceName="Name" />
                        <span class="field-item-input"><Asp:TextBox runat="server" ID="ApiKeyName" /></span>
                        <span class="field-item-validation" style="display: none;"></span>
                    </li>
                    <li class="field-item">
                        <TEControl:FormLabel LabelForId="IsEnabled" LabelCssClass="field-item-header" runat="server" ResourceName="enabled" />
                        <span class="field-item-input"><TEControl:YesNoCheckBox runat="server" ID="IsEnabled" /></span>
                    </li>
					<li class="field-item submit-form">
					<span class="field-item-input">
						<asp:LinkButton ID="SaveApiKey" runat="server" CssClass="internal-link submit-form"><span></span><TEControl:ResourceControl runat="server" ResourceName="Save" /></asp:LinkButton>
						<span class="processing" style="visibility: hidden;"></span>
					</span>
					</li>
                </ul>
            </fieldset>
            <div class="field-list-footer"></div>
        </FormTemplate>
    </TEControl:EditApiKeyForm>

</asp:Content>