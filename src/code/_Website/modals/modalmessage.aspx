<%@ Page Async="true" EnableViewState="false" Language="C#" AutoEventWireup="true" MasterPageFile="~/modals/modal.Master" %>
<%@ Import Namespace="Telligent.Evolution.Components" %>

<asp:Content ContentPlaceHolderID="content" runat="server">

    <div class="page-header"></div>
    <div class="page">
	    <TEControl:MessageData runat="server" Property="Title" Tag="Div" CssClass="page-name" />
	    <div class="page-content">
            <TEControl:MessageData Property="Body" runat="server" />
        </div>
    </div>
    <div class="page-footer"></div>

</asp:Content>