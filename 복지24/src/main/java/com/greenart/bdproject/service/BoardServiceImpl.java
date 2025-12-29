package com.greenart.bdproject.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.greenart.bdproject.dao.BoardDao;
import com.greenart.bdproject.dto.BoardDto;

@Service
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	BoardDao dao;
	
	@Override
	public int getCount() throws Exception{
		return dao.count();
	}
	
	@Override
	public int remove(Integer bno, String writer) throws Exception{
		return dao.delete(bno, writer);
	}
	
	@Override
	public int write(BoardDto dto) throws Exception{
		return dao.insert(dto);
	}
	
	@Override
	public List<BoardDto> getList() throws Exception{
		return dao.selectAll();
	}
	
	// 게시판읽기 => 조회수1증가 + 게시판 조회
	@Override
	public BoardDto read(Integer bno) throws Exception{
		int res = dao.updateViewCnt(bno);
		if(res == 1) {
			return dao.select(bno);
		}
		return null;
	}
	
	@Override
	public List<BoardDto> getPage(Integer offset, Integer pageSize) throws Exception{
		return dao.selectPage(offset, pageSize);
	}
	
	@Override
	public int modify(BoardDto dto) throws Exception{
		return dao.update(dto);
	}
}
