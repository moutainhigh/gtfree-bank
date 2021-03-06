package cn.gtmap.landsale.service;

import cn.gtmap.landsale.model.TransResource;
import cn.gtmap.landsale.model.TransResourceVerify;

/**
 * Created by trr on 2015/10/9.
 */
public interface TransVerifyService {

    TransResourceVerify saveTransVerify(TransResourceVerify transResourceVerify);

    /**
     * 保存成交地块的确认审核信息
     * @param transResource
     * @param transResourceVerify
     */
    void saveTransResourceVerify(TransResource transResource,TransResourceVerify transResourceVerify);

    /**
     * 根据id获取地块成交审核信息
     * @param verifyId
     * @return
     */
    TransResourceVerify getTransVerifyById(String verifyId);
}
