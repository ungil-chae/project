package com.greenart.bdproject.controller;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
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

import com.greenart.bdproject.dto.VolunteerApplicationDto;
import com.greenart.bdproject.service.KindnessTemperatureService;

/**
 * 봉사 API 컨트롤러
 * URL 패턴: /api/volunteer/*
 */
@RestController
@RequestMapping("/api/volunteer")
public class VolunteerApiController {

    private static final Logger logger = LoggerFactory.getLogger(VolunteerApiController.class);

    @Autowired
    private DataSource dataSource;

    @Autowired(required = false)
    private KindnessTemperatureService temperatureService;

    /**
     * 봉사 신청 (로그인 필요)
     * @PostMapping("/api/volunteer/apply")
     */
    @PostMapping("/apply")
    public Map<String, Object> applyVolunteer(
            @RequestParam("applicantName") String applicantName,
            @RequestParam("applicantPhone") String applicantPhone,
            @RequestParam("applicantEmail") String applicantEmail,
            @RequestParam("applicantAddress") String applicantAddress,
            @RequestParam("volunteerExperience") String volunteerExperience,
            @RequestParam("selectedCategory") String selectedCategory,
            @RequestParam("volunteerDate") String volunteerDate,
            @RequestParam(value = "volunteerEndDate", required = false) String volunteerEndDate,
            @RequestParam("volunteerTime") String volunteerTime,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 로그인 체크 - member.id (이메일)
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                // 대체로 userId 속성도 확인
                userId = (String) session.getAttribute("userId");
            }

            if (userId == null || userId.isEmpty()) {
                logger.warn("봉사 신청 실패 - 로그인되지 않음");
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            logger.info("=== 봉사 신청 요청 ===");
            logger.info("userId: {}, name: {}", userId, applicantName);
            logger.info("category: {}", selectedCategory);
            logger.info("date: {} ~ {}", volunteerDate, volunteerEndDate);

            con = dataSource.getConnection();

            String sql = "INSERT INTO volunteer_applications " +
                    "(user_id, applicant_name, applicant_phone, applicant_email, applicant_address, " +
                    "volunteer_experience, selected_category, volunteer_date, volunteer_end_date, volunteer_time, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'applied')";

            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, userId);
            pstmt.setString(2, applicantName);
            pstmt.setString(3, applicantPhone);
            pstmt.setString(4, applicantEmail);
            pstmt.setString(5, applicantAddress);
            pstmt.setString(6, volunteerExperience);
            pstmt.setString(7, selectedCategory);

            // 시작 날짜 변환 (YYYY-MM-DD 형식)
            try {
                pstmt.setDate(8, Date.valueOf(volunteerDate));
            } catch (IllegalArgumentException e) {
                logger.error("날짜 형식 오류: {}", volunteerDate);
                response.put("success", false);
                response.put("message", "날짜 형식이 올바르지 않습니다: " + volunteerDate);
                return response;
            }

            // 종료 날짜 변환 (있을 경우에만)
            if (volunteerEndDate != null && !volunteerEndDate.isEmpty()) {
                try {
                    pstmt.setDate(9, Date.valueOf(volunteerEndDate));
                } catch (IllegalArgumentException e) {
                    logger.error("종료 날짜 형식 오류: {}", volunteerEndDate);
                    response.put("success", false);
                    response.put("message", "종료 날짜 형식이 올바르지 않습니다: " + volunteerEndDate);
                    return response;
                }
            } else {
                // 종료일이 없으면 시작일과 동일하게 설정 (1일 봉사)
                pstmt.setDate(9, Date.valueOf(volunteerDate));
            }

            pstmt.setString(10, volunteerTime);

            logger.info("SQL 실행 준비 완료");
            int result = pstmt.executeUpdate();
            logger.info("SQL 실행 결과: {}", result);

            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    long applicationId = rs.getLong(1);
                    response.put("success", true);
                    response.put("applicationId", applicationId);
                    response.put("message", "봉사 신청이 완료되었습니다.");
                    logger.info("봉사 신청 성공 - applicationId: {}", applicationId);

