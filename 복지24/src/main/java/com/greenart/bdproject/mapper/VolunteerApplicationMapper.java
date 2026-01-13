package com.greenart.bdproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.greenart.bdproject.dto.VolunteerApplicationDto;

@Mapper
public interface VolunteerApplicationMapper {

    int insert(VolunteerApplicationDto application);

    VolunteerApplicationDto selectById(@Param("applicationId") int applicationId);

    List<VolunteerApplicationDto> selectByUserId(@Param("userId") int userId);

    List<VolunteerApplicationDto> selectAll();

    int updateStatus(@Param("applicationId") Long applicationId, @Param("status") String status);
}
