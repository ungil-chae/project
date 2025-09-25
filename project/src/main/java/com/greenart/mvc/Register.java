package com.greenart.mvc;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller 
public class Register {
    

    @RequestMapping("/register")
    public String asd() {
        return "registerForm";  
    }
    
    @RequestMapping(value="/register/value", method=RequestMethod.POST)
    public String asd(String id, String pwd, String name, String email, Model model) {

        model.addAttribute("id", id);
        model.addAttribute("pwd", pwd);
        model.addAttribute("name", name);
        model.addAttribute("email", email);
        
        return "registerinfo";
    }
}