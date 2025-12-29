package com.greenart.bdproject.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.greenart.bdproject.dto.VolunteerReviewDto;

@Repository
public class VolunteerReviewDaoImpl implements VolunteerReviewDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.greenart.bdproject.mapper.VolunteerReviewMapper";

    @Override
    public int insertReview(VolunteerReviewDto review) {
        return sqlSession.insert(NAMESPACE + ".insert", review);
    }

    @Override
    public VolunteerReviewDto selectById(Long reviewId) {
        return sqlSession.selectOne(NAMESPACE + ".selectById", reviewId);
    }

    @Override
    public List<VolunteerReviewDto> selectAll() {
        return sqlSession.selectList(NAMESPACE + ".selectAll");
    }

    @Override
    public List<VolunteerReviewDto> selectByUserId(String userId) {
        return sqlSession.selectList(NAMESPACE + ".selectByUserId", userId);
    }

    @Override
    public int countByApplicationId(Long applicationId) {
        return sqlSession.selectOne(NAMESPACE + ".countByApplicationId", applicationId);
    }
}
