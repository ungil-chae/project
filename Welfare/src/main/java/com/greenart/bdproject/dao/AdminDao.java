package com.greenart.bdproject.dao;

import java.util.List;
import java.util.Map;

public interface AdminDao {

    /**
     * 전체 회원 수 조회
     */
    int getTotalMembers();

    /**
     * 총 기부금 조회 (완료된 기부만)
     */
    Long getTotalDonations();

    /**
     * 봉사 신청 수 조회
     */
    int getTotalVolunteers();

    /**
     * 복지 진단 수 조회
     */
    int getTotalDiagnoses();

    /**
     * 회원 목록 조회
     */
    List<Map<String, Object>> getAllMembers();

    /**
     * 공지사항 목록 조회
     */
    List<Map<String, Object>> getAllNotices();

    /**
     * FAQ 목록 조회
     */
    List<Map<String, Object>> getAllFaqs();

    /**
     * 기부 내역 조회
     */
    List<Map<String, Object>> getAllDonations();

    /**
     * 봉사 신청 내역 조회
     */
    List<Map<String, Object>> getAllVolunteers();

    /**
     * 회원 정보 수정
     */
    boolean updateMember(String userId, String name, String email, String phone);

    /**
     * 회원 삭제
     */
    boolean deleteMember(String userId);

    /**
     * 회원 계정 정지
     */
    boolean suspendMember(String userId);

    /**
     * 회원 계정 활성화
     */
    boolean activateMember(String userId);

    /**
     * 회원 상태 조회 (member_id로 조회)
     */
    Map<String, Object> getMemberStatus(Long memberId);

    /**
     * 회원 상태 조회 (userId로 조회)
     */
    Map<String, Object> getMemberStatusByUserId(String userId);

    /**
     * 회원 상태 변경
     */
    boolean updateMemberStatus(String userId, String status);

    /**
     * 회원 등급 변경
     */
    boolean updateMemberRole(String userId, String role);

    /**
     * 봉사활동 승인 및 시설 배정
     */
    boolean approveVolunteerApplication(
        Long applicationId,
        String adminUserId,
        String facilityName,
        String facilityAddress,
        String facilityLat,
        String facilityLng,
        String adminNote
    );

    /**
     * 봉사활동 거절
     */
    boolean rejectVolunteerApplication(Long applicationId, String reason);

    /**
     * 봉사 신청 정보 조회
     */
    Map<String, Object> getVolunteerApplicationById(Long applicationId);

    /**
     * 봉사활동 완료 처리 (시간 경과)
     */
    int completeExpiredVolunteerApplications();

    // ===== 대시보드 통계 관련 메서드 =====

    /**
     * 오늘 기부 건수 조회
     */
    int getTodayDonationCount();

    /**
     * 진행 중인 봉사활동 수 조회
     */
    int getActiveVolunteerCount();

    /**
     * 봉사 완료율 조회
     */
    double getVolunteerCompletionRate();

    /**
     * 활동 중인 회원 수 조회
     */
    int getActiveMembers();

    // ===== 대시보드 차트 관련 메서드 =====

    /**
     * 월별 기부금 추이 조회
     */
    Map<String, Object> getMonthlyDonationTrend();

    /**
     * 회원 증가 추이 조회
     */
    Map<String, Object> getMemberGrowthTrend();

    /**
     * 봉사활동 카테고리별 통계 조회
     */
    Map<String, Object> getVolunteerCategoryStats();

    /**
     * 후원 방식별 통계 조회
     */
    Map<String, Object> getPaymentMethodStats();

    /**
     * 복지서비스 이용 통계 조회
     */
    Map<String, Object> getWelfareServiceStats();

    /**
     * 기부 카테고리별 분포 조회
     */
    Map<String, Object> getDonationCategoryStats();
}
