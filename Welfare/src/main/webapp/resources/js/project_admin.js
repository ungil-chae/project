// project_admin.js - 관리자 페이지 JavaScript

// Daum Postcode API 로딩 확인
window.addEventListener('load', function() {
    if (typeof daum !== 'undefined' && typeof daum.Postcode !== 'undefined') {
        console.log('✓ Daum Postcode API 로드 성공');
    } else {
        console.error('✗ Daum Postcode API 로드 실패');
    }
});

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    loadDashboardStats();
    loadMembers();
});

// 섹션 전환
function showSection(sectionId) {
    // 모든 섹션 숨기기
    document.querySelectorAll('.content-section').forEach(section => {
        section.classList.remove('active');
    });

    // 모든 메뉴 아이템 비활성화
    document.querySelectorAll('.menu-item').forEach(item => {
        item.classList.remove('active');
    });

    // 선택한 섹션 표시
    document.getElementById(sectionId).classList.add('active');

    // 선택한 메뉴 아이템 활성화
    event.currentTarget.classList.add('active');

    // 섹션별 데이터 로드
    switch(sectionId) {
        case 'dashboard':
            loadDashboardStats();
            break;
        case 'members':
            loadMembers();
            break;
        case 'member-history':
            loadMemberHistory();
            break;
        case 'notices':
            loadNotices();
            break;
        case 'faqs':
            loadFaqs();
            break;
        case 'user-questions':
            loadUserQuestions();
            break;
        case 'donations':
            loadDonations();
            break;
        case 'refund-requests':
            loadRefundRequests();
            break;
        case 'volunteers':
            loadVolunteers();
            break;
    }
}

// 차트 인스턴스 저장
let chartInstances = {};

// 대시보드 통계 로드
function loadDashboardStats() {
    fetch('/bdproject/api/admin/dashboard/stats')
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                const data = result.data;

                // 상단 5개 카드 업데이트
                document.getElementById('todayDonations').textContent = formatNumber(data.todayDonations || 0) + '건';
                document.getElementById('activeVolunteers').textContent = formatNumber(data.activeVolunteers || 0) + '건';
                document.getElementById('volunteerCompletionRate').textContent = (data.volunteerCompletionRate || 0).toFixed(2) + '%';
                document.getElementById('totalDonations').textContent = formatMoney(data.totalDonations || 0) + '원';
                document.getElementById('totalMembers').textContent = formatNumber(data.totalMembers || 0) + '명';
            }
        })
        .catch(error => {
            console.error('통계 로드 오류:', error);
        });

    // 차트 데이터 로드
    loadChartData();
}

// 차트 데이터 로드 및 초기화
function loadChartData() {
    console.log('차트 데이터 로드 시작...');
    fetch('/bdproject/api/admin/dashboard/charts')
        .then(response => {
            console.log('API 응답 상태:', response.status);
            return response.json();
        })
        .then(result => {
            console.log('차트 API 응답:', result);
            if (result.success) {
                const data = result.data;
                console.log('차트 데이터:', data);
                initializeCharts(data);
            } else {
                console.warn('차트 데이터 실패:', result.message);
                initializeChartsWithDefaultData();
            }
        })
        .catch(error => {
            console.error('차트 데이터 로드 오류:', error);
            initializeChartsWithDefaultData();
        });
}

// 차트 초기화
function initializeCharts(data) {
    // 기존 차트 파괴
    Object.values(chartInstances).forEach(chart => chart.destroy());
    chartInstances = {};

    // 1. 최근 6개월 기부금 현황 (선형 차트)
    const donationCtx = document.getElementById('donationTrendChart').getContext('2d');
    chartInstances.donationTrend = new Chart(donationCtx, {
        type: 'line',
        data: {
            labels: data.donationTrend?.labels || getLastSixMonths(),
            datasets: [{
                label: '기부금 (원)',
                data: data.donationTrend?.data || [0, 0, 0, 0, 0, 0],
                borderColor: '#ff6b9d',
                backgroundColor: 'rgba(255, 107, 157, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, ticks: { callback: value => formatMoney(value) } }
            }
        }
    });

    // 2. 회원 증가 추이 (영역 차트)
    const memberCtx = document.getElementById('memberGrowthChart').getContext('2d');
    chartInstances.memberGrowth = new Chart(memberCtx, {
        type: 'line',
        data: {
            labels: data.memberGrowth?.labels || getLastSixMonths(),
            datasets: [{
                label: '신규 회원',
                data: data.memberGrowth?.newMembers || [0, 0, 0, 0, 0, 0],
                borderColor: '#4bc0c0',
                backgroundColor: 'rgba(75, 192, 192, 0.3)',
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } }
        }
    });

    // 3. 봉사활동 카테고리별 신청률 (막대 차트)
    const volunteerCatCtx = document.getElementById('volunteerCategoryChart').getContext('2d');
    chartInstances.volunteerCategory = new Chart(volunteerCatCtx, {
        type: 'bar',
        data: {
            labels: data.volunteerCategory?.labels || ['노인돌봄', '아동교육', '환경보호', '의료봉사', '재난구호', '문화행사'],
            datasets: [{
                label: '신청률 (%)',
                data: data.volunteerCategory?.data || [0, 0, 0, 0, 0, 0],
                backgroundColor: [
                    'rgba(239, 68, 68, 0.85)',
                    'rgba(245, 158, 11, 0.85)',
                    'rgba(34, 197, 94, 0.85)',
                    'rgba(59, 130, 246, 0.85)',
                    'rgba(139, 92, 246, 0.85)',
                    'rgba(236, 72, 153, 0.85)'
                ],
                borderColor: [
                    'rgba(239, 68, 68, 1)',
                    'rgba(245, 158, 11, 1)',
                    'rgba(34, 197, 94, 1)',
                    'rgba(59, 130, 246, 1)',
                    'rgba(139, 92, 246, 1)',
                    'rgba(236, 72, 153, 1)'
                ],
                borderWidth: 1,
                borderRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true, max: 100, ticks: { callback: value => value + '%' } } }
        }
    });

    // 4. 월별 후기 작성 현황 (라인 차트)
    const monthlyReviewCtx = document.getElementById('monthlyReviewChart').getContext('2d');
    chartInstances.monthlyReview = new Chart(monthlyReviewCtx, {
        type: 'line',
        data: {
            labels: data.monthlyReview?.labels || ['7월', '8월', '9월', '10월', '11월', '12월'],
            datasets: [
                {
                    label: '봉사 후기',
                    data: data.monthlyReview?.volunteerData || [0, 0, 0, 0, 0, 0],
                    borderColor: '#10B981',
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    fill: true,
                    tension: 0.4
                },
                {
                    label: '기부 후기',
                    data: data.monthlyReview?.donationData || [0, 0, 0, 0, 0, 0],
                    borderColor: '#3B82F6',
                    backgroundColor: 'rgba(59, 130, 246, 0.1)',
                    fill: true,
                    tension: 0.4
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom' } },
            scales: { y: { beginAtZero: true } }
        }
    });

    // 5. 복지서비스 이용 비율 (도넛 차트)
    const welfareCtx = document.getElementById('welfareServiceChart').getContext('2d');
    chartInstances.welfareService = new Chart(welfareCtx, {
        type: 'doughnut',
        data: {
            labels: data.welfareService?.labels || ['기부', '봉사', '복지진단', '복지지도', '기타'],
            datasets: [{
                data: data.welfareService?.data || [20, 20, 20, 20, 20],
                backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#22C55E', '#4BC0C0']
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom' } }
        }
    });

    // 6. 기부 카테고리별 분포 (도넛 차트)
    const categoryCtx = document.getElementById('donationCategoryChart').getContext('2d');
    chartInstances.donationCategory = new Chart(categoryCtx, {
        type: 'doughnut',
        data: {
            labels: data.donationCategory?.labels || ['위기가정', '의료비', '화재피해', '한부모', '자연재해', '노숙인', '가정폭력', '자살고위험', '범죄피해'],
            datasets: [{
                data: data.donationCategory?.data || [0, 0, 0, 0, 0, 0, 0, 0, 0],
                backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40', '#E7E9ED', '#8B5CF6', '#EC4899']
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'right', labels: { boxWidth: 12, font: { size: 11 } } },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return context.label + ': ' + formatMoney(context.raw) + '원';
                        }
                    }
                }
            }
        }
    });
}

// 기본 데이터로 차트 초기화
function initializeChartsWithDefaultData() {
    initializeCharts({
        donationTrend: { labels: getLastSixMonths(), data: [0, 0, 0, 0, 0, 0] },
        memberGrowth: { labels: getLastSixMonths(), newMembers: [0, 0, 0, 0, 0, 0] },
        volunteerCategory: { labels: ['노인돌봄', '아동교육', '환경보호', '의료봉사', '재난구호', '문화행사'], data: [0, 0, 0, 0, 0, 0] },
        paymentMethod: { labels: ['신용카드', '계좌이체', '카카오페이', '네이버페이', '토스페이'], data: [0, 0, 0, 0, 0] },
        welfareService: { labels: ['기부', '봉사', '복지진단', '복지지도', '기타'], data: [0, 0, 0, 0, 0] },
        donationCategory: { labels: ['위기가정', '의료비', '화재피해', '한부모', '자연재해', '노숙인', '가정폭력', '자살고위험', '범죄피해'], data: [0, 0, 0, 0, 0, 0, 0, 0, 0] }
    });
}

// 최근 6개월 라벨 생성
function getLastSixMonths() {
    const months = [];
    const date = new Date();
    for (let i = 5; i >= 0; i--) {
        const d = new Date(date.getFullYear(), date.getMonth() - i, 1);
        months.push((d.getMonth() + 1) + '월');
    }
    return months;
}

// 숫자 포맷팅 (천단위 콤마)
function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// 금액 포맷팅 (천단위 콤마, 한글 단위)
function formatMoney(amount) {
    if (amount >= 100000000) {
        return (amount / 100000000).toFixed(1) + '억';
    } else if (amount >= 10000) {
        return Math.floor(amount / 10000) + '만';
    }
    return formatNumber(amount);
}

// 회원 상태 변경 이력 로드
function loadMemberHistory() {
    const tbody = document.getElementById('historyTableBody');
    tbody.innerHTML = '<tr><td colspan="9" style="text-align: center;">로딩 중...</td></tr>';

    fetch('/bdproject/api/admin/member/history')
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                const history = result.data;
                if (history.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="9" style="text-align: center;">등록된 상태 변경 이력이 없습니다.</td></tr>';
                    return;
                }

                tbody.innerHTML = history.map((item, index) => {
                    // 상태/권한 한글 변환
                    const statusMap = {
                        'ACTIVE': '활성',
                        'SUSPENDED': '정지',
                        'DORMANT': '탈퇴',
                        'USER': '일반회원',
                        'MANAGER': '매니저',
                        'ADMIN': '관리자'
                    };

                    const oldStatus = statusMap[item.oldStatus] || item.oldStatus;
                    const newStatus = statusMap[item.newStatus] || item.newStatus;

                    // 상태 변경 타입에 따른 뱃지 색상
                    const oldStatusClass = item.oldStatus === 'ACTIVE' ? 'badge-success' : 'badge-danger';
                    const newStatusClass = item.newStatus === 'ACTIVE' ? 'badge-success' : 'badge-danger';

                    return `
                    <tr>
                        <td>${index + 1}</td>
                        <td>${item.memberEmail || '-'}</td>
                        <td>${item.memberName || '-'}</td>
                        <td><span class="badge ${oldStatusClass}">${oldStatus}</span></td>
                        <td><span class="badge ${newStatusClass}">${newStatus}</span></td>
                        <td>${item.reason || '사유 없음'}</td>
                        <td>${item.adminEmail || '시스템'}</td>
                        <td>${item.createdAt || '-'}</td>
                        <td>${item.ipAddress || '-'}</td>
                    </tr>
                    `;
                }).join('');
            } else {
                tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
            }
        })
        .catch(error => {
            console.error('상태 변경 이력 로드 실패:', error);
            tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
        });
}

