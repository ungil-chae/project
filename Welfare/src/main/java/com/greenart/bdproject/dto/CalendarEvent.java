package com.greenart.bdproject.dto;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonFormat;

/**
 * 캘린더 일정 DTO
 */
public class CalendarEvent {
    @JsonProperty("event_id")
    private Long eventId;

    @JsonProperty("member_id")
    private Long memberId;

    private String title;

    private String description;

    @JsonProperty("event_date")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date eventDate;

    @JsonProperty("event_time")
    private Time eventTime;

    @JsonProperty("event_type")
    private String eventType; // PERSONAL, DONATION, VOLUNTEER, ETC

    @JsonProperty("reminder_enabled")
    private Boolean reminderEnabled;

    @JsonProperty("remind_before_days")
    private Integer remindBeforeDays;

    private String status; // SCHEDULED, COMPLETED, CANCELLED

    @JsonProperty("created_at")
    private Timestamp createdAt;

    @JsonProperty("updated_at")
    private Timestamp updatedAt;

    // 프론트엔드 호환성을 위한 추가 필드
    @JsonProperty("start_date")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date startDate;

    @JsonProperty("end_date")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date endDate;

    private String type; // single or range

    private Long id; // 프론트엔드에서 사용하는 ID

    // 기본 생성자
    public CalendarEvent() {
        this.reminderEnabled = true;
        this.remindBeforeDays = 1;
        this.eventType = "PERSONAL";
        this.status = "SCHEDULED";
    }

    // Getter and Setter
    public Long getEventId() {
        return eventId;
    }

    public void setEventId(Long eventId) {
        this.eventId = eventId;
        this.id = eventId; // 프론트엔드 호환성
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getEventDate() {
        return eventDate;
    }

    public void setEventDate(Date eventDate) {
        this.eventDate = eventDate;
        this.startDate = eventDate; // 프론트엔드 호환성
    }

    public Time getEventTime() {
        return eventTime;
    }

    public void setEventTime(Time eventTime) {
        this.eventTime = eventTime;
    }

    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public Boolean getReminderEnabled() {
        return reminderEnabled;
    }

    public void setReminderEnabled(Boolean reminderEnabled) {
        this.reminderEnabled = reminderEnabled;
    }

    public Integer getRemindBeforeDays() {
        return remindBeforeDays;
    }

    public void setRemindBeforeDays(Integer remindBeforeDays) {
        this.remindBeforeDays = remindBeforeDays;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    // 프론트엔드 호환성 필드
    public Date getStartDate() {
        return startDate != null ? startDate : eventDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
        this.eventDate = startDate;  // 항상 eventDate도 함께 설정
    }

    public Date getEndDate() {
        return endDate != null ? endDate : eventDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Long getId() {
        return id != null ? id : eventId;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "CalendarEvent{" +
                "eventId=" + eventId +
                ", memberId=" + memberId +
                ", title='" + title + '\'' +
                ", eventDate=" + eventDate +
                ", eventType='" + eventType + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
