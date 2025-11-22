package com.greenart.bdproject.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.greenart.bdproject.dto.WelfareDiagnosisDto;

@Repository
public class WelfareDiagnosisDaoImpl implements WelfareDiagnosisDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.greenart.bdproject.mapper.WelfareDiagnosisMapper";

    @Override
    public int insertDiagnosis(WelfareDiagnosisDto diagnosis) {
        return sqlSession.insert(NAMESPACE + ".insert", diagnosis);
    }

    @Override
    public List<WelfareDiagnosisDto> selectByUserId(String userId) {
        return sqlSession.selectList(NAMESPACE + ".selectByUserId", userId);
    }

    @Override
    public WelfareDiagnosisDto selectById(Long diagnosisId) {
        return sqlSession.selectOne(NAMESPACE + ".selectById", diagnosisId);
    }

    @Override
    public WelfareDiagnosisDto selectLatestByUserId(String userId) {
        return sqlSession.selectOne(NAMESPACE + ".selectLatestByUserId", userId);
    }
}
