package com.greenart.bdproject.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * 비밀번호 변경 이력 DAO 구현체
 */
@Repository
public class PasswordHistoryDaoImpl implements PasswordHistoryDao {

    private static final String NAMESPACE = "PasswordHistoryMapper";

    @Autowired
    private SqlSession sqlSession;

    @Override
    public int savePasswordHistory(Long memberId, String passwordHash) {
        Map<String, Object> params = new HashMap<>();
        params.put("memberId", memberId);
        params.put("passwordHash", passwordHash);
        return sqlSession.insert(NAMESPACE + ".savePasswordHistory", params);
    }

    @Override
    public List<String> getRecentPasswordHashes(Long memberId) {
        return sqlSession.selectList(NAMESPACE + ".getRecentPasswordHashes", memberId);
    }

    @Override
    public boolean existsInHistory(Long memberId, String passwordHash) {
        Map<String, Object> params = new HashMap<>();
        params.put("memberId", memberId);
        params.put("passwordHash", passwordHash);
        Integer count = sqlSession.selectOne(NAMESPACE + ".existsInHistory", params);
        return count != null && count > 0;
    }

    @Override
    public int deleteOldHistory(Long memberId) {
        return sqlSession.delete(NAMESPACE + ".deleteOldHistory", memberId);
    }
}
