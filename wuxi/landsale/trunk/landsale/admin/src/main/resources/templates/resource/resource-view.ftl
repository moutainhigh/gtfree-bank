<html>
<head>
    <title>-出让地块</title>
    <meta name="menu" content="menu_admin_resourcelist"/>
    <link rel="stylesheet" href="${base}/tree/zTreeStyle/zTreeStyle.css" type="text/css">
    <style type="text/css">
        .title-info {
            width: 100%;
            height: 90px;
            position: relative;
            top: 18px;
            padding-right: 10px;
        }
        .title-info h1, .title-info h3 {
            margin: 0;
            padding: 0 0 0 20px;
            font-family: "Microsoft Yahei";
            font-weight: 400;
        }
        .btn-upload{ position: relative;display: inline-block;overflow: hidden; vertical-align: middle; cursor: pointer;}
        .upload-url{ width: 200px;cursor: pointer;}
        .input-file{ position:absolute; right:0; top:0; cursor: pointer; font-size:17px;opacity:0;filter: alpha(opacity=0)}
        .uploadifive-button{
            display: block;
            width: 60px;
            height: 65px;
            background: #fff url(${base}/thridparty/H-ui.1.5.6/images/icon-add.png) no-repeat 0 0;
            text-indent: -99em;
        }
        .btn-upload input{
            height:55px;
            cursor: pointer;
        }
        .image{
            padding-right:5px;
            float: left;
        }
        .image:hover{
            cursor: pointer;
        }
        .image a{
            position: relative;
            top:-30px;
            filter: alpha(opacity=0);
            opacity: 0;

        }
        .image:hover a{
            filter: alpha(opacity=100);
            opacity: 1;
        }
        .unit_span{
            font-size:10px;
            font-style:italic;
            color: #f4523b;
        }
        .minOfferInfo{
            font-size:10px;
            font-style:italic;
            color: #f4523b;
        }
        .unit_house{
            font-size:10px;
            font-style:italic;
            color: #f4523b;
        }
        .error_input{
            background-color: #FFFFCC;
        }
        #attachmentsTitle{width:100px;float:left}
        #attachments{width: 500px;float: left;overflow:hidden;text-overflow-ellipsis: '..';}
        #attachmentsOperation{float: right}

        .upload-progress-bar{
            display: none;
            width: 400px;
            margin-top: 5px;
        }

    </style>
    <script type="text/javascript" src="${base}/thridparty/H-ui.2.0/lib/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${base}/thridparty/fileupload/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="${base}/thridparty/fileupload/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="${base}/thridparty/fileupload/jquery.fileupload.js"></script>
    <script type="text/javascript" src="${base}/layer/layer.js"></script>
    <script type="text/javascript" src="${base}/tree/js/jquery.ztree.core.js"></script>
    <script type="text/javascript" src="${base}/tree/js/jquery.ztree.excheck.js"></script>
    <script type="text/javascript">
        //土地用途
        var tdytSetting = {
            check: {
                enable: true,
                chkStyle: "checkbox",
                chkboxType: {"Y": "", "N": "" }
            },
            view: {
                dblClickExpand: false
            },
            data: {
                simpleData : {
                    enable : true
                }
            },
            callback: {
//                beforeCheck: beforeTdytClick,
                onCheck: onTdytClick
            }
        };

        $(document).ready(function(){
            $('#btnSubmit').click(function(){
                var menuIds = "";
                $('input[type=checkbox][class=resource]:checked').each(function(){
                    if ("" == menuIds) {
                        menuIds = $(this).val();
                    } else {
                        menuIds += "," + $(this).val();
                    }
                });
            });
            $.ajax({
                type: "post",
                dataType: "json",
                data: {regionCode: '${regionCodes!}', tdytDictCode: '${transFloorPriceView.tdytDictCode!}'},
                url: "${base}/resource/getLandUseDictTree",
                success: function (data) {
                    if (data != null) {
                        $.fn.zTree.init($("#treeTdyt"), tdytSetting, data);
                    }
                }
            });
        });


        //  点击地块用途菜单执行事件
        function beforeTdytClick(treeId, treeNode) {
            var check = (treeNode && !treeNode.isParent);
            if (!check) alert("只能选择一个用途...");
            return check;
        }

        function onTdytClick(e, treeId, treeNode) {
            var zTree = $.fn.zTree.getZTreeObj("treeTdyt"),
                    nodes = zTree.getCheckedNodes(true),
                    tdytCode = "",
                    tdytName = "";
            if (nodes.length > 1) {
                alert("只能选择一个用途...");
                return false;
            }
            nodes.sort(function compare(a, b) {
                return a.id - b.id;
            });
            for (var i = 0, len = nodes.length; i < len; i++) {
                tdytCode += nodes[i].id + ",";
                tdytName += nodes[i].name + ",";
            }
            if (tdytCode.length > 0 ) {
                tdytCode = tdytCode.substring(0, tdytCode.length - 1);
                tdytName = tdytName.substring(0, tdytName.length - 1);
            }
            $("#tdytName").val(tdytName);
            $("#tdytCode").val(tdytCode);
        }


        function showTdytMenu() {
            $("#tdytContent").slideDown("fast");
            $("body").bind("mousedown", onTdytBodyDown);
        }

        function hideTdytMenu() {
            $("#tdytContent").fadeOut("fast");
            $("body").unbind("mousedown", onTdytBodyDown);
        }

        function onTdytBodyDown(event) {
            if (!(event.target.id == "tdytMenuBtn" || event.target.id == "tdytContent" || $(event.target).parents("#tdytContent").length > 0)) {
                hideTdytMenu();
            }
        }

        function clearTdyt () {
            $("#tdytName").val("");
            $("#tdytCode").val("");
        }

        var fileTypeMap;
        var uploadFileQueue= [];
        var uploadIndex = -1;

        $(document).ready(function(){
            // 是否最高限价
            maxOfferExistChange();
            // 初始化附件信息
            initializeAttachment();

        });


        function initializeAttachment() {
            if (!isEmpty('${transResource.resourceId!}')) {
                getAttachments('${transResource.resourceId!}');
            }

            fileTypeMap = {};
            $('#attachmentType option').each(function(){
                fileTypeMap[$(this).val()]=$(this).text();
            });
        }

        // 初始化时 获取已上传的附件
        function getAttachments (resourceId) {
            var url = '${base}/transfile/attachments?fileKey=' + resourceId;
            $.get(url, function (data) {
                $('#attachments').empty();
                if(data != null && data.length > 0) {
                    for(var i = 0; i < data.length; i++){
                        insertAttachment(data[i].fileId, data[i].fileName, data[i].fileType);
                    }
                }
            })
        }


        function insertAttachment(fileId,fileName,fileType){
            $('#attachmentsTitle').prepend("<div class='attachment"+fileId+"'><a class='btn btn-link' >"+getFileTypeName(fileType)+"</a><br/></div>");
            $("#attachments").prepend("<div class='attachment"+fileId+"'><a class='btn btn-link' target='_blank' href='${core}/transfile/get?fileId=" +fileId+ "'>"+fileName+"</a><br/></div>");
        }

        function regionChanged(){
            var regionCode=$("select#regionCode").val();
            $("#bankList").load("${base}/console/resource/edit/banks.f?regionCode="+regionCode+"&resourceId=${transResource.resourceId!}");
        }
        function unitChange(){
            $(".unit_span").html($("select[name='offerUnit']").find("option:selected").text());
        }

        function beginDateChange(){
            var bDate=$("input[name='gpBeginTime']").val();
            bDate=new XDate(bDate);
            var endDate=bDate.addDays(9);
            $("input[name='gpEndTime']").val(endDate.toString("yyyy-MM-dd")+" 16:00:00");
            $("input[name='yxEndTime']").val(endDate.toString("yyyy-MM-dd")+" 16:00:00");
            $("input[name='xsBeginTime']").val(endDate.toString("yyyy-MM-dd")+" 16:00:00");
            $("input[name='bmEndTime']").val(endDate.addDays(-2).toString("yyyy-MM-dd")+" 16:00:00");
            $("input[name='bzjEndTime']").val(endDate.toString("yyyy-MM-dd")+" 16:00:00");

            $("input[name='bmBeginTime']").val(bDate.addDays(-33).toString("yyyy-MM-dd")+" 09:00:00");
            $("input[name='bzjBeginTime']").val(bDate.toString("yyyy-MM-dd")+" 09:00:00");

        }

        function maxOfferExistChange () {
            var maxOfferExist = $("#maxOfferExist").val();
            if (maxOfferExist == 1) {
                $("#maxOfferTr").show();
            }
        }

        function getFileTypeName(fileType){
            return fileTypeMap[fileType];
        }

        function checkAllBanks() {
            $("#bankList [name='banks']").each(function(i, e) {
                $(e).attr("checked", true);
            });
        }



    </script>

