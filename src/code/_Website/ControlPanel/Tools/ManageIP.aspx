<%@ Page Async="true" language="c#" Codebehind="ManageIP.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Tools.ManageIPAddresses" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>

<asp:Content ContentPlaceHolderId="TaskRegion" runat="Server">
    <CP:ControlPanelSelectedNavigation runat="server" SelectedNavItem="ToolsManageIP" />
    <cp:StatusMessage runat="server" id="Status" />
    <DIV class="CommonDescription"><cp:resourcecontrol id=RegionSubTitle runat="Server" resourcename="CP_Tools_ManageIP_SubTitle" /></DIV>

    <asp:repeater id=BannedIPS runat="Server">
		    <headertemplate>
			    <table cellspacing="0" border="0" cellpadding="0">
			    <tr>
				    <th class="CommonListHeaderLeftMost"><cp:resourcecontrol id="Resourcecontrol3" runat="Server" resourcename="CP_Tools_ManageIP_IPAddressRange" /></th>
				    <th class="CommonListHeader"><cp:resourcecontrol id="Resourcecontrol4" runat="Server" resourcename="Delete" /></th>
			    </tr>
		    </headertemplate>
		    <itemtemplate>
			    <tr>
				    <td class="CommonListCellLeftMost">
    <asp:literal id = "IP" runat = "Server" /></td>
				    <td class="CommonListCell">
    <cp:resourcelinkbutton id = "DeleteButton" resourcename="Delete" cssclass="CommonTextButton" runat = "Server" /></td>
			    </tr>
		    </itemtemplate>
		    <alternatingitemtemplate>
			    <tr class="AltListRow">
				    <td class="CommonListCellLeftMost">
    <asp:literal id = "IP" runat = "Server" /></td>
				    <td class="CommonListCell">
    <cp:resourcelinkbutton id = "DeleteButton" resourcename="Delete" cssclass="CommonTextButton" runat = "Server" /></td>
			    </tr>
		    </alternatingitemtemplate>
		    <footertemplate>
			    </table>
		    </footertemplate>
		    </asp:repeater>

     <p />

     <TABLE cellspacing="0" border="0" cellpadding="0">
      <TR>
        <TH class="ContentFilterColumn" width="150px"><cp:resourcecontrol id="Resourcecontrol1" runat="Server" resourcename="CP_Tools_ManageIP_IPAddress" /></TH>
        <TH class="ContentFilterColumn" width="150px"><cp:resourcecontrol id="Resourcecontrol2" runat="Server" resourcename="CP_Tools_ManageIP_Range" /></TH>
        <TH class="ContentFilterColumn" width="150px">&nbsp;</TH></TR>
      <TR>
        <TD>
            <asp:textbox id=IPStart runat="Server"></asp:textbox></TD>
        <TD>
            <asp:textbox id=IPEnd runat="Server"></asp:textbox></TD>
        <TD>
            <cp:resourcelinkbutton id=AddButton runat="server" resourcename="CP_Tools_ManageIP_AddIPAddress" cssclass="CommonTextButton"></cp:resourcelinkbutton>
        </TD>
      </TR>
    </TABLE>


</asp:Content>