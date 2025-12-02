package com.greenart.bdproject.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.greenart.bdproject.dto.DonationReviewDto;
import com.greenart.bdproject.service.DonationReviewService;
import com.greenart.bdproject.service.KindnessTemperatureService;

/**
 * 기부 리뷰 API 컨트롤러
 * URL 패턴: /api/donation-review/*
 */
@RestController
@RequestMapping("/api/donation-review")
public class DonationReviewApiController {

    private static final Logger logger = LoggerFactory.getLogger(DonationReviewApiController.class);

    @Autowired
    private DonationReviewService donationReviewService;

    @Autowired(required = false)
    private KindnessTemperatureService temperatureService;

    @Autowired
    private DataSource dataSource;

    /**
     * 리뷰 작성
     * @PostMapping("/api/donation-review/create")
     */
    @PostMapping("/create")
    public Map<String, Object> createReview(DonationReviewDto reviewDto, HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 로그인 체크 - id (이메일) 사용
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                userId = (String) session.getAttribute("userId");
            }

            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            logger.info("기부 리뷰 작성 요청 - userId: {}, donationId: {}", userId, reviewDto.getDonationId());

            con = dataSource.getConnection();

            // member_id 조회 및 기부 소유권 확인
            String checkSql = "SELECT m.member_id, m.name, d.donation_id FROM member m " +
                    "JOIN donations d ON m.member_id = d.member_id " +
                    "WHERE m.email = ? AND d.donation_id = ?";
            pstmt = con.prepareStatement(checkSql);
            pstmt.setString(1, userId);
            pstmt.setLong(2, reviewDto.getDonationId());
            rs = pstmt.executeQuery();

            if (!rs.next()) {
                response.put("success", false);
                response.put("message", "해당 기부 내역을 찾을 수 없습니다.");
                return response;
            }

            Long memberId = rs.getLong("member_id");
            String memberName = rs.getString("name");

            close(rs, pstmt);

            // 이미 리뷰가 있는지 확인
            String existCheckSql = "SELECT review_id FROM donation_reviews WHERE donation_id = ?";
            pstmt = con.prepareStatement(existCheckSql);
            pstmt.setLong(1, reviewDto.getDonationId());
            rs = pstmt.executeQuery();

            if (rs.next()) {
                response.put("success", false);
                response.put("message", "이미 해당 기부에 대한 리뷰를 작성하셨습니다.");
                return response;
            }

            close(rs, pstmt);

            // 리뷰 작성
            reviewDto.setUserId(memberId);
            reviewDto.setReviewerName(memberName);

            DonationReviewDto result = donationReviewService.createReview(reviewDto);

