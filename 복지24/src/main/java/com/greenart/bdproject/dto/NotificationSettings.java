package com.greenart.bdproject.dto;

import java.sql.Timestamp;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * 알림 설정 DTO
 */
public class NotificationSettings {
    @JsonProperty("setting_id")
    private Long settingId;

    @JsonProperty("member_id")
    private Long memberId;

    @JsonProperty("event_notification")
    private Boolean eventNotification;

    @JsonProperty("donation_notification")
    private Boolean donationNotification;

    @JsonProperty("volunteer_notification")
    private Boolean volunteerNotification;

    @JsonProperty("faq_answer_notification")
    private Boolean faqAnswerNotification;

    @JsonProperty("created_at")
    private Timestamp createdAt;

    @JsonProperty("updated_at")
    private Timestamp updatedAt;

    // 기본 생성자
    public NotificationSettings() {
        this.eventNotification = true;
        this.donationNotification = true;
        this.volunteerNotification = true;
        this.faqAnswerNotification = true;
    }

    // Getter and Setter
    public Long getSettingId() {
        return settingId;
    }

    public void setSettingId(Long settingId) {
        this.settingId = settingId;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public Boolean getEventNotification() {
        return eventNotification;
    }

    public void setEventNotification(Boolean eventNotification) {
        this.eventNotification = eventNotification;
    }

    public Boolean getDonationNotification() {
        return donationNotification;
    }

    public void setDonationNotification(Boolean donationNotification) {
        this.donationNotification = donationNotification;
    }

    public Boolean getVolunteerNotification() {
        return volunteerNotification;
    }

    public void setVolunteerNotification(Boolean volunteerNotification) {
        this.volunteerNotification = volunteerNotification;
    }

    public Boolean getFaqAnswerNotification() {
        return faqAnswerNotification;
    }

    public void setFaqAnswerNotification(Boolean faqAnswerNotification) {
        this.faqAnswerNotification = faqAnswerNotification;
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

    @Override
    public String toString() {
        return "NotificationSettings{" +
                "settingId=" + settingId +
                ", memberId=" + memberId +
                ", eventNotification=" + eventNotification +
                ", donationNotification=" + donationNotification +
                ", volunteerNotification=" + volunteerNotification +
                ", faqAnswerNotification=" + faqAnswerNotification +
                '}';
    }
}
