package com.greenart.bdproject.dao;

import com.greenart.bdproject.dto.FavoriteWelfareServiceDto;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 즐겨찾기 복지 서비스 DAO 구현체
 */
@Repository
public class FavoriteWelfareServiceDaoImpl implements FavoriteWelfareServiceDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.greenart.bdproject.mapper.FavoriteWelfareServiceMapper";

    @Override
    public int insert(FavoriteWelfareServiceDto favorite) {
        return sqlSession.insert(NAMESPACE + ".insert", favorite);
    }

    @Override
    public int delete(Long memberId, String serviceId) {
        Map<String, Object> params = new HashMap<>();
        params.put("memberId", memberId);
        params.put("serviceId", serviceId);
        return sqlSession.delete(NAMESPACE + ".delete", params);
    }

    @Override
    public List<FavoriteWelfareServiceDto> selectByMemberId(Long memberId) {
        return sqlSession.selectList(NAMESPACE + ".selectByMemberId", memberId);
    }

    @Override
    public boolean exists(Long memberId, String serviceId) {
        Map<String, Object> params = new HashMap<>();
        params.put("memberId", memberId);
        params.put("serviceId", serviceId);
        Boolean result = sqlSession.selectOne(NAMESPACE + ".exists", params);
        return result != null && result;
    }

    @Override
    public int countByMemberId(Long memberId) {
        Integer count = sqlSession.selectOne(NAMESPACE + ".countByMemberId", memberId);
        return count != null ? count : 0;
    }
}
