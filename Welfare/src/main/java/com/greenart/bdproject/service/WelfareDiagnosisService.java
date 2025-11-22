package com.greenart.bdproject.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.greenart.bdproject.dao.WelfareDiagnosisDao;
import com.greenart.bdproject.dto.WelfareDiagnosisDto;

@Service
@Transactional
public class WelfareDiagnosisService {

    @Autowired
    private WelfareDiagnosisDao welfareDiagnosisDao;

    /**
     * 복지 진단 결과 저장
     * @param diagnosis 복지 진단 정보
     * @return 저장된 진단 정보
     */
    public WelfareDiagnosisDto saveDiagnosis(WelfareDiagnosisDto diagnosis) {
        int result = welfareDiagnosisDao.insertDiagnosis(diagnosis);

        if (result > 0) {
            return welfareDiagnosisDao.selectById(diagnosis.getDiagnosisId());
        }

        return null;
    }

    /**
     * 사용자별 진단 내역 조회
     * @param userId 사용자 ID
     * @return 진단 내역 리스트
     */
    public List<WelfareDiagnosisDto> getUserDiagnoses(Long userId) {
        return welfareDiagnosisDao.selectByUserId(userId);
    }

    /**
     * 사용자 최근 진단 결과 조회
     * @param userId 사용자 ID
     * @return 최근 진단 정보
     */
    public WelfareDiagnosisDto getLatestDiagnosis(Long userId) {
        return welfareDiagnosisDao.selectLatestByUserId(userId);
    }
}
