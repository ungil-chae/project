<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navbar.css">

<header id="main-header">
    <nav class="navbar">
        <div class="navbar-left">
            <a href="/bdproject/project.jsp" class="logo">
                <div class="logo-icon"></div>
                <span class="logo-text">복지24</span>
            </a>
        </div>
        <div class="nav-menu">
            <div class="nav-item">
                <a href="#" class="nav-link" data-menu="service">서비스</a>
            </div>
            <div class="nav-item">
                <a href="#" class="nav-link" data-menu="explore">살펴보기</a>
            </div>
            <div class="nav-item">
                <a href="#" class="nav-link" data-menu="volunteer">봉사하기</a>
            </div>
            <div class="nav-item">
                <a href="#" class="nav-link" data-menu="donate">기부하기</a>
            </div>
        </div>
        <div class="navbar-right">
            <div class="language-selector">
                <svg class="navbar-icon" id="languageToggle" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" style="cursor: pointer;" title="언어 선택">
                    <path d="M12 2C6.477 2 2 6.477 2 12s4.477 10 10 10 10-4.477 10-10S17.523 2 12 2zm6.93 6h-2.95a15.65 15.65 0 00-1.38-3.56A8.03 8.03 0 0118.93 8zM12 4.04c.83 1.2 1.48 2.53 1.91 3.96h-3.82c.43-1.43 1.08-2.76 1.91-3.96zM4.26 14C4.1 13.36 4 12.69 4 12s.1-1.36.26-2h3.38c-.08.66-.14 1.32-.14 2 0 .68.06 1.34.14 2H4.26zm.81 2h2.95c.32 1.25.78 2.45 1.38 3.56A7.987 7.987 0 015.07 16zm2.95-8H5.07a7.987 7.987 0 014.33-3.56A15.65 15.65 0 008.02 8zM12 19.96c-.83-1.2-1.48-2.53-1.91-3.96h3.82c-.43 1.43-1.08 2.76-1.91 3.96zM14.34 14H9.66c-.09-.66-.16-1.32-.16-2 0-.68.07-1.35.16-2h4.68c.09.65.16 1.32.16 2 0 .68-.07 1.34-.16 2zm.25 5.56c.6-1.11 1.06-2.31 1.38-3.56h2.95a8.03 8.03 0 01-4.33 3.56zM16.36 14c.08-.66.14-1.32.14-2 0-.68-.06-1.34-.14-2h3.38c.16.64.26 1.31.26 2s-.1 1.36-.26 2h-3.38z"></path>
                </svg>
                <div id="google_translate_element" style="display: none;"></div>
            </div>
            <svg class="navbar-icon" id="userIcon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" style="cursor: pointer">
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 4c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm0 14c-2.03 0-4.43-.82-6.14-2.88C7.55 15.8 9.68 15 12 15s4.45.8 6.14 2.12C16.43 19.18 14.03 20 12 20z"></path>
            </svg>
        </div>
    </nav>
    <div id="mega-menu-wrapper">
        <div class="mega-menu-content">
            <div class="menu-column" data-menu-content="service">
                <a href="/bdproject/project_information.jsp" class="dropdown-link">
                    <span class="dropdown-link-title">나의 상황 진단하기</span>
                    <span class="dropdown-link-desc">나에게 맞는 복지 혜택을 찾아보세요.</span>
                </a>
                <a href="/bdproject/project_Map.jsp" class="dropdown-link">
                    <span class="dropdown-link-title">복지 지도</span>
                    <span class="dropdown-link-desc">주변의 복지시설을 지도로 확인하세요.</span>
                </a>
            </div>
            <div class="menu-column" data-menu-content="explore">
                <a href="/bdproject/project_notice.jsp" class="dropdown-link">
                    <span class="dropdown-link-title">공지사항</span>
                    <span class="dropdown-link-desc">새로운 복지 소식을 알려드립니다.</span>
                </a>
                <a href="/bdproject/project_faq.jsp" class="dropdown-link">
                    <span class="dropdown-link-title">자주묻는 질문</span>
                    <span class="dropdown-link-desc">궁금한 점을 빠르게 해결하세요.</span>
                </a>
                <a href="/bdproject/project_about.jsp" class="dropdown-link">
                    <span class="dropdown-link-title">소개</span>
                    <span class="dropdown-link-desc">복지24에 대해 알아보세요.</span>
                </a>
            </div>
            <div class="menu-column" data-menu-content="volunteer">
                <a href="/bdproject/project_volunteer.jsp" class="dropdown-link">
                    <span class="dropdown-link-title">봉사 신청</span>
                    <span class="dropdown-link-desc">나에게 맞는 봉사활동을 찾아보세요.</span>
                </a>
                <a href="/bdproject/project_volunteer_record.jsp" class="dropdown-link">
                    <span class="dropdown-link-title">봉사 후기</span>
                    <span class="dropdown-link-desc">봉사자들의 따뜻한 이야기를 만나보세요.</span>
                </a>
            </div>
            <div class="menu-column" data-menu-content="donate">
                <a href="/bdproject/project_Donation.jsp" class="dropdown-link">
                    <span class="dropdown-link-title">기부하기</span>
                    <span class="dropdown-link-desc">따뜻한 나눔으로 세상을 변화시켜보세요.</span>
                </a>
                <a href="/bdproject/project_donation_review.jsp" class="dropdown-link">
                    <span class="dropdown-link-title">후원자 리뷰</span>
                    <span class="dropdown-link-desc">따뜻한 나눔 이야기를 들어보세요.</span>
                </a>
                <a href="/bdproject/project_fundUsage.jsp" class="dropdown-link">
                    <span class="dropdown-link-title">기금 사용처</span>
                    <span class="dropdown-link-desc">후원금을 투명하게 운영합니다.</span>
                </a>
            </div>
        </div>
    </div>
</header>

<script src="${pageContext.request.contextPath}/resources/js/navbar.js"></script>
<script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