// 전역 변수에 회원 데이터 저장
let allMembersData = [];

// 회원 목록 로드
function loadMembers() {
    const tbody = document.getElementById('membersTableBody');
    tbody.innerHTML = '<tr><td colspan="9" style="text-align: center;">로딩 중...</td></tr>';

    fetch('/bdproject/api/admin/members')
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                allMembersData = result.data;
                renderMemberTable(allMembersData);
            } else {
                tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
            }
        })
        .catch(error => {
            console.error('회원 목록 로드 실패:', error);
            tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
        });
}

// 회원 테이블 렌더링
function renderMemberTable(members) {
    const tbody = document.getElementById('membersTableBody');

    if (members.length === 0) {
        tbody.innerHTML = '<tr><td colspan="9" style="text-align: center;">등록된 회원이 없습니다.</td></tr>';
        return;
    }

    tbody.innerHTML = members.map((member, index) => {
        const roleText = member.role === 'ADMIN' ? 'MANAGER' : 'USER';
        const roleClass = member.role === 'ADMIN' ? 'badge-admin' : 'badge-user';

        // 상태 표시
        const status = member.status || 'ACTIVE';
        let statusText = '';
        let statusClass = '';

        if (status === 'ACTIVE') {
            statusText = '활동중';
            statusClass = 'badge-success';
        } else if (status === 'SUSPENDED') {
            statusText = '활동정지';
            statusClass = 'badge-warning';
        } else if (status === 'DORMANT') {
            statusText = '탈퇴';
            statusClass = 'badge-danger';
        } else {
            statusText = '활동중';
            statusClass = 'badge-success';
        }

        // 날짜 포맷팅
        const createdAt = member.createdAt ? formatDateTime(member.createdAt) : '-';
        const lastLoginAt = member.lastLoginAt ? formatDateTime(member.lastLoginAt) : '-';
        const statusUpdatedAt = member.statusUpdatedAt ? formatDateTime(member.statusUpdatedAt) : '-';

        return '<tr data-user-id="' + member.userId + '">' +
                '<td><input type="checkbox" class="member-checkbox" value="' + member.userId + '"' + (member.role === 'ADMIN' ? ' disabled' : '') + '></td>' +
                '<td>' + (member.email || '-') + '<br><small style="color: #999;">' + (member.userId || '-') + '</small></td>' +
                '<td>' + (member.name || '-') + '</td>' +
                '<td>' + (member.phone || '-') + '</td>' +
                '<td>' + createdAt + '</td>' +
                '<td><span class="badge ' + statusClass + '">' + statusText + '</span></td>' +
                '<td>' + lastLoginAt + '</td>' +
                '<td>' + statusUpdatedAt + '</td>' +
                '<td><span class="badge ' + roleClass + '">' + roleText + '</span></td>' +
            '</tr>';
    }).join('');
}

// 날짜 시간 포맷팅
function formatDateTime(dateString) {
    if (!dateString) return '-';
    try {
        const date = new Date(dateString);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;
    } catch (e) {
        return dateString;
    }
}

