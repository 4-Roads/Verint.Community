<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ManageActivityStoryDefaultPreferences.ascx.cs" Inherits="Telligent.Evolution.Web.ControlPanel.Settings.ManageActivityStoryDefaultPreferences" %>
<%@ Register TagPrefix="CP" TagName="ActivityStorySitePreferenceSelector" Src = "~/ControlPanel/Utility/ActivityStorySitePreferenceSelector.ascx" %>
<%@ Register TagPrefix="CP" Namespace="Telligent.Evolution.ControlPanel.Components" Assembly="Telligent.Evolution.Web" %>

<div>
<asp:Repeater runat="server" ID="PreferencesRepeater">
	<HeaderTemplate>
		<table width="100%">
	</HeaderTemplate>
	<SeparatorTemplate>
		<tr>
	</SeparatorTemplate>
	<ItemTemplate>
			<td class="CommonFormFieldName">
				<strong><asp:Label runat="server" ID="Name"></asp:Label></strong> <br />
				<asp:Label runat="server" ID="Description"></asp:Label>
				<asp:HiddenField runat="server" ID="StoryTypeId" />
			</td>
			<td class="CommonFormField">
				<CP:ActivityStorySitePreferenceSelector runat="server" ID="PreferenceSelector" />
			</td>
	</ItemTemplate>
	
	<FooterTemplate>
		</table>
	</FooterTemplate>
</asp:Repeater>
</div>