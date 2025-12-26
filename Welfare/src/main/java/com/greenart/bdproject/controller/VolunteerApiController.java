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
import com.greenart.bdproject.dto.CalendarEvent;
import com.greenart.bdproject.service.KindnessTemperatureService;
import com.greenart.bdproject.service.NotificationService;
import com.greenart.bdproject.service.CalendarEventService;

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

    @Autowired(required = false)
    private NotificationService notificationService;

    @Autowired(required = false)
    private CalendarEventService calendarEventService;

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

            // member_id 조회 및 봉사 신청 금지 확인
            Long memberId = null;
            java.sql.Timestamp banUntil = null;
            String memberSql = "SELECT member_id, volunteer_ban_until FROM member WHERE email = ?";
            try (PreparedStatement memberPstmt = con.prepareStatement(memberSql)) {
                memberPstmt.setString(1, userId);
                try (ResultSet memberRs = memberPstmt.executeQuery()) {
                    if (memberRs.next()) {
                        memberId = memberRs.getLong("member_id");
                        banUntil = memberRs.getTimestamp("volunteer_ban_until");
                    }
                }
            }

            // 봉사 신청 금지 상태 확인
            if (banUntil != null && banUntil.after(new java.sql.Timestamp(System.currentTimeMillis()))) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy년 MM월 dd일 HH시 mm분");
                String banUntilStr = sdf.format(banUntil);
                logger.warn("봉사 신청 금지 상태 - userId: {}, 금지 해제일: {}", userId, banUntilStr);
                response.put("success", false);
                response.put("message", "봉사활동 신청이 제한되어 있습니다. " + banUntilStr + "까지 신청이 불가합니다. (24시간 이내 취소 패널티)");
                response.put("banUntil", banUntilStr);
                return response;
            }

            // schema.sql에 맞춤: vol_apply 테이블 사용
            String sql = "INSERT INTO vol_apply " +
                    "(act_id, member_id, appl_name, appl_phone, appl_email, appl_addr, " +
                    "vol_exp, sel_cat, vol_date, vol_end_date, vol_time, status) " +
                    "VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'APPLIED')";

            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            if (memberId != null) {
                pstmt.setLong(1, memberId);
            } else {
                pstmt.setNull(1, java.sql.Types.BIGINT);
            }
            pstmt.setString(2, applicantName);
            pstmt.setString(3, applicantPhone);
            pstmt.setString(4, applicantEmail);
            pstmt.setString(5, applicantAddress);

            // 봉사 경험 한글 -> ENUM 값 변환
            String experienceEnum = convertExperienceToEnum(volunteerExperience);
            pstmt.setString(6, experienceEnum);
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

                    // 캘린더에 자동 등록
                    if (memberId != null && calendarEventService != null) {
                        try {
                            CalendarEvent calendarEvent = new CalendarEvent();
                            calendarEvent.setMemberId(memberId);
                            calendarEvent.setTitle(String.format("봉사 활동 (%s)", selectedCategory));
                            calendarEvent.setDescription(String.format("%s 봉사 활동 - %s", selectedCategory, volunteerTime));

                            // 날짜 문자열 변환 (시간대 문제 방지)
                            java.sql.Date sqlDate = java.sql.Date.valueOf(volunteerDate.trim());
                            calendarEvent.setEventDate(sqlDate);

                            calendarEvent.setEventType("VOLUNTEER");
                            calendarEvent.setReminderEnabled(true);
                            calendarEvent.setRemindBeforeDays(1);
                            calendarEvent.setStatus("SCHEDULED");

                            calendarEventService.createEvent(calendarEvent);
                            logger.info("캘린더 자동 등록 성공 - applicationId: {}, date: {}", applicationId, volunteerDate);
                        } catch (Exception e) {
                            logger.warn("캘린더 자동 등록 실패 (봉사 신청은 성공): {}", e.getMessage());
                        }
                    }

                    // 봉사활동 알림은 페이지 로드 시 자동 생성됩니다 (generateAutoNotifications)
                    // 중복 방지를 위해 여기서는 생성하지 않음
                    logger.info("봉사활동 신청 완료 - 알림은 페이지 로드 시 자동 생성됩니다.");
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

            // 새 스키마: vol_apply 테이블 사용
            // 봉사 신청 내역 조회 + 리뷰 작성 여부 확인
            String sql = "SELECT va.apply_id AS application_id, va.act_id AS activity_id, va.member_id, " +
                    "va.appl_name AS applicant_name, va.appl_email AS applicant_email, va.appl_phone AS applicant_phone, " +
                    "va.appl_birth AS applicant_birth, va.appl_gender AS applicant_gender, va.appl_addr AS applicant_address, " +
                    "va.vol_exp AS volunteer_experience, va.sel_cat AS selected_category, va.motivation, " +
                    "va.vol_date AS volunteer_date, va.vol_end_date AS volunteer_end_date, va.vol_time AS volunteer_time, " +
                    "va.status, va.attend_yn AS attendance_checked, va.actual_hr AS actual_hours, " +
                    "va.cancel_rsn AS cancel_reason, va.reject_rsn AS reject_reason, " +
                    "va.completed_at, va.cancelled_at, va.created_at, va.updated_at, " +
                    "va.assign_fac_nm AS assigned_facility_name, va.assign_fac_addr AS assigned_facility_address, " +
                    "va.assign_fac_lat AS assigned_facility_lat, va.assign_fac_lng AS assigned_facility_lng, " +
                    "va.admin_memo AS admin_note, va.appr_by AS approved_by, va.appr_at AS approved_at, " +
                    "CASE WHEN vr.review_id IS NOT NULL THEN 1 ELSE 0 END AS has_review, " +
                    "CASE WHEN va.status = 'COMPLETED' AND va.completed_at IS NOT NULL AND " +
                    "TIMESTAMPDIFF(DAY, va.completed_at, NOW()) <= 3 AND vr.review_id IS NULL " +
                    "THEN 1 ELSE 0 END AS can_write_review " +
                    "FROM vol_apply va " +
                    "LEFT JOIN vol_review vr ON va.apply_id = vr.apply_id " +
                    "LEFT JOIN member m ON va.member_id = m.member_id " +
                    "WHERE (m.email = ? OR va.appl_email = ?) " +
                    "ORDER BY va.created_at DESC";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);  // userId는 email (member 테이블)
            pstmt.setString(2, userId);  // userId는 email (applicant_email)
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

                // 배정된 시설 정보 추가
                dto.setAssignedFacilityName(rs.getString("assigned_facility_name"));
                dto.setAssignedFacilityAddress(rs.getString("assigned_facility_address"));
                try {
                    dto.setAssignedFacilityLat(rs.getObject("assigned_facility_lat") != null ? rs.getDouble("assigned_facility_lat") : null);
                    dto.setAssignedFacilityLng(rs.getObject("assigned_facility_lng") != null ? rs.getDouble("assigned_facility_lng") : null);
                } catch (Exception e) {
                    // 좌표 정보 없을 경우 무시
                }
                dto.setAdminNote(rs.getString("admin_note"));
                dto.setApprovedBy(rs.getObject("approved_by") != null ? rs.getLong("approved_by") : null);
                dto.setApprovedAt(rs.getTimestamp("approved_at"));

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

            // member_id와 이름 조회
            Long memberId = null;
            String reviewerName = null;
            String memberSql = "SELECT member_id, name FROM member WHERE email = ?";
            try (PreparedStatement memberPstmt = con.prepareStatement(memberSql)) {
                memberPstmt.setString(1, userId);
                try (ResultSet memberRs = memberPstmt.executeQuery()) {
                    if (memberRs.next()) {
                        memberId = memberRs.getLong("member_id");
                        reviewerName = memberRs.getString("name");
                    }
                }
            }
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }
            if (reviewerName == null || reviewerName.trim().isEmpty()) {
                reviewerName = "익명"; // 이름이 없을 경우 기본값
            }

            // 1. 봉사 신청 확인 및 3일 이내 확인 (vol_end_date 기준)
            String checkSql = "SELECT vol_end_date AS volunteer_end_date, sel_cat AS selected_category, " +
                    "DATEDIFF(CURDATE(), vol_end_date) AS days_passed " +
                    "FROM vol_apply " +
                    "WHERE apply_id = ? AND member_id = ?";

            pstmt = con.prepareStatement(checkSql);
            pstmt.setLong(1, applicationId);
            pstmt.setLong(2, memberId);
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
            String checkReviewSql = "SELECT COUNT(*) FROM vol_review WHERE apply_id = ?";
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

            // 3. 리뷰 저장 (schema.sql에 맞춤: vol_review 테이블 사용)
            String insertSql = "INSERT INTO vol_review " +
                    "(member_id, apply_id, reviewer_nm, title, content, rating) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";

            pstmt = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setLong(1, memberId);
            pstmt.setLong(2, applicationId);
            pstmt.setString(3, reviewerName);
            pstmt.setString(4, title);
            pstmt.setString(5, content);
            if (rating != null) {
                pstmt.setInt(6, rating);
            } else {
                pstmt.setNull(6, java.sql.Types.INTEGER);
            }

            int result = pstmt.executeUpdate();

            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                long reviewId = 0;
                if (rs.next()) {
                    reviewId = rs.getLong(1);
                }

                // INSERT 성공 시 항상 success = true 설정
                response.put("success", true);
                if (reviewId > 0) {
                    response.put("reviewId", reviewId);
                }
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

            String sql = "SELECT vr.review_id, vr.reviewer_nm AS applicant_name, va.sel_cat AS selected_category, " +
                    "vr.title, vr.content, vr.rating, vr.created_at " +
                    "FROM vol_review vr " +
                    "JOIN vol_apply va ON vr.apply_id = va.apply_id " +
                    "WHERE vr.visible_yn = TRUE " +
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

    /**
     * 봉사활동 취소 API
     * 24시간 이내 취소 시 1주일간 봉사 신청 금지
     */
    @PostMapping("/cancel")
    public Map<String, Object> cancelVolunteerApplication(
            @RequestParam("applicationId") Long applicationId,
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

            logger.info("봉사활동 취소 요청 - userId: {}, applicationId: {}", userId, applicationId);

            con = dataSource.getConnection();

            // 신청 정보 및 봉사 예정일 조회
            String selectSql = "SELECT va.apply_id, va.status, va.vol_date AS volunteer_date, " +
                    "va.vol_time AS volunteer_time, m.member_id " +
                    "FROM vol_apply va " +
                    "JOIN member m ON va.member_id = m.member_id " +
                    "WHERE va.apply_id = ? AND m.email = ?";
            pstmt = con.prepareStatement(selectSql);
            pstmt.setLong(1, applicationId);
            pstmt.setString(2, userId);
            rs = pstmt.executeQuery();

            if (!rs.next()) {
                response.put("success", false);
                response.put("message", "해당 봉사 신청을 찾을 수 없습니다.");
                return response;
            }

            String status = rs.getString("status");
            Date volunteerDate = rs.getDate("volunteer_date");
            String volunteerTime = rs.getString("volunteer_time");
            Long memberId = rs.getLong("member_id");

            // 이미 취소된 경우
            if ("CANCELLED".equals(status)) {
                response.put("success", false);
                response.put("message", "이미 취소된 신청입니다.");
                return response;
            }

            // 완료된 경우
            if ("COMPLETED".equals(status)) {
                response.put("success", false);
                response.put("message", "완료된 봉사활동은 취소할 수 없습니다.");
                return response;
            }

            close(rs, pstmt);

            // 봉사 시작 시간 계산 (시간대별)
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(volunteerDate);

            int startHour = 9; // 기본값
            if ("PM".equals(volunteerTime) || "AFTERNOON".equals(volunteerTime) || "오후".equals(volunteerTime)) {
                startHour = 13;
            } else if ("EVENING".equals(volunteerTime) || "저녁".equals(volunteerTime)) {
                startHour = 18;
            }
            cal.set(java.util.Calendar.HOUR_OF_DAY, startHour);
            cal.set(java.util.Calendar.MINUTE, 0);
            cal.set(java.util.Calendar.SECOND, 0);

            java.util.Date volunteerStartTime = cal.getTime();
            java.util.Date now = new java.util.Date();

            // 24시간 이내인지 확인
            long diffMs = volunteerStartTime.getTime() - now.getTime();
            long hours24 = 24 * 60 * 60 * 1000;
            boolean isWithin24Hours = diffMs >= 0 && diffMs <= hours24;

            // 봉사활동 취소 (상태를 CANCELLED로 변경)
            String updateSql = "UPDATE vol_apply SET status = 'CANCELLED', " +
                    "cancel_rsn = ?, cancelled_at = NOW(), updated_at = NOW() " +
                    "WHERE apply_id = ?";
            pstmt = con.prepareStatement(updateSql);

            String cancelReason = isWithin24Hours ? "사용자 취소 (24시간 이내)" : "사용자 취소";
            pstmt.setString(1, cancelReason);
            pstmt.setLong(2, applicationId);

            int updated = pstmt.executeUpdate();

            if (updated > 0) {
                // 24시간 이내 취소인 경우 1주일 제한 설정 + 온도 감소
                if (isWithin24Hours) {
                    close(pstmt);

                    // member 테이블에 volunteer_ban_until 컬럼 업데이트
                    String banSql = "UPDATE member SET volunteer_ban_until = DATE_ADD(NOW(), INTERVAL 7 DAY) " +
                            "WHERE member_id = ?";
                    pstmt = con.prepareStatement(banSql);
                    pstmt.setLong(1, memberId);
                    pstmt.executeUpdate();

                    // 선행 온도 감소 (24시간 이내 취소 패널티)
                    if (temperatureService != null) {
                        try {
                            temperatureService.decreaseForVolunteerCancellation(userId);
                            logger.info("24시간 이내 취소로 선행온도 감소 - userId: {}", userId);
                        } catch (Exception e) {
                            logger.error("선행온도 감소 실패 - userId: {}", userId, e);
                        }
                    }

                    logger.info("24시간 이내 취소로 1주일 제한 적용 - memberId: {}", memberId);

                    response.put("success", true);
                    response.put("banned", true);
                    response.put("message", "봉사활동이 취소되었습니다. 봉사 시작 24시간 이내 취소로 인해 1주일간 봉사 신청이 제한되며 선행온도가 감소합니다.");
                } else {
                    response.put("success", true);
                    response.put("banned", false);
                    response.put("message", "봉사활동이 취소되었습니다.");
                }
            } else {
                response.put("success", false);
                response.put("message", "봉사활동 취소에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("봉사활동 취소 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "봉사활동 취소 중 오류가 발생했습니다: " + e.getMessage());
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

    /**
     * 봉사 경험 한글 값을 DB ENUM 값으로 변환
     * schema.sql ENUM: 'NONE', 'LT_1Y', '1Y_3Y', 'GT_3Y'
     */
    private String convertExperienceToEnum(String koreanExperience) {
        if (koreanExperience == null || koreanExperience.isEmpty()) {
            return "NONE";
        }

        switch (koreanExperience) {
            case "없음":
                return "NONE";
            case "1년 미만":
                return "LT_1Y";
            case "1-3년":
                return "1Y_3Y";
            case "3년 이상":
                return "GT_3Y";
            default:
                // 이미 ENUM 값인 경우 그대로 반환
                if (koreanExperience.equals("NONE") ||
                    koreanExperience.equals("LT_1Y") ||
                    koreanExperience.equals("1Y_3Y") ||
                    koreanExperience.equals("GT_3Y")) {
                    return koreanExperience;
                }
                logger.warn("알 수 없는 봉사 경험 값: {}, 기본값 NONE 사용", koreanExperience);
                return "NONE";
        }
    }
}
