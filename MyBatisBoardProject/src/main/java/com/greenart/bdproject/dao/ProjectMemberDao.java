package com.greenart.bdproject.dao;

import java.util.List;

import com.greenart.bdproject.dto.Member;

public interface ProjectMemberDao {

	int insert(Member m);

	Member select(String id);

	int delete(String id);

	int update(Member m);
	
	public int deleteAll();
	
	public List<Member> selectList();
	
	// 이메일(아이디) 중복 확인을 위한 메서드 추가
	public int countByEmail(String email);
}