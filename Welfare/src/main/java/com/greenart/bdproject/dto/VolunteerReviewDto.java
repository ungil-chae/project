package com.greenart.bdproject.dto;

import java.util.Date;

public class VolunteerReviewDto {
    private Long reviewId;
    private String userId;  // member.id와 연결 (VARCHAR)
    private String userName; // 조인으로 가져올 사용자 이름
    private Long applicationId;
    private String activityName; // 봉사 활동명
    private String volunteerExperience; // 봉사 경력 (없음/1년미만/1-3년/3년이상)
    private String title;
    private String content;
    private Integer rating;
    private Date createdAt;

    public VolunteerReviewDto() {
    }

    public Long getReviewId() {
        return reviewId;
    }

    public void setReviewId(Long reviewId) {
        this.reviewId = reviewId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Long getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(Long applicationId) {
        this.applicationId = applicationId;
    }

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }

    public String getVolunteerExperience() {
        return volunteerExperience;
    }

    public void setVolunteerExperience(String volunteerExperience) {
        this.volunteerExperience = volunteerExperience;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "VolunteerReviewDto{" +
                "reviewId=" + reviewId +
                ", userId='" + userId + '\'' +
                ", userName='" + userName + '\'' +
                ", applicationId=" + applicationId +
                ", activityName='" + activityName + '\'' +
                ", volunteerExperience='" + volunteerExperience + '\'' +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", rating=" + rating +
                ", createdAt=" + createdAt +
                '}';
    }
}
