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
     * 사용자별 진단 내역 조회
     * @param userId 사용자 ID
     * @return List<WelfareDiagnosisDto> 진단 목록
     */
    List<WelfareDiagnosisDto> selectByUserId(String userId);

    /**
     * ID로 진단 결과 조회
     * @param diagnosisId 진단 ID
     * @return WelfareDiagnosisDto 진단 정보
     */
    WelfareDiagnosisDto selectById(Long diagnosisId);

    /**
     * 최근 진단 결과 조회
     * @param userId 사용자 ID
     * @return WelfareDiagnosisDto 최근 진단 정보
     */
    WelfareDiagnosisDto selectLatestByUserId(String userId);
}