</head>
<body>
<nav class="breadcrumb pngfix">
    <a href="${base}/index" class="maincolor">首页</a>
    <span class="c_gray en">&gt;</span><a href="javascript:changeSrc('${base}/resource/index')">出让地块</a>
    <span class="c_gray en">&gt;</span><span class="c_gray"> ${transResource.resourceCode!"新增地块"}</span>
</nav>

<#if _result?? && _result>
<div class="Huialert Huialert-success" style="margin-bottom: 0px"><i class="icon-remove"></i>${_msg!}</div>
<#elseif _result?? && !_result>
<div class="Huialert Huialert-danger" style="margin-bottom: 0px"><i class="icon-remove"></i>${_msg!}</div>
</#if>
<form class="form-base" method="post" action="${base}/console/resource/edit/save">
    <table class="table table-border table-bordered table-striped">
    <tr>
        <td colspan="4" style="text-align: center;font-size: 14px;font-weight:700">交易地块基本信息（以下必填）</td>
    </tr>
    <tr>
        <td width="180"><label class="control-label">地块编号：</label></td>
        <td><input type="text" disabled="disabled" class="input-text" name="resourceCode" value="${transResource.resourceCode!}" maxlength="32">
        </td>
        <td width="180"><label class="control-label">行政区部门：</label></td>
        <td width="300">
            <select disabled="disabled" id="organizeId" name="organizeId" class="select">
                <#list transOrganizeList as organize>
                    <#--<option value="${organize.organizeId}">${organize.organizeName}</option>-->
                    <option
                        <#if transResource.organizeId?? && transResource.organizeId == organize.organizeId>selected="selected"
                        </#if> value="${organize.organizeId}">
                    ${organize.organizeName}
                    </option>
                </#list>
            </select>
        <#--<@SelectHtml SelectName="regionCode" SelectObjects=transOrganizeList Width=0 SelectValue=transResource.regionCode onChange="regionChanged"/>-->
        </td>
    </tr>
    <tr>
        <td><label class="control-label">地块座落：</label></td>
        <td colspan="3"><input type="text" disabled="disabled" class="input-text" name="resourceLocation" value="${transResource.resourceLocation!}" maxlength="100"></td>
    </tr>

    <tr>
        <td><label class="control-label">竞价单位：</label></td>
        <td>
            <span class="select-box">
                <select disabled="disabled" onChange="unitChange()" name="offerUnit" class="select" >
                    <option value="0" <#if transResource.offerUnit?? && transResource.offerUnit==0 >selected="selected"</#if>>万元（总价）</option>
                    <option value="1" <#if transResource.offerUnit?? && transResource.offerUnit==1 >selected="selected"</#if>>元/平方米（地面价）</option>
                    <option value="2" <#if transResource.offerUnit?? && transResource.offerUnit==2 >selected="selected"</#if>>元/平方米（楼面价）</option>
                    <option value="3" <#if transResource.offerUnit?? && transResource.offerUnit==3 >selected="selected"</#if>>万元/亩</option>
                </select>
            </span>
        </td>
        <td><label class="control-label">起始价<span class="unit_span"><@unitText value=transResource.offerUnit! /></span>：</label></td>
        <td><input disabled="disabled" style="background-color: #FFFFCC" type="text" name="beginOffer" class="input-text"  value="${transResource.beginOffer!}" maxlength="12"></td>

    </tr>
    <tr>
        <td><label class="control-label">增价幅度<span class="unit_span"><@unitText value=transResource.offerUnit! /></span>：</label></td>
        <td><input disabled="disabled" type="text" name="addOffer" class="input-text" value="${transResource.addOffer!}" maxlength="12"></td>
        <td><label class="control-label">出让面积（平方米）：</label></td>
        <td><input type="text" name="crArea" disabled="disabled" class="input-text" value="${transResource.crArea!}" maxlength="12"></td>

    </tr>

     <tr>
         <td width="210"><label class="control-label">建筑面积（平方米）：</label></td>
         <td><input type="text" id="buildingArea" name="buildingArea" class="input-text"  value="${transResource.buildingArea!}" maxlength="12"></td>
         <td></td>
         <td></td>
     </tr>

    <tr>
        <td><label class="control-label">保证金（万元）：</label></td>
        <td><input type="text" disabled="disabled" name="fixedOffer" class="input-text" value="${transResource.fixedOffer!}" maxlength="12"></td>
        <td><label class="control-label">保证金（万美元）：</label></td>
        <td><input type="text" disabled="disabled" name="fixedOfferUsd" class="input-text" value="${transResource.fixedOfferUsd!}" maxlength="12"></td>
    </tr>
    <tr>
        <td><label class="control-label">保证金（万港币）：</label></td>
        <td><input type="text" disabled="disabled" name="fixedOfferHkd" class="input-text" value="${transResource.fixedOfferHkd!}" maxlength="12"></td>
        <td>规划用途：</td>
        <td>
            <input type="text" class="input-text" id="tdytName" name="tdytName" value="${transResource.tdytName!}" readonly
                   style="width: 80%;background-color: background-color: #ffffcc;" maxlength="50">
            <input type="hidden" id="tdytCode" name="tdytCode" value="${tdytCode!}" />
        <#--<a id="tdytMenuBtn" href="#" onclick="showTdytMenu(); return false;">选择</a>-->
        <#--<a href="#" onclick="clearTdyt(); return false;">清空</a>-->
            <div id="tdytContent" class="RegionContent" style="display:none; position: absolute; background-color:#F5F5F5;width: 250px;z-index: 1; ">
                <ul id="treeTdyt" class="ztree" style="margin-top:0; width:160px;z-index: 1;"></ul>
            </div>
        </td>

    </tr>

    <tr>
        <td><label class="control-label">供地方式：</label></td>
        <td>
            <span class="select-box">
            <select disabled="disabled" name="dealType" class="select" >
                <option value="00" <#if transResource.dealType?? && transResource.dealType=='00' >selected="selected"</#if>>出让</option>
            </select>
            </span>
        </td>
        <#--<td width="210"><label class="control-label">代征土地面积（平方米）：</label></td>
        <td><input type="text" id="daizhArea" name="daizhArea" class="input-text"  value="${transResourceInfo.daizhArea!}"></td>-->
        <td><label class="control-label">是否有底价：</label></td>
        <td>
            <span class="select-box">
                <select disabled="disabled" id="minOffer" name="minOffer" class="select">
                    <option value="0" <#if transResource.minOffer?? && transResource.minOffer == 0 >selected="selected"</#if>>否</option>
                    <option value="1" <#if transResource.minOffer?? && transResource.minOffer == 1 >selected="selected"</#if>>是</option>
                </select>
            </span>
            <#--<input type="checkbox" name="minOffer" value="${transResource.minOffer?string(1,0)}" onchange="minOfferChange()" <#if transResource.minOffer==true>checked</#if> >
            <label class="minOfferInfo">
            <#if transResource.minOffer>
                请务必在挂牌截至前30分钟内录入底价，否则底价默认为0！
            <#else>
                无底价！
            </#if>k
            </label>-->
        </td>
    </tr>
        <tr>
            <td><label class="control-label">是否资格前审：</label></td>
            <td>
            <span class="select-box">
                <select id="beforeBzjAudit" name="beforeBzjAudit" class="select">
                    <option value="0" <#if transResource.beforeBzjAudit?? && transResource.beforeBzjAudit == 0 >selected="selected"</#if>>否</option>
                    <option value="1" <#if transResource.beforeBzjAudit?? && transResource.beforeBzjAudit == 1 >selected="selected"</#if>>是</option>
                </select>
            </span>
            </td>
            <td><label class="control-label">是否有最高限价：</label></td>
            <td colspan="3">
            <span class="select-box">
                <select disabled="disabled" id="maxOfferExist" name="maxOfferExist" class="select" onchange="maxOfferExistChange();">
                    <option value="0" <#if transResource.maxOfferExist?? && transResource.maxOfferExist == 0 >selected="selected"</#if>>否</option>
                    <option value="1" <#if transResource.maxOfferExist?? && transResource.maxOfferExist == 1 >selected="selected"</#if>>是</option>
                </select>
            </span>
            </td>
        </tr>
    <tr id="maxOfferTr" style="display: none;">
        <td><label class="control-label">最高限价<span class="unit_span"><@unitText value=transResource.offerUnit! /></span>：</label></td>
        <td><input type="text" id="maxOffer" name="maxOffer" class="input-text" disabled="disabled" value="${transResource.maxOffer!}" maxlength="12"></td>
        <td><label class="control-label">到达限价后的处理方式：</label></td>
        <td>
            <span class="select-box">
                <select id="maxOfferChoose" name="maxOfferChoose" class="select" disabled="disabled" >
                    <option value="YCBJ" <#if transResource.maxOfferChoose?? && transResource.maxOfferChoose.code==1 >selected="selected"</#if>>一次报价</option>
                    <option value="YH" <#if transResource.maxOfferChoose?? && transResource.maxOfferChoose.code==2  >selected="selected"</#if>>摇号</option>
                    <option value="3">限地价、竞房价，共有产权管理</option>
                    <option value="4">限地价、限房价，竞配建</option>
                    <option value="5">限定地价范围的竞价</option>
                    <option value="6">地价与自持面积双竞价</option>
                    <option value="7">土地利用综合条件优先</option>
                </select>
            </span>
        </td>
    </tr>
    <tr>
        <td><label class="control-label">挂牌开始时间：</label></td>
        <td><input type="text" disabled="disabled" id="gpBeginTime" name="gpBeginTime" class="input-text Wdate" onchange="beginDateChange()"  value="<#if transResource.gpBeginTime??>${transResource.gpBeginTime?string("yyyy-MM-dd HH:mm:ss")}</#if>" onfocus="WdatePicker({firstDayOfWeek:1,dateFmt:'yyyy-MM-dd HH:mm:ss',startDate:'%y-%M-%d 09:00:00',maxDate:'#F{$dp.$D(\'gpEndTime\')}',alwaysUseStartDate:true})" readonly="readonly"></td>
        <td><label class="control-label">挂牌截止时间：</label></td>
        <td><input type="text" disabled="disabled" id="gpEndTime" name="gpEndTime" class="input-text Wdate" value="${transResource.gpEndTime?string("yyyy-MM-dd HH:mm:ss")}" onfocus="WdatePicker({firstDayOfWeek:1,dateFmt:'yyyy-MM-dd HH:mm:ss',startDate:'%y-%M-%d 15:00:00',minDate:'#F{$dp.$D(\'gpBeginTime\')}',alwaysUseStartDate:true})" readonly="readonly"></td>
    </tr>
    <tr>
        <td><label class="control-label">报名开始时间：</label></td>
        <td><input type="text" disabled="disabled" id="bmBeginTime" name="bmBeginTime" class="input-text Wdate"  value="<#if transResource.bmBeginTime??>${transResource.bmBeginTime?string("yyyy-MM-dd HH:mm:ss")}</#if>" onfocus="WdatePicker({firstDayOfWeek:1,dateFmt:'yyyy-MM-dd HH:mm:ss',startDate:'%y-%M-%d 09:00:00',maxDate:'#F{$dp.$D(\'bmEndTime\')}',alwaysUseStartDate:true})" readonly="readonly"></td>
        <td><label class="control-label">报名截止时间：</label></td>
        <td><input type="text" disabled="disabled" id="bmEndTime" name="bmEndTime" class="input-text Wdate" value="<#if transResource.bmEndTime??>${transResource.bmEndTime?string("yyyy-MM-dd HH:mm:ss")}</#if>" onfocus="WdatePicker({firstDayOfWeek:1,dateFmt:'yyyy-MM-dd HH:mm:ss',startDate:'%y-%M-%d 15:00:00',minDate:'#F{$dp.$D(\'bmBeginTime\')}',alwaysUseStartDate:true})" readonly="readonly"></td>
    </tr>
    <tr>
        <td><label class="control-label">保证金交纳开始时间：</label></td>
        <td><input type="text" disabled="disabled" id="bzjBeginTime" name="bzjBeginTime" class="input-text Wdate"  value="<#if transResource.bzjBeginTime??>${transResource.bzjBeginTime?string("yyyy-MM-dd HH:mm:ss")}</#if>" onfocus="WdatePicker({firstDayOfWeek:1,dateFmt:'yyyy-MM-dd HH:mm:ss',startDate:'%y-%M-%d 09:00:00',maxDate:'#F{$dp.$D(\'bmEndTime\')}',alwaysUseStartDate:true})" readonly="readonly"></td>
        <td><label class="control-label">保证金交纳截止时间：</label></td>
        <td><input type="text" disabled="disabled" id="bzjEndTime" name="bzjEndTime" class="input-text Wdate" value="${transResource.bzjEndTime?string("yyyy-MM-dd HH:mm:ss")}" onfocus="WdatePicker({firstDayOfWeek:1,dateFmt:'yyyy-MM-dd HH:mm:ss',startDate:'%y-%M-%d 15:00:00',minDate:'#F{$dp.$D(\'bmBeginTime\')}',alwaysUseStartDate:true})" readonly="readonly"></td>
    </tr>
        <tr>
            <#--<td><label class="control-label">首次报价截止时间：</label></td>
            <td><input type="text" disabled="disabled" id="yxEndTime" name="yxEndTime" class="input-text Wdate" value="<#if transResource.yxEndTime??>${transResource.yxEndTime?string("yyyy-MM-dd HH:mm:ss")}</#if> " onfocus="WdatePicker({firstDayOfWeek:1,dateFmt:'yyyy-MM-dd HH:mm:ss',startDate:'%y-%M-%d 15:00:00',minDate:'#F{$dp.$D(\'gpEndTime\')}',alwaysUseStartDate:true})" readonly="readonly"></td>-->

            <td><label class="control-label">限时报价开始时间：</label></td>
            <td><input type="text" disabled="disabled" id="xsBeginTime" name="xsBeginTime" class="input-text Wdate" value="<#if transResource.xsBeginTime??>${transResource.xsBeginTime?string("yyyy-MM-dd HH:mm:ss")}</#if> " onfocus="WdatePicker({firstDayOfWeek:1,dateFmt:'yyyy-MM-dd HH:mm:ss',startDate:'%y-%M-%d 15:00:00',minDate:'#F{$dp.$D(\'gpEndTime\')}',alwaysUseStartDate:true})" readonly="readonly"></td>
        </tr>
    </table>

    <table  class="table table-border table-bordered table-striped">
        <tr>
            <td colspan="4" style="text-align: center;font-size: 14px;font-weight:700" >选择保证金交纳银行（必选）--<a href="javascript:checkAllBanks();">全选</a> </td>
        </tr>
        <tr>
            <td colspan="4" id="bankList" >
            <#include "resource/resource-bank.ftl"/>
            </td>
        </tr>
    </table>
