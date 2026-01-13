package com.greenart.bdproject.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.greenart.bdproject.mapper.MemberMapper;
import com.greenart.bdproject.dto.Member;

@Controller
public class RegisterController {

	@Autowired
	MemberMapper memberMapper;
	
	@GetMapping("/register/add")
	public String register() {
		return "project_register";
	}
	
	@GetMapping("/register/checkId")
	@ResponseBody
	public String checkId(@RequestParam("email") String email) {
		int count = memberMapper.countByEmail(email);
		if (count > 0) {
			return "duplicate";
		} else {
			return "available";
		}
	}
	
	@PostMapping("/register/save")
	public String save(Member member, RedirectAttributes reatt) {
		int res = memberMapper.insert(member);
		
		if (res == 1) {
			reatt.addFlashAttribute("register", "suc");
			return "redirect:/login/login";
		} else {
			reatt.addFlashAttribute("msg", "ȸ�����Կ� �����߽��ϴ�.");
			return "redirect:/register/add";
		}
	}
}