package com.greenart.bdproject.mapper;

import java.math.BigDecimal;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.greenart.bdproject.dto.DonationDto;

@Mapper
public interface DonationMapper {

    int insert(DonationDto donation);

    DonationDto selectById(@Param("donationId") int donationId);

    List<DonationDto> selectByUserId(@Param("userId") String userId);

    List<DonationDto> selectAll();

    BigDecimal getTotalDonationAmount();

    int countTotalDonors();
}
