package com.greenart.bdproject.dao;

import java.util.List;
import com.greenart.bdproject.dto.VolunteerReviewDto;

public interface VolunteerReviewDao {

    /**
     * 봉사 후기 등록
     * @param review 후기 정보
     * @return int 등록된 행 수
     */
    int insertReview(VolunteerReviewDto review);

    /**
     * ID로 후기 조회
     * @param reviewId 후기 ID
     * @return VolunteerReviewDto 후기 정보
     */
    VolunteerReviewDto selectById(Long reviewId);

    /**
     * 전체 후기 목록 조회 (최신순, member와 조인하여 userName 포함)
     * @return List<VolunteerReviewDto> 후기 목록
     */
    List<VolunteerReviewDto> selectAll();

    /**
     * 사용자별 후기 목록 조회
     * @param userId 사용자 ID (member.id)
     * @return List<VolunteerReviewDto> 후기 목록
     */
    List<VolunteerReviewDto> selectByUserId(String userId);

    /**
     * 봉사 신청별 후기 존재 여부 확인
     * @param applicationId 봉사 신청 ID
     * @return int 후기 개수
     */
    int countByApplicationId(Long applicationId);
}
