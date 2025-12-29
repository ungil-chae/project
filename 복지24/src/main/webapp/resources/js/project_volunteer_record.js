document.addEventListener('DOMContentLoaded', function() {
    let allReviews = [];
    let currentPage = 1;
    const reviewsPerPage = 7;

    loadVolunteerReviews();

    function loadVolunteerReviews() {
        console.log('봉사 후기 로드 시작...');
        fetch('/bdproject/api/volunteer/review/list')
            .then(response => {
                console.log('응답 상태:', response.status);
                if (!response.ok) {
                    throw new Error('네트워크 응답이 올바르지 않습니다');
                }
                return response.json();
            })
            .then(data => {
                console.log('받은 데이터:', data);
                console.log('data.success:', data.success);
                console.log('data.data:', data.data);
                console.log('data.data 타입:', typeof data.data);
                console.log('data.data.length:', data.data ? data.data.length : 'null');

                if (data.success && data.data && data.data.length > 0) {
                    console.log('후기 개수:', data.data.length);
                    allReviews = data.data;
                    displayReviewsWithPagination(1);
                } else {
                    console.log('후기가 없거나 성공하지 못함');
                    console.log('실패 이유 - success:', data.success, ', data 길이:', data.data ? data.data.length : 0);
                    showEmptyMessage();
                }
            })
            .catch(error => {
                console.error('봉사 후기 로드 실패:', error);
                showErrorMessage();
            });
    }

    function displayReviewsWithPagination(page) {
        currentPage = page;
        const startIndex = (page - 1) * reviewsPerPage;
        const endIndex = startIndex + reviewsPerPage;
        const reviewsToDisplay = allReviews.slice(startIndex, endIndex);

        displayReviews(reviewsToDisplay, startIndex);
        createPagination();
    }

    function displayReviews(reviews, startIndex) {
        const container = document.getElementById('storiesContainer');

        if (reviews.length === 0) {
            showEmptyMessage();
            return;
        }

        container.innerHTML = reviews.map((review, index) => {
            const actualIndex = startIndex + index;
            const isLeft = actualIndex % 2 === 0;
            const alignment = isLeft ? 'left' : 'right';

            const createdDate = new Date(review.createdAt);
            const formattedDate = createdDate.toLocaleDateString('ko-KR', {
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });

            const escapedContent = escapeHtml(review.content || '').replace(/\n/g, '<br>');

            const ratingHtml = review.rating ? `
                <div class="story-footer">
                    <div class="story-stat">
                        <i class="fas fa-star"></i>
                        <span>만족도 ${review.rating}/5</span>
                    </div>
                    <div class="story-stat">
                        <i class="fas fa-heart" style="color: #e91e63;"></i>
                        <span>감사합니다</span>
                    </div>
                </div>
            ` : '';

            return `
                <div class="story-wrapper ${alignment}">
                    <div class="profile-icon">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="story-card">
                        <div class="story-header">
                            <div class="story-author">${escapeHtml(review.userName || '익명')}님의 이야기</div>
                            <div class="story-date">${formattedDate}</div>
                            <div class="activity-badge">
                                <i class="fas fa-hands-helping" style="margin-right: 5px;"></i>
                                ${escapeHtml(review.activityName || '봉사 활동')}
                            </div>
                            ${review.volunteerExperience ? `<div class="experience-badge">
                                <i class="fas fa-award" style="margin-right: 5px;"></i>
                                경력: ${escapeHtml(review.volunteerExperience)}
                            </div>` : ''}
                        </div>
                        <div class="story-content">
                            <h3 class="story-title">${escapeHtml(review.title)}</h3>
                            <p class="story-text">${escapedContent}</p>
                            ${ratingHtml}
                        </div>
                    </div>
                </div>
            `;
        }).join('');
    }

    function createPagination() {
        const totalPages = Math.ceil(allReviews.length / reviewsPerPage);
        const paginationContainer = document.getElementById('paginationContainer');

        if (totalPages <= 1) {
            paginationContainer.style.display = 'none';
            return;
        }

        paginationContainer.style.display = 'flex';

        let paginationHtml = '';

        if (currentPage > 1) {
            paginationHtml += `<button class="pagination-btn" onclick="changePage(${currentPage - 1})">
                <i class="fas fa-chevron-left"></i>
            </button>`;
        } else {
            paginationHtml += `<button class="pagination-btn" disabled>
                <i class="fas fa-chevron-left"></i>
            </button>`;
        }

        for (let i = 1; i <= totalPages; i++) {
            const activeClass = i === currentPage ? 'active' : '';
            paginationHtml += `<button class="pagination-btn ${activeClass}" onclick="changePage(${i})">${i}</button>`;
        }

        if (currentPage < totalPages) {
            paginationHtml += `<button class="pagination-btn" onclick="changePage(${currentPage + 1})">
                <i class="fas fa-chevron-right"></i>
            </button>`;
        } else {
            paginationHtml += `<button class="pagination-btn" disabled>
                <i class="fas fa-chevron-right"></i>
            </button>`;
        }

        paginationContainer.innerHTML = paginationHtml;
    }

    function showEmptyMessage() {
        const container = document.getElementById('storiesContainer');
        container.innerHTML = `
            <div class="empty-message">
                <i class="fas fa-comments"></i>
                <p>아직 작성된 후기가 없습니다.</p>
                <p style="font-size: 15px; margin-top: 15px; color: #999;">
                    마이페이지에서 봉사 활동 후기를 작성해보세요!
                </p>
            </div>
        `;
        document.getElementById('paginationContainer').style.display = 'none';
    }

    function showErrorMessage() {
        const container = document.getElementById('storiesContainer');
        container.innerHTML = `
            <div class="empty-message">
                <i class="fas fa-exclamation-triangle"></i>
                <p>후기를 불러오는 중 오류가 발생했습니다.</p>
                <p style="font-size: 15px; margin-top: 15px; color: #999;">
                    잠시 후 다시 시도해주세요.
                </p>
            </div>
        `;
        document.getElementById('paginationContainer').style.display = 'none';
    }

    window.changePage = function(page) {
        displayReviewsWithPagination(page);
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    };

    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
});
