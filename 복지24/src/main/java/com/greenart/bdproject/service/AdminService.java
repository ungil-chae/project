package com.greenart.bdproject.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.greenart.bdproject.mapper.AdminMapper;
import com.greenart.bdproject.mapper.MemberStatusHistoryMapper;
import com.greenart.bdproject.dto.MemberStatusHistoryDto;

@Service
public class AdminService {

    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private MemberStatusHistoryMapper memberStatusHistoryMapper;

    /**
     * 관리자 대시보드 통계 데이터 조회 (캐시 적용)
     */
    @Cacheable(value = "adminStats")
    public Map<String, Object> getAdminStats() {
        Map<String, Object> stats = new HashMap<>();

        // 전체 회원 수
        int totalMembers = adminMapper.getTotalMembers();
        stats.put("totalMembers", totalMembers);

        // 총 기부금 (완료된 기부만)
        Long totalDonations = adminMapper.getTotalDonations();
        stats.put("totalDonations", totalDonations != null ? totalDonations : 0L);

        // 봉사 신청 수
        int totalVolunteers = adminMapper.getTotalVolunteers();
        stats.put("totalVolunteers", totalVolunteers);

        return stats;
    }

    /**
     * 전체 회원 목록 조회
     */
    public List<Map<String, Object>> getAllMembers() {
        return adminMapper.getAllMembers();
    }

    /**
     * 전체 공지사항 목록 조회
     */
    public List<Map<String, Object>> getAllNotices() {
        return adminMapper.getAllNotices();
    }

    /**
     * 전체 FAQ 목록 조회
     */
    public List<Map<String, Object>> getAllFaqs() {
        return adminMapper.getAllFaqs();
    }

    /**
     * 전체 기부 내역 조회
     */
    public List<Map<String, Object>> getAllDonations() {
        return adminMapper.getAllDonations();
    }

    /**
     * 전체 봉사 신청 내역 조회
     */
    public List<Map<String, Object>> getAllVolunteers() {
        return adminMapper.getAllVolunteers();
    }

    /**
     * 회원 정보 수정
     */
    public boolean updateMember(String userId, String name, String email, String phone) {
        return adminMapper.updateMember(userId, name, email, phone) > 0;
    }

    /**
     * 회원 탈퇴 처리 (소프트 삭제 - DORMANT 상태로 변경)
     */
    public boolean deleteMember(String userId) {
        // 변경 전 회원 상태 조회
        Map<String, Object> memberInfo = adminMapper.getMemberStatusByUserId(userId);
        if (memberInfo == null) {
            return false;
        }

        String oldStatus = (String) memberInfo.get("status");
        Long memberId = ((Number) memberInfo.get("member_id")).longValue();

        // 상태 변경 실행 (DORMANT로 변경)
        boolean success = adminMapper.deleteMember(userId) > 0;

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
        Map<String, Object> memberInfo = adminMapper.getMemberStatusByUserId(userId);
        if (memberInfo == null) {
            return false;
        }

        String oldStatus = (String) memberInfo.get("status");
        Long memberId = ((Number) memberInfo.get("member_id")).longValue();

        // 상태 변경 실행
        boolean success = adminMapper.suspendMember(userId) > 0;

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
        Map<String, Object> memberInfo = adminMapper.getMemberStatusByUserId(userId);
        if (memberInfo == null) {
            return false;
        }

        String oldStatus = (String) memberInfo.get("status");
        Long memberId = ((Number) memberInfo.get("member_id")).longValue();

        // 상태 변경 실행
        boolean success = adminMapper.activateMember(userId) > 0;

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
        List<MemberStatusHistoryDto> historyList = memberStatusHistoryMapper.selectAllHistory();
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
            int result = memberStatusHistoryMapper.insertHistory(history);
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
        Map<String, Object> memberInfo = adminMapper.getMemberStatusByUserId(userId);
        if (memberInfo == null) {
            return false;
        }

        String oldStatus = (String) memberInfo.get("status");
        Long memberId = ((Number) memberInfo.get("member_id")).longValue();

        // 상태 변경 실행
        boolean success = adminMapper.updateMemberStatus(userId, status) > 0;

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
        Map<String, Object> memberInfo = adminMapper.getMemberStatusByUserId(userId);
        if (memberInfo == null) {
            return false;
        }

        String oldRole = (String) memberInfo.get("role");
        Long memberId = ((Number) memberInfo.get("member_id")).longValue();

        // 등급 변경 실행
        boolean success = adminMapper.updateMemberRole(userId, role) > 0;

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

        return adminMapper.approveVolunteerApplication(
            applicationId,
            adminUserId,
            facilityName,
            facilityAddress,
            facilityLat,
            facilityLng,
            adminNote
        ) > 0;
    }

