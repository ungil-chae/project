package com.greenart.com;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HelloController {
    
    @PostMapping("/hello")
    public String hello(@RequestParam("username") String username, Model model) {
    	
        model.addAttribute("name", username);
        return "result"; // WEB-INF/views/result.jsp »£√‚
    }
}