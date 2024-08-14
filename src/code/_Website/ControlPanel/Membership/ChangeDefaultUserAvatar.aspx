<%@ Page Async="true" language="c#" Codebehind="ChangeDefaultUserAvatar.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Membership.ChangeDefaultUserAvatar" MasterPageFile="~/ControlPanel/Masters/Modal.master" %>
<%@ Import Namespace="Telligent.Evolution.Components" %>

<asp:Content ContentPlaceHolderId="bcr" runat="Server">
    <div class="<%= Telligent.Evolution.Web.ControlPanel.Components.StaticVariables.LicenseRestrictionClass %>">
	<script type="text/javascript">
    // <!--
    function ValidateDelete()
    {
        return (window.confirm('<CP:ResourceControl runat="server" ResourceName="CP_Membership_Settings_Avatar_SelectableAvatar_DeleteConfirmation" />'));
    }
    // -->
    </script>
    <cp:statusmessage id="Status" runat="server" />
    <TWC:TabbedPanes runat="server" ID="Tabs" EnableResizing="false"
	    PanesCssClass="CommonPane"
        TabSetCssClass="CommonPaneTabSet"
        TabCssClasses="CommonPaneTab"
        TabSelectedCssClasses="CommonPaneTabSelected"
        TabHoverCssClasses="CommonPaneTabHover">

		<TWC:TabbedPane runat="server">
		    <Tab><TEControl:ResourceControl runat="server" ResourceName="EditProfile_UploadAvatarTab" /></Tab>
		    <Content>
    		    <div class="CommonFormFieldName">
                    <strong><CP:ResourceControl runat="server" ResourceName="CP_UserEdit_Avatar_UploadDefault" /></strong>
                </div>
                <div class="CommonFormField">
                    <asp:FileUpload runat="server" id="defaultAvatarFileUpload" />
                    <asp:RequiredFieldValidator runat="server" ValidationGroup="UploadGroup" ErrorMessage="<br/>Please browse to an image first." ControlToValidate="defaultAvatarFileUpload" />
                    <p>
                        <CP:ResourceButton id="uploadDefaultAvatarButton" ResourceName="CP_UserEdit_Avatar_UploadButton" Runat="server" ValidationGroup="UploadGroup" />
                        <CP:ResourceButton runat="server" ResourceName="CP_UserEdit_Avatar_RemoveButton" ID="deleteDefaultAvatar" OnClientClick="return ValidateDelete();" />
                    </p>
                </div>
		    </Content>
		</TWC:TabbedPane>

		<TWC:TabbedPane runat="server" ID="AvatarSelectionTab">
            <Tab><TEControl:ResourceControl runat="server" ResourceName="EditProfile_AvatarSelect" /></Tab>
            <Content>
                <asp:CheckBox runat="server" ID="EnableSelectAvatarCheckbox" Checked="true" Visible="false" />
                <div class="CommonFormFieldName"><TEControl:ResourceControl Tag="Strong" ResourceName="EditProfile_AvatarSelect" runat="server" /></div>
                <div class="CommonFormField">
                    <asp:RadioButtonList RepeatLayout="Flow" runat="server" ID="SelectableAvatars" RepeatColumns="6" />
                    <asp:RequiredFieldValidator runat="server" ValidationGroup="SelectGroup" ErrorMessage="<br/>Please select an image first." ControlToValidate="SelectableAvatars" />
                </div>
                <div class="CommonFormFieldName">
                    <CP:ResourceButton runat="server" id="UpdateSelectedAvatarButton" ResourceName="EditProfile_UseSelectedAvatar" ValidationGroup="SelectGroup" />
                    <CP:ResourceButton runat="server" ID="RemoveSelectAvatarButton" ResourceName="EditProfile_RemoveAvatar" />
                </div>
            </Content>
        </TWC:TabbedPane>

        <TWC:TabbedPane runat="server" ID="AvatarLinkTab">
            <Tab><TEControl:ResourceControl runat="server" ResourceName="EditProfile_LinkToAvatarTab" /></Tab>
            <Content>
                <div class="CommonFormFieldName">
                    <TEControl:ResourceControl runat="server" Tag="Strong" ResourceName="EditProfile_AvatarUrl" />
                </div>
                <div class="CommonFormField">
                    <asp:TextBox id="AvatarUrl" runat="server" MaxLength="256" Columns="60" />
                    <asp:RequiredFieldValidator runat="server" ValidationGroup="LinkGroup" ErrorMessage="<br/>Please enter the URL to an image first." ControlToValidate="AvatarUrl" />
                </div>
                <div class="CommonFormFieldName">
                    <CP:ResourceButton runat="server" id="UpdateLinkedAvatarButton" ResourceName="EditProfile_UseLinkedAvatar" ValidationGroup="LinkGroup" />
                    <CP:ResourceButton runat="server" ID="RemoveLinkAvatarButton" ResourceName="EditProfile_RemoveAvatar" />
                </div>
            </Content>
        </TWC:TabbedPane>
	</TWC:TabbedPanes>
    </div>
</asp:Content>