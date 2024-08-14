<%@ Page Async="true" language="c#" Codebehind="UserFiles.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Settings.UserFiles" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>

<asp:Content ContentPlaceHolderId="TaskRegion" runat="Server">
    <CP:ControlPanelSelectedNavigation runat="server" SelectedNavItem="UserFiles" />

	<CP:StatusMessage runat="server" id="Status" visible="false" />

	<div class="FixedWidthContainer">
		<table cellpadding="0" cellspacing="0" border="0">
		    <tr>
		        <td class="CommonFormFieldName">
			        <strong><cp:resourcecontrol runat="Server" resourcename="CP_UserFiles_Enable" /></strong><br />
			        <cp:resourcecontrol runat="Server" resourcename="CP_UserFiles_Enable_Help" />
		        </td>
		        <td class="CommonFormField">
		            <CP:YesNoRadioButtonList runat="server" ID="EnableUserFiles" RepeatColumns="2" />
		        </td>
		    </tr>
    	</table>
	</div>

	<p class="PanelSaveButton DetailsFixedWidth">
		<cp:ResourceLinkButton id="SaveButton" runat="Server" CssClass="CommonTextButton" ResourceName="Save" />
	</p>

</asp:Content>