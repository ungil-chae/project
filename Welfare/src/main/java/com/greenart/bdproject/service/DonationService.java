package com.greenart.bdproject.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.greenart.bdproject.dao.DonationDao;
import com.greenart.bdproject.dto.DonationDto;

@Service
@Transactional
public class DonationService {

    @Autowired
    private DonationDao donationDao;

    /**
     * 기부 등록
     * @param donation 기부 정보
     * @return 등록된 기부 정보
     */
    public DonationDto createDonation(DonationDto donation) {
        int result = donationDao.insertDonation(donation);

        if (result > 0) {
            return donationDao.selectById(donation.getDonationId());
        }

        return null;
    }

    /**
     * 기부 ID로 조회
     * @param donationId 기부 ID
     * @return 기부 정보
     */
    public DonationDto getDonationById(Long donationId) {
        return donationDao.selectById(donationId);
    }

    /**
     * 사용자별 기부 내역 조회
     * @param userId 사용자 ID
     * @return 기부 내역 리스트
     */
    public List<DonationDto> getUserDonations(Long userId) {
        return donationDao.selectByUserId(userId);
    }

    /**
     * 전체 기부 내역 조회
     * @return 전체 기부 내역 리스트
     */
    public List<DonationDto> getAllDonations() {
        return donationDao.selectAll();
    }

    /**
     * 총 기부 금액 조회
     * @return 총 기부 금액
     */
    public Double getTotalAmount() {
        Double totalAmount = donationDao.getTotalDonationAmount();
        return totalAmount != null ? totalAmount : 0.0;
    }

    /**
     * 총 기부자 수 조회
     * @return 총 기부자 수
     */
    public int getTotalDonorCount() {
        return donationDao.countTotalDonors();
    }
}
