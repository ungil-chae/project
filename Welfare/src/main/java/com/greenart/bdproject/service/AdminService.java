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
     * 회원 삭제
     */
    public boolean deleteMember(String userId) {
        return adminDao.deleteMember(userId);
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
}
