package com.greenart.bdproject.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.greenart.bdproject.dao.MemberDao;
import com.greenart.bdproject.dto.Member;
import com.greenart.bdproject.service.EmailService;

/**
 * 이메일 인증 API 컨트롤러
 * - 회원가입 시 이메일 인증
 */
@RestController
@RequestMapping("/api/email")
public class EmailVerificationController {

    private static final Logger logger = LoggerFactory.getLogger(EmailVerificationController.class);

    @Autowired
    private MemberDao memberDao;

    @Autowired
    private EmailService emailService;

    @Autowired
    private DataSource dataSource;

    /**
     * 이메일 API 테스트 엔드포인트
     * GET /api/email/test
     */
    @RequestMapping("/test")
    public Map<String, Object> testEmailApi() {
        Map<String, Object> response = new HashMap<>();
        try {
            response.put("success", true);
            response.put("message", "Email API is working");
            response.put("memberDaoAvailable", memberDao != null);
            response.put("emailServiceAvailable", emailService != null);
            response.put("dataSourceAvailable", dataSource != null);

            // 데이터베이스 연결 테스트
            if (dataSource != null) {
                try (Connection con = dataSource.getConnection()) {
                    response.put("databaseConnected", true);
                }
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
            response.put("errorType", e.getClass().getName());
            logger.error("Test API error", e);
        }
        return response;
    }

    /**
     * 회원가입 이메일 인증 코드 발송
     * POST /api/email/send-signup-code
     */
    @PostMapping("/send-signup-code")
    public Map<String, Object> sendSignupCode(@RequestParam("email") String email) {
        Map<String, Object> response = new HashMap<>();

        try {
            logger.info("=== 회원가입 인증 코드 발송 요청 ===");
            logger.info("email: {}", email);

            // 이메일 중복 확인
            Member existingMember = memberDao.select(email);
            if (existingMember != null) {
                logger.warn("이미 등록된 이메일: {}", email);

                // 가입일자 포맷팅 (yyyy-MM-dd)
                String joinDate = "";
                if (existingMember.getCreatedAt() != null) {
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy년 MM월 dd일");
                    joinDate = sdf.format(existingMember.getCreatedAt());
                }

                response.put("success", false);
                response.put("message", "이미 가입된 이메일입니다.");
                response.put("joinDate", joinDate);
                response.put("alreadyRegistered", true);
                return response;
            }

            // 인증 코드 생성
            String verificationCode = emailService.generateVerificationCode();
            logger.info("생성된 인증 코드: {}", verificationCode);

            // DB에 인증 코드 저장 (10분 유효)
            boolean saved = saveVerificationCode(email, verificationCode, "SIGNUP");
            if (!saved) {
                response.put("success", false);
                response.put("message", "인증 코드 저장 중 오류가 발생했습니다.");
                return response;
            }

            // 이메일 발송
            boolean sent = emailService.sendSignupVerificationCode(email, verificationCode);
            if (!sent) {
                response.put("success", false);
                response.put("message", "이메일 발송 중 오류가 발생했습니다.");
                return response;
            }

            response.put("success", true);
            response.put("message", "인증 코드가 이메일로 발송되었습니다. 10분 내에 입력해주세요.");
            logger.info("회원가입 인증 코드 발송 성공: {}", email);

        } catch (Exception e) {
            logger.error("========== 인증 코드 발송 중 오류 발생 ==========", e);
            logger.error("Error Type: {}", e.getClass().getName());
            logger.error("Error Message: {}", e.getMessage());
            if (e.getCause() != null) {
                logger.error("Caused by: {}", e.getCause().getMessage());
            }
            e.printStackTrace();

            response.put("success", false);
            response.put("message", "처리 중 오류가 발생했습니다: " + e.getMessage());
            response.put("errorType", e.getClass().getName());
        }

        return response;
    }

    /**
     * 회원가입 인증 코드 검증
     * POST /api/email/verify-signup-code
     */
    @PostMapping("/verify-signup-code")
    public Map<String, Object> verifySignupCode(
            @RequestParam("email") String email,
            @RequestParam("code") String code) {

        Map<String, Object> response = new HashMap<>();

        try {
            logger.info("=== 회원가입 인증 코드 검증 요청 ===");
            logger.info("email: {}, code: {}", email, code);

            boolean valid = verifyVerificationCode(email, code, "SIGNUP");

            if (valid) {
                // 인증 성공 시 코드를 사용됨으로 표시
                markVerificationCodeAsUsed(email, code);

                response.put("success", true);
                response.put("message", "이메일 인증이 완료되었습니다.");
                logger.info("회원가입 인증 코드 검증 성공: {}", email);
            } else {
                response.put("success", false);
                response.put("message", "인증 코드가 올바르지 않거나 만료되었습니다.");
                logger.warn("회원가입 인증 코드 검증 실패: {}", email);
            }

        } catch (Exception e) {
            logger.error("인증 코드 검증 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "처리 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 인증 코드를 DB에 저장 (10분 유효)
     */
    private boolean saveVerificationCode(String email, String code, String type) {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dataSource.getConnection();

            // 기존 미사용 코드 삭제
            String deleteSql = "DELETE FROM email_verifications " +
                    "WHERE email = ? AND verification_type = ? AND is_verified = false";
            pstmt = con.prepareStatement(deleteSql);
            pstmt.setString(1, email);
            pstmt.setString(2, type);
            pstmt.executeUpdate();
            pstmt.close();

            // 새 코드 저장
            String insertSql = "INSERT INTO email_verifications " +
                    "(email, verification_code, verification_type, expires_at) " +
                    "VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL 10 MINUTE))";
            pstmt = con.prepareStatement(insertSql);
            pstmt.setString(1, email);
            pstmt.setString(2, code);
            pstmt.setString(3, type);

            int result = pstmt.executeUpdate();
            return result > 0;

        } catch (Exception e) {
            logger.error("인증 코드 저장 중 오류", e);
            return false;
        } finally {
            close(pstmt, con);
        }
    }

    /**
     * 인증 코드 검증
     */
    private boolean verifyVerificationCode(String email, String code, String type) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = dataSource.getConnection();

            String sql = "SELECT verification_id FROM email_verifications " +
                    "WHERE email = ? AND verification_code = ? AND verification_type = ? " +
                    "AND is_verified = false AND expires_at > NOW()";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, code);
            pstmt.setString(3, type);

            rs = pstmt.executeQuery();
            return rs.next();  // 코드가 존재하면 유효

        } catch (Exception e) {
            logger.error("인증 코드 검증 중 오류", e);
            return false;
        } finally {
            close(rs, pstmt, con);
        }
    }

    /**
     * 인증 코드를 사용됨으로 표시
     */
    private void markVerificationCodeAsUsed(String email, String code) {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dataSource.getConnection();

            String sql = "UPDATE email_verifications " +
                    "SET is_verified = true, verified_at = NOW() " +
                    "WHERE email = ? AND verification_code = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, code);
            pstmt.executeUpdate();

        } catch (Exception e) {
            logger.error("인증 코드 사용 처리 중 오류", e);
        } finally {
            close(pstmt, con);
        }
    }

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
