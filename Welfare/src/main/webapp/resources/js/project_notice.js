// project_notice.js - 공지사항 페이지 JavaScript

// 전역 변수
let currentPage = 1;
let itemsPerPage = 10;
let allNoticesData = [];

// 페이지 로드 시 공지사항 목록 로드
document.addEventListener('DOMContentLoaded', function() {
    loadNotices();
});

// 공지사항 목록 로드
function loadNotices() {
    // 로그인 상태 확인 및 관리자 권한 체크
    checkAdminAuth();

    // 공지사항 목록 로드
    fetch('/bdproject/api/notices')
        .then(response => response.json())
        .then(data => {
            const loadingIndicator = document.getElementById('loadingIndicator');
            const noticeList = document.getElementById('noticeList');

            loadingIndicator.style.display = 'none';
            noticeList.style.display = 'block';

            if (data.success && data.data && data.data.length > 0) {
                allNoticesData = data.data;
                displayNoticesWithPagination(currentPage);
            } else {
                // 데이터가 없으면 빈 상태 또는 샘플 데이터 표시
                showNoNotices();
            }
        })
        .catch(error => {
            console.error('공지사항 로드 실패:', error);
            document.getElementById('loadingIndicator').style.display = 'none';
            document.getElementById('noticeList').style.display = 'block';
            // 에러 발생 시 샘플 데이터 사용 (6개 샘플)
            allNoticesData = getSampleNoticesData();
            displayNoticesWithPagination(1);
        });
}

// 관리자 권한 확인
function checkAdminAuth() {
    fetch('/bdproject/api/auth/check')
        .then(response => response.json())
        .then(data => {
            if (data.loggedIn && data.role === 'ADMIN') {
                // 관리자 버튼 표시
                const adminControls = document.querySelector('.admin-controls');
                if (adminControls) {
                    adminControls.classList.remove('hidden');
                }
            }
        })
        .catch(error => console.error('권한 확인 실패:', error));
}

// 페이징과 함께 공지사항 표시
function displayNoticesWithPagination(page) {
    console.log('displayNoticesWithPagination called with page:', page);
    console.log('allNoticesData length:', allNoticesData.length);

    if (!allNoticesData || allNoticesData.length === 0) {
        console.error('allNoticesData is empty or undefined');
        displayNotices([]);
        document.getElementById('paginationContainer').style.display = 'none';
        return;
    }

    const totalNotices = allNoticesData.length;
    const totalPages = Math.ceil(totalNotices / itemsPerPage);

    // 현재 페이지의 공지사항만 표시
    const startIndex = (page - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const pageNotices = allNoticesData.slice(startIndex, endIndex);

    console.log('Displaying notices from index', startIndex, 'to', endIndex);
    console.log('pageNotices length:', pageNotices.length);

    displayNotices(pageNotices);

    // 10개 초과 시에만 페이징 표시
    if (totalNotices > itemsPerPage) {
        renderPagination(page, totalPages);
        document.getElementById('paginationContainer').style.display = 'flex';
    } else {
        document.getElementById('paginationContainer').style.display = 'none';
    }
}

// 공지사항 표시
function displayNotices(notices) {
    const noticeList = document.getElementById('noticeList');

    if (!noticeList) {
        console.error('noticeList element not found');
        return;
    }

    if (!notices || notices.length === 0) {
        noticeList.innerHTML = '<div style="text-align: center; padding: 50px; color: #6c757d;">등록된 공지사항이 없습니다.</div>';
        return;
    }

    noticeList.innerHTML = notices.map(notice => {
        const isPinned = notice.isPinned || false;
        const itemClass = isPinned ? 'notice-item pinned' : 'notice-item';
        const pinBadge = isPinned ? '<span class="pin-badge">📌 공지</span>' : '';
        const createdDate = new Date(notice.createdAt).toLocaleDateString('ko-KR', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit'
        }).replace(/\. /g, '.').replace(/\.$/, '');

        return '<div class="' + itemClass + '" data-id="' + notice.noticeId + '" data-views="' + (notice.views || 0) + '" onclick="toggleContent(this)">' +
                '<div class="notice-header">' +
                    '<div class="notice-header-top">' +
                        pinBadge +
                        '<span class="notice-title">' + escapeHtml(notice.title) + '</span>' +
                        '<i class="fas fa-chevron-down notice-arrow"></i>' +
                    '</div>' +
                    '<div class="notice-header-bottom">' +
                        '<span class="notice-date">' + createdDate + '</span>' +
                        '<span class="notice-views">조회 <span class="views-count">' + (notice.views || 0) + '</span></span>' +
                    '</div>' +
                '</div>' +
                '<div class="notice-content">' +
                    escapeHtml(notice.content || '').replace(/\n/g, '<br>') +
                '</div>' +
            '</div>';
    }).join('');
}

