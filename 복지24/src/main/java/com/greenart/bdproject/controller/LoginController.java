package com.greenart.bdproject.controller;


import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.greenart.bdproject.dao.MemberDao;
import com.greenart.bdproject.dto.Member;


@Controller
@RequestMapping("/login")
public class LoginController {
	@Autowired
	MemberDao dao;
	
	@GetMapping("/login")
	public String loginForm() {
		return "loginForm";
	}
	
	@PostMapping("/login")
	public String login(String id, String pwd, String toURL, boolean rememberId, HttpServletResponse resp, HttpServletRequest req) {
		System.out.println(toURL);
		toURL = "".equals(toURL) || toURL==null ? "/" : toURL;
		if(!isValid(id, pwd)) {
			return "redirect:/login/login";
		}
		if(rememberId) {
			Cookie cookie = new Cookie("id", id);
			resp.addCookie(cookie);
		}else {
			Cookie cookie = new Cookie("id", "");
			cookie.setMaxAge(0);
			resp.addCookie(cookie);
		}
		System.out.println(id);
		System.out.println(pwd);
		System.out.println(rememberId);
		
		
		HttpSession session = req.getSession();
		session.setAttribute("id", id);
		return "redirect:"+toURL;
	}

	private boolean isValid(String id, String pwd) {
		Member m = null;
		try {
			m = dao.select(id);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(m==null) return false;
		return m.getId().equals(id) && m.getPwd().equals(pwd);
	}
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		System.out.println("로그아웃");
		return "redirect:/";
	}
}
