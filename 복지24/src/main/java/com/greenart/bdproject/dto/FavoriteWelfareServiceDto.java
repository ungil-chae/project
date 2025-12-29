package com.greenart.bdproject.dto;

import java.sql.Timestamp;

public class FavoriteWelfareServiceDto {
    // 새 스키마: 복합 PK (member_id, service_id), favorite_id 없음
    private Long memberId;  // 회원 고유번호
    private String serviceId;
    private String serviceName;
    private String servicePurpose;
    private String department;
    private String applyMethod;
    private String supportType;
    private String lifecycleCode;
    private String memo;  // 새 스키마: 사용자 메모
    private Timestamp createdAt;

    public FavoriteWelfareServiceDto() {
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public String getServiceId() {
        return serviceId;
    }

    public void setServiceId(String serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getServicePurpose() {
        return servicePurpose;
    }

    public void setServicePurpose(String servicePurpose) {
        this.servicePurpose = servicePurpose;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getApplyMethod() {
        return applyMethod;
    }

    public void setApplyMethod(String applyMethod) {
        this.applyMethod = applyMethod;
    }

    public String getSupportType() {
        return supportType;
    }

    public void setSupportType(String supportType) {
        this.supportType = supportType;
    }

    public String getLifecycleCode() {
        return lifecycleCode;
    }

    public void setLifecycleCode(String lifecycleCode) {
        this.lifecycleCode = lifecycleCode;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "FavoriteWelfareServiceDto{" +
                "memberId=" + memberId +
                ", serviceId='" + serviceId + '\'' +
                ", serviceName='" + serviceName + '\'' +
                '}';
    }
}