// 공지사항 목록 로드
function loadNotices() {
    const tbody = document.getElementById('noticesTableBody');
    tbody.innerHTML = '<tr><td colspan="6" style="text-align: center;">로딩 중...</td></tr>';

    fetch('/bdproject/api/admin/notices')
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                const notices = result.data;
                if (notices.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="6" style="text-align: center;">등록된 공지사항이 없습니다.</td></tr>';
                    return;
                }
                // API가 최신순으로 반환하므로, 역순으로 번호 매김
                // 마지막 항목(가장 오래된 것) = 1번, 첫 항목(최신) = 가장 큰 번호
                const totalCount = notices.length;

                tbody.innerHTML = notices.map((notice, index) => `
                    <tr>
                        <td>${totalCount - index}</td>
                        <td>${notice.title || '-'}</td>
                        <td>${notice.views || 0}</td>
                        <td><span class="badge ${notice.isPinned ? 'badge-success' : 'badge-warning'}">${notice.isPinned ? '고정' : '일반'}</span></td>
                        <td>${notice.createdAt || '-'}</td>
                        <td class="table-actions">
                            <button class="btn-sm btn-edit" onclick="editNotice(${notice.noticeId})">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn-sm btn-delete" onclick="deleteNotice(${notice.noticeId})">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `).join('');
            } else {
                tbody.innerHTML = '<tr><td colspan="6" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
            }
        })
        .catch(error => {
            console.error('공지사항 목록 로드 실패:', error);
            tbody.innerHTML = '<tr><td colspan="6" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
        });
}

// FAQ 목록 로드
function loadFaqs() {
    const tbody = document.getElementById('faqsTableBody');
    tbody.innerHTML = '<tr><td colspan="4" style="text-align: center;">로딩 중...</td></tr>';

    fetch('/bdproject/api/admin/faqs')
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                const faqs = result.data;
                if (faqs.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="4" style="text-align: center;">등록된 FAQ가 없습니다.</td></tr>';
                    return;
                }
                // API가 최신순으로 반환하므로, 역순으로 번호 매김
                const totalCount = faqs.length;
                tbody.innerHTML = faqs.map((faq, index) => `
                    <tr>
                        <td>${totalCount - index}</td>
                        <td><span class="badge badge-user">${faq.category || '-'}</span></td>
                        <td>${faq.question || '-'}</td>
                        <td class="table-actions">
                            <button class="btn-sm btn-edit" onclick="editFaq(${faq.faqId})" title="수정">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn-sm btn-delete" onclick="deleteFaq(${faq.faqId})" title="삭제">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `).join('');
            } else {
                tbody.innerHTML = '<tr><td colspan="4" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
            }
        })
        .catch(error => {
            console.error('FAQ 목록 로드 실패:', error);
            tbody.innerHTML = '<tr><td colspan="4" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
        });
}

// 기부 내역 로드
function loadDonations() {
    const tbody = document.getElementById('donationsTableBody');
    tbody.innerHTML = '<tr><td colspan="8" style="text-align: center;">로딩 중...</td></tr>';

    fetch('/bdproject/api/admin/donations')
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                const donations = result.data;
                if (donations.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="8" style="text-align: center;">등록된 기부 내역이 없습니다.</td></tr>';
                    return;
                }

                // 전역 변수에 저장 (viewDonation에서 사용)
                window.donationsData = donations;

                tbody.innerHTML = donations.map((donation, index) => {
                    const statusText = (donation.paymentStatus === 'COMPLETED' || donation.paymentStatus === 'completed') ? '완료' : '대기';
                    return '<tr>' +
                        '<td>' + (donation.donationId || '-') + '</td>' +
                        '<td>' + (donation.donorName || '-') + '</td>' +
                        '<td>₩' + formatNumber(donation.amount || 0) + '</td>' +
                        '<td><span class="badge badge-user">' + (donation.donationType === 'REGULAR' || donation.donationType === 'regular' ? '정기' : '일시') + '</span></td>' +
                        '<td>' + (donation.category || '-') + '</td>' +
                        '<td><span class="badge badge-success">' + statusText + '</span></td>' +
                        '<td>' + (donation.createdAt || '-') + '</td>' +
                        '<td class="table-actions">' +
                            '<button class="btn-sm btn-view" onclick="viewDonation(' + index + ')" title="상세 보기">' +
                                '<i class="fas fa-eye"></i>' +
                            '</button>' +
                        '</td>' +
                    '</tr>';
                }).join('');
            } else {
                tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
            }
        })
        .catch(error => {
            console.error('기부 내역 로드 실패:', error);
            tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
        });
}

// ===== 환불 요청 관리 함수들 =====

// 환불 요청 목록 로드
function loadRefundRequests() {
    const tbody = document.getElementById('refundRequestsTableBody');
    if (!tbody) return;
    tbody.innerHTML = '<tr><td colspan="8" style="text-align: center;">로딩 중...</td></tr>';

    fetch('/bdproject/api/donation/refund/pending')
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                const refunds = result.data;

                // 배지 업데이트
                const badge = document.getElementById('refundBadge');
                const count = document.getElementById('refundCount');
                if (refunds.length > 0) {
                    badge.textContent = refunds.length;
                    badge.style.display = 'inline';
                } else {
                    badge.style.display = 'none';
                }
                count.textContent = refunds.length;

                if (refunds.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="8" style="text-align: center;">대기 중인 환불 요청이 없습니다.</td></tr>';
                    return;
                }

                tbody.innerHTML = refunds.map((refund, index) => {
                    const donorName = refund.memberName || refund.donorName || '-';
                    const donorEmail = refund.memberEmail || refund.donorEmail || '-';
                    const amount = Number(refund.amount) || 0;
                    const refundAmount = Number(refund.refundAmount) || 0;
                    const refundFee = Number(refund.refundFee) || 0;
                    const createdAt = refund.createdAt ? new Date(refund.createdAt).toLocaleDateString('ko-KR') : '-';

                    return '<tr>' +
                        '<td>' + (refund.donationId || '-') + '</td>' +
                        '<td>' +
                            '<div style="font-weight: 600;">' + donorName + '</div>' +
                            '<div style="font-size: 12px; color: #888;">' + donorEmail + '</div>' +
                        '</td>' +
                        '<td>₩' + formatNumber(amount) + '</td>' +
                        '<td style="color: #e74c3c;">-₩' + formatNumber(refundFee) + '</td>' +
                        '<td style="color: #27ae60; font-weight: 600;">₩' + formatNumber(refundAmount) + '</td>' +
                        '<td>' + (refund.categoryName || '-') + '</td>' +
                        '<td>' + createdAt + '</td>' +
                        '<td class="table-actions">' +
                            '<button class="btn-sm" style="background: #27ae60; color: white;" ' +
                                    'onclick="approveRefund(' + refund.donationId + ')" title="승인">' +
                                '<i class="fas fa-check"></i> 승인' +
                            '</button>' +
                            '<button class="btn-sm" style="background: #e74c3c; color: white;" ' +
                                    'onclick="rejectRefund(' + refund.donationId + ')" title="거부">' +
                                '<i class="fas fa-times"></i> 거부' +
                            '</button>' +
                        '</td>' +
                    '</tr>';
                }).join('');
            } else {
                tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
            }
        })
        .catch(error => {
            console.error('환불 요청 목록 로드 실패:', error);
            tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
        });
}

// 환불 승인
function approveRefund(donationId) {
    if (!confirm('이 환불 요청을 승인하시겠습니까?\n승인 후에는 취소할 수 없습니다.')) {
        return;
    }

    fetch('/bdproject/api/donation/refund/approve', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'donationId=' + donationId
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert('환불이 승인되었습니다.\n환불금액: ' + formatNumber(result.refundAmount) + '원');
            loadRefundRequests(); // 목록 새로고침
        } else {
            alert('환불 승인 실패: ' + (result.message || '알 수 없는 오류'));
        }
    })
    .catch(error => {
        console.error('환불 승인 오류:', error);
        alert('환불 승인 중 오류가 발생했습니다.');
    });
}

