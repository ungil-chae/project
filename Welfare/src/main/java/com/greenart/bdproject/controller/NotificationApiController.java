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
import com.greenart.bdproject.service.NotificationService;

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
}
