package com.greenart.bdproject.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.greenart.bdproject.BoardDto;

@Repository
public class BoardDaoOmpl implements BoardDao {
	 @Autowired
	 SqlSession session;
	 String namespace = "com.greenart.board.";
	 
	 @Override
	public BoardDto select(int bno) {
		 return session.selectOne(namespace+"select", bno);
	 }
	 @Override
	public List<BoardDto> selectAll() throws Exception {
		 return session.selectList(namespace+"selectALL");
	 }
	 @Override
	public int insert(BoardDto dto) throws Exception{
		 return session.insert(namespace+"insert", dto);
	 }
	 @Override
	public int update(BoardDto dto) throws Exception{
		 return session.update(namespace + "update", dto);
	 }
	 
	 @Override
	public int delete(int bno, String writer) throws Exception{
	 Map map = new HashMap<String, Object>();
	 map.put("bno", bno);
	 map.put("writer", writer);
	 return session.delete(namespace+"delete", map);
}
	 @Override
	public int updateViewCnt(int bno) throws Exception{
		 return session.update(namespace+"updateViewCnt", bno);
	 }
	 @Override
	public int deleteAll() throws Exception{
		 return session.delete(namespace+"deleteALL");
	 }
	 @Override
		public int count() throws Exception{
			return session.selectOne(namespace+"count");
		}
}
