package com.greenart.bdproject.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.greenart.bdproject.dao.AdminDao;
import com.greenart.bdproject.dao.MemberStatusHistoryDao;
import com.greenart.bdproject.dto.MemberStatusHistoryDto;

@Service
public class AdminService {

    @Autowired
    private AdminDao adminDao;

    @Autowired
    private MemberStatusHistoryDao memberStatusHistoryDao;

    /**
     * 관리자 대시보드 통계 데이터 조회
     */
    public Map<String, Object> getAdminStats() {
        Map<String, Object> stats = new HashMap<>();

        // 전체 회원 수
        int totalMembers = adminDao.getTotalMembers();
        stats.put("totalMembers", totalMembers);

        // 총 기부금 (완료된 기부만)
        Long totalDonations = adminDao.getTotalDonations();
        stats.put("totalDonations", totalDonations != null ? totalDonations : 0L);

        // 봉사 신청 수
        int totalVolunteers = adminDao.getTotalVolunteers();
        stats.put("totalVolunteers", totalVolunteers);

        // 복지 진단 수
        int totalDiagnoses = adminDao.getTotalDiagnoses();
        stats.put("totalDiagnoses", totalDiagnoses);

        return stats;
    }

    /**
     * 전체 회원 목록 조회
     */
    public List<Map<String, Object>> getAllMembers() {
        return adminDao.getAllMembers();
    }

    /**
     * 전체 공지사항 목록 조회
     */
    public List<Map<String, Object>> getAllNotices() {
        return adminDao.getAllNotices();
    }

    /**
     * 전체 FAQ 목록 조회
     */
    public List<Map<String, Object>> getAllFaqs() {
        return adminDao.getAllFaqs();
    }

    /**
     * 전체 기부 내역 조회
     */
    public List<Map<String, Object>> getAllDonations() {
        return adminDao.getAllDonations();
    }

    /**
     * 전체 봉사 신청 내역 조회
     */
    public List<Map<String, Object>> getAllVolunteers() {
        return adminDao.getAllVolunteers();
    }

    /**
     * 회원 정보 수정
     */
    public boolean updateMember(String userId, String name, String email, String phone) {
        return adminDao.updateMember(userId, name, email, phone);
    }

    /**
     * 회원 탈퇴 처리 (소프트 삭제 - DORMANT 상태로 변경)
     */
    public boolean deleteMember(String userId) {
        // 변경 전 회원 상태 조회
        Map<String, Object> memberInfo = adminDao.getMemberStatusByUserId(userId);
        if (memberInfo == null) {
            return false;
        }

        String oldStatus = (String) memberInfo.get("status");
        Long memberId = ((Number) memberInfo.get("member_id")).longValue();

        // 상태 변경 실행 (DORMANT로 변경)
        boolean success = adminDao.deleteMember(userId);

        // 성공 시 이력 저장
        if (success) {
            MemberStatusHistoryDto history = new MemberStatusHistoryDto();
            history.setMemberId(memberId);
            history.setAdminId(null); // 관리자 ID는 컨트롤러에서 설정 필요
            history.setOldStatus(oldStatus);
            history.setNewStatus("DORMANT");
            history.setReason("관리자에 의한 계정 탈퇴 처리");

            saveMemberStatusHistory(history);
        }

        return success;
    }

    /**
     * 회원 계정 정지
     */
    public boolean suspendMember(String userId) {
        // 변경 전 회원 상태 조회
        Map<String, Object> memberInfo = adminDao.getMemberStatusByUserId(userId);
        if (memberInfo == null) {
            return false;
        }

        String oldStatus = (String) memberInfo.get("status");
        Long memberId = ((Number) memberInfo.get("member_id")).longValue();

        // 상태 변경 실행
        boolean success = adminDao.suspendMember(userId);

        // 성공 시 이력 저장
        if (success) {
            MemberStatusHistoryDto history = new MemberStatusHistoryDto();
            history.setMemberId(memberId);
            history.setAdminId(null); // 관리자 ID는 컨트롤러에서 설정 필요
            history.setOldStatus(oldStatus);
            history.setNewStatus("SUSPENDED");
            history.setReason("관리자에 의한 계정 정지");

            saveMemberStatusHistory(history);
        }

        return success;
    }

