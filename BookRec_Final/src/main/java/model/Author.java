package model;

import java.time.LocalDateTime;
import java.util.Objects; // for equals/hashCode

public class Author {
    private int authorId;
    private String authorName;
    private String authorDescription;
    private String authorImageUrl;
    private LocalDateTime createdAt;

    // 기본 생성자
    public Author() {}

    // 모든 필드를 포함하는 생성자
    public Author(int authorId, String authorName, String authorDescription, String authorImageUrl, LocalDateTime createdAt) {
        this.authorId = authorId;
        this.authorName = authorName;
        this.authorDescription = authorDescription;
        this.authorImageUrl = authorImageUrl;
        this.createdAt = createdAt;
    }

    // Getter 및 Setter 메서드
    public int getAuthorId() { return authorId; }
    public void setAuthorId(int authorId) { this.authorId = authorId; }

    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }

    public String getAuthorDescription() { return authorDescription; }
    public void setAuthorDescription(String authorDescription) { this.authorDescription = authorDescription; }

    public String getAuthorImageUrl() { return authorImageUrl; }
    public void setAuthorImageUrl(String authorImageUrl) { this.authorImageUrl = authorImageUrl; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Author{" +
               "authorId=" + authorId +
               ", authorName='" + authorName + '\'' +
               ", description='" + (authorDescription != null && authorDescription.length() > 20 ? authorDescription.substring(0, 20) + "..." : authorDescription) + '\'' +
               '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Author author = (Author) o;
        return authorId == author.authorId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(authorId);
    }
}