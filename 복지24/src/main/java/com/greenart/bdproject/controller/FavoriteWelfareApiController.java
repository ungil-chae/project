package com.greenart.bdproject.controller;

import com.greenart.bdproject.dao.FavoriteWelfareServiceDao;
import com.greenart.bdproject.dao.ProjectMemberDao;
import com.greenart.bdproject.dto.FavoriteWelfareServiceDto;
import com.greenart.bdproject.dto.Member;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 즐겨찾기 복지 서비스 API 컨트롤러
 * URL 패턴: /api/favorite/*
 */
@RestController
@RequestMapping("/api/favorite")
public class FavoriteWelfareApiController {

    private static final Logger logger = LoggerFactory.getLogger(FavoriteWelfareApiController.class);

    @Autowired
    private FavoriteWelfareServiceDao favoriteDao;

    @Autowired
    private ProjectMemberDao memberDao;

    /**
     * 즐겨찾기 추가
     * POST /api/favorite/add
     */
    @PostMapping("/add")
    public Map<String, Object> addFavorite(
            @RequestParam("serviceId") String serviceId,
            @RequestParam("serviceName") String serviceName,
            @RequestParam(value = "servicePurpose", required = false) String servicePurpose,
            @RequestParam(value = "department", required = false) String department,
            @RequestParam(value = "applyMethod", required = false) String applyMethod,
            @RequestParam(value = "supportType", required = false) String supportType,
            @RequestParam(value = "lifecycleCode", required = false) String lifecycleCode,
            @RequestParam(value = "memo", required = false) String memo,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 로그인 확인
            String userEmail = (String) session.getAttribute("id");
            if (userEmail == null) {
                userEmail = (String) session.getAttribute("userId");
            }
            if (userEmail == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            // 회원 정보 조회
            Member member = memberDao.select(userEmail);
            if (member == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            Long memberId = member.getMemberId();

            // 이미 즐겨찾기에 있는지 확인
            if (favoriteDao.exists(memberId, serviceId)) {
                response.put("success", false);
                response.put("message", "이미 즐겨찾기에 추가된 서비스입니다.");
                return response;
            }

            // 즐겨찾기 추가
            FavoriteWelfareServiceDto favorite = new FavoriteWelfareServiceDto();
            favorite.setMemberId(memberId);
            favorite.setServiceId(serviceId);
            favorite.setServiceName(serviceName);
            favorite.setServicePurpose(servicePurpose);
            favorite.setDepartment(department);
            favorite.setApplyMethod(applyMethod);
            favorite.setSupportType(supportType);
            favorite.setLifecycleCode(lifecycleCode);
            favorite.setMemo(memo);

            int result = favoriteDao.insert(favorite);

            if (result > 0) {
                response.put("success", true);
                response.put("message", "즐겨찾기에 추가되었습니다.");
                logger.info("즐겨찾기 추가 성공 - memberId: {}, serviceId: {}", memberId, serviceId);
            } else {
                response.put("success", false);
                response.put("message", "즐겨찾기 추가에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("즐겨찾기 추가 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "즐겨찾기 추가 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 즐겨찾기 삭제
     * POST /api/favorite/remove
     */
    @PostMapping("/remove")
    public Map<String, Object> removeFavorite(
            @RequestParam("serviceId") String serviceId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 로그인 확인
            String userEmail = (String) session.getAttribute("id");
            if (userEmail == null) {
                userEmail = (String) session.getAttribute("userId");
            }
            if (userEmail == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            // 회원 정보 조회
            Member member = memberDao.select(userEmail);
            if (member == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            Long memberId = member.getMemberId();

            // 즐겨찾기 삭제
            int result = favoriteDao.delete(memberId, serviceId);

            if (result > 0) {
                response.put("success", true);
                response.put("message", "즐겨찾기에서 삭제되었습니다.");
                logger.info("즐겨찾기 삭제 성공 - memberId: {}, serviceId: {}", memberId, serviceId);
            } else {
                response.put("success", false);
                response.put("message", "즐겨찾기에 해당 서비스가 없습니다.");
            }

        } catch (Exception e) {
            logger.error("즐겨찾기 삭제 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "즐겨찾기 삭제 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 즐겨찾기 목록 조회
     * GET /api/favorite/list
     */
    @GetMapping("/list")
    public Map<String, Object> getFavoriteList(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            // 로그인 확인
            String userEmail = (String) session.getAttribute("id");
            if (userEmail == null) {
                userEmail = (String) session.getAttribute("userId");
            }
            if (userEmail == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            // 회원 정보 조회
            Member member = memberDao.select(userEmail);
            if (member == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            Long memberId = member.getMemberId();

            // 즐겨찾기 목록 조회
            List<FavoriteWelfareServiceDto> favorites = favoriteDao.selectByMemberId(memberId);

            response.put("success", true);
            response.put("data", favorites);
            response.put("count", favorites.size());
            logger.info("즐겨찾기 목록 조회 성공 - memberId: {}, count: {}", memberId, favorites.size());

        } catch (Exception e) {
            logger.error("즐겨찾기 목록 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "즐겨찾기 목록 조회 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 즐겨찾기 여부 확인
     * GET /api/favorite/check
     */
    @GetMapping("/check")
    public Map<String, Object> checkFavorite(
            @RequestParam("serviceId") String serviceId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 로그인 확인
            String userEmail = (String) session.getAttribute("id");
            if (userEmail == null) {
                userEmail = (String) session.getAttribute("userId");
            }
            if (userEmail == null) {
                response.put("success", false);
                response.put("isFavorite", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            // 회원 정보 조회
            Member member = memberDao.select(userEmail);
            if (member == null) {
                response.put("success", false);
                response.put("isFavorite", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            Long memberId = member.getMemberId();

            // 즐겨찾기 여부 확인
            boolean isFavorite = favoriteDao.exists(memberId, serviceId);

            response.put("success", true);
            response.put("isFavorite", isFavorite);

        } catch (Exception e) {
            logger.error("즐겨찾기 확인 중 오류 발생", e);
            response.put("success", false);
            response.put("isFavorite", false);
            response.put("message", "즐겨찾기 확인 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 즐겨찾기 토글 (추가/삭제)
     * POST /api/favorite/toggle
     */
    @PostMapping("/toggle")
    public Map<String, Object> toggleFavorite(
            @RequestParam("serviceId") String serviceId,
            @RequestParam("serviceName") String serviceName,
            @RequestParam(value = "servicePurpose", required = false) String servicePurpose,
            @RequestParam(value = "department", required = false) String department,
            @RequestParam(value = "applyMethod", required = false) String applyMethod,
            @RequestParam(value = "supportType", required = false) String supportType,
            @RequestParam(value = "lifecycleCode", required = false) String lifecycleCode,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 로그인 확인
            String userEmail = (String) session.getAttribute("id");
            if (userEmail == null) {
                userEmail = (String) session.getAttribute("userId");
            }
            if (userEmail == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            // 회원 정보 조회
            Member member = memberDao.select(userEmail);
            if (member == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            Long memberId = member.getMemberId();

            // 즐겨찾기 여부 확인
            boolean exists = favoriteDao.exists(memberId, serviceId);

            if (exists) {
                // 이미 있으면 삭제
                int result = favoriteDao.delete(memberId, serviceId);
                if (result > 0) {
                    response.put("success", true);
                    response.put("action", "removed");
                    response.put("isFavorite", false);
                    response.put("message", "즐겨찾기에서 삭제되었습니다.");
                    logger.info("즐겨찾기 삭제 (토글) - memberId: {}, serviceId: {}", memberId, serviceId);
                } else {
                    response.put("success", false);
                    response.put("message", "즐겨찾기 삭제에 실패했습니다.");
                }
            } else {
                // 없으면 추가
                FavoriteWelfareServiceDto favorite = new FavoriteWelfareServiceDto();
                favorite.setMemberId(memberId);
                favorite.setServiceId(serviceId);
                favorite.setServiceName(serviceName);
                favorite.setServicePurpose(servicePurpose);
                favorite.setDepartment(department);
                favorite.setApplyMethod(applyMethod);
                favorite.setSupportType(supportType);
                favorite.setLifecycleCode(lifecycleCode);

                int result = favoriteDao.insert(favorite);
                if (result > 0) {
                    response.put("success", true);
                    response.put("action", "added");
                    response.put("isFavorite", true);
                    response.put("message", "즐겨찾기에 추가되었습니다.");
                    logger.info("즐겨찾기 추가 (토글) - memberId: {}, serviceId: {}", memberId, serviceId);
                } else {
                    response.put("success", false);
                    response.put("message", "즐겨찾기 추가에 실패했습니다.");
                }
            }

        } catch (Exception e) {
            logger.error("즐겨찾기 토글 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "즐겨찾기 처리 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }
}
