package dto;

import java.time.LocalDateTime;

public class WishlistItemResponse {
    private final int bookId;
    private final String isbn;
    private final String title;
    private final String author;
    private final String coverImageUrl;
    private final LocalDateTime addedAt;
    private final String link; // [추가] 책 링크를 담을 필드

    // [수정] 생성자에 link 파라미터를 추가합니다.
    public WishlistItemResponse(int bookId, String isbn, String title, String author, String coverImageUrl, LocalDateTime addedAt, String link) {
        this.bookId = bookId;
        this.isbn = isbn;
        this.title = title;
        this.author = author;
        this.coverImageUrl = coverImageUrl;
        this.addedAt = addedAt;
        this.link = link; // [추가] 필드 초기화
    }

    // --- 기존 Getter 메서드들 ---
    public int getBookId() { return bookId; }
    public String getIsbn() { return isbn; }
    public String getTitle() { return title; }
    public String getAuthor() { return author; }
    public String getCoverImageUrl() { return coverImageUrl; }
    public LocalDateTime getAddedAt() { return addedAt; }

    // [추가] link 필드의 Getter 메서드
    public String getLink() { return link; }
    @Override
    public String toString() {
        return "WishlistItemResponse{" +
               "bookId=" + bookId +
               ", title='" + title + '\'' +
               ", author='" + author + '\'' +
               ", addedAt=" + addedAt +
               '}';
    }
}