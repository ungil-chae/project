<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>후원자 리뷰 - 복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="resources/css/project_donation_review.css">
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

    <script src="resources/js/project_donation_review.js"></script>
</body>
</html>
