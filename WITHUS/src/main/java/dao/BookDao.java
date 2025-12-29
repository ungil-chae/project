package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import model.Book;
import util.DBUtil;

/**
 * Book 테이블 전용 DAO
 */
public class BookDao {

    /* ------------------------------------------------------------------
     * 1.  단일 조회
     * ------------------------------------------------------------------ */
    public Book findById(int bookId) throws SQLException {
        // 이 메서드는 수정사항 없습니다.
        final String sql = "SELECT * FROM books WHERE book_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    /* ------------------------------------------------------------------
     * 2.  여러 건 조회 (id 목록)
     * ------------------------------------------------------------------ */
    public List<Book> findByIds(List<Integer> ids) throws SQLException {
        // 이 메서드는 수정사항 없습니다.
        if (ids == null || ids.isEmpty()) return new ArrayList<>();

        String placeholders = String.join(",", java.util.Collections.nCopies(ids.size(), "?"));
        final String sql = "SELECT * FROM books WHERE book_id IN (" + placeholders + ")";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 1, ids.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                List<Book> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }

    /* ------------------------------------------------------------------
     * 3.  단일 삽입 [수정됨]
     * ------------------------------------------------------------------ */
    public int insert(Book book) throws SQLException {
        // [수정] SQL 쿼리에 category 필드를 추가합니다.
        final String sql = "INSERT INTO books " +
            "(isbn, title, author, publisher, pub_date, description, cover_image_url, link, category) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, book.getIsbn());
            ps.setString(2, book.getTitle());
            ps.setString(3, book.getAuthor());
            ps.setString(4, book.getPublisher());

            LocalDate pubDate = book.getPubDate();
            if (pubDate != null) ps.setDate(5, Date.valueOf(pubDate));
            else                 ps.setNull(5, java.sql.Types.DATE);

            ps.setString(6, book.getDescription());
            ps.setString(7, book.getCoverImageUrl());
            ps.setString(8, book.getLink());
            ps.setString(9, book.getCategory()); // [수정] category 파라미터를 설정합니다.

            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                return (keys.next()) ? keys.getInt(1) : 0;
            }
        }
    }

    /* ------------------------------------------------------------------
     * 4.  행 매핑 유틸리티 [수정됨]
     * ------------------------------------------------------------------ */
    private Book mapRow(ResultSet rs) throws SQLException {
        Book b = new Book();

        b.setBookId(rs.getInt("book_id"));
        b.setIsbn(rs.getString("isbn"));
        b.setTitle(rs.getString("title"));
        b.setAuthor(rs.getString("author"));
        b.setPublisher(rs.getString("publisher"));

        Date sqlDate = rs.getDate("pub_date");
        if (sqlDate != null) {
            b.setPubDate(sqlDate.toLocalDate());
        }

        b.setDescription(rs.getString("description"));
        b.setCoverImageUrl(rs.getString("cover_image_url"));
        b.setLink(rs.getString("link"));

        // [수정] category 필드를 매핑하는 코드의 주석을 해제합니다.
        b.setCategory(rs.getString("category"));

        return b;
    }

    /* ------------------------------------------------------------------
     * 5.  여러 건 조회 (카테고리별) [추가됨]
     * ------------------------------------------------------------------ */
    public List<Book> findByCategory(String category) throws SQLException {
        final String sql = "SELECT * FROM books WHERE category = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category);

            try (ResultSet rs = ps.executeQuery()) {
                List<Book> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
                return list;
            }
        }
    }
    
 // [추가] 특정 카테고리에 속한 모든 책의 ID 목록을 조회합니다.
    public List<Integer> findBookIdsByCategory(String category) throws SQLException {
        final String sql = "SELECT book_id FROM books WHERE category = ?";
        List<Integer> bookIds = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookIds.add(rs.getInt("book_id"));
                }
            }
        }
        return bookIds;
    }
}