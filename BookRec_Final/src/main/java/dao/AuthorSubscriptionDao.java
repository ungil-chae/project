package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import dto.AuthorResponse; // 작가 정보 응답 DTO 임포트
import util.DBUtil; // DB 연결 유틸리티 임포트

public class AuthorSubscriptionDao {

    /**
     * 사용자의 찜 목록에 책을 추가합니다.
     * `AuthorSubscriptions` 테이블에 새로운 구독 항목을 추가합니다.
     * `UNIQUE (user_id, author_id)` 제약조건에 의해 중복 구독이 방지됩니다.
     *
     * @param userId 구독을 추가할 사용자 ID
     * @param authorId 구독할 작가 ID
     * @return 성공 시 true, 실패 시 false (예: 이미 구독한 경우)
     * @throws SQLException 데이터베이스 오류 발생 시
     */
    public boolean subscribeAuthor(int userId, int authorId) throws SQLException {
        String sql = "INSERT INTO AuthorSubscriptions (user_id, author_id, subscribed_at) VALUES (?, ?, NOW())";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, authorId);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            // MySQL에서 UNIQUE 제약조건 위반 시 발생하는 오류 코드 (SQLSTATE 23000, ErrorCode 1062)
            if (e.getSQLState().equals("23000") && e.getErrorCode() == 1062) {
                // 이미 구독된 경우이므로 false를 반환하여 서비스 계층에서 AlreadySubscribed 예외를 발생시키도록 함
                return false;
            }
            throw e; // 그 외 다른 SQLException은 다시 던집니다.
        } finally {
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 사용자의 작가 구독을 취소합니다.
     * `AuthorSubscriptions` 테이블에서 특정 구독 항목을 삭제합니다.
     *
     * @param userId 구독을 취소할 사용자 ID
     * @param authorId 구독 취소할 작가 ID
     * @return 성공 시 true, 실패 시 false
     * @throws SQLException 데이터베이스 오류 발생 시
     */
    public boolean unsubscribeAuthor(int userId, int authorId) throws SQLException {
        String sql = "DELETE FROM AuthorSubscriptions WHERE user_id = ? AND author_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, authorId);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } finally {
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 특정 사용자가 구독한 모든 작가 목록을 조회합니다.
     * `Authors` 테이블과 조인하여 작가 상세 정보와 구독 시각을 가져와 `AuthorResponse` DTO 리스트로 반환합니다.
     *
     * @param userId 조회할 사용자 ID
     * @return 구독한 작가 목록의 리스트 (각 항목은 AuthorResponse DTO)
     * @throws SQLException 데이터베이스 오류 발생 시
     */
    public List<AuthorResponse> getSubscribedAuthorsByUserId(int userId) throws SQLException {
        String sql = "SELECT asub.author_id, a.author_name, a.author_description, a.author_image_url, asub.subscribed_at " +
                     "FROM AuthorSubscriptions asub JOIN Authors a ON asub.author_id = a.author_id " +
                     "WHERE asub.user_id = ? ORDER BY asub.subscribed_at DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<AuthorResponse> authors = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int authorId = rs.getInt("author_id");
                String authorName = rs.getString("author_name");
                // description과 image_url은 null일 수 있으므로 null 체크를 하거나 DTO 생성자에서 처리해야 합니다.
                String authorDescription = rs.getString("author_description");
                String authorImageUrl = rs.getString("author_image_url");
                LocalDateTime subscribedAt = rs.getTimestamp("subscribed_at").toLocalDateTime();

                authors.add(new AuthorResponse(authorId, authorName, authorDescription, authorImageUrl, subscribedAt));
            }
            return authors;
        } finally {
            DBUtil.close(rs);
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 특정 작가가 사용자에 의해 구독되어 있는지 확인합니다.
     * 이 메서드는 서비스 계층에서 중복 구독 방지 로직에 사용됩니다.
     *
     * @param userId 사용자 ID
     * @param authorId 작가 ID
     * @return 구독 중이면 true, 아니면 false
     * @throws SQLException 데이터베이스 오류 발생 시
     */
    public boolean isAuthorSubscribed(int userId, int authorId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM AuthorSubscriptions WHERE user_id = ? AND author_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, authorId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } finally {
            DBUtil.close(rs);
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }
}