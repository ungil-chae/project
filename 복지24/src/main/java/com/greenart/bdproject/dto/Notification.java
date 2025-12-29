package com.greenart.bdproject.dto;

import java.sql.Date;
import java.sql.Timestamp;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * 알림 DTO (새 스키마 지원)
 * DB 스키마 변경에 따른 수정:
 * - userId VARCHAR(50) → memberId BIGINT UNSIGNED
 * - readAt TIMESTAMP 추가
 */
public class Notification {
    @JsonProperty("notification_id")
    private Long notificationId;

    @JsonProperty("member_id")
    private Long memberId;  // 새 스키마: member_id (BIGINT)

    @JsonProperty("user_id")
    private String userId;  // 호환성 유지: email을 userId로 사용

    @JsonProperty("notification_type")
    private String type; // DONATION_REMINDER, VOLUNTEER_REMINDER, CALENDAR_EVENT, GENERAL

    private String title;

    private String content;

    @JsonProperty("message")
    private String message; // content의 별칭으로 사용

    @JsonProperty("related_id")
    private Long relatedId;

    @JsonProperty("event_date")
    private Date eventDate;  // 이벤트 날짜 (캘린더 일정 등)

    @JsonProperty("related_url")
    private String relatedUrl;

    @JsonProperty("is_read")
    private boolean isRead;

    @JsonProperty("read_at")
    private Timestamp readAt;  // 새 스키마: 읽은 시간

    @JsonProperty("created_at")
    private Timestamp createdAt;

    @JsonProperty("deleted_at")
    private Timestamp deletedAt;  // 소프트 삭제

    // 기본 생성자
    public Notification() {
    }

    // 전체 생성자 (호환성 유지)
    public Notification(String userId, String type, String title, String content, Long relatedId, String relatedUrl) {
        this.userId = userId;
        this.type = type;
        this.title = title;
        this.content = content;
        this.relatedId = relatedId;
        this.relatedUrl = relatedUrl;
        this.isRead = false;
    }

    // Getter and Setter
    public Long getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(Long notificationId) {
        this.notificationId = notificationId;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
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
        this.message = content; // message와 동기화
    }

    public String getMessage() {
        return message != null ? message : content;
    }

    public void setMessage(String message) {
        this.message = message;
        this.content = message; // content와 동기화
    }

    public Long getRelatedId() {
        return relatedId;
    }

    public void setRelatedId(Long relatedId) {
        this.relatedId = relatedId;
    }

    public Date getEventDate() {
        return eventDate;
    }

    public void setEventDate(Date eventDate) {
        this.eventDate = eventDate;
    }

    public String getRelatedUrl() {
        return relatedUrl;
    }

    public void setRelatedUrl(String relatedUrl) {
        this.relatedUrl = relatedUrl;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }

    public Timestamp getReadAt() {
        return readAt;
    }

    public void setReadAt(Timestamp readAt) {
        this.readAt = readAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getDeletedAt() {
        return deletedAt;
    }

    public void setDeletedAt(Timestamp deletedAt) {
        this.deletedAt = deletedAt;
    }

    @Override
    public String toString() {
        return "Notification{" +
                "notificationId=" + notificationId +
                ", memberId=" + memberId +
                ", userId='" + userId + '\'' +
                ", type='" + type + '\'' +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", relatedId=" + relatedId +
                ", eventDate=" + eventDate +
                ", relatedUrl='" + relatedUrl + '\'' +
                ", isRead=" + isRead +
                ", readAt=" + readAt +
                ", createdAt=" + createdAt +
                '}';
    }
}
