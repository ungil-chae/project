package com.greenart.bdproject.dao;

import java.util.List;
import com.greenart.bdproject.dto.VolunteerApplicationDto;

public interface VolunteerApplicationDao {

    /**
     * 봉사 신청 등록
     * @param application 신청 정보
     * @return int 등록된 행 수
     */
    int insertApplication(VolunteerApplicationDto application);

    /**
     * ID로 봉사 신청 조회
     * @param applicationId 신청 ID
     * @return VolunteerApplicationDto 신청 정보
     */
    VolunteerApplicationDto selectById(Long applicationId);

    /**
     * 사용자별 봉사 신청 내역 조회
     * @param userId 사용자 ID (member.id)
     * @return List<VolunteerApplicationDto> 신청 목록
     */
    List<VolunteerApplicationDto> selectByUserId(String userId);

    /**
     * 전체 봉사 신청 목록 조회
     * @return List<VolunteerApplicationDto> 신청 목록
     */
    List<VolunteerApplicationDto> selectAll();

    /**
     * 봉사 신청 상태 업데이트
     * @param applicationId 신청 ID
     * @param status 상태 (승인, 대기, 거절 등)
     * @return int 수정된 행 수
     */
    int updateStatus(Long applicationId, String status);
}
