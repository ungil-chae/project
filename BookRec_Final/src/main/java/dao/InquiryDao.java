package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import dto.InquiryRequest;
import dto.InquiryResponse;
import model.Inquiry; // Inquiry 모델이 필요합니다.
import util.DBUtil;

public class InquiryDao {

    /**
     * 새로운 문의를 데이터베이스에 추가합니다.
     *
     * @param userId 문의를 작성하는 사용자 ID
     * @param reqDto 문의 정보 (inquiryType, title, content)
     * @return 생성된 문의의 InquiryResponse 객체 (inquiryId 포함) 또는 null
     * @throws SQLException 데이터베이스 오류 발생 시
     */
    public InquiryResponse createInquiry(int userId, InquiryRequest reqDto) throws SQLException {
        String sql = "INSERT INTO Inquiries (user_id, inquiry_type, title, content, created_at, status) VALUES (?, ?, ?, ?, NOW(), 'pending')";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, userId);
            pstmt.setString(2, reqDto.getInquiryType());
            pstmt.setString(3, reqDto.getTitle());
            pstmt.setString(4, reqDto.getContent());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    int inquiryId = rs.getInt(1);
                    // DTO 반환을 위해 필요한 정보 매핑
                    return new InquiryResponse(
                        inquiryId,
                        userId,
                        reqDto.getInquiryType(),
                        reqDto.getTitle(),
                        reqDto.getContent(),
                        LocalDateTime.now(), // DB의 NOW()와 동기화
                        "pending",
                        null,
                        null
                    );
                }
            }
            return null; // 문의 생성 실패 시
        } finally {
            DBUtil.close(rs);
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 특정 사용자가 작성한 모든 문의 내역을 조회합니다.
     *
     * @param userId 조회할 사용자 ID
     * @return 문의 항목들의 리스트
     * @throws SQLException 데이터베이스 오류 발생 시
     */
    public List<InquiryResponse> getInquiriesByUserId(int userId) throws SQLException {
        String sql = "SELECT inquiry_id, user_id, inquiry_type, title, content, created_at, status, answer_content, answered_at " +
                     "FROM Inquiries WHERE user_id = ? ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<InquiryResponse> inquiries = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int inquiryId = rs.getInt("inquiry_id");
                // int retrievedUserId = rs.getInt("user_id"); // 마이페이지에서는 굳이 다시 매핑 안해도 됨
                String inquiryType = rs.getString("inquiry_type");
                String title = rs.getString("title");
                String content = rs.getString("content");
                LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                String status = rs.getString("status");
                String answerContent = rs.getString("answer_content");
                LocalDateTime answeredAt = rs.getTimestamp("answered_at") != null ? rs.getTimestamp("answered_at").toLocalDateTime() : null;

                inquiries.add(new InquiryResponse(inquiryId, userId, inquiryType, title, content,
                                                  createdAt, status, answerContent, answeredAt));
            }
            return inquiries;
        } finally {
            DBUtil.close(rs);
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 특정 사용자가 작성한 특정 문의의 상세 정보를 조회합니다.
     * 보안을 위해 user_id도 함께 검증합니다.
     *
     * @param inquiryId 조회할 문의 ID
     * @param userId    조회할 문의의 사용자 ID
     * @return 해당 문의의 InquiryResponse 객체 또는 null
     * @throws SQLException 데이터베이스 오류 발생 시
     */
    public InquiryResponse getInquiryByIdAndUserId(int inquiryId, int userId) throws SQLException {
        String sql = "SELECT inquiry_id, user_id, inquiry_type, title, content, created_at, status, answer_content, answered_at " +
                     "FROM Inquiries WHERE inquiry_id = ? AND user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        InquiryResponse inquiry = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, inquiryId);
            pstmt.setInt(2, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // int retrievedUserId = rs.getInt("user_id");
                String inquiryType = rs.getString("inquiry_type");
                String title = rs.getString("title");
                String content = rs.getString("content");
                LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                String status = rs.getString("status");
                String answerContent = rs.getString("answer_content");
                LocalDateTime answeredAt = rs.getTimestamp("answered_at") != null ? rs.getTimestamp("answered_at").toLocalDateTime() : null;

                inquiry = new InquiryResponse(inquiryId, userId, inquiryType, title, content,
                                              createdAt, status, answerContent, answeredAt);
            }
            return inquiry;
        } finally {
            DBUtil.close(rs);
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }
}