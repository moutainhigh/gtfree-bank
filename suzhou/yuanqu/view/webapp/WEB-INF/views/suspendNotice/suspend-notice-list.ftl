<#list suspendNotices.items as notice>
<ul>
    <li>
        <#if notice.noticeTitle?length lt 20>
            <a href="/zzggnrnew/index.jhtml?noticeId=${notice.noticeId!}" title="" target="_blank">${notice.noticeTitle}</a>
            <span style="float:right;color:#AAAAAA">${notice.deployTime?string("yyyy-MM-dd")}</span>
        <#else>
            <a href="/zzggnrnew/index.jhtml?noticeId=${notice.noticeId!}" title="" target="_blank">${notice.noticeTitle[0..19]}...</a>
            <span style="float:right;color:#AAAAAA">${notice.deployTime?string("yyyy-MM-dd")}</span>
        </#if>
    </li>
</ul>
</#list>