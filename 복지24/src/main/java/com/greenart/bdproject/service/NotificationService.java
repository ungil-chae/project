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
     * 사용자의 모든 알림 삭제
     * @param userId 사용자 ID
     * @return 성공 여부
     */
    boolean deleteAllNotifications(String userId);

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

    /**
     * 자동 알림 생성 (정기 기부, 봉사, 캘린더 일정)
     * @param userId 사용자 ID
     * @return 생성된 알림 개수
     */
    int generateAutoNotifications(String userId);

    /**
     * 봉사활동 알림 생성 (하루 전 + 당일)
     * @param userId 사용자 ID (이메일)
     * @param applicationId 봉사 신청 ID
     * @param volunteerDate 봉사 날짜
     * @param category 봉사 카테고리
     * @return 생성된 알림 개수
     */
    int createVolunteerNotifications(String userId, Long applicationId, java.sql.Date volunteerDate, String category);

    /**
     * 봉사활동 승인 알림 생성
     * @param userId 사용자 ID (이메일)
     * @param applicationId 봉사 신청 ID
     * @param facilityName 배정된 시설명
     * @param volunteerDate 봉사 날짜
     * @return 생성된 알림 ID
     */
    Long createVolunteerApprovalNotification(String userId, Long applicationId, String facilityName, String volunteerDate);
}
