package dto;

// import java.util.Date; // <-- 불필요하므로 제거

public class CelebRecommendedBooks {
    private int celebRecBookId; // celeb_rec_book_id -> celebRecBookId
    private int celebRecId;     // celeb_rec_id -> celebRecId
    private int bookId;         // book_id -> bookId
    private int orderInRec;     // order_in_rec -> orderInRec

    public CelebRecommendedBooks() {
        // super(); // 불필요하므로 제거
    }

    public CelebRecommendedBooks(int celebRecBookId, int celebRecId, int bookId, int orderInRec) {
        // super(); // 불필요하므로 제거
        this.celebRecBookId = celebRecBookId;
        this.celebRecId = celebRecId;
        this.bookId = bookId;
        this.orderInRec = orderInRec;
    }

    // --- Getters (camelCase에 맞춰 변경) ---
    public int getCelebRecBookId() {
        return celebRecBookId;
    }
    public int getCelebRecId() {
        return celebRecId;
    }
    public int getBookId() {
        return bookId;
    }
    public int getOrderInRec() {
        return orderInRec;
    }

    // --- Setters (camelCase에 맞춰 변경) ---
    public void setCelebRecBookId(int celebRecBookId) {
        this.celebRecBookId = celebRecBookId;
    }
    public void setCelebRecId(int celebRecId) {
        this.celebRecId = celebRecId;
    }
    public void setBookId(int bookId) {
        this.bookId = bookId;
    }
    public void setOrderInRec(int orderInRec) {
        this.orderInRec = orderInRec;
    }
    
    @Override
    public String toString() {
        return "CelebRecommendedBooks [celebRecBookId=" + celebRecBookId + ", celebRecId=" + celebRecId
                + ", bookId=" + bookId + ", orderInRec=" + orderInRec + "]";
    }
}