// 페이징 렌더링
function renderPagination(currentPage, totalPages) {
    const paginationContainer = document.getElementById('paginationContainer');
    if (!paginationContainer) return;

    let paginationHTML = '';

    // 이전 버튼
    if (currentPage > 1) {
        paginationHTML += '<button class="page-btn" onclick="goToPage(' + (currentPage - 1) + ')">&laquo;</button>';
    }

    // 페이지 번호 (최대 5개만 표시)
    const maxButtons = 5;
    let startPage = Math.max(1, currentPage - Math.floor(maxButtons / 2));
    let endPage = Math.min(totalPages, startPage + maxButtons - 1);

    if (endPage - startPage < maxButtons - 1) {
        startPage = Math.max(1, endPage - maxButtons + 1);
    }

    for (let i = startPage; i <= endPage; i++) {
        const activeClass = i === currentPage ? 'active' : '';
        paginationHTML += '<button class="page-btn ' + activeClass + '" onclick="goToPage(' + i + ')">' + i + '</button>';
    }

    // 다음 버튼
    if (currentPage < totalPages) {
        paginationHTML += '<button class="page-btn" onclick="goToPage(' + (currentPage + 1) + ')">&raquo;</button>';
    }

    paginationContainer.innerHTML = paginationHTML;
}

