<form class="navbar-form" id="frmSearch">
<#list suspendNotices.items as notice>
    <ul>
        <li>
            <#if notice.noticeTitle?length lt 30>
                <a href="/zzggnr/index.jhtml?noticeId=${notice.noticeId!}" title="" target="_blank">${notice.noticeTitle}</a>
                <span style="float:right;color:#AAAAAA">${notice.deployTime?string("yyyy-MM-dd")}</span>
            <#else>
                <a href="/zzggnr/index.jhtml?noticeId=${notice.noticeId!}" title="" target="_blank">${notice.noticeTitle[0..29]}...</a>
                <span style="float:right;color:#AAAAAA">${notice.deployTime?string("yyyy-MM-dd")}</span>
            </#if>
        </li>
    </ul>
</#list>
</form>
<div class="pageNav">
<@PageHtml pageobj=suspendNotices formId="frmSearch" />
</div>