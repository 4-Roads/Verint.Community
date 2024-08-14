<%@ Page Async="true" Language="C#" AutoEventWireup="false" CodeBehind="SiteTermEdit.aspx.cs" Inherits="Telligent.Evolution.ControlPanel.Tools.SiteTermEdit" MasterPageFile="~/ControlPanel/Masters/Modal.master" %>

<asp:Content ID="Content1" ContentPlaceHolderId="bcr" runat="Server">
    <div class="CommonContentArea">
        <div class="CommonFormField">
            <div class="CommonContent">
                <div runat=server id="StatusContainer" visible=false style="padding-bottom:7px">
                    <asp:Label runat=server ID="lblStatus" ForeColor=Red />
                </div>
                <table cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td><div class="CommonFormFieldName"><strong><%= Telligent.Evolution.Components.ResourceManager.GetString("CP_Settings_ManageSiteTerms_ColumnHeader_TokenName", "ControlPanelResources.xml")%>:</strong></div></td>
                        <td><asp:TextBox ID="txtTokenName" runat="server"></asp:TextBox><asp:RequiredFieldValidator runat=server ControlToValidate="txtTokenName">&nbsp;*</asp:RequiredFieldValidator></td>
                    </tr>
                    <tr>
                        <td><div class="CommonFormFieldName"><strong><%= Telligent.Evolution.Components.ResourceManager.GetString("CP_Settings_ManageSiteTerms_ColumnHeader_OriginalTerm", "ControlPanelResources.xml")%>:</strong></div></td>
                        <td><asp:TextBox ID="txtOriginal" runat=server></asp:TextBox><asp:RequiredFieldValidator runat=server ControlToValidate="txtOriginal">&nbsp;*</asp:RequiredFieldValidator></td>
                    </tr>
                    <tr>
                        <td><div class="CommonFormFieldName"><strong><%= Telligent.Evolution.Components.ResourceManager.GetString("CP_Settings_ManageSiteTerms_ColumnHeader_ReplacementTerm", "ControlPanelResources.xml")%>:</strong></div></td>
                        <td><asp:TextBox ID="txtCurrentTerm" runat="server"></asp:TextBox></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div class="CommonContentArea">
        <div class="CommonContent">
            <div class="PanelSaveButton">
			    <CP:ResourceLinkButton id="btnSave" runat="server" cssclass="CommonTextButton" resourcename="Save"></CP:ResourceLinkButton>
		    </div>
	    </div>
    </div>
</asp:Content>
