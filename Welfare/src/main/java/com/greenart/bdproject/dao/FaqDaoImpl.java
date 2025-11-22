package com.greenart.bdproject.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.greenart.bdproject.dto.FaqDto;

@Repository
public class FaqDaoImpl implements FaqDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.greenart.bdproject.mapper.FaqMapper";

    @Override
    public int insert(FaqDto faq) {
        return sqlSession.insert(NAMESPACE + ".insert", faq);
    }

    @Override
    public FaqDto selectById(Long faqId) {
        return sqlSession.selectOne(NAMESPACE + ".selectById", faqId);
    }

    @Override
    public List<FaqDto> selectAll() {
        return sqlSession.selectList(NAMESPACE + ".selectAll");
    }

    @Override
    public List<FaqDto> selectByCategory(String category) {
        return sqlSession.selectList(NAMESPACE + ".selectByCategory", category);
    }

    @Override
    public int update(FaqDto faq) {
        return sqlSession.update(NAMESPACE + ".update", faq);
    }

    @Override
    public int deleteById(Long faqId) {
        return sqlSession.delete(NAMESPACE + ".deleteById", faqId);
    }

    @Override
    public List<FaqDto> searchFaqs(String keyword) {
        return sqlSession.selectList(NAMESPACE + ".searchFaqs", keyword);
    }

    @Override
    public List<FaqDto> searchFaqsByCategory(String keyword, String category) {
        Map<String, String> params = new HashMap<>();
        params.put("keyword", keyword);
        params.put("category", category);
        return sqlSession.selectList(NAMESPACE + ".searchFaqsByCategory", params);
    }
}
