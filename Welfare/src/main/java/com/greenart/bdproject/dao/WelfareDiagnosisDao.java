package com.greenart.bdproject.dao;

import java.util.List;
import com.greenart.bdproject.dto.WelfareDiagnosisDto;

public interface WelfareDiagnosisDao {

    /**
     * 복지 진단 결과 저장
     * @param diagnosis 진단 정보
     * @return int 등록된 행 수
     */
    int insertDiagnosis(WelfareDiagnosisDto diagnosis);

    /**
     * 회원별 진단 내역 조회
     * @param memberId 회원 ID
     * @return List<WelfareDiagnosisDto> 진단 목록
     */
    List<WelfareDiagnosisDto> selectByMemberId(Long memberId);

    /**
     * ID로 진단 결과 조회
     * @param diagnosisId 진단 ID
     * @return WelfareDiagnosisDto 진단 정보
     */
    WelfareDiagnosisDto selectById(Long diagnosisId);

    /**
     * 최근 진단 결과 조회
     * @param memberId 회원 ID
     * @return WelfareDiagnosisDto 최근 진단 정보
     */
    WelfareDiagnosisDto selectLatestByMemberId(Long memberId);
}
