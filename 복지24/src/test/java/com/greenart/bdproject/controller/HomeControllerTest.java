package com.greenart.bdproject.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeControllerTest {
    
    @RequestMapping("/**")
    public String test() {
        System.out.println("========== 모든 요청 테스트! ==========");
        return "project";
    }
}