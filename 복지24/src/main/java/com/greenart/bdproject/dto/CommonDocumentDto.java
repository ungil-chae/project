package com.greenart.bdproject.dto;

import java.sql.Timestamp;

public class CommonDocumentDto {
    private Integer commonDocId;
    private String documentName;
    private String documentCategory;
    private String description;
    private String howToGet;
    private Timestamp createdAt;

    public CommonDocumentDto() {
    }

    public Integer getCommonDocId() {
        return commonDocId;
    }

    public void setCommonDocId(Integer commonDocId) {
        this.commonDocId = commonDocId;
    }

    public String getDocumentName() {
        return documentName;
    }

    public void setDocumentName(String documentName) {
        this.documentName = documentName;
    }

    public String getDocumentCategory() {
        return documentCategory;
    }

    public void setDocumentCategory(String documentCategory) {
        this.documentCategory = documentCategory;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getHowToGet() {
        return howToGet;
    }

    public void setHowToGet(String howToGet) {
        this.howToGet = howToGet;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "CommonDocumentDto{" +
                "commonDocId=" + commonDocId +
                ", documentName='" + documentName + '\'' +
                ", documentCategory='" + documentCategory + '\'' +
                '}';
    }
}
