package com.greenart.bdproject.dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import com.greenart.bdproject.dto.Member;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/spring/root-context.xml"})
@Transactional
class MemberDaoImpl2Test {

    @Autowired
    MemberDao memberDao;

    @Test
    void testInsertAndSelect() throws Exception {

        Member member = new Member("testId", "testPassword", "testName", "test@email.com");


        memberDao.insert(member);
        Member selectedMember = memberDao.select("testId");


        assertNotNull(selectedMember);
        assertEquals(member.getId(), selectedMember.getId());
        assertEquals(member.getPwd(), selectedMember.getPwd());
        assertEquals(member.getName(), selectedMember.getName());
        assertEquals(member.getEmail(), selectedMember.getEmail());
    }
}