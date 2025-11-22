package com.greenart.bdproject.util;

import java.util.HashMap;
import java.util.Map;

/**
 * API 응답 표준화 유틸리티 클래스
 * 컨트롤러에서 일관된 응답 형식을 생성하기 위한 헬퍼 메서드 제공
 *
 * @author Welfare24 Team
 */
public class ApiResponse {

    /**
     * 성공 응답 생성 (데이터 없음)
     * @return Map<String, Object> - {success: true}
     */
    public static Map<String, Object> success() {
        return success(null);
    }

    /**
     * 성공 응답 생성 (데이터 포함)
     * @param data - 응답 데이터
     * @return Map<String, Object> - {success: true, data: ...}
     */
    public static Map<String, Object> success(Object data) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        if (data != null) {
            response.put("data", data);
        }
        return response;
    }

    /**
     * 성공 응답 생성 (메시지 포함)
     * @param message - 성공 메시지
     * @return Map<String, Object> - {success: true, message: ...}
     */
    public static Map<String, Object> successWithMessage(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", message);
        return response;
    }

    /**
     * 성공 응답 생성 (데이터와 메시지 포함)
     * @param data - 응답 데이터
     * @param message - 성공 메시지
     * @return Map<String, Object> - {success: true, data: ..., message: ...}
     */
    public static Map<String, Object> success(Object data, String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", data);
        response.put("message", message);
        return response;
    }

    /**
     * 실패 응답 생성
     * @param message - 에러 메시지
     * @return Map<String, Object> - {success: false, message: ...}
     */
    public static Map<String, Object> error(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        return response;
    }

    /**
     * 실패 응답 생성 (Exception으로부터)
     * @param e - Exception 객체
     * @return Map<String, Object> - {success: false, message: ...}
     */
    public static Map<String, Object> error(Exception e) {
        return error(e.getMessage());
    }

    /**
     * 검증 실패 응답 생성
     * @param errors - 필드별 에러 맵
     * @return Map<String, Object> - {success: false, message: ..., errors: {...}}
     */
    public static Map<String, Object> validationError(Map<String, String> errors) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", "입력값 검증에 실패했습니다.");
        response.put("errors", errors);
        return response;
    }

    /**
     * 인증 실패 응답 생성
     * @param message - 인증 실패 메시지
     * @return Map<String, Object> - {success: false, message: ..., requiresAuth: true}
     */
    public static Map<String, Object> unauthorized(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        response.put("requiresAuth", true);
        return response;
    }

    /**
     * 권한 부족 응답 생성
     * @param message - 권한 부족 메시지
     * @return Map<String, Object> - {success: false, message: ..., forbidden: true}
     */
    public static Map<String, Object> forbidden(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        response.put("forbidden", true);
        return response;
    }

    /**
     * 리소스 없음 응답 생성
     * @param message - 리소스 없음 메시지
     * @return Map<String, Object> - {success: false, message: ..., notFound: true}
     */
    public static Map<String, Object> notFound(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        response.put("notFound", true);
        return response;
    }

    /**
     * 페이징된 데이터 응답 생성
     * @param data - 데이터 리스트
     * @param page - 현재 페이지
     * @param totalPages - 전체 페이지 수
     * @param totalElements - 전체 요소 수
     * @return Map<String, Object> - 페이징 정보 포함 응답
     */
    public static Map<String, Object> pagedSuccess(Object data, int page, int totalPages, long totalElements) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", data);

        Map<String, Object> pagination = new HashMap<>();
        pagination.put("currentPage", page);
        pagination.put("totalPages", totalPages);
        pagination.put("totalElements", totalElements);
        pagination.put("hasNext", page < totalPages);
        pagination.put("hasPrevious", page > 1);

        response.put("pagination", pagination);
        return response;
    }
}
