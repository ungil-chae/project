package com.greenart.bdproject.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.greenart.bdproject.dto.DonationDto;

@Repository
public class DonationDaoImpl implements DonationDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.greenart.bdproject.mapper.DonationMapper";

    @Override
    public int insertDonation(DonationDto donation) {
        return sqlSession.insert(NAMESPACE + ".insert", donation);
    }

    @Override
    public DonationDto selectById(Long donationId) {
        return sqlSession.selectOne(NAMESPACE + ".selectById", donationId);
    }

    @Override
    public List<DonationDto> selectByUserId(Long userId) {
        return sqlSession.selectList(NAMESPACE + ".selectByUserId", userId);
    }

    @Override
    public List<DonationDto> selectAll() {
        return sqlSession.selectList(NAMESPACE + ".selectAll");
    }

    @Override
    public Double getTotalDonationAmount() {
        return sqlSession.selectOne(NAMESPACE + ".getTotalDonationAmount");
    }

    @Override
    public int countTotalDonors() {
        Integer count = sqlSession.selectOne(NAMESPACE + ".countTotalDonors");
        return count != null ? count : 0;
    }
}
