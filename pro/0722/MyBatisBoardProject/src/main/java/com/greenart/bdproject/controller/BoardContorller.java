package com.greenart.bdproject.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.greenart.bdproject.dto.BoardDto;
import com.greenart.bdproject.service.BoardService;
import com.greenart.bdproject.util.PageHandler;

@Controller
@RequestMapping("/board")
public class BoardContorller {
	@Autowired
	BoardService service;
	
	@GetMapping("/list")
	public String list(Integer page, Integer pageSize, HttpServletRequest request, HttpSession session, Model m ) {
		if(page==null) page = 1;
		if(pageSize == null) pageSize = 5;
		if(!loginCheck(session)) return "redirect:/login/login?toURL="+request.getRequestURL();
		
		try {
			int offset = (page-1) * pageSize;
			int count = service.getCount();// 전체게시물수
			PageHandler ph = new PageHandler(count, page, pageSize);
			List<BoardDto> list = service.getPage(offset, pageSize);
			m.addAttribute("list", list);
			m.addAttribute("ph", ph);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "boardList";
	}
	
	@GetMapping("/read")
	public String read(Integer bno, Model m, HttpSession session, HttpServletRequest request) {
		if(!loginCheck(session)) return "redirect:/login/login?toURL="+request.getRequestURL();
		if(bno==null) return "redirect:/board/list";
		
		try {
			BoardDto dto = service.read(bno);
			m.addAttribute("dto", dto);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "boardRead";
	}

	private boolean loginCheck(HttpSession session) {
		return session.getAttribute("id")!=null;
	}
}
