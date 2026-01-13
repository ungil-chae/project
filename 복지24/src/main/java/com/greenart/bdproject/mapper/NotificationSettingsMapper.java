package com.greenart.bdproject.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.greenart.bdproject.dto.NotificationSettings;

@Mapper
public interface NotificationSettingsMapper {

    NotificationSettings selectByMemberId(@Param("memberId") Long memberId);

    int insert(NotificationSettings settings);

    int update(NotificationSettings settings);

    int upsert(NotificationSettings settings);

    int delete(@Param("memberId") Long memberId);
}
