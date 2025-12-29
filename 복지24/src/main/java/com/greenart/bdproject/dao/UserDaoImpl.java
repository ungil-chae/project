package com.greenart.bdproject.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.greenart.bdproject.dto.UserDto;

@Repository
public class UserDaoImpl implements UserDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.greenart.bdproject.mapper.UserMapper";

    @Override
    public UserDto selectByUsername(String username) {
        return sqlSession.selectOne(NAMESPACE + ".selectByUsername", username);
    }

    @Override
    public UserDto selectById(Long userId) {
        return sqlSession.selectOne(NAMESPACE + ".selectById", userId);
    }

    @Override
    public int insert(UserDto user) {
        return sqlSession.insert(NAMESPACE + ".insert", user);
    }

    @Override
    public int update(UserDto user) {
        return sqlSession.update(NAMESPACE + ".update", user);
    }

    @Override
    public int deleteById(Long userId) {
        return sqlSession.delete(NAMESPACE + ".deleteById", userId);
    }

    @Override
    public List<UserDto> selectAll() {
        return sqlSession.selectList(NAMESPACE + ".selectAll");
    }
}
