<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>소개 - 복지24</title>
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

        .hero-section {
            background: #2c3e50;
            color: white;
            padding: 100px 20px;
            text-align: center;
        }

        .hero-title {
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .hero-subtitle {
            font-size: 20px;
            opacity: 0.95;
            max-width: 800px;
            margin: 0 auto;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .section {
            padding: 80px 20px;
        }

        .section-title {
            font-size: 36px;
            font-weight: 700;
            color: #2c3e50;
            text-align: center;
            margin-bottom: 20px;
        }

        .section-subtitle {
            font-size: 18px;
            color: #6c757d;
            text-align: center;
            margin-bottom: 60px;
            line-height: 1.6;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
            margin-top: 40px;
        }

        .feature-card {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 25px rgba(0,0,0,0.15);
        }

        .feature-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
            font-size: 36px;
            color: white;
        }

        .feature-title {
            font-size: 22px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .feature-description {
            font-size: 15px;
            color: #6c757d;
            line-height: 1.8;
        }

        .stats-section {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 80px 20px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            margin-top: 40px;
        }

        .stat-card {
            text-align: center;
        }

        .stat-number {
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-label {
            font-size: 18px;
            opacity: 0.9;
        }

        .mission-section {
            background: white;
        }

        .mission-content {
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
        }

        .mission-text {
            font-size: 18px;
            color: #495057;
            line-height: 2;
            margin-bottom: 30px;
        }

        .values-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 30px;
            margin-top: 50px;
        }

        .value-item {
            text-align: center;
            padding: 30px 20px;
        }

        .value-emoji {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .value-title {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .value-desc {
            font-size: 14px;
            color: #6c757d;
        }

        .contact-section {
            background: #f8f9fa;
        }

        .contact-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }

        .contact-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
        }

        .contact-icon {
            font-size: 36px;
            color: #4a90e2;
            margin-bottom: 20px;
        }

        .contact-title {
            font-size: 20px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .contact-info {
            font-size: 16px;
            color: #495057;
        }

        /* Footer 스타일 */
        footer {
            position: relative;
            z-index: 10;
            background: #2c3e50;
            color: #ecf0f1;
            padding: 60px 20px 30px;
            margin-top: 0;
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
            margin: 0;
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
        .footer-contact p {
            color: #bdc3c7;
            margin-bottom: 12px;
            font-size: 14px;
            line-height: 1.8;
        }
        .footer-contact strong {
            color: #fff;
            display: block;
            margin-bottom: 5px;
        }
        .social-links {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }
        .social-icon {
            width: 40px;
            height: 40px;
            background: #34495e;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ecf0f1;
            text-decoration: none;
            font-size: 18px;
            transition: all 0.3s ease;
        }
        .social-icon:hover {
            background: #3498db;
            transform: translateY(-3px);
        }
        .footer-bottom {
            border-top: 1px solid #34495e;
            padding-top: 30px;
            text-align: center;
        }
        .footer-bottom-content {
            display: flex;
            flex-direction: column;
            gap: 15px;
            align-items: center;
        }
        .footer-bottom p {
            color: #95a5a6;
            font-size: 13px;
            margin: 5px 0;
        }
        .footer-legal-links {
            display: flex;
            gap: 20px;
            margin-top: 10px;
        }
        .footer-legal-links a {
            color: #95a5a6;
            text-decoration: none;
            font-size: 13px;
            transition: color 0.3s ease;
        }
        .footer-legal-links a:hover {
            color: #3498db;
        }

        @media (max-width: 768px) {
            .footer-content {
                grid-template-columns: 1fr;
                gap: 30px;
            }
            .footer-legal-links {
                flex-direction: column;
                gap: 10px;
            }
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

    <!-- 히어로 섹션 -->
    <section class="hero-section">
        <h1 class="hero-title">복지24와 함께하는 따뜻한 세상</h1>
        <p class="hero-subtitle">
            복지24는 모든 국민이 자신에게 맞는 복지 혜택을 쉽게 찾고 신청할 수 있도록 돕는 통합 복지 플랫폼입니다.
            우리는 기술과 마음을 더해 더 나은 삶을 만들어갑니다.
        </p>
    </section>

    <!-- 주요 기능 섹션 -->
    <section class="section">
        <div class="container">
            <h2 class="section-title">복지24의 주요 서비스</h2>
            <p class="section-subtitle">누구나 쉽게 이용할 수 있는 맞춤형 복지 서비스를 제공합니다</p>

            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <h3 class="feature-title">맞춤형 복지 혜택 찾기</h3>
                    <p class="feature-description">
                        간단한 정보 입력만으로 나에게 맞는 복지 혜택을 추천해 드립니다.
                        중앙부처와 지방자치단체의 모든 복지 서비스를 한 번에 검색할 수 있습니다.
                    </p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-map-marked-alt"></i>
                    </div>
                    <h3 class="feature-title">복지 지도</h3>
                    <p class="feature-description">
                        내 주변의 복지시설을 지도에서 쉽게 찾을 수 있습니다.
                        복지관, 주민센터, 상담센터 등 다양한 시설의 위치와 정보를 제공합니다.
                    </p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-hands-helping"></i>
                    </div>
                    <h3 class="feature-title">봉사 및 기부</h3>
                    <p class="feature-description">
                        봉사활동 신청과 기부를 통해 지역사회에 기여할 수 있습니다.
                        함께 만드는 따뜻한 사회, 복지24가 연결해 드립니다.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- 통계 섹션 -->
    <section class="stats-section">
        <div class="container">
            <h2 class="section-title" style="color: white;">복지24의 성과</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number">10,000+</div>
                    <div class="stat-label">등록된 복지 서비스</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">500,000+</div>
                    <div class="stat-label">서비스 이용자</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">1,500+</div>
                    <div class="stat-label">협력 기관</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">95%</div>
                    <div class="stat-label">사용자 만족도</div>
                </div>
            </div>
        </div>
    </section>

    <!-- 미션 및 비전 섹션 -->
    <section class="section mission-section">
        <div class="container">
            <h2 class="section-title">우리의 미션</h2>
            <div class="mission-content">
                <p class="mission-text">
                    <strong>모든 국민이 복지 사각지대 없이 자신에게 맞는 혜택을 누릴 수 있는 세상</strong>을 만듭니다.
                    복잡한 복지 제도를 쉽게 이해하고, 간편하게 신청할 수 있도록 기술과 정보를 연결합니다.
                </p>
                <p class="mission-text">
                    복지24는 단순한 정보 제공을 넘어, 실질적인 도움이 필요한 분들에게
                    <strong>맞춤형 솔루션</strong>을 제공하여 삶의 질을 향상시키는 것을 목표로 합니다.
                </p>
            </div>

            <div class="values-grid">
                <div class="value-item">
                    <div class="value-emoji">🤝</div>
                    <div class="value-title">신뢰</div>
                    <div class="value-desc">정확한 정보로 신뢰를 만듭니다</div>
                </div>
                <div class="value-item">
                    <div class="value-emoji">💡</div>
                    <div class="value-title">혁신</div>
                    <div class="value-desc">기술로 복지를 혁신합니다</div>
                </div>
                <div class="value-item">
                    <div class="value-emoji">❤️</div>
                    <div class="value-title">배려</div>
                    <div class="value-desc">사용자를 먼저 생각합니다</div>
                </div>
                <div class="value-item">
                    <div class="value-emoji">🌍</div>
                    <div class="value-title">포용</div>
                    <div class="value-desc">모두를 위한 서비스를 만듭니다</div>
                </div>
            </div>
        </div>
    </section>

    <!-- 문의 섹션 -->
    <section class="section contact-section">
        <div class="container">
            <h2 class="section-title">문의하기</h2>
            <p class="section-subtitle">복지24에 대해 궁금한 점이 있으신가요? 언제든 연락주세요</p>

            <div class="contact-grid">
                <div class="contact-card">
                    <div class="contact-icon">
                        <i class="fas fa-phone"></i>
                    </div>
                    <h3 class="contact-title">전화 문의</h3>
                    <p class="contact-info">1544-1234<br>평일 09:00 - 18:00</p>
                </div>

                <div class="contact-card">
                    <div class="contact-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <h3 class="contact-title">이메일</h3>
                    <p class="contact-info">support@welfare24.kr<br>24시간 접수 가능</p>
                </div>

                <div class="contact-card">
                    <div class="contact-icon">
                        <i class="fas fa-comments"></i>
                    </div>
                    <h3 class="contact-title">채팅 상담</h3>
                    <p class="contact-info">웹사이트 우측 하단<br>실시간 상담 가능</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="footer-container">
            <div class="footer-content">
                <!-- 회사 소개 -->
                <div class="footer-section footer-about">
                    <h3>복지24</h3>
                    <p>
                        국민 모두가 누려야 할 복지 혜택,<br>
                        복지24가 찾아드립니다.
                    </p>
                    <p style="font-size: 13px; color: #95a5a6;">
                        보건복지부, 지방자치단체와 함께<br>
                        국민의 복지 향상을 위해 노력합니다.
                    </p>
                </div>

                <!-- 서비스 -->
                <div class="footer-section">
                    <h3>서비스</h3>
                    <ul class="footer-links">
                        <li><a href="/bdproject/project_detail.jsp">복지 혜택 찾기</a></li>
                        <li><a href="/bdproject/project_Map.jsp">복지 지도</a></li>
                        <li><a href="/bdproject/project_information.jsp">상황 진단하기</a></li>
                    </ul>
                </div>

                <!-- 참여하기 -->
                <div class="footer-section">
                    <h3>참여하기</h3>
                    <ul class="footer-links">
                        <li><a href="#">봉사 신청</a></li>
                        <li><a href="/bdproject/project_Donation.jsp">기부하기</a></li>
                        <li><a href="#">후원자 리뷰</a></li>
                    </ul>
                </div>

                <!-- 고객지원 -->
                <div class="footer-section">
                    <h3>고객지원</h3>
                    <ul class="footer-links">
                        <li><a href="/bdproject/project_notice.jsp">공지사항</a></li>
                        <li><a href="/bdproject/project_faq.jsp">자주묻는 질문</a></li>
                        <li><a href="/bdproject/project_about.jsp">소개</a></li>
                    </ul>
                </div>

                <!-- 문의 정보 -->
                <div class="footer-section footer-contact">
                    <h3>고객센터</h3>
                    <p>
                        <strong>전화</strong>
                        1234-5678
                    </p>
                    <p>
                        <strong>운영시간</strong>
                        평일 09:00 - 18:00<br>
                        (주말 및 공휴일 휴무)
                    </p>
                    <p>
                        <strong>이메일</strong>
                        support@welfare24.com
                    </p>
                    <div class="social-links">
                        <a href="#" class="social-icon" aria-label="Facebook">
                            <i class="fab fa-facebook-f"></i>
                        </a>
                        <a href="#" class="social-icon" aria-label="Instagram">
                            <i class="fab fa-instagram"></i>
                        </a>
                        <a href="#" class="social-icon" aria-label="YouTube">
                            <i class="fab fa-youtube"></i>
                        </a>
                        <a href="#" class="social-icon" aria-label="Blog">
                            <i class="fas fa-blog"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- 하단 정보 -->
            <div class="footer-bottom">
                <div class="footer-bottom-content">
                    <div class="footer-legal-links">
                        <a href="#">이용약관</a>
                        <a href="#" style="font-weight: 600; color: #3498db;">개인정보처리방침</a>
                        <a href="#">이메일무단수집거부</a>
                    </div>
                    <p>
                        사업자등록번호: 123-45-67890 | 대표: 홍길동 | 통신판매업신고: 제2024-서울종로-0000호
                    </p>
                    <p>
                        주소: 서울특별시 종로구 세종대로 209 (복지로 빌딩)
                    </p>
                    <p style="margin-top: 10px;">
                        Copyright &copy; 2024 복지24. All rights reserved.
                    </p>
                </div>
            </div>
        </div>
    </footer>

    <script>
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
