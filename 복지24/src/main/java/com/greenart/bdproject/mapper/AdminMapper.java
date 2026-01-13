package com.greenart.bdproject.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface AdminMapper {

    // 통계 조회
    int getTotalMembers();

    Long getTotalDonations();

    int getTotalVolunteers();

    // 목록 조회
    List<Map<String, Object>> getAllMembers();

    List<Map<String, Object>> getAllNotices();

    List<Map<String, Object>> getAllFaqs();

    List<Map<String, Object>> getAllDonations();

    List<Map<String, Object>> getAllVolunteers();

    // 회원 관리
    int updateMember(@Param("userId") String userId, @Param("name") String name,
                     @Param("email") String email, @Param("phone") String phone);

    int deleteMember(@Param("userId") String userId);

    int suspendMember(@Param("userId") String userId);

    int activateMember(@Param("userId") String userId);

    Map<String, Object> getMemberStatus(@Param("memberId") Long memberId);

    Map<String, Object> getMemberStatusByUserId(@Param("userId") String userId);

    int updateMemberStatus(@Param("userId") String userId, @Param("status") String status);

    int updateMemberRole(@Param("userId") String userId, @Param("role") String role);

    // 봉사활동 관리
    int approveVolunteerApplication(@Param("applicationId") Long applicationId,
                                    @Param("adminUserId") String adminUserId,
                                    @Param("facilityName") String facilityName,
                                    @Param("facilityAddress") String facilityAddress,
                                    @Param("facilityLat") String facilityLat,
                                    @Param("facilityLng") String facilityLng,
                                    @Param("adminNote") String adminNote);

    int rejectVolunteerApplication(@Param("applicationId") Long applicationId,
                                   @Param("reason") String reason);

    Map<String, Object> getVolunteerApplicationById(@Param("applicationId") Long applicationId);

    int completeExpiredVolunteerApplications();

    // 대시보드 통계
    int getTodayDonationCount();

    int getActiveVolunteerCount();

    Double getVolunteerCompletionRate();

    int getActiveMembers();

    // 차트 데이터 (raw data - 비즈니스 로직은 Service에서 처리)
    List<Map<String, Object>> getMonthlyDonationTrend();

    List<Map<String, Object>> getMemberGrowthTrend();

    List<Map<String, Object>> getVolunteerCategoryStats();

    List<Map<String, Object>> getMonthlyVolunteerStats();

    List<Map<String, Object>> getMonthlyVolunteerReviewStats();

    List<Map<String, Object>> getMonthlyDonationReviewStats();

    List<Map<String, Object>> getWelfareServiceStats();

    List<Map<String, Object>> getDonationCategoryStats();
}
