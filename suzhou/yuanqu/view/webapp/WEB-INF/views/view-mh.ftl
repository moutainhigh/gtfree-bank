<!DOCTYPE html>
<html lang="zh-CN">
<head>

    <meta charset="utf-8">
    <title></title>
    <style type="text/css">
        .table_resource{
            width: 512px;
        }
        .table_resource tr{
            height: 27px;
        }
        .info-section{
            padding-left: 20px;
        }
        .value{
            padding-left: 20px;
        }
        .currency{
            font-size: 16px;
        }
        .price-font-small{
            font-size: 26px;
            font-family: 'Microsoft Yahei', 'Hiragino Sans GB', 'Helvetica Neue', Helvetica, tahoma, arial, Verdana, sans-serif, 'WenQuanYi Micro Hei', 宋体;
            font-style: normal;
            font-weight: bold;
        }

        .time em{
            font-weight: 400;
            font-style: normal;
            color: #666;
            font-size: 12px;
            margin-left: 3px;
        }
        .time var{
            font-size: 26px;
            font-style: normal;
            font-weight: bold;
            margin-left: 3px;
        }
        .table-info td{
            padding-top:0px;
        }
        .offer-info{
            padding-top: 0px;
            padding-bottom: 0px;
        }
        .offer-info div{
            margin-bottom:0px;
        }
        .table-price td{
            padding:3px 3px;
        }
        .price-disable{
            background-color: #f3f3f3;
        }
        .table-offer td{
            padding-left:20px;
        }
        .currency{
            font-style: normal !important;
        }
        .table-td-title{
            background-color:#e5e5e5;
            font-weight: bold;
        }
        .info-style{
            margin-bottom: 0px;padding: 0px 20px 0px 10px;height:39px;display: table-cell;vertical-align: middle;width:230px;
        }
        .tooltip{
            background:#FFFFCC;
            position: absolute;
            display: block;
            z-index:99999;
            padding: 5px 10px 5px 10px;
        }
        .progress{-khtml-border-radius:0px;-ms-border-radius:0px;-o-border-radius:0px;-moz-border-radius:0px;-webkit-border-radius:0px;border-radius:0px}
        .sr-only{background-color:#d91615}
    </style>
    <link rel="stylesheet" href="${base}/static/thridparty/leaflet/leaflet.css" />
    <link rel="stylesheet" href="${base}/static/js/dist/view.css" />
    <script type="text/javascript">
        $(function(){
            $("div[class='topbar']").remove();
            $("div[class='banner cl has-dots']").remove();
            var name = $("#owner").text();
            var obj = $("#owner");
            $("#owner").text(setString($.trim(name),$.trim(name).length));
        });

        function setString(str,len){
            var strlen = 0;
            var s = "";
            for(var i = 0;i < str.length;i++){
                if(str.charCodeAt(i)>255){
                    strlen ++;
                    s += str.charAt(i);
                }else{
                    strlen+=2;
                }

                if(strlen >= len){
                    return s ;
                }
            }
            return s;
        }
    </script>
</head>
<body>
<@TopOffer resourceObj=resource maxOfferObj=maxOffer!/>
<div class="wp">
    <nav class="breadcrumb pngfix">
        <i class="iconfont">&#xf012b;</i>
        <a href="http://jsyd.sipac.gov.cn/" class="maincolor">首页</a>
        <span class="c_gray en">&gt;</span><span class="c_gray">${resource.resourceCode!}</span>
    </nav>
    <div class="row" style="border: 1px solid #eeecec;overflow: auto">
        <div class="col-10">
            <div class="row cl" style="padding:0px 10px">
                <h3 style="width:500px">${resource.resourceCode!}</h3>
            </div>
            <div class="row cl">
                <div class="col-5" style="padding-left: 10px">
                    <div style="border: none;overflow: hidden;clear: none!important;">
                        <div class="picbox">
                            <div id="featured">
                            <#list thumbnails as item>
                                <div class="image" id="image_pic-0${item_index+1}">
                                    <img class="imageItem" src="${base}/${item}" onerror="this.src='${base}/static/image/blank.jpg'"  width="402" height="320">
                                </div>
                            </#list>
                            </div>
                            <div id="thumbs">
                                <ul>
                                    <li id="play_prev" class="iconfont">&#xf016e;</li>
                                <#list thumbnails as item>
                                    <li class="slideshowItem"><a id="thumb_pic-0${item_index+1}" href="javascript:" <#if item_index==0>class="current"</#if> ><img src="${base}/${item}" width="78" height="37" onerror="this.src='${base}/static/image/blank.jpg'"></a></li>
                                </#list>
                                    <li id="play_next" class="iconfont" style="float: right">&#xf016d;</li>
                                </ul>
                                <div class="clear"></div>
                            </div>
                            <script type="text/javascript">
                                var target = ["pic-01","pic-02","pic-03","pic-04"];
                            </script>
                        </div>
                    </div>

                </div>
                <div class="col-7">
                    <div class="row cl" style="min-height:200px;">
                        <table class="table table-offer" style="-moz-user-select:none;" onselectstart="return false">
                            <tbody>
                            <#include "common/view-offer.ftl">
                            </tbody>
                        </table>
                    </div>
                    <div class="row cl" style="padding: 5px 20px;">
                        <table class="table table-info">
                            <tr>
                                <td>
                                    <span class="title">起始价：</span>
                                    <span class="current-price">¥${resource.beginOffer!}&nbsp;万元</span>
                                </td>
                                <td>
                                    <span class="title">加价幅度：</span>
                                    <span>¥${resource.addOffer!}&nbsp;万元</span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="title">出让面积：</span>
                                    <span>${resource.crArea!}平方米</span>
                                </td>
                                <td>
                                    <span class="title">保证金：</span>
                                    <span>${resource.fixedOffer!}万元<#if resource.fixedOfferUsd?? && resource.fixedOfferUsd &gt; 0>，&nbsp;${resource.fixedOfferUsd?string(",##0.######")}万美元</#if><#if resource.fixedOfferHkd?? && resource.fixedOfferHkd &gt; 0>，&nbsp;${resource.fixedOfferHkd?string(",##0.######")}万港币</#if></span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="title">挂牌开始时间：</span>
                                    <span>${resource.gpBeginTime?string("yyyy-MM-dd HH:mm")}</span>
                                </td>
                                <td>
                                    <span class="title">挂牌截止时间：</span>
                                    <span>${resource.gpEndTime?string("yyyy-MM-dd HH:mm")}</span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="title">报名开始时间：</span>
                                    <span>${resource.bmBeginTime?string("yyyy-MM-dd HH:mm")}</span>
                                </td>
                                <td>
                                    <span class="title">报名截止时间：</span>
                                    <span>${resource.bmEndTime?string("yyyy-MM-dd HH:mm")}</span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="title">交纳保证金开始时间：</span>
                                    <span>${resource.bzjBeginTime?string("yyyy-MM-dd HH:mm")}</span>
                                </td>
                                <td>
                                    <span class="title">交纳保证金截止时间：</span>
                                    <span>${resource.bzjEndTime?string("yyyy-MM-dd HH:mm")}</span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="title">规划用途：</span>
                                <span>
                                <#if landUseList?? && (landUseList?size > 0)>
                                    <#list landUseList as landUse>

                                        <#if !landUse_has_next>
                                            <@LandUseListConvert selectValue= landUse! />用地
                                        <#else>
                                            <@LandUseListConvert selectValue= landUse! />,
                                        </#if>
                                    </#list>
                                <#else>
                                    <@LandUseConvert selectValue= resource.landUse.getCode()! />
                                </#if>
                                </span>
                                </td>
                                <td>
                                    <span class="title">最高限价：</span>
                                <span>
                                <#if resource.maxOffer?? && resource.maxOffer gt 0>
                                ${resource.maxOffer}万元
                                <#else>
                                    无
                                </#if>
                                </span>
                                </td>
                            </tr>
                        <#if resource.maxOffer?? && resource.maxOffer gt 0>
                            <tr>
                                <td>
                                    <span class="title">起始公租房：</span>
                                <span>
                                ${resource.beginHouse}<#if resource.publicHouse?? && resource.publicHouse==1 >万元（资金）<#else>平方米（面积）</#if>
                                </span>
                                </td>
                                <td>
                                    <span class="title">公租房增幅：</span>
                                <span>
                                ${resource.addHouse}<#if resource.publicHouse?? && resource.publicHouse==1 >万元（资金）<#else>平方米（面积）</#if>
                                </span>
                                </td>
                            </tr>
                        </#if>
                        <#if resource.resourceStatus==30 || resource.resourceStatus==31>
                            <#assign minPrice=PriceUtil.getMinPriceByResourceId(resource.resourceId)/>
                            <#if minPrice gt 0>
                                <tr>
                                    <td>
                                        <span class="title">底价：</span>
                                    <span>
                                    ${minPrice}万元
                                    </span>
                                    </td>
                                    <td>
                                        <span class="title"></span>
                                    <span>
                                    </span>
                                    </td>
                                </tr>
                            </#if>
                        </#if>
                        </table>
                    </div>
                </div>
            </div>

        </div>
        <div class="col-2 cl" style="border-left: 1px solid #e9e9e9;height: 495px;
                background: url(${base}/static/image/price-back.png) repeat-x 0 0 #fff;padding:0px 0px 0px 5px;">
            <h5 style="border-bottom: 1px solid #eeecec;line-height:40px">竞买记录<span></h5>
            <table class="table table-price">
                <thead>
                <tr>
                    <td style="width:65px;">状态</td>
                    <td style="width:45px;">号牌</td>
                    <td>报价</td>
                </tr>
                </thead>
                <tbody>
                <input type="hidden" id="offerCount" value="${maxoffercount!}"/>
                <#list resourceOffers as resourceOffer>
                <tr>
                    <td>
                        <#if resourceOffer_index==0>
                            <span class="label label-danger label-max">领先</span>
                        <#else>
                            <span>第${resourceOffer.offerCount}轮</span>
                        </#if>
                    </td>
                    <td >
                        <span>---</span>
                    <#--${resourceOffer.applyNumber!}号-->
                    </td>
                    <td>${resourceOffer.offerPrice}
                        <#if resourceOffer.offerType==2 && resource.publicHouse?? && resource.publicHouse==0>
                            平米<i class="iconfont" style="font-size:10px">&#xf012b;</i>
                        <#elseif resourceOffer.offerType==2 && resource.publicHouse?? && resource.publicHouse==1>
                            万<i class="iconfont" style="font-size:10px">&#xf012b;</i>
                        <#else>
                            万
                        </#if>
                    </td>
                </tr>
                </#list>
                </tbody>
            </table>
            <script id="tpl_offer0" type="text/html">
                <tr>
                    <td>
                        <span class="label label-danger label-max">领先</span>
                    </td>

                    <td>
                        <span>---</span>
                        <#--{{ d.applyNumber }}号-->
                    </td>
                    <td>{{ d.offerPrice }}
                        {{# if(d.offerType==2){ }}
                    <#if resource.publicHouse?? && resource.publicHouse==0>平米<#else>万</#if><i class="iconfont" style="font-size:10px">&#xf012b;</i>
                        {{# }else{ }}
                        万
                        {{# } }}
                    </td>
                </tr>
            </script>
            <script id="tpl_offer1" type="text/html">
                <tr>
                    <td>
                        <span>---</span>
                    </td>
                    <td>
                        <span>---</span>
                        <#--{{ d.applyNumber }}号-->
                    </td>
                    <td>{{ d.offerPrice }}
                        万</td>
                </tr>
            </script>
            <script id="tpl_beginoffer" type="text/html">
                <div style="text-align: center">
                    <p style='color: #d91615;font-size: 20px'>小写：{{ d.offer }}万元</p>
                    <p style='color: #d91615;font-size: 20px'>大写：{{ d.offerChinese }}元整</p>
                </div>
            </script>
            <script id="tpl_beginoffer_top" type="text/html">
                <div style="text-align: center">
                    <p style='color: #d91615;font-size: 20px'>小写：{{ d.offer }}万元 &nbsp;&nbsp;&nbsp;&nbsp; 公租房：{{ d.housePrice }}<#if resource.publicHouse?? && resource.publicHouse==1 >万元<#else>平方米</#if></p>
                    <p style='color: #d91615;font-size: 20px'>大写：{{ d.offerChinese }}元整</p>
                </div>
            </script>
           <#-- <script id="tpl_tooltip" type="text/html">
                <div class="tooltip" >

                <span>溢价：{{ d.over }}%
                平均地价：{{ d.price1 }}元/平方米-{{ d.price2 }}万元/亩</span>
                </div>
            </script>-->
            <#--<script id="tpl_tooltip" type="text/html">
                <div id="tooltip" >
                <span>溢价：{{ d.over }}%
                平均地价：{{ d.price1 }}元/平方米</span>
                </div>
            </script>-->

        </div>
    </div>
<#include "common/help.ftl">
<#include "common/view-desc.ftl">
</div>

<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-header">
        <h4 id="myModalLabel"><i class="icon-warning-sign"></i>出价确认对话框</h4><a class="close" data-dismiss="modal" aria-hidden="true" href="javascript:void();">×</a>
    </div>
    <div class="modal-body">
        <p id="modal_content">对话框内容…</p>
    </div>
    <div class="modal-footer">
        <button class="btn btn-primary" id="btn_modal" onclick="javascript:postOffer();">确定</button> <button class="btn" data-dismiss="modal" aria-hidden="true">关闭</button>
    </div>
</div>

<div id="myModalLimit" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-header">
        <h4 id="myModalLabel"><i class="icon-warning-sign"></i>参与限时竞价确认对话框</h4><a class="close" data-dismiss="modal" aria-hidden="true" href="javascript:void();">×</a>
    </div>
    <div class="modal-body">
        <p id="modal_content2">您是否确认参加限时竞价！</p>
    </div>
    <div class="modal-footer">
        <button class="btn btn-primary" id="btn_modal" onclick="javascript:confirmLimit('${resource.resourceId}');">确定</button> <button class="btn" data-dismiss="modal" aria-hidden="true">关闭</button>
    </div>
</div>

<div id="myModalRefresh" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-body">
        <p id="modal_refresh">
        <div style="text-align: center">
            <p style="font-size:26px;font-weight:700" id="refreshValue">3</p>
        </div>
        </p>
    </div>
</div>

<div id="myModalError" class="modal hide fade" tabindex="-1">
    <div class="modal-body">
        <span style="font-size:16px">离开时间太久，请重新刷新页面！</span>
        <a href="javascript:window.location.reload();" class="btn btn-primary">刷新页面</a>
        <a href="javascript:windows.close();" class="btn btn-danger">关闭页面</a>
    </div>
</div>
    <#assign mapUrl=WebUtil.getMapUrl()/>
    <input type="hidden" id="mapUrl" value="${mapUrl!}">
    <input type="hidden" id="resourceCodeSecret" value="${resourceCodeSecret!}">
    <input type="hidden" id="crArea" value="${resource.crArea!}">
    <input type="hidden" id="offer0" value="${resource.beginOffer}">
    <input type="hidden" id="resourceStatus" value="${resource.resourceStatus}">
    <input type="hidden" id="resourceId" value="${resource.resourceId}">
    <input type="hidden" id="maxOfferPrice" value="<#if maxOfferPrice??>${maxOfferPrice.offerPrice!}</#if>">

<#if isTopOffer?? && isTopOffer>

    <input type="hidden" id="addOffer" value="${resource.addHouse}">
    <input type="hidden" id="beginOffer" value="${resource.beginHouse}">
    <input type="hidden" id="topOffer" value="0">
    <#if (maxOffer??)&&maxOffer.offerType==2>
        <input type="hidden" id="maxOffer" value="${maxOffer.offerPrice}">
        <input type="hidden" id="maxOfferTime" value="${maxOffer.offerTime?long}">
    <#else>
        <input type="hidden" id="maxOffer" value="0">
        <input type="hidden" id="maxOfferTime" value="${.now?long}">
    </#if>
    <input type="hidden" id="maxOfferType" value="2">
<#else>
    <input type="hidden" id="addOffer" value="${resource.addOffer}">
    <input type="hidden" id="beginOffer" value="${resource.beginOffer}">
    <input type="hidden" id="topOffer" value="${resource.maxOffer!}">
    <#if maxOffer??>
        <input type="hidden" id="maxOffer" value="${maxOffer.offerPrice}">
        <input type="hidden" id="maxOfferTime" value="${maxOffer.offerTime?long}">
        <input type="hidden" id="maxOfferType" value="${maxOffer.offerType!}">
    <#else>
        <input type="hidden" id="maxOffer" value="0">
        <input type="hidden" id="maxOfferTime" value="${.now?long}">
    </#if>
</#if>
    <#--<script type="text/javascript" src="${base}/static/js/slide.js"></script>
    <script type="text/javascript" src="${base}/static/js/index.js"></script>
    <script type="text/javascript" src="${base}/static/js/view.js"></script>
    <script type="text/javascript" src="${base}/static/thridparty/H-ui.2.0/lib/bootstrap-modal.js"></script>
    <script type="text/javascript" src="${base}/static/thridparty/H-ui.2.0/lib/bootstrap-modalmanager.js"></script>
    <script type="text/javascript" src="${base}/static/thridparty/laytpl/laytpl.js"></script>-->

    <script type="text/javascript" src="${base}/static/js/dist/view.js"></script>


</body>
</html>