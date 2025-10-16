<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>봉사 신청 - 복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        html,
        body {
            width: 100%;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            overflow-x: hidden;
            background-color: #e2f0f6;
        }
        * {
            box-sizing: border-box;
        }
        body {
            position: relative;
            background-color: #fafafa;
            color: #191918;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }

        /* Header Styles */
        #main-header {
            position: sticky;
            top: 0;
            z-index: 1000;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        .navbar {
            background-color: transparent;
            padding: 0 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 60px;
        }
        .navbar-left {
            flex-shrink: 0;
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
            background-image: url("resources/image/복지로고.png");
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
        }
        .logo-text {
            font-size: 24px;
            font-weight: 700;
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

        /* Step Indicator */
        .step-indicator {
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 40px auto;
            gap: 20px;
            max-width: 1400px;
        }

        .step {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .step-number {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: #ddd;
            color: #666;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
        }

        .step-number.active {
            background: #4a90e2;
            color: white;
        }

        .step-text {
            font-size: 14px;
            color: #666;
        }

        .step-text.active {
            color: #333;
            font-weight: 600;
        }

        .step-connector {
            width: 40px;
            height: 2px;
            background: #ddd;
        }

        /* Main Container */
        #volunteer-container {
            position: relative;
            width: 100%;
            max-width: 1400px;
            overflow: visible;
            min-height: 1000px;
            background-color: #fafafa;
            color: #191918;
            margin: 0 auto 40px;
            padding: 40px 20px 100px 20px;
        }

        .volunteer-step {
            display: flex;
            width: 100%;
            gap: 30px;
            transition: transform 0.5s ease-in-out, opacity 0.5s ease-in-out;
        }

        #volunteer-step1 {
            gap: 30px;
        }

        #volunteer-step2,
        #volunteer-step3 {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            opacity: 0;
            visibility: hidden;
            transform: translateX(100%);
            transition: all 0.5s ease-in-out;
        }

        #volunteer-container.view-step2 #volunteer-step1 {
            opacity: 0;
            visibility: hidden;
            transform: translateX(-100%);
        }

        #volunteer-container.view-step2 #volunteer-step2 {
            opacity: 1;
            visibility: visible;
            transform: translateX(0);
        }

        #volunteer-container.view-step3 #volunteer-step1,
        #volunteer-container.view-step3 #volunteer-step2 {
            opacity: 0;
            visibility: hidden;
            transform: translateX(-100%);
        }

        #volunteer-container.view-step3 #volunteer-step3 {
            opacity: 1;
            visibility: visible;
            transform: translateX(0);
        }

        .volunteer-box {
            width: 100%;
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
        }

        .volunteer-title {
            font-size: 28px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
        }

        .volunteer-subtitle {
            font-size: 14px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.5;
        }

        /* Volunteer Categories */
        .volunteer-categories {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .volunteer-category {
            display: flex;
            flex-direction: column;
            padding: 25px 20px;
            background: #f8f9fa;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .volunteer-category:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }

        .volunteer-category.selected {
            background: #e3f2fd;
            border-color: #4a90e2;
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
        }

        .category-icon {
            width: 50px;
            height: 50px;
            background: #fff;
            border-radius: 10px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
        }

        .category-title {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }

        .category-desc {
            font-size: 13px;
            color: #666;
            line-height: 1.4;
        }

        /* Form Styles */
        .volunteer-form {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px 40px;
            margin-top: 30px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .form-group.full-width {
            grid-column: span 2;
        }

        .form-label {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }

        .form-input,
        .form-select,
        .form-textarea {
            width: 100%;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            outline: none;
        }

        .form-input:focus,
        .form-select:focus,
        .form-textarea:focus {
            border-color: #4a90e2;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }

        .form-textarea {
            resize: vertical;
            min-height: 120px;
            font-family: inherit;
        }

        .form-select {
            background: white;
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath fill='none' stroke='%23666' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 16px;
        }

        .date-time-group {
            display: flex;
            gap: 10px;
        }

        .date-time-group .form-input {
            flex: 1;
        }

        .address-row {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
        }

        .address-group {
            flex: 1;
            display: flex;
            gap: 10px;
        }

        .address-group .form-input {
            flex: 1;
        }

        #searchAddressBtn {
            background: #4a90e2;
            color: white;
            border: none;
            padding: 15px 25px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.3s ease;
            white-space: nowrap;
        }

        #searchAddressBtn:hover {
            background: #357abd;
        }

        /* Radio Group */
        .radio-group {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .radio-group div {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .radio-group input[type="radio"] {
            margin: 0;
            cursor: pointer;
        }

        .radio-group label {
            font-size: 15px;
            color: #333;
            cursor: pointer;
            margin: 0;
        }

        /* Navigation Buttons */
        .form-navigation-btns {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            margin-top: 40px;
        }

        .back-btn {
            background: #6c757d;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .back-btn:hover {
            background: #5a6268;
        }

        .next-btn {
            background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .next-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(74, 144, 226, 0.3);
        }

        /* Summary Box */
        .summary-box {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 30px;
        }

        .summary-title {
            font-size: 20px;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #e0e0e0;
        }

        .summary-item:last-child {
            border-bottom: none;
        }

        .summary-label {
            font-weight: 500;
            color: #666;
        }

        .summary-value {
            color: #4a90e2;
            font-weight: 600;
        }

        /* Agreement Section */
        .agreement-section {
            margin-top: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
        }

        .agreement-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 14px;
        }

        .agreement-item label {
            display: flex;
            align-items: center;
            cursor: pointer;
            margin: 0;
            flex-grow: 1;
        }

        .agreement-item input[type="checkbox"] {
            margin-right: 10px;
            cursor: pointer;
        }

        .agreement-item.all-agree {
            font-weight: 600;
            padding-bottom: 12px;
            border-bottom: 1px solid #ddd;
            margin-bottom: 15px;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .volunteer-categories {
                grid-template-columns: repeat(2, 1fr);
            }
            .volunteer-form {
                grid-template-columns: 1fr;
            }
            .form-group.full-width {
                grid-column: span 1;
            }
        }

        @media (max-width: 768px) {
            .nav-menu {
                display: none;
            }
            .navbar {
                padding: 0 15px;
            }
            .volunteer-categories {
                grid-template-columns: 1fr;
            }
            .date-time-group {
                flex-direction: column;
            }
            .radio-group {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
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
                    <a href="#" class="nav-link active" data-menu="volunteer">봉사하기</a>
                </div>
                <div class="nav-item">
                    <a href="#" class="nav-link" data-menu="donate">기부하기</a>
                </div>
            </div>
            <div class="navbar-right">
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
                    <a href="/bdproject/project_volunteer.jsp" class="dropdown-link">
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
                </div>
            </div>
        </div>
    </header>

    <!-- Step Indicator -->
    <div class="step-indicator">
        <div class="step">
            <div class="step-number active" id="step1Number">1</div>
            <div class="step-text active" id="step1Text">봉사 활동 선택</div>
        </div>
        <div class="step-connector"></div>
        <div class="step">
            <div class="step-number" id="step2Number">2</div>
            <div class="step-text" id="step2Text">봉사자 정보</div>
        </div>
        <div class="step-connector"></div>
        <div class="step">
            <div class="step-number" id="step3Number">3</div>
            <div class="step-text" id="step3Text">신청 완료</div>
        </div>
    </div>

    <div id="volunteer-container">
        <!-- Step 1: Volunteer Activity Selection -->
        <div id="volunteer-step1" class="volunteer-step">
            <div class="volunteer-box">
                <h2 class="volunteer-title">봉사 활동 선택</h2>
                <p class="volunteer-subtitle">관심 있는 봉사 활동 분야를 선택해주세요.</p>

                <div class="volunteer-categories">
                    <div class="volunteer-category" data-category="노인돌봄">
                        <div class="category-icon">
                            <i class="fas fa-hands-helping" style="color: #e74c3c; font-size: 24px"></i>
                        </div>
                        <div class="category-title">노인 돌봄</div>
                        <div class="category-desc">어르신들과 함께하는 시간을 통해 따뜻한 마음을 나눠보세요.</div>
                    </div>

                    <div class="volunteer-category" data-category="환경보호">
                        <div class="category-icon">
                            <i class="fas fa-leaf" style="color: #2ecc71; font-size: 24px"></i>
                        </div>
                        <div class="category-title">환경 보호</div>
                        <div class="category-desc">깨끗한 환경을 위한 실천 활동에 동참해주세요.</div>
                    </div>

                    <div class="volunteer-category" data-category="아동교육">
                        <div class="category-icon">
                            <i class="fas fa-book-reader" style="color: #3498db; font-size: 24px"></i>
                        </div>
                        <div class="category-title">아동 교육</div>
                        <div class="category-desc">아이들의 꿈을 키워주는 교육 봉사에 참여하세요.</div>
                    </div>

                    <div class="volunteer-category" data-category="장애인지원">
                        <div class="category-icon">
                            <i class="fas fa-wheelchair" style="color: #9b59b6; font-size: 24px"></i>
                        </div>
                        <div class="category-title">장애인 지원</div>
                        <div class="category-desc">장애인의 일상을 돕고 함께 성장하는 시간을 가져보세요.</div>
                    </div>

                    <div class="volunteer-category" data-category="재능기부">
                        <div class="category-icon">
                            <i class="fas fa-palette" style="color: #f39c12; font-size: 24px"></i>
                        </div>
                        <div class="category-title">재능 기부</div>
                        <div class="category-desc">내 재능을 나누며 더 나은 사회를 만들어보세요.</div>
                    </div>

                    <div class="volunteer-category" data-category="반려동물">
                        <div class="category-icon">
                            <i class="fas fa-paw" style="color: #e67e22; font-size: 24px"></i>
                        </div>
                        <div class="category-title">반려동물 돌봄</div>
                        <div class="category-desc">유기동물 보호와 돌봄 활동에 함께해주세요.</div>
                    </div>
                </div>

                <div class="volunteer-form">
                    <div class="form-group">
                        <label class="form-label" for="region">지역 선택</label>
                        <select class="form-select" id="region" required>
                            <option value="">지역을 선택하세요</option>
                            <option value="서울">서울특별시</option>
                            <option value="경기">경기도</option>
                            <option value="인천">인천광역시</option>
                            <option value="부산">부산광역시</option>
                            <option value="대구">대구광역시</option>
                            <option value="광주">광주광역시</option>
                            <option value="대전">대전광역시</option>
                            <option value="울산">울산광역시</option>
                            <option value="세종">세종특별자치시</option>
                            <option value="강원">강원도</option>
                            <option value="충북">충청북도</option>
                            <option value="충남">충청남도</option>
                            <option value="전북">전라북도</option>
                            <option value="전남">전라남도</option>
                            <option value="경북">경상북도</option>
                            <option value="경남">경상남도</option>
                            <option value="제주">제주특별자치도</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="preferredDate">희망 봉사 기간</label>
                        <div class="date-time-group">
                            <input type="date" class="form-input" id="startDate" required>
                            <span style="display: flex; align-items: center;">~</span>
                            <input type="date" class="form-input" id="endDate" required>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label" for="availableTime">참여 가능 시간대</label>
                        <div class="radio-group">
                            <div>
                                <input type="radio" id="time_morning" name="availableTime" value="오전">
                                <label for="time_morning">오전 (09:00-12:00)</label>
                            </div>
                            <div>
                                <input type="radio" id="time_afternoon" name="availableTime" value="오후">
                                <label for="time_afternoon">오후 (13:00-18:00)</label>
                            </div>
                            <div>
                                <input type="radio" id="time_allday" name="availableTime" value="종일">
                                <label for="time_allday">종일</label>
                            </div>
                            <div>
                                <input type="radio" id="time_flexible" name="availableTime" value="조율가능">
                                <label for="time_flexible">조율 가능</label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-navigation-btns">
                    <div></div>
                    <button class="next-btn" id="nextBtn">다음</button>
                </div>
            </div>
        </div>

        <!-- Step 2: Volunteer Information -->
        <div id="volunteer-step2" class="volunteer-step">
            <div class="volunteer-box">
                <h2 class="volunteer-title">봉사자 정보</h2>
                <p class="volunteer-subtitle">봉사 활동을 위한 정보를 입력해주세요.</p>

                <form class="volunteer-form" id="volunteerForm">
                    <div class="form-group">
                        <label class="form-label" for="volunteerName">이름</label>
                        <input type="text" id="volunteerName" class="form-input" placeholder="이름을 입력하세요" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="volunteerPhone">전화번호</label>
                        <input type="text" id="volunteerPhone" class="form-input" placeholder="'-' 없이 숫자만 입력" maxlength="11" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="volunteerEmail">이메일</label>
                        <input type="email" id="volunteerEmail" class="form-input" placeholder="example@email.com" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="volunteerBirth">생년월일</label>
                        <input type="text" id="volunteerBirth" class="form-input" placeholder="8자리 입력 (예: 19900101)" maxlength="8" required>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">주소</label>
                        <div class="address-row">
                            <div class="address-group">
                                <input type="text" id="postcode" class="form-input" placeholder="우편번호" readonly>
                                <button type="button" id="searchAddressBtn">주소검색</button>
                            </div>
                            <input type="text" id="address" class="form-input" placeholder="주소" readonly style="flex: 2;">
                        </div>
                        <input type="text" id="detailAddress" class="form-input" placeholder="상세주소">
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label" for="experience">봉사 경험</label>
                        <div class="radio-group">
                            <div>
                                <input type="radio" id="exp_none" name="experience" value="없음">
                                <label for="exp_none">없음</label>
                            </div>
                            <div>
                                <input type="radio" id="exp_beginner" name="experience" value="1년 미만">
                                <label for="exp_beginner">1년 미만</label>
                            </div>
                            <div>
                                <input type="radio" id="exp_intermediate" name="experience" value="1-3년">
                                <label for="exp_intermediate">1-3년</label>
                            </div>
                            <div>
                                <input type="radio" id="exp_expert" name="experience" value="3년 이상">
                                <label for="exp_expert">3년 이상</label>
                            </div>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label" for="motivation">지원 동기</label>
                        <textarea id="motivation" class="form-textarea" placeholder="봉사 활동에 참여하고자 하는 동기를 간단히 작성해주세요."></textarea>
                    </div>
                </form>

                <div class="form-navigation-btns">
                    <button class="back-btn" id="backBtn">뒤로</button>
                    <button class="next-btn" id="goToStep3Btn">다음</button>
                </div>
            </div>
        </div>

        <!-- Step 3: Confirmation -->
        <div id="volunteer-step3" class="volunteer-step">
            <div class="volunteer-box">
                <h2 class="volunteer-title">신청 정보 확인</h2>
                <p class="volunteer-subtitle">입력하신 정보를 확인해주세요.</p>

                <div class="summary-box">
                    <h3 class="summary-title">봉사 활동 정보</h3>
                    <div class="summary-item">
                        <span class="summary-label">선택한 봉사 활동</span>
                        <span class="summary-value" id="summary-category">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">지역</span>
                        <span class="summary-value" id="summary-region">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">봉사 기간</span>
                        <span class="summary-value" id="summary-date">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">참여 시간대</span>
                        <span class="summary-value" id="summary-time">-</span>
                    </div>
                </div>

                <div class="summary-box">
                    <h3 class="summary-title">봉사자 정보</h3>
                    <div class="summary-item">
                        <span class="summary-label">이름</span>
                        <span class="summary-value" id="summary-name">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">전화번호</span>
                        <span class="summary-value" id="summary-phone">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">이메일</span>
                        <span class="summary-value" id="summary-email">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">주소</span>
                        <span class="summary-value" id="summary-address">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">봉사 경험</span>
                        <span class="summary-value" id="summary-experience">-</span>
                    </div>
                </div>

                <div class="agreement-section">
                    <div class="agreement-item all-agree">
                        <label>
                            <input type="checkbox" id="agreeAll">
                            개인정보 수집 및 이용에 모두 동의합니다.
                        </label>
                    </div>
                    <div class="agreement-item">
                        <label>
                            <input type="checkbox" class="agree-item">
                            개인정보 수집 및 이용 동의 (필수)
                        </label>
                    </div>
                    <div class="agreement-item">
                        <label>
                            <input type="checkbox" class="agree-item">
                            봉사 활동 안내 및 알림 수신 동의 (선택)
                        </label>
                    </div>
                </div>

                <div class="form-navigation-btns">
                    <button class="back-btn" id="backToStep2Btn">뒤로</button>
                    <button class="next-btn" id="finalSubmitBtn">신청 완료</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Daum Postcode API -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <script>
        // 봉사 신청 데이터 저장 객체
        let volunteerData = {
            category: '',
            region: '',
            startDate: '',
            endDate: '',
            availableTime: '',
            name: '',
            phone: '',
            email: '',
            birth: '',
            postcode: '',
            address: '',
            detailAddress: '',
            experience: '',
            motivation: ''
        };

        document.addEventListener('DOMContentLoaded', function() {
            // Step indicator update
            function updateStepIndicator(currentStep) {
                document.querySelectorAll('.step-number, .step-text').forEach(element => {
                    element.classList.remove('active');
                });

                if (currentStep === 1) {
                    document.getElementById('step1Number').classList.add('active');
                    document.getElementById('step1Text').classList.add('active');
                } else if (currentStep === 2) {
                    document.getElementById('step2Number').classList.add('active');
                    document.getElementById('step2Text').classList.add('active');
                } else if (currentStep === 3) {
                    document.getElementById('step3Number').classList.add('active');
                    document.getElementById('step3Text').classList.add('active');
                }
            }

            // 네비바 메뉴
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

            // 봉사 카테고리 선택
            const volunteerCategories = document.querySelectorAll('.volunteer-category');
            volunteerCategories.forEach(category => {
                category.addEventListener('click', function() {
                    volunteerCategories.forEach(cat => cat.classList.remove('selected'));
                    this.classList.add('selected');
                    volunteerData.category = this.dataset.category;
                });
            });

            // Step 1 -> Step 2
            const nextBtn = document.getElementById('nextBtn');
            const volunteerContainer = document.getElementById('volunteer-container');

            nextBtn.addEventListener('click', function() {
                // 검증
                if (!volunteerData.category) {
                    alert('봉사 활동 분야를 선택해주세요.');
                    return;
                }

                const region = document.getElementById('region').value;
                const startDate = document.getElementById('startDate').value;
                const endDate = document.getElementById('endDate').value;
                const availableTime = document.querySelector('input[name="availableTime"]:checked');

                if (!region) {
                    alert('지역을 선택해주세요.');
                    return;
                }
                if (!startDate || !endDate) {
                    alert('희망 봉사 기간을 선택해주세요.');
                    return;
                }
                if (!availableTime) {
                    alert('참여 가능 시간대를 선택해주세요.');
                    return;
                }

                // 데이터 저장
                volunteerData.region = region;
                volunteerData.startDate = startDate;
                volunteerData.endDate = endDate;
                volunteerData.availableTime = availableTime.value;

                // Step 2로 이동
                volunteerContainer.classList.add('view-step2');
                updateStepIndicator(2);
                window.scrollTo(0, 0);
            });

            // Step 2 -> Step 1 (뒤로가기)
            const backBtn = document.getElementById('backBtn');
            backBtn.addEventListener('click', function() {
                volunteerContainer.classList.remove('view-step2');
                updateStepIndicator(1);
                window.scrollTo(0, 0);
            });

            // Step 2 -> Step 3
            const goToStep3Btn = document.getElementById('goToStep3Btn');
            goToStep3Btn.addEventListener('click', function() {
                // 검증
                const name = document.getElementById('volunteerName').value;
                const phone = document.getElementById('volunteerPhone').value;
                const email = document.getElementById('volunteerEmail').value;
                const birth = document.getElementById('volunteerBirth').value;
                const address = document.getElementById('address').value;
                const experience = document.querySelector('input[name="experience"]:checked');

                if (!name) {
                    alert('이름을 입력해주세요.');
                    return;
                }
                if (!phone) {
                    alert('전화번호를 입력해주세요.');
                    return;
                }
                if (!email) {
                    alert('이메일을 입력해주세요.');
                    return;
                }
                if (!birth || birth.length !== 8) {
                    alert('생년월일을 8자리로 입력해주세요.');
                    return;
                }
                if (!address) {
                    alert('주소를 입력해주세요.');
                    return;
                }
                if (!experience) {
                    alert('봉사 경험을 선택해주세요.');
                    return;
                }

                // 데이터 저장
                volunteerData.name = name;
                volunteerData.phone = phone;
                volunteerData.email = email;
                volunteerData.birth = birth;
                volunteerData.postcode = document.getElementById('postcode').value;
                volunteerData.address = address;
                volunteerData.detailAddress = document.getElementById('detailAddress').value;
                volunteerData.experience = experience.value;
                volunteerData.motivation = document.getElementById('motivation').value;

                // 요약 정보 업데이트
                updateSummary();

                // Step 3으로 이동
                volunteerContainer.classList.add('view-step3');
                updateStepIndicator(3);
                window.scrollTo(0, 0);
            });

            // Step 3 -> Step 2 (뒤로가기)
            const backToStep2Btn = document.getElementById('backToStep2Btn');
            backToStep2Btn.addEventListener('click', function() {
                volunteerContainer.classList.remove('view-step3');
                updateStepIndicator(2);
                window.scrollTo(0, 0);
            });

            // 요약 정보 업데이트
            function updateSummary() {
                document.getElementById('summary-category').textContent = volunteerData.category;
                document.getElementById('summary-region').textContent = volunteerData.region;
                document.getElementById('summary-date').textContent = volunteerData.startDate + ' ~ ' + volunteerData.endDate;
                document.getElementById('summary-time').textContent = volunteerData.availableTime;
                document.getElementById('summary-name').textContent = volunteerData.name;
                document.getElementById('summary-phone').textContent = volunteerData.phone;
                document.getElementById('summary-email').textContent = volunteerData.email;

                let fullAddress = volunteerData.address;
                if (volunteerData.detailAddress) {
                    fullAddress += ', ' + volunteerData.detailAddress;
                }
                document.getElementById('summary-address').textContent = fullAddress;
                document.getElementById('summary-experience').textContent = volunteerData.experience;
            }

            // 주소 검색
            const searchAddressBtn = document.getElementById('searchAddressBtn');
            searchAddressBtn.addEventListener('click', function() {
                new daum.Postcode({
                    oncomplete: function(data) {
                        document.getElementById('postcode').value = data.zonecode;
                        document.getElementById('address').value = data.address;
                        document.getElementById('detailAddress').focus();
                    }
                }).open();
            });

            // 동의 체크박스
            const agreeAll = document.getElementById('agreeAll');
            const agreeItems = document.querySelectorAll('.agree-item');

            agreeAll.addEventListener('change', function() {
                agreeItems.forEach(item => {
                    item.checked = this.checked;
                });
            });

            agreeItems.forEach(item => {
                item.addEventListener('change', function() {
                    agreeAll.checked = Array.from(agreeItems).every(item => item.checked);
                });
            });

            // 최종 신청
            const finalSubmitBtn = document.getElementById('finalSubmitBtn');
            finalSubmitBtn.addEventListener('click', function() {
                // 필수 동의 확인
                const requiredAgree = agreeItems[0];
                if (!requiredAgree.checked) {
                    alert('개인정보 수집 및 이용에 동의해주세요.');
                    return;
                }

                alert(volunteerData.name + '님의 봉사 신청이 완료되었습니다.\n담당자가 확인 후 연락드리겠습니다.');

                setTimeout(() => {
                    window.location.href = '/bdproject/project.jsp';
                }, 1500);
            });

            // 사용자 아이콘
            const userIcon = document.getElementById('userIcon');
            if (userIcon) {
                userIcon.addEventListener('click', function() {
                    window.location.href = '/bdproject/projectLogin.jsp';
                });
            }

            // 초기화
            updateStepIndicator(1);
        });
    </script>
</body>
</html>
