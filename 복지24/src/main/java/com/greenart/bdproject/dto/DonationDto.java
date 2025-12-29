package com.greenart.bdproject.dto;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * 기부 DTO (최적화 버전)
 * DB 스키마 변경에 따른 수정:
 * - userId VARCHAR(50) → memberId BIGINT UNSIGNED
 * - amount DOUBLE → amount DECIMAL(15, 2)
 * - category VARCHAR(50) → categoryId TINYINT UNSIGNED
 * - donorPhone VARCHAR(20) → donorPhone CHAR(11)
 * - payment_method/donation_type/payment_status → ENUM
 */
public class DonationDto {
    // Primary Key
    private Long donationId;  // BIGINT UNSIGNED

    // 회원 정보
    private Long memberId;  // BIGINT UNSIGNED (기존 userId → memberId)

    // 카테고리 정보
    private Integer categoryId;  // TINYINT UNSIGNED (정규화됨)
    private String categoryName;  // 조회용 (JOIN 시 사용)

    // 기부 정보
    private BigDecimal amount;  // DECIMAL(15, 2) - Double보다 정확함
    private String donationType;  // ENUM('REGULAR', 'ONETIME')
    private String packageName;  // VARCHAR(100)

    // 후원자 정보 (비회원 포함)
    private String donorName;  // VARCHAR(100)
    private String donorEmail;  // VARCHAR(100)
    private String donorPhone;  // CHAR(11) - 하이픈 제거
    private String message;  // TEXT

    // 결제 정보
    private String paymentMethod;  // ENUM('CREDIT_CARD', 'BANK_TRANSFER', 'KAKAO_PAY', 'NAVER_PAY', 'TOSS_PAY')
    private String paymentStatus;  // ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED', 'CANCELLED')
    private String transactionId;  // VARCHAR(100) - PG사 거래번호

    // 영수증 정보
    private Boolean receiptIssued;  // BOOLEAN

    // 서명 정보
    private String signatureImage;  // LONGTEXT (Base64 이미지)

    // 정기 기부 정보
    private java.sql.Date regularStartDate;  // DATE (정기 기부 시작일)

    // 환불 정보
    private Integer refundAmount;  // 환불 금액 (수수료 제외)
    private Integer refundFee;  // 환불 수수료

    // 시스템 정보
    private Timestamp createdAt;  // TIMESTAMP
    private Timestamp refundedAt;  // TIMESTAMP (환불일)

    // 리뷰 정보 (조회용)
    private Boolean hasReview;  // 리뷰 작성 여부

    // 기본 생성자
    public DonationDto() {
    }

    // 편의 생성자 (회원 기부)
    public DonationDto(Long memberId, Integer categoryId, BigDecimal amount, String donationType) {
        this.memberId = memberId;
        this.categoryId = categoryId;
        this.amount = amount;
        this.donationType = donationType;
    }

    // Getters and Setters
    public Long getDonationId() {
        return donationId;
    }

    public void setDonationId(Long donationId) {
        this.donationId = donationId;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getDonationType() {
        return donationType;
    }

    public void setDonationType(String donationType) {
        this.donationType = donationType;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    public String getDonorName() {
        return donorName;
    }

    public void setDonorName(String donorName) {
        this.donorName = donorName;
    }

    public String getDonorEmail() {
        return donorEmail;
    }

    public void setDonorEmail(String donorEmail) {
        this.donorEmail = donorEmail;
    }

    public String getDonorPhone() {
        return donorPhone;
    }

    public void setDonorPhone(String donorPhone) {
        this.donorPhone = donorPhone;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public Boolean getReceiptIssued() {
        return receiptIssued;
    }

    public void setReceiptIssued(Boolean receiptIssued) {
        this.receiptIssued = receiptIssued;
    }

    public String getSignatureImage() {
        return signatureImage;
    }

    public void setSignatureImage(String signatureImage) {
        this.signatureImage = signatureImage;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getRefundedAt() {
        return refundedAt;
    }

    public void setRefundedAt(Timestamp refundedAt) {
        this.refundedAt = refundedAt;
    }

    public java.sql.Date getRegularStartDate() {
        return regularStartDate;
    }

    public void setRegularStartDate(java.sql.Date regularStartDate) {
        this.regularStartDate = regularStartDate;
    }

    public Boolean getHasReview() {
        return hasReview;
    }

    public void setHasReview(Boolean hasReview) {
        this.hasReview = hasReview;
    }

    public Integer getRefundAmount() {
        return refundAmount;
    }

    public void setRefundAmount(Integer refundAmount) {
        this.refundAmount = refundAmount;
    }

    public Integer getRefundFee() {
        return refundFee;
    }

    public void setRefundFee(Integer refundFee) {
        this.refundFee = refundFee;
    }

    // 유틸리티 메서드

    /**
     * 전화번호 포맷팅 (하이픈 추가)
     */
    public String getFormattedDonorPhone() {
        if (donorPhone == null || donorPhone.length() != 11) {
            return donorPhone;
        }
        return donorPhone.substring(0, 3) + "-" + donorPhone.substring(3, 7) + "-" + donorPhone.substring(7);
    }

    /**
     * 정기 기부 여부
     */
    public boolean isRegular() {
        return "REGULAR".equals(this.donationType);
    }

    /**
     * 완료된 기부 여부
     */
    public boolean isCompleted() {
        return "COMPLETED".equals(this.paymentStatus);
    }

    /**
     * 환불된 기부 여부
     */
    public boolean isRefunded() {
        return "REFUNDED".equals(this.paymentStatus);
    }

    /**
     * 금액을 원 단위 문자열로 포맷팅
     */
    public String getFormattedAmount() {
        if (amount == null) {
            return "0원";
        }
        return String.format("%,d원", amount.longValue());
    }

    @Override
    public String toString() {
        return "DonationDto{" +
                "donationId=" + donationId +
                ", memberId=" + memberId +
                ", categoryId=" + categoryId +
                ", categoryName='" + categoryName + '\'' +
                ", amount=" + amount +
                ", donationType='" + donationType + '\'' +
                ", donorName='" + donorName + '\'' +
                ", donorEmail='" + donorEmail + '\'' +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
