<%@ Page Async="true" Language="c#" CodeBehind="FieldGroups.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Membership.FieldGroups" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>
<%@ Import Namespace="Telligent.Evolution.Components"%>

<asp:Content ContentPlaceHolderID="TaskRegion" runat="Server">
	<CP:ControlPanelSelectedNavigation runat="server" SelectedNavItem="FieldGroups" />
	<asp:Repeater runat="server" ID="FieldGroupList">
		<HeaderTemplate>
			<div class="CommonListArea">
				<table id="Listing" cellspacing="0" cellpadding="0" border="0" width="100%">
					<thead>
						<tr>
							<th class="CommonListHeaderLeftMost">
								<CP:ResourceControl runat="server" ResourceName="CP_Membership_Settings_Profile_FieldGroup_Name" />
							</th>
							<th class="CommonListHeader">
								&nbsp;
							</th>
						</tr>
					</thead>
		</HeaderTemplate>
		<ItemTemplate>
			<tr>
				<td class="CommonListCellLeftMost">
					<%# ProcessTokens(((UserProfileFieldGroup)Container.DataItem).Name) %>&nbsp;
				</td>
				<td class="CommonListCell" nowrap="nowrap">
					<input type="button" onclick="javascript:Telligent_Modal.Open('<%# Globals.FullPath("~/ControlPanel/Membership/UserProfileData.aspx") %>?FieldGroupID=<%# Eval("ID") %>    ', 530, 500, refresh);" value="<%# ResourceManager.GetString("CP_Membership_EditFieldGroup", "ControlPanelResources.xml") %>" />
					&nbsp;
					<CP:ResourceButton runat="server" ID="DeleteButton" CommandArgument='<%# Eval("ID") %>'
						CommandName="Delete" OnClientClick="return confirm('Are you sure you want to delete this field group?');"
						ResourceName="CP_Membership_Settings_Profile_FieldGroup_Delete" />
				</td>
			</tr>
		</ItemTemplate>
		<AlternatingItemTemplate>
			<tr class="AltListRow">
				<td class="CommonListCellLeftMost">
					<%# ProcessTokens(((UserProfileFieldGroup)Container.DataItem).Name) %>&nbsp;
				</td>
				<td class="CommonListCell" nowrap="nowrap">
					<input type="button" onclick="javascript:Telligent_Modal.Open('<%# Globals.FullPath("~/ControlPanel/Membership/UserProfileData.aspx") %>?FieldGroupID=<%# Eval("ID") %>    ', 530, 500, refresh);" value="<%# ResourceManager.GetString("CP_Membership_EditFieldGroup", "ControlPanelResources.xml") %>" />
					&nbsp;
					<CP:ResourceButton runat="server" ID="DeleteButton" CommandArgument='<%# Eval("ID") %>'
						CommandName="Delete" OnClientClick="return confirm('Are you sure you want to delete this field group?');"
						ResourceName="CP_Membership_Settings_Profile_FieldGroup_Delete" />
				</td>
			</tr>
		</AlternatingItemTemplate>
		<FooterTemplate>
			</table> </div>
		</FooterTemplate>
	</asp:Repeater>
	<p class="PanelSaveButton">
		<input type="button" onclick="javascript:Telligent_Modal.Open('<%= Globals.FullPath("~/ControlPanel/Membership/UserProfileData.aspx") %>', 530, 500, refresh);" value='<%= ResourceManager.GetString("CP_Membership_Settings_Profile_FieldGroup_NewFieldGroup", "ControlPanelResources.xml") %>    ' />
		&nbsp;&nbsp;&nbsp;
	</p>
</asp:Content>
