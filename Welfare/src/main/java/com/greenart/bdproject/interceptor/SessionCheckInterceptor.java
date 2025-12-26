package com.greenart.bdproject.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 세션 만료 체크 Interceptor
 * 로그인이 필요한 페이지 접근 시 세션 만료 여부 확인
 */
public class SessionCheckInterceptor implements HandlerInterceptor {

    private static final Logger logger = LoggerFactory.getLogger(SessionCheckInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);

        String requestURI = request.getRequestURI();
        logger.info("세션 체크 - 요청 URL: {}", requestURI);

        // 세션이 없거나 로그인 정보가 없는 경우
        if (session == null || session.getAttribute("id") == null) {
            logger.warn("세션 만료 또는 미로그인 상태 - URL: {}", requestURI);

            // AJAX 요청인 경우 JSON 응답
            if (isAjaxRequest(request)) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"로그인이 필요합니다.\", \"sessionExpired\": true}");
                return false;
            }

            // 일반 페이지 요청인 경우 세션 만료 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/error/session-expired.jsp");
            return false;
        }

        return true;
    }

    /**
     * AJAX 요청 여부 확인
     */
    private boolean isAjaxRequest(HttpServletRequest request) {
        String xhrHeader = request.getHeader("X-Requested-With");
        String acceptHeader = request.getHeader("Accept");

        return "XMLHttpRequest".equals(xhrHeader) ||
               (acceptHeader != null && acceptHeader.contains("application/json"));
    }
}
