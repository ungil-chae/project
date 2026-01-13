package com.greenart.bdproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.greenart.bdproject.dto.FavoriteWelfareServiceDto;

@Mapper
public interface FavoriteWelfareServiceMapper {

    int insert(FavoriteWelfareServiceDto favoriteService);

    int delete(@Param("memberId") Long memberId, @Param("serviceId") String serviceId);

    List<FavoriteWelfareServiceDto> selectByMemberId(@Param("memberId") Long memberId);

    boolean exists(@Param("memberId") Long memberId, @Param("serviceId") String serviceId);

    int countByMemberId(@Param("memberId") Long memberId);
}
