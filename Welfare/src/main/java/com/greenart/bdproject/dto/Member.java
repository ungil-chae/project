package com.greenart.bdproject.dto;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.Objects;

/**
 * 회원 DTO (최적화 버전)
 * DB 스키마 변경에 따른 수정:
 * - id VARCHAR(50) → memberId BIGINT UNSIGNED + username VARCHAR(50)
 * - role VARCHAR(10) → role ENUM('USER', 'ADMIN')
 * - status VARCHAR(20) → status ENUM('ACTIVE', 'SUSPENDED', 'DORMANT')
 * - phone VARCHAR(20) → phone CHAR(11) (하이픈 제거)
 */
public class Member {
    // Primary Key
    private Long memberId;  // BIGINT UNSIGNED (기존 id → memberId)

    // 로그인 정보
    private String username;  // VARCHAR(50) - 로그인 ID (기존 id → username)
    private String pwd;  // VARCHAR(255) - BCrypt 해시

    // 기본 정보
    private String name;  // VARCHAR(100)
    private String email;  // VARCHAR(100)
    private String phone;  // CHAR(11) - 하이픈 제거 (01012345678)
    private Date birth;  // DATE
    private String gender;  // ENUM('MALE', 'FEMALE', 'OTHER')

    // 권한 및 상태
    private String role;  // ENUM('USER', 'ADMIN')
    private String status;  // ENUM('ACTIVE', 'SUSPENDED', 'DORMANT')

    // 보안 정보
    private String securityQuestion;  // VARCHAR(200)
    private String securityAnswer;  // VARCHAR(255) - 해시

    // 부가 정보
    private BigDecimal kindnessTemperature;  // DECIMAL(5, 2)
    private String profileImageUrl;  // VARCHAR(500)

    // 시스템 정보
    private Timestamp lastLoginAt;  // TIMESTAMP
    private String lastLoginIp;  // VARCHAR(45)
    private Integer loginFailCount;  // TINYINT UNSIGNED
    private Timestamp lastLoginFailAt;  // TIMESTAMP - 마지막 로그인 실패 일시
    private Timestamp accountLockedUntil;  // TIMESTAMP - 계정 잠금 해제 시간
    private Timestamp createdAt;  // TIMESTAMP
    private Timestamp updatedAt;  // TIMESTAMP
    private Timestamp deletedAt;  // TIMESTAMP (소프트 삭제)

    // 기본 생성자
    public Member() {
    }

    // 편의 생성자 (로그인용)
    public Member(String username, String pwd) {
        this.username = username;
        this.pwd = pwd;
    }

    // 편의 생성자 (회원가입용)
    public Member(String username, String pwd, String name, String email) {
        this.username = username;
        this.pwd = pwd;
        this.name = name;
        this.email = email;
    }

    // Getters and Setters
    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPwd() {
        return pwd;
    }

    public void setPwd(String pwd) {
        this.pwd = pwd;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Date getBirth() {
        return birth;
    }

    public void setBirth(Date birth) {
        this.birth = birth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSecurityQuestion() {
        return securityQuestion;
    }

    public void setSecurityQuestion(String securityQuestion) {
        this.securityQuestion = securityQuestion;
    }

    public String getSecurityAnswer() {
        return securityAnswer;
    }

    public void setSecurityAnswer(String securityAnswer) {
        this.securityAnswer = securityAnswer;
    }

    public BigDecimal getKindnessTemperature() {
        return kindnessTemperature;
    }

    public void setKindnessTemperature(BigDecimal kindnessTemperature) {
        this.kindnessTemperature = kindnessTemperature;
    }

    public String getProfileImageUrl() {
        return profileImageUrl;
    }

    public void setProfileImageUrl(String profileImageUrl) {
        this.profileImageUrl = profileImageUrl;
    }

    public Timestamp getLastLoginAt() {
        return lastLoginAt;
    }

    public void setLastLoginAt(Timestamp lastLoginAt) {
        this.lastLoginAt = lastLoginAt;
    }

    public String getLastLoginIp() {
        return lastLoginIp;
    }

    public void setLastLoginIp(String lastLoginIp) {
        this.lastLoginIp = lastLoginIp;
    }

    public Integer getLoginFailCount() {
        return loginFailCount;
    }

    public void setLoginFailCount(Integer loginFailCount) {
        this.loginFailCount = loginFailCount;
    }

    public Timestamp getLastLoginFailAt() {
        return lastLoginFailAt;
    }

    public void setLastLoginFailAt(Timestamp lastLoginFailAt) {
        this.lastLoginFailAt = lastLoginFailAt;
    }

    public Timestamp getAccountLockedUntil() {
        return accountLockedUntil;
    }

    public void setAccountLockedUntil(Timestamp accountLockedUntil) {
        this.accountLockedUntil = accountLockedUntil;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Timestamp getDeletedAt() {
        return deletedAt;
    }

    public void setDeletedAt(Timestamp deletedAt) {
        this.deletedAt = deletedAt;
    }

    // 유틸리티 메서드

    /**
     * 활성 회원 여부 확인
     */
    public boolean isActive() {
        return "ACTIVE".equals(this.status) && this.deletedAt == null;
    }

    /**
     * 관리자 여부 확인
     */
    public boolean isAdmin() {
        return "ADMIN".equals(this.role);
    }

    /**
     * 전화번호 포맷팅 (하이픈 추가)
     * DB: 01012345678 → 출력: 010-1234-5678
     */
    public String getFormattedPhone() {
        if (phone == null || phone.length() != 11) {
            return phone;
        }
        return phone.substring(0, 3) + "-" + phone.substring(3, 7) + "-" + phone.substring(7);
    }

    /**
     * 전화번호 정규화 (하이픈 제거)
     * 입력: 010-1234-5678 → DB: 01012345678
     */
    public static String normalizePhone(String phone) {
        if (phone == null) {
            return null;
        }
        return phone.replaceAll("[^0-9]", "");
    }

    @Override
    public String toString() {
        return "Member{" +
                "memberId=" + memberId +
                ", username='" + username + '\'' +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", role='" + role + '\'' +
                ", status='" + status + '\'' +
                ", birth=" + birth +
                ", gender='" + gender + '\'' +
                ", kindnessTemperature=" + kindnessTemperature +
                ", createdAt=" + createdAt +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Member member = (Member) o;
        return Objects.equals(memberId, member.memberId) &&
               Objects.equals(username, member.username) &&
               Objects.equals(email, member.email);
    }

    @Override
    public int hashCode() {
        return Objects.hash(memberId, username, email);
    }
}
