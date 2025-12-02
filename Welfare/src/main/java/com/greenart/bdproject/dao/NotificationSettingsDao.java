package com.greenart.bdproject.dao;

import com.greenart.bdproject.dto.NotificationSettings;

/**
 * 알림 설정 DAO 인터페이스
 */
public interface NotificationSettingsDao {

    /**
     * 회원의 알림 설정 조회
     * @param memberId 회원 ID
     * @return 알림 설정 (없으면 null)
     */
    NotificationSettings selectByMemberId(Long memberId);

    /**
     * 알림 설정 저장 (INSERT)
     * @param settings 알림 설정
     * @return 생성된 설정 ID
     */
    Long insert(NotificationSettings settings);

    /**
     * 알림 설정 수정 (UPDATE)
     * @param settings 알림 설정
     * @return 수정된 행 수
     */
    int update(NotificationSettings settings);

    /**
     * 알림 설정 저장 또는 수정 (UPSERT)
     * @param settings 알림 설정
     * @return 영향받은 행 수
     */
    int upsert(NotificationSettings settings);

    /**
     * 알림 설정 삭제
     * @param memberId 회원 ID
     * @return 삭제된 행 수
     */
    int delete(Long memberId);
}
