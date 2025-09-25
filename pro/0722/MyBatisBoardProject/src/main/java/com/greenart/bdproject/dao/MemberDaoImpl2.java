package com.greenart.bdproject.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.greenart.bdproject.dto.Member;
@Repository
public class MemberDaoImpl2 implements MemberDao {
	@Autowired
	SqlSession session;
	String namespace ="com.greenart.member.";
	
	@Override
	public int insert(Member m) throws Exception{
		return session.insert(namespace+"insert", m);
	}

	@Override
	public Member select(String id) throws Exception {
		return session.selectOne(namespace+"select", id);
	}

	@Override
	public int delete(String id) throws Exception{
		return session.delete(namespace+"delete", id);
	}

	@Override
	public int update(Member m) throws Exception{
		return session.update(namespace+"update", m);
	}

	@Override
	public int deleteAll() throws Exception {
		return session.delete(namespace+"deleteAll");

	}

	@Override
	public List<Member> selectList() throws Exception{
		return session.selectList(namespace+"selectAll");
	}

}
