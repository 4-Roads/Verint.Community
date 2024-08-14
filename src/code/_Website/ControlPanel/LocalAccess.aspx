<%@ Page Async="true" Language="C#" EnableViewState="false" AutoEventWireup="false" CodeBehind="LocalAccess.aspx.cs" Inherits="Telligent.Evolution.Web.ControlPanel.LocalAccess" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <style>
        html, body { background-color: #fff; color: #000; font-family: Arial, Arial, Helvetica, sans-serif; font-size: 13px; }
        h1 { font-size: 18px; margin: 0 0 .5em 0; }
        label { font-weight: bold; display: block; margin: 1em 0 0 0; }
        input { margin: 0 0 1em 0; }
        input[type="text"], input[type="password"] { width: 50%; min-width: 200px; max-width: 500px; }
        div { margin-top: 1em; }
    </style>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body spellcheck="true">
    <form runat="server" id="AdminForm">
        <h1>Emergency Login</h1>
        <label>
            Username:
        </label>
        <asp:textbox ID="username" autocomplete="Off" runat="server"></asp:textbox>
        <label>
            Password:
        </label>
        <asp:textbox ID="password" autocomplete="Off"  TextMode="Password" runat="server"></asp:textbox>
        <div>
            <asp:Button runat="server" ID="submit" Text="Submit" />
        </div>
        <div>
            <asp:Label runat="server" ID="Errors" Visible="false" style="color: red;" />
        </div>
    </form>
</body>
</html>
