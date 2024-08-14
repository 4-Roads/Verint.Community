<%@ Page Async="true" Language="c#" CodeBehind="Fields.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Membership.Fields" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>
<%@ Import Namespace="Telligent.Evolution.Components" %>
<asp:Content ContentPlaceHolderID="TaskRegion" runat="Server">
    <script type="text/javascript">
        $(function()
        {
            var iframe = $('.administration-panel-contents>iframe', window.parent.document);
            var contentHeigth = iframe.contents().height();
            if(iframe.height()!=contentHeigth)
                iframe.height(contentHeigth);
        });
    </script>
	<CP:ControlPanelSelectedNavigation runat="server" SelectedNavItem="Fields" />
	<asp:Repeater runat="server" ID="FieldList">
		<HeaderTemplate>
			<div class="CommonListArea">
				<table id="Listing" cellspacing="0" cellpadding="0" border="0" width="100%">
					<thead>
					<tr>
						<th class="CommonListHeaderLeftMost">
							<CP:ResourceControl runat="server" ResourceName="CP_Membership_Settings_Profile_Field_Name" />
						</th>
						<th class="CommonListHeader">
							<CP:ResourceControl runat="server" ResourceName="CP_Membership_Settings_Profile_Field_Label" />
						</th>
						<th class="CommonListHeader">
							<CP:ResourceControl runat="server" ResourceName="CP_Membership_Settings_Profile_Field_Searchable" />
						</th>
						<th class="CommonListHeader">
							<CP:ResourceControl runat="server" ResourceName="CP_Membership_Settings_Profile_Field_InputType" />
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
					<%# Eval("InternalName")%>&nbsp;
				</td>
				<td class="CommonListCell">
					<%# ProcessTokens(((UserProfileField)Container.DataItem).Name) %>&nbsp;
				</td>
			    <td class="CommonListCell">
			        <img src="<%=SiteUrls.Instance().Locations["ControlPanel"]%>images/<%# DataBinder.Eval(Container.DataItem,"IsSearchable").ToString() %>_large.gif" />
			    </td>
				<td class="CommonListCell">
					<%# GetFieldTypeName((int)Eval("FieldTypeID"))%>&nbsp;
				</td>
				<td class="CommonListCell" nowrap="nowrap">
					<input type="button" value='<%# Telligent.Evolution.ControlPanel.Components.ResourceManager.GetString("CP_Blog_GridCol_Edit") %>' onclick='Telligent_Modal.Open("<%# Globals.FullPath("~/ControlPanel/Membership/FieldEdit.aspx") %>?<%=Telligent.Evolution.Components.CommonQueryStringProperties.FieldID %>=<%# Eval("ID") %>    ", 500, 400, refreshCallback);' />
					&nbsp;
					<CP:ResourceButton runat="server" ID="DeleteButton" CommandArgument='<%# Eval("ID") %>'
						CommandName="Delete" OnClientClick="return confirm('Are you sure you want to delete this field?');"
						ResourceName="CP_Membership_Settings_Profile_Field_Delete" />
					&nbsp;
				</td>
			</tr>
		</ItemTemplate>
		<AlternatingItemTemplate>
			<tr class="AltListRow">
				<td class="CommonListCellLeftMost">
					<%# Eval("InternalName")%>&nbsp;
				</td>
				<td class="CommonListCell">
					<%# ProcessTokens(((UserProfileField)Container.DataItem).Name) %>&nbsp;
				</td>
			    <td class="CommonListCell">
			        <img src="<%=SiteUrls.Instance().Locations["ControlPanel"]%>images/<%# DataBinder.Eval(Container.DataItem,"IsSearchable").ToString() %>_large.gif" />
			    </td>
				<td class="CommonListCell">
					<%# GetFieldTypeName((int)Eval("FieldTypeID"))%>&nbsp;
				</td>
				<td class="CommonListCell" nowrap="nowrap">
					<input type="button" value='<%# Telligent.Evolution.ControlPanel.Components.ResourceManager.GetString("CP_Blog_GridCol_Edit") %>' onclick='Telligent_Modal.Open("<%# Globals.FullPath("~/ControlPanel/Membership/FieldEdit.aspx") %>?<%=Telligent.Evolution.Components.CommonQueryStringProperties.FieldID %>=<%# Eval("ID") %>    ", 500, 400, refreshCallback);' />
					&nbsp;
					<CP:ResourceButton runat="server" ID="DeleteButton" CommandArgument='<%# Eval("ID") %>'
						CommandName="Delete" OnClientClick="return confirm('Are you sure you want to delete this field?');"
						ResourceName="CP_Membership_Settings_Profile_Field_Delete" />
					&nbsp;
				</td>
			</tr>
		</AlternatingItemTemplate>
		<FooterTemplate>
			</table> </div>
		</FooterTemplate>
	</asp:Repeater>
	<p class="PanelSaveButton">
		<input type="button" onclick="javascript:Telligent_Modal.Open('<%= Globals.FullPath("~/ControlPanel/Membership/FieldEdit.aspx") %>', 500, 400, refresh);" value='<%= ResourceManager.GetString("CP_Membership_Settings_Profile_Field_NewField", "ControlPanelResources.xml") %>    ' />
		&nbsp;&nbsp;&nbsp;
	</p>
</asp:Content>
