package com.greenart.bdproject.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
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

import com.greenart.bdproject.dto.DonationDto;
import com.greenart.bdproject.dto.CalendarEvent;
import com.greenart.bdproject.service.KindnessTemperatureService;
import com.greenart.bdproject.service.CalendarEventService;
import java.math.BigDecimal;

/**
 * 기부 API 컨트롤러
 * URL 패턴: /api/donation/*
 */
@RestController
@RequestMapping("/api/donation")
public class DonationApiController {

    private static final Logger logger = LoggerFactory.getLogger(DonationApiController.class);

    @Autowired
    private DataSource dataSource;

    @Autowired(required = false)
    private KindnessTemperatureService temperatureService;

    @Autowired(required = false)
    private CalendarEventService calendarEventService;

    /**
     * API 테스트용 엔드포인트
     * @GetMapping("/api/donation/test")
     */
    @GetMapping("/test")
    public Map<String, Object> testApi() {
        Map<String, Object> response = new HashMap<>();

        try {
            logger.info("========================================");
            logger.info("테스트 API 호출됨");

            response.put("success", true);
            response.put("message", "DonationApiController가 정상 작동합니다");
            response.put("dataSourceStatus", dataSource != null ? "정상" : "NULL");

            if (dataSource != null) {
                try (Connection con = dataSource.getConnection()) {
                    response.put("databaseConnection", "연결 성공");
                    logger.info("데이터베이스 연결 테스트 성공");
                } catch (SQLException e) {
                    response.put("databaseConnection", "연결 실패: " + e.getMessage());
                    logger.error("데이터베이스 연결 테스트 실패", e);
                }
            }

            logger.info("테스트 API 응답: {}", response);
            logger.info("========================================");

        } catch (Exception e) {
            logger.error("테스트 API 오류", e);
            response.put("success", false);
            response.put("error", e.getMessage());
        }

        return response;
    }

    /**
     * 기부 생성
     * @PostMapping("/api/donation/create")
     */
    @PostMapping("/create")
    public Map<String, Object> createDonation(
            @RequestParam("amount") Double amount,
            @RequestParam("donationType") String donationType,
            @RequestParam("category") String category,
            @RequestParam(value = "packageName", required = false) String packageName,
            @RequestParam("donorName") String donorName,
            @RequestParam("donorEmail") String donorEmail,
            @RequestParam("donorPhone") String donorPhone,
            @RequestParam(value = "message", required = false) String message,
            @RequestParam(value = "signatureImage", required = false) String signatureImage,
            @RequestParam(value = "paymentMethod", required = false) String paymentMethod,
            @RequestParam(value = "regularStartDate", required = false) String regularStartDate,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 로그인 체크 (선택사항 - 비로그인도 기부 가능)
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                // 대체로 userId 속성도 확인
                userId = (String) session.getAttribute("userId");
            }

            logger.info("=== 기부 요청 ===");
            logger.info("userId: {}, amount: {}", userId, amount);
            logger.info("category: {}", category);
            logger.info("packageName: {}", packageName);
            logger.info("donorName: {}", donorName);
            logger.info("donationType: {}", donationType);
            logger.info("paymentMethod: {}", paymentMethod);
            logger.info("regularStartDate: {}", regularStartDate);
            logger.info("signatureImage length: {}", signatureImage != null ? signatureImage.length() : 0);

            con = dataSource.getConnection();

            // member_id 조회 (로그인 사용자인 경우)
            Long memberId = null;
            if (userId != null && !userId.isEmpty()) {
                String memberSql = "SELECT member_id FROM member WHERE email = ?";
                try (PreparedStatement memberPstmt = con.prepareStatement(memberSql)) {
                    memberPstmt.setString(1, userId);
                    try (ResultSet memberRs = memberPstmt.executeQuery()) {
                        if (memberRs.next()) {
                            memberId = memberRs.getLong("member_id");
                        }
                    }
                }
            }

            // category_id 조회
            int categoryId = 1; // 기본값
            String categorySql = "SELECT category_id FROM donation_categories WHERE category_code = ? OR category_name = ?";
            try (PreparedStatement catPstmt = con.prepareStatement(categorySql)) {
                catPstmt.setString(1, category);
                catPstmt.setString(2, category);
                try (ResultSet catRs = catPstmt.executeQuery()) {
                    if (catRs.next()) {
                        categoryId = catRs.getInt("category_id");
                    }
                }
            }

            // payment_method 기본값 설정
            if (paymentMethod == null || paymentMethod.isEmpty()) {
                paymentMethod = "CREDIT_CARD"; // 기본값
            }

