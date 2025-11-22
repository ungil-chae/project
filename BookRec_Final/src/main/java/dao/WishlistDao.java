package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import dto.WishlistItemResponse;
import util.DBUtil;

/**
 * wishlists 테이블 관련 데이터베이스 작업을 처리하는 DAO 클래스
 */
public class WishlistDao {

    /**
     * 1. 찜 목록에 책을 추가합니다.
     * @param userId 사용자 ID
     * @param bookId 책 ID
     * @return 삽입 성공 시 true, 이미 존재하여 실패 시 false
     * @throws SQLException 그 외 DB 오류 발생 시
     */
    public boolean addWishlist(int userId, int bookId) throws SQLException {
        final String sql = "INSERT INTO wishlists(user_id, book_id, added_at) VALUES (?, ?, NOW())";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            ps.executeUpdate();
            return true; // 삽입 성공

        } catch (SQLException e) {
            // MySQL 에러 코드 1062는 UNIQUE 제약 조건 위반(중복)을 의미합니다.
            if (e.getErrorCode() == 1062) {
                return false; // 이미 존재하는 경우
            }
            throw e; // 그 외 다른 SQL 예외는 다시 던집니다.
        }
    }

    /**
     * 2. 찜 목록에서 책을 제거합니다.
     * @param userId 사용자 ID
     * @param bookId 책 ID
     * @return 삭제 성공 시 true, 대상이 없어 실패 시 false
     * @throws SQLException DB 오류 발생 시
     */
    public boolean removeWishlist(int userId, int bookId) throws SQLException {
        final String sql = "DELETE FROM wishlists WHERE user_id = ? AND book_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, bookId); // [추가] 두 번째 파라미터에 bookId 값을 설정합니다.
            
            return ps.executeUpdate() == 1;
        }
    }

    /**
     * 3. 특정 책이 찜 목록에 이미 있는지 확인합니다.
     * @param userId 사용자 ID
     * @param bookId 책 ID
     * @return 존재하면 true, 없으면 false
     * @throws SQLException DB 오류 발생 시
     */
    public boolean isBookInWishlist(int userId, int bookId) throws SQLException {
        final String sql = "SELECT 1 FROM wishlists WHERE user_id = ? AND book_id = ? LIMIT 1";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // 행이 존재하면 true
            }
        }
    }

    /**
     * 4. 특정 사용자의 전체 찜 목록을 상세 정보와 함께 조회합니다.
     * (마이페이지 찜 목록 표시용)
     * @param userId 사용자 ID
     * @return WishlistItemResponse 객체 리스트
     * @throws SQLException DB 오류 발생 시
     */
    public List<WishlistItemResponse> getWishlistsByUserId(int userId) throws SQLException {
        // wishlists 테이블과 books 테이블을 JOIN하여 책의 상세 정보를 함께 가져옵니다.
        final String sql =
            "SELECT w.book_id, b.isbn, b.title, b.author, b.cover_image_url, w.added_at, b.link " +
            "FROM wishlists w JOIN books b ON w.book_id = b.book_id " +
            "WHERE w.user_id = ? ORDER BY w.added_at DESC";

        List<WishlistItemResponse> list = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LocalDateTime addedAt = null;
                    Timestamp ts = rs.getTimestamp("added_at");
                    if (ts != null) {
                        addedAt = ts.toLocalDateTime();
                    }

                    // DTO 객체를 생성할 때 link 정보까지 포함하여 전달합니다.
                    list.add(new WishlistItemResponse(
                        rs.getInt("book_id"),
                        rs.getString("isbn"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("cover_image_url"),
                        addedAt,
                        rs.getString("link") // 링크 정보 추가
                    ));
                }
            }
        }
        return list;
    }

    /**
     * 5. 특정 사용자의 찜 목록에 있는 책들의 ID만 조회합니다.
     * (페이지 로드 시 찜 상태를 효율적으로 확인하기 위함)
     * @param userId 사용자 ID
     * @return 책 ID(Integer)를 담고 있는 Set
     * @throws SQLException DB 오류 발생 시
     */
    public Set<Integer> getWishlistBookIdsByUserId(int userId) throws SQLException {
        final String sql = "SELECT book_id FROM wishlists WHERE user_id = ?";
        Set<Integer> bookIds = new HashSet<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookIds.add(rs.getInt("book_id"));
                }
            }
        }
        return bookIds;
    }
    
 // [추가] 여러 개의 책을 찜 목록에 한 번에 추가합니다. (JDBC Batch 사용)
    public void addBooksToWishlist(int userId, List<Integer> bookIds) throws SQLException {
        // 중복 추가를 방지하기 위해 ON DUPLICATE KEY UPDATE 구문을 사용합니다.
        // wishlists 테이블의 (user_id, book_id)에 복합 UNIQUE 키가 설정되어 있어야 합니다.
        final String sql = "INSERT INTO wishlists(user_id, book_id, added_at) VALUES (?, ?, NOW()) ON DUPLICATE KEY UPDATE user_id = user_id";
        
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            for (Integer bookId : bookIds) {
                ps.setInt(1, userId);
                ps.setInt(2, bookId);
                ps.addBatch(); // 작업을 배치에 추가
            }
            ps.executeBatch(); // 배치 작업 실행
        }
    }

    // [추가] 여러 개의 책을 찜 목록에서 한 번에 삭제합니다.
    public void removeBooksFromWishlist(int userId, List<Integer> bookIds) throws SQLException {
        if (bookIds == null || bookIds.isEmpty()) {
            return;
        }
        // IN 절에 들어갈 ? 플레이스홀더를 동적으로 생성합니다.
        String placeholders = String.join(",", java.util.Collections.nCopies(bookIds.size(), "?"));
        final String sql = "DELETE FROM wishlists WHERE user_id = ? AND book_id IN (" + placeholders + ")";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            for (int i = 0; i < bookIds.size(); i++) {
                ps.setInt(i + 2, bookIds.get(i));
            }
            ps.executeUpdate();
        }
    }

    // [추가] 주어진 책 ID 목록 중에서 사용자가 찜한 책의 개수를 반환합니다.
    public int countWishlistedBooks(int userId, List<Integer> bookIds) throws SQLException {
        if (bookIds == null || bookIds.isEmpty()) {
            return 0;
        }
        String placeholders = String.join(",", java.util.Collections.nCopies(bookIds.size(), "?"));
        final String sql = "SELECT COUNT(*) FROM wishlists WHERE user_id = ? AND book_id IN (" + placeholders + ")";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            for (int i = 0; i < bookIds.size(); i++) {
                ps.setInt(i + 2, bookIds.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
}
