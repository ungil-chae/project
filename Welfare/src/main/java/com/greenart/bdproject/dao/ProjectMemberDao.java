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

	// 로그인 실패 횟수 증가 및 계정 잠금
	public int incrementLoginFailCount(String email);

	// 로그인 성공 시 실패 횟수 초기화
	public int resetLoginFailCount(String email);

	// 계정 잠금 설정 (5분)
	public int lockAccount(String email, int minutes);

	// 프로필 이미지 업데이트
	public int updateProfileImage(String email, String imageUrl);
}