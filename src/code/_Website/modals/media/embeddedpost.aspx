<%@ Page Async="true" EnableViewState="false" Language="C#" AutoEventWireup="true" %>
<%@ Register TagPrefix="TEMedia" Namespace="Telligent.Evolution.MediaGalleries.Internal.Legacy.Controls.MediaGalleryPost" Assembly="Telligent.Evolution.MediaGalleries" %>

<script language="C#" runat="server">
	void Page_Load()
	{
		Telligent.Evolution.Components.JavaScript.RenderAsJavaScript(this.Context);

        int v;

        if (!string.IsNullOrEmpty(Request.QueryString["width"]) && int.TryParse(Request.QueryString["width"], out v))
            PostViewer.Width = v;

        if (!string.IsNullOrEmpty(Request.QueryString["height"]) && int.TryParse(Request.QueryString["height"], out v))
            PostViewer.Height = v;
	}
</script>

<TEMedia:MediaGalleryPostViewer runat="server" ViewType="View" Width="400" Height="300" ID="PostViewer" />