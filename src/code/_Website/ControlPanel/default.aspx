<%@ Page Async="true" language="c#" AutoEventWireup="true" EnableViewState="false" %>

<script language="C#" runat="server">
private void Page_Load(object sender, System.EventArgs e)
{
   Response.Status = "301 Moved Permanently";
   Response.AddHeader("Location","/administration");
   Response.End();
}
</script>

<html>
<head>
</head>
<body>

<body>
</html>
