package com.greenart.bdproject.dao;

import com.greenart.bdproject.dto.MemberStatusHistoryDto;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 회원 상태 변경 이력 DAO 구현체
 */
@Repository
public class MemberStatusHistoryDaoImpl implements MemberStatusHistoryDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.greenart.bdproject.mapper.MemberStatusHistoryMapper";

    @Override
    public int insertHistory(MemberStatusHistoryDto history) {
        return sqlSession.insert(NAMESPACE + ".insertHistory", history);
    }

    @Override
    public List<MemberStatusHistoryDto> selectAllHistory() {
        return sqlSession.selectList(NAMESPACE + ".selectAllHistory");
    }

    @Override
    public List<MemberStatusHistoryDto> selectHistoryByMemberId(Long memberId) {
        return sqlSession.selectList(NAMESPACE + ".selectHistoryByMemberId", memberId);
    }

    @Override
    public List<MemberStatusHistoryDto> selectHistoryByAdminId(Long adminId) {
        return sqlSession.selectList(NAMESPACE + ".selectHistoryByAdminId", adminId);
    }

    @Override
    public List<MemberStatusHistoryDto> selectHistoryByDateRange(String startDate, String endDate) {
        Map<String, String> params = new HashMap<>();
        params.put("startDate", startDate);
        params.put("endDate", endDate);
        return sqlSession.selectList(NAMESPACE + ".selectHistoryByDateRange", params);
    }

    @Override
    public List<MemberStatusHistoryDto> selectHistoryByEmail(String email) {
        return sqlSession.selectList(NAMESPACE + ".selectHistoryByEmail", email);
    }
}
