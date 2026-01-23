package com.greenart.bdproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.greenart.bdproject.dto.CommonDocumentDto;
import com.greenart.bdproject.dto.RequiredDocumentDto;
import com.greenart.bdproject.dto.UserChecklistDto;

@Mapper
public interface ChecklistMapper {

    // ========== 공통 서류 관련 ==========

    List<CommonDocumentDto> selectAllCommonDocuments();

    List<CommonDocumentDto> selectCommonDocumentsByCategory(@Param("category") String category);

    // ========== 필요 서류 관련 ==========

    List<RequiredDocumentDto> selectRequiredDocumentsByServiceId(@Param("serviceId") String serviceId);

    int insertRequiredDocument(RequiredDocumentDto document);

    int countRequiredDocumentsByServiceId(@Param("serviceId") String serviceId);

    // ========== 사용자 체크리스트 관련 ==========

    List<UserChecklistDto> selectUserChecklist(
            @Param("memberId") Long memberId,
            @Param("serviceId") String serviceId);

    UserChecklistDto selectUserChecklistItem(
            @Param("memberId") Long memberId,
            @Param("serviceId") String serviceId,
            @Param("documentId") Long documentId);

    int insertUserChecklistItem(UserChecklistDto checklist);

    int updateCheckStatus(
            @Param("memberId") Long memberId,
            @Param("serviceId") String serviceId,
            @Param("documentId") Long documentId,
            @Param("isChecked") Boolean isChecked);

    int updateMemo(
            @Param("memberId") Long memberId,
            @Param("serviceId") String serviceId,
            @Param("documentId") Long documentId,
            @Param("memo") String memo);

    int deleteUserChecklist(
            @Param("memberId") Long memberId,
            @Param("serviceId") String serviceId);

    // ========== 진행률 관련 ==========

    int countCheckedByMemberAndService(
            @Param("memberId") Long memberId,
            @Param("serviceId") String serviceId);

    int countTotalByMemberAndService(
            @Param("memberId") Long memberId,
            @Param("serviceId") String serviceId);

    // ========== 사용자의 모든 체크리스트 ==========

    List<String> selectServiceIdsByMemberId(@Param("memberId") Long memberId);

    // ========== 체크리스트 초기화 (서비스의 모든 서류를 사용자 체크리스트에 추가) ==========

    int initializeUserChecklist(
            @Param("memberId") Long memberId,
            @Param("serviceId") String serviceId);
}
