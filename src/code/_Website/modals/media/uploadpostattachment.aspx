<%@ Page Async="true" EnableViewState="false" Language="C#" AutoEventWireup="true" MasterPageFile="~/modals/modal.Master" %>
<%@ Register TagPrefix="TEMedia" Namespace="Telligent.Evolution.MediaGalleries.Internal.Legacy.Controls.Forms" Assembly="Telligent.Evolution.MediaGalleries" %>

<asp:Content ContentPlaceHolderID="content" runat="server">

	<TEControl:Title runat="server" ResourceName="MediaGalleries_Title_UploadFile" ResourceFile="MediaGallery.xml" />

	<TEMedia:UploadPostAttachmentForm id="AttachmentForm" runat="server"
		ErrorTextId="Error"
		FileUploadId="FileUpload"
		LinkToUrlRadioButtonId="LinkToUrl"
		UploadFileRadioButtonId="UploadFile"
		SaveButtonId="Save"
		UrlTextBoxId="Url"
		ControlIdsToHideWhenLocalAttachmentsNotAllowed="LocalLinkArea"
		ControlIdsToHideWhenRemoteAttachmentsNotAllowed="RemoteLinkArea"
		>
		<FormTemplate>
			<TEControl:WrappedLiteral runat="server" ID="Error" Tag="Div" CssClass="message error" />
			<div class="field-list-header"></div>
			<fieldset class="field-list">
				<legend class="field-list-description"><span>
					<TEControl:ValueSelectedContent runat="server">
						<ValueTemplate><TEControl:ControlData runat="server" ControlId="AttachmentForm" Property="AllowLocalAttachment" /><TEControl:ControlData runat="server" ControlId="AttachmentForm" Property="AllowRemoteAttachment" /></ValueTemplate>
						<Content>
							<TEControl:ValueContent Value="TrueTrue" runat="server"><TEControl:ResourceControl runat="server" ResourceName="UploadAttachment_Description" /></TEControl:ValueContent>
							<TEControl:ValueContent Value="TrueFalse" runat="server"><TEControl:ResourceControl runat="server" ResourceName="UploadAttachment_Description_FileOnly" /></TEControl:ValueContent>
							<TEControl:ValueContent Value="FalseTrue" runat="server"><TEControl:ResourceControl runat="server" ResourceName="UploadAttachment_Description_UrlOnly" /></TEControl:ValueContent>
							<TEControl:DefaultContent runat="server"><TEControl:ResourceControl runat="server" ResourceName="UploadAttachment_Description_NoAccess" /></TEControl:DefaultContent>
						</Content>
					</TEControl:ValueSelectedContent>
				</span></legend>
				<ul class="field-list">
					<li class="field-item file" id="LocalLinkArea" runat="server">
						<TEControl:FormLabel LabelForId="File" LabelCssClass="field-item-header" runat="server" ResourceName="UploadAttachment_File" />
						<TEControl:ResourceControl ResourceName="UploadAttachment_File_Description" runat="server" Tag="Span" CssClass="field-item-description" />
						<span class="field-item-input">
							<asp:RadioButton ID="UploadFile" runat="server" GroupName="UploadOption" Checked="True" />
							<TWC:FileUpload ID="FileUpload" runat="server" OnUploadErrorClientFunction="uploadError" OnUploadingCompleteClientFunction="uploadComplete" OnUploadingStartedClientFunction="uploadStarted" />
						</span>
						<span class="field-item-validation" style="display: none;"></span>
					</li>
					<li class="field-item link" id="RemoteLinkArea" runat="server">
						<TEControl:FormLabel LabelForId="Url" LabelCssClass="field-item-header" runat="server" ResourceName="UploadAttachment_Url" />
						<TEControl:ResourceControl ResourceName="UploadAttachment_Url_Description" runat="server" Tag="Span" CssClass="field-item-description" />
						<span class="field-item-input">
							<asp:RadioButton ID="LinkToUrl" Runat="server" GroupName="UploadOption" />
							<asp:TextBox ID="Url" Runat="server" Columns="40" />
						</span>
						<span class="field-item-validation" style="display: none;"></span>
					</li>
					<li class="field-item upload-file">
						<span class="field-item-input">
							<asp:LinkButton ID="Save" OnClientClick="return validateForm(true);" runat="server" CssClass="internal-link upload-file disabled"><span></span><TEControl:ResourceControl runat="server" ResourceName="Save" /></asp:LinkButton>
							<span class="internal-link upload-file placeholder disabled" style="visibility: hidden;"><span></span><TEControl:ResourceControl runat="server" ResourceName="Save" /></span>
							<span class="processing" style="visibility: hidden;"></span>
						</span>
					</li>
				</ul>
			</fieldset>
			<div class="field-list-footer"></div>
		</FormTemplate>
	</TEMedia:UploadPostAttachmentForm>

