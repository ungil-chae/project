package com.greenart.bdproject.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.greenart.bdproject.dto.NoticeDto;

@Repository
public class NoticeDaoImpl implements NoticeDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.greenart.bdproject.mapper.NoticeMapper";

    @Override
    public int insert(NoticeDto notice) {
        return sqlSession.insert(NAMESPACE + ".insert", notice);
    }

    @Override
    public NoticeDto selectById(Long noticeId) {
        return sqlSession.selectOne(NAMESPACE + ".selectById", noticeId);
    }

    @Override
    public List<NoticeDto> selectAll() {
        return sqlSession.selectList(NAMESPACE + ".selectAll");
    }

    @Override
    public List<NoticeDto> selectPinned() {
        return sqlSession.selectList(NAMESPACE + ".selectPinned");
    }

    @Override
    public int update(NoticeDto notice) {
        return sqlSession.update(NAMESPACE + ".update", notice);
    }

    @Override
    public int deleteById(Long noticeId) {
        return sqlSession.delete(NAMESPACE + ".deleteById", noticeId);
    }

    @Override
    public int incrementViews(Long noticeId) {
        return sqlSession.update(NAMESPACE + ".incrementViews", noticeId);
    }
}