// 페이지 이동
function goToPage(page) {
    console.log('goToPage called with page:', page);
    console.log('allNoticesData length:', allNoticesData ? allNoticesData.length : 'undefined');

    if (!allNoticesData || allNoticesData.length === 0) {
        console.error('allNoticesData is empty or undefined in goToPage');
        return;
    }

    currentPage = page;
    displayNoticesWithPagination(page);
    // 페이지 상단으로 스크롤
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// 공지사항이 없을 때 표시
function showNoNotices() {
    const noticeList = document.getElementById('noticeList');
    if (noticeList) {
        noticeList.innerHTML = '<div style="text-align: center; padding: 50px; color: #6c757d;">등록된 공지사항이 없습니다.</div>';
    }
}

// HTML 이스케이프 함수 (XSS 방지)
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// 샘플 공지사항 데이터 반환
function getSampleNoticesData() {
    return [
        {
            noticeId: 1,
            title: '2025년 복지 혜택 확대 안내',
            content: '2025년부터 복지 혜택이 대폭 확대됩니다. 기존 소득 기준이 완화되어 더 많은 분들이 혜택을 받으실 수 있게 되었습니다. 자세한 사항은 복지 혜택 찾기 메뉴에서 진단을 통해 확인하실 수 있습니다.',
            createdAt: '2025-10-08T00:00:00',
            isImportant: true,
            isPinned: false
        },
        {
            noticeId: 2,
            title: '복지 지도 서비스 오픈',
            content: '주변 복지시설을 한눈에 확인할 수 있는 복지 지도 서비스가 오픈되었습니다. 복지관, 주민센터, 상담센터 등 다양한 복지시설의 위치와 정보를 지도에서 확인하세요.',
            createdAt: '2025-10-05T00:00:00',
            isImportant: false,
            isPinned: false
        },
        {
            noticeId: 3,
            title: '복지24 모바일 앱 출시 예정',
            content: '언제 어디서나 복지 혜택을 확인하고 신청할 수 있는 복지24 모바일 앱이 11월 중 출시 예정입니다. 많은 기대 부탁드립니다.',
            createdAt: '2025-10-01T00:00:00',
            isImportant: false,
            isPinned: false
        },
        {
            noticeId: 4,
            title: '추석 연휴 고객센터 운영 안내',
            content: '추석 연휴 기간(9/28~10/3) 동안 고객센터 운영이 일부 제한됩니다. 긴급 문의사항은 온라인 채팅 상담을 이용해 주시기 바랍니다.',
            createdAt: '2025-09-25T00:00:00',
            isImportant: false,
            isPinned: false
        },
        {
            noticeId: 5,
            title: '개인정보 처리방침 개정 안내',
            content: '개인정보 보호를 강화하기 위해 개인정보 처리방침이 개정되었습니다. 개정된 내용은 9월 20일부터 적용됩니다. 자세한 내용은 하단 개인정보 처리방침 페이지에서 확인하세요.',
            createdAt: '2025-09-15T00:00:00',
            isImportant: false,
            isPinned: false
        }
    ];
}

// 샘플 공지사항 사용 (API 연동 전 또는 에러 시) - 더 이상 사용하지 않음
function useSampleNotices() {
    const noticeList = document.getElementById('noticeList');
    noticeList.innerHTML = `
    <div class="notice-item important" data-id="1" onclick="toggleContent(this)">
        <div class="notice-header">
            <div class="notice-header-top">
                <span class="notice-title">2025년 복지 혜택 확대 안내</span>
                <i class="fas fa-chevron-down notice-arrow"></i>
            </div>
            <div class="notice-header-bottom">
                <span class="notice-date">2025.10.08</span>
                <span class="notice-views">조회 <span class="views-count">523</span></span>
            </div>
        </div>
        <div class="notice-content">
            2025년부터 복지 혜택이 대폭 확대됩니다. 기존 소득 기준이 완화되어 더 많은 분들이 혜택을 받으실 수 있게 되었습니다.
            자세한 사항은 복지 혜택 찾기 메뉴에서 진단을 통해 확인하실 수 있습니다.
        </div>
    </div>

    <div class="notice-item" data-id="2" onclick="toggleContent(this)">
        <div class="notice-header">
            <div class="notice-header-top">
                <span class="notice-title">복지 지도 서비스 오픈</span>
                <i class="fas fa-chevron-down notice-arrow"></i>
            </div>
            <div class="notice-header-bottom">
                <span class="notice-date">2025.10.05</span>
                <span class="notice-views">조회 <span class="views-count">312</span></span>
            </div>
        </div>
        <div class="notice-content">
            주변 복지시설을 한눈에 확인할 수 있는 복지 지도 서비스가 오픈되었습니다.
            복지관, 주민센터, 상담센터 등 다양한 복지시설의 위치와 정보를 지도에서 확인하세요.
        </div>
    </div>

    <div class="notice-item" data-id="3" onclick="toggleContent(this)">
        <div class="notice-header">
            <div class="notice-header-top">
                <span class="notice-title">복지24 모바일 앱 출시 예정</span>
                <i class="fas fa-chevron-down notice-arrow"></i>
            </div>
            <div class="notice-header-bottom">
                <span class="notice-date">2025.10.01</span>
                <span class="notice-views">조회 <span class="views-count">789</span></span>
            </div>
        </div>
        <div class="notice-content">
            언제 어디서나 복지 혜택을 확인하고 신청할 수 있는 복지24 모바일 앱이 11월 중 출시 예정입니다.
            많은 기대 부탁드립니다.
        </div>
    </div>

    <div class="notice-item" data-id="4" onclick="toggleContent(this)">
        <div class="notice-header">
            <div class="notice-header-top">
                <span class="notice-title">추석 연휴 고객센터 운영 안내</span>
                <i class="fas fa-chevron-down notice-arrow"></i>
            </div>
            <div class="notice-header-bottom">
                <span class="notice-date">2025.09.25</span>
                <span class="notice-views">조회 <span class="views-count">456</span></span>
            </div>
        </div>
        <div class="notice-content">
            추석 연휴 기간(9/28~10/3) 동안 고객센터 운영이 일부 제한됩니다.
            긴급 문의사항은 온라인 채팅 상담을 이용해 주시기 바랍니다.
        </div>
    </div>

    <div class="notice-item" data-id="5" onclick="toggleContent(this)">
        <div class="notice-header">
            <div class="notice-header-top">
                <span class="notice-title">개인정보 처리방침 개정 안내</span>
                <i class="fas fa-chevron-down notice-arrow"></i>
            </div>
            <div class="notice-header-bottom">
                <span class="notice-date">2025.09.15</span>
                <span class="notice-views">조회 <span class="views-count">234</span></span>
            </div>
        </div>
        <div class="notice-content">
            개인정보 보호를 강화하기 위해 개인정보 처리방침이 개정되었습니다.
            개정된 내용은 9월 20일부터 적용됩니다. 자세한 내용은 하단 개인정보 처리방침 페이지에서 확인하세요.
        </div>
    </div>

    <div class="notice-item" data-id="6" onclick="toggleContent(this)">
        <div class="notice-header">
            <div class="notice-header-top">
                <span class="notice-title">복지24 서비스 점검 안내</span>
                <i class="fas fa-chevron-down notice-arrow"></i>
            </div>
            <div class="notice-header-bottom">
                <span class="notice-date">2025.09.10</span>
                <span class="notice-views">조회 <span class="views-count">167</span></span>
            </div>
        </div>
        <div class="notice-content">
            서비스 안정화를 위한 시스템 점검이 9월 12일 새벽 2시~5시에 진행됩니다.
            점검 시간 동안 일시적으로 서비스 이용이 제한될 수 있습니다.
        </div>
    </div>
    `;
}

// 공지사항 내용 토글
function toggleContent(element) {
    const content = element.querySelector('.notice-content');
    const arrow = element.querySelector('.notice-arrow');
    const wasActive = content.classList.contains('active');

    content.classList.toggle('active');
    arrow.classList.toggle('active');

    // 처음 펼칠 때만 조회수 증가 (닫을 때는 증가 안함)
    if (!wasActive && !element.dataset.viewed) {
        const noticeId = element.dataset.id;
        if (noticeId) {
            // 조회수 증가 API 호출
            fetch('/bdproject/api/notices/' + noticeId)
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.data) {
                        // 화면의 조회수 업데이트
                        const viewsCountElement = element.querySelector('.views-count');
                        if (viewsCountElement) {
                            viewsCountElement.textContent = data.data.views || 0;
                        }
                        // 중복 조회 방지
                        element.dataset.viewed = 'true';
                    }
                })
                .catch(error => console.error('조회수 증가 오류:', error));
        }
    }
}

// 공지사항 상세 페이지로 이동 (선택적 기능)
function viewNotice(noticeId) {
    // 공지사항 상세 페이지로 이동하려면 주석 해제
    // window.location.href = '/bdproject/noticeDetail.jsp?id=' + noticeId;
}
