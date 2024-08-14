<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ActivityStorySitePreferenceSelector.ascx.cs" Inherits="Telligent.Evolution.Web.ControlPanel.Utility.ActivityStorySitePreferenceSelector" %>

<asp:DropDownList runat="server" ID="PreferenceSelector">
	<asp:ListItem Value="ControlledOptIn">ControlledOptIn</asp:ListItem>
	<asp:ListItem Value="ControlledOptOut">ControlledOptOut</asp:ListItem>
	<asp:ListItem Value="AlwaysOnVisible">AlwaysOnVisible</asp:ListItem>
	<asp:ListItem Value="AlwaysOnHidden">AlwaysOnHidden</asp:ListItem>
	<asp:ListItem Value="AlwaysOff">AlwaysOff</asp:ListItem>
</asp:DropDownList>
