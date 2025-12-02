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
     * 회원별 진단 내역 조회
     * @param memberId 회원 ID
     * @return 진단 내역 리스트
     */
    public List<WelfareDiagnosisDto> getUserDiagnoses(Long memberId) {
        return welfareDiagnosisDao.selectByMemberId(memberId);
    }

    /**
     * 회원 최근 진단 결과 조회
     * @param memberId 회원 ID
     * @return 최근 진단 정보
     */
    public WelfareDiagnosisDto getLatestDiagnosis(Long memberId) {
        return welfareDiagnosisDao.selectLatestByMemberId(memberId);
    }
}
