package com.greenart.bdproject.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * 최근 활동 숨김 처리 DAO 구현체
 *
 * @author Claude Code
 * @version 1.0.0
 */
@Repository
public class HiddenActivityDaoImpl implements HiddenActivityDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.greenart.bdproject.mapper.HiddenActivityMapper";

    @Override
    public int hideActivity(Long memberId, String activityType, Long activityId) {
        Map<String, Object> params = new HashMap<>();
        params.put("memberId", memberId);
        params.put("activityType", activityType);
        params.put("activityId", activityId);

        return sqlSession.insert(NAMESPACE + ".hideActivity", params);
    }

    @Override
    public int unhideActivity(Long memberId, String activityType, Long activityId) {
        Map<String, Object> params = new HashMap<>();
        params.put("memberId", memberId);
        params.put("activityType", activityType);
        params.put("activityId", activityId);

        return sqlSession.delete(NAMESPACE + ".unhideActivity", params);
    }

    @Override
    public List<Long> getHiddenActivityIds(Long memberId, String activityType) {
        Map<String, Object> params = new HashMap<>();
        params.put("memberId", memberId);
        params.put("activityType", activityType);

        return sqlSession.selectList(NAMESPACE + ".getHiddenActivityIds", params);
    }

    @Override
    public boolean isHidden(Long memberId, String activityType, Long activityId) {
        Map<String, Object> params = new HashMap<>();
        params.put("memberId", memberId);
        params.put("activityType", activityType);
        params.put("activityId", activityId);

        Integer count = sqlSession.selectOne(NAMESPACE + ".isHidden", params);
        return count != null && count > 0;
    }

    @Override
    public int deleteAllHidden(Long memberId) {
        return sqlSession.delete(NAMESPACE + ".deleteAllHidden", memberId);
    }
}
