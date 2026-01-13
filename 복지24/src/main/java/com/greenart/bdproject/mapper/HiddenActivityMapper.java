package com.greenart.bdproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface HiddenActivityMapper {

    int hideActivity(@Param("memberId") Long memberId,
                     @Param("activityType") String activityType,
                     @Param("activityId") Long activityId);

    int unhideActivity(@Param("memberId") Long memberId,
                       @Param("activityType") String activityType,
                       @Param("activityId") Long activityId);

    List<Long> getHiddenActivityIds(@Param("memberId") Long memberId,
                                    @Param("activityType") String activityType);

    int isHidden(@Param("memberId") Long memberId,
                 @Param("activityType") String activityType,
                 @Param("activityId") Long activityId);

    int deleteAllHidden(@Param("memberId") Long memberId);
}