// 환불 거부
function rejectRefund(donationId) {
    const reason = prompt('환불 거부 사유를 입력해주세요:');
    if (reason === null) return; // 취소

    if (!reason.trim()) {
        alert('거부 사유를 입력해주세요.');
        return;
    }

    fetch('/bdproject/api/donation/refund/reject', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'donationId=' + donationId + '&reason=' + encodeURIComponent(reason)
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert('환불 요청이 거부되었습니다.');
            loadRefundRequests(); // 목록 새로고침
        } else {
            alert('환불 거부 실패: ' + (result.message || '알 수 없는 오류'));
        }
    })
    .catch(error => {
        console.error('환불 거부 오류:', error);
        alert('환불 거부 중 오류가 발생했습니다.');
    });
}

// ===== 봉사활동 관리 함수들 =====

// 봉사활동 목록 로드
function loadVolunteers() {
    const tbody = document.getElementById('volunteersTableBody');
    tbody.innerHTML = '<tr><td colspan="7" style="text-align: center;">로딩 중...</td></tr>';

    fetch('/bdproject/api/admin/volunteers')
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                const volunteers = result.data;
                if (volunteers.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="7" style="text-align: center;">등록된 봉사 신청이 없습니다.</td></tr>';
                    return;
                }
                tbody.innerHTML = volunteers.map(volunteer => `
                    <tr>
                        <td>${volunteer.applicationId || '-'}</td>
                        <td>${volunteer.applicantName || '-'}</td>
                        <td>${volunteer.activityName || '-'}</td>
                        <td><span class="badge badge-user">${volunteer.selectedCategory || '-'}</span></td>
                        <td>${volunteer.volunteerDate || '-'}</td>
                        <td><span class="badge ${
                            volunteer.status === 'completed' ? 'badge-success' :
                            volunteer.status === 'confirmed' ? 'badge-warning' : 'badge-user'
                        }">${
                            volunteer.status === 'completed' ? '완료' :
                            volunteer.status === 'confirmed' ? '확정' : '신청'
                        }</span></td>
                        <td class="table-actions">
                            <button class="btn-sm btn-view" onclick="viewVolunteer(${volunteer.applicationId})">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="btn-sm btn-edit" onclick="editVolunteer(${volunteer.applicationId})">
                                <i class="fas fa-edit"></i>
                            </button>
                        </td>
                    </tr>
                `).join('');
            } else {
                tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
            }
        })
        .catch(error => {
            console.error('봉사 신청 목록 로드 실패:', error);
            tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
        });
}

// 모달 관련 함수들
function openNoticeModal() {
    document.getElementById('noticeModal').classList.add('active');
}

function closeNoticeModal() {
    document.getElementById('noticeModal').classList.remove('active');
    document.getElementById('noticeForm').reset();

    // 모달을 기본 상태(작성 모드)로 되돌림
    document.getElementById('noticeModalTitle').textContent = '공지사항 작성';
    document.getElementById('noticeSubmitBtn').textContent = '등록';
    document.getElementById('noticeId').value = '';
}

function openFaqModal() {
    document.getElementById('faqModal').classList.add('active');
}

function closeFaqModal() {
    document.getElementById('faqModal').classList.remove('active');
    document.getElementById('faqForm').reset();

    // 모달을 기본 상태(작성 모드)로 되돌림
    document.getElementById('faqModalTitle').textContent = 'FAQ 작성';
    document.getElementById('faqSubmitBtn').textContent = '등록';
    document.getElementById('faqId').value = '';
}

function openVolunteerModal() {
    alert('봉사활동 등록 기능은 추후 구현 예정입니다.');
}

// 공지사항 제출
function submitNotice() {
    const form = document.getElementById('noticeForm');
    const formData = new FormData(form);

    // 입력값 검증
    const title = formData.get('title');
    const content = formData.get('content');
    const isPinned = formData.get('isPinned') === 'true';
    const noticeId = formData.get('noticeId');

    if (!title || title.trim() === '') {
        alert('제목을 입력해주세요.');
        return;
    }

    if (!content || content.trim() === '') {
        alert('내용을 입력해주세요.');
        return;
    }

    // URLSearchParams로 변환
    const params = new URLSearchParams();
    params.append('title', title);
    params.append('content', content);
    params.append('isPinned', isPinned);

    // 수정 모드인지 확인
    const isUpdate = noticeId && noticeId.trim() !== '';
    const url = isUpdate ? '/bdproject/api/notices/' + noticeId + '/update' : '/bdproject/api/notices';
    const successMessage = isUpdate ? '공지사항이 수정되었습니다.' : '공지사항이 등록되었습니다.';

    // API 호출
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
    })
    .then(response => {
        console.log('Response status:', response.status);
        if (!response.ok) {
            throw new Error('HTTP error! status: ' + response.status);
        }
        return response.json();
    })
    .then(result => {
        console.log('API 응답:', result);
        if (result.success) {
            alert(successMessage);
            closeNoticeModal();
            form.reset();
            loadNotices(); // 목록 새로고침
        } else {
            alert('실패: ' + (result.message || '알 수 없는 오류'));
        }
    })
    .catch(error => {
        console.error('공지사항 처리 오류:', error);
        alert('공지사항 처리 중 오류가 발생했습니다: ' + error.message);
    });
}

// FAQ 제출
function submitFaq() {
    const form = document.getElementById('faqForm');
    const formData = new FormData(form);

    // 입력값 검증
    const category = formData.get('category');
    const question = formData.get('question');
    const answer = formData.get('answer');
    const faqId = formData.get('faqId');

    if (!category || category.trim() === '') {
        alert('카테고리를 선택해주세요.');
        return;
    }

    if (!question || question.trim() === '') {
        alert('질문을 입력해주세요.');
        return;
    }

    if (!answer || answer.trim() === '') {
        alert('답변을 입력해주세요.');
        return;
    }

    // URLSearchParams로 변환
    const params = new URLSearchParams();
    params.append('category', category);
    params.append('question', question);
    params.append('answer', answer);

    // 수정 모드인지 확인
    const isUpdate = faqId && faqId.trim() !== '';
    const url = isUpdate ? '/bdproject/api/faqs/' + faqId + '/update' : '/bdproject/api/faqs';
    const successMessage = isUpdate ? 'FAQ가 수정되었습니다.' : 'FAQ가 등록되었습니다.';

    // API 호출
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('HTTP error! status: ' + response.status);
        }
        return response.json();
    })
    .then(result => {
        if (result.success) {
            alert(successMessage);
            closeFaqModal();
            form.reset();
            loadFaqs(); // 목록 새로고침
        } else {
            alert('실패: ' + (result.message || '알 수 없는 오류'));
        }
    })
    .catch(error => {
        console.error('FAQ 처리 오류:', error);
        alert('FAQ 처리 중 오류가 발생했습니다: ' + error.message);
    });
}

// 필터링 함수
function filterMembers() {
    const searchTerm = document.getElementById('memberSearch').value.toLowerCase().trim();
    const statusFilter = document.getElementById('statusFilter').value;
    const roleFilter = document.getElementById('roleFilter').value;

    let filteredMembers = allMembersData.filter(member => {
        // 검색어 필터
        const matchesSearch = !searchTerm ||
            (member.email && member.email.toLowerCase().includes(searchTerm)) ||
            (member.userId && member.userId.toLowerCase().includes(searchTerm)) ||
            (member.name && member.name.toLowerCase().includes(searchTerm)) ||
            (member.phone && member.phone.toLowerCase().includes(searchTerm));

        // 상태 필터
        const memberStatus = member.status || 'ACTIVE';
        const matchesStatus = !statusFilter || memberStatus === statusFilter;

        // 등급 필터
        const matchesRole = !roleFilter || member.role === roleFilter;

        return matchesSearch && matchesStatus && matchesRole;
    });

    renderMemberTable(filteredMembers);
}

// 전체 선택/해제
function toggleSelectAll(checkbox) {
    const checkboxes = document.querySelectorAll('.member-checkbox');
    checkboxes.forEach(cb => cb.checked = checkbox.checked);
}

