package dto;

import java.time.LocalDateTime;
import java.util.List;     // List 임포트

import model.ContentBlock; // ContentBlock 모델 클래스 임포트

// 리뷰 상세 페이지에 표시할 모든 데이터를 담는 DTO
// ReviewListDisplayDTO를 상속받아 리뷰의 기본 정보와 책 정보를 포함합니다.
public class ReviewDetailDisplayDTO extends ReviewListDisplayDTO {
    private List<ContentBlock> contentBlocks; // 해당 리뷰의 내용 블록들

    // 기본 생성자
    public ReviewDetailDisplayDTO() {
        super(); // 부모 클래스(ReviewListDisplayDTO)의 기본 생성자 호출
    }

    // 모든 필드를 포함하는 생성자
    // 부모 클래스(ReviewListDisplayDTO)의 필드와 자체 필드를 모두 초기화합니다.
    // isbn 파라미터를 추가하고 super() 호출 시 전달합니다.
    public ReviewDetailDisplayDTO(int reviewId, int userId, String reviewText, int rating,
                                  LocalDateTime createdAt, LocalDateTime updatedAt,
                                  int bookId, String isbn, String bookTitle, String bookAuthor, String bookCoverImageUrl, // <<-- String isbn 추가!
                                  List<ContentBlock> contentBlocks) {
        // super() 호출 시 isbn 파라미터를 추가합니다.
        super(reviewId, userId, reviewText, rating, createdAt, updatedAt,
              bookId, isbn, bookTitle, bookAuthor, bookCoverImageUrl); // <<-- super()에 isbn 전달!
        this.contentBlocks = contentBlocks;
    }

    // Getter 및 Setter 메서드
    public List<ContentBlock> getContentBlocks() {
        return contentBlocks;
    }

    public void setContentBlocks(List<ContentBlock> contentBlocks) {
        this.contentBlocks = contentBlocks;
    }

    // toString() 메서드 오버라이드 (디버깅 용이)
    @Override
    public String toString() {
        return "ReviewDetailDisplayDTO{" +
               "reviewId=" + getReviewId() +
               ", userId=" + getUserId() +
               ", reviewText='" + getReviewText() + '\'' +
               ", rating=" + getRating() +
               ", createdAt=" + getCreatedAt() +
               ", updatedAt=" + getUpdatedAt() +
               ", bookId=" + getBookId() +
               ", isbn='" + getIsbn() + '\'' + // isbn 필드도 toString에 포함
               ", bookTitle='" + getBookTitle() + '\'' +
               ", bookAuthor='" + getBookAuthor() + '\'' +
               ", bookCoverImageUrl='" + getBookCoverImageUrl() + '\'' +
               ", contentBlocks=" + (contentBlocks != null ? contentBlocks.size() + " blocks" : "null") +
               '}';
    }
}