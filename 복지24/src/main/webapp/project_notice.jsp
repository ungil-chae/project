<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 - 복지24</title>
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

        .logo {
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            color: #333;
            width: fit-content;
            transition: opacity 0.2s ease;
        }

        .logo:hover {
            opacity: 0.7;
        }

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
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 8px 0;
            min-width: 160px;
            max-height: 300px;
            overflow-y: auto;
            z-index: 9999;
            margin-top: 5px;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.2s ease;
        }

        .language-dropdown.active {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
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
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.05);
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

        .container {
            max-width: 1200px;
            margin: 60px auto;
            padding: 0 20px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 50px;
        }

        .page-title {
            font-size: 42px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .page-subtitle {
            font-size: 18px;
            color: #6c757d;
            line-height: 1.6;
        }

        .notice-list {
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .notice-item {
            border-bottom: 1px solid #e9ecef;
            padding: 25px 30px;
            transition: background-color 0.2s ease;
            cursor: pointer;
        }

        .notice-item:last-child {
            border-bottom: none;
        }

        .notice-item:hover {
            background-color: #f8f9fa;
        }

        .notice-item.important {
            background-color: #fff3cd;
        }

        .notice-item.important:hover {
            background-color: #ffe69c;
        }

        .notice-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 8px;
        }

        .notice-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .notice-badge.important {
            background-color: #dc3545;
            color: white;
        }

        .notice-badge.new {
            background-color: #28a745;
            color: white;
        }

        .notice-title {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            flex: 1;
        }

        .notice-date {
            font-size: 14px;
            color: #6c757d;
        }

        .notice-content {
            font-size: 15px;
            color: #495057;
            line-height: 1.8;
            max-height: 0;
            overflow: hidden;
            opacity: 0;
            transition: max-height 0.5s ease, opacity 0.4s ease, margin-top 0.4s ease, padding 0.4s ease;
        }

        .notice-content.active {
            max-height: 500px;
            opacity: 1;
            margin-top: 15px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
            border-left: 4px solid #4A90E2;
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 40px;
        }

        .page-btn {
            padding: 10px 15px;
            border: 1px solid #dee2e6;
            background: white;
            color: #495057;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .page-btn:hover {
            background-color: #e9ecef;
        }

        .page-btn.active {
            background-color: #4A90E2;
            color: white;
            border-color: #4A90E2;
        }
    </style>
</head>
<body>
    <!-- 헤더 -->
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
                    <svg class="navbar-icon" id="languageToggle" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M12 2C6.477 2 2 6.477 2 12s4.477 10 10 10 10-4.477 10-10S17.523 2 12 2zm6.93 6h-2.95a15.65 15.65 0 00-1.38-3.56A8.03 8.03 0 0118.93 8zM12 4.04c.83 1.2 1.48 2.53 1.91 3.96h-3.82c.43-1.43 1.08-2.76 1.91-3.96zM4.26 14C4.1 13.36 4 12.69 4 12s.1-1.36.26-2h3.38c-.08.66-.14 1.32-.14 2 0 .68.06 1.34.14 2H4.26zm.81 2h2.95c.32 1.25.78 2.45 1.38 3.56A7.987 7.987 0 015.07 16zm2.95-8H5.07a7.987 7.987 0 014.33-3.56A15.65 15.65 0 008.02 8zM12 19.96c-.83-1.2-1.48-2.53-1.91-3.96h3.82c-.43 1.43-1.08 2.76-1.91 3.96zM14.34 14H9.66c-.09-.66-.16-1.32-.16-2 0-.68.07-1.35.16-2h4.68c.09.65.16 1.32.16 2 0 .68-.07 1.34-.16 2zm.25 5.56c.6-1.11 1.06-2.31 1.38-3.56h2.95a8.03 8.03 0 01-4.33 3.56zM16.36 14c.08-.66.14-1.32.14-2 0-.68-.06-1.34-.14-2h3.38c.16.64.26 1.31.26 2s-.1 1.36-.26 2h-3.38z"></path>
                    </svg>
                    <div class="language-dropdown" id="languageDropdown">
                        <div class="language-option" data-lang="ko">
                            <span class="country-name">대한민국</span>
                            <span class="language-name">한국어</span>
                        </div>
                        <div class="language-option" data-lang="en">
                            <span class="country-name">Australia</span>
                            <span class="language-name">English</span>
                        </div>
                        <div class="language-option" data-lang="ja">
                            <span class="country-name">日本</span>
                            <span class="language-name">日本語</span>
                        </div>
                        <div class="language-option" data-lang="zh">
                            <span class="country-name">中国</span>
                            <span class="language-name">中文</span>
                        </div>
                        <div class="language-option" data-lang="es">
                            <span class="country-name">España</span>
                            <span class="language-name">Español</span>
                        </div>
                    </div>
                </div>
                <svg class="navbar-icon" id="userIcon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" style="cursor: pointer">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 4c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm0 14c-2.03 0-4.43-.82-6.14-2.88C7.55 15.8 9.68 15 12 15s4.45.8 6.14 2.12C16.43 19.18 14.03 20 12 20z"></path>
                </svg>
            </div>
        </nav>
        <div id="mega-menu-wrapper">
            <div class="mega-menu-content">
                <div class="menu-column" data-menu-content="service">
                    <a href="/bdproject/project_detail.jsp" class="dropdown-link">
                        <span class="dropdown-link-title">복지 혜택 찾기</span>
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
                    <a href="#" class="dropdown-link">
                        <span class="dropdown-link-title">봉사 신청</span>
                        <span class="dropdown-link-desc">나에게 맞는 봉사활동을 찾아보세요.</span>
                    </a>
                    <a href="#" class="dropdown-link">
                        <span class="dropdown-link-title">봉사 기록</span>
                        <span class="dropdown-link-desc">나의 봉사활동 내역을 확인하세요.</span>
                    </a>
                </div>
                <div class="menu-column" data-menu-content="donate">
                    <a href="/bdproject/project_Donation.jsp" class="dropdown-link">
                        <span class="dropdown-link-title">기부하기</span>
                        <span class="dropdown-link-desc">따뜻한 나눔으로 세상을 변화시켜보세요.</span>
                    </a>
                    <a href="#" class="dropdown-link">
                        <span class="dropdown-link-title">후원자 리뷰</span>
                        <span class="dropdown-link-desc">따뜻한 나눔 이야기를 들어보세요.</span>
                    </a>
                    <a href="#" class="dropdown-link">
                        <span class="dropdown-link-title">기부 사용처</span>
                        <span class="dropdown-link-desc">후원금을 투명하게 운영합니다.</span>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- 메인 컨텐츠 -->
    <div class="container">
        <div class="page-header">
            <h1 class="page-title">공지사항</h1>
            <p class="page-subtitle">복지24의 새로운 소식과 중요한 공지사항을 확인하세요</p>
        </div>

        <div class="notice-list">
            <div class="notice-item important" onclick="toggleContent(this)">
                <div class="notice-header">
                    <span class="notice-badge important">중요</span>
                    <span class="notice-title">2024년 복지 혜택 확대 안내</span>
                    <span class="notice-date">2024.10.08</span>
                </div>
                <div class="notice-content">
                    2024년부터 복지 혜택이 대폭 확대됩니다. 기존 소득 기준이 완화되어 더 많은 분들이 혜택을 받으실 수 있게 되었습니다.
                    자세한 사항은 복지 혜택 찾기 메뉴에서 진단을 통해 확인하실 수 있습니다.
                </div>
            </div>

            <div class="notice-item" onclick="toggleContent(this)">
                <div class="notice-header">
                    <span class="notice-title">복지 지도 서비스 오픈</span>
                    <span class="notice-date">2024.10.05</span>
                </div>
                <div class="notice-content">
                    주변 복지시설을 한눈에 확인할 수 있는 복지 지도 서비스가 오픈되었습니다.
                    복지관, 주민센터, 상담센터 등 다양한 복지시설의 위치와 정보를 지도에서 확인하세요.
                </div>
            </div>

            <div class="notice-item" onclick="toggleContent(this)">
                <div class="notice-header">
                    <span class="notice-title">복지24 모바일 앱 출시 예정</span>
                    <span class="notice-date">2024.10.01</span>
                </div>
                <div class="notice-content">
                    언제 어디서나 복지 혜택을 확인하고 신청할 수 있는 복지24 모바일 앱이 11월 중 출시 예정입니다.
                    많은 기대 부탁드립니다.
                </div>
            </div>

            <div class="notice-item" onclick="toggleContent(this)">
                <div class="notice-header">
                    <span class="notice-title">추석 연휴 고객센터 운영 안내</span>
                    <span class="notice-date">2024.09.25</span>
                </div>
                <div class="notice-content">
                    추석 연휴 기간(9/28~10/3) 동안 고객센터 운영이 일부 제한됩니다.
                    긴급 문의사항은 온라인 채팅 상담을 이용해 주시기 바랍니다.
                </div>
            </div>

            <div class="notice-item" onclick="toggleContent(this)">
                <div class="notice-header">
                    <span class="notice-title">개인정보 처리방침 개정 안내</span>
                    <span class="notice-date">2024.09.15</span>
                </div>
                <div class="notice-content">
                    개인정보 보호를 강화하기 위해 개인정보 처리방침이 개정되었습니다.
                    개정된 내용은 9월 20일부터 적용됩니다. 자세한 내용은 하단 개인정보 처리방침 페이지에서 확인하세요.
                </div>
            </div>

            <div class="notice-item" onclick="toggleContent(this)">
                <div class="notice-header">
                    <span class="notice-title">복지24 서비스 점검 안내</span>
                    <span class="notice-date">2024.09.10</span>
                </div>
                <div class="notice-content">
                    서비스 안정화를 위한 시스템 점검이 9월 12일 새벽 2시~5시에 진행됩니다.
                    점검 시간 동안 일시적으로 서비스 이용이 제한될 수 있습니다.
                </div>
            </div>
        </div>

        <div class="pagination">
            <button class="page-btn">&laquo;</button>
            <button class="page-btn active">1</button>
            <button class="page-btn">2</button>
            <button class="page-btn">3</button>
            <button class="page-btn">&raquo;</button>
        </div>
    </div>

    <script>
        function toggleContent(element) {
            const content = element.querySelector('.notice-content');
            content.classList.toggle('active');
        }

        // DOM이 완전히 로드된 후 실행
        document.addEventListener('DOMContentLoaded', function() {
            // --- 네비바 드롭다운 메뉴 ---
            const header = document.getElementById("main-header");
            const navLinks = document.querySelectorAll(".nav-link[data-menu]");
            const megaMenuWrapper = document.getElementById("mega-menu-wrapper");
            const menuColumns = document.querySelectorAll(".menu-column");
            let menuTimeout;

            const showMenu = (targetMenu) => {
                clearTimeout(menuTimeout);
                megaMenuWrapper.classList.add("active");

                menuColumns.forEach((col) => {
                    if (col.dataset.menuContent === targetMenu) {
                        col.style.display = "flex";
                    } else {
                        col.style.display = "none";
                    }
                });

                navLinks.forEach((link) => {
                    if (link.dataset.menu === targetMenu) {
                        link.classList.add("active");
                    } else {
                        link.classList.remove("active");
                    }
                });
            };

            const hideMenu = () => {
                menuTimeout = setTimeout(() => {
                    megaMenuWrapper.classList.remove("active");
                    navLinks.forEach((link) => link.classList.remove("active"));
                }, 200);
            };

            navLinks.forEach((link) => {
                link.addEventListener("mouseenter", () => {
                    showMenu(link.dataset.menu);
                });
            });

            header.addEventListener("mouseleave", () => {
                hideMenu();
            });
            // --- 네비바 로직 끝 ---

            // 언어 선택 드롭다운
            const languageToggle = document.getElementById('languageToggle');
            const languageDropdown = document.getElementById('languageDropdown');

            if (languageToggle && languageDropdown) {
                languageToggle.addEventListener('click', function(e) {
                    e.stopPropagation();
                    languageDropdown.classList.toggle('active');
                });

                document.addEventListener('click', function() {
                    languageDropdown.classList.remove('active');
                });
            }

            // 유저 아이콘 클릭
            const userIcon = document.getElementById('userIcon');
            if (userIcon) {
                userIcon.addEventListener('click', function() {
                    window.location.href = '/bdproject/projectLogin.jsp';
                });
            }
        });
    </script>
</body>
</html>
