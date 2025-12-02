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
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.greenart.bdproject.dto.FavoriteWelfareServiceDto;
import com.greenart.bdproject.dto.WelfareDiagnosisDto;
import com.greenart.bdproject.service.KindnessTemperatureService;

/**
 * 복지 서비스 API 컨트롤러
 * URL 패턴: /api/welfare/*
 */
@RestController
@RequestMapping("/api/welfare")
public class WelfareApiController {

    private static final Logger logger = LoggerFactory.getLogger(WelfareApiController.class);

    @Autowired
    private DataSource dataSource;

    @Autowired(required = false)
    private KindnessTemperatureService temperatureService;

    /**
     * 관심 복지 서비스 추가 (즐겨찾기)
     * @PostMapping("/api/welfare/favorite/add")
     */
    @PostMapping("/favorite/add")
    public Map<String, Object> addFavorite(
            @RequestParam("serviceId") String serviceId,
            @RequestParam("serviceName") String serviceName,
            @RequestParam(value = "servicePurpose", required = false) String servicePurpose,
            @RequestParam(value = "department", required = false) String department,
            @RequestParam(value = "applyMethod", required = false) String applyMethod,
            @RequestParam(value = "supportType", required = false) String supportType,
            @RequestParam(value = "lifecycleCode", required = false) String lifecycleCode,
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

            logger.info("=== 관심 복지 서비스 추가 ===");
            logger.info("userId: {}, serviceId: {}", userId, serviceId);
            logger.info("serviceName: {}", serviceName);

            con = dataSource.getConnection();

            // member_id 조회
            Long memberId = null;
            String memberSql = "SELECT member_id FROM member WHERE email = ?";
            try (PreparedStatement memberPstmt = con.prepareStatement(memberSql)) {
                memberPstmt.setString(1, userId);
                try (ResultSet memberRs = memberPstmt.executeQuery()) {
                    if (memberRs.next()) {
                        memberId = memberRs.getLong("member_id");
                    }
                }
            }
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            // 중복 확인
            String checkSql = "SELECT COUNT(*) FROM favorite_welfare_services WHERE member_id = ? AND service_id = ?";
            pstmt = con.prepareStatement(checkSql);
            pstmt.setLong(1, memberId);
            pstmt.setString(2, serviceId);
            rs = pstmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                response.put("success", false);
                response.put("message", "이미 관심 서비스로 등록되어 있습니다.");
                return response;
            }

            rs.close();
            pstmt.close();

