<%@ Page Async="true" EnableViewState="false" Language="C#" AutoEventWireup="true" MasterPageFile="~/modals/modal.Master" %>
<%@ Register TagPrefix="LEGACY" Namespace="Telligent.Evolution.Web.LegacyControls" Assembly="Telligent.Evolution.Web" %>
<%@ Import Namespace="Telligent.Evolution.Components"%>

<asp:Content ContentPlaceHolderID="content" runat="server">
	<script type="text/javascript">
		// <![CDATA[
		var usernameValidation;
		$(function() {
			var submit = $('#<%= CSControlUtility.Instance().FindControl(this, "Submit").ClientID %>');
			submit.evolutionValidation({
				validateOnLoad: false,
				onValidated: function (isValid, buttonClicked, context) {
					if (isValid)
						submit.removeClass('disabled');
					else
						submit.addClass('disabled');
				},
				onSuccessfulClick: function (e) {
					$('.processing', submit.parent()).css("visibility", "visible");
					submit.addClass('disabled');
				}
			});

			var f = submit.evolutionValidation('addCustomValidation', 'commentBody', function() {
					return <%= ((ITextEditor)CSControlUtility.Instance().FindControl(this, "Body")).GetContentScript() %>.length > 0;
				},
				'<%= ResourceManager.GetString("Wikis_EnterCommentWarning") %>', '.field-item.body .field-item-validation', null
			);
			<%= ((ITextEditor)CSControlUtility.Instance().FindControl(this, "Body")).GetAttachOnChangeScript("f") %>;
		});
		// ]]>
	</script>

	<TEControl:Title ResourceName="Wiki_EditComment_Title" runat="server" IncludeSiteName="false" />

	<LEGACY:CreateEditPageCommentForm runat="server"
		BodyEditorId="Body"
		SubmitButtonId="Submit"
		SubFormIds="PostTags"
		CustomValidatorId=""
		ValidationGroup="AddComment">
		<SuccessActions>
			<TEControl:RefreshPageAction runat="server" WindowNameScript="window.parent.Telligent_Modal.GetWindowOpener(window)" />
		</SuccessActions>
		<FormTemplate>
			<div class="field-list-header"></div>
			<fieldset class="field-list">
				<ul class="field-list">
					<li class="field-item body">
						<span class="field-item-input"><TEControl:Editor Width="90%" Height="250px" ID="Body" runat="server" /></span>
						<span class="field-item-validation" style="display: none;"></span>
					</li>
					<li class="field-item submit-form">
						<span class="field-item-input">
							<asp:LinkButton ID="Submit" runat="server" CssClass="internal-link edit-reply submit-form" ValidationGroup="AddComment"><span></span><TEControl:ResourceControl runat=server ResourceName="Wiki_EditComment_PublishComment" /></asp:LinkButton>
							<span class="processing" style="visibility: hidden;"></span>
						</span>
					</li>
				</ul>
			</fieldset>
			<div class="field-list-footer"></div>
		</FormTemplate>
	</LEGACY:CreateEditPageCommentForm>

</asp:Content>