                    // 선행온도 증가
                    if (temperatureService != null) {
                        try {
                            temperatureService.increaseForVolunteerApplication(userId);
                        } catch (Exception e) {
                            logger.warn("선행온도 증가 실패 (봉사 신청은 성공): {}", e.getMessage());
                        }
                    }
                }
            } else {
                response.put("success", false);
                response.put("message", "봉사 신청에 실패했습니다.");
                logger.error("봉사 신청 실패 - executeUpdate 결과: 0");
            }

        } catch (SQLException e) {
            logger.error("봉사 신청 중 SQL 오류 발생", e);
            logger.error("SQL State: {}, Error Code: {}", e.getSQLState(), e.getErrorCode());
            response.put("success", false);
            response.put("message", "봉사 신청 중 오류가 발생했습니다: " + e.getMessage());
        } catch (Exception e) {
            logger.error("봉사 신청 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "봉사 신청 중 오류가 발생했습니다: " + e.getMessage());
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    /**
     * 내 신청 내역 조회
     * @GetMapping("/api/volunteer/my-applications")
     */
    @GetMapping("/my-applications")
    public Map<String, Object> getMyApplications(HttpSession session) {

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
            // 봉사 신청 내역 조회 + 리뷰 작성 여부 확인
            String sql = "SELECT va.*, " +
                    "CASE WHEN vr.review_id IS NOT NULL THEN 1 ELSE 0 END AS has_review, " +
                    "CASE WHEN va.status = 'COMPLETED' AND va.completed_at IS NOT NULL AND " +
                    "TIMESTAMPDIFF(DAY, va.completed_at, NOW()) <= 3 AND vr.review_id IS NULL " +
                    "THEN 1 ELSE 0 END AS can_write_review " +
                    "FROM volunteer_applications va " +
                    "LEFT JOIN volunteer_reviews vr ON va.application_id = vr.application_id " +
                    "JOIN member m ON va.member_id = m.member_id " +
                    "WHERE m.email = ? " +
                    "ORDER BY va.created_at DESC";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);  // userId는 email
            rs = pstmt.executeQuery();

            List<VolunteerApplicationDto> applications = new ArrayList<>();

            while (rs.next()) {
                VolunteerApplicationDto dto = new VolunteerApplicationDto();
                dto.setApplicationId(rs.getLong("application_id"));
                dto.setActivityId(rs.getLong("activity_id"));
                dto.setMemberId(rs.getLong("member_id"));
                dto.setApplicantName(rs.getString("applicant_name"));
                dto.setApplicantEmail(rs.getString("applicant_email"));
                dto.setApplicantPhone(rs.getString("applicant_phone"));
                dto.setApplicantBirth(rs.getDate("applicant_birth"));
                dto.setApplicantGender(rs.getString("applicant_gender"));
                dto.setApplicantAddress(rs.getString("applicant_address"));
                dto.setVolunteerExperience(rs.getString("volunteer_experience"));
                dto.setSelectedCategory(rs.getString("selected_category"));
                dto.setMotivation(rs.getString("motivation"));
                dto.setVolunteerDate(rs.getDate("volunteer_date"));
                dto.setVolunteerEndDate(rs.getDate("volunteer_end_date"));
                dto.setVolunteerTime(rs.getString("volunteer_time"));
                dto.setStatus(rs.getString("status"));
                dto.setAttendanceChecked(rs.getBoolean("attendance_checked"));
                dto.setActualHours(rs.getInt("actual_hours"));
                dto.setCancelReason(rs.getString("cancel_reason"));
                dto.setRejectReason(rs.getString("reject_reason"));
                dto.setCompletedAt(rs.getTimestamp("completed_at"));
                dto.setCancelledAt(rs.getTimestamp("cancelled_at"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setUpdatedAt(rs.getTimestamp("updated_at"));
                dto.setHasReview(rs.getInt("has_review") == 1);
                dto.setCanWriteReview(rs.getInt("can_write_review") == 1);

                applications.add(dto);
            }

            response.put("success", true);
            response.put("data", applications);
            logger.info("봉사 신청 내역 조회 성공 - userId: {}, count: {}", userId, applications.size());

        } catch (Exception e) {
            logger.error("신청 내역 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "신청 내역 조회 중 오류가 발생했습니다.");
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    /**
     * 후기 작성 (봉사 종료 후 3일 이내만 가능)
     * @PostMapping("/api/volunteer/review/create")
     */
    @PostMapping("/review/create")
    public Map<String, Object> createReview(
            @RequestParam("applicationId") Long applicationId,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam(value = "rating", required = false) Integer rating,
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

            // 1. 봉사 신청 확인 및 3일 이내 확인 (volunteer_end_date 기준)
            String checkSql = "SELECT volunteer_end_date, selected_category, " +
                    "DATEDIFF(CURDATE(), volunteer_end_date) AS days_passed " +
                    "FROM volunteer_applications " +
                    "WHERE application_id = ? AND user_id = ?";

            pstmt = con.prepareStatement(checkSql);
            pstmt.setLong(1, applicationId);
            pstmt.setString(2, userId);
            rs = pstmt.executeQuery();

            if (!rs.next()) {
                response.put("success", false);
                response.put("message", "해당 봉사 신청 내역을 찾을 수 없습니다.");
                return response;
            }

            Date volunteerEndDate = rs.getDate("volunteer_end_date");
            int daysPassed = rs.getInt("days_passed");

            // 봉사 종료일이 아직 오지 않았으면 후기 작성 불가
            if (daysPassed < 0) {
                response.put("success", false);
                response.put("message", "봉사 종료 후에 리뷰를 작성할 수 있습니다.");
                return response;
            }

            // 봉사 종료 후 3일이 지났으면 후기 작성 불가
            if (daysPassed > 3) {
                response.put("success", false);
                response.put("message", "봉사 종료 후 3일 이내에만 리뷰를 작성할 수 있습니다.");
                return response;
            }

            rs.close();
            pstmt.close();

            // 2. 이미 리뷰가 있는지 확인
            String checkReviewSql = "SELECT COUNT(*) FROM volunteer_reviews WHERE application_id = ?";
            pstmt = con.prepareStatement(checkReviewSql);
            pstmt.setLong(1, applicationId);
            rs = pstmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                response.put("success", false);
                response.put("message", "이미 리뷰를 작성하셨습니다.");
                return response;
            }

            rs.close();
            pstmt.close();

            // 3. 리뷰 저장
            String insertSql = "INSERT INTO volunteer_reviews " +
                    "(user_id, application_id, title, content, rating) " +
                    "VALUES (?, ?, ?, ?, ?)";

            pstmt = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, userId);
            pstmt.setLong(2, applicationId);
            pstmt.setString(3, title);
            pstmt.setString(4, content);
            if (rating != null) {
                pstmt.setInt(5, rating);
            } else {
                pstmt.setNull(5, java.sql.Types.INTEGER);
            }

            int result = pstmt.executeUpdate();

            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    long reviewId = rs.getLong(1);
                    response.put("success", true);
                    response.put("reviewId", reviewId);
                    response.put("message", "리뷰가 작성되었습니다.");
                    logger.info("봉사 리뷰 작성 성공 - reviewId: {}", reviewId);

                    // 선행온도 증가
                    if (temperatureService != null) {
                        try {
                            temperatureService.increaseForVolunteerReview(userId);
                        } catch (Exception e) {
                            logger.warn("선행온도 증가 실패 (리뷰 작성은 성공): {}", e.getMessage());
                        }
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

    /**
     * 후기 목록 조회
     * @GetMapping("/api/volunteer/review/list")
     */
    @GetMapping("/review/list")
    public Map<String, Object> getReviewList() {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = dataSource.getConnection();

            String sql = "SELECT vr.*, va.applicant_name, va.selected_category " +
                    "FROM volunteer_reviews vr " +
                    "JOIN volunteer_applications va ON vr.application_id = va.application_id " +
                    "ORDER BY vr.created_at DESC";

            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            List<Map<String, Object>> reviews = new ArrayList<>();

            while (rs.next()) {
                Map<String, Object> review = new HashMap<>();
                review.put("reviewId", rs.getLong("review_id"));
                review.put("userName", rs.getString("applicant_name"));
                review.put("activityName", rs.getString("selected_category"));
                review.put("title", rs.getString("title"));
                review.put("content", rs.getString("content"));
                review.put("rating", rs.getObject("rating"));
                review.put("createdAt", rs.getTimestamp("created_at"));

                reviews.add(review);
            }

            response.put("success", true);
            response.put("data", reviews);
            logger.info("봉사 후기 목록 조회 성공 - count: {}", reviews.size());

        } catch (Exception e) {
            logger.error("후기 목록 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "후기 목록 조회 중 오류가 발생했습니다.");
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