    /**
     * 회원 계정 활성화
     */
    public boolean activateMember(String userId) {
        // 변경 전 회원 상태 조회
        Map<String, Object> memberInfo = adminDao.getMemberStatusByUserId(userId);
        if (memberInfo == null) {
            return false;
        }

        String oldStatus = (String) memberInfo.get("status");
        Long memberId = ((Number) memberInfo.get("member_id")).longValue();

        // 상태 변경 실행
        boolean success = adminDao.activateMember(userId);

        // 성공 시 이력 저장
        if (success) {
            MemberStatusHistoryDto history = new MemberStatusHistoryDto();
            history.setMemberId(memberId);
            history.setAdminId(null); // 관리자 ID는 컨트롤러에서 설정 필요
            history.setOldStatus(oldStatus);
            history.setNewStatus("ACTIVE");
            history.setReason("관리자에 의한 계정 활성화");

            saveMemberStatusHistory(history);
        }

        return success;
    }

    /**
     * 회원 상태 변경 이력 조회
     */
    public List<Map<String, Object>> getMemberStatusHistory() {
        List<MemberStatusHistoryDto> historyList = memberStatusHistoryDao.selectAllHistory();
        List<Map<String, Object>> result = new ArrayList<>();

        for (MemberStatusHistoryDto history : historyList) {
            Map<String, Object> map = new HashMap<>();
            map.put("historyId", history.getHistoryId());
            map.put("memberId", history.getMemberId());
            map.put("adminId", history.getAdminId());
            map.put("oldStatus", history.getOldStatus());
            map.put("newStatus", history.getNewStatus());
            map.put("reason", history.getReason());
            map.put("ipAddress", history.getIpAddress());
            map.put("createdAt", history.getCreatedAt() != null ? history.getCreatedAt().toString() : null);
            map.put("memberEmail", history.getMemberEmail());
            map.put("memberName", history.getMemberName());
            map.put("adminEmail", history.getAdminEmail());
            map.put("adminName", history.getAdminName());
            result.add(map);
        }

        return result;
    }

