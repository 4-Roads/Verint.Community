<%@ Page Async="true" language="c#" Codebehind="EmailSetup.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Settings.EmailSetup" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>
<%@ Import Namespace="Telligent.Evolution.Components" %>
<%@ Register TagPrefix="MG" TagName="Accounts" Src = "~/ControlPanel/Settings/MGAccounts.ascx" %>

<asp:Content ContentPlaceHolderId="TaskRegion" runat="Server">
    <cp:controlpanelselectednavigation selectednavitem="SettingsSetup" runat="server" />
	<cp:statusmessage id="Status" runat="server" />
	<div class="CommonFormArea">


            <asp:Label runat="server" ID="LicenseMessage" Visible="false" ForeColor="Red"><CP:ResourceControl runat="Server" ResourceName="CP_Settings_Email_LimitedLicense" /></asp:Label>
			<TABLE cellSpacing="0" cellPadding="2" border="0">
				<TR>
					<TD class="CommonFormFieldName">
						<strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_Email_Enable" /></strong><br />
						<cp:ResourceControl runat="Server" resourcename="CP_Settings_Email_Enable_Descr" />
					</TD>
					<TD class="CommonFormField">
						<cp:yesnoradiobuttonlist id="EnableEmail" runat="server" repeatcolumns="2"></cp:yesnoradiobuttonlist></TD>
				</TR>
				<TR>
					<TD class="CommonFormFieldName">
						<strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_Email_Digest_Enable" /></strong><br />
						<cp:ResourceControl runat="Server" resourcename="CP_Settings_Email_Digest_Enable_Descr" />
					</TD>
					<TD class="CommonFormField">
						<cp:yesnoradiobuttonlist id="EnableEmailDigest" runat="server" repeatcolumns="2"></cp:yesnoradiobuttonlist></TD>
				</TR>
				<TR>
					<TD class="CommonFormFieldName">
						<strong><cp:resourcecontrol runat="server" resourcename="Admin_SiteSettings_Contact_NotificationFromEmail" /></strong><br />
						<cp:ResourceControl  runat="Server" resourcename="Admin_SiteSettings_Contact_NotificationFromEmail_Descr" />
					</TD>
					<TD class="CommonFormField">
						<asp:textbox id="NotificationFromEmailAddress" runat="server" maxlength="128"></asp:textbox>
                        <TEControl:EmailValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="NotificationFromEmailAddress"><cp:resourcecontrol runat="server" resourcename="Admin_SiteSettings_Contact_InvalidEmail" /></TEControl:EmailValidator>
					</TD>
				</TR>
				<TR>
					<TD class="CommonFormFieldName">
						<strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_Email_MG_EmailDomain" ResourceFile="MGResources.xml" /></strong><br />
						<cp:ResourceControl runat="Server" resourcename="CP_Settings_Email_MG_EmailDomain_Descr" ResourceFile="MGResources.xml" />
					</TD>
					<TD class="CommonFormField">
						<asp:textbox id="MGEmailDomain" runat="server" maxlength="256"></asp:textbox>

						<asp:CustomValidator ID="EmailDomainValidator" runat="server" ControlToValidate="MGEmailDomain"><cp:resourcecontrol ID="Resourcecontrol9" runat="server" resourcename="CP_Settings_Email_MG_EmailDomain_InvalidDomain" ResourceFile="MGResources.xml" /></asp:CustomValidator>
					</TD>
				</TR>
				

			</TABLE>
            <TABLE cellSpacing="0" cellPadding="2" border="0">
	            <TR>
		            <TD class="CommonFormFieldName">
		                <div>
		                <strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_Email_Logo" /></strong>
                        <br />
			            <cp:resourcecontrol runat="server" resourcename="CP_Settings_Email_Logo_Descr" />
		                <br />
                        <asp:FileUpload runat="server" ID="EmailLogoUpload"/>
                        <br />
                        <br />
                        <CP:ResourceButton runat="server" ID="RevertEmailLogo" ResourceName="CP_Settings_Email_Logo_Revert" />
			            </div>
                    </TD>
                    <TD class="CommonFormField">
			            <div>
    			            <asp:Image id="EmailLogo" runat="server" />
    			        </div>
		            </TD>
	            </TR>
            </TABLE>
		   

			<asp:Panel ID="MailGatewayOptions" runat="server">
				<H3 class="CommonSubTitle"><cp:resourcecontrol runat="server" resourcename="CP_Settings_Email_SubTitle_MailGatewayGeneral" /></H3>
				<TABLE cellSpacing="0" cellPadding="0" border="0" width="100%">
					<TR>
						<TD class="CommonFormFieldName">
							<strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_Email_EnableMG" ResourceFile="MGResources.xml" /></strong><br />
							<cp:ResourceControl runat="Server" resourcename="CP_Settings_Email_EnableMG_Descr" ResourceFile="MGResources.xml" />
						</TD>
						<TD class="CommonFormField">
							<cp:yesnoradiobuttonlist id="EnableMailGateway" runat="server" repeatcolumns="2"></cp:yesnoradiobuttonlist></TD>
					</TR>
					<TR>
						<TD class="CommonFormFieldName">
							<strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_Email_MG_MaxAttachmentBytes" ResourceFile="MGResources.xml" /></strong><br />
							<cp:ResourceControl runat="Server" resourcename="CP_Settings_Email_MG_MaxAttachmentBytes_Descr" ResourceFile="MGResources.xml" />
						</TD>
						<TD class="CommonFormField">
							<asp:textbox id="MaxAttachmentBytes" runat="server" maxlength="256" AutoComplete="Off"></asp:textbox>
							<asp:requiredfieldvalidator id="MaxAttachmentBytesValidator" runat="server" controltovalidate="MaxAttachmentBytes"
							font-bold="True" errormessage="*"></asp:requiredfieldvalidator>
						</TD>
					</TR>
					<tr id="FromAddressArea" runat="server">
						<td class="CommonFormFieldName">
							<strong><CP:ResourceControl runat="server" ResourceName="CP_Settings_SetupFromAddressType" /></strong><br />
							<CP:ResourceControl runat="server" ResourceName="CP_Settings_SetupFromAddressTypeDesc" /></td>
						<td class="CommonFormField">
							<asp:DropDownList ID="FromAddressType" runat="server">
							</asp:DropDownList>
						</td>
					</tr>
                    <tr>
                        <td class="CommonFormFieldName">
                            <strong><CP:ResourceControl runat="server" ResourceName="CP_Settings_MailGatewayLogMessageHeaders" /></strong><br />
							<CP:ResourceControl runat="server" ResourceName="CP_Settings_MailGatewayLogMessageHeaders_Desc" /></td>
                        
                        <td class="CommonFormField">
                            <cp:yesnoradiobuttonlist runat="server" repeatcolumns="2" ID="MailGatewayLogMessageHeaders" />
                        </td>
                    </tr>
				</TABLE>
				<H3 class="CommonSubTitle"><cp:resourcecontrol runat="server" resourcename="CP_Settings_Email_MG_Accounts" ResourceFile="MGResources.xml" /></H3>
				<MG:Accounts id="Accounts" runat="server" />
			</asp:Panel>

    <p class="PanelSaveButton">
        <cp:resourcebutton id="SaveButton" runat="server" resourcename="Save" />
    </p>
    </div>

	<%--<script type="text/javascript">
		$(function () {
			var showPassword = $('#change-password'),
				cancelShowPassword = $('#cancel-change-password'),
				password = $('#<%= SmtpServerPassword.ClientID %>'),
				notSet = '<%= JavaScript.Encode(PasswordNotSetValue) %>',
				hide = function () {
					showPassword.show();
					password.hide();
					cancelShowPassword.hide();
					password.val(notSet);
					return false;
				},
				show = function () {
					showPassword.hide();
					password.show();
					cancelShowPassword.show();
					password.val('');
					return false;
				};

			if (password.val() == notSet) {
				hide();
			} else if (password.val() == '') {
				show();
				cancelShowPassword.hide();
			} else {
				var v = password.val();
				show();
				password.val(v);
			}

			showPassword.on('click', show);
			cancelShowPassword.on('click', hide);
		});
	</script>--%>
</asp:Content>
