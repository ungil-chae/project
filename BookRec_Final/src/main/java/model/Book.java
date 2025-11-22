package model;

import java.time.LocalDate; // pub_date 필드를 위해 LocalDate 임포트
import java.util.Objects; // for equals/hashCode

public class Book {
    private int bookId;
    private String isbn; // 국제 표준 도서 번호
    private String title;
    private String author;
    private String publisher;
    private LocalDate pubDate; // 출판일
    private String description;
    private String coverImageUrl;
    private String link; // 구매 링크 등
    private String category; // [추가] 카테고리 필드

    public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	// 기본 생성자
    public Book() {}

    // 모든 필드를 포함하는 생성자
    public Book(int bookId, String isbn, String title, String author, String publisher,
                LocalDate pubDate, String description, String coverImageUrl, String link) {
        this.bookId = bookId;
        this.isbn = isbn;
        this.title = title;
        this.author = author;
        this.publisher = publisher;
        this.pubDate = pubDate;
        this.description = description;
        this.coverImageUrl = coverImageUrl;
        this.link = link;
    }

    // Getter 및 Setter 메서드
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

    public LocalDate getPubDate() { return pubDate; }
    public void setPubDate(LocalDate pubDate) { this.pubDate = pubDate; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCoverImageUrl() { return coverImageUrl; }
    public void setCoverImageUrl(String coverImageUrl) { this.coverImageUrl = coverImageUrl; }

    public String getLink() { return link; }
    public void setLink(String link) { this.link = link; }

    @Override
    public String toString() {
        return "Book{" +
               "bookId=" + bookId +
               ", title='" + title + '\'' +
               ", author='" + author + '\'' +
               ", publisher='" + publisher + '\'' +
               ", pubDate=" + pubDate +
               '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Book book = (Book) o;
        return bookId == book.bookId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(bookId);
    }
}