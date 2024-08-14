<%@ Page Async="true" Language="C#" AutoEventWireup="true" CodeBehind="UpgradeThemeFilesTo6.aspx.cs" Inherits="Telligent.Evolution.Web.ControlPanel.Utility.UpgradeThemeFilesTo6" %>

<html>
    <head>
        <title>Upgrade Theme Files for Telligent Evolution 6.0</title>
    </head>
    <body style="color: #000; background-color: #fff; font-family: Arial, Heletica; font-size: 12px;">
        <form runat="server">
            <fieldset>
                <legend style="font-weight: bold;">Migrate Theme Files for Telligent Evolution 6.0</legend>
                <div style="margin: 1em 0; color: #666;">
                    Click 'Start Migration' below to migrate theme files associated to out-of-the-box themes for use in Telligent Evolution 6.0.
                </div>
                <div style="margin: 1em 0;">
                    <asp:Button runat="server" id="update" Text="Start Migration" OnClick="update_Click" />
                </div>
        </form>
    </body>
</html>
