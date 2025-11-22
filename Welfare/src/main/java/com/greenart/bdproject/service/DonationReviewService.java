package com.greenart.bdproject.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.greenart.bdproject.dao.DonationDao;
import com.greenart.bdproject.dao.DonationReviewDao;
import com.greenart.bdproject.dto.DonationReviewDto;

@Service
@Transactional
public class DonationReviewService {

    @Autowired
    private DonationReviewDao donationReviewDao;

    @Autowired
    private DonationDao donationDao;

    /**
     * 후원자 리뷰 등록
     * @param review 리뷰 정보
     * @return 등록된 리뷰 정보
     */
    public DonationReviewDto createReview(DonationReviewDto review) {
        int result = donationReviewDao.insertReview(review);

        if (result > 0) {
            return donationReviewDao.selectById(review.getReviewId());
        }

        return null;
    }

    /**
     * 전체 리뷰 조회
     * @return 전체 리뷰 리스트
     */
    public List<DonationReviewDto> getAllReviews() {
        return donationReviewDao.selectAll();
    }

    /**
     * 사용자별 리뷰 조회
     * @param userId 사용자 ID
     * @return 사용자 리뷰 리스트
     */
    public List<DonationReviewDto> getUserReviews(Long userId) {
        return donationReviewDao.selectByUserId(userId);
    }

    /**
     * 리뷰 통계 조회
     * @return 리뷰 통계 정보 (리뷰 수, 평균 만족도, 총 후원자 수, 누적 지원금)
     */
    public Map<String, Object> getReviewStatistics() {
        Map<String, Object> statistics = new HashMap<>();

        // 리뷰 수
        Integer reviewCount = donationReviewDao.countTotalReviews();
        statistics.put("totalReviews", reviewCount != null ? reviewCount : 0);

        // 평균 만족도
        Double avgRating = donationReviewDao.getAverageRating();
        statistics.put("averageRating", avgRating != null ? avgRating : 0.0);

        // 총 후원자 수
        Integer donorCount = donationDao.countTotalDonors();
        statistics.put("totalDonors", donorCount != null ? donorCount : 0);

        // 누적 지원금
        Double totalAmount = donationDao.getTotalDonationAmount();
        statistics.put("totalAmount", totalAmount != null ? totalAmount : 0.0);

        return statistics;
    }

    /**
     * 고유한 기부 카테고리 목록 조회
     * @return 카테고리 리스트
     */
    public List<String> getDistinctCategories() {
        List<DonationReviewDto> allReviews = donationReviewDao.selectAll();
        return allReviews.stream()
                .map(DonationReviewDto::getCategory)
                .filter(category -> category != null && !category.trim().isEmpty())
                .distinct()
                .sorted()
                .collect(java.util.stream.Collectors.toList());
    }
}
