<%@ Page Async="true" language="c#" Codebehind="AdvancedConfiguration.aspx.cs" AutoEventWireup="false" Inherits="Telligent.Evolution.ControlPanel.Settings.AdvancedConfiguration" MasterPageFile="~/ControlPanel/Masters/Embedded.master" %>
<%@ Register TagPrefix="CP" Namespace="Telligent.Evolution.ControlPanel.Controls" Assembly="Telligent.Evolution.Web" %>
<%@ Register TagPrefix="CS" Namespace="Telligent.Evolution.Controls" Assembly="Telligent.Evolution.Platform" %>
<%@ Register TagPrefix="TWC" Namespace="Telligent.Glow" Assembly="Telligent.Glow" %>

<asp:Content ContentPlaceHolderId="TaskRegion" runat="Server">
    <cp:controlpanelselectednavigation selectednavitem="AdvancedConfiguration" runat="server" />
    <div class="<%= Telligent.Evolution.Web.ControlPanel.Components.StaticVariables.LicenseRestrictionClass %>">
	    <CP:statusmessage id="Status" runat="server"></CP:statusmessage>

	                <TABLE cellSpacing="0" cellPadding="4" border="0">
                        <asp:PlaceHolder id="RssNotAllowedLicensingHolder" runat="Server">
							<tr>
								<td class="CommonFormFieldName">&nbsp;</td>
								<td class="CommonFormField"><cp:resourcecontrol id="RssNotAllowedLicensing" visible="false" runat="server" Tag="div" CssClass="CommonLicenseRestrictionMessage" resourcename="CP_Settings_RssNotAllowedLicensing" /></td>
							</tr>
						</asp:PlaceHolder>
			            <TR>
				            <TD class="CommonFormFieldName">
					            <strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_RSS_Secure" /></strong><br />
					            <cp:resourcecontrol runat="Server" resourcename="CP_Settings_RSS_Secure_Descr" />
					        </TD>
				            <TD class="CommonFormField" noWrap>
					            <cp:yesnoradiobuttonlist id="SecureRss" runat="server" repeatcolumns="2" cssclass="ControlPanelTextInput"></cp:yesnoradiobuttonlist></TD>
			            </TR>
			            <TR>
				            <TD class="CommonFormFieldName">
					            <strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_RSS_Search" /></strong><br />
					            <cp:resourcecontrol runat="Server" resourcename="CP_Settings_RSS_Search_Descr" />
					        </TD>
				            <TD class="CommonFormField" noWrap>
					            <cp:yesnoradiobuttonlist id="RssSearch" runat="server" repeatcolumns="2" cssclass="ControlPanelTextInput"></cp:yesnoradiobuttonlist></TD>
			            </TR>
                        <TR>
				            <TD class="CommonFormFieldName">
					            <strong><cp:resourcecontrol runat="server" resourcename="Admin_Settings_RSS_MaxNumOfFeeds" /></strong><br />
					            <cp:resourcecontrol runat="Server" resourcename="Admin_Settings_RSS_MaxNumOfFeeds_Descr" />
					        </TD>
		                    <TD class="CommonFormField">
			                    <asp:textbox id="MaxNumOfRssFeeds" runat="server"  maxlength="2" />
			                    <asp:requiredfieldvalidator id="MaxRssFeedsPerUserValidator" runat="server" controltovalidate="MaxNumOfRssFeeds" font-bold="True" errormessage="*" />
								<asp:RangeValidator ID="MaxRssFeedsPerUserRangeValidator" runat="server" ControlToValidate="MaxNumOfRssFeeds"    Display="Dynamic" Type="Integer" MinimumValue="1" MaximumValue="20"></asp:RangeValidator>
							</TD>
			            </TR>


                <tr>
		            <td colspan="2">
		                <div class="CommonFormFieldName">
                            <strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_SiteContent_AdditionalHttpHeaders"/></strong>
                            <br />
    			            <cp:resourcecontrol runat="server" resourcename="CP_Settings_SiteContent_AdditionHttpHeaders_Descr" />
                        </div>

                        <div class="CommonFormField">
                            <asp:textbox class="ControlPanelTextInput" id="HttpHeaders" runat="server" columns="55" textmode="Multiline" rows="6" />
                        </div>
		            </td>
	            </tr>
				<tr>
		            <td colspan="2">
		                <div class="CommonFormFieldName">
                            <strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_SiteContent_AdditionHeaderTop"/></strong>
                            <br />
    			            <cp:resourcecontrol runat="server" resourcename="CP_Settings_SiteContent_AdditionHeaderTop_Descr" />
                        </div>

                        <div class="CommonFormField">
                            <CS:CodeStringControl id="GenericHeaderTop" runat="server" Language="html" MinLines="5" MaxLines="20" />
                        </div>
		            </td>
	            </tr>
				<tr>
		            <td colspan="2">
		                <div class="CommonFormFieldName">
                            <strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_SiteContent_AdditionHeader"/></strong>
                            <br />
    			            <cp:resourcecontrol runat="server" resourcename="CP_Settings_SiteContent_AdditionHeader_Descr" />
                        </div>

                        <div class="CommonFormField">
                            <CS:CodeStringControl id="GenericHeader" runat="server" Language="html" MinLines="5" MaxLines="20" />
                        </div>
		            </td>
	            </tr>
				<tr>
		            <td colspan="2">
		                <div class="CommonFormFieldName">
                            <strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_SiteContent_AfterBodyTag"/></strong>
                            <br />
    			            <cp:resourcecontrol runat="server" resourcename="CP_Settings_SiteContent_AfterBodyTag_Descr" />
                        </div>

                        <div class="CommonFormField">
                            <cs:CodeStringControl  id="AfterBodyTag" runat="server" Language="html" MinLines="5" MaxLines="20" />
                        </div>
		            </td>
	            </tr>
	            <tr>
		            <td colspan="2">
		                <div class="CommonFormFieldName">
                            <strong><cp:resourcecontrol runat="server" resourcename="CP_Settings_SiteContent_GoogleAnalytics"/></strong>
                            <br />
    			            <cp:resourcecontrol runat="server" resourcename="CP_Settings_SiteContent_GoogleAnalytics_Descr" />
                        </div>

                        <div class="CommonFormField">
                            <cs:CodeStringControl  id="GoogleAnalytics" runat="server" Language="html" MinLines="5" MaxLines="20" />
                        </div>
		            </td>
	            </tr>


		            </TABLE>


	    <p class="PanelSaveButton DetailsFixedWidth">
		    <cp:resourcelinkbutton id="SaveButton" runat="server" resourcename="Save" cssclass="CommonTextButton" />
        </p>
    </div>
</asp:Content>