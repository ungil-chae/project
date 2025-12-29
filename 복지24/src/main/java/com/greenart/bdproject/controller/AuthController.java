package com.greenart.bdproject.controller;

import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.greenart.bdproject.dao.MemberDao;
import com.greenart.bdproject.dto.Member;

@Controller
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    @Autowired
    private MemberDao memberDao;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    // 아이디 찾기 API (이메일 기반 - 레거시)
    @PostMapping("/api/auth/find-id")
    @ResponseBody
    public Map<String, Object> findId(@RequestParam("name") String name,
                                      @RequestParam("email") String email) {
        Map<String, Object> response = new HashMap<>();

        try {
            logger.info("========== 아이디 찾기 요청 (이메일 기반) ==========");
            logger.info("이름: {}", name);
            logger.info("이메일: {}", email);

            Member member = memberDao.findByNameAndEmail(name, email);

            if (member != null) {
                response.put("success", true);
                response.put("userId", member.getEmail());
                logger.info("아이디 찾기 성공: {}", member.getEmail());
            } else {
                response.put("success", false);
                response.put("message", "입력하신 정보와 일치하는 회원을 찾을 수 없습니다.");
                logger.warn("아이디 찾기 실패: 일치하는 회원 없음");
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "시스템 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            logger.error("아이디 찾기 오류", e);
        }

        return response;
    }

    // 아이디 찾기 API (전화번호 기반)
    @PostMapping("/api/auth/find-id-by-phone")
    @ResponseBody
    public Map<String, Object> findIdByPhone(@RequestParam("name") String name,
                                             @RequestParam("phone") String phone) {
        Map<String, Object> response = new HashMap<>();

        try {
            logger.info("========== 아이디 찾기 요청 (전화번호 기반) ==========");
            logger.info("이름: {}", name);
            logger.info("전화번호: {}", phone);

            Member member = memberDao.findByNameAndPhone(name, phone);

            if (member != null) {
                // 이메일 일부 마스킹 처리 (보안)
                String email = member.getEmail();
                String maskedEmail = maskEmail(email);

                response.put("success", true);
                response.put("email", email); // 실제 이메일 전체 반환
                response.put("maskedEmail", maskedEmail); // 마스킹된 이메일
                logger.info("아이디 찾기 성공: {}", maskedEmail);
            } else {
                response.put("success", false);
                response.put("message", "입력하신 정보와 일치하는 회원을 찾을 수 없습니다.");
                logger.warn("아이디 찾기 실패: 일치하는 회원 없음");
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "시스템 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            logger.error("아이디 찾기 오류", e);
        }

        return response;
    }

    /**
     * 이메일 마스킹 처리
     * 예: test@example.com → te**@example.com
     */
    private String maskEmail(String email) {
        if (email == null || !email.contains("@")) {
            return email;
        }

        String[] parts = email.split("@");
        String localPart = parts[0];
        String domain = parts[1];

        if (localPart.length() <= 2) {
            return localPart.charAt(0) + "**@" + domain;
        }

        int visibleChars = Math.min(2, localPart.length() / 2);
        String visible = localPart.substring(0, visibleChars);
        String masked = "**";

        return visible + masked + "@" + domain;
    }

    // 비밀번호 찾기 - 보안 질문 확인 및 비밀번호 재설정
    @PostMapping("/api/auth/reset-password-security")
    @ResponseBody
    public Map<String, Object> resetPasswordWithSecurity(@RequestParam("username") String username,
                                                          @RequestParam("securityAnswer") String securityAnswer,
                                                          @RequestParam("newPassword") String newPassword) {
        Map<String, Object> response = new HashMap<>();

        try {
            logger.info("========== 비밀번호 재설정 (보안 질문) ==========");
            logger.info("아이디: {}", username);

            // 비밀번호 유효성 검사 (최소 8자로 강화)
            if (newPassword == null || newPassword.length() < 8) {
                response.put("success", false);
                response.put("message", "비밀번호는 최소 8자 이상이어야 합니다.");
                return response;
            }

            // 아이디와 보안 질문 답변 확인
            Member member = memberDao.findByIdAndSecurityAnswer(username, securityAnswer);

            if (member == null) {
                response.put("success", false);
                response.put("message", "아이디 또는 보안 질문 답변이 일치하지 않습니다.");
                logger.warn("보안 질문 답변 불일치: {}", username);
                return response;
            }

            // 🔐 BCrypt로 비밀번호 암호화
            String encryptedPassword = passwordEncoder.encode(newPassword);
            member.setPwd(encryptedPassword);

            int result = memberDao.update(member);

            if (result > 0) {
                response.put("success", true);
                response.put("message", "비밀번호가 성공적으로 변경되었습니다.");
                logger.info("비밀번호 변경 성공: {}", username);
            } else {
                response.put("success", false);
                response.put("message", "비밀번호 변경에 실패했습니다.");
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "시스템 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            logger.error("비밀번호 재설정 오류", e);
        }

        return response;
    }

    // 보안 질문 조회
    @GetMapping("/api/auth/security-question")
    @ResponseBody
    public Map<String, Object> getSecurityQuestion(@RequestParam("username") String username) {
        Map<String, Object> response = new HashMap<>();

        try {
            System.out.println("========== 보안 질문 조회 ==========");
            System.out.println("아이디: " + username);

            Member member = memberDao.select(username);

            if (member == null) {
                System.out.println("회원을 찾을 수 없음");
                response.put("success", false);
                response.put("message", "존재하지 않는 아이디입니다.");
                return response;
            }

            System.out.println("회원 조회 성공 - Email: " + member.getEmail());
            System.out.println("보안 질문: " + member.getSecurityQuestion());
            System.out.println("보안 답변: " + member.getSecurityAnswer());

            if (member.getSecurityQuestion() == null || member.getSecurityQuestion().isEmpty()) {
                response.put("success", false);
                response.put("message", "등록된 보안 질문이 없습니다. 관리자에게 문의하세요.");
                System.out.println("보안 질문이 null이거나 비어있음");
                return response;
            }

            response.put("success", true);
            response.put("securityQuestion", member.getSecurityQuestion());
            System.out.println("보안 질문 조회 성공: " + member.getSecurityQuestion());

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "시스템 오류가 발생했습니다.");
            System.out.println("보안 질문 조회 오류: " + e.getMessage());
            e.printStackTrace();
        }

        return response;
    }

    // 로그인 페이지 표시
    @GetMapping("/LOGIN")
    public String loginPage() {
        System.out.println("========== 로그인 페이지 요청 ==========");
        return "projectLogin"; // login.jsp로 이동
    }

    // 로그인 처리 (임시 - 사용 안 함)
    @PostMapping("/auth/login")
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
    
    // 로그아웃 API (AJAX용)
    @PostMapping("/api/auth/logout")
    @ResponseBody
    public Map<String, Object> logoutApi(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            Member member = (Member) session.getAttribute("member");
            if (member != null) {
                logger.info("로그아웃: {}", member.getEmail());
            }

            // 세션 무효화
            session.invalidate();

            response.put("success", true);
            response.put("message", "로그아웃되었습니다.");

        } catch (Exception e) {
            logger.error("로그아웃 오류", e);
            response.put("success", false);
            response.put("message", "로그아웃 중 오류가 발생했습니다.");
        }

        return response;
    }

    // 로그아웃 처리 (페이지 리다이렉트용)
    @GetMapping("/auth/logout")
    public String logout(HttpSession session) {
        logger.info("========== 로그아웃 ==========");

        Member member = (Member) session.getAttribute("member");
        if (member != null) {
            logger.info("로그아웃: {}", member.getEmail());
        }

        // 세션 무효화
        session.invalidate();

        // 로그인 페이지로 리다이렉트
        return "redirect:/projectLogin.jsp";
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