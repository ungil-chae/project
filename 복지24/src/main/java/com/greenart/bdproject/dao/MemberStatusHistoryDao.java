package com.greenart.bdproject.dao;

import com.greenart.bdproject.dto.MemberStatusHistoryDto;
import java.util.List;

/**
 * 회원 상태 변경 이력 DAO 인터페이스
 */
public interface MemberStatusHistoryDao {

    /**
     * 회원 상태 변경 이력 저장
     * @param history 이력 정보
     * @return 저장된 행 수
     */
    int insertHistory(MemberStatusHistoryDto history);

    /**
     * 전체 회원 상태 변경 이력 조회 (회원 및 관리자 정보 포함)
     * @return 이력 목록
     */
    List<MemberStatusHistoryDto> selectAllHistory();

    /**
     * 특정 회원의 상태 변경 이력 조회
     * @param memberId 회원 ID
     * @return 이력 목록
     */
    List<MemberStatusHistoryDto> selectHistoryByMemberId(Long memberId);

    /**
     * 특정 관리자가 처리한 상태 변경 이력 조회
     * @param adminId 관리자 ID
     * @return 이력 목록
     */
    List<MemberStatusHistoryDto> selectHistoryByAdminId(Long adminId);

    /**
     * 특정 기간의 상태 변경 이력 조회
     * @param startDate 시작일
     * @param endDate 종료일
     * @return 이력 목록
     */
    List<MemberStatusHistoryDto> selectHistoryByDateRange(String startDate, String endDate);

    /**
     * 이메일로 회원 상태 변경 이력 검색
     * @param email 회원 이메일
     * @return 이력 목록
     */
    List<MemberStatusHistoryDto> selectHistoryByEmail(String email);
}
