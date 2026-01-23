package com.greenart.bdproject.dto;

import java.sql.Timestamp;

public class RequiredDocumentDto {
    private Long documentId;
    private String serviceId;
    private String documentName;
    private String documentDescription;
    private Boolean isRequired;
    private String howToGet;
    private Integer documentOrder;
    private Integer commonDocId;
    private Timestamp createdAt;

    // 조인용 필드 (common_documents 테이블에서)
    private String category;

    public RequiredDocumentDto() {
    }

    public Long getDocumentId() {
        return documentId;
    }

    public void setDocumentId(Long documentId) {
        this.documentId = documentId;
    }

    public String getServiceId() {
        return serviceId;
    }

    public void setServiceId(String serviceId) {
        this.serviceId = serviceId;
    }

    public String getDocumentName() {
        return documentName;
    }

    public void setDocumentName(String documentName) {
        this.documentName = documentName;
    }

    public String getDocumentDescription() {
        return documentDescription;
    }

    public void setDocumentDescription(String documentDescription) {
        this.documentDescription = documentDescription;
    }

    public Boolean getIsRequired() {
        return isRequired;
    }

    public void setIsRequired(Boolean isRequired) {
        this.isRequired = isRequired;
    }

    public String getHowToGet() {
        return howToGet;
    }

    public void setHowToGet(String howToGet) {
        this.howToGet = howToGet;
    }

    public Integer getDocumentOrder() {
        return documentOrder;
    }

    public void setDocumentOrder(Integer documentOrder) {
        this.documentOrder = documentOrder;
    }

    public Integer getCommonDocId() {
        return commonDocId;
    }

    public void setCommonDocId(Integer commonDocId) {
        this.commonDocId = commonDocId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    @Override
    public String toString() {
        return "RequiredDocumentDto{" +
                "documentId=" + documentId +
                ", serviceId='" + serviceId + '\'' +
                ", documentName='" + documentName + '\'' +
                ", isRequired=" + isRequired +
                '}';
    }
}
