package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dto.BookRecommendationResponse;
import util.DBUtil;

/**
 * 도서 추천 관련 데이터베이스 작업을 처리하는 DAO 클래스
 * MBTI 기반 협업 필터링 추천 쿼리를 담당합니다.
 */
public class RecommendationDao {

    /**
     * 같은 MBTI를 가진 다른 사용자들이 찜한 책을 추천합니다.
     *
     * 추천 로직:
     * 1. 같은 MBTI를 가진 사용자들이 찜한 책을 조회
     * 2. 본인이 이미 찜한 책은 제외
     * 3. 찜 횟수가 많은 순으로 정렬
     *
     * @param mbti 사용자의 MBTI 유형
     * @param userId 현재 로그인한 사용자 ID (본인 제외용)
     * @param limit 가져올 추천 책 개수
     * @return 추천 도서 목록 (찜 횟수 포함)
     * @throws SQLException DB 오류 발생 시
     */
    public List<BookRecommendationResponse> getRecommendationsByMbti(String mbti, int userId, int limit)
            throws SQLException {

        // 핵심 추천 쿼리: JOIN + 서브쿼리 + GROUP BY + ORDER BY
        final String sql =
            "SELECT b.book_id, b.isbn, b.title, b.author, b.publisher, " +
            "       b.cover_image_url, b.link, COUNT(w.book_id) AS wishlist_count " +
            "FROM books b " +
            "JOIN wishlists w ON b.book_id = w.book_id " +
            "JOIN users u ON w.user_id = u.user_id " +
            "WHERE u.mbti = ? " +                              // 1. 같은 MBTI
            "  AND w.user_id != ? " +                          // 2. 본인 제외
            "  AND b.book_id NOT IN ( " +                      // 3. 이미 찜한 책 제외
            "      SELECT book_id FROM wishlists WHERE user_id = ? " +
            "  ) " +
            "GROUP BY b.book_id, b.isbn, b.title, b.author, b.publisher, " +
            "         b.cover_image_url, b.link " +
            "ORDER BY wishlist_count DESC " +                  // 4. 찜 횟수 순 정렬
            "LIMIT ?";

        List<BookRecommendationResponse> recommendations = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, mbti);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            ps.setInt(4, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int wishlistCount = rs.getInt("wishlist_count");
                    String reason = mbti + " 사용자 " + wishlistCount + "명이 찜했습니다";

                    BookRecommendationResponse book = new BookRecommendationResponse(
                        rs.getInt("book_id"),
                        rs.getString("isbn"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("publisher"),
                        rs.getString("cover_image_url"),
                        rs.getString("link"),
                        wishlistCount,
                        reason
                    );
                    recommendations.add(book);
                }
            }
        }
        return recommendations;
    }

    /**
     * 특정 MBTI 유형의 사용자 수를 조회합니다. (통계용)
     *
     * @param mbti MBTI 유형
     * @return 해당 MBTI 사용자 수
     * @throws SQLException DB 오류 발생 시
     */
    public int countUsersByMbti(String mbti) throws SQLException {
        final String sql = "SELECT COUNT(*) FROM users WHERE mbti = ? AND status = 'active'";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, mbti);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
}
