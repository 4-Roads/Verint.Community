<%@ Control CodeBehind="FieldChoices.ascx.cs" Language="c#" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Membership.FieldChoices" %>
<%@ Import Namespace="Telligent.Evolution.Components" %>

<div class="CommonFormFieldName">
	<strong><cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_Profile_FieldChoices_Title" /></strong>
</div>

	<TEControl:WrappedRepeater id="FieldChoiceRepeater" runat="Server" EnableViewState="false" ShowHeaderFooterOnNone="true">
		<HeaderTemplate>
			<div class="CommonListArea">
				<table id="Listing" cellspacing="0" cellpadding="0" border="0" width="100%">
					<thead>
					<tr>
						<th class="CommonListHeaderLeftMost">
							<CP:ResourceControl runat="server" ResourceName="CP_Membership_Settings_Profile_FieldChoices_Name" />
						</th>
						<th class="CommonListHeader">
							<CP:ResourceControl runat="server" ResourceName="CP_Membership_Settings_Profile_FieldChoices_Value" />
						</th>
						<th class="CommonListHeader">
							&nbsp;
						</th>
					</tr>
					</thead>
		</HeaderTemplate>
		<ItemTemplate>
			<tr>
				<td class="CommonListCellLeftMost"><asp:TextBox runat="server" Columns="15" ID="Name" /></td>
				<td class="CommonListCell"><asp:TextBox runat="server" Columns="15" ID="Value" /></td>
				<td class="CommonListCell">
					<asp:LinkButton CssClass="CommonSortableMoveUpButton" ID="MoveUpButton" runat="server">&nbsp;</asp:LinkButton>
					<asp:LinkButton CssClass="CommonSortableMoveDownButton" ID="MoveDownButton" runat="server">&nbsp;</asp:LinkButton>
					<asp:LinkButton CssClass="CommonSortableDeleteButton" ID="DeleteButton" runat="server">&nbsp;</asp:LinkButton>
				</td>
			</tr>
		</ItemTemplate>
		<NoneTemplate>
			<tr>
				<td colspan="3"><CP:ResourceControl ResourceName="CP_Membership_Settings_Profile_FieldChoices_NoData" runat="server" /></td>
			</tr>
		</NoneTemplate>
		<FooterTemplate>
			</table>
			</div>
		</FooterTemplate>
	</TEControl:WrappedRepeater>
<div class="CommonFormField">
    <asp:TextBox Runat="server" ID="NewName" Columns="20" /> 
    <asp:TextBox Runat="server" ID="NewValue" Columns="20" /> 
    <asp:Button Runat="server" ID="AddButton" />
</div>
