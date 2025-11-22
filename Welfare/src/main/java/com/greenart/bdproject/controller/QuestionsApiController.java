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
import com.greenart.bdproject.service.NotificationService;

/**
 * 사용자 질문 API 컨트롤러
 * URL 패턴: /api/questions/*
 */
@RestController
@RequestMapping("/api/questions")
public class QuestionsApiController {

    private static final Logger logger = LoggerFactory.getLogger(QuestionsApiController.class);

    @Autowired
    private DataSource dataSource;

    @Autowired
    private MemberDao memberDao;

    @Autowired
    private NotificationService notificationService;

    /**
     * 질문 목록 조회
     * @GetMapping("/api/questions")
     */
    @GetMapping("")
    public Map<String, Object> getQuestions(
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "category", required = false) String category) {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = dataSource.getConnection();

            StringBuilder sql = new StringBuilder(
                    "SELECT question_id, user_id, user_name, user_email, category, " +
                    "title, content, answer, answered_by, answered_at, status, views, " +
                    "created_at, updated_at " +
                    "FROM user_questions WHERE 1=1");

            if (status != null && !status.isEmpty()) {
                sql.append(" AND status = ?");
            }
            if (category != null && !category.isEmpty()) {
                sql.append(" AND category = ?");
            }
            sql.append(" ORDER BY created_at DESC");

            pstmt = con.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (status != null && !status.isEmpty()) {
                pstmt.setString(paramIndex++, status);
            }
            if (category != null && !category.isEmpty()) {
                pstmt.setString(paramIndex++, category);
            }

            rs = pstmt.executeQuery();

            List<Map<String, Object>> questions = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> question = new HashMap<>();
                question.put("questionId", rs.getLong("question_id"));
                question.put("userId", rs.getString("user_id"));
                question.put("userName", rs.getString("user_name"));
                question.put("userEmail", rs.getString("user_email"));
                question.put("category", rs.getString("category"));
                question.put("title", rs.getString("title"));
                question.put("content", rs.getString("content"));
                question.put("answer", rs.getString("answer"));
                question.put("answeredBy", rs.getString("answered_by"));
                question.put("answeredAt", rs.getTimestamp("answered_at"));
                question.put("status", rs.getString("status"));
                question.put("views", rs.getInt("views"));
                question.put("createdAt", rs.getTimestamp("created_at"));
                question.put("updatedAt", rs.getTimestamp("updated_at"));

                questions.add(question);
            }

            response.put("success", true);
            response.put("data", questions);
            logger.info("질문 목록 조회 성공 - 총 {}건", questions.size());

        } catch (Exception e) {
            logger.error("질문 목록 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "질문 목록 조회 중 오류가 발생했습니다.");
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    /**
     * 질문 상세 조회
     * @GetMapping("/api/questions/{id}")
     */
    @GetMapping("/{id}")
    public Map<String, Object> getQuestion(@PathVariable("id") Long id) {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        PreparedStatement updatePstmt = null;
        ResultSet rs = null;

        try {
            con = dataSource.getConnection();

            // 조회수 증가
            String updateSql = "UPDATE user_questions SET views = views + 1 WHERE question_id = ?";
            updatePstmt = con.prepareStatement(updateSql);
            updatePstmt.setLong(1, id);
            updatePstmt.executeUpdate();

            // 질문 조회
            String sql = "SELECT question_id, user_id, user_name, user_email, category, " +
                    "title, content, answer, answered_by, answered_at, status, views, " +
                    "created_at, updated_at " +
                    "FROM user_questions WHERE question_id = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Map<String, Object> question = new HashMap<>();
                question.put("questionId", rs.getLong("question_id"));
                question.put("userId", rs.getString("user_id"));
                question.put("userName", rs.getString("user_name"));
                question.put("userEmail", rs.getString("user_email"));
                question.put("category", rs.getString("category"));
                question.put("title", rs.getString("title"));
                question.put("content", rs.getString("content"));
                question.put("answer", rs.getString("answer"));
                question.put("answeredBy", rs.getString("answered_by"));
                question.put("answeredAt", rs.getTimestamp("answered_at"));
                question.put("status", rs.getString("status"));
                question.put("views", rs.getInt("views"));
                question.put("createdAt", rs.getTimestamp("created_at"));
                question.put("updatedAt", rs.getTimestamp("updated_at"));

                response.put("success", true);
                response.put("data", question);
            } else {
                response.put("success", false);
                response.put("message", "질문을 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            logger.error("질문 상세 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "질문 조회 중 오류가 발생했습니다.");
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
     * 질문 작성
     * @PostMapping("/api/questions")
     */
    @PostMapping("")
    public Map<String, Object> createQuestion(
            @RequestParam("userName") String userName,
            @RequestParam("userEmail") String userEmail,
            @RequestParam("category") String category,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 세션에서 로그인 정보 가져오기 (선택사항)
            String userId = (String) session.getAttribute("id");

            con = dataSource.getConnection();

            String sql = "INSERT INTO user_questions " +
                    "(user_id, user_name, user_email, category, title, content, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, 'pending')";

            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, userId);
            pstmt.setString(2, userName);
            pstmt.setString(3, userEmail);
            pstmt.setString(4, category);
            pstmt.setString(5, title);
            pstmt.setString(6, content);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    long questionId = rs.getLong(1);
                    response.put("success", true);
                    response.put("questionId", questionId);
                    response.put("message", "질문이 등록되었습니다.");
                    logger.info("질문 등록 성공 - questionId: {}", questionId);
                }
            } else {
                response.put("success", false);
                response.put("message", "질문 등록에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("질문 등록 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "질문 등록 중 오류가 발생했습니다: " + e.getMessage());
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    /**
     * 비회원 질문 조회 (질문번호 + 이메일)
     * @GetMapping("/api/questions/check")
     */
    @GetMapping("/check")
    public Map<String, Object> checkQuestion(
            @RequestParam("questionId") Long questionId,
            @RequestParam("email") String email) {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = dataSource.getConnection();

            String sql = "SELECT question_id, user_id, user_name, user_email, category, " +
                    "title, content, answer, answered_by, answered_at, status, views, " +
                    "created_at, updated_at " +
                    "FROM user_questions " +
                    "WHERE question_id = ? AND user_email = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, questionId);
            pstmt.setString(2, email);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Map<String, Object> question = new HashMap<>();
                question.put("questionId", rs.getLong("question_id"));
                question.put("userId", rs.getString("user_id"));
                question.put("userName", rs.getString("user_name"));
                question.put("userEmail", rs.getString("user_email"));
                question.put("category", rs.getString("category"));
                question.put("title", rs.getString("title"));
                question.put("content", rs.getString("content"));
                question.put("answer", rs.getString("answer"));
                question.put("answeredBy", rs.getString("answered_by"));
                question.put("answeredAt", rs.getTimestamp("answered_at"));
                question.put("status", rs.getString("status"));
                question.put("views", rs.getInt("views"));
                question.put("createdAt", rs.getTimestamp("created_at"));
                question.put("updatedAt", rs.getTimestamp("updated_at"));

                response.put("success", true);
                response.put("data", question);
                logger.info("질문 조회 성공 - questionId: {}, email: {}", questionId, email);
            } else {
                response.put("success", false);
                response.put("message", "질문을 찾을 수 없습니다.");
                logger.warn("질문 조회 실패 - questionId: {}, email: {}", questionId, email);
            }

        } catch (Exception e) {
            logger.error("질문 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "질문 조회 중 오류가 발생했습니다.");
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    /**
     * 관리자 답변 작성
     * @PostMapping("/api/questions/{id}/answer")
     */
    @PostMapping("/{id}/answer")
    public Map<String, Object> answerQuestion(
            @PathVariable("id") Long id,
            @RequestParam("answer") String answer,
            HttpSession session) {

        logger.info("========== 답변 등록 API 시작 ==========");
        logger.info("questionId: {}", id);
        logger.info("answer: {}", answer);

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            // 관리자 권한 체크
            String userId = (String) session.getAttribute("id");
            logger.info("세션 userId: {}", userId);

            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                logger.warn("로그인 필요 - 세션에 userId 없음");
                return response;
            }

            if (memberDao == null) {
                logger.error("MemberDao is null!");
                response.put("success", false);
                response.put("message", "시스템 오류: MemberDao가 초기화되지 않았습니다.");
                return response;
            }

            logger.info("MemberDao.select 호출 - userId: {}", userId);
            Member member = memberDao.select(userId);
            logger.info("조회된 Member: {}", member);
            if (member == null || !"ADMIN".equals(member.getRole())) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return response;
            }

            logger.info("데이터베이스 연결 시작");
            con = dataSource.getConnection();
            logger.info("데이터베이스 연결 성공");

            String sql = "UPDATE user_questions SET " +
                    "answer = ?, " +
                    "answered_by = ?, " +
                    "answered_at = NOW(), " +
                    "status = 'answered' " +
                    "WHERE question_id = ?";

            logger.info("SQL 실행: {}", sql);
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, answer);
            pstmt.setString(2, userId);
            pstmt.setLong(3, id);

            int result = pstmt.executeUpdate();
            logger.info("UPDATE 결과: {} rows", result);

            if (result > 0) {
                // 질문 정보 조회하여 알림 생성
                try {
                    String selectSql = "SELECT user_id, title FROM user_questions WHERE question_id = ?";
                    PreparedStatement selectPstmt = con.prepareStatement(selectSql);
                    selectPstmt.setLong(1, id);
                    ResultSet selectRs = selectPstmt.executeQuery();

                    if (selectRs.next()) {
                        String questionUserId = selectRs.getString("user_id");
                        String questionTitle = selectRs.getString("title");

                        // 질문 작성자에게 알림 생성 (로그인한 사용자만)
                        if (questionUserId != null && !questionUserId.isEmpty()) {
                            notificationService.createFaqAnswerNotification(questionUserId, id, questionTitle);
                            logger.info("FAQ 답변 알림 생성 완료 - questionUserId: {}, questionId: {}", questionUserId, id);
                        }
                    }

                    selectRs.close();
                    selectPstmt.close();

                } catch (Exception notifEx) {
                    logger.error("알림 생성 중 오류 (답변은 정상 등록됨)", notifEx);
                }

                response.put("success", true);
                response.put("message", "답변이 등록되었습니다.");
                logger.info("답변 등록 성공 - questionId: {}", id);
            } else {
                response.put("success", false);
                response.put("message", "답변 등록에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("답변 등록 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "답변 등록 중 오류가 발생했습니다: " + e.getMessage());
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
