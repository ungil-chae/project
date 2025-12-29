package com.greenart.bdproject.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.greenart.bdproject.dao.HiddenActivityDao;
import com.greenart.bdproject.dao.ProjectMemberDao;
import com.greenart.bdproject.dto.Member;

/**
 * 최근 활동 숨김 처리 REST API 컨트롤러
 *
 * @author Claude Code
 * @version 1.0.0
 */
@RestController
@RequestMapping("/api/hidden-activities")
public class HiddenActivityApiController {

    private static final Logger logger = LoggerFactory.getLogger(HiddenActivityApiController.class);

    @Autowired
    private HiddenActivityDao hiddenActivityDao;

    @Autowired
    private ProjectMemberDao projectMemberDao;

    /**
     * 활동 숨김 처리
     *
     * @param activityType 활동 유형 (VOLUNTEER, DONATION)
     * @param activityId 활동 ID
     * @param session HTTP 세션
     * @return 처리 결과
     */
    @PostMapping
    public ResponseEntity<Map<String, Object>> hideActivity(
            @RequestParam("activityType") String activityType,
            @RequestParam("activityId") Long activityId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 세션에서 회원 ID 가져오기
            Long memberId = getMemberIdFromSession(session);
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            // 활동 타입 검증
            if (!"VOLUNTEER".equals(activityType) && !"DONATION".equals(activityType)) {
                response.put("success", false);
                response.put("message", "잘못된 활동 유형입니다.");
                return ResponseEntity.badRequest().body(response);
            }

            // 숨김 처리
            int result = hiddenActivityDao.hideActivity(memberId, activityType, activityId);

            if (result > 0) {
                response.put("success", true);
                response.put("message", "활동이 숨김 처리되었습니다.");
                logger.info("활동 숨김 처리 성공 - memberId: {}, type: {}, id: {}", new Object[]{memberId, activityType, activityId});
            } else {
                response.put("success", false);
                response.put("message", "숨김 처리에 실패했습니다.");
            }

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("활동 숨김 처리 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "서버 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 활동 숨김 해제
     *
     * @param activityType 활동 유형
     * @param activityId 활동 ID
     * @param session HTTP 세션
     * @return 처리 결과
     */
    @DeleteMapping("/{activityType}/{activityId}")
    public ResponseEntity<Map<String, Object>> unhideActivity(
            @PathVariable("activityType") String activityType,
            @PathVariable("activityId") Long activityId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long memberId = getMemberIdFromSession(session);
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            int result = hiddenActivityDao.unhideActivity(memberId, activityType, activityId);

            if (result > 0) {
                response.put("success", true);
                response.put("message", "숨김이 해제되었습니다.");
                logger.info("활동 숨김 해제 성공 - memberId: {}, type: {}, id: {}", new Object[]{memberId, activityType, activityId});
            } else {
                response.put("success", false);
                response.put("message", "숨김 해제에 실패했습니다.");
            }

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("활동 숨김 해제 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "서버 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 회원의 숨긴 활동 ID 목록 조회
     *
     * @param activityType 활동 유형
     * @param session HTTP 세션
     * @return 숨긴 활동 ID 목록
     */
    @GetMapping("/{activityType}")
    public ResponseEntity<Map<String, Object>> getHiddenActivityIds(
            @PathVariable("activityType") String activityType,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long memberId = getMemberIdFromSession(session);
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            List<Long> hiddenIds = hiddenActivityDao.getHiddenActivityIds(memberId, activityType);

            response.put("success", true);
            response.put("hiddenIds", hiddenIds);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("숨긴 활동 목록 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "서버 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 회원의 모든 숨김 활동 삭제 (전체 삭제)
     *
     * @param session HTTP 세션
     * @return 처리 결과
     */
    @DeleteMapping("/all")
    public ResponseEntity<Map<String, Object>> deleteAllHidden(HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long memberId = getMemberIdFromSession(session);
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            int result = hiddenActivityDao.deleteAllHidden(memberId);

            response.put("success", true);
            response.put("deletedCount", result);
            response.put("message", result + "개의 숨긴 활동이 삭제되었습니다.");
            logger.info("전체 숨김 활동 삭제 완료 - memberId: {}, count: {}", new Object[]{memberId, result});

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("전체 숨김 활동 삭제 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "서버 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 세션에서 회원 ID 추출
     *
     * @param session HTTP 세션
     * @return 회원 ID (없으면 null)
     */
    private Long getMemberIdFromSession(HttpSession session) {
        try {
            String email = (String) session.getAttribute("id");
            if (email == null || email.isEmpty()) {
                return null;
            }

            Member member = projectMemberDao.select(email);
            return member != null ? member.getMemberId() : null;

        } catch (Exception e) {
            logger.error("세션에서 회원 ID 추출 중 오류", e);
            return null;
        }
    }
}
