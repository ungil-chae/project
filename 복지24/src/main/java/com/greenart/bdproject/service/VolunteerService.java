package com.greenart.bdproject.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.greenart.bdproject.mapper.VolunteerApplicationMapper;
import com.greenart.bdproject.mapper.VolunteerReviewMapper;
import com.greenart.bdproject.dto.VolunteerApplicationDto;
import com.greenart.bdproject.dto.VolunteerReviewDto;

@Service
@Transactional
public class VolunteerService {

    @Autowired
    private VolunteerApplicationMapper volunteerApplicationMapper;

    @Autowired
    private VolunteerReviewMapper volunteerReviewMapper;

    /**
     * 봉사 신청
     * @param application 봉사 신청 정보
     * @return 등록된 신청 정보
     */
    public VolunteerApplicationDto applyVolunteer(VolunteerApplicationDto application) {
        int result = volunteerApplicationMapper.insert(application);

        if (result > 0) {
            return volunteerApplicationMapper.selectById(application.getApplicationId().intValue());
        }

        return null;
    }

    /**
     * 사용자별 봉사 신청 내역 조회
     * @param userId 사용자 ID (member.id)
     * @return 봉사 신청 내역 리스트
     */
    public List<VolunteerApplicationDto> getUserApplications(int userId) {
        return volunteerApplicationMapper.selectByUserId(userId);
    }

    /**
     * 전체 봉사 신청 내역 조회
     * @return 전체 봉사 신청 내역 리스트
     */
    public List<VolunteerApplicationDto> getAllApplications() {
        return volunteerApplicationMapper.selectAll();
    }

    /**
     * 봉사 신청 상태 변경
     * @param applicationId 신청 ID
     * @param status 변경할 상태
     * @return 성공 여부
     */
    public boolean updateApplicationStatus(Long applicationId, String status) {
        int result = volunteerApplicationMapper.updateStatus(applicationId, status);
        return result > 0;
    }

    /**
     * 봉사 후기 등록 (캐시 무효화)
     * @param review 후기 정보
     * @return 등록된 후기 정보
     */
    @CacheEvict(value = "volunteerReviews", allEntries = true)
    public VolunteerReviewDto createReview(VolunteerReviewDto review) {
        int result = volunteerReviewMapper.insert(review);

        if (result > 0) {
            return volunteerReviewMapper.selectById(review.getReviewId());
        }

        return null;
    }

    /**
     * 전체 봉사 후기 조회 (캐시 적용)
     * @return 전체 후기 리스트
     */
    @Cacheable(value = "volunteerReviews")
    public List<VolunteerReviewDto> getAllReviews() {
        return volunteerReviewMapper.selectAll();
    }

    /**
     * 사용자별 봉사 후기 조회
     * @param userId 사용자 ID (member.id)
     * @return 사용자 후기 리스트
     */
    public List<VolunteerReviewDto> getUserReviews(String userId) {
        return volunteerReviewMapper.selectByUserId(userId);
    }

    /**
     * 봉사 신청별 후기 존재 여부 확인
     * @param applicationId 봉사 신청 ID
     * @return 후기가 있으면 true, 없으면 false
     */
    public boolean hasReview(Long applicationId) {
        int count = volunteerReviewMapper.countByApplicationId(applicationId);
        return count > 0;
    }
}
