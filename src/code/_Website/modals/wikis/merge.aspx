<%@ Page Async="true" EnableViewState="false" Language="C#" AutoEventWireup="true" MasterPageFile="~/modals/modal.Master" %>
<%@ Import Namespace="Telligent.Evolution.Components"%>

<script runat="server">

	void Page_Load(object sender, EventArgs e)
	{
		CSContext cntx = CSContext.Current;

		int revA = cntx.GetIntFromQueryString("revA", -1);
		int revB = cntx.GetIntFromQueryString("revB", -1);

		PageMerger1.RevisionA = revA;
		PageMerger1.RevisionB = revB;
	}

</script>

<asp:Content ContentPlaceHolderId="content" runat="Server">
	<div style="margin: 10px;">
	<div class="content-fragment compare">
		<TEWiki:PageMerger ID="PageMerger1" TitleTag="h1" TitleCssClass="title" runat="server" />
	</div>
	</div>
</asp:Content>