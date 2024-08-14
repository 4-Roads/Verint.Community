<%@ Page Async="true" language="c#" Codebehind="ManageShortenedUrls.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Tools.ManageShortenedUrls" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>

<asp:Content ContentPlaceHolderId="TaskRegion" runat="Server">
	<CP:ControlPanelSelectedNavigation runat="server" SelectedNavItem="ToolsRedirects" />
	<DIV class="CommonDescription">
		<cp:resourcecontrol id="Resourcecontrol1" runat="Server" resourcename="ShortenedUrl_SubTitle"></cp:resourcecontrol></DIV>
	<asp:datalist id="ManageShortened" runat="server" width="100%">
		<headertemplate>
			<table id="tblManageShortenedUrls" cellspacing="0" cellpadding="0" width="100%" border="0">
				<tr>
					<td class="CommonListHeaderLeftMost">
						<cp:resourcelabel runat="server" resourcename="ShortenedUrl_ID" id="Resourcelabel2" />
					</td>
					<td class="CommonListHeader">
						<cp:resourcelabel runat="server" resourcename="ShortenedUrl_Url" id="Resourcelabel3" />
					</td>
					<td class="CommonListHeader">
						<cp:resourcelabel runat="server" resourcename="ShortenedUrl_Description" id="Resourcelabel4" />
					</td>
					<td class="CommonListHeader">
						<cp:resourcelabel runat="server" resourcename="ShortenedUrl_Impressions" id="Resourcelabel1" />
					</td>
					<td class="CommonListHeader" nowrap="nowrap">
						<cp:resourcelabel runat="server" resourcename="Actions" id="Resourcelabel5" />
					</td>
				</tr>
		</headertemplate>
		<itemtemplate>
			<tr>
				<td class="CommonListCellLeftMost">
					<asp:label runat="server" id="ID" />
				</td>
				<td class="CommonListCell">
					<asp:label runat="server" id="Url" />
				</td>
				<td class="CommonListCell">
					<asp:label runat="server" id="Description" />
				</td>
				<td class="CommonListCell">
					<asp:label runat="server" id="Impressions" />
				</td>
				<td class="CommonListCell" nowrap="nowrap">
					<asp:Hyperlink id="ViewShortenedUrl" runat="server" cssclass="CommonTextButton" />
					<asp:LinkButton id="EditShortenedUrl" commandname="Edit" runat="server" CssClass="CommonTextButton"></asp:LinkButton>
					<asp:LinkButton id="DeleteShortenedUrl" commandname="Delete" runat="server" CssClass="CommonTextButton" OnClientClick="return confirm('Are you sure you want to delete this shortened URL?');"></asp:LinkButton>
				</td>
			</tr>
		</itemtemplate>
		<AlternatingItemTemplate>
		    <tr class="AltListRow">
				<td class="CommonListCellLeftMost">
					<asp:label runat="server" id="ID" />
				</td>
				<td class="CommonListCell">
					<asp:label runat="server" id="Url" />
				</td>
				<td class="CommonListCell">
					<asp:label runat="server" id="Description" />
				</td>
				<td class="CommonListCell">
					<asp:label runat="server" id="Impressions" />
				</td>
				<td class="CommonListCell" nowrap="nowrap">
					<asp:Hyperlink id="ViewShortenedUrl" runat="server" cssclass="CommonTextButton" />
					<asp:LinkButton id="EditShortenedUrl" commandname="Edit" runat="server" CssClass="CommonTextButton"></asp:LinkButton>
					<asp:LinkButton id="DeleteShortenedUrl" commandname="Delete" runat="server" CssClass="CommonTextButton" OnClientClick="return confirm('Are you sure you want to delete this shortened URL?');"></asp:LinkButton>
				</td>
			</tr>
		</AlternatingItemTemplate>
		<edititemtemplate>
			<tr>
				<td class="CommonListCellLeftMost">
					<asp:label runat="server" id="ID" />
				</td>
				<td class="CommonListCell">
					<asp:textbox id="ShortenedUrlOriginalUrl" size="40" runat="server"></asp:textbox>
					<asp:RequiredFieldValidator runat="server" ControlToValidate="ShortenedUrlOriginalUrl" ErrorMessage="*" ValidationGroup="EditValidationGroup" />
				</td>
				<td class="CommonListCell">
					<asp:textbox id="ShortenedUrlDescription" size="35" runat="server"></asp:textbox>
					<asp:RequiredFieldValidator runat="server" ControlToValidate="ShortenedUrlDescription" ErrorMessage="*" ValidationGroup="EditValidationGroup" />
				</td>
				<td class="CommonListCell">
					<asp:label runat="server" id="Impressions" />
				</td>
				<td class="CommonListCell">
					<asp:LinkButton id="UpdateShortenedUrl" runat="server" commandname="Update" CssClass="CommonTextButton" ValidationGroup="EditValidationGroup"></asp:LinkButton>
					<asp:LinkButton id="CancelShortenedUrl" runat="server" commandname="Cancel" CssClass="CommonTextButton"></asp:LinkButton>
				</td>
			</tr>
		</edititemtemplate>
		<footertemplate>
				<tr>
				<td class="CommonListCellLeftMost">
					&nbsp;
				</td>
				<td class="CommonListCell">
					<asp:textbox runat="server" size="40" id="NewShortenedUrlOriginalUrl"></asp:textbox>
					<asp:RequiredFieldValidator runat="server" ControlToValidate="NewShortenedUrlOriginalUrl" ErrorMessage="*" ValidationGroup="CreateValidationGroup" />
				</td>
				<td class="CommonListCell">
					<asp:textbox runat="server" size="35" id="NewShortenedUrlDescription"></asp:textbox>
					<asp:RequiredFieldValidator runat="server" ControlToValidate="NewShortenedUrlDescription" ErrorMessage="*" ValidationGroup="CreateValidationGroup" />
				</td>
				<td class="CommonListCell">
					&nbsp;
				</td>
				<td class="CommonListCell">
					<asp:LinkButton id="CreateShortenedUrl" commandname="Create" runat="server" CssClass="CommonTextButton" ValidationGroup="CreateValidationGroup" />
				</td>
			</tr>
			</table>
		</footertemplate>
	</asp:datalist>
</asp:Content>