            // 저장
            String sql = "INSERT INTO favorite_welfare_services " +
                    "(member_id, service_id, service_name, service_purpose, department, apply_method, support_type, lifecycle_code) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setLong(1, memberId);
            pstmt.setString(2, serviceId);
            pstmt.setString(3, serviceName);
            pstmt.setString(4, servicePurpose);
            pstmt.setString(5, department);
            pstmt.setString(6, applyMethod);
            pstmt.setString(7, supportType);
            pstmt.setString(8, lifecycleCode);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    long favoriteId = rs.getLong(1);
                    response.put("success", true);
                    response.put("favoriteId", favoriteId);
                    response.put("message", "관심 서비스로 등록되었습니다.");
                    logger.info("관심 서비스 등록 성공 - favoriteId: {}", favoriteId);
                } else {
                    // 생성된 키를 가져오지 못했지만 insert는 성공
                    response.put("success", true);
                    response.put("message", "관심 서비스로 등록되었습니다.");
                    logger.info("관심 서비스 등록 성공 (generated key 없음)");
                }
            } else {
                response.put("success", false);
                response.put("message", "등록에 실패했습니다.");
            }

        } catch (SQLException e) {
            logger.error("관심 서비스 등록 중 SQL 오류 발생", e);
            response.put("success", false);
            response.put("message", "등록 중 오류가 발생했습니다: " + e.getMessage());
        } catch (Exception e) {
            logger.error("관심 서비스 등록 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "등록 중 오류가 발생했습니다: " + e.getMessage());
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    /**
     * 관심 복지 서비스 삭제
     * @DeleteMapping("/api/welfare/favorite/remove")
     */
    @DeleteMapping("/favorite/remove")
    public Map<String, Object> removeFavorite(
            @RequestParam("serviceId") String serviceId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;

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

            // member_id 조회
            Long memberId = null;
            String memberSql = "SELECT member_id FROM member WHERE email = ?";
            try (PreparedStatement memberPstmt = con.prepareStatement(memberSql)) {
                memberPstmt.setString(1, userId);
                try (ResultSet memberRs = memberPstmt.executeQuery()) {
                    if (memberRs.next()) {
                        memberId = memberRs.getLong("member_id");
                    }
                }
            }
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            String sql = "DELETE FROM favorite_welfare_services WHERE member_id = ? AND service_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, memberId);
            pstmt.setString(2, serviceId);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                response.put("success", true);
                response.put("message", "관심 서비스가 삭제되었습니다.");
                logger.info("관심 서비스 삭제 성공 - userId: {}, serviceId: {}", userId, serviceId);
            } else {
                response.put("success", false);
                response.put("message", "삭제할 서비스를 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            logger.error("관심 서비스 삭제 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "삭제 중 오류가 발생했습니다.");
        } finally {
            close(pstmt, con);
        }

        return response;
    }

    /**
     * 내 관심 복지 서비스 목록 조회
     * @GetMapping("/api/welfare/favorite/list")
     */
    @GetMapping("/favorite/list")
    public Map<String, Object> getFavoriteList(HttpSession session) {

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
            // 복합 PK (member_id, service_id), favorite_id 없음
            String sql = "SELECT fws.* " +
                    "FROM favorite_welfare_services fws " +
                    "JOIN member m ON fws.member_id = m.member_id " +
                    "WHERE m.email = ? " +
                    "ORDER BY fws.created_at DESC";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);  // userId는 email
            rs = pstmt.executeQuery();

            List<FavoriteWelfareServiceDto> favorites = new ArrayList<>();

            while (rs.next()) {
                FavoriteWelfareServiceDto dto = new FavoriteWelfareServiceDto();
                dto.setMemberId(rs.getLong("member_id"));
                dto.setServiceId(rs.getString("service_id"));
                dto.setServiceName(rs.getString("service_name"));
                dto.setServicePurpose(rs.getString("service_purpose"));
                dto.setDepartment(rs.getString("department"));
                dto.setApplyMethod(rs.getString("apply_method"));
                dto.setSupportType(rs.getString("support_type"));
                dto.setLifecycleCode(rs.getString("lifecycle_code"));
                dto.setMemo(rs.getString("memo"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));

                favorites.add(dto);
            }

            response.put("success", true);
            response.put("data", favorites);
            logger.info("관심 서비스 조회 성공 - userId: {}, count: {}", userId, favorites.size());

        } catch (Exception e) {
            logger.error("관심 서비스 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "조회 중 오류가 발생했습니다.");
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    /**
     * 특정 서비스의 즐겨찾기 여부 확인
     * @GetMapping("/api/welfare/favorite/check")
     */
    @GetMapping("/favorite/check")
    public Map<String, Object> checkFavorite(
            @RequestParam("serviceId") String serviceId,
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
                response.put("isFavorite", false);
                return response;
            }

            con = dataSource.getConnection();

            // member_id 조회
            Long memberId = null;
            String memberSql = "SELECT member_id FROM member WHERE email = ?";
            try (PreparedStatement memberPstmt = con.prepareStatement(memberSql)) {
                memberPstmt.setString(1, userId);
                try (ResultSet memberRs = memberPstmt.executeQuery()) {
                    if (memberRs.next()) {
                        memberId = memberRs.getLong("member_id");
                    }
                }
            }
            if (memberId == null) {
                response.put("isFavorite", false);
                return response;
            }

            String sql = "SELECT COUNT(*) FROM favorite_welfare_services WHERE member_id = ? AND service_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, memberId);
            pstmt.setString(2, serviceId);
            rs = pstmt.executeQuery();

            boolean isFavorite = false;
            if (rs.next()) {
                isFavorite = rs.getInt(1) > 0;
            }

            response.put("isFavorite", isFavorite);

        } catch (Exception e) {
            logger.error("즐겨찾기 확인 중 오류 발생", e);
            response.put("isFavorite", false);
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    /**
     * 복지 진단 결과 저장
     * @PostMapping("/api/welfare/diagnosis/save")
     */
    @PostMapping("/diagnosis/save")
    public Map<String, Object> saveDiagnosis(
            @RequestParam("birthdate") String birthdate,
            @RequestParam("gender") String gender,
            @RequestParam("household_size") Integer householdSize,
            @RequestParam("income") String income,
            @RequestParam("marital_status") String maritalStatus,
            @RequestParam("children_count") Integer childrenCount,
            @RequestParam("employment_status") String employmentStatus,
            @RequestParam("sido") String sido,
            @RequestParam("sigungu") String sigungu,
            @RequestParam(value = "isPregnant", defaultValue = "false") Boolean isPregnant,
            @RequestParam(value = "isDisabled", defaultValue = "false") Boolean isDisabled,
            @RequestParam(value = "isMulticultural", defaultValue = "false") Boolean isMulticultural,
            @RequestParam(value = "isVeteran", defaultValue = "false") Boolean isVeteran,
            @RequestParam(value = "isSingleParent", defaultValue = "false") Boolean isSingleParent,
            @RequestParam(value = "matchedServices", required = false) String matchedServicesJson,
            @RequestParam(value = "saveConsent", defaultValue = "true") Boolean saveConsent,
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

            logger.info("=== 복지 진단 저장 ===");
            logger.info("userId: {}, birthdate: {}", userId, birthdate);

            con = dataSource.getConnection();

            // member_id 조회
            Long memberId = null;
            String memberSql = "SELECT member_id FROM member WHERE email = ?";
            try (PreparedStatement memberPstmt = con.prepareStatement(memberSql)) {
                memberPstmt.setString(1, userId);
                try (ResultSet memberRs = memberPstmt.executeQuery()) {
                    if (memberRs.next()) {
                        memberId = memberRs.getLong("member_id");
                    }
                }
            }
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            // 나이 계산
            java.time.LocalDate birthLocalDate = java.time.LocalDate.parse(birthdate);
            int age = java.time.Period.between(birthLocalDate, java.time.LocalDate.now()).getYears();

            // income 값을 ENUM 형식으로 변환 (LEVEL_1, LEVEL_2, LEVEL_3, LEVEL_4, LEVEL_5)
            String incomeLevel = convertToIncomeLevel(income);
            if (incomeLevel == null) {
                response.put("success", false);
                response.put("message", "잘못된 소득 수준입니다. (1-5 또는 LEVEL_1-LEVEL_5)");
                return response;
            }

            // schema.sql에 맞춤: member_id, age, matched_services 사용
            String sql = "INSERT INTO welfare_diagnoses " +
                    "(member_id, birth_date, age, gender, household_size, income_level, marital_status, " +
                    "children_count, employment_status, sido, sigungu, is_pregnant, is_disabled, " +
                    "is_multicultural, is_veteran, is_single_parent, matched_services, save_consent) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setLong(1, memberId);
            pstmt.setDate(2, java.sql.Date.valueOf(birthdate));
            pstmt.setInt(3, age);  // 나이 추가
            pstmt.setString(4, gender.toUpperCase()); // ENUM: MALE, FEMALE, OTHER
            pstmt.setInt(5, householdSize);
            pstmt.setString(6, incomeLevel);
            pstmt.setString(7, maritalStatus.toUpperCase()); // ENUM
            pstmt.setInt(8, childrenCount);
            pstmt.setString(9, employmentStatus.toUpperCase()); // ENUM
            pstmt.setString(10, sido);
            pstmt.setString(11, sigungu);
            pstmt.setBoolean(12, isPregnant);
            pstmt.setBoolean(13, isDisabled);
            pstmt.setBoolean(14, isMulticultural);
            pstmt.setBoolean(15, isVeteran);
            pstmt.setBoolean(16, isSingleParent);
            pstmt.setString(17, matchedServicesJson);
            pstmt.setBoolean(18, saveConsent);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                long diagnosisId = 0;
                if (rs.next()) {
                    diagnosisId = rs.getLong(1);
                }

                // INSERT 성공 시 항상 success = true 설정
                response.put("success", true);
                if (diagnosisId > 0) {
                    response.put("diagnosisId", diagnosisId);
                }
                response.put("message", "진단 결과가 저장되었습니다.");
                logger.info("진단 저장 성공 - diagnosisId: {}", diagnosisId);

                // 선행온도 증가
                if (temperatureService != null) {
                    try {
                        temperatureService.increaseForWelfareDiagnosis(userId);
                    } catch (Exception e) {
                        logger.warn("선행온도 증가 실패 (진단 저장은 성공): {}", e.getMessage());
                    }
                }
            } else {
                response.put("success", false);
                response.put("message", "저장에 실패했습니다.");
            }

        } catch (SQLException e) {
            logger.error("진단 저장 중 SQL 오류 발생", e);
            response.put("success", false);
            response.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
        } catch (Exception e) {
            logger.error("진단 저장 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    /**
     * 내 진단 내역 조회
     * @GetMapping("/api/welfare/diagnosis/my")
     */
    @GetMapping("/diagnosis/my")
    public Map<String, Object> getMyDiagnoses(HttpSession session) {

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
            String sql = "SELECT wd.* " +
                    "FROM welfare_diagnoses wd " +
                    "JOIN member m ON wd.member_id = m.member_id " +
                    "WHERE m.email = ? " +
                    "ORDER BY wd.created_at DESC";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);  // userId는 email
            rs = pstmt.executeQuery();

            List<WelfareDiagnosisDto> diagnoses = new ArrayList<>();

            while (rs.next()) {
                WelfareDiagnosisDto dto = new WelfareDiagnosisDto();
                dto.setDiagnosisId(rs.getLong("diagnosis_id"));
                dto.setMemberId(rs.getLong("member_id"));
                dto.setBirthDate(rs.getDate("birth_date"));
                dto.setAge(rs.getByte("age"));
                dto.setGender(rs.getString("gender"));
                dto.setHouseholdSize(rs.getByte("household_size"));
                dto.setIncomeLevel(rs.getString("income_level"));
                dto.setMonthlyIncome(rs.getBigDecimal("monthly_income"));
                dto.setMaritalStatus(rs.getString("marital_status"));
                dto.setChildrenCount(rs.getByte("children_count"));
                dto.setEmploymentStatus(rs.getString("employment_status"));
                dto.setSido(rs.getString("sido"));
                dto.setSigungu(rs.getString("sigungu"));
                dto.setIsPregnant(rs.getBoolean("is_pregnant"));
                dto.setIsDisabled(rs.getBoolean("is_disabled"));
                dto.setDisabilityGrade(rs.getByte("disability_grade"));
                dto.setIsMulticultural(rs.getBoolean("is_multicultural"));
                dto.setIsVeteran(rs.getBoolean("is_veteran"));
                dto.setIsSingleParent(rs.getBoolean("is_single_parent"));
                dto.setIsElderlyLivingAlone(rs.getBoolean("is_elderly_living_alone"));
                dto.setIsLowIncome(rs.getBoolean("is_low_income"));
                dto.setMatchedServices(rs.getString("matched_services"));
                dto.setMatchedServicesCount(rs.getShort("matched_services_count"));
                dto.setTotalMatchingScore(rs.getInt("total_matching_score"));
                dto.setSaveConsent(rs.getBoolean("save_consent"));
                dto.setPrivacyConsent(rs.getBoolean("privacy_consent"));
                dto.setMarketingConsent(rs.getBoolean("marketing_consent"));
                // ip_address, user_agent, referrer_url 컬럼은 스키마에서 제거됨
                dto.setCreatedAt(rs.getTimestamp("created_at"));

                diagnoses.add(dto);
            }

            response.put("success", true);
            response.put("data", diagnoses);
            logger.info("진단 내역 조회 성공 - userId: {}, count: {}", userId, diagnoses.size());

        } catch (Exception e) {
            logger.error("진단 내역 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "조회 중 오류가 발생했습니다.");
        } finally {
            close(rs, pstmt, con);
        }

        return response;
    }

    /**
     * 복지 진단 내역 삭제
     * @DeleteMapping("/api/welfare/diagnosis/delete")
     */
    @DeleteMapping("/diagnosis/delete")
    public Map<String, Object> deleteDiagnosis(
            @RequestParam("diagnosisId") Long diagnosisId,
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

            logger.info("=== 복지 진단 내역 삭제 ===");
            logger.info("userId: {}, diagnosisId: {}", userId, diagnosisId);

            con = dataSource.getConnection();

            // member_id 조회
            Long memberId = null;
            String memberSql = "SELECT member_id FROM member WHERE email = ?";
            try (PreparedStatement memberPstmt = con.prepareStatement(memberSql)) {
                memberPstmt.setString(1, userId);
                try (ResultSet memberRs = memberPstmt.executeQuery()) {
                    if (memberRs.next()) {
                        memberId = memberRs.getLong("member_id");
                    }
                }
            }
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            // 소유권 확인
            String checkSql = "SELECT member_id FROM welfare_diagnoses WHERE diagnosis_id = ?";
            pstmt = con.prepareStatement(checkSql);
            pstmt.setLong(1, diagnosisId);
            rs = pstmt.executeQuery();

            if (!rs.next()) {
                response.put("success", false);
                response.put("message", "진단 내역을 찾을 수 없습니다.");
                return response;
            }

            Long ownerId = rs.getLong("member_id");
            if (!memberId.equals(ownerId)) {
                response.put("success", false);
                response.put("message", "삭제 권한이 없습니다.");
                return response;
            }

            rs.close();
            pstmt.close();

            // 삭제 실행
            String deleteSql = "DELETE FROM welfare_diagnoses WHERE diagnosis_id = ? AND member_id = ?";
            pstmt = con.prepareStatement(deleteSql);
            pstmt.setLong(1, diagnosisId);
            pstmt.setLong(2, memberId);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                response.put("success", true);
                response.put("message", "복지 진단 내역이 삭제되었습니다.");
                logger.info("진단 내역 삭제 성공 - diagnosisId: {}", diagnosisId);
            } else {
                response.put("success", false);
                response.put("message", "삭제에 실패했습니다.");
            }

        } catch (SQLException e) {
            logger.error("진단 내역 삭제 중 SQL 오류 발생", e);
            response.put("success", false);
            response.put("message", "삭제 중 오류가 발생했습니다: " + e.getMessage());
        } catch (Exception e) {
            logger.error("진단 내역 삭제 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "삭제 중 오류가 발생했습니다: " + e.getMessage());
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
     * income 값을 ENUM 형식으로 변환
     * @param income - 입력된 소득 수준 (1, 2, 3, 4, 5 또는 LEVEL_1, LEVEL_2, LEVEL_3, LEVEL_4, LEVEL_5)
     * @return LEVEL_1 ~ LEVEL_5 형식의 문자열, 유효하지 않으면 null
     */
    private String convertToIncomeLevel(String income) {
        if (income == null || income.trim().isEmpty()) {
            return "LEVEL_3"; // 기본값: 중간 수준
        }

        income = income.trim();

        // 이미 LEVEL_X 형식인 경우
        if (income.matches("LEVEL_[1-5]")) {
            return income;
        }

        // 숫자만 있는 경우 (1, 2, 3, 4, 5)
        if (income.matches("[1-5]")) {
            return "LEVEL_" + income;
        }

        // 한글 또는 기타 형식을 숫자로 변환
        switch (income.toLowerCase()) {
            case "저소득층":
            case "기초생활수급자":
            case "차상위계층":
            case "1":
            case "level_1":
                return "LEVEL_1";
            case "저소득":
            case "2":
            case "level_2":
                return "LEVEL_2";
            case "중산층":
            case "보통":
            case "중간":
            case "3":
            case "level_3":
                return "LEVEL_3";
            case "중상층":
            case "4":
            case "level_4":
                return "LEVEL_4";
            case "고소득층":
            case "상위층":
            case "5":
            case "level_5":
                return "LEVEL_5";
            case "none":
            case "unknown":
            case "미선택":
            case "미입력":
            case "선택안함":
                logger.info("소득 수준 미선택, 기본값(LEVEL_3) 사용: {}", income);
                return "LEVEL_3"; // 기본값: 중간 수준
            default:
                logger.warn("알 수 없는 소득 수준: {}, 기본값(LEVEL_3) 사용", income);
                return "LEVEL_3"; // 알 수 없는 값도 기본값으로 저장 허용
        }
    }
}
