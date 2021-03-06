package cn.gtmap.landsale.model;

import cn.gtmap.egovplat.core.support.hibernate.UUIDHexGenerator;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.io.Serializable;

/**
 * Created by u on 2016/2/29.
 */
@Entity
@Table(name="trans_crgg_material")
public class MaterialCrgg implements Serializable {
    @Id
    @GeneratedValue(generator = "sort-uuid")
    @GenericGenerator(name = "sort-uuid", strategy = UUIDHexGenerator.TYPE)
    @Column(length = 32)
    private String tcmId;

    private String materialId;

    private String crggId;

    public String getTcmId() {
        return tcmId;
    }

    public void setTcmId(String tcmId) {
        this.tcmId = tcmId;
    }

    public String getMaterialId() {
        return materialId;
    }

    public void setMaterialId(String materialId) {
        this.materialId = materialId;
    }

    public String getCrggId() {
        return crggId;
    }

    public void setCrggId(String crggId) {
        this.crggId = crggId;
    }
}