// 일괄 처리 적용
function applyBulkAction() {
    const selectedUserIds = getSelectedUserIds();

    if (selectedUserIds.length === 0) {
        alert('회원을 선택해주세요.');
        return;
    }

    const bulkAction = document.getElementById('bulkActionSelect').value;
    const bulkRole = document.getElementById('bulkRoleSelect').value;

    if (!bulkAction && !bulkRole) {
        alert('변경할 항목을 선택해주세요.');
        return;
    }

    // 상태 변경
    if (bulkAction) {
        if (!confirm(selectedUserIds.length + '명의 회원 상태를 변경하시겠습니까?')) {
            return;
        }
        bulkUpdateStatus(selectedUserIds, bulkAction);
    }

    // 등급 변경
    if (bulkRole) {
        if (!confirm(selectedUserIds.length + '명의 회원 등급을 ' + (bulkRole === 'ADMIN' ? 'MANAGER' : 'USER') + '로 변경하시겠습니까?')) {
            return;
        }
        bulkUpdateRole(selectedUserIds, bulkRole);
    }
}

// 선택된 회원 ID 가져오기
function getSelectedUserIds() {
    const checkboxes = document.querySelectorAll('.member-checkbox:checked');
    return Array.from(checkboxes).map(cb => cb.value);
}

// 일괄 상태 변경
function bulkUpdateStatus(userIds, action) {
    const params = new URLSearchParams();
    params.append('userIds', userIds.join(','));
    params.append('action', action);

    fetch('/bdproject/api/admin/member/bulk-status', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert('상태가 변경되었습니다.');
            loadMembers();
            document.getElementById('selectAllMembers').checked = false;
            document.getElementById('bulkActionSelect').value = '';
        } else {
            alert('상태 변경 실패: ' + (result.message || '알 수 없는 오류'));
        }
    })
    .catch(error => {
        console.error('일괄 상태 변경 오류:', error);
        alert('상태 변경 중 오류가 발생했습니다.');
    });
}

// 일괄 등급 변경
function bulkUpdateRole(userIds, role) {
    const params = new URLSearchParams();
    params.append('userIds', userIds.join(','));
    params.append('role', role);

    fetch('/bdproject/api/admin/member/bulk-role', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert('등급이 변경되었습니다.');
            loadMembers();
            document.getElementById('selectAllMembers').checked = false;
            document.getElementById('bulkRoleSelect').value = '';
        } else {
            alert('등급 변경 실패: ' + (result.message || '알 수 없는 오류'));
        }
    })
    .catch(error => {
        console.error('일괄 등급 변경 오류:', error);
        alert('등급 변경 중 오류가 발생했습니다.');
    });
}

// 검색 함수들
function searchMembers() {
    filterMembers();
}

function searchHistory() {
    const searchTerm = document.getElementById('historySearch').value.toLowerCase().trim();
    const tbody = document.getElementById('historyTableBody');
    const rows = tbody.querySelectorAll('tr');

    if (!searchTerm) {
        rows.forEach(row => row.style.display = '');
        return;
    }

    rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        if (text.includes(searchTerm)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

function searchDonations() {
    const searchTerm = document.getElementById('donationSearch').value.toLowerCase().trim();
    const tbody = document.getElementById('donationsTableBody');
    const rows = tbody.querySelectorAll('tr');

    if (!searchTerm) {
        rows.forEach(row => row.style.display = '');
        return;
    }

    rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        if (text.includes(searchTerm)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

// 회원 관련 함수들
function editMember(userId, name, email, phone) {
    document.getElementById('editUserId').value = userId;
    document.getElementById('editUserIdDisplay').value = userId;
    document.getElementById('editName').value = name;
    document.getElementById('editEmail').value = email;
    document.getElementById('editPhone').value = phone || '';
    document.getElementById('memberModal').classList.add('active');
}

function closeMemberModal() {
    document.getElementById('memberModal').classList.remove('active');
    document.getElementById('memberForm').reset();
}

function submitMemberEdit() {
    const userId = document.getElementById('editUserId').value;
    const name = document.getElementById('editName').value;
    const email = document.getElementById('editEmail').value;
    const phone = document.getElementById('editPhone').value;

    if (!name || !email) {
        alert('이름과 이메일은 필수 입력 항목입니다.');
        return;
    }

    const params = new URLSearchParams();
    params.append('userId', userId);
    params.append('name', name);
    params.append('email', email);
    params.append('phone', phone);

    fetch('/bdproject/api/admin/member/update', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert('회원 정보가 수정되었습니다.');
            closeMemberModal();
            loadMembers();
        } else {
            alert('수정 실패: ' + (result.message || '알 수 없는 오류'));
        }
    })
    .catch(error => {
        console.error('회원 수정 오류:', error);
        alert('회원 수정 중 오류가 발생했습니다.');
    });
}

function deleteMember(userId) {
    if (!confirm('이 회원을 탈퇴 처리하시겠습니까?\n탈퇴된 계정은 로그인할 수 없습니다.')) {
        return;
    }

    fetch(`/bdproject/api/admin/member/delete?userId=${userId}`, {
        method: 'POST'
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert('회원이 탈퇴 처리되었습니다.');
            loadMembers();
        } else {
            alert('탈퇴 처리 실패: ' + (result.message || '알 수 없는 오류'));
        }
    })
    .catch(error => {
        console.error('회원 탈퇴 처리 오류:', error);
        alert('회원 탈퇴 처리 중 오류가 발생했습니다.');
    });
}

// 회원 계정 정지
function suspendMember(userId) {
    if (!confirm('이 계정을 정지하시겠습니까?\n정지된 계정은 로그인할 수 없습니다.')) {
        return;
    }

    fetch(`/bdproject/api/admin/member/suspend?userId=${userId}`, {
        method: 'POST'
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert('계정이 정지되었습니다.');
            loadMembers();
        } else {
            alert('정지 실패: ' + (result.message || '알 수 없는 오류'));
        }
    })
    .catch(error => {
        console.error('계정 정지 오류:', error);
        alert('계정 정지 중 오류가 발생했습니다.');
    });
}

// 회원 계정 활성화
function activateMember(userId) {
    if (!confirm('이 계정을 활성화하시겠습니까?')) {
        return;
    }

    fetch(`/bdproject/api/admin/member/activate?userId=${userId}`, {
        method: 'POST'
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert('계정이 활성화되었습니다.');
            loadMembers();
        } else {
            alert('활성화 실패: ' + (result.message || '알 수 없는 오류'));
        }
    })
    .catch(error => {
        console.error('계정 활성화 오류:', error);
        alert('계정 활성화 중 오류가 발생했습니다.');
    });
}

function viewNotice(id) {
    alert('공지사항 상세 보기 기능은 추후 구현 예정입니다.');
}

function editNotice(id) {
    // 공지사항 상세 조회
    fetch('/bdproject/api/notices/' + id)
        .then(response => response.json())
        .then(result => {
            if (result.success && result.data) {
                const notice = result.data;

                // 폼 필드에 데이터 채우기
                document.getElementById('noticeId').value = notice.noticeId;
                document.getElementById('noticeTitle').value = notice.title;
                document.getElementById('noticeContent').value = notice.content;
                document.getElementById('noticePinned').checked = notice.isPinned;

                // 모달 제목 및 버튼 텍스트 변경
                document.getElementById('noticeModalTitle').textContent = '공지사항 수정';
                document.getElementById('noticeSubmitBtn').textContent = '수정';

                // 모달 열기
                openNoticeModal();
            } else {
                alert('공지사항을 불러올 수 없습니다.');
            }
        })
        .catch(error => {
            console.error('공지사항 조회 오류:', error);
            alert('공지사항 조회 중 오류가 발생했습니다.');
        });
}

