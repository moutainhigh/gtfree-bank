<tr class="price">
<#if resource.resourceStatus==1 || resource.resourceStatus==2 || resource.resourceStatus==10>
<td width="51">当前价</td>
<td class="value" style="color: #d91615;">
     <em class="currency" >¥</em>
     <em class="price-font-small" id="priceInfo">
         <#if maxOfferPrice??>
         ${maxOfferPrice.offerPrice}
         <#else>
         ${resource.beginOffer}
         </#if>
     </em>万
    <#if isTopOffer?? && isTopOffer>
    <em style="margin-left: 30px;color: #7a7a7a;font-style: normal">
    公租房<#if resource.publicHouse?? && resource.publicHouse==1 >资金<#else>面积</#if>
    </em>
    <em class="price-font-small" style="margin-left: 10px;" id="priceHouseInfo">
        <#if maxOffer?? && maxOffer.offerType==2>
        ${maxOffer.offerPrice}
        <#else>
        ${resource.beginHouse}
        </#if>
    </em>
        <#if resource.publicHouse?? && resource.publicHouse==1 >万<#else>平方米</#if>
    </#if>
 </td>
<#elseif resource.resourceStatus==30 >
<td width="51">成交价</td>
<td class="value" style="color: #777;">
     <em class="currency">¥</em>
     <em class="price-font-small" id="priceInfo">${successOffer.offerPrice}</em>万元
     <#if isTopOffer?? && isTopOffer>
        <#if maxOffer?? && maxOffer.offerType==2>
        <em style="margin-left: 30px;color: #7a7a7a;font-style: normal">
            公租房<#if resource.publicHouse?? && resource.publicHouse==1 >资金&nbsp;&nbsp;<em class="currency">¥</em><#else>面积&nbsp;&nbsp;</#if>
        </em>
        <em class="price-font-small">
        ${successOffer.offerPrice}</em><#if resource.publicHouse?? && resource.publicHouse==1 >万元<#else>平方米</#if>
        </#if>
    </#if>
 </td>
<#elseif resource.resourceStatus==20>
<td width="51">起始价</td>
<td class="value" style="color: #5eb95e;">
     <em class="currency">¥</em>
     <em class="price-font-small" id="priceInfo">${resource.beginOffer}</em>万
 </td>
<#else>
<td width="51">起始价</td>
<td class="value" style="color: #777;">
    <em class="currency">¥</em>
    <em class="price-font-small" id="priceInfo">${resource.beginOffer}</em>万
</td>
</#if>
</tr>
<#if resource.resourceEditStatus==2 || resource.resourceEditStatus==9>
<tr>
    <#if resource.resourceStatus==20><#-- 如果是公告阶段-->
    <td>距开始</td>
    <td class="value">
        <span class="time" id="span_${resource.resourceId}" value="${resource.gpBeginTime?long}"></span>
     </td>
    <#elseif resource.resourceStatus==10><#-- 如果是挂牌阶段-->
    <td>距结束</td>
    <td class="value" >
        <span class="time" id="span_${resource.resourceId}" value="${resource.gpEndTime?long}"></span>
    </td>
    <#elseif resource.resourceStatus==1> <#-- 如果是限时竞价阶段-->
        <td>距结束</td>
        <td class="value" >
            <span class="time" id="span_${resource.resourceId}" value="${endTime!}"></span>
            <div style="float: right;color: #d91615;display: none" id="oneminuteInfo">
                竞拍即将结束！
            </div>
            <div class="progress" style="width:470px;display: none" id="oneminuteProgress">
                <div class="progress-bar"><span class="sr-only" style="width:100%"></span></div>
            </div>
        </td>
    <#else>
    <td>结束时间</td>
    <td class="value" >
        ${resource.overTime?string("yyyy-MM-dd HH:mm:ss")}
    </td>
    </#if>
</tr>
</#if>
<#assign bgclass="">

<#--判断是否结束 -->
<#if resource.resourceStatus==30 || resource.resourceStatus==31 || resource.resourceEditStatus==3
|| resource.resourceEditStatus==4>
    <#include "view-over.ftl">
<#elseif resource.resourceStatus==20>
<tr class="price price-disable">
    <td colspan="2" style="line-height: 140px;text-align: center;font-size:20px;font-weight:700" >

        <span style="height:25px;line-height:25px">正在公告！</span>
    </td>
</tr>
<#elseif resource.resourceStatus==10 || resource.resourceStatus==1>
    <#if (((resource.gpEndTime?long)-(.now?long)) lt 1000*60*60) && (((resource.gpEndTime?long)-(.now?long)) gt 0)>
    <tr class="price price-disable">
        <td colspan="2" style="line-height: 140px;text-align: center;font-size:14px;font-weight:700" >

            <span style="height:25px;line-height:25px"> 挂牌截止前1小时停止报价，挂牌截止时间后进入4分钟限时竞价！</span>
        </td>
    </tr>
    <#elseif (((resource.gpEndTime?long)-(.now?long)) lt 0)>
    <tr class="price price-disable">
        <td colspan="2" style="line-height: 140px;text-align: center;font-size:20px;font-weight:700" >
            <span style="height:25px;line-height:25px">正在挂牌，限时竞价阶段！</span>
        </td>
    </tr>
    <#else >
    <tr class="price price-disable">
        <td colspan="2" style="line-height: 140px;text-align: center;font-size:20px;font-weight:700" >
            <span style="height:25px;line-height:25px">正在挂牌<#if isTopOffer?? && isTopOffer>，公租房竞价阶段</#if>！</span>
        </td>
    </tr>
    </#if>

</#if>




