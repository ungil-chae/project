package com.greenart.bdproject.service;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.greenart.bdproject.mapper.DonationMapper;
import com.greenart.bdproject.dto.DonationDto;

@Service
@Transactional
public class DonationService {

    @Autowired
    private DonationMapper donationMapper;

    /**
     * 기부 등록 (캐시 무효화)
     * @param donation 기부 정보
     * @return 등록된 기부 정보
     */
    @CacheEvict(value = "donationStats", allEntries = true)
    public DonationDto createDonation(DonationDto donation) {
        int result = donationMapper.insert(donation);

        if (result > 0) {
            return donationMapper.selectById(donation.getDonationId().intValue());
        }

        return null;
    }

    /**
     * 기부 ID로 조회
     * @param donationId 기부 ID
     * @return 기부 정보
     */
    public DonationDto getDonationById(Long donationId) {
        return donationMapper.selectById(donationId.intValue());
    }

    /**
     * 사용자별 기부 내역 조회
     * @param userId 사용자 ID
     * @return 기부 내역 리스트
     */
    public List<DonationDto> getUserDonations(String userId) {
        return donationMapper.selectByUserId(userId);
    }

    /**
     * 전체 기부 내역 조회
     * @return 전체 기부 내역 리스트
     */
    public List<DonationDto> getAllDonations() {
        return donationMapper.selectAll();
    }

    /**
     * 총 기부 금액 조회 (캐시 적용)
     * @return 총 기부 금액
     */
    @Cacheable(value = "donationStats", key = "'totalAmount'")
    public BigDecimal getTotalAmount() {
        BigDecimal totalAmount = donationMapper.getTotalDonationAmount();
        return totalAmount != null ? totalAmount : BigDecimal.ZERO;
    }

    /**
     * 총 기부자 수 조회 (캐시 적용)
     * @return 총 기부자 수
     */
    @Cacheable(value = "donationStats", key = "'totalDonorCount'")
    public int getTotalDonorCount() {
        return donationMapper.countTotalDonors();
    }
}
