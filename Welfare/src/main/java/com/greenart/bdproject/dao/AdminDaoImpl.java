package com.greenart.bdproject.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AdminDaoImpl implements AdminDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.greenart.bdproject.mapper.AdminMapper";

    @Override
    public int getTotalMembers() {
        return sqlSession.selectOne(NAMESPACE + ".getTotalMembers");
    }

    @Override
    public Long getTotalDonations() {
        return sqlSession.selectOne(NAMESPACE + ".getTotalDonations");
    }

    @Override
    public int getTotalVolunteers() {
        return sqlSession.selectOne(NAMESPACE + ".getTotalVolunteers");
    }

    @Override
    public int getTotalDiagnoses() {
        return sqlSession.selectOne(NAMESPACE + ".getTotalDiagnoses");
    }

    @Override
    public List<Map<String, Object>> getAllMembers() {
        return sqlSession.selectList(NAMESPACE + ".getAllMembers");
    }

    @Override
    public List<Map<String, Object>> getAllNotices() {
        return sqlSession.selectList(NAMESPACE + ".getAllNotices");
    }

    @Override
    public List<Map<String, Object>> getAllFaqs() {
        return sqlSession.selectList(NAMESPACE + ".getAllFaqs");
    }

    @Override
    public List<Map<String, Object>> getAllDonations() {
        return sqlSession.selectList(NAMESPACE + ".getAllDonations");
    }

    @Override
    public List<Map<String, Object>> getAllVolunteers() {
        return sqlSession.selectList(NAMESPACE + ".getAllVolunteers");
    }

    @Override
    public boolean updateMember(String userId, String name, String email, String phone) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("name", name);
        params.put("email", email);
        params.put("phone", phone);
        int result = sqlSession.update(NAMESPACE + ".updateMember", params);
        return result > 0;
    }

    @Override
    public boolean deleteMember(String userId) {
        int result = sqlSession.delete(NAMESPACE + ".deleteMember", userId);
        return result > 0;
    }

    @Override
    public boolean suspendMember(String userId) {
        int result = sqlSession.update(NAMESPACE + ".suspendMember", userId);
        return result > 0;
    }

    @Override
    public boolean activateMember(String userId) {
        int result = sqlSession.update(NAMESPACE + ".activateMember", userId);
        return result > 0;
    }

    @Override
    public Map<String, Object> getMemberStatus(Long memberId) {
        return sqlSession.selectOne(NAMESPACE + ".getMemberStatus", memberId);
    }

    @Override
    public Map<String, Object> getMemberStatusByUserId(String userId) {
        return sqlSession.selectOne(NAMESPACE + ".getMemberStatusByUserId", userId);
    }
}
