package com.greenart.bdproject.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 에러 페이지 테스트용 컨트롤러
 * 테스트 후 삭제 권장
 */
@Controller
@RequestMapping("/error-test")
public class ErrorTestController {

    /**
     * 500 에러 테스트
     * 접속: /error-test/500
     */
    @GetMapping("/500")
    public String test500Error() {
        // 일부러 예외 발생
        throw new RuntimeException("500 에러 테스트입니다.");
    }

    /**
     * 에러 페이지 직접 확인
     * 접속: /error-test/view404
     */
    @GetMapping("/view404")
    public String view404() {
        return "forward:/error/error404.jsp";
    }

    /**
     * 에러 페이지 직접 확인
     * 접속: /error-test/view405
     */
    @GetMapping("/view405")
    public String view405() {
        return "forward:/error/error405.jsp";
    }

    /**
     * 에러 페이지 직접 확인
     * 접속: /error-test/view500
     */
    @GetMapping("/view500")
    public String view500() {
        return "forward:/error/error500.jsp";
    }

    /**
     * 세션 만료 페이지 직접 확인
     * 접속: /error-test/session-expired
     */
    @GetMapping("/session-expired")
    public String viewSessionExpired() {
        return "forward:/error/session-expired.jsp";
    }

    /**
     * 세션 강제 만료 테스트
     * 접속: /error-test/expire-session
     */
    @GetMapping("/expire-session")
    public String expireSession(HttpSession session) {
        // 세션 무효화
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/error/session-expired.jsp";
    }
}
