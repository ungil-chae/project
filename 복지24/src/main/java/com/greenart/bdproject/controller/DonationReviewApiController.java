package com.greenart.bdproject.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collections;
import java.util.Comparator;
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
            // 리뷰가 없으면 샘플 데이터 삽입
            initSampleReviewsIfEmpty();

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
     * 리뷰가 비어있으면 샘플 데이터 삽입
     */
    private void initSampleReviewsIfEmpty() {
        Connection con = null;
        PreparedStatement countStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet countRs = null;

        try {
            con = dataSource.getConnection();

            // 리뷰 개수 확인
            countStmt = con.prepareStatement("SELECT COUNT(*) FROM donation_reviews");
            countRs = countStmt.executeQuery();
            countRs.next();
            int count = countRs.getInt(1);

            if (count == 0) {
                logger.info("기부 리뷰가 없어 샘플 데이터를 삽입합니다.");

                // 샘플 리뷰 삽입
                String insertSql = "INSERT INTO donation_reviews (member_id, donation_id, reviewer_name, title, rating, content, is_anonymous, helpful_count, created_at, updated_at) " +
                        "VALUES (NULL, NULL, ?, ?, ?, ?, ?, ?, DATE_SUB(NOW(), INTERVAL ? DAY), NOW())";
                insertStmt = con.prepareStatement(insertSql);

                // 리뷰 1: 위기가정 기부
                insertStmt.setString(1, "김민수");
                insertStmt.setString(2, "따뜻한 나눔의 기쁨");
                insertStmt.setInt(3, 5);
                insertStmt.setString(4, "처음으로 복지24를 통해 위기가정 지원 기부를 했습니다. 복잡한 절차 없이 간편하게 기부할 수 있어서 좋았고, 기부금이 어떻게 사용되는지 투명하게 공개되어 신뢰가 갔습니다.");
                insertStmt.setBoolean(5, false);
                insertStmt.setInt(6, 42);
                insertStmt.setInt(7, 30);
                insertStmt.executeUpdate();

                // 리뷰 2: 아동 지원
                insertStmt.setString(1, "이서연");
                insertStmt.setString(2, "아이들의 밝은 미래를 위해");
                insertStmt.setInt(3, 5);
                insertStmt.setString(4, "정기 후원을 시작한 지 6개월이 되었습니다. 매달 아이들의 교육과 급식 지원에 사용된다고 하니 보람을 느낍니다. 복지24 덕분에 쉽게 나눔을 실천할 수 있게 되었습니다.");
                insertStmt.setBoolean(5, false);
                insertStmt.setInt(6, 38);
                insertStmt.setInt(7, 25);
                insertStmt.executeUpdate();

                // 리뷰 3: 노인 돌봄
                insertStmt.setString(1, "박지훈");
                insertStmt.setString(2, "어르신들께 전하는 따뜻한 마음");
                insertStmt.setInt(3, 4);
                insertStmt.setString(4, "독거 어르신 지원 프로그램에 기부했습니다. 명절에 혼자 계신 어르신들께 선물을 전달한다고 하니 마음이 따뜻해졌습니다.");
                insertStmt.setBoolean(5, false);
                insertStmt.setInt(6, 29);
                insertStmt.setInt(7, 20);
                insertStmt.executeUpdate();

                // 리뷰 4: 장애인 지원
                insertStmt.setString(1, "최영희");
                insertStmt.setString(2, "함께하는 세상을 꿈꾸며");
                insertStmt.setInt(3, 5);
                insertStmt.setString(4, "장애인 자립 지원 프로그램에 후원하고 있습니다. 직업 훈련과 취업 연계 프로그램이 잘 운영되고 있다고 들었습니다. 앞으로도 계속 응원하겠습니다!");
                insertStmt.setBoolean(5, false);
                insertStmt.setInt(6, 56);
                insertStmt.setInt(7, 15);
                insertStmt.executeUpdate();

                // 리뷰 5: 한부모 가정
                insertStmt.setString(1, "정수민");
                insertStmt.setString(2, "한부모 가정에 희망을");
                insertStmt.setInt(3, 5);
                insertStmt.setString(4, "한부모 가정 지원에 매달 정기 후원하고 있습니다. 아이를 혼자 키우시는 분들께 조금이나마 도움이 되길 바랍니다. 복지24의 투명한 운영이 마음에 듭니다.");
                insertStmt.setBoolean(5, false);
                insertStmt.setInt(6, 33);
                insertStmt.setInt(7, 10);
                insertStmt.executeUpdate();

                // 리뷰 6: 익명 기부
                insertStmt.setString(1, "익명");
                insertStmt.setString(2, "작은 나눔이 큰 변화를");
                insertStmt.setInt(3, 4);
                insertStmt.setString(4, "범죄 피해자 지원 프로그램에 기부했습니다. 피해자분들의 심리 치료와 생활 안정에 조금이나마 보탬이 되길 바랍니다. 복지24의 체계적인 지원 시스템에 신뢰가 갑니다.");
                insertStmt.setBoolean(5, true);
                insertStmt.setInt(6, 47);
                insertStmt.setInt(7, 5);
                insertStmt.executeUpdate();

                logger.info("샘플 기부 리뷰 6건 삽입 완료");
            }
        } catch (Exception e) {
            logger.error("샘플 리뷰 삽입 중 오류", e);
        } finally {
            close(countRs, countStmt, insertStmt, con);
        }
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
                Collections.sort(filteredReviews, new Comparator<DonationReviewDto>() {
                    @Override
                    public int compare(DonationReviewDto a, DonationReviewDto b) {
                        return Integer.compare(b.getRating(), a.getRating());
                    }
                });
            } else if ("helpful".equals(sort)) {
                Collections.sort(filteredReviews, new Comparator<DonationReviewDto>() {
                    @Override
                    public int compare(DonationReviewDto a, DonationReviewDto b) {
                        return Integer.compare(b.getHelpfulCount(), a.getHelpfulCount());
                    }
                });
            } else {
                // latest (기본값)
                Collections.sort(filteredReviews, new Comparator<DonationReviewDto>() {
                    @Override
                    public int compare(DonationReviewDto a, DonationReviewDto b) {
                        return b.getCreatedAt().compareTo(a.getCreatedAt());
                    }
                });
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

    /**
     * 리뷰 좋아요(도움됨) 토글
     * @PostMapping("/api/donation-review/helpful")
     * @param reviewId 리뷰 ID
     * @param action "like" 또는 "unlike"
     * @return 업데이트된 좋아요 수
     */
    @PostMapping("/helpful")
    public Map<String, Object> toggleHelpful(
            @RequestParam("reviewId") Long reviewId,
            @RequestParam("action") String action,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 로그인 체크
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                userId = (String) session.getAttribute("userId");
            }

            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            con = dataSource.getConnection();

            // 좋아요 수 업데이트
            String updateSql;
            if ("like".equals(action)) {
                updateSql = "UPDATE donation_reviews SET helpful_count = helpful_count + 1 WHERE review_id = ?";
            } else {
                updateSql = "UPDATE donation_reviews SET helpful_count = GREATEST(0, helpful_count - 1) WHERE review_id = ?";
            }

            pstmt = con.prepareStatement(updateSql);
            pstmt.setLong(1, reviewId);
            int updated = pstmt.executeUpdate();

            if (updated > 0) {
                close(pstmt);

                // 업데이트된 좋아요 수 조회
                String selectSql = "SELECT helpful_count FROM donation_reviews WHERE review_id = ?";
                pstmt = con.prepareStatement(selectSql);
                pstmt.setLong(1, reviewId);
                rs = pstmt.executeQuery();

                int newCount = 0;
                if (rs.next()) {
                    newCount = rs.getInt("helpful_count");
                }

                response.put("success", true);
                response.put("helpfulCount", newCount);
                response.put("message", "like".equals(action) ? "좋아요가 추가되었습니다." : "좋아요가 취소되었습니다.");

                logger.info("리뷰 좋아요 {} - reviewId: {}, newCount: {}", new Object[]{action, reviewId, newCount});
            } else {
                response.put("success", false);
                response.put("message", "리뷰를 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            logger.error("리뷰 좋아요 처리 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "좋아요 처리 중 오류가 발생했습니다.");
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }
}
