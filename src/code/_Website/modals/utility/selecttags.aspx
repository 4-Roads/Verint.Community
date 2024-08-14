<%@ Page Async="true" EnableViewState="false" Language="C#" AutoEventWireup="true" MasterPageFile="~/modals/modal.Master" %>

<asp:Content ContentPlaceHolderID="content" runat="server">
<script type="text/javascript">
		// <![CDATA[
		$(function() {
			var saveButton = $('#<%= CSControlUtility.Instance().FindControl(this, "OK").ClientID %>');
			saveButton.on('click', function(e) { $('.processing', $(saveButton).parent()).css("visibility", "visible"); saveButton.addClass('disabled'); });
		});
		// ]]>
	</script>

<TEControl:Title runat="server" IncludeSiteName="false" ResourceName="TagSelector_Title" EnableRendering="false" />

<TEControl:SelectTagsForm runat="server" SelectButtonId="OK" TagListPlaceHolderId="CheckboxListContainer">
    <FormTemplate>
        <div class="field-list-header"></div>
        <fieldset class="field-list">
            <legend class="field-list-description"><TEControl:ResourceControl ResourceName="TagSelector_Instructions" runat="server" /></legend>
            <ul class="field-list">
                <li class="field-item tag-list">
                    <span class="field-item-input"><asp:PlaceHolder Runat="server" ID="CheckboxListContainer" /></span>
                </li>
                <li class="field-item submit-button">
                    <span class="field-item-input">
                        <asp:LinkButton ID="OK" runat="server" CssClass="internal-link submit-form"><span></span><TEControl:ResourceControl runat="server" ResourceName="OK" /></asp:LinkButton>
                        <span class="processing" style="visibility: hidden;"></span>
                        <asp:LinkButton runat="server" CssClass="internal-link cancel" OnClientClick="window.parent.Telligent_Modal.GetWindowOpener(window).Telligent_Modal.Close(null, window.parent.Telligent_Modal.GetWindowOpener(window)); return false;"><span></span><TEControl:ResourceControl runat="server" ResourceName="Cancel" /></asp:LinkButton>
                    </span>
                </li>
            </ul>
        </fieldset>
        <div class="field-list-footer"></div>
    </FormTemplate>
</TEControl:SelectTagsForm>

</asp:Content>