<%@ Page Async="true" language="c#" Codebehind="IPAddressTracking.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Settings.IPAddressTracking" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>
<%@ Register TagPrefix="CP" Namespace="Telligent.Evolution.ControlPanel.Controls" Assembly="Telligent.Evolution.Web" %>
<%@ Register TagPrefix="TWC" Namespace="Telligent.Glow" Assembly="Telligent.Glow" %>

<asp:Content ContentPlaceHolderId="TaskRegion" runat="Server">
    <cp:controlpanelselectednavigation selectednavitem="AdvancedConfiguration" runat="server" />
    <div class="<%= Telligent.Evolution.Web.ControlPanel.Components.StaticVariables.LicenseRestrictionClass %>">
	    <CP:statusmessage id="Status" runat="server"></CP:statusmessage>


                    <TABLE cellSpacing="0" cellPadding="2" border="0">
			            <TR>
				            <TD class="CommonFormFieldName">
					            <strong><cp:resourcecontrol runat="server" resourcename="Admin_SiteSettings_IP_Enable" /></strong><br />
					            <cp:resourcecontrol runat="Server" resourcename="Admin_SiteSettings_IP_Enable_Descr" />
					        </TD>
				            <TD class="CommonFormField" nowrap="nowrap">
					            <cp:yesnoradiobuttonlist id="EnableTrackPostsByIP" runat="server" repeatcolumns="2" cssclass="ControlPanelTextInput"></cp:yesnoradiobuttonlist></TD>
			            </TR>
			            <TR>
				            <TD class="CommonFormFieldName">
					            <strong><cp:resourcecontrol runat="server" resourcename="Admin_SiteSettings_IP_AdminOnly" /></strong><br />
					            <cp:resourcecontrol runat="Server" resourcename="Admin_SiteSettings_IP_AdminOnly_Descr" />
					        </TD>
				            <TD class="CommonFormField" nowrap="nowrap">
					            <cp:yesnoradiobuttonlist id="DisplayPostIPAdminsModeratorsOnly" runat="server" repeatcolumns="2" cssclass="ControlPanelTextInput"></cp:yesnoradiobuttonlist></TD>
			            </TR>
		            </TABLE>

	    <p class="PanelSaveButton DetailsFixedWidth">
		    <cp:resourcelinkbutton id="SaveButton" runat="server" resourcename="Save" cssclass="CommonTextButton" />
        </p>
    </div>
</asp:Content>