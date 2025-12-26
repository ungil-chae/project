package com.greenart.bdproject.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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

    @Autowired
    private DataSource dataSource;

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
            // FAQ가 없으면 샘플 데이터 삽입
            initSampleFaqsIfEmpty();

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
     * FAQ가 비어있으면 샘플 데이터 삽입
     */
    private void initSampleFaqsIfEmpty() {
        Connection con = null;
        PreparedStatement countStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet countRs = null;

        try {
            con = dataSource.getConnection();

            // FAQ 개수 확인
            countStmt = con.prepareStatement("SELECT COUNT(*) FROM faq");
            countRs = countStmt.executeQuery();
            countRs.next();
            int count = countRs.getInt(1);

            if (count == 0) {
                logger.info("FAQ가 없어 샘플 데이터를 삽입합니다.");

                // 샘플 FAQ 삽입 (cat_id: 1=복지혜택, 2=서비스이용, 3=계정관리)
                String insertSql = "INSERT INTO faq (cat_id, question, answer, order_num, active_yn) VALUES (?, ?, ?, ?, TRUE)";
                insertStmt = con.prepareStatement(insertSql);

                // FAQ 1: 복지 혜택 찾기
                insertStmt.setInt(1, 1);
                insertStmt.setString(2, "복지 혜택은 어떻게 찾나요?");
                insertStmt.setString(3, "메인 페이지에서 '복지 혜택 찾기' 메뉴를 클릭하시면 간단한 정보 입력 후 맞춤형 복지 혜택을 추천받으실 수 있습니다. 나이, 가구 구성, 소득 수준 등의 정보를 입력하시면 AI가 자동으로 적합한 복지 서비스를 매칭해 드립니다.");
                insertStmt.setInt(4, 1);
                insertStmt.executeUpdate();

                // FAQ 2: 복지 혜택 신청
                insertStmt.setInt(1, 1);
                insertStmt.setString(2, "복지 혜택 신청은 어떻게 하나요?");
                insertStmt.setString(3, "복지 혜택 검색 결과에서 원하는 혜택의 '신청하기' 버튼을 클릭하시면 해당 기관의 신청 페이지로 이동합니다. 온라인 신청이 가능한 경우 바로 신청이 가능하며, 방문 신청이 필요한 경우 주변 시설 정보를 안내해 드립니다.");
                insertStmt.setInt(4, 2);
                insertStmt.executeUpdate();

                // FAQ 3: 기부 방법
                insertStmt.setInt(1, 2);
                insertStmt.setString(2, "기부는 어떻게 하나요?");
                insertStmt.setString(3, "상단 메뉴의 '기부하기'를 클릭하시면 기부 페이지로 이동합니다. 기부 카테고리를 선택하고, 기부 금액 및 결제 방법을 선택하신 후 기부를 진행하실 수 있습니다. 기부금 영수증은 마이페이지에서 확인 가능합니다.");
                insertStmt.setInt(4, 3);
                insertStmt.executeUpdate();

                // FAQ 4: 봉사활동 신청
                insertStmt.setInt(1, 2);
                insertStmt.setString(2, "봉사활동은 어떻게 신청하나요?");
                insertStmt.setString(3, "상단 메뉴의 '봉사활동'을 클릭하시면 다양한 봉사활동 목록을 확인하실 수 있습니다. 원하는 활동을 선택하고 신청서를 작성하시면 관리자 승인 후 봉사활동에 참여하실 수 있습니다.");
                insertStmt.setInt(4, 4);
                insertStmt.executeUpdate();

                // FAQ 5: 회원가입
                insertStmt.setInt(1, 3);
                insertStmt.setString(2, "회원가입은 어떻게 하나요?");
                insertStmt.setString(3, "상단의 '회원가입' 버튼을 클릭하여 이메일, 비밀번호, 이름, 연락처 등의 정보를 입력하시면 가입이 완료됩니다. 가입 후 다양한 복지 서비스를 이용하실 수 있습니다.");
                insertStmt.setInt(4, 5);
                insertStmt.executeUpdate();

                // FAQ 6: 비밀번호 변경
                insertStmt.setInt(1, 3);
                insertStmt.setString(2, "비밀번호를 잊어버렸어요.");
                insertStmt.setString(3, "로그인 페이지에서 '비밀번호 찾기'를 클릭하시면 가입 시 등록한 이메일로 비밀번호 재설정 링크가 발송됩니다. 이메일을 확인하시고 새 비밀번호를 설정해 주세요.");
                insertStmt.setInt(4, 6);
                insertStmt.executeUpdate();

                // FAQ 7: 복지지도
                insertStmt.setInt(1, 2);
                insertStmt.setString(2, "복지지도는 어떻게 이용하나요?");
                insertStmt.setString(3, "상단 메뉴의 '복지지도'를 클릭하시면 현재 위치 기반으로 주변 복지시설을 확인하실 수 있습니다. 복지관, 주민센터, 의료시설 등 다양한 카테고리별로 시설을 검색할 수 있습니다.");
                insertStmt.setInt(4, 7);
                insertStmt.executeUpdate();

                // FAQ 8: 마이페이지
                insertStmt.setInt(1, 3);
                insertStmt.setString(2, "마이페이지에서 무엇을 할 수 있나요?");
                insertStmt.setString(3, "마이페이지에서는 회원정보 수정, 기부 내역 조회, 봉사활동 내역 확인, 관심 복지시설 관리 등을 하실 수 있습니다. 또한 알림 설정을 통해 새로운 복지 혜택 소식을 받아보실 수 있습니다.");
                insertStmt.setInt(4, 8);
                insertStmt.executeUpdate();

                logger.info("샘플 FAQ 8건 삽입 완료");
            }
        } catch (SQLException e) {
            logger.error("샘플 FAQ 삽입 중 오류", e);
        } finally {
            try {
                if (countRs != null) countRs.close();
                if (countStmt != null) countStmt.close();
                if (insertStmt != null) insertStmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                logger.error("Resource close error", e);
            }
        }
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