function deleteNotice(id) {
    if (!confirm('정말 삭제하시겠습니까?')) {
        return;
    }

    fetch(`/bdproject/api/notices/${id}/delete`, {
        method: 'POST'
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert('공지사항이 삭제되었습니다.');
            loadNotices(); // 목록 새로고침
        } else {
            alert('삭제 실패: ' + (result.message || '알 수 없는 오류'));
        }
    })
    .catch(error => {
        console.error('공지사항 삭제 오류:', error);
        alert('공지사항 삭제 중 오류가 발생했습니다.');
    });
}

// FAQ 상세 보기
function viewFaq(id) {
    fetch('/bdproject/api/faqs/' + id)
        .then(response => response.json())
        .then(result => {
            if (result.success && result.data) {
                const faq = result.data;
                let message = '=== FAQ 상세 정보 ===\n\n';
                message += '번호: ' + faq.faqId + '\n';
                message += '카테고리: ' + (faq.category || '-') + '\n';
                message += '질문: ' + faq.question + '\n\n';
                message += '답변:\n' + faq.answer + '\n\n';
                message += '등록일: ' + (faq.createdAt || '-');
                alert(message);
            } else {
                alert('FAQ를 불러올 수 없습니다.');
            }
        })
        .catch(error => {
            console.error('FAQ 조회 오류:', error);
            alert('FAQ 조회 중 오류가 발생했습니다.');
        });
}

// FAQ 수정
function editFaq(id) {
    fetch('/bdproject/api/faqs/' + id)
        .then(response => response.json())
        .then(result => {
            if (result.success && result.data) {
                const faq = result.data;

                // 폼 필드에 데이터 채우기
                document.getElementById('faqId').value = faq.faqId;
                document.querySelector('#faqForm select[name="category"]').value = faq.category || '';
                document.querySelector('#faqForm input[name="question"]').value = faq.question || '';
                document.querySelector('#faqForm textarea[name="answer"]').value = faq.answer || '';

                // 모달 제목 및 버튼 텍스트 변경
                document.getElementById('faqModalTitle').textContent = 'FAQ 수정';
                document.getElementById('faqSubmitBtn').textContent = '수정';

                // 모달 열기
                openFaqModal();
            } else {
                alert('FAQ를 불러올 수 없습니다.');
            }
        })
        .catch(error => {
            console.error('FAQ 조회 오류:', error);
            alert('FAQ 조회 중 오류가 발생했습니다.');
        });
}

// FAQ 삭제
function deleteFaq(id) {
    if (!confirm('정말 삭제하시겠습니까?\n삭제된 FAQ는 복구할 수 없습니다.')) {
        return;
    }

    fetch('/bdproject/api/faqs/' + id + '/delete', {
        method: 'POST'
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert('FAQ가 삭제되었습니다.');
            loadFaqs(); // 목록 새로고침
        } else {
            alert('삭제 실패: ' + (result.message || '알 수 없는 오류'));
        }
    })
    .catch(error => {
        console.error('FAQ 삭제 오류:', error);
        alert('FAQ 삭제 중 오류가 발생했습니다.');
    });
}

// ===== 사용자 질문 관리 관련 함수들 =====
let allUserQuestionsData = [];

// 사용자 질문 목록 로드
function loadUserQuestions() {
    const tbody = document.getElementById('userQuestionsTableBody');
    tbody.innerHTML = '<tr><td colspan="7" style="text-align: center;">로딩 중...</td></tr>';

    fetch('/bdproject/api/questions')
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                allUserQuestionsData = result.data;
                renderUserQuestionsTable(allUserQuestionsData);
            } else {
                tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
            }
        })
        .catch(error => {
            console.error('질문 목록 로드 실패:', error);
            tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
        });
}

// 사용자 질문 테이블 렌더링
function renderUserQuestionsTable(questions) {
    const tbody = document.getElementById('userQuestionsTableBody');

    if (questions.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center;">등록된 질문이 없습니다.</td></tr>';
        return;
    }

    tbody.innerHTML = questions.map((q, index) => {
        const statusText = q.status === 'answered' ? '답변 완료' : '답변 대기';
        const statusClass = q.status === 'answered' ? 'badge-success' : 'badge-warning';
        const createdAt = q.createdAt ? formatDateTime(q.createdAt) : '-';

        const actionButtons = q.status === 'pending'
            ? '<button class="btn-sm btn-success" onclick="openAnswerModal(' + q.questionId + ')" title="답변하기"><i class="fas fa-reply"></i> 답변</button>'
            : '<button class="btn-sm btn-view" onclick="openAnswerModal(' + q.questionId + ')" title="답변 확인/수정"><i class="fas fa-eye"></i> 확인</button>';

        return '<tr>' +
            '<td>' + q.questionId + '</td>' +
            '<td><span class="badge badge-user">' + (q.category || '-') + '</span></td>' +
            '<td style="text-align: left; max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">' + (q.title || '-') + '</td>' +
            '<td>' + (q.userName || '-') + '</td>' +
            '<td>' + createdAt + '</td>' +
            '<td><span class="badge ' + statusClass + '">' + statusText + '</span></td>' +
            '<td class="table-actions">' + actionButtons + '</td>' +
        '</tr>';
    }).join('');
}

// 사용자 질문 필터링 (이름 + 상태)
function filterUserQuestions() {
    const nameSearch = document.getElementById('questionNameSearch').value.trim().toLowerCase();
    const statusFilter = document.getElementById('questionStatusFilter').value;

    let filteredQuestions = allUserQuestionsData.filter(q => {
        const matchesName = !nameSearch || (q.userName && q.userName.toLowerCase().includes(nameSearch));
        const matchesStatus = !statusFilter || q.status === statusFilter;
        return matchesName && matchesStatus;
    });

    renderUserQuestionsTable(filteredQuestions);
}

// 답변 모달 열기
function openAnswerModal(questionId) {
    fetch('/bdproject/api/questions/' + questionId)
        .then(response => response.json())
        .then(result => {
            if (result.success && result.data) {
                const q = result.data;

                // 질문 정보 표시
                document.getElementById('answerQuestionId').value = q.questionId;
                document.getElementById('answerQuestionCategory').textContent = q.category || '-';
                document.getElementById('answerQuestionAuthor').textContent = q.userName || '-';
                document.getElementById('answerQuestionEmail').textContent = q.userEmail || '-';
                document.getElementById('answerQuestionTitle').textContent = q.title || '-';
                document.getElementById('answerQuestionContent').textContent = q.content || '-';
                document.getElementById('answerQuestionDate').textContent = q.createdAt ? formatDateTime(q.createdAt) : '-';

                // 기존 답변이 있는 경우 표시
                if (q.answer && q.answer.trim() !== '') {
                    document.getElementById('existingAnswerSection').style.display = 'block';
                    document.getElementById('existingAnswerContent').textContent = q.answer;
                    document.getElementById('existingAnsweredBy').textContent = q.answeredBy || '-';
                    document.getElementById('existingAnsweredAt').textContent = q.answeredAt ? formatDateTime(q.answeredAt) : '-';
                    document.getElementById('answerContent').value = q.answer;
                    document.getElementById('answerSubmitBtn').innerHTML = '<i class="fas fa-edit"></i> 답변 수정';
                } else {
                    document.getElementById('existingAnswerSection').style.display = 'none';
                    document.getElementById('answerContent').value = '';
                    document.getElementById('answerSubmitBtn').innerHTML = '<i class="fas fa-paper-plane"></i> 답변 등록';
                }

                // 모달 열기
                const modal = document.getElementById('answerQuestionModal');
                modal.classList.add('active');
                modal.style.display = 'flex';
            } else {
                alert('질문을 불러올 수 없습니다.');
            }
        })
        .catch(error => {
            console.error('질문 조회 오류:', error);
            alert('질문 조회 중 오류가 발생했습니다.');
        });
}

