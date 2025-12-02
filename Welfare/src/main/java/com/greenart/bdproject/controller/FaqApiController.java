package com.greenart.bdproject.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.greenart.bdproject.dao.MemberDao;
import com.greenart.bdproject.dto.FaqDto;
import com.greenart.bdproject.dto.Member;
import com.greenart.bdproject.dto.SearchResultDto;
import com.greenart.bdproject.service.FaqService;

/**
 * FAQ API 컨트롤러
 * URL 패턴: /api/faqs/*
 */
@RestController
@RequestMapping("/api/faqs")
public class FaqApiController {

    private static final Logger logger = LoggerFactory.getLogger(FaqApiController.class);

    @Autowired
    private FaqService faqService;

    @Autowired
    private MemberDao memberDao;

    /**
     * FAQ 목록 조회 (활성화 여부 필터링 가능)
     * @GetMapping("/api/faqs/list")
     * @param isActive 활성화 여부 필터 (선택사항)
     */
    @GetMapping("/list")
    public Map<String, Object> getFaqList(
            @RequestParam(value = "isActive", required = false) Boolean isActive) {

        Map<String, Object> response = new HashMap<>();

        try {
            List<FaqDto> faqList;

            if (isActive != null && isActive) {
                // 활성화된 FAQ만 조회
                faqList = faqService.getActiveFaqs();
                logger.info("활성화된 FAQ 조회: " + faqList.size() + "건");
            } else {
                // 전체 FAQ 조회
                faqList = faqService.getAllFaqs();
                logger.info("전체 FAQ 조회: " + faqList.size() + "건");
            }

            response.put("success", true);
            response.put("data", faqList);
            response.put("count", faqList.size());

        } catch (Exception e) {
            logger.error("FAQ 목록 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "FAQ 목록 조회 중 오류가 발생했습니다: " + e.getMessage());
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

    /**
     * FAQ 상세 조회
     * @GetMapping("/api/faqs/{id}")
     */
    @GetMapping("/{id}")
    public Map<String, Object> getFaqById(@PathVariable("id") Long id) {
        Map<String, Object> response = new HashMap<>();

        try {
            FaqDto faq = faqService.getFaqById(id);

            if (faq != null) {
                response.put("success", true);
                response.put("data", faq);
            } else {
                response.put("success", false);
                response.put("message", "FAQ를 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            logger.error("FAQ 상세 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "FAQ 조회 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * FAQ 등록 (관리자 전용)
     * @PostMapping("/api/faqs")
     */
    @PostMapping("")
    public Map<String, Object> createFaq(
            @RequestParam("category") String category,
            @RequestParam("question") String question,
            @RequestParam("answer") String answer,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 관리자 권한 체크
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            Member member = memberDao.select(userId);
            if (member == null || !"ADMIN".equals(member.getRole())) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return response;
            }

            // FAQ 생성
            FaqDto faq = new FaqDto();
            faq.setCategory(category);
            faq.setQuestion(question);
            faq.setAnswer(answer);
            faq.setIsActive(true);
            faq.setOrderNum(0);

            Long faqId = faqService.createFaq(faq);

            response.put("success", true);
            response.put("faqId", faqId);
            response.put("message", "FAQ가 등록되었습니다.");
            logger.info("FAQ 등록 성공 - faqId: {}", faqId);

        } catch (Exception e) {
            logger.error("FAQ 등록 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "FAQ 등록 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * FAQ 수정 (관리자 전용)
     * @PostMapping("/api/faqs/{id}/update")
     */
    @PostMapping("/{id}/update")
    public Map<String, Object> updateFaq(
            @PathVariable("id") Long id,
            @RequestParam("category") String category,
            @RequestParam("question") String question,
            @RequestParam("answer") String answer,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 관리자 권한 체크
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            Member member = memberDao.select(userId);
            if (member == null || !"ADMIN".equals(member.getRole())) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return response;
            }

            // 기존 FAQ 조회
            FaqDto existingFaq = faqService.getFaqById(id);
            if (existingFaq == null) {
                response.put("success", false);
                response.put("message", "FAQ를 찾을 수 없습니다.");
                return response;
            }

            // FAQ 수정
            existingFaq.setCategory(category);
            existingFaq.setQuestion(question);
            existingFaq.setAnswer(answer);

            boolean result = faqService.updateFaq(existingFaq);

            if (result) {
                response.put("success", true);
                response.put("message", "FAQ가 수정되었습니다.");
                logger.info("FAQ 수정 성공 - faqId: {}", id);
            } else {
                response.put("success", false);
                response.put("message", "FAQ 수정에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("FAQ 수정 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "FAQ 수정 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * FAQ 삭제 (관리자 전용)
     * @PostMapping("/api/faqs/{id}/delete")
     */
    @PostMapping("/{id}/delete")
    public Map<String, Object> deleteFaq(
            @PathVariable("id") Long id,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 관리자 권한 체크
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            Member member = memberDao.select(userId);
            if (member == null || !"ADMIN".equals(member.getRole())) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return response;
            }

            // FAQ 삭제
            boolean result = faqService.deleteFaq(id);

            if (result) {
                response.put("success", true);
                response.put("message", "FAQ가 삭제되었습니다.");
                logger.info("FAQ 삭제 성공 - faqId: {}", id);
            } else {
                response.put("success", false);
                response.put("message", "FAQ 삭제에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("FAQ 삭제 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "FAQ 삭제 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }
}
