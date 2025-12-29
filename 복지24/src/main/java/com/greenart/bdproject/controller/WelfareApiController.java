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
