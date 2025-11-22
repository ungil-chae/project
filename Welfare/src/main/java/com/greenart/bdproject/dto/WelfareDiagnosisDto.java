package com.greenart.bdproject.dto;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * 복지 진단 DTO (최적화 버전)
 * DB 스키마 변경에 따른 수정:
 * - userId VARCHAR(50) → memberId BIGINT UNSIGNED
 * - Integer → Byte (householdSize, childrenCount, age)
 * - String gender/maritalStatus/employmentStatus/incomeLevel → ENUM
 * - TEXT matchedServicesJson → JSON (String으로 처리)
 */
public class WelfareDiagnosisDto {
    // Primary Key
    private Long diagnosisId;  // BIGINT UNSIGNED

    // 회원 정보
    private Long memberId;  // BIGINT UNSIGNED (기존 userId → memberId)

    // 기본 정보
    private Date birthDate;  // DATE
    private Byte age;  // TINYINT UNSIGNED - 나이 (성능을 위해 미리 계산)
    private String gender;  // ENUM('MALE', 'FEMALE', 'OTHER')

    // 가구 정보
    private Byte householdSize;  // TINYINT UNSIGNED - 가구원 수
    private String incomeLevel;  // ENUM('LEVEL_1', 'LEVEL_2', 'LEVEL_3', 'LEVEL_4', 'LEVEL_5')
    private BigDecimal monthlyIncome;  // DECIMAL(12, 2) - 월 소득

    private String maritalStatus;  // ENUM('SINGLE', 'MARRIED', 'DIVORCED', 'WIDOWED', 'SEPARATED')
    private Byte childrenCount;  // TINYINT UNSIGNED - 자녀 수
    private String employmentStatus;  // ENUM('EMPLOYED', 'UNEMPLOYED', 'SELF_EMPLOYED', 'STUDENT', 'RETIRED', 'HOMEMAKER')

    // 지역 정보
    private String sido;  // VARCHAR(50)
    private String sigungu;  // VARCHAR(50)

    // 특성 정보
    private Boolean isPregnant;  // BOOLEAN
    private Boolean isDisabled;  // BOOLEAN
    private Byte disabilityGrade;  // TINYINT UNSIGNED - 장애 등급 (1-6)
    private Boolean isMulticultural;  // BOOLEAN
    private Boolean isVeteran;  // BOOLEAN
    private Boolean isSingleParent;  // BOOLEAN
    private Boolean isElderlyLivingAlone;  // BOOLEAN - 독거노인
    private Boolean isLowIncome;  // BOOLEAN - 저소득층

    // 매칭 결과 (JSON)
    private String matchedServices;  // JSON → String으로 처리
    private Short matchedServicesCount;  // SMALLINT UNSIGNED
    private Integer totalMatchingScore;  // INT UNSIGNED

    // 개인정보 동의
    private Boolean saveConsent;  // BOOLEAN
    private Boolean privacyConsent;  // BOOLEAN
    private Boolean marketingConsent;  // BOOLEAN

    // 추적 정보
    private String ipAddress;  // VARCHAR(45)
    private String userAgent;  // VARCHAR(500)
    private String referrerUrl;  // VARCHAR(500)

    // 시스템 정보
    private Timestamp createdAt;  // TIMESTAMP

    // 기본 생성자
    public WelfareDiagnosisDto() {
    }

    // 편의 생성자
    public WelfareDiagnosisDto(Long memberId, Date birthDate, String incomeLevel) {
        this.memberId = memberId;
        this.birthDate = birthDate;
        this.incomeLevel = incomeLevel;
    }

    // Getters and Setters
    public Long getDiagnosisId() {
        return diagnosisId;
    }

    public void setDiagnosisId(Long diagnosisId) {
        this.diagnosisId = diagnosisId;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public Date getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }

    public Byte getAge() {
        return age;
    }

