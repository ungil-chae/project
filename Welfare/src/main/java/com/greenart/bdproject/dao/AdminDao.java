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
}
