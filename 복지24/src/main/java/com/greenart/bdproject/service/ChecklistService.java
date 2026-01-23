package com.greenart.bdproject.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.greenart.bdproject.dto.CommonDocumentDto;
import com.greenart.bdproject.dto.RequiredDocumentDto;
import com.greenart.bdproject.dto.UserChecklistDto;
import com.greenart.bdproject.mapper.ChecklistMapper;

@Service
@Transactional
public class ChecklistService {

    @Autowired
    private ChecklistMapper checklistMapper;

    // ========== 공통 서류 관련 ==========

    public List<CommonDocumentDto> getAllCommonDocuments() {
        return checklistMapper.selectAllCommonDocuments();
    }

    public List<CommonDocumentDto> getCommonDocumentsByCategory(String category) {
        return checklistMapper.selectCommonDocumentsByCategory(category);
    }

    // ========== 필요 서류 관련 ==========

    public List<RequiredDocumentDto> getRequiredDocuments(String serviceId) {
        return checklistMapper.selectRequiredDocumentsByServiceId(serviceId);
    }

    public boolean hasRequiredDocuments(String serviceId) {
        return checklistMapper.countRequiredDocumentsByServiceId(serviceId) > 0;
    }

    public int addRequiredDocument(RequiredDocumentDto document) {
        return checklistMapper.insertRequiredDocument(document);
    }

    // ========== 사용자 체크리스트 관련 ==========

    /**
     * 사용자의 특정 서비스 체크리스트 조회
     * 체크리스트가 없으면 초기화 후 조회
     */
    public List<UserChecklistDto> getUserChecklist(Long memberId, String serviceId) {
        // 해당 서비스에 필요 서류가 없으면 빈 리스트 반환
        if (!hasRequiredDocuments(serviceId)) {
            return new ArrayList<>();
        }

        // 체크리스트가 초기화되어 있지 않으면 초기화
        int existingCount = checklistMapper.countTotalByMemberAndService(memberId, serviceId);
        if (existingCount == 0) {
            checklistMapper.initializeUserChecklist(memberId, serviceId);
        }

        return checklistMapper.selectUserChecklist(memberId, serviceId);
    }

    /**
     * 서류 체크 상태 토글
     */
    public boolean toggleCheckStatus(Long memberId, String serviceId, Long documentId) {
        UserChecklistDto item = checklistMapper.selectUserChecklistItem(memberId, serviceId, documentId);
        if (item == null) {
            return false;
        }

        boolean newStatus = !Boolean.TRUE.equals(item.getIsChecked());
        return checklistMapper.updateCheckStatus(memberId, serviceId, documentId, newStatus) > 0;
    }

    /**
     * 서류 체크 상태 직접 설정
     */
    public boolean setCheckStatus(Long memberId, String serviceId, Long documentId, boolean isChecked) {
        return checklistMapper.updateCheckStatus(memberId, serviceId, documentId, isChecked) > 0;
    }

    /**
     * 메모 업데이트
     */
    public boolean updateMemo(Long memberId, String serviceId, Long documentId, String memo) {
        return checklistMapper.updateMemo(memberId, serviceId, documentId, memo) > 0;
    }

    /**
     * 체크리스트 삭제 (서비스 전체)
     */
    public boolean deleteUserChecklist(Long memberId, String serviceId) {
        return checklistMapper.deleteUserChecklist(memberId, serviceId) > 0;
    }

    // ========== 진행률 관련 ==========

    /**
     * 특정 서비스 체크리스트 진행률 조회
     */
    public Map<String, Object> getProgress(Long memberId, String serviceId) {
        Map<String, Object> progress = new HashMap<>();

        int checked = checklistMapper.countCheckedByMemberAndService(memberId, serviceId);
        int total = checklistMapper.countTotalByMemberAndService(memberId, serviceId);

        progress.put("checked", checked);
        progress.put("total", total);
        progress.put("percentage", total > 0 ? (int) Math.round((double) checked / total * 100) : 0);
        progress.put("isComplete", checked == total && total > 0);

        return progress;
    }

    // ========== 사용자의 모든 체크리스트 ==========

    /**
     * 사용자가 진행 중인 모든 체크리스트 조회
     */
    public List<Map<String, Object>> getAllUserChecklists(Long memberId) {
        List<String> serviceIds = checklistMapper.selectServiceIdsByMemberId(memberId);
        List<Map<String, Object>> result = new ArrayList<>();

        for (String serviceId : serviceIds) {
            Map<String, Object> checklistInfo = new HashMap<>();
            checklistInfo.put("serviceId", serviceId);
            checklistInfo.put("progress", getProgress(memberId, serviceId));
            checklistInfo.put("items", checklistMapper.selectUserChecklist(memberId, serviceId));
            result.add(checklistInfo);
        }

        return result;
    }

    /**
     * 사용자가 진행 중인 모든 체크리스트의 서비스 ID와 진행률만 조회 (경량)
     */
    public List<Map<String, Object>> getAllUserChecklistsSummary(Long memberId) {
        List<String> serviceIds = checklistMapper.selectServiceIdsByMemberId(memberId);
        List<Map<String, Object>> result = new ArrayList<>();

        for (String serviceId : serviceIds) {
            Map<String, Object> summary = new HashMap<>();
            summary.put("serviceId", serviceId);
            summary.put("progress", getProgress(memberId, serviceId));
            result.add(summary);
        }

        return result;
    }

    // ========== 체크리스트 초기화 ==========

    /**
     * 서비스에 대한 체크리스트 초기화 (강제)
     */
    public int initializeChecklist(Long memberId, String serviceId) {
        // 기존 체크리스트가 있으면 삭제
        checklistMapper.deleteUserChecklist(memberId, serviceId);
        // 새로 초기화
        return checklistMapper.initializeUserChecklist(memberId, serviceId);
    }
}
