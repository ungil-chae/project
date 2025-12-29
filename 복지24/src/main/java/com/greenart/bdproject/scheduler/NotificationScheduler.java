package com.greenart.bdproject.scheduler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.greenart.bdproject.dao.ProjectMemberDao;
import com.greenart.bdproject.dto.Member;
import com.greenart.bdproject.service.NotificationService;

import java.util.List;

/**
 * 알림 자동 생성 스케줄러
 * 매일 오전 9시에 모든 회원의 알림을 생성합니다.
 */
@Component
public class NotificationScheduler {

    private static final Logger logger = LoggerFactory.getLogger(NotificationScheduler.class);

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private ProjectMemberDao memberDao;

    /**
     * 매일 오전 9시에 실행
     * cron: 초 분 시 일 월 요일
     * "0 0 9 * * *" = 매일 오전 9시 0분 0초
     */
    @Scheduled(cron = "0 0 9 * * *")
    public void generateDailyNotifications() {
        logger.info("========================================");
        logger.info("일일 알림 자동 생성 스케줄러 시작");
        logger.info("========================================");

        try {
            // 모든 활성 회원 조회
            List<Member> members = memberDao.selectList();
            logger.info("대상 회원 수: {}", members != null ? members.size() : 0);

            if (members == null || members.isEmpty()) {
                logger.warn("활성 회원이 없습니다.");
                return;
            }

            int totalNotifications = 0;
            int processedMembers = 0;

            // 각 회원에 대해 알림 생성
            for (Member member : members) {
                try {
                    // 탈퇴한 회원은 스킵
                    if (member.getDeletedAt() != null) {
                        continue;
                    }

                    String userId = member.getEmail();
                    logger.info("회원 {} 알림 생성 중...", userId);

                    int count = notificationService.generateAutoNotifications(userId);
                    totalNotifications += count;
                    processedMembers++;

                    if (count > 0) {
                        logger.info("회원 {} - {}개 알림 생성", userId, count);
                    }

                } catch (Exception e) {
                    logger.error("회원 {} 알림 생성 중 오류", member.getEmail(), e);
                }
            }

            logger.info("========================================");
            logger.info("일일 알림 생성 완료 - 처리 회원: {}, 생성 알림: {}", processedMembers, totalNotifications);
            logger.info("========================================");

        } catch (Exception e) {
            logger.error("일일 알림 생성 스케줄러 실행 중 오류", e);
        }
    }

    /**
     * 테스트용: 매분마다 실행 (개발 및 테스트 목적)
     * 실제 배포 시에는 주석 처리하거나 삭제하세요.
     */
    // @Scheduled(cron = "0 * * * * *")
    public void generateNotificationsEveryMinute() {
        logger.info("========================================");
        logger.info("[테스트] 알림 자동 생성 (매분 실행)");
        logger.info("========================================");

        try {
            List<Member> members = memberDao.selectList();

            if (members == null || members.isEmpty()) {
                logger.warn("활성 회원이 없습니다.");
                return;
            }

            int totalNotifications = 0;

            for (Member member : members) {
                if (member.getDeletedAt() != null) {
                    continue;
                }

                String userId = member.getEmail();
                int count = notificationService.generateAutoNotifications(userId);
                totalNotifications += count;

                if (count > 0) {
                    logger.info("[테스트] 회원 {} - {}개 알림 생성", userId, count);
                }
            }

            logger.info("[테스트] 총 {}개 알림 생성 완료", totalNotifications);

        } catch (Exception e) {
            logger.error("[테스트] 알림 생성 중 오류", e);
        }
    }
}
