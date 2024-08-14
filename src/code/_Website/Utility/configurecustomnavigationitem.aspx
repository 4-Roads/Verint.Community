<%@ Page Async="true" EnableViewState="false" Language="C#" AutoEventWireup="true" MasterPageFile="~/modals/modal.Master" %>
<%@ Import Namespace="Telligent.Evolution.Components"%>
<%@ Import Namespace="Telligent.Evolution.Controls"%>

<script runat="server" type="text/C#" language="C#">
protected void Page_Load(object sender, EventArgs e)
{
    Guid id = (Guid)CustomNavigationItemForm.DataSource;
    if (id != Guid.Empty)
        Page.Title = ResourceManager.GetString("CustomNavigationItem_Edit");
    else
        Page.Title = ResourceManager.GetString("CustomNavigationItem_Add");
}
</script>

<asp:Content ContentPlaceHolderID="content" runat="server">
	<script type="text/javascript">
		// <![CDATA[
	    $(function ()
	    {
	        var saveButton = $('#<%= CSControlUtility.Instance().FindControl(this, "Save").ClientID %>');
	        saveButton.on('click', function ()
	        {
	            if (typeof (Page_ClientValidate) == "function" && Page_ClientValidate('') == false)
	                return false;

	            $('.processing', saveButton.parent()).css("visibility", "visible");
	            saveButton.addClass('disabled');
	        });
	    });
		// ]]>
	</script>

    <TEControl:ConfigureCustomNavigationItemForm runat="server" ID="CustomNavigationItemForm"
		CustomNavigationItemConfigurationFormId="ConfigurationForm"
		LinkTypeDropDownListId="LinkType"
		SaveButtonId="Save">
		<FormTemplate>
            <div class="field-list-header"></div>
	        <fieldset class="field-list">
		        <ul class="field-list">
			        <li class="field-item">
                        <label class="field-item-header"><TEControl:ResourceControl ResourceName="CustomNavigationItem_LinkType" runat="server" /></label>
                         <span class="field-item-description"><TEControl:ResourceControl ResourceName="CustomNavigationItem_LinkType_Description" runat="server" /></span>
                        <span class="field-item-input"><asp:DropDownList runat="server" ID="LinkType" /></span>
			        </li>
		        </ul>
	        </fieldset>
	        <div class="field-list-footer"></div>

            <TEDynConfig:ConfigurationForm runat="server" id="ConfigurationForm" EnableResizing="false"
		        RenderGroupsInTabs="true"
		        PanesCssClass="tab-pane"
		        TabSetCssClass="tab-set"
		        TabCssClasses="tab"
		        TabSelectedCssClasses="tab selected"
		        TabHoverCssClasses="tab hover"
		        >
		        <PropertyFormGroupHeaderTemplate>
			        <div class="field-list-header"></div>
			        <fieldset class="field-list">
				        <legend class="field-list-description"><span><TEDynConfig:PropertyGroupData Property="Description" runat="server" /></span></legend>
				        <ul class="field-list">
		        </PropertyFormGroupHeaderTemplate>
		        <PropertyFormSubGroupHeaderTemplate>
					        <li class="field-item heading"><TEDynConfig:PropertySubGroupData Property="Name" runat="server" /></li>
		        </PropertyFormSubGroupHeaderTemplate>
		        <PropertyFormPropertyTemplate>
					        <li class="field-item" id="<TEDynConfig:PropertyData Property="UniqueId" runat="server" />">
						        <label class="field-item-header"><TEDynConfig:PropertyData Property="Name" runat="server" /></label>
						        <span class="field-item-description"><TEDynConfig:PropertyData Property="Description" runat="server" /></span>
						        <span class="field-item-input"><TEDynConfig:PropertyControl runat="server" /></span>
					        </li>
		        </PropertyFormPropertyTemplate>
		        <PropertyFormGroupFooterTemplate>
				        </ul>
			        </fieldset>
			        <div class="field-list-footer"></div>
		        </PropertyFormGroupFooterTemplate>
	        </TEDynConfig:ConfigurationForm>

	        <div class="field-list-header"></div>
	        <fieldset class="field-list">
		        <ul class="field-list">
			        <li class="field-item save-form">
				        <span class="field-item-input">
					        <asp:LinkButton ID="Save" runat="server" CssClass="internal-link save-form"><span></span><TEControl:ResourceControl runat="server" ResourceName="Save" /></asp:LinkButton>
					        <span class="processing" style="visibility: hidden;"></span>
				        </span>
			        </li>
		        </ul>
	        </fieldset>
	        <div class="field-list-footer"></div>
        </FormTemplate>
    </TEControl:ConfigureCustomNavigationItemForm>
</asp:Content>