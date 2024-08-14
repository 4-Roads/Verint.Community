<%@ Control Language="c#" AutoEventWireup="false" Codebehind="ActivityQueryControl.ascx.cs" Inherits="Telligent.Evolution.ControlPanel.Tools.Reports.ActivityQueryControl" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<%@ Import Namespace = "Telligent.Evolution.Components" %>
<fieldset>
	<legend>
		<cp:ResourceControl id="Summary" runat="server" ResourceName="CP_Tools_Criteria" /></legend>
	<table width="700" border="0" cellpadding="4" cellspacing="0">
		<tr>
			<td class="CommonFormFieldName"><cp:resourcecontrol runat="server" resourcename="CP_Tools_BlogActivityReport_BegReportMonth" id="Resourcecontrol8" /></td>
			<td class="CommonFormField" nowrap>
			    <TWC:DateTimeSelector id="BegReportDatePicker" runat="server" DateTimeFormat="MMMM d yyyy" ShowCalendarPopup="true" />
			</td>
			<td class="CommonFormFieldName"><cp:resourcecontrol runat="server" resourcename="CP_Tools_BlogActivityReport_EndReportMonth" id="Resourcecontrol1" /></td>
			<td class="CommonFormField" nowrap>
			    <TWC:DateTimeSelector id="EndReportDatePicker" runat="server" DateTimeFormat="MMMM d yyyy" ShowCalendarPopup="true" />
			</td>
			<td colspan="3" class="CommonFormField" nowrap align="center"><cp:resourcelinkbutton id="ReportButton" runat="server" cssclass="CommonTextButton" resourcename="Generate"></cp:resourcelinkbutton></td>
			<td class="CommonFormField" nowrap align="left"><asp:HyperLink runat="server" id="ImageButton1" CssClass="CommonImageTextButton" style="BACKGROUND-IMAGE: url(../images/excel.gif)" /></td>
		</tr>
	</table>
	<DIV></DIV>
</fieldset>
 