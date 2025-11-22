package com.greenart.bdproject.dao;

import java.util.List;
import com.greenart.bdproject.dto.Notification;

/**
 * 알림 DAO 인터페이스
 */
public interface NotificationDao {

    /**
     * 알림 생성
     * @param notification 알림 객체
     * @return 생성된 알림 ID
     */
    Long create(Notification notification);

    /**
     * 사용자의 알림 목록 조회
     * @param userId 사용자 ID
     * @return 알림 목록
     */
    List<Notification> findByUserId(String userId);

    /**
     * 알림 읽음 처리
     * @param notificationId 알림 ID
     * @return 성공 여부
     */
    boolean markAsRead(Long notificationId);

    /**
     * 사용자의 모든 알림 읽음 처리
     * @param userId 사용자 ID
     * @return 성공 여부
     */
    boolean markAllAsRead(String userId);

    /**
     * 알림 삭제
     * @param notificationId 알림 ID
     * @return 성공 여부
     */
    boolean delete(Long notificationId);

    /**
     * 읽지 않은 알림 개수 조회
     * @param userId 사용자 ID
     * @return 읽지 않은 알림 개수
     */
    int countUnread(String userId);
}
