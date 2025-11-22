package com.greenart.bdproject.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.greenart.bdproject.dto.Member;
import com.greenart.bdproject.dao.ProjectMemberDao;

/**
 * 회원 관리 API 컨트롤러
 * URL 패턴: /api/member/*
 */
@RestController
@RequestMapping("/api/member")
public class MemberApiController {

    private static final Logger logger = LoggerFactory.getLogger(MemberApiController.class);

    @Autowired
    private ProjectMemberDao memberDao;

    /**
     * 비밀번호 변경
     * @PostMapping("/api/member/changePassword")
     */
    @PostMapping("/changePassword")
    public Map<String, Object> changePassword(
            @RequestParam("currentPassword") String currentPassword,
            @RequestParam("newPassword") String newPassword,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 세션에서 사용자 ID 가져오기
            String userId = (String) session.getAttribute("id");
            if (userId == null) {
                userId = (String) session.getAttribute("userId");
            }

            logger.info("=== 비밀번호 변경 요청 ===");
            logger.info("userId: {}", userId);

            if (userId == null) {
                logger.warn("로그인되지 않은 사용자의 비밀번호 변경 시도");
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            // 현재 사용자 정보 조회
            Member member = memberDao.select(userId);
            if (member == null) {
                logger.warn("사용자를 찾을 수 없음: {}", userId);
                response.put("success", false);
                response.put("message", "사용자 정보를 찾을 수 없습니다.");
                return response;
            }

            // 현재 비밀번호 확인
            if (!currentPassword.equals(member.getPwd())) {
                logger.warn("현재 비밀번호 불일치: {}", userId);
                response.put("success", false);
                response.put("message", "현재 비밀번호가 일치하지 않습니다.");
                return response;
            }

            // 새 비밀번호 유효성 검사
            if (newPassword == null || newPassword.length() < 8) {
                response.put("success", false);
                response.put("message", "새 비밀번호는 8자 이상이어야 합니다.");
                return response;
            }

            // 비밀번호 업데이트
            member.setPwd(newPassword);
            logger.info("비밀번호 업데이트 시작: {}", userId);
            int result = memberDao.update(member);
            logger.info("비밀번호 업데이트 결과: {}", result);

            if (result > 0) {
                response.put("success", true);
                response.put("message", "비밀번호가 성공적으로 변경되었습니다.");
                logger.info("비밀번호 변경 성공: {}", userId);
            } else {
                response.put("success", false);
                response.put("message", "비밀번호 변경에 실패했습니다.");
                logger.error("비밀번호 업데이트 실패: result={}", result);
            }

        } catch (Exception e) {
            logger.error("비밀번호 변경 처리 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "비밀번호 변경 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }
}
