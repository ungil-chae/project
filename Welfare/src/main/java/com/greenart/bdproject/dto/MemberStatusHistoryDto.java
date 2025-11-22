package com.greenart.bdproject.dto;

import java.sql.Timestamp;

/**
 * 회원 상태 변경 이력 DTO
 * 관리자가 회원 상태를 변경한 이력을 추적
 */
public class MemberStatusHistoryDto {
    // Primary Key
    private Long historyId;  // BIGINT UNSIGNED

    // 외래키
    private Long memberId;  // BIGINT UNSIGNED
    private Long adminId;  // BIGINT UNSIGNED (시스템 자동 처리 시 NULL)

    // 변경 정보
    private String oldStatus;  // ENUM('ACTIVE', 'SUSPENDED', 'DORMANT')
    private String newStatus;  // ENUM('ACTIVE', 'SUSPENDED', 'DORMANT')
    private String reason;  // VARCHAR(500)

    // 추적 정보
    private String ipAddress;  // VARCHAR(45)

    // 시스템 정보
    private Timestamp createdAt;  // TIMESTAMP

    // 조회용 추가 필드
    private String memberEmail;  // 회원 이메일 (JOIN)
    private String memberName;  // 회원 이름 (JOIN)
    private String adminEmail;  // 관리자 이메일 (JOIN)
    private String adminName;  // 관리자 이름 (JOIN)

    // 기본 생성자
    public MemberStatusHistoryDto() {
    }

    // 편의 생성자
    public MemberStatusHistoryDto(Long memberId, String oldStatus, String newStatus, String reason) {
        this.memberId = memberId;
        this.oldStatus = oldStatus;
        this.newStatus = newStatus;
        this.reason = reason;
    }

    // Getters and Setters
    public Long getHistoryId() {
        return historyId;
    }

    public void setHistoryId(Long historyId) {
        this.historyId = historyId;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public Long getAdminId() {
        return adminId;
    }

    public void setAdminId(Long adminId) {
        this.adminId = adminId;
    }

    public String getOldStatus() {
        return oldStatus;
    }

    public void setOldStatus(String oldStatus) {
        this.oldStatus = oldStatus;
    }

    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getMemberEmail() {
        return memberEmail;
    }

    public void setMemberEmail(String memberEmail) {
        this.memberEmail = memberEmail;
    }

    public String getMemberName() {
        return memberName;
    }

    public void setMemberName(String memberName) {
        this.memberName = memberName;
    }

    public String getAdminEmail() {
        return adminEmail;
    }

    public void setAdminEmail(String adminEmail) {
        this.adminEmail = adminEmail;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }

    // 유틸리티 메서드

    /**
     * 상태 변경 유형 판단
     */
    public String getChangeType() {
        if ("SUSPENDED".equals(newStatus)) {
            return "정지";
        } else if ("ACTIVE".equals(newStatus) && "SUSPENDED".equals(oldStatus)) {
            return "정지 해제";
        } else if ("DORMANT".equals(newStatus)) {
            return "휴면 전환";
        } else if ("ACTIVE".equals(newStatus) && "DORMANT".equals(oldStatus)) {
            return "휴면 해제";
        }
        return "상태 변경";
    }

    /**
     * 상태 한글명 변환
     */
    public static String getStatusKoreanName(String status) {
        switch (status) {
            case "ACTIVE":
                return "활동중";
            case "SUSPENDED":
                return "정지됨";
            case "DORMANT":
                return "휴면";
            default:
                return status;
        }
    }

    /**
     * 시스템 자동 처리 여부
     */
    public boolean isSystemGenerated() {
        return adminId == null;
    }

    @Override
    public String toString() {
        return "MemberStatusHistoryDto{" +
                "historyId=" + historyId +
                ", memberId=" + memberId +
                ", adminId=" + adminId +
                ", oldStatus='" + oldStatus + '\'' +
                ", newStatus='" + newStatus + '\'' +
                ", reason='" + reason + '\'' +
                ", memberEmail='" + memberEmail + '\'' +
                ", adminEmail='" + adminEmail + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
