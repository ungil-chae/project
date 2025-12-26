// DB에서 로드할 리뷰 데이터 (초기값은 빈 배열)
let sampleReviews = [];

// 페이지 로드 시 통계 및 리뷰 데이터 로드
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOMContentLoaded 이벤트 발생 - 초기화 시작');
    loadStatistics();
    loadReviews();

    // 이벤트 리스너 등록 (DOMContentLoaded 내부로 이동)
    document.getElementById('categoryFilter').addEventListener('change', applyFilters);
    document.getElementById('sortFilter').addEventListener('change', applyFilters);
    document.getElementById('searchInput').addEventListener('input', applyFilters);

    // 초기 렌더링 (DOMContentLoaded 내부로 이동)
    renderReviews();

    console.log('초기화 완료');
});

// 통계 데이터 로드 (project_fundUsage.jsp와 동일한 API 사용)
function loadStatistics() {
    fetch('/bdproject/api/donation/statistics')
        .then(response => response.json())
        .then(data => {
            if (data.success && data.data) {
                const stats = data.data;

                // 총 모금액 포맷팅 (억/만 단위)
                const totalAmount = stats.totalAmount || 0;
                let amountText = '';
                if (totalAmount >= 100000000) {
                    const eok = Math.floor(totalAmount / 100000000);
                    const man = Math.floor((totalAmount % 100000000) / 10000);
                    if (man > 0) {
                        amountText = eok + '.' + Math.floor(man / 1000) + '억원';
                    } else {
                        amountText = eok + '억원';
                    }
                } else if (totalAmount >= 10000) {
                    amountText = Math.floor(totalAmount / 10000) + '만원';
                } else {
                    amountText = totalAmount.toLocaleString() + '원';
                }

                // 통계 값 업데이트
                updateStatValue('donors', stats.donorCount || 0);
                updateStatValue('reviews', stats.reviewCount || 0);
                updateStatValue('rating', (stats.averageRating || 0).toFixed(1));
                updateStatValue('amount', amountText);

                console.log('후원자 리뷰 통계 로드 완료:', stats);
            }
        })
        .catch(error => {
            console.error('통계 데이터 로드 실패:', error);
            // 에러 발생 시 0으로 표시
            updateStatValue('donors', 0);
            updateStatValue('reviews', 0);
            updateStatValue('rating', '0.0');
            updateStatValue('amount', '0원');
        });
}

// 통계 값 업데이트 헬퍼 함수
function updateStatValue(key, value) {
    // 여러 방법으로 요소 찾기 시도
    let element = document.querySelector(`.stat-value[data-stat="${key}"]`);

    if (!element) {
        // 방법 2: 모든 stat-value 요소를 순회
        const allStatValues = document.querySelectorAll('.stat-value');
        console.log('모든 stat-value 요소 개수:', allStatValues.length);

        for (let el of allStatValues) {
            console.log('요소 확인:', el, 'data-stat:', el.getAttribute('data-stat'));
            if (el.getAttribute('data-stat') === key) {
                element = el;
                break;
            }
        }
    }

    console.log('updateStatValue 호출:', key, value, 'element:', element);

    if (element) {
        const displayValue = typeof value === 'number' ? value.toLocaleString() : value;
        element.textContent = displayValue;
        console.log('✓ 업데이트 완료:', key, '=', displayValue);
    } else {
        console.error('✗ 요소를 찾을 수 없음:', key);
        console.log('HTML 구조 확인:', document.querySelector('.stats-container'));
    }
}

