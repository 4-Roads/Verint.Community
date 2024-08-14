<%@ Page EnableViewState="true" Language="C#" AutoEventWireup="true" MasterPageFile="~/modals/modal.Master" %>

<asp:Content ContentPlaceHolderID="content" runat="server">
	<TEControl:Title runat="server" IncludeSiteName="false" ResourceName="Wiki_CopyToWiki" EnableRendering="false" />

	<TEWiki:SelectWikiThreadPageForm runat="server" ID="WikiForm" RedirectionTarget="_parent" SubmitButtonId="Submit" WikiDropDownListId="Wikis">
		<FormTemplate>
			<div class="field-list-header"></div>
			<fieldset class="field-list">
				<legend class="field-list-description"><span><TEControl:ResourceControl runat="server" ResourceName="Wiki_CaptureDesc" /></span></legend>
				<ul class="field-list">
					<li class="field-item">
						<span class="field-item-input"><asp:DropDownList runat="server" ID="Wikis" /></span>
					</li>
					<li class="field-item">
						<span class="field-item-input">
							<asp:LinkButton ID="Submit" runat="server" CssClass="internal-link capture-post button"><span></span><TEControl:ResourceControl runat="server" ResourceName="Wiki_Capture" /></asp:LinkButton>
							<asp:LinkButton runat="server" CssClass="internal-link cancel" OnClientClick="window.parent.Telligent_Modal.GetWindowOpener(window).Telligent_Modal.Close(null, window.parent.Telligent_Modal.GetWindowOpener(window)); return false;"><span></span><TEControl:ResourceControl runat="server" ResourceName="Cancel" /></asp:LinkButton>
						</span>
					</li>
				</ul>
			</fieldset>
			<div class="field-list-footer"></div>
		</FormTemplate>
	</TEWiki:SelectWikiThreadPageForm>

	<TEControl:PlaceHolder runat="server">
		<DisplayConditions>
			<TEControl:ControlVisibilityCondition runat="server" ControlId="WikiForm" ControlVisibilityEquals="false" />
		</DisplayConditions>
		<ContentTemplate>
			<div class="field-list-header"></div>
			<fieldset class="field-list">
				<ul class="field-list">
					<li class="field-item">
						<TEControl:ResourceControl runat="server" Tag="Span" CssClass="field-item-description" ResourceName="Wiki_NoWikisToCapture" />
						<span class="field-item-input"><asp:LinkButton runat="server" CssClass="internal-link cancel"  OnClientClick="window.parent.Telligent_Modal.GetWindowOpener(window).Telligent_Modal.Close(null, window.parent.Telligent_Modal.GetWindowOpener(window)); return false;"><span></span><TEControl:ResourceControl runat="server" ResourceName="OK" /></asp:LinkButton></span>
					</li>
				</ul>
			<br/>
		</ContentTemplate>
	</TEControl:PlaceHolder>
	
</asp:Content>