package com.greenart.bdproject.service;

import java.util.List;

import com.greenart.bdproject.dto.BoardDto;

public interface BoardService {

	int getCount() throws Exception;

	int remove(Integer bno, String writer) throws Exception;

	int write(BoardDto dto) throws Exception;

	List<BoardDto> getList() throws Exception;

	// 게시판읽기 => 조회수1증가 + 게시판 조회
	BoardDto read(Integer bno) throws Exception;

	List<BoardDto> getPage(Integer offset, Integer pageSize) throws Exception;

	int modify(BoardDto dto) throws Exception;

}