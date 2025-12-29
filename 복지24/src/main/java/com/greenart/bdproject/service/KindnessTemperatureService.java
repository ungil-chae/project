package com.greenart.bdproject.service;

import java.math.BigDecimal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.greenart.bdproject.dao.MemberDao;

/**
 * 선행온도 관리 서비스
 * 봉사, 기부, 리뷰 작성 등의 활동에 따라 온도를 증가시킴
 */
@Service
@Transactional
public class KindnessTemperatureService {

    private static final Logger logger = LoggerFactory.getLogger(KindnessTemperatureService.class);

    @Autowired(required = false)
    private MemberDao memberDao;

    // 온도 증가 규칙 (단위: 도)
    private static final BigDecimal VOLUNTEER_APPLICATION = new BigDecimal("0.3");  // 봉사 신청
    private static final BigDecimal VOLUNTEER_COMPLETION = new BigDecimal("0.5");   // 봉사 완료
    private static final BigDecimal DONATION_SMALL = new BigDecimal("0.1");        // 소액 기부 (5만원 미만)
    private static final BigDecimal DONATION_MEDIUM = new BigDecimal("0.3");       // 중액 기부 (5~20만원)
    private static final BigDecimal DONATION_LARGE = new BigDecimal("0.5");        // 고액 기부 (20만원 이상)
    private static final BigDecimal VOLUNTEER_REVIEW = new BigDecimal("0.2");      // 봉사 후기 작성
    private static final BigDecimal DONATION_REVIEW = new BigDecimal("0.1");       // 기부 후기 작성

    // 온도 감소 규칙 (단위: 도)
    private static final BigDecimal VOLUNTEER_CANCELLATION = new BigDecimal("0.5"); // 봉사 취소 (24시간 이내)

    /**
     * 현재 선행온도 조회
     */
    public BigDecimal getCurrentTemperature(String userId) {
        if (memberDao == null) {
            logger.warn("MemberDao가 null입니다. 기본 온도 반환");
            return new BigDecimal("36.50");
        }
        try {
            BigDecimal temperature = memberDao.getKindnessTemperature(userId);
            return temperature != null ? temperature : new BigDecimal("36.50");
        } catch (Exception e) {
            logger.error("온도 조회 실패: userId={}", userId, e);
            return new BigDecimal("36.50");
        }
    }

    /**
     * 봉사 신청 시 온도 증가
     */
    public void increaseForVolunteerApplication(String userId) {
        increaseTemperature(userId, VOLUNTEER_APPLICATION, "봉사 신청");
    }

    /**
     * 봉사 완료 시 온도 증가
     */
    public void increaseForVolunteerCompletion(String userId) {
        increaseTemperature(userId, VOLUNTEER_COMPLETION, "봉사 완료");
    }

    /**
     * 기부 시 온도 증가 (금액에 따라 차등)
     */
    public void increaseForDonation(String userId, BigDecimal amount) {
        BigDecimal increase;
        if (amount.compareTo(new BigDecimal("200000")) >= 0) {
            increase = DONATION_LARGE;
        } else if (amount.compareTo(new BigDecimal("50000")) >= 0) {
            increase = DONATION_MEDIUM;
        } else {
            increase = DONATION_SMALL;
        }
        increaseTemperature(userId, increase, "기부 완료 (" + amount + "원)");
    }

    /**
     * 봉사 후기 작성 시 온도 증가
     */
    public void increaseForVolunteerReview(String userId) {
        increaseTemperature(userId, VOLUNTEER_REVIEW, "봉사 후기 작성");
    }

    /**
     * 기부 후기 작성 시 온도 증가
     */
    public void increaseForDonationReview(String userId) {
        increaseTemperature(userId, DONATION_REVIEW, "기부 후기 작성");
    }

    /**
     * 온도 증가 공통 메서드
     */
    private void increaseTemperature(String userId, BigDecimal amount, String reason) {
        if (memberDao == null) {
            logger.warn("MemberDao가 null입니다. 온도 증가 건너뜀 - userId: {}, 사유: {}", userId, reason);
            return;
        }
        try {
            int result = memberDao.increaseKindnessTemperature(userId, amount);
            if (result > 0) {
                BigDecimal newTemp = getCurrentTemperature(userId);
                logger.info("선행온도 증가 성공 - userId: {}, 사유: {}", userId, reason);
                logger.debug("증가량: {}도, 현재온도: {}도", amount, newTemp);
            } else {
                logger.warn("선행온도 증가 실패 - userId: {}, 사유: {}", userId, reason);
            }
        } catch (Exception e) {
            logger.error("선행온도 증가 오류 - userId: " + userId + ", 사유: " + reason, e);
        }
    }

    /**
     * 온도 직접 설정 (관리자용)
     */
    public void setTemperature(String userId, BigDecimal temperature) {
        if (memberDao == null) {
            logger.warn("MemberDao가 null입니다. 온도 설정 건너뜀");
            return;
        }
        try {
            memberDao.updateKindnessTemperature(userId, temperature);
            logger.info("선행온도 설정 - userId: {}, 온도: {}도", userId, temperature);
        } catch (Exception e) {
            logger.error("선행온도 설정 실패 - userId: {}", userId, e);
        }
    }

    /**
     * 봉사 취소 시 온도 감소 (24시간 이내 취소 시)
     */
    public void decreaseForVolunteerCancellation(String userId) {
        decreaseTemperature(userId, VOLUNTEER_CANCELLATION, "봉사 취소 (24시간 이내)");
    }

    /**
     * 온도 감소 공통 메서드 (최소 0.00 보장)
     */
    private void decreaseTemperature(String userId, BigDecimal amount, String reason) {
        if (memberDao == null) {
            logger.warn("MemberDao가 null입니다. 온도 감소 건너뜀 - userId: {}, 사유: {}", userId, reason);
            return;
        }
        try {
            int result = memberDao.decreaseKindnessTemperature(userId, amount);
            if (result > 0) {
                BigDecimal newTemp = getCurrentTemperature(userId);
                logger.info("선행온도 감소 성공 - userId: {}, 사유: {}", userId, reason);
                logger.debug("감소량: {}도, 현재온도: {}도", amount, newTemp);
            } else {
                logger.warn("선행온도 감소 실패 - userId: {}, 사유: {}", userId, reason);
            }
        } catch (Exception e) {
            logger.error("선행온도 감소 오류 - userId: " + userId + ", 사유: " + reason, e);
        }
    }
}
