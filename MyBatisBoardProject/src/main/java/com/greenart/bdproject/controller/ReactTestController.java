package com.greenart.bdproject.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.greenart.bdproject.dto.Member;

@Controller
public class ReactTestController {

	
	@GetMapping("/react/test")
	@ResponseBody
	public ResponseEntity<Member> test() {
		Member m = new Member();
		m.setId("asdf");
		m.setPwd("1234");
		return new ResponseEntity<Member>(m,HttpStatus.OK);
	}
		@GetMapping("/react/test2")
		@ResponseBody
		public String test2() {
			return "hello";
		}
	}

