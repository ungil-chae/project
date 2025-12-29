package model;

import java.time.LocalDateTime;
// 필요한 다른 import 문이 있다면 여기에 추가하세요.

public class Review {
    private int reviewId;
    private int userId;    // <<-- 이 부분이 'int'로 되어 있어야 합니다!
    private int bookId;
    private String reviewText;
    private int rating;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 기본 생성자
    public Review() {}

    // 모든 필드를 포함하는 생성자 (필요에 따라 오버로드)
    public Review(int reviewId, int userId, int bookId, String reviewText, int rating,
                  LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.bookId = bookId;
        this.reviewText = reviewText;
        this.rating = rating;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getter 및 Setter 메서드
    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }

    public int getUserId() { return userId; } // <<-- 이 메서드가 'int'를 반환하도록 되어 있어야 합니다!
    public void setUserId(int userId) { this.userId = userId; } // <<-- 이 메서드가 'int'를 받도록 되어 있어야 합니다!

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getReviewText() { return reviewText; }
    public void setReviewText(String reviewText) { this.reviewText = reviewText; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "Review{" +
               "reviewId=" + reviewId +
               ", userId=" + userId +
               ", bookId=" + bookId +
               ", reviewText='" + reviewText + '\'' +
               ", rating=" + rating +
               ", createdAt=" + createdAt +
               ", updatedAt=" + updatedAt +
               '}';
    }
}