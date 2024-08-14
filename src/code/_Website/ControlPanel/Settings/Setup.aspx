<%@ Page Async="true" language="c#" Codebehind="Setup.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Settings.SettingsSetup" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>
<%@ Import Namespace="Telligent.Evolution.Components" %>
<%@ Register TagPrefix="MG" TagName="Accounts" Src = "~/ControlPanel/Settings/MGAccounts.ascx" %>

<asp:Content ContentPlaceHolderId="TaskRegion" runat="Server">
    <cp:controlpanelselectednavigation selectednavitem="SettingsSetup" runat="server" />
	<cp:statusmessage id="Status" runat="server" />
	<div class="CommonFormArea">

	        <table width="100%">
                <tr>
                    <td colspan="2">
                        <div class="CommonFormSubTitle">
                            <CP:ResourceControl ID="ResourceControl3" runat="server" ResourceName="CP_Settings_SetupSiteName" />
                        </div>
                    </td>
                </tr>
    	        <TR>
		            <TD colspan="2">
		                <div class="CommonFormFieldName">
		                <strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_SiteContent_Name" /></strong>
		                <br />
		                <cp:resourcecontrol runat="server" resourcename="CP_Settings_SiteContent_Name_Descr" />
		                </div>

			            <div class="CommonFormField">
		                <asp:textbox class="ControlPanelTextInput" id="SiteName" runat="server" maxlength="128" columns="55" />
		                </div>
		            </TD>
	            </TR>
	            <TR>
		            <TD colspan="2">
		                <div class="CommonFormFieldName">
		                <strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_SiteContent_Description" /></strong>
                        <br />
			            <cp:resourcecontrol runat="server" resourcename="CP_Settings_SiteContent_Description_Descr" />
			            </div>

			            <div class="CommonFormField">
    			            <asp:textbox class="ControlPanelTextInput" id="SiteDescription" runat="server" columns="55" textmode="Multiline" rows="6" />
    			        </div>
		            </TD>
	            </TR>
                <TR>
					<TD class="CommonFormFieldName">
					    <strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_General_Menu_SiteUrl" /></strong>
					    <br />
						<cp:resourcecontrol runat="Server" resourcename="CP_Settings_General_Menu_SiteUrl_Descr" />
					</TD>
					<TD class="CommonFormField">
						<asp:Label id="SiteUrl" runat="server" />

					</TD>
				</TR>
				<TR>
					<TD class="CommonFormFieldName">
					    <strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_General_Menu_TOS" /></strong>
					    <br />
						<cp:resourcecontrol runat="Server" resourcename="CP_Settings_General_Menu_TOS_Descr" />
                    </TD>
					<TD class="CommonFormField">
						<asp:TextBox id="TermsOfServiceUrl" runat="server" />
						<div style="margin-top: 10px;">
							<asp:PlaceHolder ID="TermsOfServiceLastUpdatedDate" runat="server" />
							<asp:LinkButton ID="TermsOfServiceLastUpdatedDateButton" runat="server" class="inline-button" style="margin-right: 0;"/>
						</div>
					</TD>
				</TR>
                <TR>
					<TD class="CommonFormFieldName">
						<strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_General_Menu_PrivacyPolicy" /></strong>
						<br />
						<cp:resourcecontrol runat="Server" resourcename="CP_Settings_General_Menu_PrivacyPolicy_Descr" />
					</TD>
					<TD class="CommonFormField">
						<asp:TextBox id="PrivacyPolicyUrl" runat="server" />
					</TD>
				</TR>
                <TR>
					<TD class="CommonFormFieldName">
					    <strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_General_Menu_DefaultLanguage" /></strong>
					    <br />
						<cp:resourcecontrol runat="Server" resourcename="CP_Settings_General_Menu_DefaultLanguage_Descr" />
					</TD>
					<TD class="CommonFormField">
						<asp:DropDownList id="DefaultLanguage" runat="server" />

					</TD>
				</TR>
				<TR>
					<TD class="CommonFormFieldName" style="width:350px;">
					    <strong><cp:resourcecontrol runat="server" resourcename="Admin_SiteSettings_TimeZone" /></strong>
					    <br />
						<cp:resourcecontrol runat="Server" resourcename="Admin_SiteSettings_TimeZone_Descr" />
					</TD>
					<TD class="CommonFormField">
						<asp:DropDownList id="Timezone" runat="server" />
					</TD>
				</TR>
				<TR>
					<TD class="CommonFormFieldName">
					    <strong><cp:resourcecontrol runat="server" resourcename="Admin_SiteSettings_DateTime_Date" /></strong>
					    <br />
						<cp:resourcecontrol runat="Server" resourcename="Admin_SiteSettings_DateTime_Date_Descr" />
					</TD>
					<TD class="CommonFormField">
						<cp:dateformatdropdownlist id="DateFormat" runat="server"></cp:dateformatdropdownlist>
					</TD>
				</TR>
				<TR>
					<TD class="CommonFormFieldName">
					    <strong><cp:resourcecontrol runat="server" resourcename="Admin_SiteSettings_DateTime_Time" /></strong>
					    <br />
						<cp:resourcecontrol runat="Server" resourcename="Admin_SiteSettings_DateTime_Time_Descr" />
					</TD>
					<TD class="CommonFormField">
						<cp:timeformatdropdownlist id="TimeFormat" runat="server"></cp:timeformatdropdownlist>
					</TD>
				</TR>
				<TR>
					<TD class="CommonFormFieldName">
						<strong><cp:resourcecontrol runat="server" resourcename="Admin_SiteSettings_ReadForwardedForHeader" /></strong>
						<br />
						<cp:resourcecontrol runat="Server" resourcename="Admin_SiteSettings_ReadForwardedForHeader_Descr" />
					</TD>
					<TD class="CommonFormField">
						<asp:CheckBox id="ReadForwardedHeader" runat="server"></asp:CheckBox>
					</TD>
				</TR>
				<TR>
					<TD class="CommonFormFieldName">
						<strong><cp:resourcecontrol runat="server" resourcename="Admin_SiteSettings_CustomProxyHeader" /></strong>
						<br />
						<cp:resourcecontrol runat="Server" resourcename="Admin_SiteSettings_CustomProxyHeader_Descr" />
					</TD>
					<TD class="CommonFormField">
						<asp:TextBox id="CustomProxyHeader" runat="server"></asp:TextBox>
					</TD>
				</TR>

			</table>


    <p class="PanelSaveButton">
        <cp:resourcebutton id="SaveButton" runat="server" resourcename="Save" />
    </p>
    </div>

    <%--<script type="text/javascript">
        // <![CDATA[
        function DisableFields()
        {
            var enableMailGateway = document.getElementsByName('<%=EnableMailGateway.ClientID.Replace("_", "$") %>');

            if(enableMailGateway.length > 0)
            {
                var yesButton = enableMailGateway[0];
                if(yesButton.checked)
                {
                    HideOrShowControl(document.getElementById('<%=MGSecurityCode.ClientID %>'), true);
                }
                else
                {
                    HideOrShowControl(document.getElementById('<%=MGSecurityCode.ClientID %>'), false);
                }
            }
        }

        function HideOrShowControl(control, visible)
        {
            if (control != null) {
                if (visible)
                    control.disabled = false;
                else
                    control.disabled = true;
            }
        }

        function EnableForSubmit()
        {
            HideOrShowControl(document.getElementById('<%=MGSecurityCode.ClientID %>'), true);
        }

        DisableFields();
        // ]]>
    </script>--%>
</asp:Content>