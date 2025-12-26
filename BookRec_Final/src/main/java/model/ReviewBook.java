package model;

import java.sql.Date;
import java.time.LocalDateTime;

/**
 * 리뷰 도서 정보 모델
 * [변경] books 테이블과 연동 (기존 reviewbook 테이블 통합)
 * - category 필드 추가
 */
public class ReviewBook {
    private int bookId;
    private String isbn;
    private String title;
    private String author;
    private String publisher;
    private String coverImageUrl;
    private String naverLink;      // DB의 link 컬럼과 매핑
    private String description;
    private Date pubdate;          // DB의 pub_date 컬럼과 매핑
    private String category;       // [추가] 카테고리 필드
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public ReviewBook() {}

    public ReviewBook(int bookId, String isbn, String title, String author, String publisher,
                      String coverImageUrl, String naverLink, String description, Date pubdate,
                      String category, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.bookId = bookId;
        this.isbn = isbn;
        this.title = title;
        this.author = author;
        this.publisher = publisher;
        this.coverImageUrl = coverImageUrl;
        this.naverLink = naverLink;
        this.description = description;
        this.pubdate = pubdate;
        this.category = category;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getter 및 Setter 메서드 (생략, 필요시 추가)
    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }

    public String getCoverImageUrl() { return coverImageUrl; }
    public void setCoverImageUrl(String coverImageUrl) { this.coverImageUrl = coverImageUrl; }

    public String getNaverLink() { return naverLink; }
    public void setNaverLink(String naverLink) { this.naverLink = naverLink; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getPubdate() { return pubdate; }
    public void setPubdate(Date pubdate) { this.pubdate = pubdate; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    // [추가] category Getter/Setter
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    @Override
    public String toString() {
        return "ReviewBook{" +
               "bookId=" + bookId +
               ", isbn='" + isbn + '\'' +
               ", title='" + title + '\'' +
               ", author='" + author + '\'' +
               ", publisher='" + publisher + '\'' +
               ", coverImageUrl='" + coverImageUrl + '\'' +
               ", naverLink='" + naverLink + '\'' +
               ", description='" + description + '\'' +
               ", pubdate=" + pubdate +
               ", category='" + category + '\'' +
               ", createdAt=" + createdAt +
               ", updatedAt=" + updatedAt +
               '}';
    }
}