package dto;

import java.time.LocalDateTime;

public class AuthorResponse {
    private final int authorId;
    private final String authorName;
    private final String authorDescription;
    private final String authorImageUrl;
    private final LocalDateTime subscribedAt; // 구독한 시각

    public AuthorResponse(int authorId, String authorName, String authorDescription, String authorImageUrl, LocalDateTime subscribedAt) {
        this.authorId = authorId;
        this.authorName = authorName;
        this.authorDescription = authorDescription;
        this.authorImageUrl = authorImageUrl;
        this.subscribedAt = subscribedAt;
    }

    // Getter 메서드
    public int getAuthorId() { return authorId; }
    public String getAuthorName() { return authorName; }
    public String getAuthorDescription() { return authorDescription; }
    public String getAuthorImageUrl() { return authorImageUrl; }
    public LocalDateTime getSubscribedAt() { return subscribedAt; }

    @Override
    public String toString() {
        return "AuthorResponse{" +
               "authorId=" + authorId +
               ", authorName='" + authorName + '\'' +
               '}';
    }
}