package com.greenart.bdproject.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

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

    @Autowired
    private DataSource dataSource;

    /**
     * 로그인 처리 (5회 실패 시 5분 잠금 + 자동 로그인)
     * @PostMapping("/api/auth/login")
     */
    @PostMapping("/login")
    public Map<String, Object> login(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            @RequestParam(value = "rememberMe", required = false, defaultValue = "false") boolean rememberMe,
            HttpSession session,
            HttpServletResponse httpResponse,
            HttpServletRequest httpRequest) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 디버깅 로그
            logger.info("=== 로그인 요청 ===");
            logger.info("email: {}", email);
            logger.info("password: {}", password != null ? "***" : "null");
            logger.info("rememberMe 파라미터: {}", rememberMe);

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

            // ========================================
            // 회원 상태(status) 확인 - 정지/탈퇴 계정 로그인 차단
            // ========================================
            String memberStatus = member.getStatus();
            if (memberStatus == null) {
                memberStatus = "ACTIVE";  // 기본값 (하위 호환성)
            }

            // 활동 정지(SUSPENDED) 상태 확인
            if ("SUSPENDED".equals(memberStatus)) {
                logger.warn("활동 정지된 계정 로그인 시도: {}", email);
                response.put("success", false);
                response.put("message", "현재 로그인 할 수 없는 계정입니다.");
                response.put("suspended", true);
                return response;
            }

            // 탈퇴(DORMANT) 상태 확인
            if ("DORMANT".equals(memberStatus)) {
                logger.warn("탈퇴한 계정 로그인 시도: {}", email);
                response.put("success", false);
                response.put("message", "현재 로그인 할 수 없는 계정입니다.");
                response.put("dormant", true);
                return response;
            }

            // ACTIVE 상태만 로그인 허용
            if (!"ACTIVE".equals(memberStatus)) {
                logger.warn("비활성 상태 계정 로그인 시도: {} (status: {})", email, memberStatus);
                response.put("success", false);
                response.put("message", "현재 로그인 할 수 없는 계정입니다.");
                return response;
            }

            logger.info("회원 상태 확인 완료: {} (status: {})", email, memberStatus);

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

            // 자동 로그인 처리
            logger.info("자동 로그인 체크: rememberMe = {}", rememberMe);
            if (rememberMe) {
                logger.info("✅ 자동 로그인 요청 - 토큰 생성 시작");
                try {
                    // UUID로 자동 로그인 토큰 생성
                    String autoLoginToken = UUID.randomUUID().toString();
                    logger.info("토큰 생성 완료: {}", autoLoginToken.substring(0, 8) + "...");

                    // 토큰을 DB에 저장 (30일 유효)
                    saveAutoLoginToken(member.getMemberId(), autoLoginToken);
                    logger.info("DB에 토큰 저장 완료");

                    // 컨텍스트 경로 가져오기
                    String contextPath = httpRequest.getContextPath();
                    if (contextPath == null || contextPath.isEmpty()) {
                        contextPath = "/";
                    }
                    logger.info("쿠키 경로: {}", contextPath);

                    // 쿠키 생성 (30일 = 2592000초)
                    Cookie cookie = new Cookie("autoLoginToken", autoLoginToken);
                    cookie.setPath(contextPath);
                    cookie.setMaxAge(30 * 24 * 60 * 60);  // 30일
                    cookie.setHttpOnly(true);  // JavaScript로 접근 불가 (보안)
                    httpResponse.addCookie(cookie);

                    logger.info("✅ 자동 로그인 쿠키 생성 완료 - email: {}, path: {}, maxAge: 30일", email, contextPath);
                } catch (Exception e) {
                    logger.error("❌ 자동 로그인 토큰 생성 실패 (로그인은 성공)", e);
                }
            } else {
                logger.info("⚠️ 자동 로그인 미요청 - rememberMe = false");
            }

            response.put("success", true);
            response.put("user", userDto);

            logger.info("로그인 성공: {} (자동 로그인: {})", email, rememberMe);

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

            // 비밀번호 형식 검증 (영문, 숫자, 특수문자 3가지 조합 8자 이상)
            if (!isValidPassword(member.getPwd())) {
                response.put("success", false);
                response.put("message", "비밀번호는 영문, 숫자, 특수문자를 모두 포함한 8자 이상이어야 합니다.");
                logger.warn("비밀번호 형식 오류: {}", member.getEmail());
                return response;
            }

            // 기본 role 설정
            if (member.getRole() == null || member.getRole().isEmpty()) {
                member.setRole("USER");
            }

            // 프로필 이미지 초기화 (회원가입 시 NULL로 설정)
            member.setProfileImageUrl(null);
            logger.info("프로필 이미지 NULL로 초기화");

            // 비밀번호 BCrypt 암호화
            String encryptedPassword = passwordEncoder.encode(member.getPwd());
            member.setPwd(encryptedPassword);

            logger.info("최종 member.email: {}", member.getEmail());

            // 활성 계정 중복 검사
            if (memberDao.existsByEmail(member.getEmail())) {
                logger.warn("중복 회원가입 시도 (활성 계정): {}", member.getEmail());
                response.put("success", false);
                response.put("message", "이미 등록된 이메일입니다. 다른 이메일을 사용해주세요.");
                return response;
            }

            // 삭제된 계정이 있는지 확인
            Member deletedMember = memberDao.selectDeleted(member.getEmail());
            int result = 0;

            if (deletedMember != null) {
                // 탈퇴한 계정이 있으면 재활성화
                logger.info("탈퇴한 계정 재활성화: {}", member.getEmail());
                result = memberDao.reactivateAccount(member);
                logger.info("계정 재활성화 결과: {}", result);
            } else {
                // 새로운 회원가입
                logger.info("DB insert 시작...");
                result = memberDao.insert(member);
                logger.info("DB insert 결과: {}", result);
            }

            if (result > 0) {
                response.put("success", true);
                response.put("message", "회원가입 완료");
                logger.info("회원가입 성공: {} ({})", member.getName(), member.getEmail());
            } else {
                response.put("success", false);
                response.put("message", "회원가입에 실패했습니다.");
                logger.error("회원가입 실패: result={}", result);
            }

        } catch (Exception e) {
            logger.error("회원가입 처리 중 오류 발생", e);
            response.put("success", false);

            // 중복 이메일 에러 처리
            if (e.getMessage() != null && e.getMessage().contains("Duplicate entry")) {
                response.put("message", "이미 등록된 이메일입니다. 다른 이메일을 사용해주세요.");
            } else {
                response.put("message", "회원가입 처리 중 오류가 발생했습니다: " + e.getMessage());
            }
        }

        return response;
    }

    /**
     * 로그아웃 처리
     * @GetMapping("/api/auth/logout")
     * - 세션 무효화
     * - 자동 로그인 토큰 DB에서 삭제
     * - 자동 로그인 쿠키 삭제
     */
    @GetMapping("/logout")
    public Map<String, Object> logout(HttpSession session, HttpServletRequest request, HttpServletResponse httpResponse) {

        Map<String, Object> response = new HashMap<>();

        try {
            String username = (String) session.getAttribute("username");
            String userId = (String) session.getAttribute("id");
            if (userId == null) {
                userId = (String) session.getAttribute("userId");
            }

            // 자동 로그인 토큰 삭제 처리
            if (userId != null) {
                try {
                    // 회원 정보 조회하여 memberId 획득
                    Member member = memberDao.select(userId);
                    if (member != null) {
                        // DB에서 자동 로그인 토큰 삭제
                        deleteAutoLoginToken(member.getMemberId());
                        logger.info("자동 로그인 토큰 DB에서 삭제 완료: {}", userId);
                    }
                } catch (Exception e) {
                    logger.warn("자동 로그인 토큰 삭제 중 오류 (로그아웃은 계속 진행)", e);
                }
            }

            // 자동 로그인 쿠키 삭제
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("autoLoginToken".equals(cookie.getName())) {
                        Cookie deleteCookie = new Cookie("autoLoginToken", null);
                        deleteCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                        deleteCookie.setMaxAge(0);  // 즉시 만료
                        deleteCookie.setHttpOnly(true);
                        httpResponse.addCookie(deleteCookie);
                        logger.info("자동 로그인 쿠키 삭제 완료");
                        break;
                    }
                }
            }

            // 세션 무효화
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

        // "userId" 또는 "id" 둘 다 확인 (일관성을 위해)
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            userId = (String) session.getAttribute("id");
        }

        if (userId == null || userId.isEmpty()) {
            response.put("loggedIn", false);
        } else {
            response.put("loggedIn", true);
            response.put("userId", userId);
            response.put("username", session.getAttribute("username"));
            response.put("role", session.getAttribute("role"));
        }

        return response;
    }

    /**
     * 자동 로그인 상태 확인
     * @GetMapping("/api/auth/auto-login-status")
     */
    @GetMapping("/auto-login-status")
    public Map<String, Object> checkAutoLoginStatus(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        // 일단 무조건 성공 응답 (디버깅용)
        response.put("success", true);
        response.put("enabled", false);

        try {
            logger.info("=== 자동 로그인 상태 확인 시작 ===");

            String userId = (String) session.getAttribute("id");
            if (userId == null) {
                userId = (String) session.getAttribute("userId");
            }

            logger.info("userId: {}", userId);

            if (userId == null) {
                logger.warn("로그인되지 않은 상태");
                return response;
            }

            // 회원 정보 조회
            logger.info("회원 정보 조회 시작: {}", userId);
            Member member = null;
            try {
                member = memberDao.select(userId);
                logger.info("회원 조회 결과: {}", member != null);
            } catch (Exception e) {
                logger.error("회원 조회 중 예외", e);
                return response;
            }

            if (member == null) {
                logger.warn("회원 정보 없음: {}", userId);
                return response;
            }

            logger.info("회원 ID: {}, 이메일: {}", member.getMemberId(), member.getEmail());

            // DB에서 자동 로그인 토큰 확인
            logger.info("자동 로그인 토큰 확인 시작 - memberId: {}", member.getMemberId());
            boolean hasToken = false;

            if (dataSource != null) {
                try {
                    hasToken = checkAutoLoginTokenExists(member.getMemberId());
                    logger.info("토큰 존재 여부: {}", hasToken);
                    response.put("enabled", hasToken);
                } catch (Exception e) {
                    logger.error("토큰 확인 중 예외 발생", e);
                    // 예외 발생 시 토큰 없는 것으로 처리
                }
            } else {
                logger.error("DataSource가 null입니다!");
            }

            logger.info("✅ 자동 로그인 상태 조회 완료: {} - {}", userId, hasToken);

        } catch (Exception e) {
            logger.error("❌ 자동 로그인 상태 확인 중 최상위 예외 발생", e);
            e.printStackTrace();
        }

        return response;
    }

    /**
     * 자동 로그인 활성화 (토큰 생성)
     * @PostMapping("/api/auth/enable-auto-login")
     */
    @PostMapping("/enable-auto-login")
    public Map<String, Object> enableAutoLogin(HttpSession session, HttpServletResponse httpResponse) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");
            if (userId == null) {
                userId = (String) session.getAttribute("userId");
            }

            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            // 회원 정보 조회
            Member member = memberDao.select(userId);
            if (member == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            // UUID로 자동 로그인 토큰 생성
            String autoLoginToken = UUID.randomUUID().toString();

            // 토큰을 DB에 저장 (30일 유효)
            saveAutoLoginToken(member.getMemberId(), autoLoginToken);

            // 쿠키 생성 (30일 = 2592000초)
            Cookie cookie = new Cookie("autoLoginToken", autoLoginToken);
            cookie.setPath("/");
            cookie.setMaxAge(30 * 24 * 60 * 60);  // 30일
            cookie.setHttpOnly(true);  // JavaScript로 접근 불가 (보안)
            httpResponse.addCookie(cookie);

            response.put("success", true);
            response.put("message", "로그인 상태 유지가 활성화되었습니다.");
            logger.info("자동 로그인 활성화 성공: {}", userId);

        } catch (Exception e) {
            logger.error("자동 로그인 활성화 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "자동 로그인 활성화 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 자동 로그인 해제 (토큰 삭제)
     * @PostMapping("/api/auth/disable-auto-login")
     */
    @PostMapping("/disable-auto-login")
    public Map<String, Object> disableAutoLogin(HttpSession session, HttpServletResponse httpResponse) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");
            if (userId == null) {
                userId = (String) session.getAttribute("userId");
            }

            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            // 회원 정보 조회
            Member member = memberDao.select(userId);
            if (member == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            // DB에서 자동 로그인 토큰 삭제
            deleteAutoLoginToken(member.getMemberId());

            // 쿠키 삭제
            Cookie cookie = new Cookie("autoLoginToken", null);
            cookie.setPath("/");
            cookie.setMaxAge(0);
            cookie.setHttpOnly(true);
            httpResponse.addCookie(cookie);

            response.put("success", true);
            response.put("message", "로그인 상태 유지가 해제되었습니다.");
            logger.info("자동 로그인 해제 성공: {}", userId);

        } catch (Exception e) {
            logger.error("자동 로그인 해제 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "자동 로그인 해제 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 자동 로그인 토큰 저장 (DB - auto_login_tokens 테이블)
     * @param memberId 회원 ID
     * @param token 자동 로그인 토큰 (UUID)
     */
    private void saveAutoLoginToken(Long memberId, String token) throws Exception {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dataSource.getConnection();

            // 기존 토큰 삭제 (한 사용자당 하나의 토큰만 유지)
            String deleteSql = "DELETE FROM auto_login_tokens WHERE member_id = ?";
            pstmt = con.prepareStatement(deleteSql);
            pstmt.setLong(1, memberId);
            pstmt.executeUpdate();
            pstmt.close();

            // 새 토큰 저장 (30일 유효기간)
            String insertSql = "INSERT INTO auto_login_tokens (member_id, token, expires_at) " +
                             "VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 30 DAY))";
            pstmt = con.prepareStatement(insertSql);
            pstmt.setLong(1, memberId);
            pstmt.setString(2, token);
            pstmt.executeUpdate();

            logger.info("자동 로그인 토큰 저장 완료 - memberId: {}", memberId);

        } finally {
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        }
    }

    /**
     * 자동 로그인 토큰 존재 여부 확인
     * @param memberId 회원 ID
     * @return 토큰 존재 여부
     */
    private boolean checkAutoLoginTokenExists(Long memberId) throws Exception {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            logger.debug("DataSource 확인: {}", dataSource != null);

            if (dataSource == null) {
                logger.error("DataSource가 null입니다!");
                return false;
            }

            con = dataSource.getConnection();
            logger.debug("DB 연결 성공");

            String sql = "SELECT COUNT(*) FROM auto_login_tokens WHERE member_id = ? AND expires_at > NOW()";
            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, memberId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                int count = rs.getInt(1);
                logger.debug("토큰 개수: {}", count);
                return count > 0;
            }

            logger.debug("결과 없음");
            return false;

        } catch (Exception e) {
            logger.error("토큰 확인 중 예외: {}", e.getMessage(), e);
            throw e;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (Exception e) {
                logger.error("리소스 정리 중 예외", e);
            }
        }
    }

    /**
     * 자동 로그인 토큰 삭제
     * @param memberId 회원 ID
     */
    private void deleteAutoLoginToken(Long memberId) throws Exception {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dataSource.getConnection();

            String deleteSql = "DELETE FROM auto_login_tokens WHERE member_id = ?";
            pstmt = con.prepareStatement(deleteSql);
            pstmt.setLong(1, memberId);
            pstmt.executeUpdate();

            logger.info("자동 로그인 토큰 삭제 완료 - memberId: {}", memberId);

        } finally {
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        }
    }

    /**
     * 비밀번호 형식 검증
     * 영문, 숫자, 특수문자 3가지 조합 8자 이상
     * @param password 비밀번호S
     * @return 유효성 여부
     */
    private boolean isValidPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }

        boolean hasLetter = password.matches(".*[A-Za-z].*");
        boolean hasDigit = password.matches(".*\\d.*");
        boolean hasSpecial = password.matches(".*[!@#$%^&*].*");
        return hasLetter && hasDigit && hasSpecial;
    }
}
