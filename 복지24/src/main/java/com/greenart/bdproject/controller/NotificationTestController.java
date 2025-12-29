package com.greenart.bdproject.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.greenart.bdproject.service.NotificationService;

/**
 * 알림 기능 테스트 컨트롤러
 * 프로덕션에서는 이 컨트롤러를 삭제하거나 비활성화해야 합니다.
 */
@RestController
@RequestMapping("/api/notification/test")
public class NotificationTestController {

    private static final Logger logger = LoggerFactory.getLogger(NotificationTestController.class);

    @Autowired
    private NotificationService notificationService;

    /**
     * 현재 로그인한 사용자에 대해 알림을 즉시 생성
     * GET /api/notification/test/generate
     */
    @PostMapping("/generate")
    public Map<String, Object> generateNotifications(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            // 세션에서 사용자 ID 가져오기
            String userId = (String) session.getAttribute("id");
            if (userId == null) {
                userId = (String) session.getAttribute("userId");
            }

            logger.info("=== 알림 테스트: 수동 생성 요청 ===");
            logger.info("userId: {}", userId);

            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            // 알림 자동 생성 (스케줄러와 동일한 로직)
            int count = notificationService.generateAutoNotifications(userId);

            logger.info("=== 알림 생성 완료: {}개 ===", count);

            response.put("success", true);
            response.put("count", count);
            response.put("message", count > 0 ?
                String.format("%d개의 알림이 생성되었습니다.", count) :
                "생성된 알림이 없습니다. 오늘/내일 날짜의 정기 기부 또는 봉사 활동이 있는지 확인하세요.");

        } catch (Exception e) {
            logger.error("알림 생성 테스트 중 오류", e);
            response.put("success", false);
            response.put("message", "알림 생성 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }
}
