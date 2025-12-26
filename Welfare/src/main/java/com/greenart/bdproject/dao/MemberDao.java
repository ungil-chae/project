package com.greenart.bdproject.dao;

import java.math.BigDecimal;
import java.util.List;

import com.greenart.bdproject.dto.Member;

public interface MemberDao {



int insert(Member m) throws Exception;



Member select(String id) throws Exception;



int delete(String id) throws Exception;



int update(Member m)throws Exception;


public int deleteAll() throws Exception;


public List<Member> selectList() throws Exception;

/**
 * username으로 회원 조회 (id와 동일)
 * 새로 추가된 메서드
 */
Member selectByUsername(String username) throws Exception;

/**
 * 선행 온도 조회
 */
BigDecimal getKindnessTemperature(String userId) throws Exception;

/**
 * 선행 온도 업데이트 (절대값)
 */
int updateKindnessTemperature(String userId, BigDecimal temperature) throws Exception;

/**
 * 선행 온도 증가 (상대값)
 */
int increaseKindnessTemperature(String userId, BigDecimal amount) throws Exception;

/**
 * 선행 온도 감소 (상대값, 최소 0.00 보장)
 */
int decreaseKindnessTemperature(String userId, BigDecimal amount) throws Exception;

/**
 * 이름과 이메일로 회원 찾기 (아이디 찾기)
 */
Member findByNameAndEmail(String name, String email) throws Exception;

/**
 * 이름과 전화번호로 회원 찾기 (아이디 찾기)
 */
Member findByNameAndPhone(String name, String phone) throws Exception;

/**
 * 아이디와 보안 질문 답변으로 회원 확인 (비밀번호 찾기)
 */
Member findByIdAndSecurityAnswer(String id, String securityAnswer) throws Exception;

}