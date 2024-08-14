<%@ Register TagPrefix="CP" Namespace="Telligent.Evolution.ControlPanel.Controls" Assembly="Telligent.Evolution.Web" %>
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MGAccounts.ascx.cs" Inherits="Telligent.EvolutionWeb.ControlPanel.Settings.MGAccounts" %>
            <div style="text-align: right;">
		        <TEControl:ModalLink CssClass="CommonTextButton" runat = "Server" Height="300" Width="400" callback="refreshPostCallback" resourcename="CP_Settings_Email_MG_Accounts_CreateNew" Url = 'MGAccountsForm.aspx' ResourceFile="MGResources.xml" />
		    </div>
				<asp:Repeater Runat="server" id="AccountsList">
					<HeaderTemplate>
						<div class="CommonListArea">
							<table id="Listing" cellSpacing="0" cellPadding="0" border="0" width="100%">
								<thead>
									<tr>
										<th class="CommonListHeaderLeftMost">
											<cp:resourcecontrol runat="server" resourcename="CP_Settings_Email_MG_Accounts_Account_HostName" ResourceFile="MGResources.xml" /></th>
										<th class="CommonListHeader">
											<cp:resourcecontrol runat="server" resourcename="CP_Settings_Email_MG_Accounts_Account_UserName" ResourceFile="MGResources.xml" /></th>
										<th class="CommonListHeader">
											<cp:resourcecontrol runat="server" resourcename="CP_Settings_Email_MG_Accounts_Account_Enabled" ResourceFile="MGResources.xml" /></th>
										<th class="CommonListHeader">
											<cp:resourcecontrol runat="server" resourcename="CP_Settings_Email_MG_Accounts_Account_Actions" ResourceFile="MGResources.xml" /></th>
									</tr>
								</thead>
					</HeaderTemplate>
					<ItemTemplate>
						<tr>
							<td class="CommonListCellLeftMost">
								<%# DataBinder.Eval(Container.DataItem, "Hostname")%>
							</td>
							<td class="CommonListCell">
								<%# DataBinder.Eval(Container.DataItem, "Username")%>
								&nbsp;
							</td>
							<td class="CommonListCell">
								<%# String.Format(@"<img src=""{0}images/{1}.gif"" width=""16"" height=""15"" />", Telligent.Evolution.Components.SiteUrls.Instance().Locations["ControlPanel"], DataBinder.Eval(Container.DataItem,"IsEnabled")) %>
							</td>
							<td class="CommonListCell">
								<TEControl:ModalLink CssClass="CommonTextButton" runat = "Server" Height="300" Width="400" callback="refreshPostCallback" resourcename="Edit" Url = '<%# "MGAccountsForm.aspx?AccountID=" + Container.ItemIndex %>' />
								<TEControl:ModalLink CssClass="CommonTextButton" runat = "Server" Height="150" Width="400" callback="refreshPostCallback" resourcename="Delete" Url = '<%# "SettingsCommand.aspx?Command=Telligent.Evolution.ControlPanel.Settings.DeleteMailAccountCommand,Telligent.Evolution.Web&AccountID=" + Container.ItemIndex %>' />
							</td>
						</tr>
					</ItemTemplate>

					<FooterTemplate>
						</table>
						</div>
					</FooterTemplate>
				</asp:Repeater>
<script type="text/javascript">
// <![CDATA[
    function refreshPostCallback(res) {
		if (res)
			$("form").submit();
	}
// ]]>
</script>