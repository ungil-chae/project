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
	
	@GetMapping("")
	public String loginForm() {
		return "loginForm";
	}

	@PostMapping("")
	public String login(String id, String pwd, String toURL, boolean rememberId, HttpServletResponse resp, HttpServletRequest req) {
		System.out.println(toURL);
		toURL = "".equals(toURL) || toURL==null ? "/" : toURL;
		if(!isValid(id, pwd)) {
			return "redirect:/login";
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

		// 사용자 정보 가져오기
		Member member = null;
		try {
			member = dao.select(id);
			System.out.println("=== 로그인 디버깅 ===");
			System.out.println("member: " + member);
			if (member != null) {
				System.out.println("member.getName(): " + member.getName());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		HttpSession session = req.getSession();
		session.setAttribute("id", id);

		// name(닉네임)도 세션에 저장
		if (member != null && member.getName() != null) {
			String username = member.getName().trim();
			session.setAttribute("username", username);
			System.out.println("세션에 username 저장: " + username);

			// role도 세션에 저장
			String role = member.getRole();
			if (role != null) {
				session.setAttribute("role", role);
				System.out.println("세션에 role 저장: " + role);

				// role에 따라 리다이렉트 경로 결정
				if ("ADMIN".equals(role)) {
					return "redirect:/admin";
				}
			}
		} else {
			System.out.println("경고: member 또는 name이 null입니다!");
		}

		// 일반 사용자는 toURL로 이동 (기본값: /)
		return "redirect:"+toURL;
	}

	private boolean isValid(String id, String pwd) {
		Member m = null;
		try {
			m = dao.select(id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if(m==null) return false;
		// Member에서 id가 username으로 변경됨
		String username = m.getUsername();
		return username != null && username.equals(id) && m.getPwd().equals(pwd);
	}
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		System.out.println("로그아웃");
		return "redirect:/";
	}
}
