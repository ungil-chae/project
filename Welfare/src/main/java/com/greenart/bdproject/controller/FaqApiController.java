package com.greenart.bdproject.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.greenart.bdproject.dto.FaqDto;
import com.greenart.bdproject.dto.SearchResultDto;
import com.greenart.bdproject.service.FaqService;

/**
 * FAQ API 컨트롤러
 * URL 패턴: /api/faq/*
 */
@RestController
@RequestMapping("/api/faq")
public class FaqApiController {

    private static final Logger logger = LoggerFactory.getLogger(FaqApiController.class);

    @Autowired
    private FaqService faqService;

    /**
     * 전체 FAQ 조회
     * @GetMapping("/api/faq/list")
     */
    @GetMapping("/list")
    public Map<String, Object> getFaqList() {

        Map<String, Object> response = new HashMap<>();

        try {
            List<FaqDto> faqList = faqService.getAllFaqs();

            response.put("success", true);
            response.put("data", faqList);

        } catch (Exception e) {
            logger.error("FAQ 목록 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "FAQ 목록 조회 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 카테고리별 FAQ 조회
     * @GetMapping("/api/faq/category/{category}")
     */
    @GetMapping("/category/{category}")
    public Map<String, Object> getFaqByCategory(@PathVariable("category") String category) {

        Map<String, Object> response = new HashMap<>();

        try {
            List<FaqDto> faqList = faqService.getFaqsByCategory(category);

            response.put("success", true);
            response.put("data", faqList);
            response.put("category", category);

        } catch (Exception e) {
            logger.error("카테고리별 FAQ 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "FAQ 조회 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * FAQ 검색 (고급 검색 엔진)
     * @GetMapping("/api/faq/search")
     * @param q 검색 키워드
     * @param category 카테고리 필터 (선택사항)
     */
    @GetMapping("/search")
    public Map<String, Object> searchFaqs(
            @RequestParam(value = "q", required = false) String query,
            @RequestParam(value = "category", required = false) String category) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 검색어 없는 경우
            if (query == null || query.trim().isEmpty()) {
                response.put("success", true);
                response.put("data", new java.util.ArrayList<>());
                response.put("count", 0);
                response.put("message", "검색어를 입력해주세요.");
                return response;
            }

            // 카테고리 필터링 여부에 따른 검색
            List<SearchResultDto> results;
            if (category != null && !category.trim().isEmpty() && !"all".equalsIgnoreCase(category)) {
                results = faqService.searchFaqsByCategory(query, category);
                logger.info("FAQ 검색 - 키워드: " + query + ", 카테고리: " + category + ", 결과: " + results.size() + "건");
            } else {
                results = faqService.searchFaqs(query);
                logger.info("FAQ 검색 - 키워드: " + query + ", 결과: " + results.size() + "건");
            }

            response.put("success", true);
            response.put("data", results);
            response.put("count", results.size());
            response.put("query", query);

            if (category != null && !category.isEmpty()) {
                response.put("category", category);
            }

            // 검색 성능 메트릭 추가
            if (!results.isEmpty()) {
                double avgScore = results.stream()
                        .mapToDouble(SearchResultDto::getRelevanceScore)
                        .average()
                        .orElse(0.0);
                response.put("avgRelevanceScore", String.format("%.2f", avgScore));
                response.put("topScore", String.format("%.2f", results.get(0).getRelevanceScore()));
            }

        } catch (Exception e) {
            logger.error("FAQ 검색 오류 - 키워드: " + query, e);
            response.put("success", false);
            response.put("message", "검색 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }
}