            // schema.sql에 맞춤: member_id, category_id, signature_image, payment_method, regular_start_date 사용
            String sql = "INSERT INTO donations " +
                    "(member_id, category_id, amount, donation_type, package_name, donor_name, donor_email, donor_phone, message, signature_image, payment_method, regular_start_date, payment_status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'COMPLETED')";

            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            if (memberId != null) {
                pstmt.setLong(1, memberId);
            } else {
                pstmt.setNull(1, java.sql.Types.BIGINT);
            }
            pstmt.setInt(2, categoryId);
            pstmt.setDouble(3, amount);
            pstmt.setString(4, donationType.toUpperCase()); // ENUM: REGULAR, ONETIME
            pstmt.setString(5, packageName);
            pstmt.setString(6, donorName);
            pstmt.setString(7, donorEmail);
            pstmt.setString(8, donorPhone);
            pstmt.setString(9, message);
            pstmt.setString(10, signatureImage); // Base64 이미지
            pstmt.setString(11, paymentMethod.toUpperCase()); // ENUM: CREDIT_CARD, BANK_TRANSFER, etc.
            // 정기 기부 시작일 설정
            if (regularStartDate != null && !regularStartDate.isEmpty() && "REGULAR".equalsIgnoreCase(donationType)) {
                pstmt.setString(12, regularStartDate); // DATE 형식 (YYYY-MM-DD)
            } else {
                pstmt.setNull(12, java.sql.Types.DATE);
            }

            int result = pstmt.executeUpdate();

            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    long donationId = rs.getLong(1);
                    response.put("success", true);
                    response.put("donationId", donationId);
                    response.put("message", "기부가 완료되었습니다.");
                    logger.info("기부 성공 - donationId: {}", donationId);

                    // 선행온도 증가 (userId가 있는 경우만)
                    if (userId != null && !userId.isEmpty() && temperatureService != null) {
                        try {
                            temperatureService.increaseForDonation(userId, BigDecimal.valueOf(amount));
                        } catch (Exception e) {
                            logger.warn("선행온도 증가 실패 (기부는 성공): {}", e.getMessage());
                        }
                    }

