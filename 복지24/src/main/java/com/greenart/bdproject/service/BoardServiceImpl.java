package com.greenart.bdproject.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.greenart.bdproject.mapper.BoardMapper;
import com.greenart.bdproject.dto.BoardDto;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	BoardMapper mapper;

	@Override
	public int getCount() throws Exception{
		return mapper.count();
	}

	@Override
	public int remove(Integer bno, String writer) throws Exception{
		return mapper.delete(writer, bno);
	}

	@Override
	public int write(BoardDto dto) throws Exception{
		return mapper.insert(dto);
	}

	@Override
	public List<BoardDto> getList() throws Exception{
		return mapper.selectAll();
	}

	// 게시글읽기 => 조회수1증가 + 게시글 조회
	@Override
	public BoardDto read(Integer bno) throws Exception{
		int res = mapper.updateViewCnt(bno);
		if(res == 1) {
			return mapper.select(bno);
		}
		return null;
	}

	@Override
	public List<BoardDto> getPage(Integer offset, Integer pageSize) throws Exception{
		return mapper.selectPage(offset, pageSize);
	}

	@Override
	public int modify(BoardDto dto) throws Exception{
		return mapper.update(dto);
	}
}
