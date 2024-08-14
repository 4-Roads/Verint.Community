<%@ Page Async="true" language="c#" Codebehind="ActivityStorySettings.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Membership.ActivityStorySettings" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>
<%@ Register TagPrefix="CP" TagName="ActivityStorySitePreferences" Src = "~/ControlPanel/Membership/ManageActivityStoryDefaultPreferences.ascx" %>

<asp:Content ContentPlaceHolderId="TaskRegion" runat="Server">
    <CP:ControlPanelSelectedNavigation runat="server" SelectedNavItem="AccountSettings" />
	<TEControl:PlaceHolder runat="server">
	    <DisplayConditions><TEControl:QueryStringPropertyValueComparison runat="server" QueryStringProperty="Success" Operator="EqualTo" ComparisonValue="true" /></DisplayConditions>
	    <ContentTemplate>
	        <CP:ResourceControl runat="server" Tag="Div" CssClass="CommonMessageSuccess" ResourceName="CP_Membership_Cache_Warning">
	            <Parameter1Template><TEControl:SiteSettingsData runat="server" Property="SiteSettingsCacheWindowInMinutes" /></Parameter1Template>
	        </CP:ResourceControl>
	    </ContentTemplate>
	</TEControl:PlaceHolder>


                <div class="CommonFormSubTitle">
					<CP:ResourceControl ID="ResourceControl1" runat="server" ResourceName="CP_Settings_ActivityStoryPreferences_SubTitle_Desc" />
					<ul>
						<CP:ResourceControl ID="ResourceControl2" runat="server" ResourceName="CP_Settings_ActivityStoryPreferences_ControlledOptIn_Desc" Tag="Li" />
						<CP:ResourceControl ID="ResourceControl3" runat="server" ResourceName="CP_Settings_ActivityStoryPreferences_ControlledOptOut_Desc" Tag="Li" />
						<CP:ResourceControl ID="ResourceControl4" runat="server" ResourceName="CP_Settings_ActivityStoryPreferences_AlwaysOnVisible_Desc" Tag="Li" />
						<CP:ResourceControl ID="ResourceControl5" runat="server" ResourceName="CP_Settings_ActivityStoryPreferences_AlwaysOnHidden_Desc" Tag="Li" />
						<CP:ResourceControl ID="ResourceControl6" runat="server" ResourceName="CP_Settings_ActivityStoryPreferences_AlwaysOff_Desc" Tag="Li" />
					</ul>
				</div>
				<CP:ActivityStorySitePreferences runat="server" ID="ActivityStoryPreferences" />

	<p class="PanelSaveButton DetailsFixedWidth">
			<cp:ResourceLinkButton id="btnSave" runat="server" resourcename="Save" cssclass="CommonTextButton" />
    </p>
</asp:Content>