package com.greenart.bdproject.dao;



import java.util.List;



import com.greenart.bdproject.dto.Member;

public interface MemberDao {



int insert(Member m) throws Exception;



Member select(String id) throws Exception;



int delete(String id) throws Exception;



int update(Member m)throws Exception;


public int deleteAll() throws Exception;


public List<Member> selectList() throws Exception;

}