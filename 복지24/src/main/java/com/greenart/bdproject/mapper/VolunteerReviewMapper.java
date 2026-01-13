package com.greenart.bdproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.greenart.bdproject.dto.VolunteerReviewDto;

@Mapper
public interface VolunteerReviewMapper {

    int insert(VolunteerReviewDto review);

    VolunteerReviewDto selectById(@Param("reviewId") Long reviewId);

    List<VolunteerReviewDto> selectAll();

    List<VolunteerReviewDto> selectByUserId(@Param("userId") String userId);

    int countByApplicationId(@Param("applicationId") Long applicationId);
}
