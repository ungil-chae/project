/**
 * 복지24 체크리스트 기능
 * 복지 서비스 신청에 필요한 서류 체크리스트 관리
 */

(function() {
    'use strict';

    // 현재 선택된 서비스 정보
    let currentServiceId = null;
    let currentServiceName = null;

    // DOM 요소
    const elements = {
        serviceInfo: document.getElementById('serviceInfo'),
        serviceName: document.getElementById('serviceName'),
        serviceOrg: document.getElementById('serviceOrg'),
        progressText: document.getElementById('progressText'),
        progressFill: document.getElementById('progressFill'),
        progressPercent: document.getElementById('progressPercent'),
        checklistContainer: document.getElementById('checklistContainer'),
        loadingState: document.getElementById('loadingState'),
        emptyState: document.getElementById('emptyState'),
        noDocumentsState: document.getElementById('noDocumentsState'),
        checklistItems: document.getElementById('checklistItems'),
        myChecklistsContainer: document.getElementById('myChecklistsContainer'),
        commonDocsContainer: document.getElementById('commonDocsContainer')
    };

    /**
     * 초기화
     */
    function init() {
        // URL에서 serviceId 파라미터 확인
        const urlParams = new URLSearchParams(window.location.search);
        const serviceId = urlParams.get('serviceId');
        const serviceName = urlParams.get('serviceName');

        if (serviceId) {
            currentServiceId = serviceId;
            currentServiceName = serviceName || '복지 서비스';
            loadChecklist(serviceId, serviceName);
        } else {
            showEmptyState();
        }

        // 내 체크리스트 목록 로드
        loadMyChecklists();

        // 공통 서류 로드
        loadCommonDocuments();
    }

    /**
     * 체크리스트 로드
     */
    function loadChecklist(serviceId, serviceName) {
        showLoading();

        fetch(`${contextPath}/api/checklist/${serviceId}/my`, {
            method: 'GET',
            credentials: 'include'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                if (data.data && data.data.length > 0) {
                    renderChecklist(data.data, serviceName);
                    updateProgress(data.progress);
                    showServiceInfo(serviceName);
                } else {
                    // 필요 서류가 없는 경우
                    checkIfDocumentsExist(serviceId, serviceName);
                }
            } else {
                if (data.message && data.message.includes('로그인')) {
                    showToast('로그인이 필요합니다.', 'error');
                    showEmptyState();
                } else {
                    showNoDocuments();
                }
            }
        })
        .catch(error => {
            console.error('체크리스트 로드 실패:', error);
            showToast('체크리스트를 불러오는데 실패했습니다.', 'error');
            showEmptyState();
        });
    }

    /**
     * 서류 데이터 존재 여부 확인
     */
    function checkIfDocumentsExist(serviceId, serviceName) {
        fetch(`${contextPath}/api/checklist/${serviceId}`, {
            method: 'GET'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success && data.data && data.data.length > 0) {
                // 서류는 있지만 사용자 체크리스트가 초기화되지 않음
                // 다시 로드 시도
                loadChecklist(serviceId, serviceName);
            } else {
                showNoDocuments();
                showServiceInfo(serviceName);
            }
        })
        .catch(error => {
            showNoDocuments();
        });
    }

    /**
     * 체크리스트 렌더링
     */
    function renderChecklist(items, serviceName) {
        elements.checklistItems.innerHTML = '';

        items.forEach(item => {
            const itemElement = createChecklistItem(item);
            elements.checklistItems.appendChild(itemElement);
        });

        hideLoading();
        elements.emptyState.style.display = 'none';
        elements.noDocumentsState.style.display = 'none';
        elements.checklistItems.style.display = 'flex';
    }

    /**
     * 체크리스트 아이템 생성
     */
    function createChecklistItem(item) {
        const div = document.createElement('div');
        div.className = `checklist-item${item.isChecked ? ' checked' : ''}`;
        div.dataset.documentId = item.documentId;

        div.innerHTML = `
            <div class="checkbox-wrapper" onclick="toggleCheck(${item.documentId}, event)">
                <div class="custom-checkbox">
                    <i class="fas fa-check"></i>
                </div>
            </div>
            <div class="doc-info">
                <div class="doc-header">
                    <span class="doc-name">${escapeHtml(item.documentName)}</span>
                    <span class="doc-badge ${item.isRequired ? 'required' : 'optional'}">
                        ${item.isRequired ? '필수' : '선택'}
                    </span>
                </div>
                ${item.documentDescription ? `<p class="doc-description">${escapeHtml(item.documentDescription)}</p>` : ''}
                ${item.howToGet ? `
                    <div class="doc-how-to-get">
                        <i class="fas fa-info-circle"></i>
                        <span>${escapeHtml(item.howToGet)}</span>
                    </div>
                ` : ''}
                <div class="memo-section">
                    <textarea class="memo-input"
                              placeholder="메모를 입력하세요..."
                              data-document-id="${item.documentId}"
                              onblur="saveMemo(${item.documentId}, this.value)">${item.memo || ''}</textarea>
                </div>
            </div>
        `;

        // 체크박스 클릭 이벤트 (메모 영역 제외)
        div.addEventListener('click', function(e) {
            if (!e.target.closest('.memo-section') && !e.target.closest('.checkbox-wrapper')) {
                toggleCheck(item.documentId, e);
            }
        });

        return div;
    }

    /**
     * 체크 상태 토글
     */
    window.toggleCheck = function(documentId, event) {
        if (event) event.stopPropagation();

        const formData = new FormData();
        formData.append('serviceId', currentServiceId);
        formData.append('documentId', documentId);

        fetch(`${contextPath}/api/checklist/check`, {
            method: 'POST',
            body: formData,
            credentials: 'include'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // UI 업데이트
                const item = document.querySelector(`.checklist-item[data-document-id="${documentId}"]`);
                if (item) {
                    item.classList.toggle('checked');
                }
                updateProgress(data.progress);

                // 완료 시 축하 메시지
                if (data.progress.isComplete) {
                    showToast('모든 서류 준비가 완료되었습니다! 🎉', 'success');
                }
            } else {
                showToast(data.message || '상태 변경에 실패했습니다.', 'error');
            }
        })
        .catch(error => {
            console.error('체크 상태 변경 실패:', error);
            showToast('상태 변경에 실패했습니다.', 'error');
        });
    };

    /**
     * 메모 저장
     */
    window.saveMemo = function(documentId, memo) {
        const formData = new FormData();
        formData.append('serviceId', currentServiceId);
        formData.append('documentId', documentId);
        formData.append('memo', memo);

        fetch(`${contextPath}/api/checklist/memo`, {
            method: 'POST',
            body: formData,
            credentials: 'include'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // 조용히 저장
            }
        })
        .catch(error => {
            console.error('메모 저장 실패:', error);
        });
    };

    /**
     * 진행률 업데이트
     */
    function updateProgress(progress) {
        if (!progress) return;

        elements.progressText.textContent = `${progress.checked} / ${progress.total}`;
        elements.progressFill.style.width = `${progress.percentage}%`;
        elements.progressPercent.textContent = `${progress.percentage}%`;
    }

    /**
     * 서비스 정보 표시
     */
    function showServiceInfo(serviceName) {
        elements.serviceName.textContent = serviceName || '복지 서비스';
        elements.serviceOrg.textContent = currentServiceId;
        elements.serviceInfo.style.display = 'block';
    }

    /**
     * 내 체크리스트 목록 로드
     */
    function loadMyChecklists() {
        fetch(`${contextPath}/api/checklist/my/summary`, {
            method: 'GET',
            credentials: 'include'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success && data.data && data.data.length > 0) {
                renderMyChecklists(data.data);
            } else {
                elements.myChecklistsContainer.innerHTML = `
                    <div class="empty-state" style="padding: 30px;">
                        <p>아직 진행 중인 체크리스트가 없습니다.</p>
                    </div>
                `;
            }
        })
        .catch(error => {
            console.error('내 체크리스트 로드 실패:', error);
            elements.myChecklistsContainer.innerHTML = `
                <div class="empty-state" style="padding: 30px;">
                    <p>로그인 후 이용 가능합니다.</p>
                </div>
            `;
        });
    }

    /**
     * 내 체크리스트 목록 렌더링
     */
    function renderMyChecklists(checklists) {
        elements.myChecklistsContainer.innerHTML = '';

        checklists.forEach(item => {
            const card = document.createElement('div');
            const isComplete = item.progress.isComplete;
            card.className = `my-checklist-card${isComplete ? ' complete' : ''}`;

            card.innerHTML = `
                <div class="card-header">
                    <span class="card-title">${escapeHtml(item.serviceId)}</span>
                    <span class="card-badge ${isComplete ? 'complete' : 'in-progress'}">
                        ${isComplete ? '완료' : '진행 중'}
                    </span>
                </div>
                <div class="mini-progress">
                    <div class="mini-progress-fill" style="width: ${item.progress.percentage}%"></div>
                </div>
                <div class="progress-info">
                    ${item.progress.checked} / ${item.progress.total} 완료 (${item.progress.percentage}%)
                </div>
            `;

            card.addEventListener('click', () => {
                window.location.href = `${contextPath}/checklist?serviceId=${encodeURIComponent(item.serviceId)}`;
            });

            elements.myChecklistsContainer.appendChild(card);
        });
    }

    /**
     * 공통 서류 로드
     */
    function loadCommonDocuments() {
        fetch(`${contextPath}/api/checklist/common-documents`, {
            method: 'GET'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success && data.data) {
                renderCommonDocuments(data.data);
            }
        })
        .catch(error => {
            console.error('공통 서류 로드 실패:', error);
        });
    }

    /**
     * 공통 서류 렌더링
     */
    function renderCommonDocuments(documents) {
        elements.commonDocsContainer.innerHTML = '';

        // 카테고리별로 그룹화
        const grouped = {};
        documents.forEach(doc => {
            if (!grouped[doc.documentCategory]) {
                grouped[doc.documentCategory] = [];
            }
            grouped[doc.documentCategory].push(doc);
        });

        // 주요 카테고리만 표시 (최대 8개)
        let count = 0;
        for (const category in grouped) {
            if (count >= 8) break;

            const docs = grouped[category];
            docs.slice(0, 2).forEach(doc => {
                if (count >= 8) return;

                const card = document.createElement('div');
                card.className = 'common-doc-card';

                card.innerHTML = `
                    <div class="doc-category">${escapeHtml(doc.documentCategory)}</div>
                    <div class="doc-title">${escapeHtml(doc.documentName)}</div>
                    ${doc.description ? `<div class="doc-desc">${escapeHtml(doc.description)}</div>` : ''}
                    ${doc.howToGet ? `
                        <div class="doc-how">
                            <i class="fas fa-external-link-alt"></i>
                            <span>${escapeHtml(doc.howToGet)}</span>
                        </div>
                    ` : ''}
                `;

                elements.commonDocsContainer.appendChild(card);
                count++;
            });
        }
    }

    /**
     * 상태 표시 함수들
     */
    function showLoading() {
        elements.loadingState.style.display = 'block';
        elements.emptyState.style.display = 'none';
        elements.noDocumentsState.style.display = 'none';
        elements.checklistItems.style.display = 'none';
    }

    function hideLoading() {
        elements.loadingState.style.display = 'none';
    }

    function showEmptyState() {
        hideLoading();
        elements.emptyState.style.display = 'block';
        elements.noDocumentsState.style.display = 'none';
        elements.checklistItems.style.display = 'none';
        elements.serviceInfo.style.display = 'none';
    }

    function showNoDocuments() {
        hideLoading();
        elements.emptyState.style.display = 'none';
        elements.noDocumentsState.style.display = 'block';
        elements.checklistItems.style.display = 'none';
    }

    /**
     * 토스트 메시지 표시
     */
    function showToast(message, type = 'info') {
        // 기존 토스트 제거
        const existingToast = document.querySelector('.toast');
        if (existingToast) {
            existingToast.remove();
        }

        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        toast.textContent = message;
        document.body.appendChild(toast);

        // 애니메이션
        setTimeout(() => toast.classList.add('show'), 10);
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }

    /**
     * HTML 이스케이프
     */
    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    // 페이지 로드 시 초기화
    document.addEventListener('DOMContentLoaded', init);
})();
