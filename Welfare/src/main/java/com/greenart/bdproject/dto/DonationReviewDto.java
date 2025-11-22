package com.greenart.bdproject.dto;

import java.util.Date;

public class DonationReviewDto {
    private Long reviewId;
    private Long userId;
    private Long donationId;
    private String reviewerName;
    private Integer rating;
    private String content;
    private Boolean isAnonymous;
    private Integer helpfulCount;
    private Date createdAt;
    private Date updatedAt;

    // JOIN으로 가져올 필드 (donations 테이블)
    private String category;
    private Double donationAmount;
    private String donationType;

    // 검색용 하이라이팅 필드 (서버에서만 사용, DB에는 저장 안됨)
    private String highlightedContent;
    private String highlightedName;

    public DonationReviewDto() {
    }

    public DonationReviewDto(Long reviewId, Long userId, Long donationId, String reviewerName, Integer rating, String content, Date createdAt) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.donationId = donationId;
        this.reviewerName = reviewerName;
        this.rating = rating;
        this.content = content;
        this.createdAt = createdAt;
    }

    public Long getReviewId() {
        return reviewId;
    }

    public void setReviewId(Long reviewId) {
        this.reviewId = reviewId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getDonationId() {
        return donationId;
    }

    public void setDonationId(Long donationId) {
        this.donationId = donationId;
    }

    public String getReviewerName() {
        return reviewerName;
    }

    public void setReviewerName(String reviewerName) {
        this.reviewerName = reviewerName;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Boolean getIsAnonymous() {
        return isAnonymous;
    }

    public void setIsAnonymous(Boolean isAnonymous) {
        this.isAnonymous = isAnonymous;
    }

    public Integer getHelpfulCount() {
        return helpfulCount;
    }

    public void setHelpfulCount(Integer helpfulCount) {
        this.helpfulCount = helpfulCount;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Double getDonationAmount() {
        return donationAmount;
    }

    public void setDonationAmount(Double donationAmount) {
        this.donationAmount = donationAmount;
    }

    public String getDonationType() {
        return donationType;
    }

    public void setDonationType(String donationType) {
        this.donationType = donationType;
    }

    public String getHighlightedContent() {
        return highlightedContent;
    }

    public void setHighlightedContent(String highlightedContent) {
        this.highlightedContent = highlightedContent;
    }

    public String getHighlightedName() {
        return highlightedName;
    }

    public void setHighlightedName(String highlightedName) {
        this.highlightedName = highlightedName;
    }

    @Override
    public String toString() {
        return "DonationReviewDto{" +
                "reviewId=" + reviewId +
                ", userId=" + userId +
                ", donationId=" + donationId +
                ", reviewerName='" + reviewerName + '\'' +
                ", rating=" + rating +
                ", content='" + content + '\'' +
                ", isAnonymous=" + isAnonymous +
                ", helpfulCount=" + helpfulCount +
                ", category='" + category + '\'' +
                ", donationAmount=" + donationAmount +
                ", donationType='" + donationType + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
