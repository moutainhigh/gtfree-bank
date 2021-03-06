package cn.gtmap.landsale.web.freemarker;

import cn.gtmap.landsale.model.TransResourceMinPrice;
import cn.gtmap.landsale.model.TransResourceOffer;
import cn.gtmap.landsale.security.SecUtil;
import cn.gtmap.landsale.service.TransResourceMinPriceService;
import cn.gtmap.landsale.service.TransResourceOfferService;

import java.util.List;

/**
 * Created by jibo1_000 on 2015/6/2.
 */
public class PriceUtil {

    TransResourceOfferService transResourceOfferService;

    TransResourceMinPriceService transResourceMinPriceService;

    public void setTransResourceOfferService(TransResourceOfferService transResourceOfferService) {
        this.transResourceOfferService = transResourceOfferService;
    }

    public void setTransResourceMinPriceService(TransResourceMinPriceService transResourceMinPriceService) {
        this.transResourceMinPriceService = transResourceMinPriceService;
    }


    public TransResourceOffer getMaxOffer(String resourceId){
        return transResourceOfferService.getMaxOffer(resourceId);
    }

    public Double getMinPrice(String resourceId){
        List<TransResourceMinPrice> transResourceMinPriceList=
                transResourceMinPriceService.getMinPriceListByResourceId(resourceId);
        for(TransResourceMinPrice transResourceMinPrice: transResourceMinPriceList){
            if (transResourceMinPrice.getUserId().equals(SecUtil.getLoginUserId())){
                return transResourceMinPrice.getPrice();
            }
        }
        return 0.0;
    }

    public Double getMinPriceByResourceId(String resourceId){
        return transResourceMinPriceService.getMinPriceByResourceId(resourceId);
    }
}
