package com.greenart.bdproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.greenart.bdproject.dto.BoardDto;

@Mapper
public interface BoardMapper {

    BoardDto select(@Param("bno") int bno);

    List<BoardDto> selectPage(@Param("offset") int offset, @Param("pageSize") int pageSize);

    List<BoardDto> selectAll();

    int insert(BoardDto board);

    int update(BoardDto board);

    int delete(@Param("writer") String writer, @Param("bno") int bno);

    int updateViewCnt(@Param("bno") int bno);

    int deleteAll();

    int count();
}
