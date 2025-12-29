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
     * 사용자의 모든 알림 삭제
     * @param userId 사용자 ID
     * @return 성공 여부
     */
    boolean deleteAll(String userId);

    /**
     * 읽지 않은 알림 개수 조회
     * @param userId 사용자 ID
     * @return 읽지 않은 알림 개수
     */
    int countUnread(String userId);

    /**
     * 중복 알림 체크 (캘린더 일정 알림용)
     * @param userId 사용자 ID
     * @param type 알림 타입
     * @param eventDate 이벤트 날짜
     * @param title 알림 제목
     * @return 이미 존재하면 true, 없으면 false
     */
    boolean existsByUserAndEventDate(String userId, String type, java.sql.Date eventDate, String title);

    /**
     * 특정 타입의 알림 삭제
     * @param userId 사용자 ID
     * @param notificationTypes 삭제할 알림 타입 리스트
     * @return 삭제된 알림 개수
     */
    int deleteByUserIdAndTypes(String userId, java.util.List<String> notificationTypes);
}
