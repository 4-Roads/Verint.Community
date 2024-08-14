<%@ Page Async="true" language="c#" Codebehind="MGAccountsForm.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Settings.MGAccountsForm" MasterPageFile="~/ControlPanel/Masters/Modal.master" %>
<%@ Import Namespace="Telligent.Evolution.Components" %>
<%@ Register TagPrefix="CP" Namespace="Telligent.Evolution.ControlPanel.Controls" Assembly="Telligent.Evolution.Web" %>

<asp:Content ContentPlaceHolderId="bcr" runat="server">
	<script type="text/javascript">
	// <![CDATA[
        function closeModal()
        {
            window.parent.Telligent_Modal.GetWindowOpener(window).Telligent_Modal.Close(true, window.parent.Telligent_Modal.GetWindowOpener(window));
        }
        function ShowHideApop()
        {
			var check = document.getElementById('<%=AccountTypeList.ClientID %>');
			var apop = document.getElementById('<%=UseApopAuthentication.ClientID %>');
			var text = document.getElementById('<%=UseApopAuthenticationText.ClientID %>');
			var style;
			if(check.value == 'Pop3' || check.value == 'Pop3SSL')
				style = 'inline';
			else
				style = 'none';
			apop.style['display'] = style;
			text.style['display'] = style;
        }
    // ]]>
	</script>
	<DIV class="CommonContentArea" style="position:relative;">
		<DIV class="CommonContent">
		<cp:StatusMessage runat=server ID="Status" />
			<DIV class="CommonFormFieldName">
				<cp:FormLabel id="FormLabel1" runat="server" ControlToLabel="AccountUrl" resourcename="CP_Settings_Email_MG_AccountsForm_AccountUrl" resourcefile="MGResources.xml"></cp:FormLabel>
				&nbsp;<asp:RequiredFieldValidator id="AccountUrlValidator" Runat="server" ControlToValidate="AccountUrl" Display="Dynamic"
					Text="*"></asp:RequiredFieldValidator></DIV>
			<DIV class="CommonFormField">
				<asp:TextBox id="AccountUrl" Runat="server" CssClass="ControlPanelTextInput" MaxLength="256" width="350px"></asp:TextBox></DIV>
			<DIV class="CommonFormFieldName">
				<cp:FormLabel id="Formlabel3" runat="server" resourcename="CP_Settings_Email_MG_AccountsForm_AccountUserName" controltolabel="AccountUserName" resourcefile="MGResources.xml"></cp:FormLabel>
				&nbsp;<asp:RequiredFieldValidator id="AccountUserNameValidator" Runat="server" ControlToValidate="AccountUserName" Display="Dynamic"
					Text="*"></asp:RequiredFieldValidator></DIV>
			<DIV class="CommonFormField">
				<asp:textbox id="AccountUserName" runat="server" cssclass="ControlPanelTextInput" maxlength="256" width="350px"></asp:textbox></DIV>
			<DIV class="CommonFormFieldName">
				<cp:FormLabel id="Formlabel5" runat="server" resourcename="CP_Settings_Email_MG_AccountsForm_AccountPassword" controltolabel="AccountPassword" resourcefile="MGResources.xml"></cp:FormLabel>
				</DIV>
			<DIV class="CommonFormField">
				<asp:textbox id="AccountPassword" runat="server" cssclass="ControlPanelTextInput" maxlength="256" width="350px" TextMode="Password"></asp:textbox></DIV>
			<DIV class="CommonFormFieldName">
				<cp:FormLabel id="Formlabel4" runat="server" resourcename="CP_Settings_Email_MG_AccountsForm_AccountTypeList" controltolabel="AccountTypeList" resourcefile="MGResources.xml"></cp:FormLabel></DIV>
			<DIV class="CommonFormField">
				<asp:dropdownlist id="AccountTypeList" runat="server" onchange="ShowHideApop();"></asp:dropdownlist>
				<asp:CheckBox ID="UseApopAuthentication" runat="server" />
				<CP:FormLabel id="UseApopAuthenticationText" runat="server" ResourceName="CP_Settings_Email_MG_AccountsForm_UseApopAuthentication" ControlToLabel="UseApopAuthentication" ResourceFile="MGResources.xml" />
			</DIV>
			<DIV class="CommonFormFieldName">
				<asp:checkbox id="AccountEnabled" runat="server"></asp:checkbox>
				<cp:FormLabel id="Formlabel2" runat="Server" ControlToLabel="AccountEnabled" resourcename="CP_Settings_Email_MG_AccountsForm_AccountEnabled" resourcefile="MGResources.xml"></cp:FormLabel></DIV>
			<DIV class="CommonFormField PanelSaveButton">
				<cp:ResourceLinkButton id="SaveButton" resourcename="Save" Runat="server" CssClass="CommonTextButton" />
			</DIV>
		</DIV>
	</DIV>

	<script type="text/javascript">
	// <![CDATA[
		ShowHideApop();
    // ]]>
	</script>
</asp:Content>
