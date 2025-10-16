<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자주묻는 질문 - 복지24</title>
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

        .faq-categories {
            display: flex;
            gap: 15px;
            margin-bottom: 40px;
            margin-top: 10px;
            justify-content: center;
            flex-wrap: wrap;
            align-items: center;
        }

        .ask-question-btn {
            padding: 12px 24px;
            background: #4A90E2;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.2s ease;
            font-size: 15px;
            font-weight: 600;
            margin-right: auto;
        }

        .ask-question-btn:hover {
            background-color: #357ABD;
        }

        .category-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .category-btn {
            padding: 12px 24px;
            border: 2px solid #dee2e6;
            background: white;
            color: #495057;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.2s ease;
            font-size: 15px;
            font-weight: 600;
        }

        .category-btn:hover {
            background-color: #e9ecef;
        }

        .category-btn.active {
            background-color: #4A90E2;
            color: white;
            border-color: #4A90E2;
        }

        .faq-list {
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .faq-item {
            border-bottom: 1px solid #e9ecef;
        }

        .faq-item:last-child {
            border-bottom: none;
        }

        .faq-question {
            padding: 25px 30px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 15px;
            transition: background-color 0.2s ease;
        }

        .faq-question:hover {
            background-color: #f8f9fa;
        }

        .faq-icon {
            width: 32px;
            height: 32px;
            background-color: #4A90E2;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            flex-shrink: 0;
        }

        .faq-question-text {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            flex: 1;
        }

        .faq-toggle {
            color: #6c757d;
            transition: transform 0.3s ease;
        }

        .faq-toggle.active {
            transform: rotate(180deg);
        }

        .faq-answer {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease, padding 0.3s ease;
            background-color: #f8f9fa;
        }

        .faq-answer.active {
            max-height: 500px;
            padding: 25px 30px 25px 77px;
        }

        .faq-answer-text {
            font-size: 15px;
            color: #495057;
            line-height: 1.8;
        }

        .search-box {
            max-width: 600px;
            margin: 0 auto 40px;
            position: relative;
            z-index: 100;
        }

        .search-input {
            width: 100%;
            padding: 15px 50px 15px 20px;
            border: 2px solid #dee2e6;
            border-radius: 25px;
            font-size: 16px;
            transition: border-color 0.2s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: #4A90E2;
        }

        .search-input.autocomplete-active {
            border-radius: 25px 25px 0 0;
            border-bottom-color: #4A90E2;
        }

        .search-icon {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            cursor: pointer;
            transition: color 0.2s ease;
        }

        .search-icon:hover {
            color: #4A90E2;
        }

        .search-autocomplete {
            position: absolute;
            top: calc(100% - 2px);
            left: 0;
            right: 0;
            background: white;
            border: 2px solid #4A90E2;
            border-top: none;
            border-radius: 0 0 15px 15px;
            max-height: 250px;
            overflow-y: auto;
            box-shadow: 0 4px 8px rgba(0,0,0,0.08);
            display: none;
            z-index: 1001;
        }

        .search-autocomplete.active {
            display: block;
        }

        .autocomplete-item {
            padding: 12px 20px;
            cursor: pointer;
            transition: background-color 0.2s ease;
            font-size: 15px;
            color: #495057;
        }

        .autocomplete-item:hover {
            background-color: #f8f9fa;
        }

        .autocomplete-item strong {
            color: #4A90E2;
            font-weight: 600;
        }

        .autocomplete-empty {
            padding: 12px 20px;
            text-align: center;
            color: #6c757d;
            font-size: 14px;
        }

        .question-section {
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            max-height: 0;
            overflow: hidden;
            opacity: 0;
            padding: 0 40px;
            margin-bottom: 30px;
            transition: max-height 0.5s ease, opacity 0.5s ease, padding 0.5s ease, margin-bottom 0.5s ease;
        }

        .question-section.active {
            max-height: 1000px;
            opacity: 1;
            padding: 40px;
            margin-bottom: 30px;
        }

        .question-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .question-title {
            font-size: 28px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .question-subtitle {
            font-size: 16px;
            color: #6c757d;
        }

        .question-form {
            max-width: 800px;
            margin: 0 auto;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            font-size: 15px;
            font-weight: 600;
            color: #495057;
            margin-bottom: 10px;
        }

        .form-label .required {
            color: #dc3545;
        }

        .form-input,
        .form-textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            font-size: 15px;
            font-family: inherit;
            transition: border-color 0.2s ease;
        }

        .form-input:focus,
        .form-textarea:focus {
            outline: none;
            border-color: #4A90E2;
        }

        .form-textarea {
            resize: vertical;
            min-height: 150px;
        }

        .submit-btn {
            width: 100%;
            padding: 15px;
            background-color: #4A90E2;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .submit-btn:hover {
            background-color: #357ABD;
        }

        .form-info {
            background: #e3f2fd;
            border-left: 4px solid #4A90E2;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        .form-info p {
            font-size: 14px;
            color: #495057;
            line-height: 1.6;
            margin: 0;
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
            <h1 class="page-title">자주묻는 질문</h1>
            <p class="page-subtitle">궁금한 점을 빠르게 찾아보세요</p>
        </div>

        <div class="search-box">
            <input type="text" class="search-input" id="searchInput" placeholder="질문을 검색하세요..." autocomplete="off">
            <i class="fas fa-search search-icon" id="searchIcon"></i>
            <div class="search-autocomplete" id="searchAutocomplete"></div>
        </div>

        <div class="faq-categories">
            <button class="ask-question-btn" id="askQuestionBtn">
                <i class="fas fa-plus"></i> 질문하기
            </button>
            <div class="category-buttons">
                <button class="category-btn active" data-category="all">전체</button>
                <button class="category-btn" data-category="welfare">복지혜택</button>
                <button class="category-btn" data-category="service">서비스이용</button>
                <button class="category-btn" data-category="account">계정관리</button>
                <button class="category-btn" data-category="etc">기타</button>
            </div>
        </div>

        <!-- 질문하기 섹션 -->
        <div class="question-section">
            <div class="question-header">
                <h2 class="question-title">찾으시는 답변이 없으신가요?</h2>
                <p class="question-subtitle">궁금한 점을 남겨주시면 빠르게 답변 드리겠습니다</p>
            </div>

            <form class="question-form" onsubmit="submitQuestion(event)">
                <div class="form-info">
                    <p><i class="fas fa-info-circle"></i> 답변은 등록하신 이메일로 발송되며, 영업일 기준 1-2일 이내에 답변드립니다.</p>
                </div>

                <div class="form-group">
                    <label class="form-label">질문 제목 <span class="required">*</span></label>
                    <input type="text" class="form-input" name="title" placeholder="질문 제목을 입력하세요" required>
                </div>

                <div class="form-group">
                    <label class="form-label">질문 내용 <span class="required">*</span></label>
                    <textarea class="form-textarea" name="content" placeholder="궁금한 내용을 자세히 입력해주세요" required></textarea>
                </div>

                <button type="submit" class="submit-btn">
                    <i class="fas fa-paper-plane"></i> 질문 보내기
                </button>
            </form>
        </div>

        <div class="faq-list">
            <div class="faq-item" data-category="welfare">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <div class="faq-icon">Q</div>
                    <div class="faq-question-text">복지 혜택은 어떻게 찾나요?</div>
                    <i class="fas fa-chevron-down faq-toggle"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-text">
                        메인 페이지에서 '복지 혜택 찾기' 메뉴를 클릭하시면 간단한 정보 입력 후 맞춤형 복지 혜택을 추천받으실 수 있습니다.
                        나이, 가구 구성, 소득 수준 등의 정보를 입력하시면 AI가 자동으로 적합한 복지 서비스를 매칭해 드립니다.
                    </div>
                </div>
            </div>

            <div class="faq-item" data-category="welfare">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <div class="faq-icon">Q</div>
                    <div class="faq-question-text">복지 혜택 신청은 어떻게 하나요?</div>
                    <i class="fas fa-chevron-down faq-toggle"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-text">
                        복지 혜택 검색 결과에서 원하는 혜택의 '신청하기' 버튼을 클릭하시면 해당 기관의 신청 페이지로 이동합니다.
                        온라인 신청이 가능한 경우 바로 신청이 가능하며, 방문 신청이 필요한 경우 주변 시설 정보를 안내해 드립니다.
                    </div>
                </div>
            </div>

            <div class="faq-item" data-category="service">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <div class="faq-icon">Q</div>
                    <div class="faq-question-text">복지 지도는 어떻게 사용하나요?</div>
                    <i class="fas fa-chevron-down faq-toggle"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-text">
                        '복지 지도' 메뉴에서 현재 위치 또는 주소를 입력하시면 주변의 복지시설을 지도에서 확인하실 수 있습니다.
                        복지관, 주민센터, 상담센터 등 다양한 시설의 위치, 연락처, 운영시간 정보를 제공합니다.
                    </div>
                </div>
            </div>

            <div class="faq-item" data-category="account">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <div class="faq-icon">Q</div>
                    <div class="faq-question-text">회원가입은 필수인가요?</div>
                    <i class="fas fa-chevron-down faq-toggle"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-text">
                        복지 혜택 검색과 정보 조회는 회원가입 없이도 가능합니다. 다만, 맞춤형 추천 서비스와 신청 내역 관리를 위해서는
                        회원가입이 필요합니다. 회원가입 시 더욱 편리하게 서비스를 이용하실 수 있습니다.
                    </div>
                </div>
            </div>

            <div class="faq-item" data-category="account">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <div class="faq-icon">Q</div>
                    <div class="faq-question-text">비밀번호를 잊어버렸어요</div>
                    <i class="fas fa-chevron-down faq-toggle"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-text">
                        로그인 페이지에서 '비밀번호 찾기'를 클릭하시면 가입 시 등록한 이메일 또는 휴대폰 번호로 임시 비밀번호를 발송해 드립니다.
                        임시 비밀번호로 로그인 후 마이페이지에서 새로운 비밀번호로 변경해 주세요.
                    </div>
                </div>
            </div>

            <div class="faq-item" data-category="welfare">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <div class="faq-icon">Q</div>
                    <div class="faq-question-text">저소득층 기준은 어떻게 되나요?</div>
                    <i class="fas fa-chevron-down faq-toggle"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-text">
                        저소득층 기준은 정부 정책에 따라 변동될 수 있으며, 일반적으로 기준 중위소득의 일정 비율 이하를 기준으로 합니다.
                        정확한 기준은 복지 혜택 찾기에서 소득 정보 입력 시 자동으로 판단되어 적용됩니다.
                    </div>
                </div>
            </div>

            <div class="faq-item" data-category="service">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <div class="faq-icon">Q</div>
                    <div class="faq-question-text">개인정보는 안전한가요?</div>
                    <i class="fas fa-chevron-down faq-toggle"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-text">
                        복지24는 개인정보보호법에 따라 모든 개인정보를 암호화하여 안전하게 관리하고 있습니다.
                        수집된 정보는 복지 서비스 매칭 목적으로만 사용되며, 제3자에게 제공되지 않습니다.
                        자세한 내용은 개인정보 처리방침을 참고해 주세요.
                    </div>
                </div>
            </div>

            <div class="faq-item" data-category="etc">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <div class="faq-icon">Q</div>
                    <div class="faq-question-text">서비스 이용 중 오류가 발생했어요</div>
                    <i class="fas fa-chevron-down faq-toggle"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-text">
                        서비스 이용 중 오류가 발생하신 경우 페이지를 새로고침하거나 브라우저 캐시를 삭제해 보세요.
                        문제가 계속되는 경우 고객센터(1544-1234)로 문의하시거나 온라인 채팅 상담을 이용해 주세요.
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function toggleFAQ(element) {
            const answer = element.nextElementSibling;
            const toggle = element.querySelector('.faq-toggle');
            const allAnswers = document.querySelectorAll('.faq-answer');
            const allToggles = document.querySelectorAll('.faq-toggle');

            // 다른 FAQ 닫기
            allAnswers.forEach(item => {
                if (item !== answer) {
                    item.classList.remove('active');
                }
            });
            allToggles.forEach(item => {
                if (item !== toggle) {
                    item.classList.remove('active');
                }
            });

            // 현재 FAQ 토글
            answer.classList.toggle('active');
            toggle.classList.toggle('active');
        }

        // 질문 제출
        function submitQuestion(event) {
            event.preventDefault();

            const formData = new FormData(event.target);
            const data = {
                title: formData.get('title'),
                content: formData.get('content')
            };

            // TODO: 서버로 데이터 전송 (Ajax 호출)
            // 로그인 확인 후 회원 정보와 함께 전송
            console.log('질문 제출:', data);

            // 임시 알림
            alert('질문이 성공적으로 접수되었습니다.\n등록하신 이메일로 답변을 보내드리겠습니다.');
            event.target.reset();
        }

        // 질문하기 버튼 토글
        function toggleQuestionSection() {
            const questionSection = document.querySelector('.question-section');
            const askQuestionBtn = document.getElementById('askQuestionBtn');
            const isActive = questionSection.classList.toggle('active');

            // 버튼 아이콘 변경
            if (isActive) {
                askQuestionBtn.innerHTML = '<i class="fas fa-minus"></i> 질문 접기';
            } else {
                askQuestionBtn.innerHTML = '<i class="fas fa-plus"></i> 질문하기';
            }
        }

        // 검색 기능 (아이콘 클릭 또는 Enter 키로만 실행)
        function searchFAQ() {
            const searchInput = document.getElementById('searchInput');
            const searchText = searchInput.value.toLowerCase().trim();
            const faqItems = document.querySelectorAll('.faq-item');
            const activeCategoryBtn = document.querySelector('.category-btn.active');
            const activeCategory = activeCategoryBtn ? activeCategoryBtn.dataset.category : 'all';
            let visibleCount = 0;

            // 자동완성 숨기기
            hideAutocomplete();

            // 검색 시 카테고리를 "전체"로 리셋
            if (searchText !== '') {
                document.querySelectorAll('.category-btn').forEach(btn => btn.classList.remove('active'));
                document.querySelector('.category-btn[data-category="all"]').classList.add('active');
            }

            faqItems.forEach(item => {
                const questionText = item.querySelector('.faq-question-text').textContent.toLowerCase();
                const answerText = item.querySelector('.faq-answer-text').textContent.toLowerCase();
                const itemCategory = item.dataset.category;

                // 검색어와 카테고리 필터 모두 확인
                const matchesSearch = searchText === '' || questionText.includes(searchText) || answerText.includes(searchText);
                const matchesCategory = activeCategory === 'all' || itemCategory === activeCategory;

                if (matchesSearch && matchesCategory) {
                    item.style.display = 'block';
                    visibleCount++;
                } else {
                    item.style.display = 'none';
                }
            });
        }

        // 자동완성 표시
        function showAutocomplete() {
            const searchInput = document.getElementById('searchInput');
            const searchText = searchInput.value.toLowerCase().trim();
            const autocompleteDiv = document.getElementById('searchAutocomplete');
            const faqItems = document.querySelectorAll('.faq-item');

            if (searchText === '') {
                hideAutocomplete();
                return;
            }

            let matches = [];
            faqItems.forEach(item => {
                const questionText = item.querySelector('.faq-question-text').textContent;
                if (questionText.toLowerCase().includes(searchText)) {
                    matches.push(questionText);
                }
            });

            // 중복 제거
            matches = [...new Set(matches)];

            if (matches.length > 0) {
                let html = '';
                matches.slice(0, 5).forEach(function(match) {
                    const highlighted = highlightMatch(match, searchText);
                    const escapedMatch = match.replace(/'/g, "\\'");
                    html += '<div class="autocomplete-item" onclick="selectAutocomplete(\'' + escapedMatch + '\')">' + highlighted + '</div>';
                });
                autocompleteDiv.innerHTML = html;
                autocompleteDiv.classList.add('active');
                searchInput.classList.add('autocomplete-active');
            } else {
                autocompleteDiv.innerHTML = '<div class="autocomplete-empty">검색 결과가 없습니다</div>';
                autocompleteDiv.classList.add('active');
                searchInput.classList.add('autocomplete-active');
            }
        }

        // 자동완성 숨기기
        function hideAutocomplete() {
            const autocompleteDiv = document.getElementById('searchAutocomplete');
            const searchInput = document.getElementById('searchInput');
            autocompleteDiv.classList.remove('active');
            searchInput.classList.remove('autocomplete-active');
        }

        // 검색어 하이라이트
        function highlightMatch(text, search) {
            const regex = new RegExp('(' + search + ')', 'gi');
            return text.replace(regex, '<strong>$1</strong>');
        }

        // 자동완성 항목 선택
        function selectAutocomplete(text) {
            const searchInput = document.getElementById('searchInput');
            searchInput.value = text;
            searchFAQ();
        }

        // DOM이 완전히 로드된 후 실행
        document.addEventListener('DOMContentLoaded', function() {
            // 질문하기 버튼 이벤트
            const askQuestionBtn = document.getElementById('askQuestionBtn');
            if (askQuestionBtn) {
                askQuestionBtn.addEventListener('click', toggleQuestionSection);
            }

            // 검색 기능
            const searchInput = document.getElementById('searchInput');
            const searchIcon = document.getElementById('searchIcon');

            if (searchInput) {
                // 입력 시 자동완성 표시
                searchInput.addEventListener('input', showAutocomplete);

                // Enter 키로 검색
                searchInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        searchFAQ();
                    }
                });
            }

            if (searchIcon) {
                // 검색 아이콘 클릭으로 검색
                searchIcon.addEventListener('click', searchFAQ);
            }

            // 외부 클릭 시 자동완성 숨기기
            document.addEventListener('click', function(e) {
                const searchBox = document.querySelector('.search-box');
                if (searchBox && !searchBox.contains(e.target)) {
                    hideAutocomplete();
                }
            });

            // 카테고리 필터링
            const categoryBtns = document.querySelectorAll('.category-btn');
            if (categoryBtns) {
                categoryBtns.forEach(btn => {
                    btn.addEventListener('click', function() {
                        const category = this.dataset.category;
                        const searchInput = document.getElementById('searchInput');
                        const searchText = searchInput.value.toLowerCase().trim();

                        // 버튼 활성화 상태 변경
                        document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
                        this.classList.add('active');

                        // FAQ 아이템 필터링 (검색어도 고려)
                        document.querySelectorAll('.faq-item').forEach(item => {
                            const questionText = item.querySelector('.faq-question-text').textContent.toLowerCase();
                            const answerText = item.querySelector('.faq-answer-text').textContent.toLowerCase();
                            const itemCategory = item.dataset.category;

                            const matchesSearch = searchText === '' || questionText.includes(searchText) || answerText.includes(searchText);
                            const matchesCategory = category === 'all' || itemCategory === category;

                            if (matchesSearch && matchesCategory) {
                                item.style.display = 'block';
                            } else {
                                item.style.display = 'none';
                            }
                        });
                    });
                });
            }

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
