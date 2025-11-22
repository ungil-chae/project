package dto;

import java.time.LocalDateTime;

public class InquiryResponse {
    private final int inquiryId;
    private final int userId; // 이 필드는 필요에 따라 제외 가능 (마이페이지에서는 본인 userId로 조회하므로)
    private final String inquiryType;
    private final String title;
    private final String content;
    private final LocalDateTime createdAt;
    private final String status; // "pending", "answered", "closed"
    private final String answerContent;
    private final LocalDateTime answeredAt;

    public InquiryResponse(int inquiryId, int userId, String inquiryType, String title, String content,
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

    // Getter 메서드
    public int getInquiryId() { return inquiryId; }
    public int getUserId() { return userId; }
    public String getInquiryType() { return inquiryType; }
    public String getTitle() { return title; }
    public String getContent() { return content; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public String getStatus() { return status; }
    public String getAnswerContent() { return answerContent; }
    public LocalDateTime getAnsweredAt() { return answeredAt; }

    @Override
    public String toString() {
        return "InquiryResponse{" +
               "inquiryId=" + inquiryId +
               ", title='" + title + '\'' +
               ", status='" + status + '\'' +
               '}';
    }
}