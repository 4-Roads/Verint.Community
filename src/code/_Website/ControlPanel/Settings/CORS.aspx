<%@ Page Async="true" language="c#" Codebehind="CORS.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Settings.CORS" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>
<%@ Import Namespace="Telligent.Evolution.Components" %>
<%@ Register TagPrefix="MG" TagName="Accounts" Src = "~/ControlPanel/Settings/MGAccounts.ascx" %>

<asp:Content ContentPlaceHolderId="TaskRegion" runat="Server">
    <cp:controlpanelselectednavigation selectednavitem="SettingsSetup" runat="server" />
	<cp:statusmessage id="Status" runat="server" />
	<div class="CommonFormArea">


				<div class="CommonFormFieldName">
                    <CP:ResourceControl runat="server" ResourceName="CP_Settings_SiteContent_EnableCors" />
                </div>
                <div class="CommonFormFieldDescription">
    				<CP:ResourceControl runat="server" ResourceName="CP_Settings_SiteContent_EnableCors_Descr" />
				</div>
				<div class="CommonFormField">
				    <cp:yesnoradiobuttonlist id="EnableCors" runat="server" repeatcolumns="2" />
				</div>


				<div class="CommonFormFieldName">
				    <CP:ResourceControl runat="server" ResourceName="CP_Settings_SiteContent_CorsOrigin" />
                </div>
                <div class="CommonFormFieldDescription">
					<CP:ResourceControl runat="server" ResourceName="CP_Settings_SiteContent_CorsOrigin_Descr" />
				</div>
				<div class="CommonFormField">
				    <asp:TextBox id="CorsOrigin" runat="server" />
				</div>

    <p class="PanelSaveButton">
        <cp:resourcebutton id="SaveButton" runat="server" resourcename="Save" />
    </p>
    </div>


</asp:Content>