    /**
     * 봉사활동 거절
     */
    public boolean rejectVolunteerApplication(Long applicationId, String reason) {
        return adminMapper.rejectVolunteerApplication(applicationId, reason) > 0;
    }

    /**
     * 봉사 신청 정보 조회
     */
    public Map<String, Object> getVolunteerApplicationById(Long applicationId) {
        return adminMapper.getVolunteerApplicationById(applicationId);
    }

    /**
     * 시간 경과된 봉사활동 자동 완료 처리
     */
    public int completeExpiredVolunteerApplications() {
        return adminMapper.completeExpiredVolunteerApplications();
    }

    /**
     * 대시보드 통계 카드 데이터 조회
     */
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        try {
            // 오늘 기부 건수
            stats.put("todayDonations", adminMapper.getTodayDonationCount());

            // 진행 중인 봉사활동 수
            stats.put("activeVolunteers", adminMapper.getActiveVolunteerCount());

            // 봉사 완료율
            stats.put("volunteerCompletionRate", adminMapper.getVolunteerCompletionRate());

            // 총 기부금액
            Long totalDonations = adminMapper.getTotalDonations();
            stats.put("totalDonations", totalDonations != null ? totalDonations : 0L);

            // 활동 중인 총 회원 수
            stats.put("totalMembers", adminMapper.getActiveMembers());

        } catch (Exception e) {
            e.printStackTrace();
            // 기본값 설정
            stats.put("todayDonations", 0);
            stats.put("activeVolunteers", 0);
            stats.put("volunteerCompletionRate", 0.0);
            stats.put("totalDonations", 0L);
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
            chartData.put("donationTrend", transformDonationTrend(adminMapper.getMonthlyDonationTrend()));

            // 2. 회원 증가 추이
            chartData.put("memberGrowth", transformMemberGrowth(adminMapper.getMemberGrowthTrend()));

            // 3. 봉사활동 카테고리별 신청률
            chartData.put("volunteerCategory", transformCategoryStats(adminMapper.getVolunteerCategoryStats()));

            // 4. 월별 후기 작성 현황
            chartData.put("monthlyReview", buildMonthlyReviewStats());

            // 5. 복지서비스 이용 비율
            chartData.put("welfareService", transformServiceStats(adminMapper.getWelfareServiceStats()));

            // 6. 기부 카테고리별 분포
            chartData.put("donationCategory", transformDonationCategoryStats(adminMapper.getDonationCategoryStats()));

        } catch (Exception e) {
            e.printStackTrace();
        }