// 리뷰 목록 로드
function loadReviews() {
    fetch('/bdproject/api/donation-review/list')
        .then(response => response.json())
        .then(data => {
            if (data.success && data.data.length > 0) {
                // API 응답 데이터를 sampleReviews 형식으로 변환
                sampleReviews = data.data.map(review => ({
                    id: review.reviewId,
                    name: review.reviewerName,
                    initial: review.reviewerName.charAt(0),
                    date: typeof review.createdAt === 'string' ? review.createdAt.split('T')[0] : new Date(review.createdAt).toISOString().split('T')[0],
                    category: review.category || '일반',
                    rating: review.rating,
                    amount: review.donationAmount || 0,
                    type: review.donationType || 'onetime',
                    isAnonymous: review.isAnonymous || false,
                    content: review.content,
                    helpful: review.helpfulCount || 0
                }));
                filteredReviews = [...sampleReviews];
                renderReviews();
            } else {
                // 데이터가 없으면 샘플 데이터 사용
                useSampleReviews();
            }
        })
        .catch(error => {
            console.error('리뷰 목록 로드 실패:', error);
            // 에러 발생 시 샘플 데이터 사용
            useSampleReviews();
        });
}

// 샘플 통계 데이터 사용 함수는 제거됨 (더 이상 사용하지 않음)

// 샘플 리뷰 데이터 사용 (API 연동 전 또는 에러 시)
function useSampleReviews() {
    sampleReviews = [
    {
        id: 1,
        name: "김민수",
        initial: "김",
        date: "2025-01-15",
        category: "위기가정",
        rating: 5,
        amount: 100000,
        type: "regular",
        isAnonymous: false,
        content: "매달 정기 기부를 하고 있습니다. 복지24를 통해 기부금이 어려운 가정에 투명하게 전달되는 것을 확인할 수 있어서 믿음이 갑니다. 작은 나눔이 큰 변화가 되길 바랍니다.",
        helpful: 42
    },
    {
        id: 2,
        name: "익명",
        initial: "익",
        date: "2025-01-14",
        category: "의료비",
        rating: 5,
        amount: 50000,
        type: "onetime",
        isAnonymous: true,
        content: "의료비 지원 분야에 기부했습니다. 아픈 분들이 경제적 걱정 없이 치료에만 집중할 수 있으면 좋겠어요. 복지24의 투명한 기부금 사용 내역 공개가 인상적입니다.",
        helpful: 35
    },
    {
        id: 3,
        name: "박철수",
        initial: "박",
        date: "2025-01-13",
        category: "화재피해",
        rating: 5,
        amount: 200000,
        type: "onetime",
        isAnonymous: false,
        content: "화재 피해 가정 지원에 기부했습니다. 뉴스에서 화재 소식을 볼 때마다 마음이 아팠는데, 조금이나마 도움이 될 수 있어서 기쁩니다. 복지24 덕분에 쉽게 기부할 수 있었어요.",
        helpful: 58
    },
    {
        id: 4,
        name: "익명",
        initial: "익",
        date: "2025-01-12",
        category: "한부모",
        rating: 4,
        amount: 30000,
        type: "regular",
        isAnonymous: true,
        content: "한부모 가정을 위해 매달 소액이지만 꾸준히 기부하고 있습니다. 홀로 아이를 키우시는 분들께 조금이나마 힘이 되었으면 합니다. 기부 후기 페이지에서 감사 인사를 보면 보람을 느껴요.",
        helpful: 28
    },
    {
        id: 5,
        name: "정현우",
        initial: "정",
        date: "2025-01-11",
        category: "자연재해",
        rating: 5,
        amount: 150000,
        type: "onetime",
        isAnonymous: false,
        content: "태풍 피해 복구 지원에 기부했습니다. 재난 상황에서 빠른 지원이 중요하다고 생각해서 망설임 없이 기부했어요. 복지24의 긴급 모금 시스템이 잘 되어있어서 신뢰가 갑니다.",
        helpful: 45
    },
    {
        id: 6,
        name: "강서연",
        initial: "강",
        date: "2025-01-10",
        category: "노숙인",
        rating: 5,
        amount: 20000,
        type: "regular",
        isAnonymous: false,
        content: "노숙인 분들을 위해 매달 기부하고 있어요. 길에서 힘들게 지내시는 분들이 따뜻한 곳에서 쉴 수 있으면 좋겠습니다. 작은 금액이지만 꾸준히 이어가겠습니다.",
        helpful: 31
    },
    {
        id: 7,
        name: "익명",
        initial: "익",
        date: "2025-01-09",
        category: "가정폭력",
        rating: 5,
        amount: 80000,
        type: "onetime",
        isAnonymous: true,
        content: "가정폭력 피해자 보호시설 지원에 기부했습니다. 피해자분들이 안전하게 새 출발을 할 수 있도록 도움이 되고 싶었어요. 복지24를 통해 의미있는 나눔을 할 수 있어 감사합니다.",
        helpful: 52
    },
    {
        id: 8,
        name: "이수진",
        initial: "이",
        date: "2025-01-08",
        category: "자살고위험",
        rating: 4,
        amount: 40000,
        type: "regular",
        isAnonymous: false,
        content: "마음이 힘든 분들을 위한 심리상담 지원에 정기 기부 중입니다. 누구나 힘든 시기가 있잖아요. 전문 상담을 통해 다시 일어설 수 있도록 응원하고 싶습니다.",
        helpful: 38
    },
    {
        id: 9,
        name: "익명",
        initial: "익",
        date: "2025-01-07",
        category: "범죄피해",
        rating: 5,
        amount: 120000,
        type: "onetime",
        isAnonymous: true,
        content: "범죄 피해자 지원 프로그램에 기부했습니다. 피해자분들의 심리 치료와 생활 안정에 조금이나마 보탬이 되길 바랍니다. 복지24의 체계적인 지원 시스템에 신뢰가 갑니다.",
        helpful: 47
    }
];
    filteredReviews = [...sampleReviews];
    renderReviews();
}

