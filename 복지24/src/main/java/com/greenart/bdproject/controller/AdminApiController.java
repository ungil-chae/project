package com.greenart.bdproject.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.greenart.bdproject.service.AdminService;
import com.greenart.bdproject.service.NotificationService;

@RestController
@RequestMapping("/api/admin")
public class AdminApiController {

    private static final Logger logger = LoggerFactory.getLogger(AdminApiController.class);

    @Autowired
    private AdminService adminService;

    @Autowired(required = false)
    private NotificationService notificationService;

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
     * 회원 탈퇴 처리 (소프트 삭제 - DORMANT 상태로 변경)
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
                response.put("message", "회원이 탈퇴 처리되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "회원 탈퇴 처리에 실패했습니다.");
            }
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "회원 탈퇴 처리 중 오류가 발생했습니다: " + e.getMessage());
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

    /**
     * 일괄 상태 변경
     */
    @PostMapping("/member/bulk-status")
    public ResponseEntity<Map<String, Object>> bulkUpdateStatus(
            @RequestParam("userIds") String userIds,
            @RequestParam("action") String action,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            String[] userIdArray = userIds.split(",");
            String status = null;

            // 액션을 상태로 변환
            if ("activate".equals(action)) {
                status = "ACTIVE";
            } else if ("suspend".equals(action)) {
                status = "SUSPENDED";
            } else if ("dormant".equals(action)) {
                status = "DORMANT";
            } else {
                response.put("success", false);
                response.put("message", "유효하지 않은 액션입니다.");
                return ResponseEntity.badRequest().body(response);
            }

            int successCount = 0;
            for (String userId : userIdArray) {
                boolean result = adminService.updateMemberStatus(userId.trim(), status);
                if (result) {
                    successCount++;
                }
            }

            response.put("success", true);
            response.put("message", successCount + "명의 회원 상태가 변경되었습니다.");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "일괄 상태 변경 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 일괄 등급 변경
     */
    @PostMapping("/member/bulk-role")
    public ResponseEntity<Map<String, Object>> bulkUpdateRole(
            @RequestParam("userIds") String userIds,
            @RequestParam("role") String role,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            String adminRole = (String) session.getAttribute("role");

            if (!"ADMIN".equals(adminRole)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            // 유효한 역할인지 확인
            if (!"USER".equals(role) && !"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "유효하지 않은 등급입니다.");
                return ResponseEntity.badRequest().body(response);
            }

            String[] userIdArray = userIds.split(",");
            int successCount = 0;

            for (String userId : userIdArray) {
                boolean result = adminService.updateMemberRole(userId.trim(), role);
                if (result) {
                    successCount++;
                }
            }

            response.put("success", true);
            response.put("message", successCount + "명의 회원 등급이 변경되었습니다.");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "일괄 등급 변경 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 봉사활동 승인 및 시설 배정
     */
    @PostMapping("/volunteer/approve")
    public ResponseEntity<Map<String, Object>> approveVolunteer(
            @RequestParam("applicationId") Long applicationId,
            @RequestParam("facilityName") String facilityName,
            @RequestParam("facilityAddress") String facilityAddress,
            @RequestParam(value = "facilityLat", required = false) String facilityLat,
            @RequestParam(value = "facilityLng", required = false) String facilityLng,
            @RequestParam(value = "adminNote", required = false) String adminNote,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        logger.info("=== 봉사활동 승인 요청 시작 ===");
        logger.info("applicationId: {}", applicationId);
        logger.info("facilityName: {}", facilityName);
        logger.info("facilityAddress: {}", facilityAddress);
        logger.info("facilityLat: {}", facilityLat);
        logger.info("facilityLng: {}", facilityLng);

        try {
            String role = (String) session.getAttribute("role");
            String userId = (String) session.getAttribute("id");

            logger.info("세션 role: {}, userId: {}", role, userId);

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            logger.info("adminService.approveVolunteerApplication 호출 시작");
            boolean result = adminService.approveVolunteerApplication(
                applicationId,
                userId,
                facilityName,
                facilityAddress,
                facilityLat,
                facilityLng,
                adminNote
            );
            logger.info("adminService.approveVolunteerApplication 결과: {}", result);

            if (result) {
                // 승인 성공 시 사용자에게 알림 발송
                if (notificationService != null) {
                    try {
                        logger.info("알림 발송을 위한 봉사 신청 정보 조회 시작");
                        Map<String, Object> volunteerInfo = adminService.getVolunteerApplicationById(applicationId);
                        logger.info("volunteerInfo: {}", volunteerInfo);

                        if (volunteerInfo != null) {
                            String userEmail = (String) volunteerInfo.get("userEmail");
                            Object volunteerDateObj = volunteerInfo.get("volunteerDate");
                            String volunteerDate = volunteerDateObj != null ? volunteerDateObj.toString() : null;

                            logger.info("userEmail: {}, volunteerDate: {}", userEmail, volunteerDate);

                            if (userEmail != null && !userEmail.isEmpty()) {
                                Long notifId = notificationService.createVolunteerApprovalNotification(
                                    userEmail,
                                    applicationId,
                                    facilityName,
                                    volunteerDate
                                );
                                logger.info("알림 생성 결과 - notificationId: {}", notifId);
                            } else {
                                logger.warn("userEmail이 없어 알림 발송 생략");
                            }
                        } else {
                            logger.warn("volunteerInfo가 null입니다");
                        }
                    } catch (Exception e) {
                        // 알림 발송 실패해도 승인은 성공으로 처리
                        logger.error("알림 발송 중 오류 (승인은 성공)", e);
                    }
                } else {
                    logger.warn("notificationService가 null입니다");
                }

                response.put("success", true);
                response.put("message", "봉사 활동이 승인되고 시설이 배정되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "봉사 활동 승인에 실패했습니다.");
            }
            logger.info("=== 봉사활동 승인 요청 완료 ===");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("봉사활동 승인 처리 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "승인 처리 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 봉사활동 거절
     */
    @PostMapping("/volunteer/reject")
    public ResponseEntity<Map<String, Object>> rejectVolunteer(
            @RequestParam("applicationId") Long applicationId,
            @RequestParam("reason") String reason,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            boolean result = adminService.rejectVolunteerApplication(applicationId, reason);

            if (result) {
                response.put("success", true);
                response.put("message", "봉사 활동이 거절되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "봉사 활동 거절에 실패했습니다.");
            }
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "거절 처리 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 대시보드 통계 카드 데이터 조회
     */
    @GetMapping("/dashboard/stats")
    public ResponseEntity<Map<String, Object>> getDashboardStats(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            Map<String, Object> stats = adminService.getDashboardStats();

            response.put("success", true);
            response.put("data", stats);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "대시보드 통계 조회 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 대시보드 차트 데이터 조회
     */
    @GetMapping("/dashboard/charts")
    public ResponseEntity<Map<String, Object>> getDashboardCharts(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            Map<String, Object> chartData = adminService.getDashboardChartData();

            response.put("success", true);
            response.put("data", chartData);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "차트 데이터 조회 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
