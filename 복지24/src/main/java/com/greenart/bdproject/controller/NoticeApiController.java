package com.greenart.bdproject.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.greenart.bdproject.dao.MemberDao;
import com.greenart.bdproject.dto.Member;

/**
 * 공지사항 API 컨트롤러
 * URL 패턴: /api/notices/*
 */
@RestController
@RequestMapping("/api/notices")
public class NoticeApiController {

    private static final Logger logger = LoggerFactory.getLogger(NoticeApiController.class);

    @Autowired
    private DataSource dataSource;

    @Autowired
    private MemberDao memberDao;

    /**
     * 공지사항 목록 조회
     * @GetMapping("/api/notices")
     */
    @GetMapping("")
    public Map<String, Object> getNotices() {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = dataSource.getConnection();

            // 공지사항이 없으면 샘플 데이터 삽입
            initSampleNoticesIfEmpty(con);

            String sql = "SELECT notice_id, admin_id, title, content, category, priority, " +
                    "views, pinned_yn, created_at, updated_at " +
                    "FROM notice " +
                    "WHERE deleted_at IS NULL " +
                    "ORDER BY pinned_yn DESC, created_at DESC";

            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            List<Map<String, Object>> notices = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> notice = new HashMap<>();
                notice.put("noticeId", rs.getLong("notice_id"));
                notice.put("adminId", rs.getLong("admin_id"));
                notice.put("title", rs.getString("title"));
                notice.put("content", rs.getString("content"));
                notice.put("category", rs.getString("category"));
                notice.put("priority", rs.getString("priority"));
                notice.put("views", rs.getInt("views"));
                notice.put("isPinned", rs.getBoolean("pinned_yn"));
                notice.put("createdAt", rs.getTimestamp("created_at"));
                notice.put("updatedAt", rs.getTimestamp("updated_at"));

                notices.add(notice);
            }

