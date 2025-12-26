/**
 * 세션 만료 처리 공통 JavaScript
 * 복지24 - Session Handler
 */

(function() {
    'use strict';

    // 세션 만료 메시지 감지 키워드
    var SESSION_EXPIRED_MESSAGES = [
        '로그인이 필요합니다',
        '세션이 만료되었습니다',
        '로그인 후 이용해 주세요'
    ];

    /**
     * 세션 만료 확인
     * @param {Object} response - API 응답 객체
     * @returns {boolean} 세션 만료 여부
     */
    function isSessionExpired(response) {
        if (!response) return false;

        // success가 false이고 메시지가 세션 관련인 경우
        if (response.success === false && response.message) {
            for (var i = 0; i < SESSION_EXPIRED_MESSAGES.length; i++) {
                if (response.message.indexOf(SESSION_EXPIRED_MESSAGES[i]) !== -1) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * 세션 만료 알림 표시 및 로그인 페이지로 이동
     */
    function handleSessionExpired() {
        alert('로그인 세션이 만료되었습니다.\n다시 로그인해 주세요.');

        // 현재 페이지 URL을 저장하여 로그인 후 돌아올 수 있도록
        var currentUrl = window.location.href;
        var contextPath = getContextPath();

        // 로그인 페이지로 이동
        window.location.href = contextPath + '/project.jsp#login';
    }

    /**
     * Context Path 가져오기
     */
    function getContextPath() {
        var pathName = window.location.pathname;
        var contextPath = pathName.substring(0, pathName.indexOf('/', 1));
        return contextPath || '';
    }

    /**
     * API 응답 처리 래퍼
     * @param {Object} response - API 응답
     * @param {Function} successCallback - 성공 시 콜백
     * @param {Function} errorCallback - 에러 시 콜백 (선택)
     */
    function handleApiResponse(response, successCallback, errorCallback) {
        // 세션 만료 체크
        if (isSessionExpired(response)) {
            handleSessionExpired();
            return;
        }

        // 성공 처리
        if (response.success) {
            if (typeof successCallback === 'function') {
                successCallback(response);
            }
        } else {
            // 에러 처리
            if (typeof errorCallback === 'function') {
                errorCallback(response);
            } else {
                // 기본 에러 처리
                alert(response.message || '오류가 발생했습니다.');
            }
        }
    }

    /**
     * jQuery AJAX 글로벌 에러 핸들러 설정
     */
    function setupGlobalAjaxHandler() {
        if (typeof $ !== 'undefined' && $.ajaxSetup) {
            $(document).ajaxComplete(function(event, xhr, settings) {
                try {
                    var response = xhr.responseJSON;
                    if (response && isSessionExpired(response)) {
                        handleSessionExpired();
                    }
                } catch (e) {
                    // JSON 파싱 실패 시 무시
                }
            });
        }
    }

    // 페이지 로드 시 글로벌 핸들러 설정
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', setupGlobalAjaxHandler);
    } else {
        setupGlobalAjaxHandler();
    }

    // 전역 객체로 내보내기
    window.SessionHandler = {
        isSessionExpired: isSessionExpired,
        handleSessionExpired: handleSessionExpired,
        handleApiResponse: handleApiResponse
    };

})();
