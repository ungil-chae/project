package com.greenart.bdproject.dao;

import java.util.List;

/**
 * 최근 활동 숨김 처리 DAO 인터페이스
 *
 * @author Claude Code
 * @version 1.0.0
 */
public interface HiddenActivityDao {

    /**
     * 활동 숨김 처리
     *
     * @param memberId 회원 ID
     * @param activityType 활동 유형 (VOLUNTEER, DONATION)
     * @param activityId 활동 ID
     * @return 영향받은 행 수
     */
    int hideActivity(Long memberId, String activityType, Long activityId);

    /**
     * 활동 숨김 해제
     *
     * @param memberId 회원 ID
     * @param activityType 활동 유형
     * @param activityId 활동 ID
     * @return 영향받은 행 수
     */
    int unhideActivity(Long memberId, String activityType, Long activityId);

    /**
     * 회원의 숨긴 활동 ID 목록 조회
     *
     * @param memberId 회원 ID
     * @param activityType 활동 유형
     * @return 숨긴 활동 ID 목록
     */
    List<Long> getHiddenActivityIds(Long memberId, String activityType);

    /**
     * 특정 활동이 숨김 처리되었는지 확인
     *
     * @param memberId 회원 ID
     * @param activityType 활동 유형
     * @param activityId 활동 ID
     * @return 숨김 여부
     */
    boolean isHidden(Long memberId, String activityType, Long activityId);

    /**
     * 회원의 모든 숨김 활동 삭제
     *
     * @param memberId 회원 ID
     * @return 삭제된 행 수
     */
    int deleteAllHidden(Long memberId);
}
