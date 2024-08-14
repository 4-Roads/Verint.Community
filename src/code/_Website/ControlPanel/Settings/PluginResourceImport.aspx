<%@ Page Async="true" Title="" Language="C#" MasterPageFile="~/ControlPanel/Masters/Modal.Master" AutoEventWireup="true" CodeBehind="PluginResourceImport.aspx.cs" Inherits="Telligent.Evolution.Web.ControlPanel.Settings.PluginResourceImport" %>

<asp:Content ID="Content5" ContentPlaceHolderID="bcr" runat="server">
    <script type="text/javascript" src="<%= ResolveUrl("~/ControlPanel/Utility/ManageWidgets/plugins.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/ControlPanel/Utility/ManageWidgets/ResourceImport.js") %>"></script>
    <script type="text/javascript">
        jQuery(function ($) {
            $('fieldset.field-list').resourceImport({
                uploadContext: '<%= FileUpload.UploadContext %>',
                errorMessage: "<cp:resourcecontrol runat="Server" resourcename="CP_ImportResources_Error" />"
            });
        });
    </script>
	<div class="field-list-header"></div>
	<fieldset class="field-list">
		<ul class="field-list">
			<li class="field-item file" id="LocalLinkArea" runat="server">
				<TEControl:FormLabel ID="FormLabel1" LabelForId="File" LabelCssClass="field-item-header" runat="server" ResourceName="CP_ImportResources_File" ResourceFile="ControlPanelResources.xml" />
				<TEControl:ResourceControl ID="ResourceControl5" ResourceName="UploadAttachment_File_Description" runat="server" Tag="Span" CssClass="field-item-description" />
				<span class="field-item-input">
					<TWC:FileUpload ID="FileUpload" AllowedFileTypes="xml" runat="server" OnUploadErrorClientFunction="uploadError" OnUploadingCompleteClientFunction="uploadComplete" OnUploadingStartedClientFunction="uploadStarted" />
				</span>
				<span class="field-item-validation" style="display: none;"></span>
			</li>
			<li class="field-item">
				<span class="field-item-input PanelSaveButton">
					<asp:LinkButton ID="Save" runat="server" CssClass="internal-link upload-file disabled"><span></span><TEControl:ResourceControl ID="ResourceControl2" runat="server" resourcename="CP_ImportResources_Title" ResourceFile="ControlPanelResources.xml" /></asp:LinkButton>
					<span class="internal-link upload-file placeholder disabled" style="visibility: hidden;"><span></span><TEControl:ResourceControl ID="ResourceControl3" runat="server" resourcename="CP_ImportResources_Title" ResourceFile="ControlPanelResources.xml" /></span>
					<span class="processing" style="visibility: hidden;"></span>
				</span>
			</li>
		</ul>
	</fieldset>
	<div class="field-list-footer"></div>

</asp:Content>