<script type="text/javascript">
// <![CDATA[
var isUploaded = false;
var saveButton;
var chkUpload;
var chkLink;
var validationTimer;
var urlBox;

$(function (e) {
	saveButton = $('#<%= CSControlUtility.Instance().FindControl(this, "Save").ClientID %>');
	chkUpload = $('#<%= CSControlUtility.Instance().FindControl(this, "UploadFile").ClientID %>');
	chkLink = $('#<%= CSControlUtility.Instance().FindControl(this, "LinkToUrl").ClientID %>');
	urlBox = $('#<%= CSControlUtility.Instance().FindControl(this, "Url").ClientID %>');

	if (urlBox)
		urlBox.on('blur', function(e) {
				if (validationTimer)
					window.clearTimeout(validationTimer);
				validateForm();
			})
			.on('keyup', function(e) {
				if (validationTimer)
					window.clearTimeout(validationTimer);
				validationTimer = window.setTimeout(function() { validateForm(); }, 499);
			});

	if (urlBox && $('input:radio:checked').val() == "UploadFile") {
		urlBox.attr("disabled", "disabled");
	}
	if (chkUpload) chkUpload.on('click', function(e) { chkUploadClick(); });
	if (chkLink) chkLink.on('click', function(e) { chkLinkClick(); });

});

function uploadError() {
	isUploaded = false;
	$('.field-item.file .field-item-validation').html('<%= Telligent.Evolution.Components.JavaScript.Encode(Telligent.Evolution.Components.ResourceManager.GetString("UploadAttachment_ErrorUploadingFile")) %>').show();
}

function uploadComplete() {
	isUploaded = true;
	if (chkLink) chkLink.prop("checked", false);
	chkUpload.prop("checked", true);

	$('.internal-link.upload-file').show();
	$('.internal-link.upload-file.placeholder').hide();

	validateForm();
}

function uploadStarted() {
	if (chkLink) chkLink.prop("checked", false);
	chkUpload.prop("checked", true);

	$('.internal-link.upload-file').hide();
	$('.internal-link.upload-file.placeholder').attr('style', 'visible');
	$('.internal-link.upload-file.placeholder').show();
}

function validateForm(submit)
{
	var isValid = false;
	if (validationTimer)
	    window.clearTimeout(validationTimer);

    var isLocal = $('input:radio:checked').val() == "UploadFile" || ($('input:radio').length == 0 && <%= CSControlUtility.Instance().FindControl(this, "FileUpload").Visible ? "true" : "false" %>);
    var isRemote = $('input:radio:checked').val() == "LinkToUrl" || urlBox.length > 0;

	if (isLocal) {
		$('.field-item.link .field-item-validation').hide();
		if (isUploaded) {
			isValid = true;
			$('.field-item.file .field-item-validation').hide();
		}
		else
			$('.field-item.file .field-item-validation').html('<%= Telligent.Evolution.Components.JavaScript.Encode(Telligent.Evolution.Components.ResourceManager.GetString("UploadAttachment_MissingFile")) %>').show();
	}
	else if (isRemote) {
		$('.field-item.file .field-item-validation').hide();
		if (urlBox.val().length > 0 && urlBox.val().toLowerCase().indexOf('http') == 0) {
			isValid = true;
			$('.field-item.link .field-item-validation').hide();
		} else {
			$('.field-item.link .field-item-validation').html('<%= Telligent.Evolution.Components.JavaScript.Encode(Telligent.Evolution.Components.ResourceManager.GetString("UploadAttachment_MissingURL")) %>').show();
		}
	}
	if (isValid) {
		if (submit) {
			saveButton.addClass('disabled disabled__internal-link disabled__internal-link__upload-file disabled__upload-file');
			$('.processing', saveButton.parent()).css("visibility", "visible");
			return true;
		}
		saveButton.removeClass('disabled disabled__internal-link disabled__internal-link__upload-file disabled__upload-file');
	}
	else {
		saveButton.addClass('disabled disabled__internal-link disabled__internal-link__upload-file disabled__upload-file');
		return false;
	}
}

function chkUploadClick() {
	urlBox.attr("disabled", "disabled");
	$('.field-item.link .field-item-validation').hide();
}

function chkLinkClick() {
	urlBox.removeAttr("disabled");
	$('.field-item.file .field-item-validation').hide();
}

// ]]>
</script>

</asp:Content>