            response.put("success", true);
            response.put("data", notices);
            logger.info("공지사항 목록 조회 성공 - 총 {}건", notices.size());

        } catch (Exception e) {
            logger.error("공지사항 목록 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "공지사항 목록 조회 중 오류가 발생했습니다.");
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    /**
     * 공지사항이 비어있으면 샘플 데이터 삽입
     */
    private void initSampleNoticesIfEmpty(Connection con) {
        PreparedStatement countStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet countRs = null;

        try {
            // 공지사항 개수 확인
            countStmt = con.prepareStatement("SELECT COUNT(*) FROM notice");
            countRs = countStmt.executeQuery();
            countRs.next();
            int count = countRs.getInt(1);

            if (count == 0) {
                logger.info("공지사항이 없어 샘플 데이터를 삽입합니다.");

                // 관리자 ID 조회 (없으면 1 사용)
                Long adminId = 1L;
                PreparedStatement adminStmt = con.prepareStatement(
                    "SELECT member_id FROM member WHERE role = 'ADMIN' LIMIT 1");
                ResultSet adminRs = adminStmt.executeQuery();
                if (adminRs.next()) {
                    adminId = adminRs.getLong(1);
                }
                adminRs.close();
                adminStmt.close();

                // 샘플 공지사항 삽입
                String insertSql = "INSERT INTO notice (admin_id, title, content, category, priority, views, pinned_yn, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
                insertStmt = con.prepareStatement(insertSql);

                // 공지사항 1: 서비스 오픈 안내 (상단 고정)
                insertStmt.setLong(1, adminId);
                insertStmt.setString(2, "복지24 서비스 이용 안내");
                insertStmt.setString(3, "안녕하세요, 복지24입니다.\n\n복지24는 복지 서비스 정보를 제공하는 플랫폼입니다.\n\n주요 기능:\n- 맞춤형 복지 혜택 검색\n- 기부 및 봉사활동 참여\n- 복지시설 지도 서비스\n- 복지 관련 정보 제공\n\n많은 이용 부탁드립니다.");
                insertStmt.setString(4, "SYSTEM");
                insertStmt.setString(5, "HIGH");
                insertStmt.setInt(6, 150);
                insertStmt.setBoolean(7, true);
                insertStmt.executeUpdate();

                // 공지사항 2: 복지 혜택 확대 안내
                insertStmt.setLong(1, adminId);
                insertStmt.setString(2, "2025년 복지 혜택 확대 안내");
                insertStmt.setString(3, "2025년부터 복지 혜택이 대폭 확대됩니다.\n\n주요 변경사항:\n- 소득 기준 완화\n- 지원 금액 인상\n- 신청 절차 간소화\n\n자세한 사항은 복지 혜택 찾기 메뉴에서 진단을 통해 확인하실 수 있습니다.");
                insertStmt.setString(4, "UPDATE");
                insertStmt.setString(5, "NORMAL");
                insertStmt.setInt(6, 120);
                insertStmt.setBoolean(7, false);
                insertStmt.executeUpdate();

                // 공지사항 3: 복지 지도 서비스 오픈
                insertStmt.setLong(1, adminId);
                insertStmt.setString(2, "복지 지도 서비스 오픈");
                insertStmt.setString(3, "주변 복지시설을 한눈에 확인할 수 있는 복지 지도 서비스가 오픈되었습니다.\n\n복지관, 주민센터, 상담센터 등 다양한 복지시설의 위치와 정보를 지도에서 확인하세요.");
                insertStmt.setString(4, "GENERAL");
                insertStmt.setString(5, "NORMAL");
                insertStmt.setInt(6, 80);
                insertStmt.setBoolean(7, false);
                insertStmt.executeUpdate();

                // 공지사항 4: 개인정보 처리방침 변경
                insertStmt.setLong(1, adminId);
                insertStmt.setString(2, "개인정보 처리방침 변경 안내");
                insertStmt.setString(3, "개인정보 보호를 강화하기 위해 개인정보 처리방침이 개정되었습니다.\n\n자세한 내용은 하단 개인정보 처리방침 페이지에서 확인하세요.");
                insertStmt.setString(4, "SYSTEM");
                insertStmt.setString(5, "NORMAL");
                insertStmt.setInt(6, 60);
                insertStmt.setBoolean(7, false);
                insertStmt.executeUpdate();

                // 공지사항 5: 봉사활동 안내
                insertStmt.setLong(1, adminId);
                insertStmt.setString(2, "봉사활동 참여 안내");
                insertStmt.setString(3, "복지24에서 다양한 봉사활동에 참여하실 수 있습니다.\n\n봉사활동 카테고리:\n- 노인돌봄\n- 아동교육\n- 환경보호\n- 장애인 보조\n\n봉사활동 메뉴에서 참여 신청하세요.");
                insertStmt.setString(4, "GENERAL");
                insertStmt.setString(5, "NORMAL");
                insertStmt.setInt(6, 45);
                insertStmt.setBoolean(7, false);
                insertStmt.executeUpdate();

                logger.info("샘플 공지사항 5건 삽입 완료");
            }
        } catch (SQLException e) {
            logger.error("샘플 공지사항 삽입 중 오류", e);
        } finally {
            try {
                if (countRs != null) countRs.close();
                if (countStmt != null) countStmt.close();
                if (insertStmt != null) insertStmt.close();
            } catch (SQLException e) {
                logger.error("Resource close error", e);
            }
        }
    }

    /**
     * 공지사항 상세 조회
     * @GetMapping("/api/notices/{id}")
     */
    @GetMapping("/{id}")
    public Map<String, Object> getNotice(@PathVariable("id") Long id) {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        PreparedStatement updatePstmt = null;
        ResultSet rs = null;

        try {
            con = dataSource.getConnection();

            // 조회수 증가
            String updateSql = "UPDATE notice SET views = views + 1 WHERE notice_id = ?";
            updatePstmt = con.prepareStatement(updateSql);
            updatePstmt.setLong(1, id);
            updatePstmt.executeUpdate();

            // 공지사항 조회
            String sql = "SELECT notice_id, admin_id, title, content, category, priority, " +
                    "views, pinned_yn, created_at, updated_at " +
                    "FROM notice WHERE notice_id = ? AND deleted_at IS NULL";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Map<String, Object> notice = new HashMap<>();
                notice.put("noticeId", rs.getLong("notice_id"));
                notice.put("adminId", rs.getLong("admin_id"));
                notice.put("title", rs.getString("title"));
                notice.put("content", rs.getString("content"));
                notice.put("category", rs.getString("category"));
                notice.put("priority", rs.getString("priority"));
                notice.put("views", rs.getInt("views"));
                notice.put("isPinned", rs.getBoolean("pinned_yn"));
                notice.put("createdAt", rs.getTimestamp("created_at"));
                notice.put("updatedAt", rs.getTimestamp("updated_at"));

                response.put("success", true);
                response.put("data", notice);
            } else {
                response.put("success", false);
                response.put("message", "공지사항을 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            logger.error("공지사항 상세 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "공지사항 조회 중 오류가 발생했습니다.");
        } finally {
            close(rs, pstmt, con);
            if (updatePstmt != null) {
                try {
                    updatePstmt.close();
                } catch (SQLException e) {
                    logger.error("PreparedStatement close error", e);
                }
            }
        }

        return response;
    }

    /**
     * 공지사항 작성 (관리자만)
     * @PostMapping("/api/notices")
     */
    @PostMapping("")
    public Map<String, Object> createNotice(
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam(value = "isPinned", defaultValue = "false") Boolean isPinned,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 관리자 권한 체크
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            Member member = memberDao.select(userId);
            if (member == null || !"ADMIN".equals(member.getRole())) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return response;
            }

            con = dataSource.getConnection();

            String sql = "INSERT INTO notice " +
                    "(admin_id, title, content, pinned_yn) " +
                    "VALUES (?, ?, ?, ?)";

            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setLong(1, member.getMemberId());  // member_id (숫자) 사용
            pstmt.setString(2, title);
            pstmt.setString(3, content);
            pstmt.setBoolean(4, isPinned);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    long noticeId = rs.getLong(1);
                    response.put("success", true);
                    response.put("noticeId", noticeId);
                    response.put("message", "공지사항이 등록되었습니다.");
                    logger.info("공지사항 등록 성공 - noticeId: {}", noticeId);
                }
            } else {
                response.put("success", false);
                response.put("message", "공지사항 등록에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("공지사항 등록 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "공지사항 등록 중 오류가 발생했습니다: " + e.getMessage());
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    /**
     * 공지사항 수정 (관리자만)
     * @PostMapping("/api/notices/{id}/update")
     */
    @PostMapping("/{id}/update")
    public Map<String, Object> updateNotice(
            @PathVariable("id") Long id,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam(value = "isPinned", defaultValue = "false") boolean isPinned,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            // 관리자 권한 체크
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            Member member = memberDao.select(userId);
            if (member == null || !"ADMIN".equals(member.getRole())) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return response;
            }

            con = dataSource.getConnection();

            String sql = "UPDATE notice SET title = ?, content = ?, pinned_yn = ?, updated_at = NOW() " +
                        "WHERE notice_id = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, content);
            pstmt.setBoolean(3, isPinned);
            pstmt.setLong(4, id);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                response.put("success", true);
                response.put("message", "공지사항이 수정되었습니다.");
                logger.info("공지사항 수정 성공 - noticeId: {}", id);
            } else {
                response.put("success", false);
                response.put("message", "공지사항 수정에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("공지사항 수정 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "공지사항 수정 중 오류가 발생했습니다: " + e.getMessage());
        } finally {
            close(null, pstmt, con);
        }

        return response;
    }

    /**
     * 공지사항 삭제 (관리자만)
     * @PostMapping("/api/notices/{id}/delete")
     */
    @PostMapping("/{id}/delete")
    public Map<String, Object> deleteNotice(
            @PathVariable("id") Long id,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            // 관리자 권한 체크
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            Member member = memberDao.select(userId);
            if (member == null || !"ADMIN".equals(member.getRole())) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return response;
            }

            con = dataSource.getConnection();

            String sql = "DELETE FROM notice WHERE notice_id = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, id);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                response.put("success", true);
                response.put("message", "공지사항이 삭제되었습니다.");
                logger.info("공지사항 삭제 성공 - noticeId: {}", id);
            } else {
                response.put("success", false);
                response.put("message", "공지사항 삭제에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("공지사항 삭제 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "공지사항 삭제 중 오류가 발생했습니다: " + e.getMessage());
        } finally {
            close(null, pstmt, con);
        }

        return response;
    }

    // 자원 해제 메서드
    private void close(AutoCloseable... resources) {
        for (AutoCloseable resource : resources) {
            if (resource != null) {
                try {
                    resource.close();
                } catch (Exception e) {
                    logger.error("Resource close error", e);
                }
            }
        }
    }
}
