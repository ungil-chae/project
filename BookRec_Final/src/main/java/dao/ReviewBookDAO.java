package dao;

import model.ReviewBook;
import util.DBUtil; // DB 연결 유틸리티 클래스 (가정)

import java.sql.*;
import java.time.LocalDateTime;

public class ReviewBookDAO {

    // ISBN으로 ReviewBook을 찾는 메서드
    public ReviewBook findByIsbn(String isbn) throws SQLException {
        ReviewBook reviewBook = null;
        String sql = "SELECT book_id, isbn, title, author, publisher, cover_image_url, naver_link, description, pubdate, created_at, updated_at FROM ReviewBook WHERE isbn = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, isbn);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    reviewBook = new ReviewBook();
                    reviewBook.setBookId(rs.getInt("book_id"));
                    reviewBook.setIsbn(rs.getString("isbn"));
                    reviewBook.setTitle(rs.getString("title"));
                    reviewBook.setAuthor(rs.getString("author"));
                    reviewBook.setPublisher(rs.getString("publisher"));
                    reviewBook.setCoverImageUrl(rs.getString("cover_image_url"));
                    reviewBook.setNaverLink(rs.getString("naver_link"));
                    reviewBook.setDescription(rs.getString("description"));
                    reviewBook.setPubdate(rs.getDate("pubdate"));
                    reviewBook.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    reviewBook.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                }
            }
        }
        return reviewBook;
    }

    // 새로운 ReviewBook을 삽입하고 생성된 book_id를 반환하는 메서드
    public int insert(ReviewBook reviewBook) throws SQLException {
        String sql = "INSERT INTO ReviewBook (isbn, title, author, publisher, cover_image_url, naver_link, description, pubdate) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, reviewBook.getIsbn());
            pstmt.setString(2, reviewBook.getTitle());
            pstmt.setString(3, reviewBook.getAuthor());
            pstmt.setString(4, reviewBook.getPublisher());
            pstmt.setString(5, reviewBook.getCoverImageUrl());
            pstmt.setString(6, reviewBook.getNaverLink());
            pstmt.setString(7, reviewBook.getDescription());
            pstmt.setDate(8, reviewBook.getPubdate()); // pubdate가 java.sql.Date 타입이어야 합니다.

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1); // 생성된 book_id
                    }
                }
            }
        }
        return generatedId;
    }

    // book_id로 ReviewBook을 찾는 메서드 (선택 사항, 필요시 추가)
    public ReviewBook findById(int bookId) throws SQLException {
        ReviewBook reviewBook = null;
        String sql = "SELECT book_id, isbn, title, author, publisher, cover_image_url, naver_link, description, pubdate, created_at, updated_at FROM ReviewBook WHERE book_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, bookId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    reviewBook = new ReviewBook();
                    reviewBook.setBookId(rs.getInt("book_id"));
                    reviewBook.setIsbn(rs.getString("isbn"));
                    reviewBook.setTitle(rs.getString("title"));
                    reviewBook.setAuthor(rs.getString("author"));
                    reviewBook.setPublisher(rs.getString("publisher"));
                    reviewBook.setCoverImageUrl(rs.getString("cover_image_url"));
                    reviewBook.setNaverLink(rs.getString("naver_link"));
                    reviewBook.setDescription(rs.getString("description"));
                    reviewBook.setPubdate(rs.getDate("pubdate"));
                    reviewBook.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    reviewBook.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                }
            }
        }
        return reviewBook;
    }
}