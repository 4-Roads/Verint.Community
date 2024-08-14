<%@ Page Async="true" language="c#" Codebehind="MassEmailingAdmin.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Tools.MassEmailingAdmin" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>

<asp:Content ContentPlaceHolderId="TaskRegion" runat="Server">
	<CP:ControlPanelSelectedNavigation runat="server" SelectedNavItem="ToolsEmailAdmin" />
	<cp:statusmessage id="Status" runat="server"></cp:statusmessage>
	<DIV class="FixedWidthContainer">
		<div class="CommonFormFieldName">
					<strong><cp:resourcelabel id="Resourcelabel1" runat="server" resourcename="MassEmailing_Recipients" name="Resourcelabel1"></cp:resourcelabel></strong>
		</div>
		<div class="CommonFormField">
					<cp:roledropdownlist id="RoleList" runat="server"></cp:roledropdownlist>
		</DIV>

		<div class="CommonFormFieldName">
					<strong><cp:resourcelabel id="Resourcelabel2" runat="server" resourcename="MassEmailing_Subject" name="Resourcelabel2"></cp:resourcelabel></strong>
		</DIV>
		<div class="CommonFormField">
					<asp:textbox id="Subject" runat="server" columns="80" maxlength="255"></asp:textbox>
		</DIV>

		<div class="CommonFormFieldName">
				<strong><cp:resourcelabel id="Resourcelabel3" runat="server" resourcename="MassEmailing_Message" name="Resourcelabel3"></cp:resourcelabel></strong>
	    </DIV>
	    <div class="CommonFormField">
				<TEControl:editor id="EditorMessage" runat="server" columns="110" height="250" width="500px" />
		</DIV>
	</DIV>
	<P class="PanelSaveButton DetailsFixedWidth">
		<asp:LinkButton id="SendButton" runat="server" CssClass="CommonTextButton"></asp:LinkButton></P>
</asp:Content>
