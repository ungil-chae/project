package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime; // LocalDateTime 임포트
import java.util.ArrayList;
import java.util.List;

import model.CelebRecommendation; // Model 임포트
import util.DBUtil; // DB 연결 유틸리티 임포트

public class CelebRecommendationsDao {

    public CelebRecommendationsDao() {
    }

    /**
     * 새로운 셀럽 추천 글을 데이터베이스에 추가합니다.
     * @param celeb 추천 정보 모델 (model.CelebRecommendation 타입)
     * @return 생성된 CelebRecommendation 모델 (ID 포함) 또는 null
     * @throws SQLException DB 오류 시
     */
    public CelebRecommendation createCelebRecommendation(CelebRecommendation celeb) throws SQLException {
        String sql = "INSERT INTO CelebRecommendations (celeb_name, celeb_description, celeb_image_url, recommend_date) VALUES (?, ?, ?, NOW())";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, celeb.getCelebName());
            pstmt.setString(2, celeb.getCelebDescription());
            pstmt.setString(3, celeb.getCelebImageUrl());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    celeb.setCelebRecId(rs.getInt(1));
                    celeb.setRecommendDate(LocalDateTime.now());
                    return celeb;
                }
            }
            return null;
        } finally {
            DBUtil.close(rs);
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 모든 셀럽 추천 목록을 조회합니다.
     * @return 셀럽 추천 목록 리스트 (List<model.CelebRecommendation>)
     * @throws SQLException DB 오류 시
     */
    public List<CelebRecommendation> getAllCelebRecommendations() throws SQLException {
        List<CelebRecommendation> list = new ArrayList<>();
        String sql = "SELECT celeb_rec_id, celeb_name, celeb_description, celeb_image_url, recommend_date FROM CelebRecommendations ORDER BY recommend_date DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                CelebRecommendation celeb = new CelebRecommendation();
                celeb.setCelebRecId(rs.getInt("celeb_rec_id"));
                celeb.setCelebName(rs.getString("celeb_name"));
                celeb.setCelebDescription(rs.getString("celeb_description"));
                celeb.setCelebImageUrl(rs.getString("celeb_image_url"));
                celeb.setRecommendDate(rs.getTimestamp("recommend_date") != null ? rs.getTimestamp("recommend_date").toLocalDateTime() : null);
                list.add(celeb);
            }
        } finally {
            DBUtil.close(rs);
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
        return list;
    }

    /**
     * 특정 셀럽 상세 정보 가져오기
     * @param celebId 조회할 셀럽 ID
     * @return model.CelebRecommendation 또는 null
     * @throws SQLException DB 오류 시
     */
    public CelebRecommendation getCelebRecommendationById(int celebId) throws SQLException {
        String sql = "SELECT celeb_rec_id, celeb_name, celeb_description, celeb_image_url, recommend_date FROM CelebRecommendations WHERE celeb_rec_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        CelebRecommendation celeb = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, celebId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                celeb = new CelebRecommendation();
                celeb.setCelebRecId(rs.getInt("celeb_rec_id"));
                celeb.setCelebName(rs.getString("celeb_name"));
                celeb.setCelebDescription(rs.getString("celeb_description"));
                celeb.setCelebImageUrl(rs.getString("celeb_image_url"));
                celeb.setRecommendDate(rs.getTimestamp("recommend_date") != null ? rs.getTimestamp("recommend_date").toLocalDateTime() : null);
            }
        } finally {
            DBUtil.close(rs);
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
        return celeb;
    }

    /**
     * 특정 셀럽 추천 글을 ID로 삭제합니다.
     * @param celebRecId 삭제할 셀럽 추천 ID
     * @return 성공 시 true, 실패 시 false
     * @throws SQLException DB 오류 시
     */
    public boolean deleteCelebRecommendation(int celebRecId) throws SQLException {
        String sql = "DELETE FROM CelebRecommendations WHERE celeb_rec_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, celebRecId);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } finally {
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }
}