let currentPage = 1;
const itemsPerPage = 6;
let filteredReviews = [];

// 리뷰 렌더링
function renderReviews() {
    const grid = document.getElementById('reviewsGrid');
    const startIdx = (currentPage - 1) * itemsPerPage;
    const endIdx = startIdx + itemsPerPage;
    const pageReviews = filteredReviews.slice(startIdx, endIdx);

    if (pageReviews.length === 0) {
        grid.innerHTML = '<div class="empty-state" style="grid-column: 1 / -1;">' +
            '<div class="empty-icon">' +
                '<i class="fas fa-inbox"></i>' +
            '</div>' +
            '<p class="empty-text">검색 결과가 없습니다.</p>' +
        '</div>';
        return;
    }

    const likedReviews = getLikedReviews();

    grid.innerHTML = pageReviews.map(review => {
        const stars = Array(5).fill(0).map((_, i) =>
            '<i class="fas fa-star ' + (i < review.rating ? '' : 'empty') + '"></i>'
        ).join('');

        const donationType = review.type === 'regular' ? '정기기부' : '일시기부';
        const displayName = review.isAnonymous ? '익명 후원자' : review.name;
        const avatarClass = review.isAnonymous ? 'reviewer-avatar anonymous' : 'reviewer-avatar';

        // 좋아요 버튼 활성화 상태 확인
        const isLiked = likedReviews.includes(review.id);
        const btnClass = isLiked ? 'helpful-btn active' : 'helpful-btn';

        return '<div class="review-card">' +
            '<div class="review-header">' +
                '<div class="reviewer-info">' +
                    '<div class="' + avatarClass + '">' + review.initial + '</div>' +
                    '<div class="reviewer-details">' +
                        '<div class="reviewer-name">' + displayName + '</div>' +
                        '<div class="review-date">' + review.date + '</div>' +
                    '</div>' +
                '</div>' +
                '<span class="donation-badge ' + review.type + '">' +
                    donationType +
                '</span>' +
            '</div>' +
            '<div class="review-rating">' + stars + '</div>' +
            '<div class="review-category">' +
                '<i class="fas fa-tag"></i> ' + review.category +
            '</div>' +
            '<div class="review-content">' + review.content + '</div>' +
            '<div class="review-footer">' +
                '<button class="' + btnClass + '" onclick="toggleHelpful(' + review.id + ')">' +
                    '<i class="fas fa-thumbs-up"></i>' +
                    '<span>' + review.helpful + '</span>' +
                '</button>' +
            '</div>' +
        '</div>';
    }).join('');

    renderPagination();
}

