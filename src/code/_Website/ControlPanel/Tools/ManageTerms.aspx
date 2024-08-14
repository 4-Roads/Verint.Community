<%@ Page Async="true" Language="C#" AutoEventWireup="false" CodeBehind="ManageTerms.aspx.cs" Inherits="Telligent.Evolution.ControlPanel.Tools.ManageTerms"  MasterPageFile="~/ControlPanel/Masters/Embedded.master"  %>

<%@ Import Namespace="Telligent.Evolution.Components" %>

<asp:Content ID="Content2" ContentPlaceHolderId="TaskRegion" runat="Server">
    <script type="text/javascript">
        // <![CDATA[
        function DeleteToken(id) {
            if (window.confirm('<CP:ResourceControl ResourceName="CP_Settings_ManageSiteTerms_DeleteSingleWarning" runat="server" Encoding="JavaScript" />')) {
                ManageTermsPage.DeleteToken(id, ResetCallback);
            }
        }
        function ResetToken(id) {
            if (window.confirm('<CP:ResourceControl ResourceName="CP_Settings_ManageSiteTerms_ResetSingleWarning" runat="server" Encoding="JavaScript" />')) {
                ManageTermsPage.ResetToken(id, ResetCallback);
            }
        }
        function ResetAllTokens(language) {
            if (window.confirm('<CP:ResourceControl ResourceName="CP_Settings_ManageSiteTerms_ResetAllWarning" runat="server" Encoding="JavaScript" />')) {
                ManageTermsPage.ResetAllTokens(language, ResetCallback);
            }
        }
        function warnAboutImport() {
            return window.confirm('<CP:ResourceControl ResourceName="CP_Settings_ManageSiteTerms_ImportInformation" runat="server" Encoding="JavaScript" />');
        }

        function ResetCallback(result) {
            if (result.error) {
                alert(result.error);
            }
            else {
                refresh();
            }
        }
        function closeModal(shouldRefresh) {
            if (shouldRefresh == 'true') {
                refresh();
            }
        }
        // ]]>
    </script>
    <CP:ControlPanelSelectedNavigation ID="ControlPanelSelectedNavigation1" runat="server" SelectedNavItem="SiteTerms" />
	<div class="CommonDescription">
		<CP:ResourceControl runat="Server" ResourceName="CP_Settings_ManageSiteTerms_SubTitle"></CP:ResourceControl>
	</div>
    <div class="CommonListArea">
        <div style="padding-bottom:5px">
            <strong><CP:ResourceLabel runat="server" ResourceName="CP_Settings_ManageSiteTerms_Languages"></CP:ResourceLabel></strong>
        </div>
        <table border=0 cellpadding=0 cellspacing=0 width=100%>
            <tr>
                <td><asp:DropDownList id="LanguageDropDownList" runat="server" AutoPostBack=true />&nbsp;&nbsp;<input type=button runat="server" id="btnResetAll"/></td>
                <td align=right><div runat=server id="ImportContainer"><CP:ResourceControl runat="server" ResourceName="CP_Settings_ManageSiteTerms_Import_All_From"></CP:ResourceControl> <asp:DropDownList id="ImportAllFromDropDownList" runat="server"><asp:ListItem Value="en-US">English</asp:ListItem></asp:DropDownList>&nbsp;&nbsp;<CP:ResourceButton runat="server" id="btnImportAll" ResourceName="CP_Settings_ManageSiteTerms_ImportButton" /></div></td>
            </tr>
        </table>
        <div style="padding-top:10px; padding-bottom:10px" runat=server id="StatusContainer" visible=false>
            <CP:StatusMessage runat="server" id="Status"/>
        </div>
	    <asp:Repeater Runat="server" id="TermList">
            <HeaderTemplate>
                <div class="CommonListArea">
	                <table id="Listing" cellSpacing="0" cellPadding="0" border="0" width=100%>
		                <thead>
			                <tr>
				                <th class="CommonListHeaderLeftMost">
					                <%# ResourceManager.GetString("CP_Settings_ManageSiteTerms_ColumnHeader_TokenName", "ControlPanelResources.xml")%>
				                </th>
				                <th class="CommonListHeader">
					                <%# ResourceManager.GetString("CP_Settings_ManageSiteTerms_ColumnHeader_OriginalTerm", "ControlPanelResources.xml")%>
				                </th>
				                <th class="CommonListHeader">
					                <%# ResourceManager.GetString("CP_Settings_ManageSiteTerms_ColumnHeader_ReplacementTerm", "ControlPanelResources.xml")%>
				                </th>
				                <th class="CommonListHeader">
					                &nbsp;
				                </th>
			                </tr>
		                </thead>
            </HeaderTemplate>
            <ItemTemplate>
                        <tr>
                            <td class="CommonListCell">
                                <%# Eval("Token") %>&nbsp;
                            </td>
                            <td class="CommonListCell">
                                <%# Eval("DefaultValue")%>&nbsp;
                            </td>
                            <td class="CommonListCell">
                                <%# GetReplacementOrNA((SiteTerm)Container.DataItem)%>&nbsp;
                            </td>
                            <td class="CommonListCell">
				                <input type="button" value="<%# ResourceManager.GetString("CP_Settings_ManageSiteTerms_EditButton", "ControlPanelResources.xml") %>" onclick="Telligent_Modal.Open('<%# Globals.FullPath("~/controlpanel/tools/SiteTermEdit.aspx") %>?ID=<%# Eval("ID") %>&token=<%# Globals.UrlEncode((string)Eval("Token")) %>&language=<%# Globals.UrlEncode((string)Eval("Language")) %>&defaultValue=<%# Globals.UrlEncode((string)Eval("DefaultValue")) %>&currentValue=<%# Globals.UrlEncode((string)Eval("CurrentValue")) %>&isDefault=<%# Eval("IsDefault") %>', 350, 165, closeModal);" />&nbsp;
				                <input type="button" value="<%# ResourceManager.GetString("CP_Settings_ManageSiteTerms_ResetButton", "ControlPanelResources.xml") %>" onclick="ResetToken('<%# Eval("ID") %>');" />&nbsp;
				                <input type="button" value="<%# ResourceManager.GetString("CP_Settings_ManageSiteTerms_DeleteButton", "ControlPanelResources.xml") %>" onclick="DeleteToken('<%# Eval("ID") %>');" />
			                </td>
                        </tr>
            </ItemTemplate>
            <AlternatingItemTemplate>
                        <tr class="AltListRow">
                            <td class="CommonListCell">
                                <%# Eval("Token") %>&nbsp;
                            </td>
                            <td class="CommonListCell">
                                <%# Eval("DefaultValue")%>&nbsp;
                            </td>
                            <td class="CommonListCell">
                                <%# GetReplacementOrNA((SiteTerm)Container.DataItem)%>&nbsp;
                            </td>
                            <td class="CommonListCell">
				                <input type="button" value="<%# ResourceManager.GetString("CP_Settings_ManageSiteTerms_EditButton", "ControlPanelResources.xml") %>" onclick="Telligent_Modal.Open('<%# Globals.FullPath("~/controlpanel/tools/SiteTermEdit.aspx") %>?ID=<%# Eval("ID") %>&token=<%# Globals.UrlEncode((string)Eval("Token")) %>&language=<%# Globals.UrlEncode((string)Eval("Language")) %>&defaultValue=<%# Globals.UrlEncode((string)Eval("DefaultValue")) %>&currentValue=<%# Globals.UrlEncode((string)Eval("CurrentValue")) %>&isDefault=<%# Eval("IsDefault") %>', 350, 165, closeModal);" />&nbsp;
				                <input type="button" value="<%# ResourceManager.GetString("CP_Settings_ManageSiteTerms_ResetButton", "ControlPanelResources.xml") %>" onclick="ResetToken('<%# Eval("ID") %>');" />&nbsp;
                                <input type="button" value="<%# ResourceManager.GetString("CP_Settings_ManageSiteTerms_DeleteButton", "ControlPanelResources.xml") %>" onclick="DeleteToken('<%# Eval("ID") %>');" />
			                </td>
                        </tr>
            </AlternatingItemTemplate>
            <FooterTemplate>
                    </table>
                </div>
            </FooterTemplate>
        </asp:Repeater>
        <table width=100% cellpadding=0 cellspacing=0>
            <tr>
                <td align=right class="PanelSaveButton"><input runat=server id="btnAddNewTerm" type="button" /></td>
            </tr>
        </table>
    </div>
</asp:Content>
