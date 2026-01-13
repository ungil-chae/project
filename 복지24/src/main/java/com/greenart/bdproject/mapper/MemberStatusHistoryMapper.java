package com.greenart.bdproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.greenart.bdproject.dto.MemberStatusHistoryDto;

@Mapper
public interface MemberStatusHistoryMapper {

    int insertHistory(MemberStatusHistoryDto history);

    List<MemberStatusHistoryDto> selectAllHistory();

    List<MemberStatusHistoryDto> selectHistoryByMemberId(@Param("memberId") Long memberId);

    List<MemberStatusHistoryDto> selectHistoryByAdminId(@Param("adminId") Long adminId);

    List<MemberStatusHistoryDto> selectHistoryByDateRange(@Param("startDate") String startDate,
                                                          @Param("endDate") String endDate);

    List<MemberStatusHistoryDto> selectHistoryByEmail(@Param("email") String email);
}
