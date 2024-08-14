<%@ Page Async="true" Language="c#" CodeBehind="ManageAds.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Tools.ManageAds"
	MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>

<asp:Content ContentPlaceHolderID="TaskRegion" runat="Server">
	<CP:ControlPanelSelectedNavigation runat="server" SelectedNavItem="ManageAds" />
	<CP:FileOnlyStatusMessage ID="FOStatus" runat="server" Visible="false" />
	<asp:PlaceHolder ID="OptionHolder" runat="Server">
		<CP:StatusMessage ID="Status" runat="server" Visible="false" />
		<div class="FixedWidthContainer">
			<table cellpadding="0" cellspacing="0" border="0" width="60%">
				<tr>
					<td class="CommonFormFieldName">
						<strong>
							<CP:ResourceControl runat="Server" ResourceName="CP_Ads_Enable" />
						</strong>
						<br />
						<CP:ResourceControl runat="Server" ResourceName="CP_Ads_Enable_Help" />
					</td>
					<td class="CommonFormField">
						<asp:CheckBox ID="enableAds" runat="Server" CssClass="ControlPanelTextInput"></asp:CheckBox>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="CommonFormFieldName">
							<CP:ResourceControl runat="server" ResourceName="CP_Ads_LinkToSiteRoles" />
						</div>
					</td>
				</tr>
			</table>
		</div>
		<p class="PanelSaveButton DetailsFixedWidth">
			<CP:ResourceLinkButton ID="SaveButton" runat="Server" CssClass="CommonTextButton"
				ResourceName="Save"/></p>
	</asp:PlaceHolder>
</asp:Content>
