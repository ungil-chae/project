package com.greenart.bdproject;

import static org.junit.Assert.assertTrue;

import java.util.List;

import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.greenart.bdproject.dao.BoardDao;
import com.greenart.bdproject.dto.BoardDto;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/**/root-context.xml" })
public class BoardDaoImplTest2 {
	
	@Autowired
	BoardDao boardDao;
	
	// @Test
	public void countTest() throws Exception {
		boardDao.deleteAll();
		assertTrue(boardDao.count() == 0);

		BoardDto boardDto = new BoardDto("no title", "no content", "asdf");
		assertTrue(boardDao.insert(boardDto) == 1);
		assertTrue(boardDao.count() == 1);

		assertTrue(boardDao.insert(boardDto) == 1);
		assertTrue(boardDao.count() == 2);
	}

	// @Test
	public void deleteAllTest() throws Exception {
		boardDao.deleteAll();
		assertTrue(boardDao.count() == 0);

		BoardDto boardDto = new BoardDto("no title", "no content", "asdf");
		assertTrue(boardDao.insert(boardDto) == 1);
		assertTrue(boardDao.deleteAll() == 1);
		assertTrue(boardDao.count() == 0);

		boardDto = new BoardDto("no title", "no content", "asdf");
		assertTrue(boardDao.insert(boardDto) == 1);
		assertTrue(boardDao.insert(boardDto) == 1);
		assertTrue(boardDao.deleteAll() == 2);
		assertTrue(boardDao.count() == 0);
	}

	// @Test
	public void deleteTest() throws Exception {
		boardDao.deleteAll();
		assertTrue(boardDao.count() == 0);

		BoardDto boardDto = new BoardDto("no title", "no content", "asdf");
		assertTrue(boardDao.insert(boardDto) == 1);
		Integer bno = boardDao.selectAll().get(0).getBno();
		assertTrue(boardDao.delete(bno, boardDto.getWriter()) == 1);
		assertTrue(boardDao.count() == 0);

		assertTrue(boardDao.insert(boardDto) == 1);
		bno = boardDao.selectAll().get(0).getBno();
		assertTrue(boardDao.delete(bno, boardDto.getWriter() + "222") == 0);
		assertTrue(boardDao.count() == 1);

		assertTrue(boardDao.delete(bno, boardDto.getWriter()) == 1);
		assertTrue(boardDao.count() == 0);

		assertTrue(boardDao.insert(boardDto) == 1);
		bno = boardDao.selectAll().get(0).getBno();
		assertTrue(boardDao.delete(bno + 1, boardDto.getWriter()) == 0);
		assertTrue(boardDao.count() == 1);
	}

	// @Test
	public void insertTest() throws Exception {
//        boardDao.deleteAll();

		for (int i = 0; i < 458; i++) {
			BoardDto boardDto = new BoardDto("title" + i, "content", "asdf");
			boardDao.insert(boardDto);
		}
//        assertTrue(boardDao.count()==100);

//        boardDto = new BoardDto("no title", "no content", "asdf");
//        assertTrue(boardDao.insert(boardDto)==1);
//        assertTrue(boardDao.count()==2);
//
//        boardDao.deleteAll();
//        boardDto = new BoardDto("no title", "no content", "asdf");
//        assertTrue(boardDao.insert(boardDto)==1);
//        assertTrue(boardDao.count()==1);
	}

	// @Test
	public void selectAllTest() throws Exception {
		boardDao.deleteAll();
		assertTrue(boardDao.count() == 0);

		List<BoardDto> list = boardDao.selectAll();
		assertTrue(list.size() == 0);

		BoardDto boardDto = new BoardDto("no title", "no content", "asdf");
		assertTrue(boardDao.insert(boardDto) == 1);

		list = boardDao.selectAll();
		assertTrue(list.size() == 1);

		assertTrue(boardDao.insert(boardDto) == 1);
		list = boardDao.selectAll();
		assertTrue(list.size() == 2);
	}

	// @Test
	public void selectTest() throws Exception {
		boardDao.deleteAll();
		assertTrue(boardDao.count() == 0);

		BoardDto boardDto = new BoardDto("no title", "no content", "asdf");
		assertTrue(boardDao.insert(boardDto) == 1);

		Integer bno = boardDao.selectAll().get(0).getBno();
		boardDto.setBno(bno);
		BoardDto boardDto2 = boardDao.select(bno);
		assertTrue(boardDto.equals(boardDto2));
	}

	// @Test
	public void updateTest() throws Exception {
		boardDao.deleteAll();
		BoardDto boardDto = new BoardDto("no title", "no content", "asdf");
		assertTrue(boardDao.insert(boardDto) == 1);

		Integer bno = boardDao.selectAll().get(0).getBno();
		System.out.println("bno = " + bno);
		boardDto.setBno(bno);
		boardDto.setTitle("yes title");
		assertTrue(boardDao.update(boardDto) == 1);

		BoardDto boardDto2 = boardDao.select(bno);
		assertTrue(boardDto.equals(boardDto2));
	}

	// @Test
	public void increaseViewCntTest() throws Exception {
		boardDao.deleteAll();
		assertTrue(boardDao.count() == 0);

		BoardDto boardDto = new BoardDto("no title", "no content", "asdf");
		assertTrue(boardDao.insert(boardDto) == 1);
		assertTrue(boardDao.count() == 1);

		Integer bno = boardDao.selectAll().get(0).getBno();
		assertTrue(boardDao.updateViewCnt(bno) == 1);

		boardDto = boardDao.select(bno);
		assertTrue(boardDto != null);
		assertTrue(boardDto.getViewCnt() == 1);

		assertTrue(boardDao.updateViewCnt(bno) == 1);
		boardDto = boardDao.select(bno);
		assertTrue(boardDto != null);
		assertTrue(boardDto.getViewCnt() == 2);
	}

}
