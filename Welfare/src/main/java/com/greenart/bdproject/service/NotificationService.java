package com.greenart.bdproject.service;

import java.util.List;
import com.greenart.bdproject.dto.Notification;

/**
 * 알림 서비스 인터페이스
 */
public interface NotificationService {

    /**
     * 알림 생성
     * @param notification 알림 객체
     * @return 생성된 알림 ID
     */
    Long createNotification(Notification notification);

    /**
     * 사용자의 알림 목록 조회
     * @param userId 사용자 ID
     * @return 알림 목록
     */
    List<Notification> getNotificationsByUserId(String userId);

    /**
     * 알림 읽음 처리
     * @param notificationId 알림 ID
     * @return 성공 여부
     */
    boolean markNotificationAsRead(Long notificationId);

    /**
     * 사용자의 모든 알림 읽음 처리
     * @param userId 사용자 ID
     * @return 성공 여부
     */
    boolean markAllNotificationsAsRead(String userId);

    /**
     * 알림 삭제
     * @param notificationId 알림 ID
     * @return 성공 여부
     */
    boolean deleteNotification(Long notificationId);

    /**
     * 읽지 않은 알림 개수 조회
     * @param userId 사용자 ID
     * @return 읽지 않은 알림 개수
     */
    int getUnreadCount(String userId);

    /**
     * FAQ 답변 알림 생성
     * @param userId 질문 작성자 ID
     * @param questionId 질문 ID
     * @param questionTitle 질문 제목
     * @return 생성된 알림 ID
     */
    Long createFaqAnswerNotification(String userId, Long questionId, String questionTitle);
}
