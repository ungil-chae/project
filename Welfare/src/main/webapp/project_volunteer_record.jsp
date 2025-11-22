<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>봉사 후기 - 복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: linear-gradient(135deg, #e3f2fd 0%, #f8f9fa 100%);
            color: #333;
            min-height: 100vh;
        }

        .main-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 80px 20px 60px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 60px;
        }

        .page-title {
            font-size: 42px;
            font-weight: 700;
            color: #333;
            margin-bottom: 20px;
        }

        .page-subtitle {
            font-size: 17px;
            color: #666;
            line-height: 1.6;
        }

        .cta-section {
            background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
            border-radius: 24px;
            padding: 60px 40px;
            text-align: center;
            color: white;
            margin-bottom: 70px;
            box-shadow: 0 10px 40px rgba(74, 144, 226, 0.3);
            transition: transform 0.3s ease;
        }

        .cta-section:hover {
            transform: translateY(-5px);
        }

        .cta-title {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .cta-text {
            font-size: 17px;
            margin-bottom: 35px;
            opacity: 0.95;
            line-height: 1.6;
        }

        .cta-button {
            display: inline-block;
            padding: 18px 50px;
            background: white;
            color: #4a90e2;
            border-radius: 30px;
            font-size: 17px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .cta-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }

        .stories-container {
            display: flex;
            flex-direction: column;
            gap: 50px;
            margin-bottom: 70px;
        }

        .story-wrapper {
            display: flex;
            align-items: flex-start;
            gap: 20px;
            animation: fadeInUp 0.6s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .story-wrapper.left {
            flex-direction: row;
        }

        .story-wrapper.right {
            flex-direction: row-reverse;
            margin-left: auto;
        }

        .profile-icon {
            width: 70px;
            height: 70px;
            min-width: 70px;
            border-radius: 50%;
            background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: white;
            box-shadow: 0 5px 15px rgba(74, 144, 226, 0.4);
        }

        .story-card {
            background: white;
            border-radius: 24px;
            padding: 35px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.1);
            position: relative;
            max-width: 700px;
            transition: all 0.3s ease;
        }

        .story-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 35px rgba(0, 0, 0, 0.15);
        }

        .story-wrapper.left .story-card::before {
            content: '';
            position: absolute;
            left: -12px;
            top: 25px;
            width: 0;
            height: 0;
            border-top: 12px solid transparent;
            border-bottom: 12px solid transparent;
            border-right: 12px solid white;
        }

        .story-wrapper.right .story-card::before {
            content: '';
            position: absolute;
            right: -12px;
            top: 25px;
            width: 0;
            height: 0;
            border-top: 12px solid transparent;
            border-bottom: 12px solid transparent;
            border-left: 12px solid white;
        }

        .story-header {
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .story-author {
            font-size: 20px;
            font-weight: 700;
            color: #333;
            margin-bottom: 8px;
        }

        .story-date {
            font-size: 14px;
            color: #999;
            margin-bottom: 12px;
        }

        .activity-badge {
            display: inline-block;
            padding: 8px 16px;
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            color: #1976d2;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        .experience-badge {
            display: inline-block;
            padding: 8px 16px;
            background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
            color: #f57c00;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            margin-top: 8px;
        }

        .story-content {
            margin-bottom: 20px;
        }

        .story-title {
            font-size: 22px;
            font-weight: 700;
            color: #333;
            margin-bottom: 18px;
            line-height: 1.4;
        }

        .story-text {
            font-size: 15px;
            line-height: 1.9;
            color: #555;
            margin-bottom: 20px;
        }

        .story-footer {
            display: flex;
            align-items: center;
            gap: 25px;
            padding-top: 20px;
            border-top: 1px solid #f0f0f0;
        }

        .story-stat {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: #999;
        }

        .story-stat i {
            color: #ffc107;
            font-size: 16px;
        }

        .loading-message, .empty-message {
            text-align: center;
            padding: 100px 20px;
            color: #666;
        }

        .loading-message i, .empty-message i {
            font-size: 56px;
            color: #4A90E2;
            margin-bottom: 25px;
            display: block;
        }

        .empty-message i {
            font-size: 72px;
            color: #ccc;
        }

        .empty-message p {
            font-size: 18px;
            margin-bottom: 10px;
        }

        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin: 70px 0 50px 0;
        }

        .pagination-btn {
            min-width: 48px;
            height: 48px;
            padding: 0 18px;
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            color: #666;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .pagination-btn:hover:not(:disabled) {
            background: #f5f5f5;
            border-color: #4A90E2;
            color: #4A90E2;
            transform: translateY(-2px);
        }

        .pagination-btn.active {
            background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%);
            border-color: #4A90E2;
            color: white;
            box-shadow: 0 5px 15px rgba(74, 144, 226, 0.4);
        }

        .pagination-btn:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .fa-spin {
            animation: spin 1s linear infinite;
        }

        @media (max-width: 768px) {
            .main-container {
                padding: 60px 15px 40px;
            }

            .page-title {
                font-size: 32px;
            }

            .cta-section {
                padding: 40px 25px;
            }

            .story-wrapper.right {
                margin-left: 0;
            }

            .profile-icon {
                width: 50px;
                height: 50px;
                min-width: 50px;
                font-size: 20px;
            }

            .story-card {
                padding: 25px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="main-container">
        <div class="page-header">
            <h1 class="page-title">봉사자들의 따뜻한 이야기</h1>
            <p class="page-subtitle">
                복지24와 함께한 봉사활동 후기와 감동의 순간들을 공유합니다.<br>
                함께 나누는 작은 실천이 세상을 변화시킵니다.
            </p>
        </div>

        <div class="cta-section">
            <h2 class="cta-title">당신의 이야기를 들려주세요</h2>
            <p class="cta-text">
                복지24와 함께한 따뜻한 봉사 활동 경험을 공유하면,<br>
                더 많은 사람들에게 봉사의 기쁨을 전할 수 있습니다.
            </p>
            <a href="/bdproject/project_volunteer.jsp" class="cta-button">
                <i class="fas fa-hands-helping" style="margin-right: 8px;"></i>
                봉사 신청하기
            </a>
        </div>

        <div class="stories-container" id="storiesContainer">
            <div class="loading-message">
                <i class="fas fa-spinner fa-spin"></i>
                <p>후기를 불러오는 중입니다...</p>
            </div>
        </div>

        <div class="pagination-container" id="paginationContainer" style="display: none;"></div>
    </div>

    <jsp:include page="footer.jsp" />

    <script>
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
                                <span>만족도 \${review.rating}/5</span>
                            </div>
                            <div class="story-stat">
                                <i class="fas fa-heart" style="color: #e91e63;"></i>
                                <span>감사합니다</span>
                            </div>
                        </div>
                    ` : '';

                    return `
                        <div class="story-wrapper \${alignment}">
                            <div class="profile-icon">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="story-card">
                                <div class="story-header">
                                    <div class="story-author">\${escapeHtml(review.userName || '익명')}님의 이야기</div>
                                    <div class="story-date">\${formattedDate}</div>
                                    <div class="activity-badge">
                                        <i class="fas fa-hands-helping" style="margin-right: 5px;"></i>
                                        \${escapeHtml(review.activityName || '봉사 활동')}
                                    </div>
                                    \${review.volunteerExperience ? `<div class="experience-badge">
                                        <i class="fas fa-award" style="margin-right: 5px;"></i>
                                        경력: \${escapeHtml(review.volunteerExperience)}
                                    </div>` : ''}
                                </div>
                                <div class="story-content">
                                    <h3 class="story-title">\${escapeHtml(review.title)}</h3>
                                    <p class="story-text">\${escapedContent}</p>
                                    \${ratingHtml}
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
                    paginationHtml += `<button class="pagination-btn" onclick="changePage(\${currentPage - 1})">
                        <i class="fas fa-chevron-left"></i>
                    </button>`;
                } else {
                    paginationHtml += `<button class="pagination-btn" disabled>
                        <i class="fas fa-chevron-left"></i>
                    </button>`;
                }

                for (let i = 1; i <= totalPages; i++) {
                    const activeClass = i === currentPage ? 'active' : '';
                    paginationHtml += `<button class="pagination-btn \${activeClass}" onclick="changePage(\${i})">\${i}</button>`;
                }

                if (currentPage < totalPages) {
                    paginationHtml += `<button class="pagination-btn" onclick="changePage(\${currentPage + 1})">
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
    </script>
</body>
</html>
