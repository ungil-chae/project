package com.greenart.bdproject.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Map;

/**
 * MyBatis 기반 DAO의 공통 로직을 제공하는 추상 클래스
 * 모든 DAO 구현체는 이 클래스를 상속받아 반복적인 코드를 줄일 수 있음
 *
 * @param <T> - Entity 타입 (DTO 클래스)
 * @param <ID> - Primary Key 타입 (Long, String 등)
 * @author Welfare24 Team
 */
public abstract class BaseDao<T, ID> {

    @Autowired
    protected SqlSession sqlSession;

    /**
     * MyBatis Mapper의 네임스페이스를 반환
     * 하위 클래스에서 반드시 구현해야 함
     *
     * @return String - Mapper 네임스페이스 (예: "com.greenart.bdproject.mapper.MemberMapper")
     */
    protected abstract String getNamespace();

    /**
     * 엔티티 삽입
     *
     * @param entity - 삽입할 엔티티
     * @return int - 삽입된 행 수
     */
    public int insert(T entity) {
        return sqlSession.insert(getNamespace() + ".insert", entity);
    }

    /**
     * ID로 엔티티 조회
     *
     * @param id - Primary Key
     * @return T - 조회된 엔티티 (없으면 null)
     */
    public T selectById(ID id) {
        return sqlSession.selectOne(getNamespace() + ".selectById", id);
    }

    /**
     * 모든 엔티티 조회
     *
     * @return List<T> - 전체 엔티티 리스트
     */
    public List<T> selectAll() {
        return sqlSession.selectList(getNamespace() + ".selectAll");
    }

    /**
     * 엔티티 수정
     *
     * @param entity - 수정할 엔티티
     * @return int - 수정된 행 수
     */
    public int update(T entity) {
        return sqlSession.update(getNamespace() + ".update", entity);
    }

    /**
     * ID로 엔티티 삭제
     *
     * @param id - Primary Key
     * @return int - 삭제된 행 수
     */
    public int deleteById(ID id) {
        return sqlSession.delete(getNamespace() + ".deleteById", id);
    }

    /**
     * 전체 엔티티 삭제
     *
     * @return int - 삭제된 행 수
     */
    public int deleteAll() {
        return sqlSession.delete(getNamespace() + ".deleteAll");
    }

    /**
     * 조건에 맞는 엔티티 개수 조회
     *
     * @param params - 조건 파라미터 맵
     * @return int - 엔티티 개수
     */
    public int count(Map<String, Object> params) {
        return sqlSession.selectOne(getNamespace() + ".count", params);
    }

    /**
     * 커스텀 쿼리로 리스트 조회
     * 하위 클래스에서 복잡한 조회 로직 구현 시 사용
     *
     * @param statement - Mapper의 statement ID (예: "findByCondition")
     * @param parameter - 쿼리 파라미터
     * @return List<T> - 조회된 엔티티 리스트
     */
    protected List<T> selectList(String statement, Object parameter) {
        return sqlSession.selectList(getNamespace() + "." + statement, parameter);
    }

    /**
     * 커스텀 쿼리로 단일 엔티티 조회
     *
     * @param statement - Mapper의 statement ID
     * @param parameter - 쿼리 파라미터
     * @return T - 조회된 엔티티 (없으면 null)
     */
    protected T selectOne(String statement, Object parameter) {
        return sqlSession.selectOne(getNamespace() + "." + statement, parameter);
    }

    /**
     * 커스텀 INSERT/UPDATE/DELETE 실행
     *
     * @param statement - Mapper의 statement ID
     * @param parameter - 쿼리 파라미터
     * @return int - 영향받은 행 수
     */
    protected int executeUpdate(String statement, Object parameter) {
        return sqlSession.update(getNamespace() + "." + statement, parameter);
    }

    /**
     * 파라미터 없이 커스텀 리스트 조회
     *
     * @param statement - Mapper의 statement ID
     * @return List<T> - 조회된 엔티티 리스트
     */
    protected List<T> selectList(String statement) {
        return sqlSession.selectList(getNamespace() + "." + statement);
    }

    /**
     * 파라미터 없이 커스텀 단일 엔티티 조회
     *
     * @param statement - Mapper의 statement ID
     * @return T - 조회된 엔티티 (없으면 null)
     */
    protected T selectOne(String statement) {
        return sqlSession.selectOne(getNamespace() + "." + statement);
    }

    /**
     * 특정 컬럼 값만 조회 (예: COUNT, SUM 등)
     *
     * @param statement - Mapper의 statement ID
     * @param parameter - 쿼리 파라미터
     * @param resultType - 결과 타입 클래스
     * @return R - 조회된 값
     */
    protected <R> R selectValue(String statement, Object parameter, Class<R> resultType) {
        return sqlSession.selectOne(getNamespace() + "." + statement, parameter);
    }
}
