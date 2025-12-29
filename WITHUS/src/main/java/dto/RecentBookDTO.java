package dto;

import java.io.Serializable;
import java.util.Objects;

/**
 * DB 책 또는 API 책의 정보를 통합하여 세션에 저장하기 위한 DTO(Data Transfer Object).
 * Serializable 인터페이스 구현은 세션 직렬화를 위해 권장됩니다.
 */
public class RecentBookDTO implements Serializable {

    private static final long serialVersionUID = 1L; // Serializable ID

    private String id;     // 책 고유 ID (DB의 book_id 또는 네이버의 ISBN)
    private String title;  // 제목
    private String author; // 저자
    private String image;  // 이미지 URL
    private String link;   // 상세 페이지로 이동할 최종 링크

    // 기본 생성자
    public RecentBookDTO() {
    }

    // 모든 필드를 받는 생성자
    public RecentBookDTO(String id, String title, String author, String image, String link) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.image = image;
        this.link = link;
    }

    // --- Getters and Setters ---
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    // equals와 hashCode는 목록에서 중복된 책을 효율적으로 찾고 제거하기 위해 구현합니다.
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        RecentBookDTO that = (RecentBookDTO) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "RecentBookDTO{" +
                "id='" + id + '\'' +
                ", title='" + title + '\'' +
                '}';
    }
}