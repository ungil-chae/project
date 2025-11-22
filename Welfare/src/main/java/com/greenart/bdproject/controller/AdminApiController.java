package com.greenart.bdproject.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.greenart.bdproject.service.AdminService;

@RestController
@RequestMapping("/api/admin")
public class AdminApiController {

    @Autowired
    private AdminService adminService;

    /**
     * 관리자 대시보드 통계 조회
     */
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getAdminStats(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            // 세션에서 사용자 권한 확인
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            // 통계 데이터 조회
            Map<String, Object> stats = adminService.getAdminStats();

            response.put("success", true);
            response.put("data", stats);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "통계 조회 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 회원 목록 조회
     */
    @GetMapping("/members")
    public ResponseEntity<Map<String, Object>> getAllMembers(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            List<Map<String, Object>> members = adminService.getAllMembers();

            response.put("success", true);
            response.put("data", members);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "회원 목록 조회 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 공지사항 목록 조회
     */
    @GetMapping("/notices")
    public ResponseEntity<Map<String, Object>> getAllNotices(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            List<Map<String, Object>> notices = adminService.getAllNotices();

            response.put("success", true);
            response.put("data", notices);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "공지사항 목록 조회 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * FAQ 목록 조회
     */
    @GetMapping("/faqs")
    public ResponseEntity<Map<String, Object>> getAllFaqs(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            List<Map<String, Object>> faqs = adminService.getAllFaqs();

            response.put("success", true);
            response.put("data", faqs);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "FAQ 목록 조회 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 기부 내역 조회
     */
    @GetMapping("/donations")
    public ResponseEntity<Map<String, Object>> getAllDonations(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            List<Map<String, Object>> donations = adminService.getAllDonations();

            response.put("success", true);
            response.put("data", donations);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "기부 내역 조회 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 봉사 신청 내역 조회
     */
    @GetMapping("/volunteers")
    public ResponseEntity<Map<String, Object>> getAllVolunteers(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            List<Map<String, Object>> volunteers = adminService.getAllVolunteers();

            response.put("success", true);
            response.put("data", volunteers);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "봉사 신청 내역 조회 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 회원 정보 수정
     */
    @PostMapping("/member/update")
    public ResponseEntity<Map<String, Object>> updateMember(
            @RequestParam("userId") String userId,
            @RequestParam("name") String name,
            @RequestParam("email") String email,
            @RequestParam(value = "phone", required = false) String phone,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            boolean result = adminService.updateMember(userId, name, email, phone);

            if (result) {
                response.put("success", true);
                response.put("message", "회원 정보가 수정되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "회원 정보 수정에 실패했습니다.");
            }
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "회원 정보 수정 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 회원 삭제
     */
    @PostMapping("/member/delete")
    public ResponseEntity<Map<String, Object>> deleteMember(
            @RequestParam("userId") String userId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            boolean result = adminService.deleteMember(userId);

            if (result) {
                response.put("success", true);
                response.put("message", "회원이 삭제되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "회원 삭제에 실패했습니다.");
            }
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "회원 삭제 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 회원 계정 정지
     */
    @PostMapping("/member/suspend")
    public ResponseEntity<Map<String, Object>> suspendMember(
            @RequestParam("userId") String userId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            boolean result = adminService.suspendMember(userId);

            if (result) {
                response.put("success", true);
                response.put("message", "계정이 정지되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "계정 정지에 실패했습니다.");
            }
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "계정 정지 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 회원 계정 활성화
     */
    @PostMapping("/member/activate")
    public ResponseEntity<Map<String, Object>> activateMember(
            @RequestParam("userId") String userId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            boolean result = adminService.activateMember(userId);

            if (result) {
                response.put("success", true);
                response.put("message", "계정이 활성화되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "계정 활성화에 실패했습니다.");
            }
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "계정 활성화 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 회원 상태 변경 이력 조회
     */
    @GetMapping("/member/history")
    public ResponseEntity<Map<String, Object>> getMemberStatusHistory(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            List<Map<String, Object>> history = adminService.getMemberStatusHistory();

            response.put("success", true);
            response.put("data", history);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "상태 변경 이력 조회 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