                    // 정기 기부인 경우 캘린더에 자동 등록
                    if ("REGULAR".equalsIgnoreCase(donationType) && regularStartDate != null &&
                        !regularStartDate.isEmpty() && memberId != null && calendarEventService != null) {
                        try {
                            CalendarEvent calendarEvent = new CalendarEvent();
                            calendarEvent.setMemberId(memberId);
                            calendarEvent.setTitle(String.format("정기 기부 (%s)", category));
                            calendarEvent.setDescription(String.format("%.0f원 정기 기부", amount));
                            calendarEvent.setEventDate(java.sql.Date.valueOf(regularStartDate));
                            calendarEvent.setEventType("DONATION");
                            calendarEvent.setReminderEnabled(true);
                            calendarEvent.setRemindBeforeDays(1);
                            calendarEvent.setStatus("SCHEDULED");

                            calendarEventService.createEvent(calendarEvent);
                            logger.info("캘린더 자동 등록 성공 - donationId: {}, date: {}", donationId, regularStartDate);
                        } catch (Exception e) {
                            logger.warn("캘린더 자동 등록 실패 (기부는 성공): {}", e.getMessage());
                        }
                    }
                }
            } else {
                response.put("success", false);
                response.put("message", "기부에 실패했습니다.");
            }

        } catch (SQLException e) {
            logger.error("기부 중 SQL 오류 발생", e);
            logger.error("SQL State: {}, Error Code: {}", e.getSQLState(), e.getErrorCode());
            response.put("success", false);
            response.put("message", "기부 중 오류가 발생했습니다: " + e.getMessage());
        } catch (Exception e) {
            logger.error("기부 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "기부 중 오류가 발생했습니다: " + e.getMessage());
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    /**
     * 기부 통계 조회 (fund usage 페이지용)
     * @GetMapping("/api/donation/statistics")
     * @return totalAmount, donorCount, beneficiaryCount (리뷰 수), averageRating
     */
    @GetMapping("/statistics")
    public Map<String, Object> getDonationStatistics() {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            logger.info("========================================");
            logger.info("기부 통계 API 호출됨");
            logger.info("========================================");

            // DataSource 체크
            if (dataSource == null) {
                logger.error("DataSource가 null입니다! Spring 설정을 확인하세요.");
                response.put("success", false);
                response.put("message", "데이터베이스 연결 설정이 올바르지 않습니다.");
                return response;
            }

            con = dataSource.getConnection();
            logger.info("데이터베이스 연결 성공");

            // 총 모금액, 후원자 수 조회 (ENUM 값은 대소문자 모두 허용)
            String sql = "SELECT " +
                    "COALESCE(SUM(amount), 0) AS total_amount, " +
                    "COUNT(DISTINCT donor_email) AS donor_count, " +
                    "COUNT(*) AS donation_count " +
                    "FROM donations " +
                    "WHERE payment_status IN ('COMPLETED', 'completed')";

            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            Map<String, Object> stats = new HashMap<>();
            double totalAmount = 0.0;  // totalAmount를 미리 선언

            if (rs.next()) {
                totalAmount = rs.getDouble("total_amount");
                int donorCount = rs.getInt("donor_count");
                int donationCount = rs.getInt("donation_count");

                // 통계 데이터
                stats.put("totalAmount", totalAmount);
                stats.put("donorCount", donorCount);
                stats.put("donationCount", donationCount);

                logger.info("기부 통계 조회 1단계 성공 - 총액: {}, 후원자: {}", totalAmount, donorCount);
                logger.info("기부건수: {}", donationCount);
            }

            // 리뷰 통계 조회 (별도 쿼리)
            close(rs, pstmt, null);  // 이전 리소스 정리

            String reviewSql = "SELECT " +
                    "COUNT(*) AS review_count, " +
                    "COALESCE(AVG(rating), 0.0) AS avg_rating " +
                    "FROM donation_reviews " +
                    "WHERE deleted_at IS NULL AND is_visible = TRUE";

            pstmt = con.prepareStatement(reviewSql);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                int reviewCount = rs.getInt("review_count");
                double avgRating = rs.getDouble("avg_rating");

                // 수혜자 수 계산: 총 모금액 / 5000원
                int beneficiaryCount = (int) (totalAmount / 5000);

                stats.put("beneficiaryCount", beneficiaryCount);
                stats.put("reviewCount", reviewCount);  // 리뷰수는 별도로 저장
                stats.put("averageRating", avgRating);

                logger.info("리뷰 통계 조회 성공 - 리뷰수: {}, 평균만족도: {}", reviewCount, avgRating);
                logger.info("수혜자수(5000원당 1명): {}", beneficiaryCount);
            }

            response.put("success", true);
            response.put("data", stats);

            logger.info("기부 통계 API 응답 성공");

        } catch (SQLException e) {
            logger.error("=========================================");
            logger.error("SQL 오류 발생!");
            logger.error("SQL State: {}", e.getSQLState());
            logger.error("Error Code: {}", e.getErrorCode());
            logger.error("Message: {}", e.getMessage());
            logger.error("=========================================", e);
            response.put("success", false);
            response.put("message", "데이터베이스 조회 중 오류가 발생했습니다: " + e.getMessage());
            response.put("errorType", "SQLException");
            response.put("errorDetail", e.getSQLState());
        } catch (Exception e) {
            logger.error("=========================================");
            logger.error("기부 통계 조회 중 예상치 못한 오류 발생");
            logger.error("Exception Type: {}", e.getClass().getName());
            logger.error("Message: {}", e.getMessage());
            logger.error("=========================================", e);
            response.put("success", false);
            response.put("message", "통계 조회 중 오류가 발생했습니다: " + e.getMessage());
            response.put("errorType", e.getClass().getSimpleName());
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    /**
     * 카테고리 통계 API 테스트
     */
    @GetMapping("/category-statistics-test")
    public Map<String, Object> testCategoryStatistics() {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Category statistics endpoint is reachable");
        response.put("timestamp", System.currentTimeMillis());
        logger.info("Category statistics test endpoint called");
        return response;
    }

    /**
     * 분야별 기부 통계 조회
     * @GetMapping("/api/donation/category-statistics")
     * @return 각 카테고리별 금액, 비율, 건수
     */
    @GetMapping("/category-statistics")
    public Map<String, Object> getCategoryStatistics() {
        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            logger.info("========================================");
            logger.info("분야별 기부 통계 API 호출 시작");
            logger.info("========================================");

            try {
            // DataSource null 체크
            if (dataSource == null) {
                logger.error("DataSource가 null입니다! Spring 설정을 확인하세요.");
                response.put("success", false);
                response.put("message", "DataSource가 초기화되지 않았습니다.");
                return response;
            }

            logger.info("DataSource 연결 시도...");
            con = dataSource.getConnection();
            logger.info("데이터베이스 연결 성공");

            // 카테고리별 금액, 비율, 건수 조회 (schema.sql에 맞춤: category_id 사용)
            String sql = "SELECT " +
                    "dc.category_name AS category, " +
                    "COUNT(*) AS donation_count, " +
                    "SUM(d.amount) AS total_amount, " +
                    "CASE " +
                    "  WHEN (SELECT SUM(amount) FROM donations WHERE payment_status IN ('COMPLETED', 'completed')) > 0 " +
                    "  THEN (SUM(d.amount) / (SELECT SUM(amount) FROM donations WHERE payment_status IN ('COMPLETED', 'completed')) * 100) " +
                    "  ELSE 0 " +
                    "END AS percentage " +
                    "FROM donations d " +
                    "JOIN donation_categories dc ON d.category_id = dc.category_id " +
                    "WHERE d.payment_status IN ('COMPLETED', 'completed') " +
                    "GROUP BY dc.category_id, dc.category_name " +
                    "ORDER BY total_amount DESC";

            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            List<Map<String, Object>> categoryStats = new ArrayList<>();

            while (rs.next()) {
                Map<String, Object> stat = new HashMap<>();
                String category = rs.getString("category");
                int donationCount = rs.getInt("donation_count");
                double totalAmount = rs.getDouble("total_amount");
                double percentage = rs.getDouble("percentage");

                stat.put("category", category != null ? category : "미분류");
                stat.put("donationCount", donationCount);
                stat.put("totalAmount", totalAmount);
                stat.put("percentage", Math.round(percentage * 10.0) / 10.0); // 소수점 1자리

                categoryStats.add(stat);
                logger.info("카테고리: {} - 금액: {}", category, totalAmount);
            }

            logger.info("분야별 통계 조회 성공 - 총 {}개 카테고리", categoryStats.size());

            // 데이터가 없는 경우 경고 로그
            if (categoryStats.isEmpty()) {
                logger.warn("분야별 통계 데이터가 없습니다. 데이터베이스에 완료된 기부 내역이 있는지 확인하세요.");
            }

            response.put("success", true);
            response.put("data", categoryStats);

            } catch (SQLException e) {
                logger.error("분야별 통계 조회 중 SQL 오류: {}", e.getMessage(), e);
                response.put("success", false);
                response.put("message", "분야별 통계 조회 중 오류가 발생했습니다: " + e.getMessage());
            } catch (Exception e) {
                logger.error("분야별 통계 조회 중 오류: {}", e.getMessage(), e);
                response.put("success", false);
                response.put("message", "분야별 통계 조회 중 오류가 발생했습니다: " + e.getMessage());
            } finally {
                close(rs, pstmt, con);
            }
        } catch (Throwable t) {
            logger.error("=== 최상위 예외 발생 ===");
            logger.error("예외 타입: {}", t.getClass().getName());
            logger.error("예외 메시지: {}", t.getMessage(), t);
            response.put("success", false);
            response.put("message", "예상치 못한 오류가 발생했습니다: " + t.getMessage());
            response.put("errorType", t.getClass().getSimpleName());
        }

        return response;
    }

    /**
     * 내 기부 내역 조회 (로그인 필요)
     * @GetMapping("/api/donation/my")
     */
    @GetMapping("/my")
    public Map<String, Object> getMyDonations(HttpSession session) {

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

            // 새 스키마: member_id (BIGINT), email로 회원 식별
            // JOIN을 통해 category_name 가져오기
            // member_id가 있으면 member로 조회, 없으면 donor_email로 조회
            String sql = "SELECT d.*, dc.category_name " +
                    "FROM donations d " +
                    "LEFT JOIN donation_categories dc ON d.category_id = dc.category_id " +
                    "LEFT JOIN member m ON d.member_id = m.member_id " +
                    "WHERE (m.email = ? OR d.donor_email = ?) " +
                    "ORDER BY d.created_at DESC";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);  // userId는 email (member 테이블)
            pstmt.setString(2, userId);  // userId는 email (donor_email)
            rs = pstmt.executeQuery();

            List<DonationDto> donations = new ArrayList<>();

            while (rs.next()) {
                DonationDto dto = new DonationDto();
                dto.setDonationId(rs.getLong("donation_id"));
                dto.setMemberId(rs.getLong("member_id"));
                dto.setCategoryId(rs.getInt("category_id"));
                dto.setCategoryName(rs.getString("category_name"));
                dto.setAmount(rs.getBigDecimal("amount"));
                dto.setDonationType(rs.getString("donation_type"));
                dto.setPackageName(rs.getString("package_name"));
                dto.setDonorName(rs.getString("donor_name"));
                dto.setDonorEmail(rs.getString("donor_email"));
                dto.setDonorPhone(rs.getString("donor_phone"));
                dto.setMessage(rs.getString("message"));
                dto.setPaymentMethod(rs.getString("payment_method"));
                dto.setPaymentStatus(rs.getString("payment_status"));
                dto.setTransactionId(rs.getString("transaction_id"));
                dto.setReceiptIssued(rs.getBoolean("receipt_issued"));
                dto.setSignatureImage(rs.getString("signature_image")); // 서명 이미지 추가
                dto.setRegularStartDate(rs.getDate("regular_start_date")); // 정기 기부 시작일 추가
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setRefundedAt(rs.getTimestamp("refunded_at"));

                donations.add(dto);
            }

            response.put("success", true);
            response.put("data", donations);
            logger.info("기부 내역 조회 성공 - userId: {}, count: {}", userId, donations.size());

        } catch (Exception e) {
            logger.error("기부 내역 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "기부 내역 조회 중 오류가 발생했습니다.");
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    /**
     * 기부 환불 API
     * 하루가 지났으면 10% 수수료
     */
    @PostMapping("/refund")
    public Map<String, Object> refundDonation(
            @RequestParam("donationId") Long donationId,
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

            logger.info("기부 환불 요청 - userId: {}, donationId: {}", userId, donationId);

            con = dataSource.getConnection();

            // 기부 정보 조회
            String selectSql = "SELECT d.*, m.member_id FROM donations d " +
                    "JOIN member m ON d.member_id = m.member_id " +
                    "WHERE d.donation_id = ? AND m.email = ?";
            pstmt = con.prepareStatement(selectSql);
            pstmt.setLong(1, donationId);
            pstmt.setString(2, userId);
            rs = pstmt.executeQuery();

            if (!rs.next()) {
                response.put("success", false);
                response.put("message", "해당 기부 내역을 찾을 수 없습니다.");
                return response;
            }

            String paymentStatus = rs.getString("payment_status");
            int amount = rs.getInt("amount");
            java.sql.Timestamp createdAt = rs.getTimestamp("created_at");

            // 이미 환불된 경우
            if ("REFUNDED".equals(paymentStatus)) {
                response.put("success", false);
                response.put("message", "이미 환불된 기부입니다.");
                return response;
            }

            // 완료되지 않은 결제
            if (!"COMPLETED".equals(paymentStatus)) {
                response.put("success", false);
                response.put("message", "완료된 기부만 환불할 수 있습니다.");
                return response;
            }

            close(rs, pstmt);

            // 기부일로부터 경과 시간 계산
            long diffMs = System.currentTimeMillis() - createdAt.getTime();
            long hours24 = 24 * 60 * 60 * 1000;
            boolean isAfter24Hours = diffMs > hours24;

            // 환불 가능 기간 체크 (7일 이내만)
            long days7 = 7 * 24 * 60 * 60 * 1000L;
            if (diffMs > days7) {
                response.put("success", false);
                response.put("message", "환불 가능 기간(7일)이 지났습니다.");
                return response;
            }

            // 환불 금액 계산 (24시간 이후면 10% 수수료)
            int fee = 0;
            int refundAmount = amount;
            if (isAfter24Hours) {
                fee = (int) Math.round(amount * 0.1);
                refundAmount = amount - fee;
            }

            // 기부 상태를 REFUNDED로 변경
            String updateSql = "UPDATE donations SET payment_status = 'REFUNDED', " +
                    "refund_amount = ?, refund_fee = ?, refunded_at = NOW(), updated_at = NOW() " +
                    "WHERE donation_id = ?";
            pstmt = con.prepareStatement(updateSql);
            pstmt.setInt(1, refundAmount);
            pstmt.setInt(2, fee);
            pstmt.setLong(3, donationId);

            int updated = pstmt.executeUpdate();

            if (updated > 0) {
                logger.info("기부 환불 완료 - donationId: {}, 원금: {}, 수수료: {}, 환불금: {}",
                        donationId, amount, fee, refundAmount);

                response.put("success", true);
                response.put("originalAmount", amount);
                response.put("fee", fee);
                response.put("refundAmount", refundAmount);
                response.put("hadFee", isAfter24Hours);

                if (isAfter24Hours) {
                    response.put("message", String.format("환불이 완료되었습니다. (원금: %,d원, 수수료: %,d원, 환불금액: %,d원)",
                            amount, fee, refundAmount));
                } else {
                    response.put("message", String.format("환불이 완료되었습니다. (환불금액: %,d원)", refundAmount));
                }
            } else {
                response.put("success", false);
                response.put("message", "환불 처리에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("기부 환불 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "환불 중 오류가 발생했습니다: " + e.getMessage());
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    // 자원 해제 메서드
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
}