            if (result != null) {
                response.put("success", true);
                response.put("data", result);
                response.put("message", "리뷰가 성공적으로 작성되었습니다.");
                logger.info("리뷰 작성 성공 - memberId: {}, rating: {}", memberId, result.getRating());

                // 선행온도 증가
                if (temperatureService != null) {
                    try {
                        temperatureService.increaseForDonationReview(userId);
                    } catch (Exception e) {
                        logger.warn("선행온도 증가 실패 (리뷰 작성은 성공): {}", e.getMessage());
                    }
                }
            } else {
                response.put("success", false);
                response.put("message", "리뷰 작성에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("리뷰 작성 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "리뷰 작성 중 오류가 발생했습니다: " + e.getMessage());
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    private void close(AutoCloseable... resources) {
        for (AutoCloseable resource : resources) {
            if (resource != null) {
                try {
                    resource.close();
                } catch (Exception e) {
                    logger.error("Resource close error", e);
                }
            }
        }
    }

    /**
     * 리뷰 목록 조회
     * @GetMapping("/api/donation-review/list")
     */
    @GetMapping("/list")
    public Map<String, Object> getReviewList() {

        Map<String, Object> response = new HashMap<>();

        try {
            List<DonationReviewDto> reviewList = donationReviewService.getAllReviews();

            response.put("success", true);
            response.put("data", reviewList);

        } catch (Exception e) {
            logger.error("리뷰 목록 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "리뷰 목록 조회 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 통계 조회
     * @GetMapping("/api/donation-review/statistics")
     * 리턴: {"totalReviews": ..., "averageRating": ..., "totalDonors": ..., "totalAmount": ...}
     */
    @GetMapping("/statistics")
    public Map<String, Object> getStatistics() {

        Map<String, Object> response = new HashMap<>();

        try {
            Map<String, Object> statistics = donationReviewService.getReviewStatistics();

            response.put("success", true);
            response.put("data", statistics);

        } catch (Exception e) {
            logger.error("통계 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "통계 조회 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 리뷰 검색 (서버 사이드 필터링)
     * @GetMapping("/api/donation-review/search")
     * @param keyword 검색 키워드 (리뷰 내용, 작성자명)
     * @param category 기부 분야 필터
     * @param sort 정렬 방식 (latest, rating, helpful)
     * @return 검색 결과 리스트
     */
    @GetMapping("/search")
    public Map<String, Object> searchReviews(
            @RequestParam(value = "q", required = false) String keyword,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "sort", defaultValue = "latest") String sort) {

        Map<String, Object> response = new HashMap<>();

        try {
            logger.info("리뷰 검색 - 키워드: {}, 카테고리: {}, 정렬: {}", new Object[]{keyword, category, sort});

            List<DonationReviewDto> allReviews = donationReviewService.getAllReviews();
            List<DonationReviewDto> filteredReviews = new java.util.ArrayList<>();

            // 필터링
            for (DonationReviewDto review : allReviews) {
                boolean matchKeyword = true;
                boolean matchCategory = true;

                // 키워드 필터링 (작성자명, 리뷰 내용)
                if (keyword != null && !keyword.trim().isEmpty()) {
                    String lowerKeyword = keyword.toLowerCase();
                    matchKeyword = (review.getReviewerName() != null && review.getReviewerName().toLowerCase().contains(lowerKeyword)) ||
                                   (review.getContent() != null && review.getContent().toLowerCase().contains(lowerKeyword)) ||
                                   (review.getCategory() != null && review.getCategory().toLowerCase().contains(lowerKeyword));

                    // 하이라이팅 적용
                    if (matchKeyword) {
                        if (review.getContent() != null && review.getContent().toLowerCase().contains(lowerKeyword)) {
                            review.setHighlightedContent(highlightText(review.getContent(), keyword));
                        }
                        if (review.getReviewerName() != null && review.getReviewerName().toLowerCase().contains(lowerKeyword)) {
                            review.setHighlightedName(highlightText(review.getReviewerName(), keyword));
                        }
                    }
                }

                // 카테고리 필터링
                if (category != null && !category.trim().isEmpty()) {
                    matchCategory = category.equals(review.getCategory());
                }

                if (matchKeyword && matchCategory) {
                    filteredReviews.add(review);
                }
            }

            // 정렬
            if ("rating".equals(sort)) {
                filteredReviews.sort((a, b) -> Integer.compare(b.getRating(), a.getRating()));
            } else if ("helpful".equals(sort)) {
                filteredReviews.sort((a, b) -> Integer.compare(b.getHelpfulCount(), a.getHelpfulCount()));
            } else {
                // latest (기본값)
                filteredReviews.sort((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()));
            }

            response.put("success", true);
            response.put("data", filteredReviews);
            response.put("count", filteredReviews.size());

            logger.info("검색 완료 - 결과: {}건", filteredReviews.size());

        } catch (Exception e) {
            logger.error("리뷰 검색 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "리뷰 검색 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 카테고리 목록 조회
     * @GetMapping("/api/donation-review/categories")
     * @return 기부 분야 목록
     */
    @GetMapping("/categories")
    public Map<String, Object> getCategories() {
        Map<String, Object> response = new HashMap<>();

        try {
            List<String> categories = donationReviewService.getDistinctCategories();

            response.put("success", true);
            response.put("data", categories);

        } catch (Exception e) {
            logger.error("카테고리 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "카테고리 조회 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 텍스트 하이라이팅 헬퍼 메서드
     */
    private String highlightText(String text, String keyword) {
        if (text == null || keyword == null) {
            return text;
        }
        // 대소문자 구분 없이 <mark> 태그로 감싸기
        String regex = "(?i)(" + java.util.regex.Pattern.quote(keyword) + ")";
        return text.replaceAll(regex, "<mark>$1</mark>");
    }
}
