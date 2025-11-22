package com.greenart.bdproject.dto;

import java.sql.Date;
import java.sql.Timestamp;

public class VolunteerApplicationDto {
    private Long applicationId;
    private Long activityId;  // 새 스키마: 봉사 활동 ID
    private Long memberId;    // 새 스키마: member_id (BIGINT)
    private String applicantName;
    private String applicantPhone;
    private String applicantEmail;
    private Date applicantBirth;  // 새 스키마: 생년월일
    private String applicantGender;  // 새 스키마: 성별
    private String applicantAddress;
    private String volunteerExperience;
    private String selectedCategory;
    private String motivation;  // 새 스키마: 지원 동기
    private Date volunteerDate;
    private Date volunteerEndDate;
    private String volunteerTime;
    private String status;
    private Boolean attendanceChecked;  // 새 스키마: 출석 확인
    private Integer actualHours;  // 새 스키마: 실제 봉사 시간
    private String cancelReason;  // 새 스키마: 취소 사유
    private String rejectReason;  // 새 스키마: 거절 사유
    private Timestamp completedAt;
    private Timestamp cancelledAt;  // 새 스키마: 취소 일시
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // 리뷰 작성 가능 여부 (3일 이내)
    private boolean canWriteReview;

    // 리뷰 작성 여부
    private boolean hasReview;

    public VolunteerApplicationDto() {
    }

    public Long getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(Long applicationId) {
        this.applicationId = applicationId;
    }

    public Long getActivityId() {
        return activityId;
    }

    public void setActivityId(Long activityId) {
        this.activityId = activityId;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public String getApplicantName() {
        return applicantName;
    }

    public void setApplicantName(String applicantName) {
        this.applicantName = applicantName;
    }

    public String getApplicantPhone() {
        return applicantPhone;
    }

    public void setApplicantPhone(String applicantPhone) {
        this.applicantPhone = applicantPhone;
    }

    public String getApplicantEmail() {
        return applicantEmail;
    }

    public void setApplicantEmail(String applicantEmail) {
        this.applicantEmail = applicantEmail;
    }

    public Date getApplicantBirth() {
        return applicantBirth;
    }

    public void setApplicantBirth(Date applicantBirth) {
        this.applicantBirth = applicantBirth;
    }

    public String getApplicantGender() {
        return applicantGender;
    }

    public void setApplicantGender(String applicantGender) {
        this.applicantGender = applicantGender;
    }

    public String getApplicantAddress() {
        return applicantAddress;
    }

    public void setApplicantAddress(String applicantAddress) {
        this.applicantAddress = applicantAddress;
    }

    public String getVolunteerExperience() {
        return volunteerExperience;
    }

    public void setVolunteerExperience(String volunteerExperience) {
        this.volunteerExperience = volunteerExperience;
    }

    public String getSelectedCategory() {
        return selectedCategory;
    }

    public void setSelectedCategory(String selectedCategory) {
        this.selectedCategory = selectedCategory;
    }

    public String getMotivation() {
        return motivation;
    }

    public void setMotivation(String motivation) {
        this.motivation = motivation;
    }

    public Date getVolunteerDate() {
        return volunteerDate;
    }

    public void setVolunteerDate(Date volunteerDate) {
        this.volunteerDate = volunteerDate;
    }

    public Date getVolunteerEndDate() {
        return volunteerEndDate;
    }

    public void setVolunteerEndDate(Date volunteerEndDate) {
        this.volunteerEndDate = volunteerEndDate;
    }

    public String getVolunteerTime() {
        return volunteerTime;
    }

    public void setVolunteerTime(String volunteerTime) {
        this.volunteerTime = volunteerTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Boolean getAttendanceChecked() {
        return attendanceChecked;
    }

    public void setAttendanceChecked(Boolean attendanceChecked) {
        this.attendanceChecked = attendanceChecked;
    }

    public Integer getActualHours() {
        return actualHours;
    }

    public void setActualHours(Integer actualHours) {
        this.actualHours = actualHours;
    }

    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    public String getRejectReason() {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public Timestamp getCancelledAt() {
        return cancelledAt;
    }

    public void setCancelledAt(Timestamp cancelledAt) {
        this.cancelledAt = cancelledAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isCanWriteReview() {
        return canWriteReview;
    }

    public void setCanWriteReview(boolean canWriteReview) {
        this.canWriteReview = canWriteReview;
    }

    public boolean isHasReview() {
        return hasReview;
    }

    public void setHasReview(boolean hasReview) {
        this.hasReview = hasReview;
    }

    @Override
    public String toString() {
        return "VolunteerApplicationDto{" +
                "applicationId=" + applicationId +
                ", activityId=" + activityId +
                ", memberId=" + memberId +
                ", applicantName='" + applicantName + '\'' +
                ", selectedCategory='" + selectedCategory + '\'' +
                ", volunteerDate=" + volunteerDate +
                ", status='" + status + '\'' +
                '}';
    }
}
