package com.greenart.bdproject.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.greenart.bdproject.dto.CommonDocumentDto;
import com.greenart.bdproject.dto.RequiredDocumentDto;
import com.greenart.bdproject.dto.UserChecklistDto;
import com.greenart.bdproject.mapper.MemberMapper;
import com.greenart.bdproject.service.ChecklistService;

/**
 * 체크리스트 API 컨트롤러
 * 복지 서비스 신청에 필요한 서류 체크리스트 관리
 * URL 패턴: /api/checklist/*
 */
@RestController
@RequestMapping("/api/checklist")
public class ChecklistApiController {

    private static final Logger logger = LoggerFactory.getLogger(ChecklistApiController.class);

    @Autowired
    private ChecklistService checklistService;

    @Autowired
    private MemberMapper memberMapper;

    /**
     * 로그인 사용자의 member_id 조회
     */
    private Long getMemberId(HttpSession session) {
        String userId = (String) session.getAttribute("id");
        if (userId == null || userId.isEmpty()) {
            userId = (String) session.getAttribute("userId");
        }
        if (userId == null || userId.isEmpty()) {
            return null;
        }
        return memberMapper.findMemberIdByEmail(userId);
    }

    // ========== 공통 서류 조회 ==========

    /**
     * 전체 공통 서류 목록 조회
     * GET /api/checklist/common-documents
     */
    @GetMapping("/common-documents")
    public Map<String, Object> getCommonDocuments() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<CommonDocumentDto> documents = checklistService.getAllCommonDocuments();
            response.put("success", true);
            response.put("data", documents);
        } catch (Exception e) {
            logger.error("공통 서류 조회 실패", e);
            response.put("success", false);
            response.put("message", "공통 서류 조회 중 오류가 발생했습니다.");
        }
        return response;
    }

    /**
     * 카테고리별 공통 서류 목록 조회
     * GET /api/checklist/common-documents/{category}
     */
    @GetMapping("/common-documents/{category}")
    public Map<String, Object> getCommonDocumentsByCategory(@PathVariable String category) {
        Map<String, Object> response = new HashMap<>();
        try {
            List<CommonDocumentDto> documents = checklistService.getCommonDocumentsByCategory(category);
            response.put("success", true);
            response.put("data", documents);
        } catch (Exception e) {
            logger.error("카테고리별 공통 서류 조회 실패", e);
            response.put("success", false);
            response.put("message", "공통 서류 조회 중 오류가 발생했습니다.");
        }
        return response;
    }

    // ========== 서비스별 필요 서류 조회 ==========

    /**
     * 특정 복지 서비스의 필요 서류 목록 조회
     * GET /api/checklist/{serviceId}
     * serviceId는 내부 ID 또는 API servId 모두 가능
     */
    @GetMapping("/{serviceId}")
    public Map<String, Object> getRequiredDocuments(@PathVariable String serviceId) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 내부 ID로 변환 (API servId인 경우 매핑)
            String resolvedId = checklistService.resolveServiceId(serviceId);
            List<RequiredDocumentDto> documents = checklistService.getRequiredDocuments(resolvedId);
            response.put("success", true);
            response.put("data", documents);
            response.put("hasDocuments", !documents.isEmpty());
            response.put("resolvedServiceId", resolvedId);
        } catch (Exception e) {
            logger.error("필요 서류 조회 실패: serviceId={}", serviceId, e);
            response.put("success", false);
            response.put("message", "필요 서류 조회 중 오류가 발생했습니다.");
        }
        return response;
    }

    /**
     * 필요 서류가 등록된 서비스 목록 조회
     * GET /api/checklist/services/available
     */
    @GetMapping("/services/available")
    public Map<String, Object> getServicesWithDocuments() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<Map<String, Object>> services = checklistService.getServicesWithDocuments();
            response.put("success", true);
            response.put("data", services);
            response.put("count", services.size());
        } catch (Exception e) {
            logger.error("서비스 목록 조회 실패", e);
            response.put("success", false);
            response.put("message", "서비스 목록 조회 중 오류가 발생했습니다.");
        }
        return response;
    }

    /**
     * API 서비스에 대한 필요 서류 조회 (서비스명으로 매칭)
     * GET /api/checklist/search?apiServiceId=xxx&serviceName=xxx
     */
    @GetMapping("/search")
    public Map<String, Object> searchRequiredDocuments(
            @RequestParam(value = "apiServiceId", required = false) String apiServiceId,
            @RequestParam(value = "serviceName", required = false) String serviceName) {
        Map<String, Object> response = new HashMap<>();
        try {
            List<RequiredDocumentDto> documents = checklistService.getRequiredDocumentsForApiService(apiServiceId, serviceName);
            response.put("success", true);
            response.put("data", documents);
            response.put("hasDocuments", !documents.isEmpty());
            response.put("searchedApiId", apiServiceId);
            response.put("searchedName", serviceName);
        } catch (Exception e) {
            logger.error("필요 서류 검색 실패: apiServiceId={}, serviceName={}", apiServiceId, serviceName, e);
            response.put("success", false);
            response.put("message", "필요 서류 검색 중 오류가 발생했습니다.");
        }
        return response;
    }

    // ========== 사용자 체크리스트 ==========

    /**
     * 내 체크리스트 진행상황 조회
     * GET /api/checklist/{serviceId}/my
     */
    @GetMapping("/{serviceId}/my")
    public Map<String, Object> getMyChecklist(@PathVariable String serviceId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long memberId = getMemberId(session);
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            List<UserChecklistDto> checklist = checklistService.getUserChecklist(memberId, serviceId);
            Map<String, Object> progress = checklistService.getProgress(memberId, serviceId);

            response.put("success", true);
            response.put("data", checklist);
            response.put("progress", progress);
        } catch (Exception e) {
            logger.error("체크리스트 조회 실패: serviceId={}", serviceId, e);
            response.put("success", false);
            response.put("message", "체크리스트 조회 중 오류가 발생했습니다.");
        }
        return response;
    }

    /**
     * 서류 체크/언체크 토글
     * POST /api/checklist/check
     */
    @PostMapping("/check")
    public Map<String, Object> toggleCheck(
            @RequestParam("serviceId") String serviceId,
            @RequestParam("documentId") Long documentId,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long memberId = getMemberId(session);
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            boolean success = checklistService.toggleCheckStatus(memberId, serviceId, documentId);
            if (success) {
                Map<String, Object> progress = checklistService.getProgress(memberId, serviceId);
                response.put("success", true);
                response.put("progress", progress);
                response.put("message", "체크 상태가 변경되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "체크 상태 변경에 실패했습니다.");
            }
        } catch (Exception e) {
            logger.error("체크 상태 변경 실패", e);
            response.put("success", false);
            response.put("message", "체크 상태 변경 중 오류가 발생했습니다.");
        }
        return response;
    }

    /**
     * 서류 체크 상태 직접 설정
     * POST /api/checklist/check/set
     */
    @PostMapping("/check/set")
    public Map<String, Object> setCheckStatus(
            @RequestParam("serviceId") String serviceId,
            @RequestParam("documentId") Long documentId,
            @RequestParam("isChecked") boolean isChecked,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long memberId = getMemberId(session);
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            boolean success = checklistService.setCheckStatus(memberId, serviceId, documentId, isChecked);
            if (success) {
                Map<String, Object> progress = checklistService.getProgress(memberId, serviceId);
                response.put("success", true);
                response.put("progress", progress);
            } else {
                response.put("success", false);
                response.put("message", "체크 상태 설정에 실패했습니다.");
            }
        } catch (Exception e) {
            logger.error("체크 상태 설정 실패", e);
            response.put("success", false);
            response.put("message", "체크 상태 설정 중 오류가 발생했습니다.");
        }
        return response;
    }

    /**
     * 메모 업데이트
     * POST /api/checklist/memo
     */
    @PostMapping("/memo")
    public Map<String, Object> updateMemo(
            @RequestParam("serviceId") String serviceId,
            @RequestParam("documentId") Long documentId,
            @RequestParam(value = "memo", required = false) String memo,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long memberId = getMemberId(session);
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            boolean success = checklistService.updateMemo(memberId, serviceId, documentId, memo);
            response.put("success", success);
            response.put("message", success ? "메모가 저장되었습니다." : "메모 저장에 실패했습니다.");
        } catch (Exception e) {
            logger.error("메모 업데이트 실패", e);
            response.put("success", false);
            response.put("message", "메모 저장 중 오류가 발생했습니다.");
        }
        return response;
    }

    // ========== 진행률 조회 ==========

    /**
     * 진행률 조회
     * GET /api/checklist/{serviceId}/progress
     */
    @GetMapping("/{serviceId}/progress")
    public Map<String, Object> getProgress(@PathVariable String serviceId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long memberId = getMemberId(session);
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            Map<String, Object> progress = checklistService.getProgress(memberId, serviceId);
            response.put("success", true);
            response.put("data", progress);
        } catch (Exception e) {
            logger.error("진행률 조회 실패", e);
            response.put("success", false);
            response.put("message", "진행률 조회 중 오류가 발생했습니다.");
        }
        return response;
    }

    // ========== 내 모든 체크리스트 ==========

    /**
     * 내가 진행 중인 모든 체크리스트 조회
     * GET /api/checklist/my/all
     */
    @GetMapping("/my/all")
    public Map<String, Object> getAllMyChecklists(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long memberId = getMemberId(session);
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            List<Map<String, Object>> checklists = checklistService.getAllUserChecklists(memberId);
            response.put("success", true);
            response.put("data", checklists);
        } catch (Exception e) {
            logger.error("전체 체크리스트 조회 실패", e);
            response.put("success", false);
            response.put("message", "체크리스트 조회 중 오류가 발생했습니다.");
        }
        return response;
    }

    /**
     * 내 모든 체크리스트 요약 조회 (진행률만)
     * GET /api/checklist/my/summary
     */
    @GetMapping("/my/summary")
    public Map<String, Object> getAllMyChecklistsSummary(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long memberId = getMemberId(session);
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            List<Map<String, Object>> summaries = checklistService.getAllUserChecklistsSummary(memberId);
            response.put("success", true);
            response.put("data", summaries);
        } catch (Exception e) {
            logger.error("체크리스트 요약 조회 실패", e);
            response.put("success", false);
            response.put("message", "체크리스트 조회 중 오류가 발생했습니다.");
        }
        return response;
    }

    // ========== 체크리스트 초기화/삭제 ==========

    /**
     * 체크리스트 초기화 (리셋)
     * POST /api/checklist/{serviceId}/reset
     */
    @PostMapping("/{serviceId}/reset")
    public Map<String, Object> resetChecklist(@PathVariable String serviceId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long memberId = getMemberId(session);
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            int count = checklistService.initializeChecklist(memberId, serviceId);
            response.put("success", true);
            response.put("message", "체크리스트가 초기화되었습니다.");
            response.put("itemCount", count);
        } catch (Exception e) {
            logger.error("체크리스트 초기화 실패", e);
            response.put("success", false);
            response.put("message", "체크리스트 초기화 중 오류가 발생했습니다.");
        }
        return response;
    }

    /**
     * 체크리스트 삭제
     * DELETE /api/checklist/{serviceId}
     */
    @DeleteMapping("/{serviceId}")
    public Map<String, Object> deleteChecklist(@PathVariable String serviceId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long memberId = getMemberId(session);
            if (memberId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            boolean success = checklistService.deleteUserChecklist(memberId, serviceId);
            response.put("success", success);
            response.put("message", success ? "체크리스트가 삭제되었습니다." : "삭제할 체크리스트가 없습니다.");
        } catch (Exception e) {
            logger.error("체크리스트 삭제 실패", e);
            response.put("success", false);
            response.put("message", "체크리스트 삭제 중 오류가 발생했습니다.");
        }
        return response;
    }
}
