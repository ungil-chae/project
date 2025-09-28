package com.greenart.bdproject.dao;

import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Repository;
import com.greenart.bdproject.dto.Member;
@Repository  // 이 어노테이션이 핵심! 스프링이 빈으로 인식
public class ProjectMemberDaoImpl implements ProjectMemberDao {
    
    // 임시 저장소 (실제로는 DB 연결)
    private Map<String, Member> memberStorage = new HashMap<>();
    
    @Override
    public int insert(Member m) {
        if (memberStorage.containsKey(m.getEmail())) {
            return 0; // 이미 존재
        }
        memberStorage.put(m.getEmail(), m);
        return 1; // 성공
    }
    
    @Override
    public Member select(String email) {
        return memberStorage.get(email);
    }
    
    @Override
    public int delete(String email) {
        if (memberStorage.remove(email) != null) {
            return 1;
        }
        return 0;
    }
    
    @Override
    public int update(Member m) {
        if (memberStorage.containsKey(m.getEmail())) {
            memberStorage.put(m.getEmail(), m);
            return 1;
        }
        return 0;
    }
    
    @Override
    public int deleteAll() {
        int size = memberStorage.size();
        memberStorage.clear();
        return size;
    }
    
    @Override
    public List<Member> selectList() {
        return new ArrayList<>(memberStorage.values());
    }
    
    @Override
    public int countByEmail(String email) {
        return memberStorage.containsKey(email) ? 1 : 0;
    }
}