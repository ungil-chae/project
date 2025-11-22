package com.greenart.bdproject.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.greenart.bdproject.dto.Member;
import com.greenart.bdproject.dao.ProjectMemberDao;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * 인증 API 컨트롤러 (AJAX용)
 * URL 패턴: /api/auth/*
 */
@RestController
@RequestMapping("/api/auth")
public class AuthApiController {

    private static final Logger logger = LoggerFactory.getLogger(AuthApiController.class);

    @Autowired
    private ProjectMemberDao memberDao;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    /**
     * 로그인 처리 (5회 실패 시 5분 잠금)
     * @PostMapping("/api/auth/login")
     */
    @PostMapping("/login")
    public Map<String, Object> login(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 디버깅 로그
            logger.info("=== 로그인 요청 ===");
            logger.info("email: {}", email);
            logger.info("password: {}", password != null ? "***" : "null");

            // 사용자 조회 (email로 검색)
            Member member = memberDao.select(email);
            logger.info("조회된 member: {}", member != null ? member.getEmail() : "null");

            if (member == null) {
                logger.warn("사용자를 찾을 수 없음: {}", email);
                response.put("success", false);
                response.put("message", "이메일 또는 비밀번호가 일치하지 않습니다.");
                return response;
            }

            // 계정 잠금 확인
            if (member.getAccountLockedUntil() != null) {
                long now = System.currentTimeMillis();
                long lockedUntil = member.getAccountLockedUntil().getTime();

                if (now < lockedUntil) {
                    long remainingSeconds = (lockedUntil - now) / 1000;
                    long remainingMinutes = remainingSeconds / 60;
                    long remainingSecondsOnly = remainingSeconds % 60;

                    logger.warn("계정 잠금 상태: {} (잔여시간: " + remainingMinutes + "분 " + remainingSecondsOnly + "초)", email);
                    response.put("success", false);
                    response.put("message", String.format("로그인이 5회 실패하여 계정이 잠겼습니다. %d분 %d초 후에 다시 시도해주세요.",
                            remainingMinutes, remainingSecondsOnly));
                    response.put("locked", true);
                    response.put("remainingSeconds", remainingSeconds);
                    return response;
                } else {
                    // 잠금 해제 시간 지남 - 실패 횟수 초기화
                    memberDao.resetLoginFailCount(email);
                    member.setLoginFailCount(0);
                    member.setAccountLockedUntil(null);
                }
            }

            // 비밀번호 확인 (BCrypt 사용)
            boolean passwordMatch = passwordEncoder.matches(password, member.getPwd());
            logger.info("비밀번호 일치 여부: {}", passwordMatch);

            if (!passwordMatch) {
                // 로그인 실패 처리
                memberDao.incrementLoginFailCount(email);
                int failCount = (member.getLoginFailCount() != null ? member.getLoginFailCount() : 0) + 1;

                logger.warn("비밀번호 불일치: {} (실패 횟수: {})", email, failCount);

                if (failCount >= 5) {
                    // 5회 실패 시 5분 잠금
                    memberDao.lockAccount(email, 5);
                    logger.warn("계정 잠금: {} (5회 실패)", email);
                    response.put("success", false);
                    response.put("message", "로그인이 5회 실패하여 계정이 5분간 잠겼습니다. 잠시 후 다시 시도하거나 비밀번호 찾기를 이용해주세요.");
                    response.put("locked", true);
                    response.put("remainingSeconds", 300);  // 5분 = 300초
                } else {
                    response.put("success", false);
                    response.put("message", String.format("이메일 또는 비밀번호가 일치하지 않습니다. (실패 %d회/5회)", failCount));
                    response.put("failCount", failCount);
                }
                return response;
            }

            // 로그인 성공 - 실패 횟수 초기화
            memberDao.resetLoginFailCount(email);

            // 세션에 사용자 정보 저장 (LoginController와 일관성 유지)
            session.setAttribute("id", member.getEmail());  // LoginController와 동일
            session.setAttribute("userId", member.getEmail());  // 호환성 유지

            // username 저장 (null 체크)
            String usernameToStore = member.getName();
            if (usernameToStore != null && !usernameToStore.trim().isEmpty()) {
                session.setAttribute("username", usernameToStore.trim());
                logger.info("세션에 username 저장: {}", usernameToStore);
            } else {
                logger.warn("경고: member.getName()이 null이거나 비어있습니다!");
            }

            session.setAttribute("role", member.getRole() != null ? member.getRole() : "USER");

            logger.info("세션 저장 완료 - id: {}, userId: {}", member.getEmail(), member.getEmail());

            // 사용자 DTO 생성 (비밀번호 제외)
            Map<String, Object> userDto = new HashMap<>();
            userDto.put("id", member.getEmail());
            userDto.put("username", member.getName());
            userDto.put("email", member.getEmail());
            userDto.put("role", member.getRole() != null ? member.getRole() : "USER");

            response.put("success", true);
            response.put("user", userDto);

            logger.info("로그인 성공: {}", email);

        } catch (Exception e) {
            logger.error("로그인 처리 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "로그인 처리 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 회원가입 처리
     * @PostMapping("/api/auth/register")
     */
    @PostMapping("/register")
    public Map<String, Object> register(Member member) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 디버깅: 받은 데이터 확인
            logger.info("=== 회원가입 요청 데이터 ===");
            logger.info("email: {}", member.getEmail());
            logger.info("pwd: {}", member.getPwd() != null ? "***" : "null");
            logger.info("name: {}", member.getName());
            logger.info("phone: {}", member.getPhone());
            logger.info("role: {}", member.getRole());
            logger.info("securityQuestion: {}", member.getSecurityQuestion());
            logger.info("securityAnswer: {}", member.getSecurityAnswer());

            // 필수 필드 검증
            if (member.getEmail() == null || member.getEmail().isEmpty()) {
                response.put("success", false);
                response.put("message", "이메일은 필수입니다.");
                return response;
            }
            if (member.getPwd() == null || member.getPwd().isEmpty()) {
                response.put("success", false);
                response.put("message", "비밀번호는 필수입니다.");
                return response;
            }
            if (member.getName() == null || member.getName().isEmpty()) {
                response.put("success", false);
                response.put("message", "이름은 필수입니다.");
                return response;
            }

            // 기본 role 설정
            if (member.getRole() == null || member.getRole().isEmpty()) {
                member.setRole("USER");
            }

            // 비밀번호 BCrypt 암호화
            String encryptedPassword = passwordEncoder.encode(member.getPwd());
            member.setPwd(encryptedPassword);

            logger.info("최종 member.email: {}", member.getEmail());

            // 중복 검사 (email로 검색)
            Member existingMember = memberDao.select(member.getEmail());
            if (existingMember != null) {
                logger.warn("중복 회원가입 시도: {}", member.getEmail());
                response.put("success", false);
                response.put("message", "이미 존재하는 이메일입니다.");
                return response;
            }

            // 회원가입 처리
            logger.info("DB insert 시작...");
            int result = memberDao.insert(member);
            logger.info("DB insert 결과: {}", result);

            if (result > 0) {
                response.put("success", true);
                response.put("message", "회원가입 완료");
                logger.info("회원가입 성공: {} ({})", member.getName(), member.getEmail());
            } else {
                response.put("success", false);
                response.put("message", "회원가입에 실패했습니다.");
                logger.error("DB insert 실패: result={}", result);
            }

        } catch (Exception e) {
            logger.error("회원가입 처리 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "회원가입 처리 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 로그아웃 처리
     * @GetMapping("/api/auth/logout")
     */
    @GetMapping("/logout")
    public Map<String, Object> logout(HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            String username = (String) session.getAttribute("username");
            session.invalidate();

            response.put("success", true);
            logger.info("로그아웃 성공: {}", username);

        } catch (Exception e) {
            logger.error("로그아웃 처리 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "로그아웃 처리 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 로그인 상태 확인
     * @GetMapping("/api/auth/check")
     */
    @GetMapping("/check")
    public Map<String, Object> checkLoginStatus(HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            response.put("loggedIn", false);
        } else {
            response.put("loggedIn", true);
            response.put("userId", userId);
            response.put("username", session.getAttribute("username"));
            response.put("role", session.getAttribute("role"));
        }

        return response;
    }
}
