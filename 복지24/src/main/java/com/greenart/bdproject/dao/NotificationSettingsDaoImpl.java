package com.greenart.bdproject.dao;

import com.greenart.bdproject.dto.NotificationSettings;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * 알림 설정 DAO 구현체
 */
@Repository
public class NotificationSettingsDaoImpl implements NotificationSettingsDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.greenart.bdproject.mapper.NotificationSettingsMapper";

    @Override
    public NotificationSettings selectByMemberId(Long memberId) {
        return sqlSession.selectOne(NAMESPACE + ".selectByMemberId", memberId);
    }

    @Override
    public Long insert(NotificationSettings settings) {
        sqlSession.insert(NAMESPACE + ".insert", settings);
        return settings.getSettingId();
    }

    @Override
    public int update(NotificationSettings settings) {
        return sqlSession.update(NAMESPACE + ".update", settings);
    }

    @Override
    public int upsert(NotificationSettings settings) {
        return sqlSession.insert(NAMESPACE + ".upsert", settings);
    }

    @Override
    public int delete(Long memberId) {
        return sqlSession.delete(NAMESPACE + ".delete", memberId);
    }
}
