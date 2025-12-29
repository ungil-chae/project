package dto;

// 클라이언트에게 셀럽 추천에 포함된 책 목록을 응답할 때 사용할 데이터 구조
// Book 모델의 일부 정보를 포함합니다.
public class CelebRecommendedBookResponse {
    private final int bookId;
    private final String title;
    private final String author;
    private final String coverImageUrl;
    private final int orderInRec; // 셀럽 추천 내에서의 순서

    public CelebRecommendedBookResponse(int bookId, String title, String author, String coverImageUrl, int orderInRec) {
        this.bookId = bookId;
        this.title = title;
        this.author = author;
        this.coverImageUrl = coverImageUrl;
        this.orderInRec = orderInRec;
    }

    // Getter 메서드 (final 필드이므로 Setter 없음)
    public int getBookId() { return bookId; }
    public String getTitle() { return title; }
    public String getAuthor() { return author; }
    public String getCoverImageUrl() { return coverImageUrl; }
    public int getOrderInRec() { return orderInRec; }

    @Override
    public String toString() {
        return "CelebRecommendedBookResponse{" +
               "bookId=" + bookId +
               ", title='" + title + '\'' +
               ", author='" + author + '\'' +
               ", orderInRec=" + orderInRec +
               '}';
    }
}