    public void setAge(Byte age) {
        this.age = age;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Byte getHouseholdSize() {
        return householdSize;
    }

    public void setHouseholdSize(Byte householdSize) {
        this.householdSize = householdSize;
    }

    public String getIncomeLevel() {
        return incomeLevel;
    }

    public void setIncomeLevel(String incomeLevel) {
        this.incomeLevel = incomeLevel;
    }

    public BigDecimal getMonthlyIncome() {
        return monthlyIncome;
    }

    public void setMonthlyIncome(BigDecimal monthlyIncome) {
        this.monthlyIncome = monthlyIncome;
    }

    public String getMaritalStatus() {
        return maritalStatus;
    }

    public void setMaritalStatus(String maritalStatus) {
        this.maritalStatus = maritalStatus;
    }

    public Byte getChildrenCount() {
        return childrenCount;
    }

    public void setChildrenCount(Byte childrenCount) {
        this.childrenCount = childrenCount;
    }

    public String getEmploymentStatus() {
        return employmentStatus;
    }

    public void setEmploymentStatus(String employmentStatus) {
        this.employmentStatus = employmentStatus;
    }

    public String getSido() {
        return sido;
    }

    public void setSido(String sido) {
        this.sido = sido;
    }

    public String getSigungu() {
        return sigungu;
    }

    public void setSigungu(String sigungu) {
        this.sigungu = sigungu;
    }

    public Boolean getIsPregnant() {
        return isPregnant;
    }

    public void setIsPregnant(Boolean isPregnant) {
        this.isPregnant = isPregnant;
    }

    public Boolean getIsDisabled() {
        return isDisabled;
    }

    public void setIsDisabled(Boolean isDisabled) {
        this.isDisabled = isDisabled;
    }

    public Byte getDisabilityGrade() {
        return disabilityGrade;
    }

    public void setDisabilityGrade(Byte disabilityGrade) {
        this.disabilityGrade = disabilityGrade;
    }

    public Boolean getIsMulticultural() {
        return isMulticultural;
    }

    public void setIsMulticultural(Boolean isMulticultural) {
        this.isMulticultural = isMulticultural;
    }

    public Boolean getIsVeteran() {
        return isVeteran;
    }

    public void setIsVeteran(Boolean isVeteran) {
        this.isVeteran = isVeteran;
    }

    public Boolean getIsSingleParent() {
        return isSingleParent;
    }

    public void setIsSingleParent(Boolean isSingleParent) {
        this.isSingleParent = isSingleParent;
    }

    public Boolean getIsElderlyLivingAlone() {
        return isElderlyLivingAlone;
    }

    public void setIsElderlyLivingAlone(Boolean isElderlyLivingAlone) {
        this.isElderlyLivingAlone = isElderlyLivingAlone;
    }

    public Boolean getIsLowIncome() {
        return isLowIncome;
    }

    public void setIsLowIncome(Boolean isLowIncome) {
        this.isLowIncome = isLowIncome;
    }

    public String getMatchedServices() {
        return matchedServices;
    }

    public void setMatchedServices(String matchedServices) {
        this.matchedServices = matchedServices;
    }

    public Short getMatchedServicesCount() {
        return matchedServicesCount;
    }

    public void setMatchedServicesCount(Short matchedServicesCount) {
        this.matchedServicesCount = matchedServicesCount;
    }

    public Integer getTotalMatchingScore() {
        return totalMatchingScore;
    }

    public void setTotalMatchingScore(Integer totalMatchingScore) {
        this.totalMatchingScore = totalMatchingScore;
    }

    public Boolean getSaveConsent() {
        return saveConsent;
    }

    public void setSaveConsent(Boolean saveConsent) {
        this.saveConsent = saveConsent;
    }

    public Boolean getPrivacyConsent() {
        return privacyConsent;
    }

    public void setPrivacyConsent(Boolean privacyConsent) {
        this.privacyConsent = privacyConsent;
    }

    public Boolean getMarketingConsent() {
        return marketingConsent;
    }

    public void setMarketingConsent(Boolean marketingConsent) {
        this.marketingConsent = marketingConsent;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public String getReferrerUrl() {
        return referrerUrl;
    }

    public void setReferrerUrl(String referrerUrl) {
        this.referrerUrl = referrerUrl;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // 유틸리티 메서드

    /**
     * 생년월일로부터 나이 계산
     */
    public static byte calculateAge(Date birthDate) {
        if (birthDate == null) {
            return 0;
        }
        java.util.Calendar birth = java.util.Calendar.getInstance();
        birth.setTime(birthDate);

        java.util.Calendar now = java.util.Calendar.getInstance();

        int age = now.get(java.util.Calendar.YEAR) - birth.get(java.util.Calendar.YEAR);

        if (now.get(java.util.Calendar.DAY_OF_YEAR) < birth.get(java.util.Calendar.DAY_OF_YEAR)) {
            age--;
        }

        return (byte) age;
    }

    /**
     * 저소득층 여부 판단
     */
    public boolean isLowIncomeLevel() {
        return "LEVEL_1".equals(incomeLevel) || "LEVEL_2".equals(incomeLevel);
    }

    /**
     * 취약계층 여부 판단
     */
    public boolean isVulnerable() {
        return Boolean.TRUE.equals(isDisabled) ||
               Boolean.TRUE.equals(isSingleParent) ||
               Boolean.TRUE.equals(isElderlyLivingAlone) ||
               Boolean.TRUE.equals(isLowIncome);
    }

    @Override
    public String toString() {
        return "WelfareDiagnosisDto{" +
                "diagnosisId=" + diagnosisId +
                ", memberId=" + memberId +
                ", birthDate=" + birthDate +
                ", age=" + age +
                ", gender='" + gender + '\'' +
                ", householdSize=" + householdSize +
                ", incomeLevel='" + incomeLevel + '\'' +
                ", sido='" + sido + '\'' +
                ", sigungu='" + sigungu + '\'' +
                ", matchedServicesCount=" + matchedServicesCount +
                ", createdAt=" + createdAt +
                '}';
    }
}
