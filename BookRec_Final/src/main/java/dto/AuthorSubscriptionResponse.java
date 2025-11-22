package dto;

import java.time.LocalDateTime;

public class AuthorSubscriptionResponse {
    private final int authorId;
    private final String authorName;
    private final LocalDateTime subscribedAt;

    public AuthorSubscriptionResponse(int authorId, String authorName, LocalDateTime subscribedAt) {
        this.authorId = authorId;
        this.authorName = authorName;
        this.subscribedAt = subscribedAt;
    }

    public int getAuthorId() { return authorId; }
    public String getAuthorName() { return authorName; }
    public LocalDateTime getSubscribedAt() { return subscribedAt; }

    @Override
    public String toString() {
        return "AuthorSubscriptionResponse{" +
               "authorId=" + authorId +
               ", authorName='" + authorName + '\'' +
               ", subscribedAt=" + subscribedAt +
               '}';
    }
}