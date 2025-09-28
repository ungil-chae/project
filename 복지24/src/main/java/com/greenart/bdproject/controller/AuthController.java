package com.greenart.bdproject.controller;

import java.util.Map;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {
    
    // 로그인 페이지 표시
    @GetMapping("/LOGIN")
    public String loginPage() {
        System.out.println("========== 로그인 페이지 요청 ==========");
        return "projectLogin"; // login.jsp로 이동
    }
    
    // 로그인 처리
    @PostMapping("/login")
    public String loginProcess(@RequestParam("username") String username, 
                             @RequestParam("password") String password,
                             HttpSession session,
                             Model model) {
        
        System.out.println("========== 로그인 시도 ==========");
        System.out.println("사용자명: " + username);
        System.out.println("비밀번호: " + password);
        
        // 임시 로그인 검증 (실제로는 DB 조회해야 함)
        if (isValidUser(username, password)) {
            // 로그인 성공
            session.setAttribute("isLoggedIn", true);
            session.setAttribute("username", username);
            session.setAttribute("loginTime", System.currentTimeMillis());
            
            System.out.println("로그인 성공: " + username);

            // 메인 페이지로 리다이렉트
            return "redirect:/";
            
        } else {
            // 로그인 실패
            model.addAttribute("error", "사용자명 또는 비밀번호가 올바르지 않습니다.");
            System.out.println("로그인 실패: " + username);

            return "login"; // 다시 로그인 페이지로
        }
    }
    
    // 로그아웃 처리
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        System.out.println("========== 로그아웃 ==========");

        String username = (String) session.getAttribute("username");
        if (username != null) {
            System.out.println("로그아웃: " + username);
        }

        // 세션 무효화
        session.invalidate();

        // 로그인 페이지로 리다이렉트
        return "redirect:/login";
    }
    
    // 회원가입 페이지
    @GetMapping("/signup")
    public String signupPage() {
        System.out.println("========== 회원가입 페이지 요청 ==========");
        return "signup"; // signup.jsp로 이동
    }
    
    // 회원가입 처리
    @PostMapping("/signup")
    public String signupProcess(@RequestParam Map<String, String> params, Model model) {
        System.out.println("========== 회원가입 시도 ==========");

        // 입력 파라미터 출력
        params.forEach((key, value) -> {
            System.out.println(key + ": " + value);
        });
        
        String username = params.get("username");
        String email = params.get("email");
        String password = params.get("password");
        String confirmPassword = params.get("confirmPassword");
        
        // 비밀번호 확인
        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
            return "signup";
        }

        // 실제로는 DB에 저장해야 함
        // 임시로 성공 처리
        System.out.println("회원가입 성공: " + username);
        model.addAttribute("message", "회원가입이 완료되었습니다. 로그인해주세요.");
        
        return "login"; // 로그인 페이지로 이동
    }
    
    // 비밀번호 찾기 페이지
    @GetMapping("/forgot-password")
    public String forgotPasswordPage() {
        System.out.println("========== 비밀번호 찾기 페이지 요청 ==========");
        return "forgot_password"; // forgot_password.jsp로 이동
    }
    
    // 비밀번호 찾기 처리
    @PostMapping("/forgot-password")
    public String forgotPasswordProcess(@RequestParam("email") String email, Model model) {
        System.out.println("========== 비밀번호 찾기 요청 ==========");
        System.out.println("이메일: " + email);

        // 실제로는 이메일 발송 기능 필요
        model.addAttribute("message", "비밀번호 재설정 링크를 이메일로 발송했습니다.");
        
        return "forgot_password";
    }
    
    // 임시 사용자 인증 메소드 (실제로는 Service 계층에서 DB 조회)
    private boolean isValidUser(String username, String password) {
        // 임시 테스트 계정
        return ("admin".equals(username) && "1234".equals(password)) ||
               ("test".equals(username) && "test".equals(password));
    }
}