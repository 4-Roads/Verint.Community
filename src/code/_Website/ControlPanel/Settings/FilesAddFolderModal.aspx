<%@ Page Async="true" Language="C#" AutoEventWireup="false" CodeBehind="FilesAddFolderModal.aspx.cs" Inherits="Telligent.EvolutionWeb.ControlPanel.Settings.FilesAddFolderModal" MasterPageFile="~/ControlPanel/Masters/Modal.master" %>
<%@ Import Namespace="Telligent.Evolution.Components" %>

<asp:Content ContentPlaceHolderId="bcr" runat="server">
<script type="text/javascript">
// <![CDATA[
function closeModal()
{
    window.parent.Telligent_Modal.GetWindowOpener(window).Telligent_Modal.Close(true, window.parent.Telligent_Modal.GetWindowOpener(window));
}
// ]]>
</script>
<div class="CommonContentArea">
	<div class="CommonContent">

	<div class="CommonFormFieldName">
		<CP:FormLabel id="tt" runat="Server" ResourceName="CP_Settings_FileStorage_FolderName" ControlToLabel="FolderName" />
	</div>
	<div class="CommonFormField">
		<asp:TextBox runat="server" id="FolderName" maxlength="250" />
		<asp:RegularExpressionValidator ValidationExpression="^[^\.\$\~\|\\\/<>][^<>\|\/]*"
                     ControlToValidate="FolderName" Display="Static"
                     ErrorMessage="<br/>Folder name contains an invalid character." runat="server" />
	</div>
	<div class="CommonFormField PanelSaveButton">
		<CP:ResourceLinkButton id="btnSave" ResourceName="Save" Runat="server"  CssClass="CommonTextButton" />
	</div>

	</div>
</div>
</asp:Content>