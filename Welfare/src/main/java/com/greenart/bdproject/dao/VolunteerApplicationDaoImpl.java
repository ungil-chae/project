package com.greenart.bdproject.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.greenart.bdproject.dto.VolunteerApplicationDto;

@Repository
public class VolunteerApplicationDaoImpl implements VolunteerApplicationDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.greenart.bdproject.mapper.VolunteerApplicationMapper";

    @Override
    public int insertApplication(VolunteerApplicationDto application) {
        return sqlSession.insert(NAMESPACE + ".insert", application);
    }

    @Override
    public VolunteerApplicationDto selectById(Long applicationId) {
        return sqlSession.selectOne(NAMESPACE + ".selectById", applicationId);
    }

    @Override
    public List<VolunteerApplicationDto> selectByUserId(String userId) {
        return sqlSession.selectList(NAMESPACE + ".selectByUserId", userId);
    }

    @Override
    public List<VolunteerApplicationDto> selectAll() {
        return sqlSession.selectList(NAMESPACE + ".selectAll");
    }

    @Override
    public int updateStatus(Long applicationId, String status) {
        Map<String, Object> params = new HashMap<>();
        params.put("applicationId", applicationId);
        params.put("status", status);
        return sqlSession.update(NAMESPACE + ".updateStatus", params);
    }
}
