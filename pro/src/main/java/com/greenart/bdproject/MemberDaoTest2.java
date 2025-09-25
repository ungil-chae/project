package com.greenart.first;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.greenart.first.dao.MemberDao;
import com.greenart.first.dto.Member;
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"file:src/main/webapp/WEB-INF/spring/**/root-context.xml"})
public class MemberDaoTest2 {
	@Autowired
	MemberDao dao;
	
	@Test
	public void updateTest() throws Exception{
		dao.deleteAll();
		Member m = new Member();
		m.setId("asdf");
		m.setPwd("1234");
		m.setName("È«±æµ¿");
		m.setEmail("asdf@naver.com");
		m.setBirth(java.sql.Date.valueOf("2012-12-12"));
		m.setSns("facebook");
		int res = dao.insert(m);
		assertTrue(res==1);
		
		Member m2 = new Member();
		m2.setId("asdf");
		m2.setPwd("3456");
		m2.setName("±è±æµ¿");
		m2.setEmail("asdf@naver.com");
		m2.setSns("kakatalk");
		m2.setBirth(java.sql.Date.valueOf("2012-12-12"));
		
		res = dao.update(m2);
		assertTrue(res==1);
		
		m = dao.select(m2.getId());
		System.out.println(m);
		assertTrue(m.equals(m2));
	}

}
