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

            // 중복 확인
            String checkSql = "SELECT COUNT(*) FROM favorite_welfare_services WHERE user_id = ? AND service_id = ?";
            pstmt = con.prepareStatement(checkSql);
            pstmt.setString(1, userId);
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
                    "(user_id, service_id, service_name, service_purpose, department, apply_method, support_type, lifecycle_code) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, userId);
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

            String sql = "DELETE FROM favorite_welfare_services WHERE user_id = ? AND service_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);
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

            String sql = "SELECT COUNT(*) FROM favorite_welfare_services WHERE user_id = ? AND service_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);
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

            String sql = "INSERT INTO welfare_diagnoses " +
                    "(user_id, birth_date, gender, household_size, income_level, marital_status, " +
                    "children_count, employment_status, sido, sigungu, is_pregnant, is_disabled, " +
                    "is_multicultural, is_veteran, is_single_parent, matched_services_json, save_consent) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, userId);
            pstmt.setDate(2, java.sql.Date.valueOf(birthdate));
            pstmt.setString(3, gender);
            pstmt.setInt(4, householdSize);
            pstmt.setString(5, income);
            pstmt.setString(6, maritalStatus);
            pstmt.setInt(7, childrenCount);
            pstmt.setString(8, employmentStatus);
            pstmt.setString(9, sido);
            pstmt.setString(10, sigungu);
            pstmt.setBoolean(11, isPregnant);
            pstmt.setBoolean(12, isDisabled);
            pstmt.setBoolean(13, isMulticultural);
            pstmt.setBoolean(14, isVeteran);
            pstmt.setBoolean(15, isSingleParent);
            pstmt.setString(16, matchedServicesJson);
            pstmt.setBoolean(17, saveConsent);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    long diagnosisId = rs.getLong(1);
                    response.put("success", true);
                    response.put("diagnosisId", diagnosisId);
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
                dto.setIpAddress(rs.getString("ip_address"));
                dto.setUserAgent(rs.getString("user_agent"));
                dto.setReferrerUrl(rs.getString("referrer_url"));
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

            // 소유권 확인
            String checkSql = "SELECT user_id FROM welfare_diagnoses WHERE diagnosis_id = ?";
            pstmt = con.prepareStatement(checkSql);
            pstmt.setLong(1, diagnosisId);
            rs = pstmt.executeQuery();

            if (!rs.next()) {
                response.put("success", false);
                response.put("message", "진단 내역을 찾을 수 없습니다.");
                return response;
            }

            String ownerId = rs.getString("user_id");
            if (!userId.equals(ownerId)) {
                response.put("success", false);
                response.put("message", "삭제 권한이 없습니다.");
                return response;
            }

            rs.close();
            pstmt.close();

            // 삭제 실행
            String deleteSql = "DELETE FROM welfare_diagnoses WHERE diagnosis_id = ? AND user_id = ?";
            pstmt = con.prepareStatement(deleteSql);
            pstmt.setLong(1, diagnosisId);
            pstmt.setString(2, userId);

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
}
