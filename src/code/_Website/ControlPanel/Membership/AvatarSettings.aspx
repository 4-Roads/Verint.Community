<%@ Page Async="true" language="c#" Codebehind="AvatarSettings.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Membership.AvatarSettings" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>
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


		        <script type="text/javascript">
                // <!--
                function ValidateDelete()
                {
                    return (window.confirm('<CP:ResourceControl runat="server" ResourceName="CP_Membership_Settings_Avatar_SelectableAvatar_DeleteConfirmation" />'));
                }
                // -->
                </script>

		        <table cellspacing="0" cellpadding="3" border="0">

		            <tr>
			            <td class="CommonFormFieldName">
				            <strong><cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_Avatar_CoverPhotoSize" /></strong><br />
				            <cp:ResourceControl runat="Server" resourcename="CP_Membership_Settings_Avatar_CoverPhotoSize_Help" />
			            </td>
			            <td class="CommonFormField">
			                <asp:textbox id="CoverPhotoWidth" columns="4" maxlength="4" runat="server" />
			                x
				            <asp:textbox id="CoverPhotoHeight" columns="4" maxlength="4" runat="server" />
				            <asp:requiredfieldvalidator id="CoverPhotoHeightValidator" runat="server" controltovalidate="CoverPhotoHeight" errormessage="*" />
				            <asp:regularexpressionvalidator id="CoverPhotoHeightRegExValidator" runat="server" controltovalidate="CoverPhotoHeight" validationexpression="[0-9]*" errormessage="*" />
				            <asp:requiredfieldvalidator id="CoverPhotoWidthValidator" runat="server" controltovalidate="CoverPhotoWidth" errormessage="*" />
				            <asp:regularexpressionvalidator id="CoverPhotoWidthRegExValidator" runat="server" controltovalidate="CoverPhotoWidth" validationexpression="[0-9]*" errormessage="*" />
			            </td>
		            </tr>


		            <tr>
			            <td class="CommonFormFieldName">
				            <strong><cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_Avatar_AvatarSize" /></strong><br />
				            <cp:ResourceControl runat="Server" resourcename="CP_Membership_Settings_Avatar_AvatarSize_Help" />
			            </td>
			            <td class="CommonFormField">
			                <asp:textbox id="txtAvatarWidth" columns="3" maxlength="3" runat="server" />
			                x
				            <asp:textbox id="txtAvatarHeight" columns="3" maxlength="3" runat="server" />
				            <asp:requiredfieldvalidator id="AvatarHeightValidator" runat="server" controltovalidate="txtAvatarHeight" errormessage="*" />
				            <asp:regularexpressionvalidator id="AvatarHeightRegExValidator" runat="server" controltovalidate="txtAvatarHeight" validationexpression="[0-9]*" errormessage="*" />
				            <asp:requiredfieldvalidator id="AvatarWidthValidator" runat="server" controltovalidate="txtAvatarWidth" errormessage="*" />
				            <asp:regularexpressionvalidator id="AvatarWidthRegExValidator" runat="server" controltovalidate="txtAvatarWidth" validationexpression="[0-9]*" errormessage="*" />
			            </td>
		            </tr>
		            <tr>
			            <td class="CommonFormFieldName">
				            <strong><cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_Avatar_EnableUploadedAvatars" /></strong><br />
	                        <cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_Avatar_EnableUploadedAvatars_Help" />
			            </td>
			            <td class="CommonFormField">
				            <cp:yesnoradiobuttonlist id="optEnableUploadedAvatars" runat="server" repeatcolumns="2"  />
			            </td>
		            </tr>
		            <tr>
			            <td class="CommonFormFieldName">
				            <strong><cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_Avatar_EnableRemoteAvatar" /></strong><br />
				            <cp:ResourceControl runat="Server" resourcename="CP_Membership_Settings_Avatar_EnableRemoteAvatar_Help" />
			            </td>
			            <td class="CommonFormField">
				            <cp:yesnoradiobuttonlist id="optEnableRemoteAvatars" runat="server" repeatcolumns="2"  />
			            </td>
		            </tr>
		            <tr>
			            <td class="CommonFormFieldName">
				            <strong><cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_Avatar_EnableSelectableAvatars" /></strong><br />
	                        <cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_Avatar_EnableSelectableAvatars_Help" />
			            </td>
			            <td class="CommonFormField">
				            <cp:yesnoradiobuttonlist id="optEnableSelectableAvatars" runat="server" repeatcolumns="2"  />
			            </td>
		            </tr>
		            <tr>
		                <td colspan="2">
		                    <div class="CommonFormFieldName">
		                        <strong><CP:ResourceControl runat="server" ResourceName="CP_UserEdit_Avatar_Default" /></strong>
		                    </div>
		                    <div class="CommonFormField">
	                            <img runat="server" id="defaultAvatarImage" />
	                            <br />
	                            <a href="javascript:Telligent_Modal.Open('<%= Telligent.Evolution.Components.Globals.FullPath("~/ControlPanel/Membership/ChangeDefaultUserAvatar.aspx") %>', 560, 400, RefreshAvatarTab);"><%= Telligent.Evolution.Components.ResourceManager.GetString("CP_UserEdit_Avatar_Change", "ControlPanelResources.xml") %></a>
		                    </div>
		                </td>
		            </tr>
		            <tr>
		                <td colspan="2">
		                    <div class="CommonFormFieldName">
		                        <strong><cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_Avatar_SelectableAvatars" /></strong><br />
	                            <cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_Avatar_SelectableAvatars_Help" />
		                    </div>
		                    <div class="CommonFormField">
		                        <asp:Repeater runat="server" ID="selectableAvatars">
		                            <ItemTemplate>
		                                <div style="width: 82px; margin-right: .5em; float: left; text-align: center;">
		                                    <div style="width: 80px; height: 80px; padding: 1px;">
		                                        <table cellpadding="0" cellspacing="0" border="0" width="80" height="80"><tr><td align="ceter" valign="center">
		                                            <img src="<%# Telligent.Evolution.Components.SiteUrls.Instance().ResizedImage((Telligent.Evolution.Extensibility.Storage.Version1.ICentralizedFile) Container.DataItem, 80, 80, false) %>" alt="" />
                                                </td></tr></table>
		                                    </div>
		                                    <div>
		                                        <cp:ResourceLinkButton OnClientClick="return ValidateDelete();" CommandArgument='<%# Eval("Path")%>' CommandName="Delete" Runat="server" ID="DeleteButton" ResourceName="Delete" />
		                                    </div>
		                                </div>
		                            </ItemTemplate>
		                            <FooterTemplate>
		                                <div style="clear: both;"></div>
		                            </FooterTemplate>
		                        </asp:Repeater>
		                    </div>
		                    <div class="CommonFormField">
		                        <asp:FileUpload runat="server" id="selectablAvatarFileUpload" /> &nbsp; <CP:ResourceButton id="uploadButton" ResourceName="CP_Settings_FileStorage_UploadButton" Runat="server" />
		                    </div>
		                </td>
		            </tr>

	            </table>

	<p class="PanelSaveButton DetailsFixedWidth">
			<cp:ResourceLinkButton id="btnSave" runat="server" resourcename="Save" cssclass="CommonTextButton" />
    </p>
</asp:Content>