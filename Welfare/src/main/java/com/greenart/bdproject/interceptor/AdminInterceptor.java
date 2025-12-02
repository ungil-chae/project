package com.greenart.bdproject.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;

import com.greenart.bdproject.dto.Member;

/**
 * 관리자 권한 검증 Interceptor
 * /api/admin/** 경로에 대한 접근 제어
 */
public class AdminInterceptor implements HandlerInterceptor {

    private static final Logger logger = LoggerFactory.getLogger(AdminInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);

        logger.info("========== 관리자 권한 검증 ==========");
        logger.info("요청 URL: {}", request.getRequestURI());

        // 세션이 없는 경우
        if (session == null) {
            logger.warn("세션이 존재하지 않습니다.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\": false, \"error\": \"로그인이 필요합니다.\"}");
            return false;
        }

        // 로그인 정보 확인 (세션에서 개별 속성으로 저장된 정보 확인)
        String userId = (String) session.getAttribute("id");
        String role = (String) session.getAttribute("role");

        logger.info("세션 정보 - userId: {}, role: {}", userId, role);

        if (userId == null || userId.isEmpty()) {
            logger.warn("로그인 정보가 없습니다.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\": false, \"error\": \"로그인이 필요합니다.\"}");
            return false;
        }

        // 관리자 권한 확인
        if (!"ADMIN".equals(role)) {
            logger.warn("관리자 권한이 없습니다. 사용자: {}, 권한: {}", userId, role);
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\": false, \"error\": \"관리자 권한이 필요합니다.\"}");
            return false;
        }

        logger.info("관리자 권한 검증 성공: {}", userId);
        return true;
    }
}
