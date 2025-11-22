package com.greenart.bdproject.dto;

import java.sql.Timestamp;

/**
 * 알림 DTO (새 스키마 지원)
 * DB 스키마 변경에 따른 수정:
 * - userId VARCHAR(50) → memberId BIGINT UNSIGNED
 * - readAt TIMESTAMP 추가
 */
public class Notification {
    private Long notificationId;
    private Long memberId;  // 새 스키마: member_id (BIGINT)
    private String userId;  // 호환성 유지: email을 userId로 사용
    private String type; // DONATION, VOLUNTEER, WELFARE, SYSTEM, NOTICE, EVENT
    private String title;
    private String content;
    private Long relatedId;
    private String relatedUrl;
    private boolean isRead;
    private Timestamp readAt;  // 새 스키마: 읽은 시간
    private Timestamp createdAt;

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
    }

    public Long getRelatedId() {
        return relatedId;
    }

    public void setRelatedId(Long relatedId) {
        this.relatedId = relatedId;
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
                ", relatedUrl='" + relatedUrl + '\'' +
                ", isRead=" + isRead +
                ", readAt=" + readAt +
                ", createdAt=" + createdAt +
                '}';
    }
}
