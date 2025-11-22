package com.greenart.bdproject.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.greenart.bdproject.dao.NotificationDao;
import com.greenart.bdproject.dto.Notification;

/**
 * 알림 서비스 구현체
 */
@Service
public class NotificationServiceImpl implements NotificationService {

    private static final Logger logger = LoggerFactory.getLogger(NotificationServiceImpl.class);

    @Autowired
    private NotificationDao notificationDao;

    @Override
    public Long createNotification(Notification notification) {
        return notificationDao.create(notification);
    }

    @Override
    public List<Notification> getNotificationsByUserId(String userId) {
        return notificationDao.findByUserId(userId);
    }

    @Override
    public boolean markNotificationAsRead(Long notificationId) {
        return notificationDao.markAsRead(notificationId);
    }

    @Override
    public boolean markAllNotificationsAsRead(String userId) {
        return notificationDao.markAllAsRead(userId);
    }

    @Override
    public boolean deleteNotification(Long notificationId) {
        return notificationDao.delete(notificationId);
    }

    @Override
    public int getUnreadCount(String userId) {
        return notificationDao.countUnread(userId);
    }

    @Override
    public Long createFaqAnswerNotification(String userId, Long questionId, String questionTitle) {
        if (userId == null || userId.isEmpty()) {
            logger.warn("FAQ 답변 알림 생성 실패 - userId가 없음");
            return null;
        }

        Notification notification = new Notification(
            userId,
            "faq_answer",
            "질문에 답변이 등록되었습니다",
            "'" + questionTitle + "' 질문에 관리자의 답변이 등록되었습니다.",
            questionId,
            "/bdproject/project_faq.jsp"
        );

        Long notificationId = notificationDao.create(notification);
        logger.info("FAQ 답변 알림 생성 완료 - userId: {}, questionId: {}", userId, questionId);
        logger.info("생성된 notificationId: {}", notificationId);

        return notificationId;
    }
}
