package com.greenart.bdproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.greenart.bdproject.dto.NoticeDto;

@Mapper
public interface NoticeMapper {

    int insert(NoticeDto notice);

    NoticeDto selectById(@Param("noticeId") int noticeId);

    List<NoticeDto> selectAll();

    List<NoticeDto> selectPinned();

    int update(NoticeDto notice);

    int deleteById(@Param("noticeId") int noticeId);

    int incrementViews(@Param("noticeId") int noticeId);
}
