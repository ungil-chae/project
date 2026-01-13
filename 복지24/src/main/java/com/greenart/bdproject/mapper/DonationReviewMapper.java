package com.greenart.bdproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.greenart.bdproject.dto.DonationReviewDto;

@Mapper
public interface DonationReviewMapper {

    int insertReview(DonationReviewDto review);

    DonationReviewDto selectById(@Param("reviewId") Long reviewId);

    List<DonationReviewDto> selectAll();

    List<DonationReviewDto> selectByUserId(@Param("userId") Long userId);

    int countTotalReviews();

    double getAverageRating();
}