<#if transResource.resourceId??>
<table id="addSonTable" class="table table-border table-bordered table-striped">
    <tr>
        <td colspan="8" style="text-align: center;font-size: 14px;font-weight:700">交易地块多规划用途信息（选填）
        <span style="float: right">
            <#--<button type="button"  class="btn btn-primary" onclick="addResourceSon()">新增</button>-->
        </span>
        </td>
    </tr>
    <tr id="addSonTr" <#if transResourceSonList?? && (transResourceSonList?size>0)><#else>style="display: none"</#if> >
        <td width="6%" align="center"><label class="control-label">#</label></td>
        <td width="22%" align="center"><label class="control-label">面积(编号)</label></td>
        <td width="22%" align="center"><label class="control-label">用途</label></td>
        <td width="10%" align="center"><label class="control-label">出让年限</label></td>
        <td width="10%" align="center"><label class="control-label">容积率</label></td>
        <td width="10%" align="center"><label class="control-label">建筑密度</label></td>
        <td width="10%" align="center"><label class="control-label">绿化率</label></td>
        <td width="10%" align="center"><label class="control-label">建筑限高</label></td>
    </tr>
    <#if transResourceSonList?? && (transResourceSonList?size>0)>
        <#list transResourceSonList as resourceSon>
            <tr>
                <td><#--<input type="button" class="btn btn-primary" onclick="delResourceSon('${resourceSon.sonId}', this)" value="删除">--></td>
                <td><label class="control-label">${resourceSon.zdArea!}(${resourceSon.zdCode!})</label></td>
                <td><label class="control-label">${resourceSon.tdytName!}</label></td>
                <td><label class="control-label">${resourceSon.sonYearCount!}</label></td>
                <td><label class="control-label"><@compareSon minNum=resourceSon.minRjl maxNumTag=resourceSon.maxRjlTag minNumTag=resourceSon.minRjlTag maxNum=resourceSon.maxRjl name="FAR"/></label></td>
                <td><label class="control-label"><@compareSon minNum=resourceSon.minJzMd maxNumTag=resourceSon.maxJzMdTag minNumTag=resourceSon.minJzMdTag maxNum=resourceSon.maxJzMd name="BD"/></label></td>
                <td><label class="control-label"><@compareSon minNum=resourceSon.minLhl maxNumTag=resourceSon.maxLhlTag minNumTag=resourceSon.minLhlTag maxNum=resourceSon.maxLhl name="GSP"/></label></td>
                <td><label class="control-label"><@compareSon minNum=resourceSon.minJzxg maxNumTag=resourceSon.maxJzXgTag minNumTag=resourceSon.minJzXgTag maxNum=resourceSon.maxJzxg name="BHR"/></label></td>
            </tr>
        </#list>
    </#if>
