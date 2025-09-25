package com.greenart.mvc;

import org.springframework.stereotype.Controller;

@Controller
public class LoginController {
	@GetMapping("/login")
	public String loginForm() {
		return "loginForm";
	}
	@PostMapping("/login")
	public String login(String id, String pwd) {
		System.out.println(id);
		System.out.println(pwd);
		System.out.println(rememberId);
		
		return "loginForm";
	}

}
