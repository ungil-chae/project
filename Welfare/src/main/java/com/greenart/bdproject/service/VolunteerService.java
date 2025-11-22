package com.greenart.bdproject.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.greenart.bdproject.dao.VolunteerApplicationDao;
import com.greenart.bdproject.dao.VolunteerReviewDao;
import com.greenart.bdproject.dto.VolunteerApplicationDto;
import com.greenart.bdproject.dto.VolunteerReviewDto;

@Service
@Transactional
public class VolunteerService {

    @Autowired
    private VolunteerApplicationDao volunteerApplicationDao;

    @Autowired
    private VolunteerReviewDao volunteerReviewDao;

    /**
     * 봉사 신청
     * @param application 봉사 신청 정보
     * @return 등록된 신청 정보
     */
    public VolunteerApplicationDto applyVolunteer(VolunteerApplicationDto application) {
        int result = volunteerApplicationDao.insertApplication(application);

        if (result > 0) {
            return volunteerApplicationDao.selectById(application.getApplicationId());
        }

        return null;
    }

    /**
     * 사용자별 봉사 신청 내역 조회
     * @param userId 사용자 ID (member.id)
     * @return 봉사 신청 내역 리스트
     */
    public List<VolunteerApplicationDto> getUserApplications(String userId) {
        return volunteerApplicationDao.selectByUserId(userId);
    }

    /**
     * 전체 봉사 신청 내역 조회
     * @return 전체 봉사 신청 내역 리스트
     */
    public List<VolunteerApplicationDto> getAllApplications() {
        return volunteerApplicationDao.selectAll();
    }

    /**
     * 봉사 신청 상태 변경
     * @param applicationId 신청 ID
     * @param status 변경할 상태
     * @return 성공 여부
     */
    public boolean updateApplicationStatus(Long applicationId, String status) {
        int result = volunteerApplicationDao.updateStatus(applicationId, status);
        return result > 0;
    }

    /**
     * 봉사 후기 등록
     * @param review 후기 정보
     * @return 등록된 후기 정보
     */
    public VolunteerReviewDto createReview(VolunteerReviewDto review) {
        int result = volunteerReviewDao.insertReview(review);

        if (result > 0) {
            return volunteerReviewDao.selectById(review.getReviewId());
        }

        return null;
    }

    /**
     * 전체 봉사 후기 조회
     * @return 전체 후기 리스트
     */
    public List<VolunteerReviewDto> getAllReviews() {
        return volunteerReviewDao.selectAll();
    }

    /**
     * 사용자별 봉사 후기 조회
     * @param userId 사용자 ID (member.id)
     * @return 사용자 후기 리스트
     */
    public List<VolunteerReviewDto> getUserReviews(String userId) {
        return volunteerReviewDao.selectByUserId(userId);
    }

    /**
     * 봉사 신청별 후기 존재 여부 확인
     * @param applicationId 봉사 신청 ID
     * @return 후기가 있으면 true, 없으면 false
     */
    public boolean hasReview(Long applicationId) {
        int count = volunteerReviewDao.countByApplicationId(applicationId);
        return count > 0;
    }
}
