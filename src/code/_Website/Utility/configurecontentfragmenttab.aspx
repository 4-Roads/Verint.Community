<%@ Page Async="true" EnableViewState="false" Language="C#" AutoEventWireup="true" MasterPageFile="~/modals/modal.Master" %>
<%@ Import Namespace="Telligent.Evolution.Components"%>
<%@ Import Namespace="Telligent.Evolution.Controls"%>

<script runat="server" type="text/C#" language="C#">
protected void Page_Load(object sender, EventArgs e)
{
	if (!Page.IsPostBack)
	{
		if (!string.IsNullOrEmpty(Request.QueryString["name"]))
			Page.Title = ResourceManager.GetString("EditTab_EditTab");
		else
			Page.Title = ResourceManager.GetString("EditTab_NewTab");
	}
}
</script>

<asp:Content ContentPlaceHolderID="content" runat="server">
	<script type="text/javascript">
		// <![CDATA[
		$(function() {
			var saveButton = $('#<%= CSControlUtility.Instance().FindControl(this, "Save").ClientID %>');
			saveButton.on('click', function(e) { $('.processing', saveButton.parent()).css("visibility", "visible"); saveButton.addClass('disabled'); });
		});
		// ]]>
	</script>

	<TEControl:ConfigureContentFragmentTabForm runat="server" NameTextBoxId="Name" UrlTextBoxId="Url" LockedCheckBoxId="Locked" ContentLockedCheckBoxId="ContentLocked" SaveButtonId="Save">
		<FormTemplate>

            <script type="text/javascript">
                // <![CDATA[

                $(function()
                {
                    $('.field-item.locked :checkbox').each(function() { toggleContentLocked(this.checked) }).on('click', function() { toggleContentLocked(this.checked); });
                });

                function toggleContentLocked(locked)
                {
                    if (locked)
                        $('.field-item.content-locked').show();
                    else
                        $('.field-item.content-locked').hide();
                }

                // ]]>
            </script>

			<div class="field-list-header"></div>
			<fieldset class="field-list">
				<ul class="field-list">
					<li class="field-item required">
						<TEControl:FormLabel runat="server" LabelForId="Name" ResourceName="EditTab_Name" CssClass="field-item-header" />
						<span class="field-item-description"><TEControl:ResourceControl runat="server" ResourceName="EditTab_Name_Description" /></span>
						<span class="field-item-input"><TEControl:ContentFragmentTokenTextBox runat="server" ID="Name" Columns="40" /></span>
						<asp:RequiredFieldValidator runat="server" ControlToValidate="Name" Display="Dynamic"><span class="field-item-validation">*</span></asp:RequiredFieldValidator>
					</li>
					<li class="field-item">
						<TEControl:FormLabel runat="server" LabelForId="Url" ResourceName="EditTab_Url" CssClass="field-item-header" />
						<span class="field-item-description"><TEControl:ResourceControl runat="server" ResourceName="EditTab_Url_Description" /></span>
						<span class="field-item-input"><asp:TextBox runat="server" ID="Url" Columns="40" /></span>
					</li>
					<TEControl:PlaceHolder runat="server">
						<DisplayConditions><TEControl:ControlVisibilityCondition ControlId="Locked" ControlVisibilityEquals="true" runat="server" /></DisplayConditions>
						<ContentTemplate>
							<li class="field-item locked">
								<TEControl:FormLabel runat="server" LabelForId="Locked" ResourceName="EditTab_Locked" CssClass="field-item-header" />
								<span class="field-item-description"><TEControl:ResourceControl runat="server" ResourceName="EditTab_Locked_Description" /></span>
								<span class="field-item-input"><asp:CheckBox runat="server" ID="Locked" /></span>
							</li>
						</ContentTemplate>
					</TEControl:PlaceHolder>
					<TEControl:PlaceHolder runat="server">
						<DisplayConditions><TEControl:ControlVisibilityCondition ControlId="ContentLocked" ControlVisibilityEquals="true" runat="server" /></DisplayConditions>
						<ContentTemplate>
							<li class="field-item content-locked">
								<TEControl:FormLabel runat="server" LabelForId="ContentLocked" ResourceName="EditTab_ContentLocked" CssClass="field-item-header" />
								<span class="field-item-description"><TEControl:ResourceControl runat="server" ResourceName="EditTab_ContentLocked_Description" /></span>
								<span class="field-item-input"><asp:CheckBox runat="server" ID="ContentLocked" /></span>
							</li>
						</ContentTemplate>
					</TEControl:PlaceHolder>
					<li class="field-item">
						<span class="field-item-input">
							<asp:LinkButton ID="Save" runat="server" CssClass="internal-link save-form"><span></span><TEControl:ResourceControl runat="server" ResourceName="Save" /></asp:LinkButton>
							<span class="processing" style="visibility: hidden;"></span>
						</span>
					</li>
				</ul>
			</fieldset>
			<div class="field-list-footer"></div>

		</FormTemplate>
	</TEControl:ConfigureContentFragmentTabForm>

</asp:Content>