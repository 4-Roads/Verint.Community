<%@ Page Async="true" EnableViewState="false" Language="C#" AutoEventWireup="true" MasterPageFile="~/modals/modal.Master" %>
<%@ Import Namespace="Telligent.Evolution.Components"%>
<%@ Import Namespace="Telligent.Evolution.Extensibility" %>
<%@ Import Namespace="Telligent.Evolution.Extensibility.Api.Version1" %>

<script runat="server">

    protected override void OnInit(EventArgs e)
    {
      base.OnInit(e);
	  var userLookupTextBox = CSControlUtility.Instance().FindControl(this, "MessageRecipients") as UserLookUpTextBox;
      if (userLookupTextBox != null)
        userLookupTextBox.OnChangeClientFunction = this.ClientID + "_userChanged";
    }

</script>

<asp:Content ContentPlaceHolderID="content" runat="server">

	<script type="text/javascript">
		// <![CDATA[
		var usernameValidation;
		$(function() {
			var selector = '#<%= CSControlUtility.Instance().FindControl(this, "SaveButton").ClientID %>';
			var validation = new Telligent_Validation(selector, { onValidatedFunction: function(isValid, buttonClicked, context) { if (isValid) $(selector).removeClass('disabled'); else $(selector).addClass('disabled'); }, onSuccessfulClickFunction: function(e) { $('.processing', $(selector).parent()).css("visibility", "visible"); $(selector).addClass('disabled');} });

			usernameValidation = validation.AddCustomValidation(
					'requiredrecipients',
					function() {
						return ValidateUserName();
					},
					'<%= JavaScript.Encode(ResourceManager.GetString("RequiredField")) %>',
					'.field-item.message-recipients .field-item-validation', null);

			var f = validation.AddCustomValidation('friendmessage',
				function() {
					return <%= ((Editor) CSControlUtility.Instance().FindControl(this, "Message")).GetContentScript() %>.length > 0 },
					'<%= JavaScript.Encode(ResourceManager.GetString("Conversation_MessageBodyRequired")) %>',
					'.field-item.message-body .field-item-validation', null);
			<%= ((Editor) CSControlUtility.Instance().FindControl(this, "Message")).GetAttachOnChangeScript("f") %>

		});

		function <%= this.ClientID %>_userChanged(lookupTextBox) {
			usernameValidation();
		}

		function ValidateUserName() {
			return <%= CSControlUtility.Instance().FindControl(this, "MessageRecipients").ClientID %>_getSelectedLookUpCount() > 0;
		}
		// ]]>
	</script>

    <TEControl:ConditionalAction runat="server">
        <Actions><TEControl:GoToMessageAction runat="server" /></Actions>
        <Conditions Operator="not"><TEControl:SiteSettingsPropertyValueComparison runat="server" ComparisonProperty="EnableConversations" Operator="issetortrue" /></Conditions>
    </TEControl:ConditionalAction>

    <TEControl:ConditionalAction runat="server">
        <Conditions><TEMessage:ConversationPropertyValueComparison runat="server" ComparisonProperty="ID" Operator="IsSetOrTrue" /></Conditions>
        <Actions><TEControl:SetControlPropertyAction runat="server" ControlId="SaveButton" Property="ResourceName" Value="ReplyMessage_Button" /></Actions>
    </TEControl:ConditionalAction>

    <TEControl:Title runat="server" IncludeSiteName="false">
        <ContentTemplate>
            <TEControl:ConditionalContent runat="server">
                <ContentConditions><TEMessage:ConversationPropertyValueComparison runat="server" ComparisonProperty="ID" Operator="IsSetOrTrue" /></ContentConditions>
                <TrueContentTemplate><TEControl:ResourceControl ResourceName="ReplyToConversation_Title" runat="server" /></TrueContentTemplate>
                <FalseContentTemplate><TEControl:ResourceControl ResourceName="CreateConversation_Title" runat="server" /></FalseContentTemplate>
            </TEControl:ConditionalContent>
        </ContentTemplate>
    </TEControl:Title>

    <TEApi:CreateEditConversationForm runat="server"
         MessageBodyEditorId="Message"
         MessageRecipientsUserLookUpTextBoxId="MessageRecipients"
         SubmitButtonId="SaveButton"
         id="CreateConversationForm"
         ValidationGroup="messageValidationGroup"
    >
        <SuccessActions>
            <TEControl:SetVisibilityAction runat="server" ControlIdsToHide="Message" />
            <TEControl:RefreshPageAction runat="server" WindowNameScript="window.parent.Telligent_Modal.GetWindowOpener(window)" />
        </SuccessActions>
        <FormTemplate>
            <div class="field-list-header"></div>
            <fieldset class="field-list">
                <ul class="field-list">
	                <li class="field-item message-recipients">
		                <label class="field-item-header"><TEControl:ResourceControl runat="server" ResourceName="Recipients" /></label>
		                <span class="field-item-input"><TEApi:UserLookUpTextBox ID="MessageRecipients" Width="300px" LookUpType="AccessingUserCanStartConversation" runat="server" /></span>
		                <span class="field-item-validation" style="display: none;"></span>
		            </li>
	                <li class="field-item message-body">
		                <span class="field-item-input message-body"><TEControl:Editor runat="Server" id="Message" Width="500" Height="180" ContentTypeId='<%#  Apis.Get<IConversationMessages>().ContentTypeId %>' /></span>
	                    <span class="field-item-validation" style="display: none;"></span>
	                </li>
					<li class="field-item submit-form">
						<span class="field-item-input">
							<asp:LinkButton ID="SaveButton" runat="server" CssClass="internal-link submit-form"><span></span><TEControl:ResourceControl runat="server" ResourceName="CreateConversation_Button" /></asp:LinkButton>
							<span class="processing" style="visibility: hidden;"></span>
						</span>
					</li>
	            </ul>
	        </fieldset>
	        <div class="field-list-footer"></div>
		</FormTemplate>
    </TEApi:CreateEditConversationForm>

</asp:Content>