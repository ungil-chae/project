package com.greenart.bdproject.dao;

import java.util.List;

import com.greenart.bdproject.BoardDto;

public interface BoardDao {

	BoardDto select(int bno);

	List<BoardDto> selectAll() throws Exception;

	int insert(BoardDto dto) throws Exception;

	int update(BoardDto dto) throws Exception;

	int delete(int bno, String writer) throws Exception;

	int updateViewCnt(int bno) throws Exception;

	int deleteAll() throws Exception;
	
	int count() throws Exception;

}