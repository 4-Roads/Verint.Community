<%@ Page Async="true" Language="C#" AutoEventWireup="true" CodeBehind="UpgradeAttachments.aspx.cs" Inherits="Telligent.Evolution.Web.ControlPanel.Utility.UpgradeAttachments" %>
<html>
	<head>
		<title>Upgrade Attachment Files for Telligent Community 6.0</title>
		<TEControl:JQuery runat="server" />
		<style type="text/css">
			html, body { margin: 1em; padding: 0; text-align: left; font-size: 12px; font-family:Arial; color: #333;  }
			a:link, a:visited, a:active { outline: none; color: #06d; text-decoration: none; font-weight: bold; }
			a:hover { outline: none; text-decoration: underline; }

			fieldset { position: relative; }
			fieldset.field-list { border: none; margin: 1em 0; padding: 0; }
				.field-list-description { color: #000; white-space: normal; font-weight: bold; font-size: 1.3em; margin: 0.5em 0; }
				.field-list-description span { position: relative; left: -3px; }
				ul.field-list { list-style-type: none; margin: 0; padding: 0; clear: both; }
			.field-item { margin: 0; padding: .5em 0 }
				.field-item-description { display: block; color: #999; clear: both; }
				.field-item-header { font-weight: bold; display: block; }
				.field-item-validation { color: #f00; }
				.field-item .field-item-input input { margin-left: 0; }
		</style>
	</head>
	<body>
		<form runat="server">
			<div class="field-list-header"></div>
			<fieldset class="field-list">
				<legend class="field-list-description"><span>Migrate File Attachments</span></legend>
				<div>Use the form below to migrate file attachments for Telligent Community 6.0.</div>
				<ul class="field-list"><%--
					<li class="field-item">
						<TEControl:FormLabel LabelForId="AmazonS3" Text="Check only if you use Amazon S3" runat="server" CssClass="field-item-header" />
						<span class="field-item-input"><asp:CheckBox ID="AmazonS3" runat="server" /></span>
					</li>--%>
					<li class="field-item">
						<TEControl:FormLabel LabelForId="testOnly" Text="Test Only (Do not physically move any files):" runat="server" CssClass="field-item-header" />
						<span class="field-item-input"><asp:CheckBox id="testOnly" runat="server" /></span>
					</li>
					<li class="field-item">
						<span class="field-item-input"><asp:Button runat="server" id="update" Text="Start Migration" OnClick="UpgradeClick" /></span>
					</li>
				</ul>
			</fieldset>
			<div class="field-list-footer"></div>
		</form>
	</body>
</html>