package model;

import java.util.Objects;

public class CelebRecommendedBook {
    private int celebRecBookId;
    private int celebRecId;
    private int bookId;
    private int orderInRec;

    public CelebRecommendedBook() {}

    public CelebRecommendedBook(int celebRecBookId, int celebRecId, int bookId, int orderInRec) {
        this.celebRecBookId = celebRecBookId;
        this.celebRecId = celebRecId;
        this.bookId = bookId;
        this.orderInRec = orderInRec;
    }

    // --- Getters ---
    public int getCelebRecBookId() { return celebRecBookId; }
    public int getCelebRecId() { return celebRecId; }
    public int getBookId() { return bookId; }
    public int getOrderInRec() { return orderInRec; }

    // --- Setters ---
    public void setCelebRecBookId(int celebRecBookId) { this.celebRecBookId = celebRecBookId; }
    public void setCelebRecId(int celebRecId) { this.celebRecId = celebRecId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    public void setOrderInRec(int orderInRec) { this.orderInRec = orderInRec; }

    @Override
    public String toString() {
        return "CelebRecommendedBook{" +
               "celebRecBookId=" + celebRecBookId +
               ", celebRecId=" + celebRecId +
               ", bookId=" + bookId +
               ", orderInRec=" + orderInRec +
               '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CelebRecommendedBook that = (CelebRecommendedBook) o;
        return celebRecBookId == that.celebRecBookId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(celebRecBookId);
    }
}