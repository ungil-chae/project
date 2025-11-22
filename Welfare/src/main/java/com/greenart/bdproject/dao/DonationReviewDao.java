package com.greenart.bdproject.dao;

import java.util.List;
import com.greenart.bdproject.dto.DonationReviewDto;

public interface DonationReviewDao {

    /**
     * 후원 리뷰 등록
     * @param review 리뷰 정보
     * @return int 등록된 행 수
     */
    int insertReview(DonationReviewDto review);

    /**
     * ID로 리뷰 조회
     * @param reviewId 리뷰 ID
     * @return DonationReviewDto 리뷰 정보
     */
    DonationReviewDto selectById(Long reviewId);

    /**
     * 전체 리뷰 목록 조회
     * @return List<DonationReviewDto> 리뷰 목록
     */
    List<DonationReviewDto> selectAll();

    /**
     * 사용자별 리뷰 목록 조회
     * @param userId 사용자 ID
     * @return List<DonationReviewDto> 리뷰 목록
     */
    List<DonationReviewDto> selectByUserId(Long userId);

    /**
     * 총 리뷰 수 조회
     * @return int 리뷰 수
     */
    int countTotalReviews();

    /**
     * 평균 만족도 조회
     * @return Double 평균 평점
     */
    Double getAverageRating();
}
