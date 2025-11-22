package com.greenart.bdproject.dao;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

	@Override
	public Member selectByUsername(String username) throws Exception {
		// id가 username 역할을 함
		return session.selectOne(namespace+"select", username);
	}

	@Override
	public BigDecimal getKindnessTemperature(String userId) throws Exception {
		return session.selectOne(namespace+"getKindnessTemperature", userId);
	}

	@Override
	public int updateKindnessTemperature(String userId, BigDecimal temperature) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", userId);
		params.put("temperature", temperature);
		return session.update(namespace+"updateKindnessTemperature", params);
	}

	@Override
	public int increaseKindnessTemperature(String userId, BigDecimal amount) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", userId);
		params.put("amount", amount);
		return session.update(namespace+"increaseKindnessTemperature", params);
	}

	@Override
	public Member findByNameAndEmail(String name, String email) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("name", name);
		params.put("email", email);
		return session.selectOne(namespace+"findByNameAndEmail", params);
	}

	@Override
	public Member findByNameAndPhone(String name, String phone) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("name", name);
		params.put("phone", phone);
		return session.selectOne(namespace+"findByNameAndPhone", params);
	}

	@Override
	public Member findByIdAndSecurityAnswer(String id, String securityAnswer) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("id", id);
		params.put("securityAnswer", securityAnswer);
		return session.selectOne(namespace+"findByIdAndSecurityAnswer", params);
	}

}
