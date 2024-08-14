<%@ Page Async="true" Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="Telligent.Evolution.Components" %>

<script runat="server">
	void Page_Load() {
		Context.Response.StatusCode = 500;
		Context.IgnoreCustomErrors(true);
	}
</script>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title>That Was Unexpected...</title>
</head>
<body style="background-color: #ffffff; color: #929292; font-family: Arial, Arial, Helvetica, sans-serif; font-size: 12pt;">
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
        <tr>
            <td align="center">
                <div style="width: 512px; text-align: left; margin-top: 100px;">
                    <table cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td align="top"><img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4NCjwhLS0gR2VuZXJhdG9yOiBBZG9iZSBJbGx1c3RyYXRvciAxOC4xLjEsIFNWRyBFeHBvcnQgUGx1Zy1JbiAuIFNWRyBWZXJzaW9uOiA2LjAwIEJ1aWxkIDApICAtLT4NCjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+DQo8c3ZnIHZlcnNpb249IjEuMSIgaWQ9Ildhcm5pbmciIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHg9IjBweCIgeT0iMHB4Ig0KCSB2aWV3Qm94PSIwIDAgMjAgMjAiIGVuYWJsZS1iYWNrZ3JvdW5kPSJuZXcgMCAwIDIwIDIwIiB4bWw6c3BhY2U9InByZXNlcnZlIj4NCjxwYXRoIGZpbGw9IiM5MjkyOTIiIGQ9Ik0xOS41MTEsMTcuOThMMTAuNjA0LDEuMzQ4QzEwLjQ4LDEuMTMzLDEwLjI1LDEsMTAsMUM5Ljc0OSwxLDkuNTE5LDEuMTMzLDkuMzk2LDEuMzQ4TDAuNDksMTcuOTgNCgljLTAuMTIxLDAuMjExLTAuMTE5LDAuNDcxLDAuMDA1LDAuNjhDMC42MiwxOC44NzEsMC44NDcsMTksMS4wOTMsMTloMTcuODE0YzAuMjQ1LDAsMC40NzQtMC4xMjksMC41OTgtMC4zNA0KCUMxOS42MjksMTguNDUxLDE5LjYzMSwxOC4xOTEsMTkuNTExLDE3Ljk4eiBNMTEsMTdIOXYtMmgyVjE3eiBNMTEsMTMuNUg5VjdoMlYxMy41eiIvPg0KPC9zdmc+" width="150" height="150" /></td>
                            <td valign="middle" style="padding-left: 20px;">
                                <h1 style="font-size: 38pt; font-weight: normal; line-height: 100%; color: #333333; margin: 0; padding: 0;">That Was Unexpected...</h1>
                            </td>
                        </tr>
                    </table>
                    <p style="line-height: 150%; margin: 2em 0; clear: left; border-top: solid 1px #ddd; border-bottom: solid 1px #ddd; padding: 1em 0;">
                        We apologize, but an unexpected issue prevented the page you requested from being available. We've logged the issue so the site administrator can resolve the problem.
                    </p>
                </div>
            </td>
        </tr>
    </table>
</body>
</html>