    /**
     * 회원 상태 변경 이력 저장
     */
    public boolean saveMemberStatusHistory(MemberStatusHistoryDto history) {
        try {
            int result = memberStatusHistoryDao.insertHistory(history);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 회원 상태 변경 (일괄 처리용)
     */
    public boolean updateMemberStatus(String userId, String status) {
        // 변경 전 회원 상태 조회
        Map<String, Object> memberInfo = adminDao.getMemberStatusByUserId(userId);
        if (memberInfo == null) {
            return false;
        }

        String oldStatus = (String) memberInfo.get("status");
        Long memberId = ((Number) memberInfo.get("member_id")).longValue();

        // 상태 변경 실행
        boolean success = adminDao.updateMemberStatus(userId, status);

        // 성공 시 이력 저장
        if (success) {
            MemberStatusHistoryDto history = new MemberStatusHistoryDto();
            history.setMemberId(memberId);
            history.setAdminId(null);
            history.setOldStatus(oldStatus);
            history.setNewStatus(status);
            history.setReason("관리자에 의한 상태 변경");

            saveMemberStatusHistory(history);
        }

        return success;
    }

    /**
     * 회원 등급 변경
     */
    public boolean updateMemberRole(String userId, String role) {
        // 변경 전 회원 정보 조회
        Map<String, Object> memberInfo = adminDao.getMemberStatusByUserId(userId);
        if (memberInfo == null) {
            return false;
        }

        String oldRole = (String) memberInfo.get("role");
        Long memberId = ((Number) memberInfo.get("member_id")).longValue();

        // 등급 변경 실행
        boolean success = adminDao.updateMemberRole(userId, role);

        // 성공 시 이력 저장
        if (success) {
            MemberStatusHistoryDto history = new MemberStatusHistoryDto();
            history.setMemberId(memberId);
            history.setAdminId(null);
            history.setOldStatus(oldRole);  // 이전 등급
            history.setNewStatus(role);      // 새 등급
            history.setReason("관리자에 의한 회원 등급 변경");

            saveMemberStatusHistory(history);
        }

        return success;
    }

    /**
     * 봉사활동 승인 및 시설 배정
     */
    public boolean approveVolunteerApplication(
            Long applicationId,
            String adminUserId,
            String facilityName,
            String facilityAddress,
            String facilityLat,
            String facilityLng,
            String adminNote) {

        return adminDao.approveVolunteerApplication(
            applicationId,
            adminUserId,
            facilityName,
            facilityAddress,
            facilityLat,
            facilityLng,
            adminNote
        );
    }

    /**
     * 봉사활동 거절
     */
    public boolean rejectVolunteerApplication(Long applicationId, String reason) {
        return adminDao.rejectVolunteerApplication(applicationId, reason);
    }

    /**
     * 봉사 신청 정보 조회
     */
    public Map<String, Object> getVolunteerApplicationById(Long applicationId) {
        return adminDao.getVolunteerApplicationById(applicationId);
    }

    /**
     * 시간 경과된 봉사활동 자동 완료 처리
     */
    public int completeExpiredVolunteerApplications() {
        return adminDao.completeExpiredVolunteerApplications();
    }

    /**
     * 대시보드 통계 카드 데이터 조회
     */
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        try {
            // 오늘 기부 건수
            stats.put("todayDonations", adminDao.getTodayDonationCount());

            // 진행 중인 봉사활동 수
            stats.put("activeVolunteers", adminDao.getActiveVolunteerCount());

            // 봉사 완료율
            stats.put("volunteerCompletionRate", adminDao.getVolunteerCompletionRate());

            // 총 기부금액
            Long totalDonations = adminDao.getTotalDonations();
            stats.put("totalDonations", totalDonations != null ? totalDonations : 0L);

            // 복지 진단 건수
            stats.put("totalDiagnoses", adminDao.getTotalDiagnoses());

            // 활동 중인 총 회원 수
            stats.put("totalMembers", adminDao.getActiveMembers());

        } catch (Exception e) {
            e.printStackTrace();
            // 기본값 설정
            stats.put("todayDonations", 0);
            stats.put("activeVolunteers", 0);
            stats.put("volunteerCompletionRate", 0.0);
            stats.put("totalDonations", 0L);
            stats.put("totalDiagnoses", 0);
            stats.put("totalMembers", 0);
        }

        return stats;
    }

    /**
     * 대시보드 차트 데이터 조회
     */
    public Map<String, Object> getDashboardChartData() {
        Map<String, Object> chartData = new HashMap<>();

        try {
            // 1. 최근 6개월 기부금 현황
            chartData.put("donationTrend", adminDao.getMonthlyDonationTrend());

            // 2. 회원 증가 추이
            chartData.put("memberGrowth", adminDao.getMemberGrowthTrend());

            // 3. 봉사활동 카테고리별 신청률
            chartData.put("volunteerCategory", adminDao.getVolunteerCategoryStats());

            // 4. 후원 방식별 현황
            chartData.put("paymentMethod", adminDao.getPaymentMethodStats());

            // 5. 복지서비스 이용 비율
            chartData.put("welfareService", adminDao.getWelfareServiceStats());

            // 6. 기부 카테고리별 분포
            chartData.put("donationCategory", adminDao.getDonationCategoryStats());

        } catch (Exception e) {
            e.printStackTrace();
        }

        return chartData;
    }
}
