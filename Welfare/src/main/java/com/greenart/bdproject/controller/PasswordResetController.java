package com.greenart.bdproject.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.greenart.bdproject.dao.ProjectMemberDao;
import com.greenart.bdproject.dto.Member;
import com.greenart.bdproject.service.EmailService;

/**
 * 비밀번호 재설정 API 컨트롤러
 * - 이메일로 인증 코드 발송
 * - 인증 코드 검증
 * - 비밀번호 재설정
 */
@RestController
@RequestMapping("/api/password")
public class PasswordResetController {

    private static final Logger logger = LoggerFactory.getLogger(PasswordResetController.class);

    @Autowired
    private ProjectMemberDao memberDao;

    @Autowired
    private EmailService emailService;

    @Autowired
    private DataSource dataSource;

    @Autowired(required = false)
    private BCryptPasswordEncoder passwordEncoder;

    /**
     * 비밀번호 재설정 인증 코드 발송
     * POST /api/password/send-code
     */
    @PostMapping("/send-code")
    public Map<String, Object> sendResetCode(
            @RequestParam("email") String email,
            @RequestParam(value = "name", required = false) String name) {
        Map<String, Object> response = new HashMap<>();

        try {
            logger.info("=== 비밀번호 재설정 코드 발송 요청 ===");
            logger.info("email: {}, name: {}", email, name);

            // 이메일 존재 확인
            Member member = memberDao.select(email);
            if (member == null) {
                logger.warn("존재하지 않는 이메일: {}", email);
                response.put("success", false);
                response.put("message", "입력하신 정보와 일치하는 회원을 찾을 수 없습니다.");
                return response;
            }

            // 이름 검증 (이름이 제공된 경우)
            if (name != null && !name.trim().isEmpty()) {
                if (!name.trim().equals(member.getName())) {
                    logger.warn("이름 불일치: email={}, 입력된 이름={}, 실제 이름={}",
                               email, name, member.getName());
                    response.put("success", false);
                    response.put("message", "입력하신 정보와 일치하는 회원을 찾을 수 없습니다.");
                    return response;
                }
            }

            // 인증 코드 생성
            String verificationCode = emailService.generateVerificationCode();
            logger.info("생성된 인증 코드: {}", verificationCode);

            // DB에 인증 코드 저장 (10분 유효)
            boolean saved = saveVerificationCode(email, verificationCode, "PASSWORD_RESET");
            if (!saved) {
                response.put("success", false);
                response.put("message", "인증 코드 저장 중 오류가 발생했습니다.");
                return response;
            }

            // 이메일 발송
            boolean sent = emailService.sendPasswordResetCode(email, verificationCode);
            if (!sent) {
                response.put("success", false);
                response.put("message", "이메일 발송 중 오류가 발생했습니다.");
                return response;
            }

            response.put("success", true);
            response.put("message", "인증 코드가 이메일로 발송되었습니다. 10분 내에 입력해주세요.");
            logger.info("인증 코드 발송 성공: {}", email);

        } catch (Exception e) {
            logger.error("인증 코드 발송 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "처리 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 인증 코드 검증
     * POST /api/password/verify-code
     */
    @PostMapping("/verify-code")
    public Map<String, Object> verifyCode(
            @RequestParam("email") String email,
            @RequestParam("code") String code) {

        Map<String, Object> response = new HashMap<>();

        try {
            logger.info("=== 인증 코드 검증 요청 ===");
            logger.info("email: {}, code: {}", email, code);

            boolean valid = verifyVerificationCode(email, code, "PASSWORD_RESET");

            if (valid) {
                response.put("success", true);
                response.put("message", "인증이 완료되었습니다. 새 비밀번호를 설정해주세요.");
                logger.info("인증 코드 검증 성공: {}", email);
            } else {
                response.put("success", false);
                response.put("message", "인증 코드가 올바르지 않거나 만료되었습니다.");
                logger.warn("인증 코드 검증 실패: {}", email);
            }

        } catch (Exception e) {
            logger.error("인증 코드 검증 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "처리 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 비밀번호 재설정
     * POST /api/password/reset
     */
    @PostMapping("/reset")
    public Map<String, Object> resetPassword(
            @RequestParam("email") String email,
            @RequestParam("code") String code,
            @RequestParam("newPassword") String newPassword) {

        Map<String, Object> response = new HashMap<>();

        try {
            logger.info("=== 비밀번호 재설정 요청 ===");
            logger.info("email: {}", email);

            // 비밀번호 유효성 검사
            if (newPassword == null || newPassword.length() < 8) {
                response.put("success", false);
                response.put("message", "비밀번호는 최소 8자 이상이어야 합니다.");
                return response;
            }

            // 인증 코드 최종 확인
            boolean valid = verifyVerificationCode(email, code, "PASSWORD_RESET");
            if (!valid) {
                response.put("success", false);
                response.put("message", "인증 코드가 올바르지 않거나 만료되었습니다. 다시 시도해주세요.");
                return response;
            }

            // 회원 정보 조회
            Member member = memberDao.select(email);
            if (member == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            // 비밀번호 암호화 (BCrypt 사용 가능하면)
            String encodedPassword = newPassword;
            if (passwordEncoder != null) {
                encodedPassword = passwordEncoder.encode(newPassword);
                logger.info("비밀번호 BCrypt 암호화 적용");
            }

            // 비밀번호 업데이트
            member.setPwd(encodedPassword);
            int result = memberDao.update(member);

            if (result > 0) {
                // 인증 코드 사용 처리
                markVerificationCodeAsUsed(email, code);

                // 로그인 실패 횟수 초기화
                memberDao.resetLoginFailCount(email);

                response.put("success", true);
                response.put("message", "비밀번호가 성공적으로 변경되었습니다. 새 비밀번호로 로그인해주세요.");
                logger.info("비밀번호 재설정 성공: {}", email);
            } else {
                response.put("success", false);
                response.put("message", "비밀번호 변경에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("비밀번호 재설정 중 오류 발생", e);
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
