package dto;

import model.Review;
import model.ReviewBook;
import java.time.LocalDateTime;

// 리뷰 목록 화면에 표시할 데이터를 담는 DTO
public class ReviewListDisplayDTO {
    // Review 테이블에서 가져올 정보
    private int reviewId;
    private int userId;
    private String reviewText;
    private int rating;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // ReviewBook 테이블에서 가져올 정보
    private int bookId;
    private String isbn; // <<-- 이 줄을 추가합니다!
    private String bookTitle;
    private String bookAuthor;
    private String bookCoverImageUrl;

    public ReviewListDisplayDTO() {}

    // 생성자 (isbn 필드도 추가)
    public ReviewListDisplayDTO(int reviewId, int userId, String reviewText, int rating,
                                LocalDateTime createdAt, LocalDateTime updatedAt,
                                int bookId, String isbn, String bookTitle, String bookAuthor, String bookCoverImageUrl) { // <<-- isbn 파라미터 추가
        this.reviewId = reviewId;
        this.userId = userId;
        this.reviewText = reviewText;
        this.rating = rating;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.bookId = bookId;
        this.isbn = isbn; // <<-- 초기화
        this.bookTitle = bookTitle;
        this.bookAuthor = bookAuthor;
        this.bookCoverImageUrl = bookCoverImageUrl;
    }

    // Getter 및 Setter 메서드
    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getReviewText() { return reviewText; }
    public void setReviewText(String reviewText) { this.reviewText = reviewText; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getIsbn() { return isbn; } // <<-- 이 메서드를 추가합니다!
    public void setIsbn(String isbn) { this.isbn = isbn; } // <<-- 이 메서드를 추가합니다!

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getBookAuthor() { return bookAuthor; }
    public void setBookAuthor(String bookAuthor) { this.bookAuthor = bookAuthor; }

    public String getBookCoverImageUrl() { return bookCoverImageUrl; }
    public void setBookCoverImageUrl(String bookCoverImageUrl) { this.bookCoverImageUrl = bookCoverImageUrl; }

    @Override
    public String toString() {
        return "ReviewListDisplayDTO{" +
               "reviewId=" + reviewId +
               ", userId=" + userId +
               ", reviewText='" + reviewText + '\'' +
               ", rating=" + rating +
               ", createdAt=" + createdAt +
               ", updatedAt=" + updatedAt +
               ", bookId=" + bookId +
               ", isbn='" + isbn + '\'' + // <<-- toString에도 추가
               ", bookTitle='" + bookTitle + '\'' +
               ", bookAuthor='" + bookAuthor + '\'' +
               ", bookCoverImageUrl='" + bookCoverImageUrl + '\'' +
               '}';
    }
}