import java.net.URLEncoder;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class RegisterController {
	@Autowired
	MemberDao dao;
	
	@GetMampping("/register/add")
	public String register() {
		return "registerForm";
	}
	
	@PostMapping("/register/save")
	public String save(Member member, Model m, Re)
	System.out.println(member);
	if(!isValid(member)) {
		String msg = URLEncoder.encode("id¸¦ ")
		m.addAttribute("msg", msg);
		return "redirect:/register/add";
	}
	reatt.addFlashAttribute()
}