// 답변 모달 닫기
function closeAnswerModal() {
    const modal = document.getElementById('answerQuestionModal');
    modal.classList.remove('active');
    modal.style.display = 'none';
    document.getElementById('answerContent').value = '';
    document.getElementById('existingAnswerSection').style.display = 'none';
}

// 답변 제출
function submitQuestionAnswer() {
    const questionId = document.getElementById('answerQuestionId').value;
    const answer = document.getElementById('answerContent').value.trim();

    if (!answer) {
        alert('답변 내용을 입력해주세요.');
        document.getElementById('answerContent').focus();
        return;
    }

    if (!confirm('답변을 등록하시겠습니까?')) {
        return;
    }

    const params = new URLSearchParams();
    params.append('answer', answer);

    fetch('/bdproject/api/questions/' + questionId + '/answer', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert('답변이 등록되었습니다.');
            closeAnswerModal();
            loadUserQuestions(); // 목록 새로고침
        } else {
            alert('답변 등록 실패: ' + (result.message || '알 수 없는 오류'));
        }
    })
    .catch(error => {
        console.error('답변 등록 오류:', error);
        alert('답변 등록 중 오류가 발생했습니다.');
    });
}

// 기부 상세 보기
function viewDonation(index) {
    const donation = window.donationsData[index];
    if (!donation) {
        alert('기부 정보를 찾을 수 없습니다.');
        return;
    }

    // 결제수단 변환
    const paymentMethodMap = {
        'credit_card': '신용카드',
        'bank_transfer': '계좌이체',
        'kakao_pay': '카카오페이',
        'naver_pay': '네이버페이'
    };

    // 모달에 데이터 채우기
    document.getElementById('detailDonationId').textContent = donation.donationId || '-';
    document.getElementById('detailDonorName').textContent = donation.donorName || '-';
    document.getElementById('detailDonorEmail').textContent = donation.donorEmail || '-';
    document.getElementById('detailDonorPhone').textContent = donation.donorPhone || '-';
    document.getElementById('detailAmount').textContent = '₩' + formatNumber(donation.amount || 0);
    document.getElementById('detailDonationType').textContent = donation.donationType === 'regular' ? '정기 후원' : '일시 후원';
    document.getElementById('detailCategory').textContent = donation.category || '-';
    document.getElementById('detailPackageName').textContent = donation.packageName || '-';
    document.getElementById('detailPaymentMethod').textContent = paymentMethodMap[donation.paymentMethod] || donation.paymentMethod || '-';
    document.getElementById('detailPaymentStatus').textContent = donation.paymentStatus === 'completed' ? '완료' : '대기';
    document.getElementById('detailCreatedAt').textContent = donation.createdAt || '-';
    document.getElementById('detailMessage').textContent = donation.message || '메시지 없음';

    // 모달 열기
    const modal = document.getElementById('donationModal');
    modal.classList.add('active');
    modal.style.display = 'flex';
}

// 기부 상세 모달 닫기
function closeDonationModal() {
    const modal = document.getElementById('donationModal');
    modal.classList.remove('active');
    modal.style.display = 'none';
}

// 봉사활동 관리 관련 함수들
let allVolunteersData = [];

// 봉사 신청 목록 로드 (재정의 - 더 많은 정보 포함)
function loadVolunteers() {
    const tbody = document.getElementById('volunteersTableBody');
    tbody.innerHTML = '<tr><td colspan="8" style="text-align: center;">로딩 중...</td></tr>';

    fetch('/bdproject/api/admin/volunteers')
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                allVolunteersData = result.data;
                renderVolunteerTable(allVolunteersData);
            } else {
                tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
            }
        })
        .catch(error => {
            console.error('봉사 신청 목록 로드 실패:', error);
            tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
        });
}

// 봉사 신청 테이블 렌더링
function renderVolunteerTable(volunteers) {
    const tbody = document.getElementById('volunteersTableBody');

    if (volunteers.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" style="text-align: center;">등록된 봉사 신청이 없습니다.</td></tr>';
        return;
    }

    tbody.innerHTML = volunteers.map((vol, index) => {
        const statusText = getVolunteerStatusText(vol.status);
        const statusClass = getVolunteerStatusClass(vol.status);
        const createdAt = vol.createdAt ? formatDateTime(vol.createdAt) : '-';
        const schedule = vol.volunteerDate + ' ' + (vol.volunteerTime || '');

        const facilityInfo = vol.assignedFacilityName
            ? '<div style="font-size: 12px;"><strong>' + vol.assignedFacilityName + '</strong><br><small style="color: #666;">' + (vol.assignedFacilityAddress || '') + '</small></div>'
            : '<span style="color: #999;">미배정</span>';

        const actionButtons = vol.status === 'APPLIED'
            ? '<button class="btn-sm btn-success" onclick="openFacilityMatchModal(' + vol.applicationId + ')" title="승인 및 시설 배정"><i class="fas fa-check"></i> 승인</button>' +
              '<button class="btn-sm btn-danger" onclick="rejectVolunteer(' + vol.applicationId + ')" title="거절"><i class="fas fa-times"></i></button>'
            : '<button class="btn-sm btn-edit" onclick="viewVolunteerDetail(' + vol.applicationId + ')" title="상세보기"><i class="fas fa-eye"></i></button>';

        return '<tr>' +
            '<td>' + (index + 1) + '</td>' +
            '<td><strong>' + (vol.applicantName || '-') + '</strong></td>' +
            '<td>' + (vol.selectedCategory || '-') + '</td>' +
            '<td>' + schedule + '</td>' +
            '<td>' + createdAt + '</td>' +
            '<td><span class="badge ' + statusClass + '">' + statusText + '</span></td>' +
            '<td>' + facilityInfo + '</td>' +
            '<td class="table-actions">' + actionButtons + '</td>' +
        '</tr>';
    }).join('');
}

// 봉사 신청 상태 텍스트 변환
function getVolunteerStatusText(status) {
    const statusMap = {
        'APPLIED': '신청됨',
        'CONFIRMED': '승인됨',
        'COMPLETED': '완료됨',
        'CANCELLED': '취소됨',
        'REJECTED': '거절됨'
    };
    return statusMap[status] || status;
}

// 봉사 신청 상태 클래스 변환
function getVolunteerStatusClass(status) {
    const classMap = {
        'APPLIED': 'badge-warning',
        'CONFIRMED': 'badge-success',
        'COMPLETED': 'badge-info',
        'CANCELLED': 'badge-secondary',
        'REJECTED': 'badge-danger'
    };
    return classMap[status] || 'badge-secondary';
}

// 봉사 경력 변환
function formatVolunteerExperience(exp) {
    const expMap = {
        'NONE': '없음',
        'LT_1Y': '1년 미만',
        '1Y_3Y': '1-3년',
        'GT_3Y': '3년 이상'
    };
    return expMap[exp] || exp || '-';
}

// 필터링
function filterVolunteers() {
    const searchTerm = document.getElementById('volunteerSearch').value.toLowerCase().trim();
    const statusFilter = document.getElementById('volunteerStatusFilter').value;

    let filteredVolunteers = allVolunteersData.filter(vol => {
        const matchesSearch = !searchTerm ||
            (vol.applicantName && vol.applicantName.toLowerCase().includes(searchTerm)) ||
            (vol.applicantEmail && vol.applicantEmail.toLowerCase().includes(searchTerm)) ||
            (vol.applicantPhone && vol.applicantPhone.includes(searchTerm));

        const matchesStatus = !statusFilter || vol.status === statusFilter;

        return matchesSearch && matchesStatus;
    });

    renderVolunteerTable(filteredVolunteers);
}

