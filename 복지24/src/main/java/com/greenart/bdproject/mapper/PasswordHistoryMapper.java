package com.greenart.bdproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface PasswordHistoryMapper {

    int savePasswordHistory(@Param("memberId") Long memberId, @Param("passwordHash") String passwordHash);

    List<String> getRecentPasswordHashes(@Param("memberId") Long memberId);

    int existsInHistory(@Param("memberId") Long memberId, @Param("passwordHash") String passwordHash);

    int deleteOldHistory(@Param("memberId") Long memberId);
}
