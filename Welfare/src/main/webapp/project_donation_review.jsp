<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>후원자 리뷰 - 복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f8f9fa;
            color: #333;
        }

        /* 헤더 스타일 */
        #main-header {
            position: sticky;
            top: 0;
            z-index: 1000;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .navbar {
            background-color: transparent;
            padding: 0 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 60px;
        }

        .navbar-left { flex-shrink: 0; }

        .nav-menu {
            display: flex;
            gap: 50px;
            align-items: center;
            justify-content: center;
            flex-grow: 1;
        }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .navbar-icon {
            width: 22px;
            height: 22px;
            cursor: pointer;
            color: #333;
        }

        .nav-item {
            height: 100%;
            display: flex;
            align-items: center;
        }

        .nav-link {
            color: #333;
            text-decoration: none;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.2s ease;
            padding: 18px 15px;
            border-radius: 8px;
        }

        .nav-link:hover,
        .nav-link.active {
            background-color: #f5f5f5;
            color: #333;
        }

        /* 메가 메뉴 */
        #mega-menu-wrapper {
            position: absolute;
            width: 100%;
            background-color: white;
            color: #333;
            left: 0;
            top: 60px;
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.4s ease-in-out, padding 0.4s ease-in-out, border-top 0.4s ease-in-out;
            border-top: 1px solid transparent;
            box-shadow: 0 8px 16px rgba(0,0,0,0.05);
        }

        #mega-menu-wrapper.active {
            max-height: 500px;
            padding: 30px 0 40px 0;
            border-top: 1px solid #e0e0e0;
        }

        .mega-menu-content {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 40px;
            display: flex;
            justify-content: flex-start;
            gap: 60px;
        }

        .menu-column {
            display: none;
            flex-direction: column;
            gap: 25px;
        }

        .menu-column.active {
            display: flex;
        }

        .dropdown-link {
            color: #333;
            text-decoration: none;
            display: block;
        }

        .dropdown-link-title {
            font-weight: 700;
            font-size: 15px;
            display: inline-block;
            position: relative;
            padding-bottom: 5px;
            color: #000000;
        }

        .dropdown-link-title::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background-color: #000000;
            transition: width 0.3s ease;
        }

        .dropdown-link:hover .dropdown-link-title::after {
            width: 100%;
        }

        .dropdown-link-desc {
            font-size: 13px;
            color: #555;
            margin-top: 6px;
            display: block;
        }

        /* 언어 선택 드롭다운 */
        .language-selector {
            position: relative;
            display: inline-block;
        }

        .language-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 8px 0;
            min-width: 160px;
            max-height: 300px;
            overflow-y: auto;
            z-index: 9999;
            margin-top: 5px;
            display: none;
        }

        .language-dropdown.active {
            display: block;
        }

        .language-option {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            padding: 12px 16px;
            cursor: pointer;
            transition: background-color 0.2s ease;
            border-bottom: 1px solid #f0f0f0;
        }

        .language-option:last-child {
            border-bottom: none;
        }

        .language-option:hover {
            background-color: #f5f5f5;
        }

        .language-option.active {
            background-color: #e3f2fd;
        }

        .country-name {
            font-weight: 600;
            color: #333;
            font-size: 14px;
            margin-bottom: 2px;
        }

        .language-name {
            font-size: 12px;
            color: #666;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            color: #333;
            width: fit-content;
            transition: opacity 0.2s ease;
        }

        .logo:hover { opacity: 0.7; }

        .logo-icon {
            width: 40px;
            height: 40px;
            background-image: url('resources/image/복지로고.png');
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
        }

        .logo-text {
            font-size: 24px;
            font-weight: 700;
            color: #333;
        }

        /* 메인 컨텐츠 */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 60px 20px;
        }

        .page-header {
            text-align: left;
            margin-bottom: 50px;
        }

        .page-title {
            font-size: 36px;
            font-weight: 700;
            color: #4a90e2;
            margin-bottom: 15px;
        }

        .page-subtitle {
            font-size: 16px;
            color: #6c757d;
            line-height: 1.6;
        }

        /* 통계 카드 */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 50px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            text-align: center;
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-icon {
            font-size: 36px;
            margin-bottom: 15px;
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 14px;
            color: #6c757d;
        }

        /* 필터 바 */
        .filter-bar {
            background: white;
            padding: 25px 30px;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-label {
            font-weight: 600;
            color: #495057;
            font-size: 14px;
        }

        .filter-select {
            padding: 10px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            background: white;
            cursor: pointer;
            transition: border-color 0.2s ease;
        }

        .filter-select:focus {
            outline: none;
            border-color: #0061ff;
        }

        .search-box {
            flex: 1;
            position: relative;
            min-width: 250px;
        }

        .search-input {
            width: 100%;
            padding: 10px 40px 10px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.2s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: #0061ff;
        }

        .search-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }

        /* 리뷰 카드 */
        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .review-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .review-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,97,255,0.15);
            border-color: #0061ff;
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .reviewer-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .reviewer-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            font-weight: 700;
        }

        .reviewer-avatar.anonymous {
            background: linear-gradient(135deg, #95a5a6 0%, #7f8c8d 100%);
        }

        .reviewer-details {
            flex: 1;
        }

        .reviewer-name {
            font-weight: 600;
            font-size: 16px;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .review-date {
            font-size: 13px;
            color: #6c757d;
        }

        .donation-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            background: #e3f2fd;
            color: #1976d2;
        }

        .donation-badge.regular {
            background: #fff3e0;
            color: #e65100;
        }

        .review-rating {
            display: flex;
            gap: 5px;
            margin-bottom: 15px;
        }

        .star {
            color: #ffc107;
            font-size: 18px;
        }

        .star.empty {
            color: #e0e0e0;
        }

        .review-category {
            display: inline-block;
            padding: 6px 12px;
            background: #f8f9fa;
            border-radius: 6px;
            font-size: 13px;
            color: #495057;
            margin-bottom: 15px;
            font-weight: 500;
        }

        .review-content {
            font-size: 15px;
            line-height: 1.7;
            color: #495057;
            margin-bottom: 20px;
        }

        .review-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 20px;
            border-top: 1px solid #f0f0f0;
        }

        .donation-amount {
            font-weight: 600;
            color: #0061ff;
            font-size: 16px;
        }

        .helpful-btn {
            display: flex;
            align-items: center;
            gap: 5px;
            padding: 8px 15px;
            border: 1px solid #e9ecef;
            border-radius: 20px;
            background: white;
            color: #6c757d;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .helpful-btn:hover {
            background: #0061ff;
            color: white;
            border-color: #0061ff;
        }

        .helpful-btn.active {
            background: #0061ff;
            color: white;
            border-color: #0061ff;
        }

        /* 페이지네이션 */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 50px;
        }

        .page-btn {
            padding: 10px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            background: white;
            color: #495057;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .page-btn:hover {
            background: #0061ff;
            color: white;
            border-color: #0061ff;
        }

        .page-btn.active {
            background: #0061ff;
            color: white;
            border-color: #0061ff;
        }

        .page-btn:disabled {
            opacity: 0.3;
            cursor: not-allowed;
        }

        /* 리뷰 작성 버튼 */
        .write-review-btn {
            position: fixed;
            bottom: 40px;
            right: 40px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #0061ff 0%, #357abd 100%);
            color: white;
            border: none;
            font-size: 24px;
            cursor: pointer;
            box-shadow: 0 4px 20px rgba(0,97,255,0.4);
            transition: all 0.3s ease;
            z-index: 100;
        }

        .write-review-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 30px rgba(0,97,255,0.6);
        }

        /* Footer */
        footer {
            background: #2c3e50;
            color: #ecf0f1;
            padding: 60px 20px 30px;
            margin-top: 80px;
        }

        .footer-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .footer-content {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr 1.5fr;
            gap: 40px;
            margin-bottom: 40px;
        }

        .footer-section h3 {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 20px;
            color: #fff;
        }

        .footer-about p {
            line-height: 1.8;
            color: #bdc3c7;
            margin-bottom: 15px;
            font-size: 14px;
        }

        .footer-links {
            list-style: none;
            padding: 0;
        }

        .footer-links li {
            margin-bottom: 12px;
        }

        .footer-links a {
            color: #bdc3c7;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s ease;
        }

        .footer-links a:hover {
            color: #3498db;
        }

        .footer-bottom {
            border-top: 1px solid #34495e;
            padding-top: 30px;
            text-align: center;
        }

        .footer-bottom p {
            color: #95a5a6;
            font-size: 13px;
            margin: 5px 0;
        }

        /* 반응형 디자인 */
        @media (max-width: 1024px) {
            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }

            .reviews-grid {
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 0 15px;
            }

            .nav-menu {
                display: none;
            }

            .container {
                padding: 40px 15px;
            }

            .page-title {
                font-size: 28px;
            }

            .stats-container {
                grid-template-columns: 1fr;
            }

            .filter-bar {
                flex-direction: column;
                align-items: stretch;
            }

            .search-box {
                min-width: 100%;
            }

            .reviews-grid {
                grid-template-columns: 1fr;
            }

            .footer-content {
                grid-template-columns: 1fr;
            }

            .write-review-btn {
                bottom: 20px;
                right: 20px;
            }
        }

        /* 빈 상태 */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
        }

        .empty-icon {
            font-size: 64px;
            color: #e0e0e0;
            margin-bottom: 20px;
        }

        .empty-text {
            font-size: 18px;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="container">
        <div class="page-header">
            <h1 class="page-title">후원자 리뷰</h1>
            <p class="page-subtitle">
                여러분의 따뜻한 마음이 누군가에게는 큰 힘이 됩니다.<br>
                후원자님들의 소중한 이야기를 들어보세요.
            </p>
        </div>

        <!-- 통계 카드 -->
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-heart" style="color: #e74c3c;"></i>
                </div>
                <div class="stat-value" data-stat="donors">0</div>
                <div class="stat-label">총 후원자 수</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-comments" style="color: #0061ff;"></i>
                </div>
                <div class="stat-value" data-stat="reviews">0</div>
                <div class="stat-label">리뷰 수</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-star" style="color: #ffc107;"></i>
                </div>
                <div class="stat-value" data-stat="rating">0.0</div>
                <div class="stat-label">평균 만족도</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-hand-holding-heart" style="color: #2ecc71;"></i>
                </div>
                <div class="stat-value" data-stat="amount">0원</div>
                <div class="stat-label">누적 후원금</div>
            </div>
        </div>

        <!-- 필터 바 -->
        <div class="filter-bar">
            <div class="filter-group">
                <label class="filter-label">분야</label>
                <select class="filter-select" id="categoryFilter">
                    <option value="">전체</option>
                    <option value="위기가정">위기가정</option>
                    <option value="화재피해">화재피해</option>
                    <option value="자연재해">자연재해</option>
                    <option value="의료비">의료비</option>
                    <option value="범죄피해">범죄피해</option>
                    <option value="가정폭력">가정폭력</option>
                    <option value="한부모">한부모</option>
                    <option value="노숙인">노숙인</option>
                    <option value="자살고위험">자살고위험</option>
                </select>
            </div>
            <div class="filter-group">
                <label class="filter-label">정렬</label>
                <select class="filter-select" id="sortFilter">
                    <option value="latest">최신순</option>
                    <option value="rating">별점순</option>
                    <option value="amount">후원금액순</option>
                    <option value="helpful">도움됨순</option>
                </select>
            </div>
            <div class="search-box">
                <input type="text" class="search-input" placeholder="리뷰 검색..." id="searchInput">
                <i class="fas fa-search search-icon"></i>
            </div>
        </div>

        <!-- 리뷰 목록 -->
        <div class="reviews-grid" id="reviewsGrid">
            <!-- 샘플 리뷰 데이터 -->
        </div>

        <!-- 페이지네이션 -->
        <div class="pagination" id="pagination">
            <!-- JavaScript로 동적 생성 -->
        </div>
    </div>

    <!-- 리뷰 작성 버튼 -->
    <button class="write-review-btn" onclick="writeReview()" title="리뷰 작성하기">
        <i class="fas fa-pen"></i>
    </button>

    <!-- Footer -->
    <footer>
        <div class="footer-container">
            <div class="footer-content">
                <div class="footer-section footer-about">
                    <h3>복지24</h3>
                    <p>국민 모두가 누려야 할 복지 혜택,<br>복지24가 찾아드립니다.</p>
                    <p style="font-size: 13px; color: #95a5a6;">
                        보건복지부, 지방자치단체와 함께<br>국민의 복지 향상을 위해 노력합니다.
                    </p>
                </div>

                <div class="footer-section">
                    <h3>서비스</h3>
                    <ul class="footer-links">
                        <li><a href="/bdproject/project_detail.jsp">복지 혜택 찾기</a></li>
                        <li><a href="/bdproject/project_Map.jsp">복지 지도</a></li>
                        <li><a href="/bdproject/project_information.jsp">상황 진단하기</a></li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h3>참여하기</h3>
                    <ul class="footer-links">
                        <li><a href="/bdproject/project_volunteer.jsp">봉사 신청</a></li>
                        <li><a href="/bdproject/project_Donation.jsp">기부하기</a></li>
                        <li><a href="/bdproject/project_donation_review.jsp">후원자 리뷰</a></li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h3>고객지원</h3>
                    <ul class="footer-links">
                        <li><a href="/bdproject/project_notice.jsp">공지사항</a></li>
                        <li><a href="/bdproject/project_faq.jsp">자주묻는 질문</a></li>
                        <li><a href="/bdproject/project_about.jsp">소개</a></li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h3>고객센터</h3>
                    <p style="color: #bdc3c7; font-size: 14px; margin-bottom: 10px;">
                        <strong style="color: #fff;">전화</strong> 1234-5678
                    </p>
                    <p style="color: #bdc3c7; font-size: 14px; margin-bottom: 10px;">
                        <strong style="color: #fff;">이메일</strong> support@welfare24.com
                    </p>
                    <p style="color: #bdc3c7; font-size: 14px;">
                        <strong style="color: #fff;">운영시간</strong> 평일 09:00 - 18:00<br>
                        (주말 및 공휴일 휴무)
                    </p>
                </div>
            </div>

            <div class="footer-bottom">
                <p>Copyright &copy; 2025 복지24. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script>
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

        // 좋아요 토글 (추가/취소) - 로그인 체크 추가
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

                    if (isLiked) {
                        // 이미 좋아요를 눌렀다면 -> 취소
                        review.helpful = Math.max(0, review.helpful - 1);
                        const index = likedReviews.indexOf(reviewId);
                        likedReviews.splice(index, 1);
                    } else {
                        // 좋아요 추가
                        review.helpful += 1;
                        likedReviews.push(reviewId);
                    }

                    saveLikedReviews(likedReviews);
                    renderReviews();
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
    </script>
</body>
</html>
