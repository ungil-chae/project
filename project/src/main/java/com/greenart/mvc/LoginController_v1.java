package com.greenart.mvc;

@Controller
@RequestMapping("/login1")
public class LoginController_v1 {
	GetMapping("/login1")
	public String loginForm() {
		return "loginForm_v1";
	}
}

