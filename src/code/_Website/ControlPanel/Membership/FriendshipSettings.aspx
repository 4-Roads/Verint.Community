<%@ Page Async="true" language="c#" Codebehind="FriendshipSettings.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Membership.FriendshipSettings" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>
<%@ Register TagPrefix="CP" TagName="ActivityStorySitePreferences" Src = "~/ControlPanel/Membership/ManageActivityStoryDefaultPreferences.ascx" %>

<asp:Content ContentPlaceHolderId="TaskRegion" runat="Server">
	<script type="text/javascript">
	// <!--
	function RefreshAvatarTab() {
		window.location.href = window.location.href.split("?")[0] + "?ShowTab=Avatars"
	}
	// -->
	</script>
    <CP:ControlPanelSelectedNavigation runat="server" SelectedNavItem="AccountSettings" />
	<TEControl:PlaceHolder runat="server">
	    <DisplayConditions><TEControl:QueryStringPropertyValueComparison runat="server" QueryStringProperty="Success" Operator="EqualTo" ComparisonValue="true" /></DisplayConditions>
	    <ContentTemplate>
	        <CP:ResourceControl runat="server" Tag="Div" CssClass="CommonMessageSuccess" ResourceName="CP_Membership_Cache_Warning">
	            <Parameter1Template><TEControl:SiteSettingsData runat="server" Property="SiteSettingsCacheWindowInMinutes" /></Parameter1Template>
	        </CP:ResourceControl>
	    </ContentTemplate>
	</TEControl:PlaceHolder>
	<TEControl:PlaceHolder runat="server">
	    <DisplayConditions><TEControl:QueryStringPropertyValueComparison runat="server" QueryStringProperty="Success" Operator="EqualTo" ComparisonValue="false" /></DisplayConditions>
	    <ContentTemplate>
	        <CP:ResourceControl runat="server" Tag="Div" CssClass="CommonMessageSuccess" ResourceName="Admin_SiteSettings_StatusFailedVersionCheckWithUrlExpectedFormatting">
	            <Parameter1Template><TEControl:SiteUrl runat="server" UrlName="membership_ControlPanel_AccountSettings" RenderRawUrl="true" /></Parameter1Template>
	        </CP:ResourceControl>
	    </ContentTemplate>
	</TEControl:PlaceHolder>


		        <table cellspacing="0" cellpadding="3" border="0">
		            <tr>
			            <td class="CommonFormFieldName">
				            <strong><cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_RequireMessage" /></strong><br />
				            <cp:ResourceControl runat="Server" resourcename="CP_Membership_Settings_RequireMessage_Desc" />
			            </td>
			            <td class="CommonFormField">
			                <CP:FriendshipRequireRequestMessageDropDownList id="reqRequestMessageList" runat="server" />
			            </td>
		            </tr>
		            <tr>
			            <td class="CommonFormFieldName">
				            <strong><cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_DefaultMessage" /></strong><br />
				            <cp:ResourceControl runat="Server" resourcename="CP_Membership_Settings_DefaultMessage_Desc" />
			            </td>
			            <td class="CommonFormField">
				            <TEControl:Editor runat="server" ID="txtDefaultFriendRequestMessage" />
			            </td>
		            </tr>
		        </table>

	<p class="PanelSaveButton DetailsFixedWidth">
			<cp:ResourceLinkButton id="btnSave" runat="server" resourcename="Save" cssclass="CommonTextButton" />
    </p>
</asp:Content>