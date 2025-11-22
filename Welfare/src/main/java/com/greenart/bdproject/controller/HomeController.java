package com.greenart.bdproject.controller;

import com.greenart.bdproject.service.FacilityApiService;
import com.greenart.bdproject.service.WelfareService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@Controller
public class HomeController {
    
    @Autowired
    private FacilityApiService facilityApiService;
    
    @Autowired 
    private WelfareService welfareService;
    
    // ============== 기본 라우터 (복지 진단 메서드 포함) ==============
    @GetMapping("/")
    public String main() {
        return "project";
    }

    @GetMapping("/diagnosis")
    public String diagnosis() {
        return "project_information";
    }

    @PostMapping("/diagnosis/result")
    public String result(@RequestParam Map<String, String> params, Model model) {
        try {
            List<Map<String, Object>> results = welfareService.matchWelfare(params);
            model.addAttribute("userData", params);
            model.addAttribute("welfareServices", results);
        } catch (Exception e) {
            model.addAttribute("error", "조회 실패: " + e.getMessage());
        }
        return "project_result";
    }

    @GetMapping("/project_Map.jsp")
    public String map() {
        return "project_Map";
    }

    @GetMapping("/admin")
    public String admin() {
        return "project_admin";
    }

    @GetMapping("/test")
    @ResponseBody
    public String test() {
        return "{\"status\":\"서버 연결 성공\",\"timestamp\":\"" + System.currentTimeMillis() + "\"}";
    }

    @GetMapping("/test/db")
    @ResponseBody
    public String testDb() {
        return "{\"status\":\"DB 테스트는 STS Console 로그를 확인하세요\"}";
    }
    
    @GetMapping(value = "/api/facilities", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String getFacilities(
            @RequestParam(required = false) String fcltKindCd,
            @RequestParam(required = false) String jrsdSggCd,
            @RequestParam(required = false) String fcltNm,
            @RequestParam(defaultValue = "1") int pageNo,
            @RequestParam(defaultValue = "100") int numOfRows) {
        System.out.println("=== 사회복지시설 API 데이터 호출 ===");
        System.out.println(fcltKindCd+"/"+ jrsdSggCd+"/"+fcltNm+"/"+ pageNo+"/"+ numOfRows);
        String result = facilityApiService.getFacilities(fcltKindCd, jrsdSggCd, fcltNm, pageNo, numOfRows);
        System.out.println("응답결과: "+result);
        System.out.println("API 응답 길이: " + (result != null ? result.length() : 0));
        return result;
    }
    
    @GetMapping(value = "/api/facility-types", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String getFacilityTypes() {
        System.out.println("=== 시설 유형 코드 조회 호출 ===");
        String result = facilityApiService.getFacilityTypes();
        System.out.println("시설 유형 API 응답 처리 완료");
        return result;
    }
}