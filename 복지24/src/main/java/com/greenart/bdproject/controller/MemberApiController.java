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
import com.greenart.bdproject.dao.PasswordHistoryDao;
import com.greenart.bdproject.dao.ProjectMemberDao;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.List;

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

    @Autowired
    private PasswordHistoryDao passwordHistoryDao;

    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    /**
     * 회원 정보 조회
     * @GetMapping("/api/member/info")
     */
    @GetMapping("/info")
    public Map<String, Object> getMemberInfo(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");
            if (userId == null) {
                userId = (String) session.getAttribute("userId");
            }

            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            Member member = memberDao.select(userId);
            if (member == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            // 회원 정보 반환 (비밀번호 제외)
            Map<String, Object> memberData = new HashMap<>();
            memberData.put("memberId", member.getMemberId());
            memberData.put("name", member.getName());
            memberData.put("email", member.getEmail());
            memberData.put("phone", member.getPhone());
            memberData.put("birth", member.getBirth() != null ? member.getBirth().toString() : null);
            memberData.put("gender", member.getGender());
            memberData.put("postcode", member.getPostcode());
            memberData.put("address", member.getAddress());
            memberData.put("detailAddress", member.getDetailAddress());
            memberData.put("role", member.getRole());
            memberData.put("kindnessTemperature", member.getKindnessTemperature());
            memberData.put("createdAt", member.getCreatedAt() != null ? member.getCreatedAt().toString() : null);

            response.put("success", true);
            response.put("data", memberData);
            logger.info("회원 정보 조회 성공: {}", userId);

        } catch (Exception e) {
            logger.error("회원 정보 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "회원 정보 조회 중 오류가 발생했습니다.");
        }

        return response;
    }

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

            // 현재 비밀번호 확인 (BCrypt 해시 또는 평문 둘 다 지원)
            String storedPassword = member.getPwd();
            boolean passwordMatch = false;

            // BCrypt로 해시된 비밀번호인지 확인 ($2a$, $2b$, $2y$로 시작)
            if (storedPassword != null && storedPassword.startsWith("$2")) {
                // BCrypt 해시 비교
                passwordMatch = passwordEncoder.matches(currentPassword, storedPassword);
                logger.info("BCrypt 비밀번호 비교 수행");
            } else {
                // 평문 비교 (레거시 지원)
                passwordMatch = currentPassword.equals(storedPassword);
                logger.info("평문 비밀번호 비교 수행");
            }

            if (!passwordMatch) {
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

            // 특수문자 포함 여부 검사
            String specialCharPattern = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*";
            if (!newPassword.matches(specialCharPattern)) {
                response.put("success", false);
                response.put("message", "새 비밀번호는 특수문자를 최소 1개 이상 포함해야 합니다.");
                return response;
            }

            // 영문자 포함 여부 검사
            if (!newPassword.matches(".*[a-zA-Z].*")) {
                response.put("success", false);
                response.put("message", "새 비밀번호는 영문자를 최소 1개 이상 포함해야 합니다.");
                return response;
            }

            // 숫자 포함 여부 검사
            if (!newPassword.matches(".*[0-9].*")) {
                response.put("success", false);
                response.put("message", "새 비밀번호는 숫자를 최소 1개 이상 포함해야 합니다.");
                return response;
            }

            Long memberId = member.getMemberId();
            String currentPasswordHash = member.getPwd();

            // 현재 비밀번호와 동일한지 확인
            if (passwordEncoder.matches(newPassword, currentPasswordHash)) {
                logger.warn("새 비밀번호가 현재 비밀번호와 동일: {}", userId);
                response.put("success", false);
                response.put("message", "새 비밀번호는 현재 비밀번호와 다르게 설정해주세요.");
                return response;
            }

            // 이전에 사용했던 비밀번호인지 확인 (최근 5개)
            if (passwordHistoryDao != null) {
                List<String> recentPasswords = passwordHistoryDao.getRecentPasswordHashes(memberId);
                for (String oldHash : recentPasswords) {
                    if (passwordEncoder.matches(newPassword, oldHash)) {
                        logger.warn("이전에 사용했던 비밀번호로 변경 시도: {}", userId);
                        response.put("success", false);
                        response.put("message", "이전에 사용했던 비밀번호는 사용할 수 없습니다. 다른 비밀번호를 입력해주세요.");
                        return response;
                    }
                }
            }

            // 현재 비밀번호를 이력에 저장 (변경 전)
            if (passwordHistoryDao != null && currentPasswordHash != null) {
                passwordHistoryDao.savePasswordHistory(memberId, currentPasswordHash);
                passwordHistoryDao.deleteOldHistory(memberId); // 최근 5개만 유지
                logger.info("이전 비밀번호 이력 저장 완료: memberId={}", memberId);
            }

            // 비밀번호 업데이트 (BCrypt로 해시하여 저장)
            String encodedNewPassword = passwordEncoder.encode(newPassword);
            member.setPwd(encodedNewPassword);
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

    /**
     * 프로필 정보 수정
     * @PostMapping("/api/member/updateProfile")
     */
    @PostMapping("/updateProfile")
    public Map<String, Object> updateProfile(
            @RequestParam("name") String name,
            @RequestParam("gender") String gender,
            @RequestParam("birth") String birth,
            @RequestParam("phone") String phone,
            @RequestParam(value = "postcode", required = false) String postcode,
            @RequestParam(value = "address", required = false) String address,
            @RequestParam(value = "detailAddress", required = false) String detailAddress,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 세션에서 사용자 ID 가져오기
            String userId = (String) session.getAttribute("id");
            if (userId == null) {
                userId = (String) session.getAttribute("userId");
            }

            logger.info("=== 프로필 수정 요청 ===");
            logger.info("userId: {}", userId);
            logger.info("name: {}, gender: {}", name, gender);
            logger.info("birth: {}, phone: {}", birth, phone);
            logger.info("postcode: {}, address: {}", postcode, address);
            logger.info("detailAddress: {}", detailAddress);

            if (userId == null) {
                logger.warn("로그인되지 않은 사용자의 프로필 수정 시도");
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

            // 필수 필드 검증
            if (name == null || name.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "이름은 필수입니다.");
                return response;
            }

            if (gender == null || gender.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "성별은 필수입니다.");
                return response;
            }

            if (birth == null || birth.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "생년월일은 필수입니다.");
                return response;
            }

            if (phone == null || phone.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "전화번호는 필수입니다.");
                return response;
            }

            // 전화번호 형식 검증 (11자리 숫자)
            if (!phone.matches("\\d{11}")) {
                response.put("success", false);
                response.put("message", "올바른 전화번호 형식이 아닙니다.");
                return response;
            }

            // Member 객체 업데이트
            member.setName(name.trim());
            member.setGender(gender);
            member.setPhone(phone);
            member.setEmail(userId);  // WHERE 조건에 필요한 email 설정

            // 주소 정보 업데이트 (빈 값이면 null로 설정)
            member.setPostcode(postcode != null && !postcode.trim().isEmpty() ? postcode.trim() : null);
            member.setAddress(address != null && !address.trim().isEmpty() ? address.trim() : null);
            member.setDetailAddress(detailAddress != null && !detailAddress.trim().isEmpty() ? detailAddress.trim() : null);

            // 생년월일 파싱
            try {
                java.sql.Date birthDate = java.sql.Date.valueOf(birth);
                member.setBirth(birthDate);
            } catch (IllegalArgumentException e) {
                logger.error("생년월일 파싱 오류: {}", birth, e);
                response.put("success", false);
                response.put("message", "올바른 생년월일 형식이 아닙니다.");
                return response;
            }

            // DB 업데이트
            int result = memberDao.updateProfile(member);
            logger.info("프로필 업데이트 결과: {}", result);

            if (result > 0) {
                // 세션 업데이트
                session.setAttribute("username", name.trim());

                response.put("success", true);
                response.put("message", "프로필 정보가 성공적으로 수정되었습니다.");
                logger.info("프로필 수정 성공: {}", userId);
            } else {
                response.put("success", false);
                response.put("message", "프로필 수정에 실패했습니다.");
                logger.error("프로필 업데이트 실패: result={}", result);
            }

        } catch (Exception e) {
            logger.error("프로필 수정 처리 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "프로필 수정 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 회원 탈퇴 (비밀번호 확인 후 처리)
     * @PostMapping("/api/member/withdraw")
     */
    @PostMapping("/withdraw")
    public Map<String, Object> withdrawMember(
            @RequestParam("password") String password,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            logger.info("=== 회원 탈퇴 요청 ===");

            // 세션에서 사용자 ID 가져오기
            String userId = (String) session.getAttribute("id");
            if (userId == null) {
                userId = (String) session.getAttribute("userId");
            }

            if (userId == null || userId.isEmpty()) {
                logger.warn("로그인하지 않은 사용자의 탈퇴 요청");
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            logger.info("탈퇴 요청 사용자: {}", userId);

            // 회원 정보 조회
            Member member = memberDao.select(userId);
            if (member == null) {
                logger.warn("회원 정보를 찾을 수 없음: {}", userId);
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            // 비밀번호 확인
            boolean passwordMatch = passwordEncoder.matches(password, member.getPwd());
            logger.info("비밀번호 일치 여부: {}", passwordMatch);

            if (!passwordMatch) {
                logger.warn("비밀번호 불일치: {}", userId);
                response.put("success", false);
                response.put("message", "비밀번호가 일치하지 않습니다.");
                return response;
            }

            // 회원 삭제 (소프트 삭제)
            int result = memberDao.delete(userId);
            logger.info("회원 삭제 결과: {}", result);

            if (result > 0) {
                // 세션 무효화
                session.invalidate();

                response.put("success", true);
                response.put("message", "회원 탈퇴가 완료되었습니다.");
                logger.info("회원 탈퇴 성공: {}", userId);
            } else {
                response.put("success", false);
                response.put("message", "회원 탈퇴에 실패했습니다.");
                logger.error("회원 탈퇴 실패: userId={}, result={}", userId, result);
            }

        } catch (Exception e) {
            logger.error("회원 탈퇴 처리 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "회원 탈퇴 처리 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }
}
