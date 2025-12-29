/**
 * 복지24 - 인증 관련 유틸리티
 * 로그인 상태 확인, 리다이렉션 등
 */

const AuthUtils = {
    /**
     * 현재 로그인 상태 확인
     * @returns {Promise} - {loggedIn: boolean, userId: string}
     */
    checkLoginStatus: function() {
        const contextPath = this.getContextPath();
        return fetch(contextPath + '/api/auth/check')
            .then(response => response.json())
            .catch(error => {
                console.error('Login status check failed:', error);
                return { loggedIn: false };
            });
    },

    /**
     * 로그인 상태에 따라 페이지 리다이렉션
     * 로그인 시 -> 마이페이지, 미로그인 시 -> 로그인 페이지
     */
    redirectBasedOnAuth: function() {
        const contextPath = this.getContextPath();
        this.checkLoginStatus()
            .then(data => {
                if (data.loggedIn) {
                    window.location.href = contextPath + '/project_mypage.jsp';
                } else {
                    window.location.href = contextPath + '/projectLogin.jsp';
                }
            })
            .catch(() => {
                window.location.href = contextPath + '/projectLogin.jsp';
            });
    },

    /**
     * 로그인 필수 체크 - 로그인되어 있으면 콜백 실행, 아니면 로그인 페이지로
     * @param {Function} successCallback - 로그인 시 실행할 콜백
     */
    requireLogin: function(successCallback) {
        const contextPath = this.getContextPath();
        this.checkLoginStatus()
            .then(data => {
                if (data.loggedIn) {
                    if (typeof successCallback === 'function') {
                        successCallback(data);
                    }
                } else {
                    alert('로그인이 필요합니다.');
                    window.location.href = contextPath + '/projectLogin.jsp';
                }
            })
            .catch(() => {
                alert('로그인 상태를 확인할 수 없습니다.');
                window.location.href = contextPath + '/projectLogin.jsp';
            });
    },

    /**
     * Context Path 가져오기
     * @returns {string} - Context Path
     */
    getContextPath: function() {
        // JSP에서 전역 변수로 설정된 contextPath 사용
        if (typeof contextPath !== 'undefined') {
            return contextPath;
        }
        // 없으면 현재 경로에서 추출
        const path = window.location.pathname;
        const context = path.substring(0, path.indexOf('/', 1));
        return context || '';
    },

    /**
     * 로그아웃 처리
     */
    logout: function() {
        const contextPath = this.getContextPath();
        fetch(contextPath + '/api/auth/logout', {
            method: 'POST'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('로그아웃되었습니다.');
                window.location.href = contextPath + '/project.jsp';
            }
        })
        .catch(error => {
            console.error('Logout failed:', error);
            alert('로그아웃 중 오류가 발생했습니다.');
        });
    }
};

// 전역 스코프에 노출
if (typeof window !== 'undefined') {
    window.AuthUtils = AuthUtils;
}
