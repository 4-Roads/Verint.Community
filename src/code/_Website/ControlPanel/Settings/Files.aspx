<%@ Page Async="true" language="c#" Codebehind="Files.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Settings.FilesPage" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>
<%@ Import Namespace = "Telligent.Evolution.Components" %>
<%@ Import Namespace = "Telligent.Evolution.ControlPanel" %>

<asp:Content ContentPlaceHolderId="TaskRegion" runat="Server">
<CP:ControlPanelSelectedNavigation runat="server" SelectedNavItem="SiteFiles" />
<script>
function refreshPage(res)
{
    refresh();
}
</script>

<asp:literal id="StatusMessage" runat="server" />

<asp:placeholder id="ManageFilesPlaceholder" runat="server">
<div class="PanelSaveButton">
	<CP:Modallink id="NewFolder" runat="Server" resourcename="CP_Settings_FileStorage_NewFolder" height="150"
		width="300" cssclass="CommonTextButton" CallBack="refreshCallback" />
</div>
<div class="CommonListArea">
<asp:literal id="FolderLinks" runat="server" visible="False" /><br />
<table id="CommentListing" cellSpacing="0" cellPadding="0" border="0" width="100%">
<thead>
    <tr>
    <th class="CommonListHeaderLeftMost"><cp:resourcecontrol runat="server" resourcename="CP_Blog_GridCol_FolderName" /></th>
    <th class="CommonListHeader"><cp:resourcecontrol runat="server" resourcename="CP_Blog_GridCol_Size" /></th>
    <th class="CommonListHeader"><cp:resourcecontrol runat="server" resourcename="CP_Blog_GridCol_Actions" /></th>
    </tr>
</thead>
<tr>
	<td class="CommonListCellLeftMost" colspan="3"><cp:href id="NavigateUpFolder" runat="server" text=".." visible="False" /></td>
</tr>
<asp:Repeater runat="Server" id="FileGrid">
<ItemTemplate>
	<tr>
	<td class="CommonListCellLeftMost">
		<asp:literal id="Icon" Runat="server" />
		<cp:href id="Name" Runat="server" />
	</td>
	<td class="CommonListCell"><asp:literal id="Size" Runat="server" /></td>
	<td  class="CommonListCell" nowrap="nowrap"><CP:ResourceLinkButton CommandName="Delete" Runat="server" ID = "DeleteButton" ResourceName="CP_Blog_GridCol_Delete" CssClass="CommonTextButton" />&nbsp;</td>
	</tr>
</ItemTemplate>
<AlternatingItemTemplate>
	<tr class="AltListRow">
	<td class="CommonListCellLeftMost">
		<asp:literal id="Icon" Runat="server" />
		<cp:href id="Name" Runat="server" />
	</td>
	<td class="CommonListCell"><asp:literal id="Size" Runat="server" /></td>
	<td  class="CommonListCell" nowrap="nowrap"><CP:ResourceLinkButton CommandName="Delete" Runat="server" ID = "DeleteButton" ResourceName="CP_Blog_GridCol_Delete" CssClass="CommonTextButton" />&nbsp;</td>
	</tr>
</AlternatingItemTemplate>
</asp:Repeater>
</table>
</div>

<div class"CommonFormArea">
<div class="CommonFormFieldName">
    <strong><CP:FormLabel id="tt" runat="Server" ResourceName="CP_Settings_FileStorage_UploadFile" ControlToLabel="SiteFileUpload" /></strong>
 </div>
 <div class="CommonFormField">
 <table cellpadding="3" cellspacing="0" border="0"><tr><td><TWC:FileUpload ID="SiteFileUpload" runat="server" /></td><td><CP:ResourceLinkButton id="btnUpload" ResourceName="CP_Settings_FileStorage_UploadButton" Runat="server"  CssClass="CommonTextButton" /></td></tr></table>
</div>
</div>
</asp:placeholder>

</asp:Content>