        return chartData;
    }

    // ===== 차트 데이터 변환 메서드 (AdminDaoImpl에서 이동) =====

    /**
     * 월별 기부금 추이 데이터 변환
     */
    private Map<String, Object> transformDonationTrend(List<Map<String, Object>> rawData) {
        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<Long> data = new ArrayList<>();

        if (rawData != null) {
            for (Map<String, Object> row : rawData) {
                labels.add((String) row.get("month"));
                Object amount = row.get("amount");
                data.add(amount != null ? ((Number) amount).longValue() : 0L);
            }
        }

        result.put("labels", labels);
        result.put("data", data);
        return result;
    }

    /**
     * 회원 증가 추이 데이터 변환
     */
    private Map<String, Object> transformMemberGrowth(List<Map<String, Object>> rawData) {
        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<Integer> newMembers = new ArrayList<>();

        if (rawData != null) {
            for (Map<String, Object> row : rawData) {
                labels.add((String) row.get("month"));
                Object newCount = row.get("new_members");
                newMembers.add(newCount != null ? ((Number) newCount).intValue() : 0);
            }
        }

        result.put("labels", labels);
        result.put("newMembers", newMembers);
        return result;
    }

    /**
     * 카테고리별 통계 데이터 변환
     */
    private Map<String, Object> transformCategoryStats(List<Map<String, Object>> rawData) {
        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<Double> data = new ArrayList<>();

        if (rawData != null) {
            for (Map<String, Object> row : rawData) {
                labels.add((String) row.get("category"));
                Object rate = row.get("rate");
                data.add(rate != null ? ((Number) rate).doubleValue() : 0.0);
            }
        }

        result.put("labels", labels);
        result.put("data", data);
        return result;
    }

    /**
     * 월별 후기 통계 생성 (봉사 후기 + 기부 후기 통합)
     */
    private Map<String, Object> buildMonthlyReviewStats() {
        Map<String, Object> result = new HashMap<>();

        // 최근 6개월 레이블 생성
        List<String> labels = new ArrayList<>();
        java.time.LocalDate now = java.time.LocalDate.now();
        for (int i = 5; i >= 0; i--) {
            java.time.LocalDate date = now.minusMonths(i);
            labels.add(date.getMonthValue() + "월");
        }

        // 봉사 후기 월별 통계
        List<Map<String, Object>> volunteerData = adminMapper.getMonthlyVolunteerReviewStats();
        List<Integer> volunteerCounts = new ArrayList<>();
        for (int i = 5; i >= 0; i--) {
            java.time.LocalDate date = now.minusMonths(i);
            String monthKey = String.format("%d-%02d", date.getYear(), date.getMonthValue());
            int count = 0;
            if (volunteerData != null) {
                for (Map<String, Object> row : volunteerData) {
                    if (monthKey.equals(row.get("month"))) {
                        count = ((Number) row.get("count")).intValue();
                        break;
                    }
                }
            }
            volunteerCounts.add(count);
        }

        // 기부 후기 월별 통계
        List<Map<String, Object>> donationData = adminMapper.getMonthlyDonationReviewStats();
        List<Integer> donationCounts = new ArrayList<>();
        for (int i = 5; i >= 0; i--) {
            java.time.LocalDate date = now.minusMonths(i);
            String monthKey = String.format("%d-%02d", date.getYear(), date.getMonthValue());
            int count = 0;
            if (donationData != null) {
                for (Map<String, Object> row : donationData) {
                    if (monthKey.equals(row.get("month"))) {
                        count = ((Number) row.get("count")).intValue();
                        break;
                    }
                }
            }
            donationCounts.add(count);
        }

        result.put("labels", labels);
        result.put("volunteerData", volunteerCounts);
        result.put("donationData", donationCounts);
        return result;
    }

    /**
     * 복지서비스 통계 데이터 변환
     */
    private Map<String, Object> transformServiceStats(List<Map<String, Object>> rawData) {
        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<Integer> data = new ArrayList<>();

        if (rawData != null) {
            for (Map<String, Object> row : rawData) {
                labels.add((String) row.get("service_type"));
                Object count = row.get("count");
                data.add(count != null ? ((Number) count).intValue() : 0);
            }
        }

        result.put("labels", labels);
        result.put("data", data);
        return result;
    }

    /**
     * 기부 카테고리별 통계 데이터 변환
     */
    private Map<String, Object> transformDonationCategoryStats(List<Map<String, Object>> rawData) {
        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<Long> data = new ArrayList<>();

        if (rawData != null) {
            for (Map<String, Object> row : rawData) {
                labels.add((String) row.get("category"));
                Object amount = row.get("amount");
                data.add(amount != null ? ((Number) amount).longValue() : 0L);
            }
        }

        result.put("labels", labels);
        result.put("data", data);
        return result;
    }
}
