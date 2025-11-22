package com.greenart.bdproject.controller;

import com.greenart.bdproject.service.WelfareService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/project_detail")
public class ProjectDetailController {

    @Autowired
    private WelfareService welfareService;

    // 상세 진단 페이지 표시
    // URL: /project_detail
    @GetMapping("")
    public String showDetailedDiagnosis() {
        return "project_detail";
    }

    // 상세 진단 폼 제출 처리 - project_information과 동일한 방식으로 project_result.jsp로 이동
    // URL: /project_detail/submit  
    @PostMapping("/submit")
    public String submitDetailedDiagnosis(@RequestParam Map<String, String> params, Model model) {
        try {
            // WelfareService를 통한 복지 매칭 (project_information과 동일한 로직)
            List<Map<String, Object>> results = welfareService.matchWelfare(params);
            model.addAttribute("userData", params);
            model.addAttribute("welfareServices", results);
        } catch (Exception e) {
            model.addAttribute("error", "복지 혜택 조회 중 오류가 발생했습니다: " + e.getMessage());
        }
        return "project_result"; // 기존 project_result.jsp 공유
    }

    // 상세 진단 결과 페이지는 직접 JSP 접근 방식으로 변경됨
    // project_detail.jsp에서 /bdproject/project_result.jsp로 직접 이동
}