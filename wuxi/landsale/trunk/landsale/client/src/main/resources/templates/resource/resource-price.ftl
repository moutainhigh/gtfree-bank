<#--地块发布或者结束-->
<#if resource.resourceEditStatus==2 || resource.resourceEditStatus==9>
<#--竞价期或挂牌期-->
    <#if resource.resourceStatus==1 || resource.resourceStatus==10 || resource.resourceStatus==11>
    <p>当前价</p>
        <#assign maxOffer=PriceUtil.getMaxOffer(resource.resourceId)! />
    <#--<#if maxOffer.offerType?? && maxOffer.offerType!=2>
        <em class="currency">¥</em>
    </#if>-->
    <span class="span_strong" style="color: #d91615;">
            <#if maxOffer.offerType??>
            ${maxOffer.offerPrice}
            <#else>
            ${resource.beginOffer}
            </#if>
        <label class="offer_unit"><@unitText offerUnit = resource.offerUnit/></label>
        </span>
    <#--已成交-->
    <#elseif resource.resourceStatus==30 >
    <#--判断是否通过审核-->
        <#assign resouerceVerify = ResourceUtil.getTransResourceVerify(resource.resourceId)!/>
    <!--获取成交审核信息-->
        <#if resouerceVerify != null>
        <!--审核通过-->
            <#if resouerceVerify.verifyStatus == 1>
                <#assign successPrice = PriceUtil.getSuccessOffer(resource.offerId)/>
                <#if resource.maxOfferChoose.code == 1 && successPrice.offerType == -1>
                <p>成交价</p>
                <span class="span_strong" style="color: #777;">
                         ${successPrice.offerPrice}<label class="offer_unit">万元（总价）</label>
                    </span>
                <#else>
                <p>成交价</p>
                <span class="span_strong" style="color: #777;">
                         ${successPrice.offerPrice}<label class="offer_unit"><@unitText offerUnit = resource.offerUnit/></label>
                    </span>
                </#if>
            <#else>
            <p>起始价</p>
            <span class="span_strong" style="color: #5eb95e;">
                    ${resource.beginOffer}<label class="offer_unit"><@unitText offerUnit = resource.offerUnit/></label>
                </span>
            </#if>
        <#else>
        <p>起始价</p>
        <span class="span_strong" style="color: #5eb95e;">
                 ${resource.beginOffer}<label class="offer_unit"><@unitText offerUnit = resource.offerUnit/></label>
             </span>
        </#if>
    <#--公告期-->
    <#elseif resource.resourceStatus==20>
    <p>起始价</p>
    <span class="span_strong" style="color: #5eb95e;">
             ${resource.beginOffer}<label class="offer_unit"><@unitText offerUnit = resource.offerUnit/></label>
         </span>
    <#--流拍-->
    <#elseif resource.resourceStatus==31>
    <p>起始价</p>
    <span class="span_strong" style="color: #777;">
             ${resource.beginOffer}<label class="offer_unit"><@unitText offerUnit = resource.offerUnit/></label>
         </span>
    </#if>
<#else>
<p>起始价</p>
<span class="span_strong" style="color: #777;">
        <#--<em class="currency">¥</em>-->
        ${resource.beginOffer}<label class="offer_unit"><@unitText offerUnit = resource.offerUnit/></label>
    </span>
</#if>
