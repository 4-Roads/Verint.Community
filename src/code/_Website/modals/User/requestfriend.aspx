<%@ Page Async="true" EnableViewState="false" Language="C#" AutoEventWireup="true" MasterPageFile="~/modals/modal.Master" %>
<%@ Import Namespace="Telligent.Evolution.Components"%>

<asp:Content ContentPlaceHolderID="content" runat="server">
    <script type="text/C#" runat="server">
        protected bool validateMessage = false;
        protected override void OnInit(EventArgs e)
        {
            var context = CSContext.Current; //This is less elegant, but in 14 this is irrelevant, no need to get fancy for dead code
            validateMessage = context.SiteSettings.RequireFriendRequestMessage == "Yes";
            base.OnInit(e);
        }
    </script>
	<script type="text/javascript">
		// <![CDATA[
		$(function() {
            <% if(validateMessage) { %>
			    var selector = '#<%= CSControlUtility.Instance().FindControl(this, "SendButton").ClientID %>';
			    var validation = new Telligent_Validation(selector, { onValidatedFunction: function(isValid, buttonClicked, context) { if (isValid) $(selector).removeClass('disabled'); else $(selector).addClass('disabled'); }, onSuccessfulClickFunction: function(e) { $('.processing', $(selector).parent()).css("visibility", "visible"); $(selector).addClass('disabled');} });

			    var f = validation.AddCustomValidation('friendmessage',
				    function() {
                        return $('#<%= CSControlUtility.Instance().FindControl(this, "Message").ClientID %>').val().length > 0 },
					    '<%= JavaScript.Encode(ResourceManager.GetString("FriendsRequest_BlankMessageError")) %>',
					    '.field-item.friend-message .field-item-validation', null);
                $('#<%= CSControlUtility.Instance().FindControl(this, "Message").ClientID %>').on('change', f);
            <% } %>
		});
		// ]]>
	</script>

    <TEControl:Title runat="server" IncludeSiteName="false" ResourceName="FriendRequest_Title" />

    <TEControl:RequestFriendshipForm runat="server" MessageTextBoxId="Message" CustomValidatorId="" SubmitButtonId="SendButton">
        <SuccessActions>
            <TEControl:RefreshPageAction runat="server" WindowNameScript="window.parent.Telligent_Modal.GetWindowOpener(window)" />
        </SuccessActions>
        <FormTemplate>
            <div class="field-list-header"></div>
            <fieldset class="field-list">
                <ul class="field-list">
	                <li class="field-item">
		                <label class="field-item-header"><TEControl:ResourceControl runat="server" ResourceName="SendEmail_From" /></label>
		                <span class="field-item-input"><TEControl:UserData UseAccessingUser="true" Property="DisplayName" runat="server" /></span>
	                </li>
	                <li class="field-item">
		                <label class="field-item-header"><TEControl:ResourceControl runat="server" ResourceName="SendEmail_To" id="rc_send_to" /></label>
		                <span class="field-item-input"><TEControl:UserData Property="DisplayName" runat="server" /></span>
	                </li>
	                <li class="field-item friend-message">
		                <span class="field-item-input">
                            <asp:TextBox runat="server" ID="Message" Width="500" Height="120" TextMode="MultiLine" />
		                </span>
		                <span class="field-item-validation" style="display: none; display: block;"></span>
	                </li>
					<li class="field-item">
						<span class="field-item-input">
							<asp:LinkButton ID="SendButton" runat="server" CssClass="internal-link save-form"><span></span><TEControl:ResourceControl runat="server" ResourceName="FriendRequest_Send" /></asp:LinkButton>
							<span class="processing" style="visibility: hidden;"></span>
						</span>
					</li>
                </ul>
            </fieldset>
            <div class="field-list-footer"></div>
        </FormTemplate>
    </TEControl:RequestFriendshipForm>

</asp:Content>