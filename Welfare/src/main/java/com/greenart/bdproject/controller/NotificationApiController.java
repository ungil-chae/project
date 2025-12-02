package com.greenart.bdproject.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.greenart.bdproject.dto.Notification;
import com.greenart.bdproject.dto.NotificationSettings;
import com.greenart.bdproject.service.NotificationService;
import com.greenart.bdproject.dao.NotificationDao;
import com.greenart.bdproject.dao.NotificationSettingsDao;
import com.greenart.bdproject.dao.ProjectMemberDao;

/**
 * 알림 API 컨트롤러
 * URL 패턴: /api/notifications/*
 */
@RestController
@RequestMapping("/api/notifications")
public class NotificationApiController {

    private static final Logger logger = LoggerFactory.getLogger(NotificationApiController.class);

    @Autowired
    private NotificationService notificationService;

    @Autowired(required = false)
    private NotificationSettingsDao notificationSettingsDao;

    @Autowired
    private ProjectMemberDao memberDao;

    @Autowired
    private NotificationDao notificationDao;

    /**
     * 사용자의 알림 목록 조회
     * @GetMapping("/api/notifications")
     */
    @GetMapping("")
    public Map<String, Object> getNotifications(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");

            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            List<Notification> notifications = notificationService.getNotificationsByUserId(userId);

            response.put("success", true);
            response.put("data", notifications);
            logger.info("알림 목록 조회 성공 - userId: {}, count: {}", userId, notifications.size());

        } catch (Exception e) {
            logger.error("알림 목록 조회 중 오류", e);
            response.put("success", false);
            response.put("message", "알림 목록 조회 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 알림 읽음 처리
     * @PostMapping("/api/notifications/{id}/read")
     */
    @PostMapping("/{id}/read")
    public Map<String, Object> markAsRead(@PathVariable("id") Long id, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");

            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            boolean result = notificationService.markNotificationAsRead(id);

            if (result) {
                response.put("success", true);
                response.put("message", "알림이 읽음 처리되었습니다.");
                logger.info("알림 읽음 처리 성공 - notificationId: {}", id);
            } else {
                response.put("success", false);
                response.put("message", "알림 읽음 처리에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("알림 읽음 처리 중 오류", e);
            response.put("success", false);
            response.put("message", "알림 읽음 처리 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 모든 알림 읽음 처리
     * @PostMapping("/api/notifications/read-all")
     */
    @PostMapping("/read-all")
    public Map<String, Object> markAllAsRead(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");

            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            boolean result = notificationService.markAllNotificationsAsRead(userId);

            if (result) {
                response.put("success", true);
                response.put("message", "모든 알림이 읽음 처리되었습니다.");
                logger.info("모든 알림 읽음 처리 성공 - userId: {}", userId);
            } else {
                response.put("success", false);
                response.put("message", "알림 읽음 처리에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("모든 알림 읽음 처리 중 오류", e);
            response.put("success", false);
            response.put("message", "알림 읽음 처리 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 알림 삭제
     * @DeleteMapping("/api/notifications/{id}")
     */
    @DeleteMapping("/{id}")
    public Map<String, Object> deleteNotification(@PathVariable("id") Long id, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");

            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            boolean result = notificationService.deleteNotification(id);

            if (result) {
                response.put("success", true);
                response.put("message", "알림이 삭제되었습니다.");
                logger.info("알림 삭제 성공 - notificationId: {}", id);
            } else {
                response.put("success", false);
                response.put("message", "알림 삭제에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("알림 삭제 중 오류", e);
            response.put("success", false);
            response.put("message", "알림 삭제 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 읽지 않은 알림 개수 조회
     * @GetMapping("/api/notifications/unread-count")
     */
    @GetMapping("/unread-count")
    public Map<String, Object> getUnreadCount(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");

            if (userId == null || userId.isEmpty()) {
                response.put("success", true);
                response.put("count", 0);
                return response;
            }

            int count = notificationService.getUnreadCount(userId);

            response.put("success", true);
            response.put("count", count);
            logger.info("읽지 않은 알림 개수 조회 - userId: {}, count: {}", userId, count);

        } catch (Exception e) {
            logger.error("읽지 않은 알림 개수 조회 중 오류", e);
            response.put("success", false);
            response.put("message", "알림 개수 조회 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 모든 알림 삭제
     * @PostMapping("/api/notifications/delete-all")
     */
    @PostMapping("/delete-all")
    public Map<String, Object> deleteAllNotifications(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");

            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            boolean result = notificationService.deleteAllNotifications(userId);

            if (result) {
                response.put("success", true);
                response.put("message", "모든 알림이 삭제되었습니다.");
                logger.info("모든 알림 삭제 성공 - userId: {}", userId);
            } else {
                response.put("success", false);
                response.put("message", "알림 삭제에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("모든 알림 삭제 중 오류", e);
            response.put("success", false);
            response.put("message", "알림 삭제 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 알림 자동 생성 (정기 기부, 봉사, 캘린더 일정)
     * @PostMapping("/api/notifications/generate")
     */
    @PostMapping("/generate")
    public Map<String, Object> generateNotifications(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            logger.info("=== 알림 생성 API 호출 시작 ===");

            String userId = (String) session.getAttribute("id");
            logger.info("세션에서 가져온 userId: {}", userId);

            if (userId == null || userId.isEmpty()) {
                logger.warn("로그인되지 않은 사용자의 알림 생성 요청");
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            logger.info("알림 자동 생성 시작 - userId: {}", userId);
            int count = notificationService.generateAutoNotifications(userId);
            logger.info("알림 자동 생성 완료 - userId: {}, count: {}", userId, count);

            response.put("success", true);
            response.put("count", count);
            response.put("message", count > 0 ?
                count + "개의 알림이 생성되었습니다." :
                "생성할 알림이 없습니다. (오늘/내일 일정 없음)");

        } catch (Exception e) {
            logger.error("알림 자동 생성 중 오류 발생", e);
            logger.error("예외 메시지: {}", e.getMessage());
            logger.error("예외 스택 트레이스:", e);
            response.put("success", false);
            response.put("message", "알림 생성 중 오류가 발생했습니다: " + e.getMessage());
            response.put("error", e.getClass().getSimpleName());
        }

        return response;
    }

    /**
     * 캘린더 일정 알림 생성
     * @PostMapping("/api/notifications/create-calendar")
     */
    @PostMapping("/create-calendar")
    public Map<String, Object> createCalendarNotification(@RequestBody Map<String, Object> requestData, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");

            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            String type = (String) requestData.get("type");
            String title = (String) requestData.get("title");
            String content = (String) requestData.get("content");
            Long relatedId = requestData.get("relatedId") != null ?
                Long.valueOf(requestData.get("relatedId").toString()) : null;
            String eventDateStr = (String) requestData.get("eventDate");

            // event_date 파싱
            java.sql.Date eventDate = null;
            if (eventDateStr != null && !eventDateStr.isEmpty()) {
                try {
                    eventDate = java.sql.Date.valueOf(eventDateStr);
                } catch (IllegalArgumentException e) {
                    logger.warn("잘못된 날짜 형식: {}", eventDateStr);
                    response.put("success", false);
                    response.put("message", "잘못된 날짜 형식입니다.");
                    return response;
                }
            }

            // 중복 체크: 같은 사용자, 같은 타입, 같은 이벤트 날짜, 같은 제목의 알림이 이미 존재하는지 확인
            if (eventDate != null && notificationDao != null) {
                boolean exists = notificationDao.existsByUserAndEventDate(userId, type, eventDate, title);
                if (exists) {
                    logger.info("중복 알림 방지 - userId: {}, type: {}, eventDate: {}, title: {}",
                               new Object[]{userId, type, eventDate, title});
                    response.put("success", true);
                    response.put("message", "이미 동일한 알림이 존재합니다.");
                    response.put("duplicate", true);
                    return response;
                }
            }

            Notification notification = new Notification();
            notification.setUserId(userId);
            notification.setType(type);
            notification.setTitle(title);
            notification.setContent(content);
            notification.setRelatedId(relatedId);
            notification.setRelatedUrl("/bdproject/project_mypage.jsp");
            notification.setEventDate(eventDate);

            Long notificationId = notificationService.createNotification(notification);

            if (notificationId != null) {
                response.put("success", true);
                response.put("message", "캘린더 알림이 생성되었습니다.");
                response.put("notificationId", notificationId);
                logger.info("캘린더 알림 생성 성공 - userId: {}, eventDate: {}", userId, eventDateStr);
            } else {
                response.put("success", false);
                response.put("message", "알림 생성에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("캘린더 알림 생성 중 오류", e);
            response.put("success", false);
            response.put("message", "알림 생성 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 알림 설정 조회
     * @GetMapping("/api/notifications/settings")
     */
    @GetMapping("/settings")
    public Map<String, Object> getNotificationSettings(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");

            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            // member_id 조회
            com.greenart.bdproject.dto.Member member = memberDao.select(userId);
            if (member == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            Long memberId = member.getMemberId();

            // 알림 설정 조회
            NotificationSettings settings = null;
            if (notificationSettingsDao != null) {
                settings = notificationSettingsDao.selectByMemberId(memberId);
            }

            // 설정이 없으면 기본값 생성
            if (settings == null) {
                settings = new NotificationSettings();
                settings.setMemberId(memberId);

                // DB에 저장
                if (notificationSettingsDao != null) {
                    notificationSettingsDao.insert(settings);
                }
            }

            response.put("success", true);
            response.put("data", settings);
            logger.info("알림 설정 조회 성공 - userId: {}, memberId: {}", userId, memberId);

        } catch (Exception e) {
            logger.error("알림 설정 조회 중 오류", e);
            response.put("success", false);
            response.put("message", "알림 설정 조회 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 알림 설정 저장/수정
     * @PostMapping("/api/notifications/settings")
     */
    @PostMapping("/settings")
    public Map<String, Object> saveNotificationSettings(
            @RequestBody NotificationSettings settings,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");

            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            // member_id 조회
            com.greenart.bdproject.dto.Member member = memberDao.select(userId);
            if (member == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            Long memberId = member.getMemberId();
            settings.setMemberId(memberId);

            // 기존 설정 조회 (변경 전 설정)
            NotificationSettings oldSettings = null;
            if (notificationSettingsDao != null) {
                oldSettings = notificationSettingsDao.selectByMemberId(memberId);
            }

            // UPSERT (없으면 INSERT, 있으면 UPDATE)
            if (notificationSettingsDao != null) {
                int result = notificationSettingsDao.upsert(settings);

                if (result > 0) {
                    // 알림 설정이 OFF로 변경된 타입의 기존 알림 삭제
                    deleteNotificationsForDisabledTypes(userId, oldSettings, settings);

                    response.put("success", true);
                    response.put("message", "알림 설정이 저장되었습니다.");
                    logger.info("알림 설정 저장 성공 - userId: {}, memberId: {}", userId, memberId);
                } else {
                    response.put("success", false);
                    response.put("message", "알림 설정 저장에 실패했습니다.");
                }
            } else {
                response.put("success", false);
                response.put("message", "알림 설정 기능을 사용할 수 없습니다.");
            }

        } catch (Exception e) {
            logger.error("알림 설정 저장 중 오류", e);
            response.put("success", false);
            response.put("message", "알림 설정 저장 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 알림 설정이 OFF로 변경된 타입의 기존 알림 삭제
     * @param userId 사용자 ID
     * @param oldSettings 변경 전 설정
     * @param newSettings 변경 후 설정
     */
    private void deleteNotificationsForDisabledTypes(String userId, NotificationSettings oldSettings, NotificationSettings newSettings) {
        if (notificationDao == null) {
            return;
        }

        java.util.List<String> typesToDelete = new java.util.ArrayList<>();

        // 일정 알림이 ON -> OFF로 변경된 경우
        boolean oldEventEnabled = (oldSettings == null || Boolean.TRUE.equals(oldSettings.getEventNotification()));
        boolean newEventDisabled = !Boolean.TRUE.equals(newSettings.getEventNotification());
        if (oldEventEnabled && newEventDisabled) {
            typesToDelete.add("CALENDAR_EVENT");
            typesToDelete.add("event");
            typesToDelete.add("calendar");
            typesToDelete.add("schedule");
            logger.info("일정 알림 OFF - 기존 알림 삭제 예정");
        }

        // 기부 알림이 ON -> OFF로 변경된 경우
        boolean oldDonationEnabled = (oldSettings == null || Boolean.TRUE.equals(oldSettings.getDonationNotification()));
        boolean newDonationDisabled = !Boolean.TRUE.equals(newSettings.getDonationNotification());
        if (oldDonationEnabled && newDonationDisabled) {
            typesToDelete.add("DONATION_REMINDER");
            typesToDelete.add("DONATION");
            typesToDelete.add("donation");
            logger.info("기부 알림 OFF - 기존 알림 삭제 예정");
        }

        // 봉사 알림이 ON -> OFF로 변경된 경우
        boolean oldVolunteerEnabled = (oldSettings == null || Boolean.TRUE.equals(oldSettings.getVolunteerNotification()));
        boolean newVolunteerDisabled = !Boolean.TRUE.equals(newSettings.getVolunteerNotification());
        if (oldVolunteerEnabled && newVolunteerDisabled) {
            typesToDelete.add("VOLUNTEER");
            typesToDelete.add("VOLUNTEER_REMINDER");
            typesToDelete.add("volunteer");
            logger.info("봉사 알림 OFF - 기존 알림 삭제 예정");
        }

        // FAQ 알림이 ON -> OFF로 변경된 경우
        boolean oldFaqEnabled = (oldSettings == null || Boolean.TRUE.equals(oldSettings.getFaqAnswerNotification()));
        boolean newFaqDisabled = !Boolean.TRUE.equals(newSettings.getFaqAnswerNotification());
        if (oldFaqEnabled && newFaqDisabled) {
            typesToDelete.add("faq_answer");
            typesToDelete.add("FAQ_ANSWER");
            typesToDelete.add("faq");
            logger.info("FAQ 답변 알림 OFF - 기존 알림 삭제 예정");
        }

        // 삭제할 타입이 있으면 삭제 실행
        if (!typesToDelete.isEmpty()) {
            int deletedCount = notificationDao.deleteByUserIdAndTypes(userId, typesToDelete);
            logger.info("알림 설정 변경으로 {} 개의 기존 알림 삭제됨", deletedCount);
        }
    }
}
