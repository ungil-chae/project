package com.greenart.bdproject.dao;

import java.util.List;

/**
 * 비밀번호 변경 이력 DAO 인터페이스
 * - 이전 비밀번호 재사용 방지를 위한 이력 관리
 */
public interface PasswordHistoryDao {

    /**
     * 비밀번호 이력 저장
     * @param memberId 회원 ID
     * @param passwordHash 비밀번호 해시
     * @return 저장 결과
     */
    int savePasswordHistory(Long memberId, String passwordHash);

    /**
     * 회원의 최근 비밀번호 이력 조회 (최근 5개)
     * @param memberId 회원 ID
     * @return 비밀번호 해시 목록
     */
    List<String> getRecentPasswordHashes(Long memberId);

    /**
     * 특정 비밀번호가 이력에 존재하는지 확인
     * @param memberId 회원 ID
     * @param passwordHash 확인할 비밀번호 해시
     * @return 존재 여부
     */
    boolean existsInHistory(Long memberId, String passwordHash);

    /**
     * 오래된 비밀번호 이력 삭제 (최근 5개만 유지)
     * @param memberId 회원 ID
     * @return 삭제된 행 수
     */
    int deleteOldHistory(Long memberId);
}
