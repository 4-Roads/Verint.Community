<%@ Page Async="true" language="c#" Codebehind="SettingsCommand.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Settings.SettingsCommandPage" MasterPageFile="~/ControlPanel/Masters/Modal.master" %>

<asp:Content ContentPlaceHolderId="bcr" runat="server">
	<DIV class="CommonContentArea">
		<DIV class="CommonContent">
			<asp:Literal id="CommandMessage" Runat="server"></asp:Literal>
			<P>
				<DIV align="center">
					<asp:Button id="OK_Button" Runat="server"></asp:Button><INPUT id="Cancel_Button" onclick="window.parent.Telligent_Modal.GetWindowOpener(window).Telligent_Modal.Close(false, window.parent.Telligent_Modal.GetWindowOpener(window)); return false;" type="button"
						value="Cancel" runat="server">
				</DIV>
		</DIV>
	</DIV>
</asp:Content>