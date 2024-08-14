<%@ Page Async="true" language="c#" Codebehind="FieldEdit.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Membership.FieldEdit" MasterPageFile="~/ControlPanel/Masters/Modal.master" %>
<%@ Register TagPrefix="CP" TagName = "FieldChoices" Src = "~/ControlPanel/Membership/FieldChoices.ascx" %>
<%@ Import Namespace="Telligent.Evolution.Components" %>
<%@ Register TagPrefix="te" Namespace="Telligent.Evolution.Controls" Assembly="Telligent.Evolution.Platform" %>

<asp:Content ContentPlaceHolderId="bcr" runat="Server">
    <div class="<%= Telligent.Evolution.Web.ControlPanel.Components.StaticVariables.LicenseRestrictionClass %>">

<script type="text/javascript">
	// <![CDATA[
	var multipleChoiceFieldTypes = new Array();
	<%=JS_MultipleChoiceFieldTypes %>

	function FieldTypeChange(ddl)
	{
		var fieldChoiceContainer = document.getElementById('<%=FieldChoicesContainer.ClientID %>');
		for (x in multipleChoiceFieldTypes)
		{
			if (multipleChoiceFieldTypes[x] == ddl.value)
			{
				fieldChoiceContainer.style.display = 'block';
				return;
	        }
		}

		fieldChoiceContainer.style.display = 'none';
	}

// ]]>
</script>

<div class="CommonContentArea"><div class="CommonContent">

<cp:statusmessage id="status" runat="server" />

<div class="CommonFormArea">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr>
    <td class="CommonFormFieldName">
	    <strong><cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_Profile_Field_Name" /></strong>
    </td>
    <td class="CommonFormField">
        <asp:textbox id="InternalName" runat="server" maxlength="255" width="300" />
        <asp:requiredfieldvalidator runat="server" errormessage="*" font-bold="True" controltovalidate="InternalName" />
        <asp:CustomValidator runat="server" id="internalNameValidator" ControlToValidate="InternalName" ErrorMessage="*" />
        <div>
             <cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_Profile_Field_NameDescription" />
        </div>
    </td>
</tr>
<tr>
    <td class="CommonFormFieldName">
	    <strong><cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_Profile_Field_Label" /></strong>
    </td>
    <td class="CommonFormField tokenStringControl">
        <te:ContentFragmentTokenStringControl runat="server" ID="fieldName" />
        <asp:CustomValidator runat="server" ErrorMessage="*" Font-Bold="true" ID="fieldNameValidator" ControlToValidate="InternalName" />
    </td>
</tr>
<tr>
    <td class="CommonFormFieldName">
	    <strong><cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_Profile_Field_Searchable" /></strong>
    </td>
    <td class="CommonFormField">
		<CP:YesNoRadioButtonList runat="server" SelectedValue="true" ID="IsSearchable" />
    </td>
</tr>
<tr>
    <td class="CommonFormFieldName">
	    <strong><cp:resourcelabel runat="server" resourcename="CP_Membership_Settings_Profile_Field_InputType" /></strong>
    </td>
    <td class="CommonFormField">
		<asp:DropDownList ID="FieldType" runat="server" />
    </td>
</tr>
</table>

<div id="FieldChoicesContainer" runat="server">
	<CP:FieldChoices id="FieldChoices1" runat="Server" />
</div>

<div class="CommonFormField PanelSaveButton" style="display: block;">
	<cp:resourcelinkbutton id="SaveButton" runat="server" cssclass="CommonTextButton" resourcename="Save" />
</div>

</div>

</div></div>
</div>
</asp:Content>