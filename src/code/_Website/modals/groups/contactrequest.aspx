<%@ Page Async="true" EnableViewState="false" Language="C#" AutoEventWireup="true" MasterPageFile="~/modals/modal.Master" %>
<%@ Import Namespace="Telligent.Evolution.Components" %>
<%@ Import Namespace="Telligent.Evolution.Controls" %>
<%@ Import Namespace="Telligent.Evolution.Components" %>

<script runat="server">

    protected static readonly ISecurityService SecurityService = Telligent.Evolution.Platform.Internal.PlatformServices.Locator.Get<ISecurityService>();

    protected override void OnPreInit(EventArgs e)
    {
        CSContext csContext = CSControlUtility.Instance().GetCurrentCSContext(this.Page);
        var group = CSControlUtility.Instance().GetCurrentGroup(this) ?? Groups.GroupService.GetRootGroup();
        if (!SecurityService.For(group).Does(csContext.User).Have(GroupPermission.ModifyMembership))
        {
           throw new AccessDeniedException(null, @group.Name, GroupPermission.ModifyMembership);
        }

        base.OnPreInit(e);
    }

</script>

<asp:Content ContentPlaceHolderID="content" runat="server">

    <TEControl:Title runat="server" IncludeSiteName="false" EnableRendering="false">
        <ContentTemplate><TEControl:GroupContactRequestData runat="server" Property="Subject" /></ContentTemplate>
    </TEControl:Title>

    <script type="text/javascript">
        function confirmRequestDelete()
        {
            return window.confirm('Are you sure you want to delete this contact request?');
        }
    </script>

    <div class="full-post-header"></div>
	<div class="full-post">
		<TEControl:GroupContactRequestData runat="server" Property="Subject" Tag="H1" CssClass="post-name" />
		<div class="post-author">
			<TEControl:GroupContactRequestData runat="server" Tag="Span" Property="Name" LinkTo="MailTo" CssClass="user-name" LinkCssClass="internal-link send-email" />
		</div>
		<TEControl:GroupContactRequestData runat="server" Property="Body" CssClass="post-content user-defined-markup" />
		<div class="post-date">
			<span class="label"></span>
			<span class="value"><TEControl:GroupContactRequestData runat="server" Property="CreationDate" /></span>
		</div>
		<div class="post-attributes">
			<div class="attribute-list-header"></div>
				<ul class="attribute-list">
					<TEControl:ConditionalContent runat="server">
						<ContentConditions>
							<TEControl:GroupContactRequestPropertyValueComparison runat="server" ComparisonProperty="IsModerated" Operator="IsSetOrTrue" />
						</ContentConditions>
						<TrueContentTemplate>
							<li class="attribute-item post-moderated-true">
								<span class="attribute-name"></span>
								<span class="attribute-value"><TEControl:ResourceControl runat=server ResourceName="Groups_ContactRequests_PossibleSpamNotEmailed" /></span>
							</li>
						</TrueContentTemplate>
						<FalseContentTemplate>
							<li class="attribute-item post-moderated-false">
								<span class="attribute-name"></span>
								<span class="attribute-value"><TEControl:ResourceControl runat=server ResourceName="Groups_ContactRequests_MessageEmailed" /></span>
							</li>
						</FalseContentTemplate>
					</TEControl:ConditionalContent>
				</ul>
			<div class="attribute-list-footer"></div>
		</div>
		<div class="post-actions">
			<div class="field-list-header"></div>
            <fieldset class="field-list">
				<ul class="field-list">
				<TEControl:ApproveDeleteGroupContactRequestForm runat="server" ApproveButtonId="ApproveRequest" DeleteButtonId="DeleteRequest">
					<SuccessActions>
						<TEControl:RefreshPageAction runat="server" WindowNameScript="window.parent.Telligent_Modal.GetWindowOpener(window)" />
					</SuccessActions>
					<FormTemplate>
						<li class="field-item">
							<span class="field-item-input">
								<asp:LinkButton runat="server" ID="DeleteRequest" OnClientClick="return confirmRequestDelete();" CssClass="internal-link deny-contact-request submit-form"><span></span><TEControl:ResourceControl runat="server" ResourceName="Delete" /></asp:LinkButton>
								<asp:LinkButton runat="server" ID="ApproveRequest" CssClass="internal-link approve-contact-request submit-form"><span></span><TEControl:ResourceControl runat="server" ResourceName="Approve" /></asp:LinkButton>
							</span>
						</li>
					</FormTemplate>
				</TEControl:ApproveDeleteGroupContactRequestForm>
			</ul>
            </fieldset>
            <div class="field-list-footer"></div>
		</div>
	</div>
	<div class="abbreviated-post-footer"></div>

</asp:Content>