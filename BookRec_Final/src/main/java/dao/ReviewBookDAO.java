package dao;

import model.ReviewBook;
import util.DBUtil;

import java.sql.*;
import java.time.LocalDateTime;

/**
 * ReviewBook DAO - books 테이블과 연동
 * [변경] 기존 ReviewBook 테이블이 books 테이블로 통합됨
 * - 테이블명: ReviewBook → books
 * - 컬럼명: naver_link → link, pubdate → pub_date
 */
public class ReviewBookDAO {

    /**
     * ISBN으로 도서 조회
     * [변경] books 테이블에서 조회
     */
    public ReviewBook findByIsbn(String isbn) throws SQLException {
        ReviewBook reviewBook = null;
        String sql = "SELECT book_id, isbn, title, author, publisher, cover_image_url, link, description, pub_date, category, created_at, updated_at FROM books WHERE isbn = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, isbn);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    reviewBook = mapResultSetToReviewBook(rs);
                }
            }
        }
        return reviewBook;
    }

    /**
     * 새로운 도서 삽입
     * [변경] books 테이블에 삽입, link 컬럼 사용
     */
    public int insert(ReviewBook reviewBook) throws SQLException {
        String sql = "INSERT INTO books (isbn, title, author, publisher, cover_image_url, link, description, pub_date, category) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, reviewBook.getIsbn());
            pstmt.setString(2, reviewBook.getTitle());
            pstmt.setString(3, reviewBook.getAuthor());
            pstmt.setString(4, reviewBook.getPublisher());
            pstmt.setString(5, reviewBook.getCoverImageUrl());
            pstmt.setString(6, reviewBook.getNaverLink()); // naverLink → link 컬럼에 저장
            pstmt.setString(7, reviewBook.getDescription());
            pstmt.setDate(8, reviewBook.getPubdate());
            pstmt.setString(9, reviewBook.getCategory()); // category 추가

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        }
        return generatedId;
    }

    /**
     * book_id로 도서 조회
     * [변경] books 테이블에서 조회
     */
    public ReviewBook findById(int bookId) throws SQLException {
        ReviewBook reviewBook = null;
        String sql = "SELECT book_id, isbn, title, author, publisher, cover_image_url, link, description, pub_date, category, created_at, updated_at FROM books WHERE book_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, bookId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    reviewBook = mapResultSetToReviewBook(rs);
                }
            }
        }
        return reviewBook;
    }

    /**
     * ResultSet을 ReviewBook 객체로 매핑
     */
    private ReviewBook mapResultSetToReviewBook(ResultSet rs) throws SQLException {
        ReviewBook reviewBook = new ReviewBook();
        reviewBook.setBookId(rs.getInt("book_id"));
        reviewBook.setIsbn(rs.getString("isbn"));
        reviewBook.setTitle(rs.getString("title"));
        reviewBook.setAuthor(rs.getString("author"));
        reviewBook.setPublisher(rs.getString("publisher"));
        reviewBook.setCoverImageUrl(rs.getString("cover_image_url"));
        reviewBook.setNaverLink(rs.getString("link")); // link → naverLink로 매핑
        reviewBook.setDescription(rs.getString("description"));
        reviewBook.setPubdate(rs.getDate("pub_date")); // pub_date로 변경
        reviewBook.setCategory(rs.getString("category")); // category 추가

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            reviewBook.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            reviewBook.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return reviewBook;
    }
}