// 시설 매칭 모달 열기
function openFacilityMatchModal(applicationId) {
    const volunteer = allVolunteersData.find(v => v.applicationId === applicationId);
    if (!volunteer) {
        alert('봉사 신청 정보를 찾을 수 없습니다.');
        return;
    }

    // 신청자 상세 정보 표시
    document.getElementById('matchApplicationId').value = applicationId;
    document.getElementById('matchApplicantName').textContent = volunteer.applicantName || '-';
    document.getElementById('matchApplicantPhone').textContent = volunteer.applicantPhone || '-';
    document.getElementById('matchApplicantEmail').textContent = volunteer.applicantEmail || '-';
    document.getElementById('matchApplicantAddress').textContent = volunteer.applicantAddress || '-';
    document.getElementById('matchCategory').textContent = volunteer.selectedCategory || '-';
    document.getElementById('matchSchedule').textContent = (volunteer.volunteerDate || '') + (volunteer.volunteerEndDate ? ' ~ ' + volunteer.volunteerEndDate : '') + ' ' + (volunteer.volunteerTime || '');
    document.getElementById('matchExperience').textContent = formatVolunteerExperience(volunteer.volunteerExperience) || '-';
    document.getElementById('matchMotivation').textContent = volunteer.motivation || '작성된 지원동기가 없습니다.';
    document.getElementById('matchCreatedAt').textContent = volunteer.createdAt || '-';

    // 신청자 주소 힌트 표시
    const applicantAddress = volunteer.applicantAddress || '주소 정보 없음';
    document.getElementById('applicantAddressHint').textContent = applicantAddress;

    // 입력 필드 초기화
    document.getElementById('selectedFacilityName').value = '';
    document.getElementById('selectedFacilityAddress').value = '';
    document.getElementById('selectedFacilityLat').value = '';
    document.getElementById('selectedFacilityLng').value = '';
    document.getElementById('adminNote').value = '';

    const modal = document.getElementById('facilityMatchModal');
    modal.classList.add('active');
    modal.style.display = 'flex';
}

// 시설 매칭 모달 닫기
function closeFacilityMatchModal() {
    const modal = document.getElementById('facilityMatchModal');
    modal.classList.remove('active');
    modal.style.display = 'none';
}

// Daum 주소 검색 팝업 열기
function openAddressSearch() {
    // Daum Postcode API 로딩 확인
    if (typeof daum === 'undefined' || typeof daum.Postcode === 'undefined') {
        alert('주소 검색 서비스를 불러오는 중입니다. 잠시 후 다시 시도해주세요.');
        console.error('Daum Postcode API가 로드되지 않았습니다.');
        return;
    }

    new daum.Postcode({
        oncomplete: function(data) {
            // 선택한 주소를 입력 필드에 설정
            const fullAddress = data.roadAddress || data.jibunAddress;
            document.getElementById('selectedFacilityAddress').value = fullAddress;

            // 상세 주소가 있으면 추가
            let extraAddress = '';
            if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                extraAddress += data.bname;
            }
            if (data.buildingName !== '' && data.apartment === 'Y') {
                extraAddress += (extraAddress !== '' ? ', ' + data.buildingName : data.buildingName);
            }
            if (extraAddress !== '') {
                document.getElementById('selectedFacilityAddress').value = fullAddress + ' (' + extraAddress + ')';
            }

            // 위도/경도는 선택사항이므로 비워둠 (필요시 Kakao Local API로 변환 가능)
            document.getElementById('selectedFacilityLat').value = '';
            document.getElementById('selectedFacilityLng').value = '';

            console.log('주소 선택 완료:', fullAddress);
        },
        onclose: function(state) {
            if (state === 'FORCE_CLOSE') {
                console.log('주소 검색 팝업이 강제로 닫혔습니다.');
            } else if (state === 'COMPLETE_CLOSE') {
                console.log('주소 검색 완료 후 닫힘');
            }
        },
        width: '100%',
        height: '100%',
        autoClose: true
    }).open();
}

// 봉사 활동 승인
function approveVolunteer() {
    const applicationId = document.getElementById('matchApplicationId').value;
    const facilityName = document.getElementById('selectedFacilityName').value.trim();
    const facilityAddress = document.getElementById('selectedFacilityAddress').value.trim();
    const facilityLat = document.getElementById('selectedFacilityLat').value;
    const facilityLng = document.getElementById('selectedFacilityLng').value;
    const adminNote = document.getElementById('adminNote').value;

    // 필수 입력 검증
    if (!facilityName) {
        alert('시설명을 입력해주세요.');
        document.getElementById('selectedFacilityName').focus();
        return;
    }

    if (!facilityAddress) {
        alert('시설 주소를 입력해주세요.');
        document.getElementById('selectedFacilityAddress').focus();
        return;
    }

    if (!confirm('이 봉사 신청을 승인하고 시설을 배정하시겠습니까?')) {
        return;
    }

    const params = new URLSearchParams();
    params.append('applicationId', applicationId);
    params.append('facilityName', facilityName);
    params.append('facilityAddress', facilityAddress);
    params.append('facilityLat', facilityLat || '');
    params.append('facilityLng', facilityLng || '');
    params.append('adminNote', adminNote || '');

    fetch('/bdproject/api/admin/volunteer/approve', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
    })
    .then(response => {
        if (!response.ok) {
            console.error('HTTP 오류:', response.status, response.statusText);
        }
        return response.json();
    })
    .then(result => {
        if (result.success) {
            alert('봉사 활동이 승인되고 시설이 배정되었습니다.');
            closeFacilityMatchModal();
            loadVolunteers();
        } else {
            alert('승인 실패: ' + (result.message || '알 수 없는 오류'));
            console.error('승인 실패 상세:', result);
        }
    })
    .catch(error => {
        console.error('승인 오류:', error);
        alert('승인 중 오류가 발생했습니다. 콘솔을 확인해주세요.');
    });
}

// 봉사 활동 거절
function rejectVolunteer(applicationId) {
    const reason = prompt('거절 사유를 입력하세요:');
    if (!reason) return;

    if (!confirm('이 봉사 신청을 거절하시겠습니까?')) {
        return;
    }

    const params = new URLSearchParams();
    params.append('applicationId', applicationId);
    params.append('reason', reason);

    fetch('/bdproject/api/admin/volunteer/reject', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert('봉사 신청이 거절되었습니다.');
            loadVolunteers();
        } else {
            alert('거절 실패: ' + (result.message || '알 수 없는 오류'));
        }
    })
    .catch(error => {
        console.error('거절 오류:', error);
        alert('거절 중 오류가 발생했습니다.');
    });
}

// 봉사 활동 상세보기
function viewVolunteerDetail(applicationId) {
    const volunteer = allVolunteersData.find(v => v.applicationId === applicationId);
    if (!volunteer) {
        alert('봉사 신청 정보를 찾을 수 없습니다.');
        return;
    }

    let message = '=== 봉사 신청 상세 정보 ===\n\n';
    message += '신청자: ' + volunteer.applicantName + '\n';
    message += '연락처: ' + volunteer.applicantPhone + '\n';
    message += '이메일: ' + (volunteer.applicantEmail || '-') + '\n';
    message += '분야: ' + volunteer.selectedCategory + '\n';
    message += '일정: ' + volunteer.volunteerDate + ' ' + (volunteer.volunteerTime || '') + '\n';
    message += '상태: ' + getVolunteerStatusText(volunteer.status) + '\n';

    if (volunteer.assignedFacilityName) {
        message += '\n=== 배정된 시설 ===\n';
        message += '시설명: ' + volunteer.assignedFacilityName + '\n';
        message += '주소: ' + (volunteer.assignedFacilityAddress || '-') + '\n';
    }

    if (volunteer.adminNote) {
        message += '\n관리자 메모: ' + volunteer.adminNote + '\n';
    }

    alert(message);
}

// 로그아웃 함수
function logout() {
    if (confirm('로그아웃 하시겠습니까?')) {
        window.location.href = '/bdproject/login/logout';
    }
}
