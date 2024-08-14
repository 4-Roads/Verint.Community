<%@ Page Async="true" language="c#" Codebehind="ShortenedUrlDetails.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Tools.ShortenedUrlDetails" MasterPageFile="~/ControlPanel/Masters/Modal.master" %>
<%@ Import Namespace="Telligent.Evolution.Components" %>

<asp:Content ContentPlaceHolderId="bcr" runat="server">
	<DIV class="CommonContentArea">
		<DIV class="CommonContent">
			<P>
				<div align="left">
					<p>
						<cp:ResourceLabel runat="server" ResourceName="ShortenedUrl_Details" />
					</p>
					<asp:textbox id="TinyUrl" runat="server" size="90" />
					<p>
						<cp:ResourceLabel runat="server" ResourceName="ShortenedUrl_Details_Text1" />
						<asp:label id="Url" runat="server" />
					</p>
					<p>
						<cp:ResourceLabel runat="server" ResourceName="ShortenedUrl_Details_Text2" />
						<b><asp:label id="Impressions" runat="server" /></b>
						<cp:ResourceLabel runat="server" ResourceName="ShortenedUrl_Details_Text3" />
					</p>
				</div>
				<asp:label id="UrlID" runat="server" visible="false" />
				<asp:label id="Description" runat="server" visible="false" />
			</P>
		</DIV>
	</DIV>
</asp:Content>
