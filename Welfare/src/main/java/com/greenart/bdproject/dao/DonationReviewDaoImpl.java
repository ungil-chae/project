package com.greenart.bdproject.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.greenart.bdproject.dto.DonationReviewDto;

@Repository
public class DonationReviewDaoImpl implements DonationReviewDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.greenart.bdproject.mapper.DonationReviewMapper";

    @Override
    public int insertReview(DonationReviewDto review) {
        return sqlSession.insert(NAMESPACE + ".insertReview", review);
    }

    @Override
    public DonationReviewDto selectById(Long reviewId) {
        return sqlSession.selectOne(NAMESPACE + ".selectById", reviewId);
    }

    @Override
    public List<DonationReviewDto> selectAll() {
        return sqlSession.selectList(NAMESPACE + ".selectAll");
    }

    @Override
    public List<DonationReviewDto> selectByUserId(Long userId) {
        return sqlSession.selectList(NAMESPACE + ".selectByUserId", userId);
    }

    @Override
    public int countTotalReviews() {
        Integer count = sqlSession.selectOne(NAMESPACE + ".countTotalReviews");
        return count != null ? count : 0;
    }

    @Override
    public Double getAverageRating() {
        return sqlSession.selectOne(NAMESPACE + ".getAverageRating");
    }
}
