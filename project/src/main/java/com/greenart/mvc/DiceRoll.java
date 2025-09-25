package com.greenart.mvc;

import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
@Controller 
public class DiceRoll {
    @RequestMapping("/rollDiceMVC")
    public String main(Model m) throws IOException{
    	
        int dice1 = (int)(Math.random() * 6) + 1;
        int dice2 = (int)(Math.random() * 6) + 1;
        
        m.addAttribute("dice1" , dice1);
        
        m.addAttribute("dice2" , dice2);
        return "dice";
    }
}