// 페이지네이션 렌더링
function renderPagination() {
    const pagination = document.getElementById('pagination');
    const totalPages = Math.ceil(filteredReviews.length / itemsPerPage);

    let html = '<button class="page-btn" onclick="changePage(' + (currentPage - 1) + ')"' +
        (currentPage === 1 ? ' disabled' : '') + '>' +
        '<i class="fas fa-chevron-left"></i>' +
        '</button>';

    for (let i = 1; i <= totalPages; i++) {
        html += '<button class="page-btn' + (i === currentPage ? ' active' : '') + '"' +
            ' onclick="changePage(' + i + ')">' + i + '</button>';
    }

    html += '<button class="page-btn" onclick="changePage(' + (currentPage + 1) + ')"' +
        (currentPage === totalPages ? ' disabled' : '') + '>' +
        '<i class="fas fa-chevron-right"></i>' +
        '</button>';

    pagination.innerHTML = html;
}

// 페이지 변경
function changePage(page) {
    const totalPages = Math.ceil(filteredReviews.length / itemsPerPage);
    if (page < 1 || page > totalPages) return;
    currentPage = page;
    renderReviews();
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// 필터링
function applyFilters() {
    const category = document.getElementById('categoryFilter').value;
    const sort = document.getElementById('sortFilter').value;
    const search = document.getElementById('searchInput').value.toLowerCase();

    filteredReviews = sampleReviews.filter(review => {
        const matchCategory = !category || review.category === category;
        const matchSearch = !search ||
            review.content.toLowerCase().includes(search) ||
            review.name.toLowerCase().includes(search) ||
            review.category.toLowerCase().includes(search);
        return matchCategory && matchSearch;
    });

    // 정렬
    switch(sort) {
        case 'rating':
            filteredReviews.sort((a, b) => b.rating - a.rating);
            break;
        case 'amount':
            filteredReviews.sort((a, b) => b.amount - a.amount);
            break;
        case 'helpful':
            filteredReviews.sort((a, b) => b.helpful - a.helpful);
            break;
        default: // latest
            filteredReviews.sort((a, b) => new Date(b.date) - new Date(a.date));
    }

    currentPage = 1;
    renderReviews();
}

// 좋아요 누른 리뷰 ID 가져오기 (localStorage 사용)
function getLikedReviews() {
    const liked = localStorage.getItem('likedReviews');
    return liked ? JSON.parse(liked) : [];
}

// 좋아요 누른 리뷰 ID 저장
function saveLikedReviews(likedReviews) {
    localStorage.setItem('likedReviews', JSON.stringify(likedReviews));
}

// 로그인 상태 변수
let isUserLoggedIn = false;

// 로그인 상태 확인
function checkLoginForLike() {
    return fetch('/bdproject/api/auth/check')
        .then(response => response.json())
        .then(data => {
            isUserLoggedIn = data.loggedIn;
            return data.loggedIn;
        })
        .catch(error => {
            console.error('로그인 상태 확인 실패:', error);
            isUserLoggedIn = false;
            return false;
        });
}

// 페이지 로드 시 로그인 상태 확인
checkLoginForLike();

// 좋아요 토글 (추가/취소) - DB 저장 및 로그인 체크
function toggleHelpful(reviewId) {
    // 로그인 상태 확인
    fetch('/bdproject/api/auth/check')
        .then(response => response.json())
        .then(data => {
            if (!data.loggedIn) {
                // 로그인하지 않은 경우
                if (confirm('로그인이 필요합니다.\n로그인 페이지로 이동하시겠습니까?')) {
                    window.location.href = '/bdproject/projectLogin.jsp';
                }
                return;
            }

            // 로그인한 경우 좋아요 처리
            const review = sampleReviews.find(r => r.id === reviewId);
            if (!review) return;

            const likedReviews = getLikedReviews();
            const isLiked = likedReviews.includes(reviewId);
            const action = isLiked ? 'unlike' : 'like';

            // 서버 API 호출하여 DB에 저장
            fetch('/bdproject/api/donation-review/helpful', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'reviewId=' + reviewId + '&action=' + action
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    // DB 업데이트 성공 시 로컬 데이터도 업데이트
                    review.helpful = result.helpfulCount;

                    if (isLiked) {
                        // 좋아요 취소
                        const index = likedReviews.indexOf(reviewId);
                        likedReviews.splice(index, 1);
                    } else {
                        // 좋아요 추가
                        likedReviews.push(reviewId);
                    }

                    saveLikedReviews(likedReviews);
                    renderReviews();
                } else {
                    alert(result.message || '좋아요 처리에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('좋아요 처리 실패:', error);
                alert('좋아요 처리 중 오류가 발생했습니다.');
            });
        })
        .catch(error => {
            console.error('로그인 상태 확인 실패:', error);
            alert('오류가 발생했습니다. 다시 시도해주세요.');
        });
}

// 리뷰 작성
function writeReview() {
    alert('리뷰 작성 기능은 준비 중입니다.\n후원 완료 후 리뷰를 남길 수 있습니다.');
    // 실제로는 리뷰 작성 모달이나 페이지로 이동
    // window.location.href = '/bdproject/project_Donation.jsp';
}

// 네비바 드롭다운 메뉴
const header = document.getElementById('main-header');
const navLinks = document.querySelectorAll('.nav-link[data-menu]');
const megaMenuWrapper = document.getElementById('mega-menu-wrapper');
const menuColumns = document.querySelectorAll('.menu-column');
let menuTimeout;

const showMenu = (targetMenu) => {
    clearTimeout(menuTimeout);
    megaMenuWrapper.classList.add('active');

    menuColumns.forEach((col) => {
        if (col.dataset.menuContent === targetMenu) {
            col.style.display = 'flex';
        } else {
            col.style.display = 'none';
        }
    });

    navLinks.forEach((link) => {
        if (link.dataset.menu === targetMenu) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });
};

const hideMenu = () => {
    menuTimeout = setTimeout(() => {
        megaMenuWrapper.classList.remove('active');
        navLinks.forEach((link) => link.classList.remove('active'));
    }, 200);
};

navLinks.forEach((link) => {
    link.addEventListener('mouseenter', () => {
        showMenu(link.dataset.menu);
    });
});

header.addEventListener('mouseleave', () => {
    hideMenu();
});

// 언어 선택 드롭다운
const languageToggle = document.getElementById('languageToggle');
const languageDropdown = document.getElementById('languageDropdown');

if (languageToggle && languageDropdown) {
    languageToggle.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        languageDropdown.classList.toggle('active');
    });

    // 언어 옵션 클릭 이벤트
    const languageOptions = languageDropdown.querySelectorAll('.language-option');
    languageOptions.forEach((option) => {
        option.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            const selectedLanguage = option.getAttribute('data-lang');

            // 활성 언어 표시 업데이트
            languageOptions.forEach((opt) => {
                opt.classList.remove('active');
            });
            option.classList.add('active');

            // 드롭다운 닫기
            languageDropdown.classList.remove('active');

            // 여기에 언어 변경 로직 추가 가능
            console.log('선택된 언어:', selectedLanguage);
        });
    });

    // 다른 곳 클릭 시 드롭다운 닫기
    document.addEventListener('click', (e) => {
        if (!languageToggle.contains(e.target) && !languageDropdown.contains(e.target)) {
            languageDropdown.classList.remove('active');
        }
    });

    // 초기 활성 언어 표시 (한국어)
    const koOption = languageDropdown.querySelector('[data-lang="ko"]');
    if (koOption) koOption.classList.add('active');
}

// 사용자 아이콘 클릭 이벤트 (로그인 페이지로 이동)
const userIcon = document.getElementById('userIcon');
if (userIcon) {
    userIcon.addEventListener('click', function(e) {
        e.preventDefault();
        window.location.href = '/bdproject/projectLogin.jsp';
    });
}
