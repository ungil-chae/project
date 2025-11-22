/**
 * 복지24 - UI 관련 유틸리티
 * 로딩 오버레이, 토스트 메시지 등
 */

const UIUtils = {
    /**
     * 로딩 오버레이 표시
     * @param {string} message - 표시할 메시지 (기본값: '처리 중입니다...')
     */
    showLoading: function(message = '처리 중입니다...') {
        // 기존 로딩 오버레이 제거
        this.hideLoading();

        const loadingHtml = `
            <div id="loading-overlay" class="loading-overlay">
                <div class="spinner"></div>
                <h3>${message}</h3>
            </div>
        `;
        document.body.insertAdjacentHTML('beforeend', loadingHtml);
    },

    /**
     * 로딩 오버레이 숨기기
     */
    hideLoading: function() {
        const overlay = document.getElementById('loading-overlay');
        if (overlay) {
            overlay.remove();
        }
    },

    /**
     * 토스트 메시지 표시
     * @param {string} message - 메시지 내용
     * @param {string} type - 메시지 타입 ('success', 'error', 'warning', 'info')
     * @param {number} duration - 표시 시간 (밀리초, 기본값: 3000)
     */
    showToast: function(message, type = 'info', duration = 3000) {
        // 토스트 컨테이너 생성 (없으면)
        let container = document.getElementById('toast-container');
        if (!container) {
            container = document.createElement('div');
            container.id = 'toast-container';
            container.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 10000;
            `;
            document.body.appendChild(container);
        }

        // 아이콘 선택
        const icons = {
            success: '✓',
            error: '✕',
            warning: '⚠',
            info: 'ℹ'
        };

        // 색상 선택
        const colors = {
            success: '#10b981',
            error: '#ef4444',
            warning: '#f59e0b',
            info: '#3b82f6'
        };

        // 토스트 생성
        const toast = document.createElement('div');
        toast.style.cssText = `
            background: white;
            padding: 16px 20px;
            margin-bottom: 10px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 300px;
            max-width: 500px;
            animation: slideIn 0.3s ease-out;
            border-left: 4px solid ${colors[type]};
        `;

        toast.innerHTML = `
            <span style="font-size: 20px; color: ${colors[type]};">${icons[type]}</span>
            <span style="flex: 1; font-size: 14px; color: #333;">${message}</span>
        `;

        container.appendChild(toast);

        // 자동 제거
        setTimeout(() => {
            toast.style.animation = 'slideOut 0.3s ease-in';
            setTimeout(() => {
                toast.remove();
                // 컨테이너가 비어있으면 제거
                if (container.children.length === 0) {
                    container.remove();
                }
            }, 300);
        }, duration);
    },

    /**
     * 확인 다이얼로그 표시
     * @param {string} message - 확인 메시지
     * @param {Function} onConfirm - 확인 버튼 클릭 시 콜백
     * @param {Function} onCancel - 취소 버튼 클릭 시 콜백 (선택사항)
     */
    showConfirm: function(message, onConfirm, onCancel) {
        if (confirm(message)) {
            if (typeof onConfirm === 'function') {
                onConfirm();
            }
        } else {
            if (typeof onCancel === 'function') {
                onCancel();
            }
        }
    },

    /**
     * 스크롤을 특정 위치로 부드럽게 이동
     * @param {string|Element} target - CSS 선택자 또는 DOM 요소
     * @param {number} offset - 오프셋 (기본값: 0)
     */
    scrollTo: function(target, offset = 0) {
        let element;
        if (typeof target === 'string') {
            element = document.querySelector(target);
        } else {
            element = target;
        }

        if (element) {
            const top = element.getBoundingClientRect().top + window.pageYOffset - offset;
            window.scrollTo({
                top: top,
                behavior: 'smooth'
            });
        }
    },

    /**
     * 페이지 최상단으로 스크롤
     */
    scrollToTop: function() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    }
};

// CSS 애니메이션 추가
if (!document.getElementById('ui-utils-styles')) {
    const style = document.createElement('style');
    style.id = 'ui-utils-styles';
    style.textContent = `
        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(100%);
                opacity: 0;
            }
        }
    `;
    document.head.appendChild(style);
}

// 전역 스코프에 노출
if (typeof window !== 'undefined') {
    window.UIUtils = UIUtils;
}
