package com.greenart.bdproject.interceptor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;

import com.greenart.bdproject.dao.ProjectMemberDao;
import com.greenart.bdproject.dto.Member;

/**
 * 자동 로그인 인터셉터
 * - 쿠키에 autoLoginToken이 있으면 자동 로그인 처리
 * - 토큰이 유효하고 만료되지 않았으면 세션 생성
 */
public class AutoLoginInterceptor implements HandlerInterceptor {

    private static final Logger logger = LoggerFactory.getLogger(AutoLoginInterceptor.class);

    private ProjectMemberDao memberDao;
    private DataSource dataSource;

    // Setter 메서드 추가 (XML에서 property로 주입)
    public void setMemberDao(ProjectMemberDao memberDao) {
        this.memberDao = memberDao;
    }

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        try {
            // dataSource나 memberDao가 null이면 자동 로그인 건너뛰기
            if (dataSource == null || memberDao == null) {
                logger.warn("자동 로그인 인터셉터: dataSource 또는 memberDao가 null입니다. 자동 로그인을 건너뜁니다.");
                return true;
            }

            HttpSession session = request.getSession(false);

            // 이미 로그인되어 있으면 인터셉터 통과
            if (session != null && session.getAttribute("id") != null) {
                return true;
            }

            // 쿠키에서 autoLoginToken 확인
            Cookie[] cookies = request.getCookies();
            if (cookies == null) {
                return true;
            }

            String autoLoginToken = null;
            for (Cookie cookie : cookies) {
                if ("autoLoginToken".equals(cookie.getName())) {
                    autoLoginToken = cookie.getValue();
                    break;
                }
            }

            // autoLoginToken 쿠키가 없으면 통과
            if (autoLoginToken == null) {
                return true;
            }

            logger.info("=== 자동 로그인 시도 - 토큰 발견 ===");
            logger.info("autoLoginToken: {}", autoLoginToken);

            // DB에서 토큰 검증
            Member member = validateAutoLoginToken(autoLoginToken);

            if (member != null) {
                // 자동 로그인 성공 - 세션 생성
                HttpSession newSession = request.getSession(true);
                newSession.setAttribute("id", member.getEmail());
                newSession.setAttribute("userId", member.getEmail());
                newSession.setAttribute("username", member.getName());
                newSession.setAttribute("role", member.getRole() != null ? member.getRole() : "USER");

                logger.info("✅ 자동 로그인 성공: {}", member.getEmail());
            } else {
                logger.warn("❌ 자동 로그인 실패: 토큰이 유효하지 않거나 만료됨");

                // 만료된 쿠키 삭제
                Cookie expiredCookie = new Cookie("autoLoginToken", null);
                expiredCookie.setPath("/");
                expiredCookie.setMaxAge(0);
                response.addCookie(expiredCookie);
            }

        } catch (Exception e) {
            // 자동 로그인 실패 시 로그만 남기고 계속 진행
            logger.error("자동 로그인 인터셉터에서 예외 발생 (요청은 계속 진행)", e);
        }

        return true;
    }

    /**
     * 자동 로그인 토큰 검증
     * - 토큰 유효성 확인
     * - 회원 상태(status) 확인: ACTIVE 상태만 자동 로그인 허용
     * - 삭제된 회원(deleted_at) 확인
     * @param token 자동 로그인 토큰
     * @return Member 객체 (유효한 경우) 또는 null
     */
    private Member validateAutoLoginToken(String token) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = dataSource.getConnection();

            // auto_login_tokens 테이블에서 토큰 조회
            // 추가 조건: status = 'ACTIVE' AND deleted_at IS NULL
            String sql = "SELECT alt.member_id, alt.expires_at, m.email, m.name, m.role, m.status " +
                        "FROM auto_login_tokens alt " +
                        "INNER JOIN member m ON alt.member_id = m.member_id " +
                        "WHERE alt.token = ? " +
                        "AND alt.expires_at > NOW() " +
                        "AND m.status = 'ACTIVE' " +
                        "AND m.deleted_at IS NULL";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, token);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Long memberId = rs.getLong("member_id");
                String email = rs.getString("email");
                String name = rs.getString("name");
                String role = rs.getString("role");
                String status = rs.getString("status");
                Timestamp expiresAt = rs.getTimestamp("expires_at");

                logger.info("토큰 검증 성공 - memberId: {}, email: {}, status: {}", new Object[]{memberId, email, status});
                logger.info("토큰 만료 시간: {}", expiresAt);

                // Member 객체 생성 (필요한 정보만)
                Member member = new Member();
                member.setMemberId(memberId);
                member.setEmail(email);
                member.setName(name);
                member.setRole(role);
                member.setStatus(status);

                return member;
            } else {
                logger.warn("토큰 검증 실패 - 토큰이 DB에 없거나 만료됨 또는 회원 상태가 ACTIVE가 아님");
                return null;
            }

        } catch (Exception e) {
            logger.error("자동 로그인 토큰 검증 중 오류", e);
            return null;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (Exception e) {
                logger.error("리소스 정리 중 오류", e);
            }
        }
    }
}
