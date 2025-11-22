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

            String sql = "SELECT notice_id, admin_id, title, content, views, is_pinned, " +
                    "created_at, updated_at " +
                    "FROM notices " +
                    "ORDER BY is_pinned DESC, created_at DESC";

            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            List<Map<String, Object>> notices = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> notice = new HashMap<>();
                notice.put("noticeId", rs.getLong("notice_id"));
                notice.put("adminId", rs.getString("admin_id"));
                notice.put("title", rs.getString("title"));
                notice.put("content", rs.getString("content"));
                notice.put("views", rs.getInt("views"));
                notice.put("isPinned", rs.getBoolean("is_pinned"));
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
            String updateSql = "UPDATE notices SET views = views + 1 WHERE notice_id = ?";
            updatePstmt = con.prepareStatement(updateSql);
            updatePstmt.setLong(1, id);
            updatePstmt.executeUpdate();

            // 공지사항 조회
            String sql = "SELECT notice_id, admin_id, title, content, views, is_pinned, " +
                    "created_at, updated_at " +
                    "FROM notices WHERE notice_id = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Map<String, Object> notice = new HashMap<>();
                notice.put("noticeId", rs.getLong("notice_id"));
                notice.put("adminId", rs.getString("admin_id"));
                notice.put("title", rs.getString("title"));
                notice.put("content", rs.getString("content"));
                notice.put("views", rs.getInt("views"));
                notice.put("isPinned", rs.getBoolean("is_pinned"));
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

            String sql = "INSERT INTO notices " +
                    "(admin_id, title, content, is_pinned) " +
                    "VALUES (?, ?, ?, ?)";

            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, userId);
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

            String sql = "DELETE FROM notices WHERE notice_id = ?";

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
