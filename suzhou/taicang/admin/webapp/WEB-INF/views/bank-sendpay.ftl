<html>
<head>
    <title>-发送到账通知</title>
    <meta name="menu" content="menu_admin_banklist"/>
    <style type="text/css">
        td input{
            padding-right: 0px;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function(){

        });
    </script>
</head>
<body>
<nav class="breadcrumb pngfix">
    <a href="${base}/console/index" class="maincolor">首页</a>
    <span class="c_gray en">&gt;</span><a href="${base}/console/bank/list">银行管理</a>
    <span class="c_gray en">&gt;</span><span class="c_gray">${transBank.bankName!}-发送到账通知</span>
</nav>
<#if retcode??>
<#if "00"==retcode>
<div class="Huialert Huialert-success"><i class="icon-remove"></i>发送到账通知成功！</div>
<#else>
<div class="Huialert Huialert-danger"><i class="icon-remove"></i>发送到账通知失败，原因：${retmsg!}</div>
</#if>
</#if>
<form class="form-base" method="post" action="${base}/console/bank/sendpay">
    <table class="table table-border table-bordered ">

        <tr>
            <td width="160">
                <label class="control-label">收款银行名称：</label>
            </td>
            <td>
                <input type="text" class="input-text" name="bankName" value="${transBank.bankName!}" readonly="readonly" style="background-color: #f9f9f9">
            </td>
            <td width="120">
                <label class="control-label">收款账户名称：</label>
            </td>
            <td>
                <input type="text" class="input-text" name="accountName" value="${transBankPay.accountName!}" readonly="readonly" style="background-color: #f9f9f9">
            </td>
        </tr>

        <tr>
            <td>
                <label class="control-label">收款银行账号：</label>
            </td>
            <td colspan="3">
                <input type="text" class="input-text" name="accountCode" value="${transBankPay.accountCode!}" style="background-color: #FFFFCC">
            </td>
        </tr>

        <tr>
            <td>
                <label class="control-label">转账银行名称：</label>
            </td>
            <td>
                <input type="text" class="input-text" name="payBankAddress" value="${transBankPay.payBankAddress!("××银行××支行")}" >
            </td>
            <td>
                <label class="control-label">转账账户名称：</label>
            </td>
            <td>
                <input type="text" class="input-text" name="payName" value="${transBankPay.payName!"××开发公司"}">
            </td>
        </tr>

        <tr>
            <td>
                <label class="control-label">转账银行账号：</label>
            </td>
            <td colspan="3">
                <input type="text" class="input-text" name="payBankAccount" value="${transBankPay.payBankAccount!"6200123456789"}" >
            </td>
        </tr>
        <tr>
            <td>
                <label class="control-label">转账银行金额（万元）：</label>
            </td>
            <td>
                <input type="text" class="input-text" name="amount" value="${transBankPay.amount!}"  style="background-color: #FFFFCC">
            </td>
            <td>
                <label class="control-label">货币类型：</label>
            </td>
            <td>
            <#if "CNY"==transBank.moneyUnit>
                <label for="control-label">人民币</label>
            <#else>
                <label for="control-label">美元</label>
            </#if>
            </td>
        </tr>

        <tr>
            <td>
                <label class="control-label">转账时间：</label>
            </td>
            <td>
                <input type="text" class="input-text" name="payTime" value="${nowDate?string("yyyy-MM-dd HH:mm:ss")}" >
            </td>
            <td>
                <label class="control-label">备注：</label>
            </td>
            <td>
                <input type="text" name="remark" class="input-text" value="手动转账" readonly="readonly" style="background-color: #f9f9f9">
            </td>
        </tr>
        <tr>
            <td>
                <label class="control-label">流水号：</label>
            </td>
            <td>
                <input type="text" class="input-text" name="payNo" value="${nowDate?string("yyyyMMddHHmmss")}" >
            </td>
            <td>

            </td>
            <td>

            </td>
        </tr>
    </table>

    <input type="hidden" name="bankId" value="${transBank.bankId!}">
    <input type="hidden" name="bankCode" value="${transBank.bankCode!}">

    <div class="row-fluid">
        <div class="span10 offset2">
            <button type="submit" class="btn btn-primary">发送</button>
            <button type="button" class="btn" onclick="window.location.href='${base}/console/bank/list'">返回</button>
        </div>
    </div>
</form>
</body>
</html>