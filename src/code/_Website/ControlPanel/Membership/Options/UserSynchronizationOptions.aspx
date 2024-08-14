<%@ Page Async="true" language="c#" Codebehind="UserSynchronizationOptions.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Membership.UserSynchronizationOptions" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>

<asp:Content ContentPlaceHolderId="TaskRegion" runat="Server">
    <CP:ControlPanelSelectedNavigation runat="server" SelectedNavItem="SecuritySettings" />
	<CP:statusmessage id="formStatus" runat="server"></CP:statusmessage>

    <div class="FixedWidthContainer">
		<TABLE cellSpacing="0" cellPadding="3" border="0">
			<tr>
				<td colspan="2">
					<p>
						<cp:resourcecontrol runat="Server" resourcename="CP_Membership_Settings_Cookie_Sychronization_Description" />
					</p>
				</td>
			</tr>

			<TR>
				<TD class="CommonFormFieldName">
					<strong><cp:resourcecontrol runat="server" resourcename="CP_Membership_Settings_Cookie_Sychronization_Enabled" /></strong>
                </TD>
				<TD class="CommonFormField" noWrap>
					<cp:yesnoradiobuttonlist id="EnableSynchronizationCookie" runat="server" repeatcolumns="2" ></cp:yesnoradiobuttonlist></TD>
			</TR>
			<TR>
				<TD class="CommonFormFieldName">
					<strong><cp:resourcecontrol runat="server" resourcename="CP_Membership_Settings_Cookie_Sychronization_CookieDomain" /></strong>
					<br />
					<cp:resourcecontrol runat="server" resourcename="CP_Membership_Settings_Cookie_Sychronization_CookieDomain_Description" />
				</TD>
				<TD class="CommonFormField">
					<asp:textbox id="SynchronizationCookieDomain" runat="server"  maxlength="100"></asp:textbox>
					<asp:RegularExpressionValidator runat="server" ControlToValidate="SynchronizationCookieDomain" ErrorMessage="*" Display="Dynamic" ValidationExpression="^(?:\.?[\w\-]+)+$" />
				</TD>
			</TR>
			<TR>
				<TD class="CommonFormFieldName">
					<strong><cp:resourcecontrol runat="server" resourcename="CP_Membership_Settings_Cookie_Sychronization_CookieName" /></strong>
					<br />
					<cp:resourcecontrol runat="Server" resourcename="CP_Membership_Settings_Cookie_Sychronization_CookieName_Description" />
				</TD>
				<TD class="CommonFormField">
					<asp:textbox id="SynchronizationCookieName" runat="server"  maxlength="64"></asp:textbox>
					<asp:requiredfieldvalidator runat="server" controltovalidate="SynchronizationCookieName"
						font-bold="True" errormessage="*"></asp:requiredfieldvalidator></TD>
			</TR>
		</TABLE>
	</div>
	<p class="PanelSaveButton DetailsFixedWidth">
			<cp:ResourceButton id="btnSave" runat="server" resourcename="Save" />
	</p>
</asp:Content>