package com.greenart.bdproject.dao;

import java.util.List;
import com.greenart.bdproject.dto.DonationDto;

public interface DonationDao {

    /**
     * 후원 정보 등록
     * @param donation 후원 정보
     * @return int 등록된 행 수
     */
    int insertDonation(DonationDto donation);

    /**
     * ID로 후원 정보 조회
     * @param donationId 후원 ID
     * @return DonationDto 후원 정보
     */
    DonationDto selectById(Long donationId);

    /**
     * 사용자별 후원 내역 조회
     * @param userId 사용자 ID
     * @return List<DonationDto> 후원 목록
     */
    List<DonationDto> selectByUserId(Long userId);

    /**
     * 전체 후원 목록 조회
     * @return List<DonationDto> 후원 목록
     */
    List<DonationDto> selectAll();

    /**
     * 누적 지원금 조회
     * @return Double 총 후원 금액
     */
    Double getTotalDonationAmount();

    /**
     * 총 후원자 수 조회
     * @return int 후원자 수
     */
    int countTotalDonors();
}
