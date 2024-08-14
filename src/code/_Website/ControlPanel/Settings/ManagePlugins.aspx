<%@ Page Async="true" language="c#" Codebehind="ManagePlugins.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Settings.ManagePlugins" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>

<asp:Content ID="Content2" ContentPlaceHolderId="TaskRegion" runat="Server">
    <cp:statusmessage runat="server" id="Status" />

    <script type = "text/javascript">
        function filterByName(input) {
            var val = $(input).val().toLowerCase();
            $('.plugins .lowered-plugin-name:not(:contains("' + val + '"))').parents('tr').hide();
            var rowsToShow = $('.plugins .lowered-plugin-name:contains("' + val + '")').parents('tr');
            rowsToShow.filter(':odd').removeClass('even').removeClass('odd').addClass('odd');
            rowsToShow.filter(':even').removeClass('odd').removeClass('even').addClass('even');
            rowsToShow.show();
        }
    </script>

	<div class="PanelSaveButton">
        <div style="float: left;">
            <cp:ResourceButton ID="ExportResources" runat="server" resourceName="ManagePlugins_ExportResources" />
            <CP:ResourceButton ID="ImportResources" runat="server" ResourceName="ManagePlugins_ImportResources" />
        </div>
	</div>

</asp:Content>