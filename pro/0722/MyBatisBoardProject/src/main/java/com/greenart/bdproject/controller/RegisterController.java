package com.greenart.bdproject.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.greenart.bdproject.dao.MemberDao;
import com.greenart.bdproject.dto.Member;



@Controller
public class RegisterController {
	@Autowired
	MemberDao dao;
	
	@GetMapping("/register/add")
	public String register() {
		return "registerForm";
	}
	
	@PostMapping("/register/save")
	public String save(Member member, Model m, RedirectAttributes reatt) throws UnsupportedEncodingException {
		System.out.println(member);
		if(!isValid(member)) {
			String msg = URLEncoder.encode("id를 잘못입력하셨습니다.", "UTF-8");
			m.addAttribute("msg", msg);
			return "redirect:/register/add";
		}
		reatt.addFlashAttribute("register", "suc");
		return "redirect:/login/login";
	}

	private boolean isValid(Member member) {
		int res = 0;
		try {
			res = dao.insert(member);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return res==1;
	}
}
