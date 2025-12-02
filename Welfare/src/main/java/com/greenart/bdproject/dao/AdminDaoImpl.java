package com.greenart.bdproject.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AdminDaoImpl implements AdminDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.greenart.bdproject.mapper.AdminMapper";

    @Override
    public int getTotalMembers() {
        return sqlSession.selectOne(NAMESPACE + ".getTotalMembers");
    }

    @Override
    public Long getTotalDonations() {
        return sqlSession.selectOne(NAMESPACE + ".getTotalDonations");
    }

    @Override
    public int getTotalVolunteers() {
        return sqlSession.selectOne(NAMESPACE + ".getTotalVolunteers");
    }

    @Override
    public int getTotalDiagnoses() {
        return sqlSession.selectOne(NAMESPACE + ".getTotalDiagnoses");
    }

    @Override
    public List<Map<String, Object>> getAllMembers() {
        return sqlSession.selectList(NAMESPACE + ".getAllMembers");
    }

    @Override
    public List<Map<String, Object>> getAllNotices() {
        return sqlSession.selectList(NAMESPACE + ".getAllNotices");
    }

    @Override
    public List<Map<String, Object>> getAllFaqs() {
        return sqlSession.selectList(NAMESPACE + ".getAllFaqs");
    }

    @Override
    public List<Map<String, Object>> getAllDonations() {
        return sqlSession.selectList(NAMESPACE + ".getAllDonations");
    }

    @Override
    public List<Map<String, Object>> getAllVolunteers() {
        return sqlSession.selectList(NAMESPACE + ".getAllVolunteers");
    }

    @Override
    public boolean updateMember(String userId, String name, String email, String phone) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("name", name);
        params.put("email", email);
        params.put("phone", phone);
        int result = sqlSession.update(NAMESPACE + ".updateMember", params);
        return result > 0;
    }

    @Override
    public boolean deleteMember(String userId) {
        // 소프트 삭제 (DORMANT 상태로 변경)
        int result = sqlSession.update(NAMESPACE + ".deleteMember", userId);
        return result > 0;
    }

    @Override
    public boolean suspendMember(String userId) {
        int result = sqlSession.update(NAMESPACE + ".suspendMember", userId);
        return result > 0;
    }

    @Override
    public boolean activateMember(String userId) {
        int result = sqlSession.update(NAMESPACE + ".activateMember", userId);
        return result > 0;
    }

    @Override
    public Map<String, Object> getMemberStatus(Long memberId) {
        return sqlSession.selectOne(NAMESPACE + ".getMemberStatus", memberId);
    }

    @Override
    public Map<String, Object> getMemberStatusByUserId(String userId) {
        return sqlSession.selectOne(NAMESPACE + ".getMemberStatusByUserId", userId);
    }

    @Override
    public boolean updateMemberStatus(String userId, String status) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("status", status);
        int result = sqlSession.update(NAMESPACE + ".updateMemberStatus", params);
        return result > 0;
    }

    @Override
    public boolean updateMemberRole(String userId, String role) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("role", role);
        int result = sqlSession.update(NAMESPACE + ".updateMemberRole", params);
        return result > 0;
    }

    @Override
    public boolean approveVolunteerApplication(
            Long applicationId,
            String adminUserId,
            String facilityName,
            String facilityAddress,
            String facilityLat,
            String facilityLng,
            String adminNote) {

        Map<String, Object> params = new HashMap<>();
        params.put("applicationId", applicationId);
        params.put("adminUserId", adminUserId);
        params.put("facilityName", facilityName);
        params.put("facilityAddress", facilityAddress);

        // 빈 문자열을 null로 변환 (DECIMAL 타입 처리)
        params.put("facilityLat", (facilityLat != null && !facilityLat.trim().isEmpty()) ? facilityLat : null);
        params.put("facilityLng", (facilityLng != null && !facilityLng.trim().isEmpty()) ? facilityLng : null);
        params.put("adminNote", adminNote);

        int result = sqlSession.update(NAMESPACE + ".approveVolunteerApplication", params);
        return result > 0;
    }

    @Override
    public boolean rejectVolunteerApplication(Long applicationId, String reason) {
        Map<String, Object> params = new HashMap<>();
        params.put("applicationId", applicationId);
        params.put("reason", reason);

        int result = sqlSession.update(NAMESPACE + ".rejectVolunteerApplication", params);
        return result > 0;
    }

    // ===== 대시보드 통계 관련 메서드 구현 =====

    @Override
    public int getTodayDonationCount() {
        Integer count = sqlSession.selectOne(NAMESPACE + ".getTodayDonationCount");
        return count != null ? count : 0;
    }

    @Override
    public int getActiveVolunteerCount() {
        Integer count = sqlSession.selectOne(NAMESPACE + ".getActiveVolunteerCount");
        return count != null ? count : 0;
    }

    @Override
    public double getVolunteerCompletionRate() {
        Double rate = sqlSession.selectOne(NAMESPACE + ".getVolunteerCompletionRate");
        return rate != null ? rate : 0.0;
    }

    @Override
    public int getActiveMembers() {
        Integer count = sqlSession.selectOne(NAMESPACE + ".getActiveMembers");
        return count != null ? count : 0;
    }

    // ===== 대시보드 차트 관련 메서드 구현 =====

    @Override
    public Map<String, Object> getMonthlyDonationTrend() {
        List<Map<String, Object>> rawData = sqlSession.selectList(NAMESPACE + ".getMonthlyDonationTrend");
        Map<String, Object> result = new HashMap<>();

        java.util.List<String> labels = new java.util.ArrayList<>();
        java.util.List<Long> data = new java.util.ArrayList<>();

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

    @Override
    public Map<String, Object> getMemberGrowthTrend() {
        List<Map<String, Object>> rawData = sqlSession.selectList(NAMESPACE + ".getMemberGrowthTrend");
        Map<String, Object> result = new HashMap<>();

        java.util.List<String> labels = new java.util.ArrayList<>();
        java.util.List<Integer> newMembers = new java.util.ArrayList<>();
        java.util.List<Integer> totalMembers = new java.util.ArrayList<>();

        if (rawData != null) {
            for (Map<String, Object> row : rawData) {
                labels.add((String) row.get("month"));
                Object newCount = row.get("new_members");
                Object totalCount = row.get("total_members");
                newMembers.add(newCount != null ? ((Number) newCount).intValue() : 0);
                totalMembers.add(totalCount != null ? ((Number) totalCount).intValue() : 0);
            }
        }

        result.put("labels", labels);
        result.put("newMembers", newMembers);
        result.put("totalMembers", totalMembers);
        return result;
    }

    @Override
    public Map<String, Object> getVolunteerCategoryStats() {
        List<Map<String, Object>> rawData = sqlSession.selectList(NAMESPACE + ".getVolunteerCategoryStats");
        Map<String, Object> result = new HashMap<>();

        java.util.List<String> labels = new java.util.ArrayList<>();
        java.util.List<Double> data = new java.util.ArrayList<>();

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

    @Override
    public Map<String, Object> getPaymentMethodStats() {
        List<Map<String, Object>> rawData = sqlSession.selectList(NAMESPACE + ".getPaymentMethodStats");
        Map<String, Object> result = new HashMap<>();

        java.util.List<String> labels = new java.util.ArrayList<>();
        java.util.List<Integer> data = new java.util.ArrayList<>();

        if (rawData != null) {
            for (Map<String, Object> row : rawData) {
                labels.add((String) row.get("method"));
                Object count = row.get("count");
                data.add(count != null ? ((Number) count).intValue() : 0);
            }
        }

        result.put("labels", labels);
        result.put("data", data);
        return result;
    }

    @Override
    public Map<String, Object> getWelfareServiceStats() {
        List<Map<String, Object>> rawData = sqlSession.selectList(NAMESPACE + ".getWelfareServiceStats");
        Map<String, Object> result = new HashMap<>();

        java.util.List<String> labels = new java.util.ArrayList<>();
        java.util.List<Integer> data = new java.util.ArrayList<>();

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

    @Override
    public Map<String, Object> getDonationCategoryStats() {
        List<Map<String, Object>> rawData = sqlSession.selectList(NAMESPACE + ".getDonationCategoryStats");
        Map<String, Object> result = new HashMap<>();

        java.util.List<String> labels = new java.util.ArrayList<>();
        java.util.List<Long> data = new java.util.ArrayList<>();

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

    @Override
    public Map<String, Object> getVolunteerApplicationById(Long applicationId) {
        return sqlSession.selectOne(NAMESPACE + ".getVolunteerApplicationById", applicationId);
    }

    @Override
    public int completeExpiredVolunteerApplications() {
        return sqlSession.update(NAMESPACE + ".completeExpiredVolunteerApplications");
    }
}