</table>
</#if>

    <table class="table table-border table-bordered table-striped">
        <tr>
            <td colspan="4" style="text-align: center;font-size: 14px;font-weight:700" >其他地块规划信息</td>
        </tr>


        <tr>
            <td width="210"><label class="control-label">建筑面积（平方米）：</label></td>
            <td><input type="text" disabled="disabled" name="buildingArea" class="input-text"  value="${transResourceInfo.buildingArea!}" maxlength="12"></td>
            <td width="210"><label class="control-label">商业建筑面积（平方米）：</label></td>
            <td><input type="text" disabled="disabled" name="shconArea" class="input-text" value="${transResourceInfo.shconArea!}" maxlength="12"></td>

        </tr>
        <tr>
            <td width="210"><label class="control-label">住宅建筑面积（平方米）：</label></td>
            <td><input type="text" disabled="disabled" name="zzconArea" class="input-text"  value="${transResourceInfo.zzconArea!}" maxlength="12"></td>
            <td width="210"><label class="control-label">办公建筑面积（平方米）：</label></td>
            <td><input type="text" disabled="disabled" name="bgconArea" class="input-text" value="${transResourceInfo.bgconArea!}" maxlength="12"></td>
        </tr>
        <tr>
            <td width="210"><label class="control-label">出让年限（年）：</label></td>
            <td><input type="text" disabled="disabled" name="yearCount" class="input-text" value="${transResourceInfo.yearCount!}" maxlength="12"></td>
            <td width="210"><label class="control-label">约定土地交易条件 ：</label></td>
            <td><input type="text" disabled="disabled" name="tdTjXx" class="input-text"  value="${transResourceInfo.tdTjXx!}" maxlength="64"></td>

        </tr>
        <tr>
            <td width="210"><label class="control-label">场地平整 ：</label></td>
            <td><input type="text" disabled="disabled" name="cdPz" class="input-text" value="${transResourceInfo.cdPz!}" maxlength="64"></td>
            <td width="210"><label class="control-label">基础设施 ：</label></td>
            <td ><input type="text" disabled="disabled" name="jcSs" class="input-text"  value="${transResourceInfo.jcSs!}" maxlength="64"></td>

        </tr>
        <tr>
            <td><label class="control-label">办公与服务设施用地比例（%）：</label></td>
            <td><input type="text" disabled="disabled" name="officeRatio" class="input-text"  value="${transResourceInfo.officeRatio!}" maxlength="12"></td>
            <td><label class="control-label">投资强度（万元/亩）：</label></td>
            <td><input type="text" disabled="disabled" name="investmentIntensity" class="input-text" value="${transResourceInfo.investmentIntensity!}" maxlength="32"></td>
        </tr>

        <tr>
            <td><label class="control-label">建设内容</label></td>
            <td colspan="3">
                <textarea name="constructContent" disabled="disabled" style="width: 100%" rows="5" maxlength="255">${transResourceInfo.constructContent!}</textarea>
            </td>
        </tr>
        <tr>
            <td><label class="control-label">土地交付条件</label></td>
            <td colspan="3">
                <textarea name="deliverTerm" disabled="disabled" style="width: 100%" rows="5" maxlength="255">${transResourceInfo.deliverTerm!}</textarea>
            </td>
        </tr>
        <tr>
            <td><label class="control-label">规划要点</label></td>
            <td colspan="3">
                <textarea name="layoutOutline" disabled="disabled" style="width: 100%" rows="5" maxlength="255">${transResourceInfo.layoutOutline!}</textarea>
            </td>
        </tr>
        <tr>
            <td><label class="control-label">地块介绍</label></td>
            <td colspan="3">
                <textarea name="description" disabled="disabled" style="width: 100%" rows="5" maxlength="255">${transResourceInfo.description!}</textarea>
            </td>
        </tr>
        <tr>
            <td><label class="control-label">周边环境</label></td>
            <td colspan="3">
                <textarea name="surroundings" disabled="disabled" style="width: 100%" rows="5" maxlength="255">${transResourceInfo.surroundings!}</textarea>
            </td>
        </tr>

        <tr>
            <td><label class="control-label">备注</label></td>
            <td colspan="3">
                <textarea name="memo" disabled="disabled" style="width: 100%" rows="5" maxlength="255">${transResourceInfo.memo!}</textarea>
            </td>
        </tr>
        <#if transResource.resourceId??>
            <tr>
                <td rowspan="2"><label class="control-label">附件：</label></td>
                <td style="width: 200px">
                    <span style="color: red;">注：只允许上传以下类型的文件：pdf、zip或者jpg等图片文件，其大小不超过10M</span>
                </td>
                <td colspan="2" style="padding-left:8px;">
                    <div style="float: left;">
                        <label class="control-label">附件类型：</label>
                        <select id="attachmentType">
                            <#list attachmentCategory?keys as key>
                                <option value="${key}" <#if key_index==0>selected</#if>>${attachmentCategory[key]}</option>
                            </#list>
                        </select>
                    </div>

                    <div id="attachmentBtn">
                    <span class="btn-upload" style="height:60px;margin-left: 10px">
                        <a href="javascript:void();" class="uploadifive-button">浏览文件</a>
                        <input disabled="disabled" id="attachmentFile" name="file" type="file" multiple="true" class="input-file"
                               accept="image/png, image/gif, image/jpg, image/jpeg,image/bmp,application/zip,application/pdf">
                    </span>
                    </div>
                    <div class="progress-bar upload-progress-bar" id="attachmentProgressBar">
                        <span class="sr-only"/>
                    </div>

                </td>

            </tr>

            <tr style="height: 90px">
                <td colspan="3" style="padding-left:8px;">
                    <div id="attachmentsTitle">
                    </div>
                    <div id="attachments">
                    </div>
                    <div id="attachmentsOperation">
                    </div>


                </td>

            </tr>
        </#if>

    </table>
    <input type="hidden" name="dkCode" value="${transResource.dkCode!}">
    <input type="hidden" id="resourceId" name="resourceId" value="${transResource.resourceId!}">
    <input type="hidden" name="ggId" value="${transResource.ggId!}">
    <input type="hidden" name="infoId" value="${transResourceInfo.infoId!}">
    <div class="row-fluid">
        <div class="span10 offset2">
           <#-- <button type="button" class="btn btn-primary" onclick="return checkForm()">导入</button>-->
            <#--<button type="button" class="btn btn-primary" onclick="submitForm()">保存</button>-->
            <button type="button" class="btn" onclick="javascript:changeSrc('${base}/resource/index')">返回</button>
        </div>
    </div>
</form>

</body>
</html>