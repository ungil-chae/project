package model;

import java.time.LocalDateTime;
import java.util.Objects; // for equals/hashCode

public class Inquiry {
    private int inquiryId;
    private int userId;
    private String inquiryType; // '일반', '오류', '제안' 등
    private String title;
    private String content;
    private LocalDateTime createdAt;
    private String status; // 'pending', 'answered', 'closed'
    private String answerContent;
    private LocalDateTime answeredAt;

    // 기본 생성자
    public Inquiry() {}

    // 모든 필드를 포함하는 생성자
    public Inquiry(int inquiryId, int userId, String inquiryType, String title, String content,
                   LocalDateTime createdAt, String status, String answerContent, LocalDateTime answeredAt) {
        this.inquiryId = inquiryId;
        this.userId = userId;
        this.inquiryType = inquiryType;
        this.title = title;
        this.content = content;
        this.createdAt = createdAt;
        this.status = status;
        this.answerContent = answerContent;
        this.answeredAt = answeredAt;
    }

    // Getter 및 Setter 메서드
    public int getInquiryId() { return inquiryId; }
    public void setInquiryId(int inquiryId) { this.inquiryId = inquiryId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getInquiryType() { return inquiryType; }
    public void setInquiryType(String inquiryType) { this.inquiryType = inquiryType; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAnswerContent() { return answerContent; }
    public void setAnswerContent(String answerContent) { this.answerContent = answerContent; }

    public LocalDateTime getAnsweredAt() { return answeredAt; }
    public void setAnsweredAt(LocalDateTime answeredAt) { this.answeredAt = answeredAt; }

    @Override
    public String toString() {
        return "Inquiry{" +
               "inquiryId=" + inquiryId +
               ", userId=" + userId +
               ", title='" + title + '\'' +
               ", status='" + status + '\'' +
               '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Inquiry inquiry = (Inquiry) o;
        return inquiryId == inquiry.inquiryId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(inquiryId);
    }
}