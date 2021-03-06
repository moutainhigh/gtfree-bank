package cn.gtmap.landsale.client.register;


import cn.gtmap.egovplat.core.data.Page;
import cn.gtmap.egovplat.core.data.Pageable;
import cn.gtmap.landsale.common.model.ResponseMessage;
import cn.gtmap.landsale.common.model.TransResource;
import cn.gtmap.landsale.common.web.ResourceQueryParam;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * 地块资源 服務
 * @author cxm
 * @version v1.0, 2017/10/20
 */
@FeignClient(name = "core-server")
public interface TransResourceClient {

    /**
     * 获取可以显示在大屏幕上的地块
     * @param title
     * @param displayStatus
     * @param regionCodes
     * @param pageable
     * @return
     */
    @RequestMapping(value = "/resource/findDisplayResource", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    Page<TransResource> findDisplayResource(@RequestParam(value = "title", required = false) String title, @RequestParam(value = "displayStatus", required = false) String displayStatus, @RequestParam(value = "regionCodes", required = false) String regionCodes, @RequestBody Pageable pageable);

    /**
     * 更新地块在交易大屏幕上的显示状态
     * @param resourceId
     * @param displayStatus
     */
    @RequestMapping(value = "/resource/updateTransResourceDisplayStatus", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    void updateTransResourceDisplayStatus(@RequestParam("resourceId") String resourceId, @RequestParam("displayStatus") int displayStatus);

    /**
     * 根据显示状态查找地块
     * @param displayStatus
     * @return
     */
    @RequestMapping(value = "/resource/findTransResourcesByDisplayStatus", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    List<TransResource> findTransResourcesByDisplayStatus(@RequestParam("displayStatus") int displayStatus);

    /**
     * 获得出让地块
     * @param resourceId 地块Id
     * @return
     */
    @RequestMapping(value = "/resource/getTransResource", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    TransResource getTransResource(@RequestParam("resourceId") String resourceId);

    /**
     * 获得出让地块
     * @param resourceCode 地块Code
     * @return
     */
    @RequestMapping(value = "/resource/getTransResourceByCode", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    TransResource getTransResourceByCode(@RequestParam("resourceCode") String resourceCode);

    /**
     * 查询资源、分页，Admin用
     * @param title
     * @param status
     * @param pageable
     * @param ggId
     * @param regionCodes
     * @return
     */
    @RequestMapping(value = "/resource/findTransResourcesByEditStatus", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    Page<TransResource> findTransResourcesByEditStatus(@RequestParam(value = "title", required = false) String title, @RequestParam(value = "status", required = false) int status, @RequestParam(value = "ggId", required = false) String ggId, @RequestParam(value = "regionCodes", required = false) String regionCodes, @RequestBody Pageable pageable);

    /**
     * 保存出让地块对象
     * @param transResource 出让地块
     * @return ResponseMessage<TransResource>
     */
    @RequestMapping(value = "/resource/saveTransResource", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    ResponseMessage<TransResource> saveTransResource(@RequestBody TransResource transResource);

    /**
     * 根据公告Id获取公告地块
     * @param ggId
     * @return
     */
    @RequestMapping(value = "/resource/findTransResource", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    List<TransResource> findTransResource(@RequestParam("ggId") String ggId);

    /**
     * 查询资源，分页,client用 首页
     * @param queryParam
     * @param regionCodes
     * @return
     */
    @RequestMapping(value = "/resource/findTransResources", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    public Page<TransResource> findTransResources(@RequestBody ResourceQueryParam queryParam, @RequestParam(value = "regionCodes", required = false) String regionCodes);

    /**
     * 查询资源，分页,client用 当前用户参与地块
     * @param queryParam
     * @param userId 用户id
     * @param regionCodes
     * @return
     */
    @RequestMapping(value = "/resource/findTransResourcesByUser", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    public Page<TransResource> findTransResourcesByUser(@RequestBody ResourceQueryParam queryParam, @RequestParam(value = "userId") String userId, @RequestParam(value = "regionCodes", required = false) String regionCodes);

    /**
     * 查询资源 client用 当前用户 可以报价的地块
     * @param userId
     * @return
     */
    @RequestMapping(value = "/resource/findResourcesForPriceByUser", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    public List<TransResource> findResourcesForPriceByUser(@RequestParam(value = "userId") String userId);

    /**
     * 地块的中止、终止和成交公告加载
     * @param resourceId
     * @return
     */
    @RequestMapping(value = "/resource/resourceNotice", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    public List resourceNotice(@RequestParam(value = "resourceId") String resourceId);
}
