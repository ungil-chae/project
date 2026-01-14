package dto;

/**
 * MBTI 기반 추천 도서 응답 DTO
 * 같은 MBTI 사용자들이 찜한 책 정보와 찜 횟수를 담습니다.
 */
public class BookRecommendationResponse {
    private final int bookId;
    private final String isbn;
    private final String title;
    private final String author;
    private final String publisher;
    private final String coverImageUrl;
    private final String link;
    private final int wishlistCount;  // 같은 MBTI 사용자들의 찜 횟수
    private final String reason;       // 추천 이유 메시지

    public BookRecommendationResponse(int bookId, String isbn, String title, String author,
                                      String publisher, String coverImageUrl, String link,
                                      int wishlistCount, String reason) {
        this.bookId = bookId;
        this.isbn = isbn;
        this.title = title;
        this.author = author;
        this.publisher = publisher;
        this.coverImageUrl = coverImageUrl;
        this.link = link;
        this.wishlistCount = wishlistCount;
        this.reason = reason;
    }

    // Getter 메서드
    public int getBookId() { return bookId; }
    public String getIsbn() { return isbn; }
    public String getTitle() { return title; }
    public String getAuthor() { return author; }
    public String getPublisher() { return publisher; }
    public String getCoverImageUrl() { return coverImageUrl; }
    public String getLink() { return link; }
    public int getWishlistCount() { return wishlistCount; }
    public String getReason() { return reason; }

    @Override
    public String toString() {
        return "BookRecommendationResponse{" +
                "bookId=" + bookId +
                ", title='" + title + '\'' +
                ", author='" + author + '\'' +
                ", wishlistCount=" + wishlistCount +
                '}';
    }
}
