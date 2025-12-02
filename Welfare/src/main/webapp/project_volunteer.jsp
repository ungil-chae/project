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

        /* 히어로 섹션 */
        .hero-section {
            background: #f8f9fa;
            color: #333;
            padding: 60px 20px 20px;
            text-align: left;
        }

        .hero-title {
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 15px;
            max-width: 1400px;
            margin-left: auto;
            margin-right: auto;
            padding: 0 40px;
        }

        .hero-title .highlight {
            color: #4a90e2;
        }

        .hero-subtitle {
            font-size: 18px;
            max-width: 1400px;
            margin-left: auto;
            margin-right: auto;
            padding: 0 40px;
            line-height: 1.6;
            color: #495057;
        }

        /* Step Indicator */
        .step-indicator {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .step {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .step-number {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #ddd;
            color: #666;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 12px;
        }

        .step-number.active {
            background: #4a90e2;
            color: white;
        }

        .step-text {
            font-size: 13px;
            color: #666;
            white-space: nowrap;
        }

        .step-text.active {
            color: #333;
            font-weight: 600;
        }

        .step-connector {
            width: 20px;
            height: 2px;
            background: #ddd;
        }

        /* Main Container */
        #volunteer-container {
            position: relative;
            width: 100%;
            max-width: 1400px;
            background-color: #fafafa;
            color: #191918;
            margin: 10px auto 40px;
            padding: 20px 20px 200px 20px;
            min-height: 900px;
            overflow: visible;
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
            display: flex;
            align-items: center;
            justify-content: space-between;
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

        /* 이메일 그룹 스타일 */
        .email-group {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .email-group .form-input {
            flex: 1;
        }

        .email-at {
            font-weight: 500;
            color: #666;
        }

        .email-group .form-select {
            flex: 0.8;
            padding: 15px;
            border: 2px solid #e8e8e8;
            border-radius: 8px;
            font-size: 15px;
            background-color: white;
            cursor: pointer;
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
            margin-bottom: 60px;
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
            margin-bottom: 40px;
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

        .social-links {
            display: flex;
            gap: 15px;
            margin-top: 10px;
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

        /* Google Translate Widget 스타일 (navbar.jsp로 이동됨) */
        .language-selector {
            position: relative;
            display: inline-block;
        }

        #google_translate_element {
            position: absolute;
            top: 100%;
            right: 0;
            margin-top: 10px;
            background: white;
            padding: 8px;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
            z-index: 9999;
            min-width: 180px;
        }

        .goog-te-banner-frame {
            display: none !important;
        }

        body {
            top: 0 !important;
        }

        .goog-te-gadget {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif !important;
            font-size: 0 !important;
        }

        .goog-te-gadget-simple {
            background-color: white !important;
            border: 2px solid #e9ecef !important;
            border-radius: 8px !important;
            font-size: 14px !important;
            padding: 10px 15px !important;
            display: inline-block !important;
            cursor: pointer !important;
            transition: all 0.2s !important;
        }

        .goog-te-gadget-simple:hover {
            border-color: #4A90E2 !important;
            background-color: #f8f9fa !important;
        }

        .goog-te-gadget-icon {
            display: none !important;
        }

        .goog-te-menu-value {
            color: #2c3e50 !important;
            font-weight: 500 !important;
        }

        .goog-te-menu-value span {
            color: #2c3e50 !important;
            font-size: 14px !important;
            font-weight: 500 !important;
        }

        .goog-te-menu-value span:first-child {
            display: none !important;
        }

        .goog-te-menu-value > span:before {
            content: '🌐 ' !important;
        }

        .goog-te-menu2 {
            border: none !important;
            border-radius: 12px !important;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15) !important;
            max-height: 450px !important;
            overflow-y: auto !important;
            padding: 8px 0 !important;
            background: white !important;
        }

        .goog-te-menu2-item {
            padding: 12px 20px !important;
            font-size: 14px !important;
            color: #2c3e50 !important;
            transition: all 0.2s !important;
            border-left: 3px solid transparent !important;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif !important;
        }

        .goog-te-menu2-item:hover {
            background-color: #f8f9fa !important;
            border-left-color: #4A90E2 !important;
        }

        .goog-te-menu2-item-selected {
            background-color: #e3f2fd !important;
            color: #4A90E2 !important;
            font-weight: 600 !important;
            border-left-color: #4A90E2 !important;
        }

        .goog-te-menu2-item div {
            color: inherit !important;
        }

        .goog-te-menu2::-webkit-scrollbar {
            width: 8px !important;
        }

        .goog-te-menu2::-webkit-scrollbar-track {
            background: #f1f1f1 !important;
            border-radius: 10px !important;
        }

        .goog-te-menu2::-webkit-scrollbar-thumb {
            background: #4A90E2 !important;
            border-radius: 10px !important;
        }

        .goog-te-menu2::-webkit-scrollbar-thumb:hover {
            background: #357ABD !important;
        }

        iframe.goog-te-menu-frame {
            border-radius: 12px !important;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2) !important;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <!-- 히어로 섹션 -->
    <section class="hero-section">
        <h1 class="hero-title">함께하는 <span class="highlight">봉사</span>, 더 따뜻한 세상</h1>
        <p class="hero-subtitle">
            여러분의 시간과 정성이 누군가에게는 큰 힘이 됩니다. 복지24와 함께 의미 있는 봉사활동을 시작하세요.
        </p>
    </section>

    <div id="volunteer-container">
        <!-- Step 1: Volunteer Activity Selection -->
        <div id="volunteer-step1" class="volunteer-step">
            <div class="volunteer-box">
                <h2 class="volunteer-title">
                    <span>봉사 활동 선택</span>
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
                </h2>
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
                <h2 class="volunteer-title">
                    <span>봉사자 정보</span>
                    <!-- Step Indicator -->
                    <div class="step-indicator">
                        <div class="step">
                            <div class="step-number" id="step1Number-s2">1</div>
                            <div class="step-text" id="step1Text-s2">봉사 활동 선택</div>
                        </div>
                        <div class="step-connector"></div>
                        <div class="step">
                            <div class="step-number active" id="step2Number-s2">2</div>
                            <div class="step-text active" id="step2Text-s2">봉사자 정보</div>
                        </div>
                        <div class="step-connector"></div>
                        <div class="step">
                            <div class="step-number" id="step3Number-s2">3</div>
                            <div class="step-text" id="step3Text-s2">신청 완료</div>
                        </div>
                    </div>
                </h2>
                <p class="volunteer-subtitle">봉사 활동을 위한 정보를 입력해주세요.</p>

                <form class="volunteer-form" id="volunteerForm">
                    <div class="form-group">
                        <label class="form-label" for="volunteerName">이름</label>
                        <input type="text" id="volunteerName" class="form-input" placeholder="이름을 입력하세요" oninput="lettersOnly(this)" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="volunteerPhone">전화번호</label>
                        <input type="text" id="volunteerPhone" class="form-input" placeholder="'-' 없이 숫자만 입력" maxlength="11" oninput="numbersOnly(this)" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">이메일</label>
                        <div class="email-group">
                            <input type="text" id="emailUser" class="form-input" placeholder="이메일 아이디" />
                            <span class="email-at">@</span>
                            <input type="text" id="emailDomain" class="form-input" placeholder="직접입력" />
                            <select id="emailDomainSelect" class="form-select">
                                <option value="">직접입력</option>
                                <option value="naver.com">naver.com</option>
                                <option value="gmail.com">gmail.com</option>
                                <option value="hanmail.net">hanmail.net</option>
                                <option value="daum.net">daum.net</option>
                                <option value="nate.com">nate.com</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="volunteerBirth">생년월일</label>
                        <input type="text" id="volunteerBirth" class="form-input" placeholder="8자리 입력 (예: 19900101)" maxlength="8" oninput="numbersOnly(this)" required>
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
                <h2 class="volunteer-title">
                    <span>신청 정보 확인</span>
                    <!-- Step Indicator -->
                    <div class="step-indicator">
                        <div class="step">
                            <div class="step-number" id="step1Number-s3">1</div>
                            <div class="step-text" id="step1Text-s3">봉사 활동 선택</div>
                        </div>
                        <div class="step-connector"></div>
                        <div class="step">
                            <div class="step-number" id="step2Number-s3">2</div>
                            <div class="step-text" id="step2Text-s3">봉사자 정보</div>
                        </div>
                        <div class="step-connector"></div>
                        <div class="step">
                            <div class="step-number active" id="step3Number-s3">3</div>
                            <div class="step-text active" id="step3Text-s3">신청 완료</div>
                        </div>
                    </div>
                </h2>
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
        // 숫자만 입력 허용 함수
        function numbersOnly(input) {
            input.value = input.value.replace(/[^0-9]/g, '');
        }

        // 문자만 입력 허용 함수 (한글, 영문, 공백만)
        function lettersOnly(input) {
            input.value = input.value.replace(/[^가-힣a-zA-Z\s]/g, '');
        }

        // 사용자 활동 로그 저장 함수
        function logUserActivity(activity) {
            try {
                const userId = '<%= session.getAttribute("id") != null ? session.getAttribute("id") : "guest" %>';
                const activityLog = JSON.parse(localStorage.getItem('userActivityLog_' + userId) || '[]');

                activityLog.unshift(activity);

                if (activityLog.length > 100) {
                    activityLog.splice(100);
                }

                localStorage.setItem('userActivityLog_' + userId, JSON.stringify(activityLog));
            } catch (error) {
                console.error('활동 로그 저장 오류:', error);
            }
        }

        // 날짜 선택 제한 설정 함수
        function setDateRestrictions() {
            // 사용자의 로컬 시간대 기준으로 오늘 날짜 계산
            const today = new Date();
            const year = today.getFullYear();
            const month = String(today.getMonth() + 1).padStart(2, '0');
            const day = String(today.getDate()).padStart(2, '0');
            const todayStr = year + '-' + month + '-' + day;

            const startDateInput = document.getElementById('startDate');
            const endDateInput = document.getElementById('endDate');

            // 시작일과 종료일 모두 오늘 이후만 선택 가능
            if (startDateInput) {
                startDateInput.setAttribute('min', todayStr);

                // 시작일 변경 시 종료일의 최소값도 업데이트
                startDateInput.addEventListener('change', function() {
                    const selectedStartDate = this.value;
                    if (endDateInput) {
                        endDateInput.setAttribute('min', selectedStartDate);

                        // 이미 선택된 종료일이 시작일보다 이전이면 초기화
                        if (endDateInput.value && endDateInput.value < selectedStartDate) {
                            endDateInput.value = '';
                            alert('종료일은 시작일 이후여야 합니다.');
                        }
                    }
                });
            }

            if (endDateInput) {
                endDateInput.setAttribute('min', todayStr);

                // 종료일 변경 시 시작일보다 이전인지 검증
                endDateInput.addEventListener('change', function() {
                    const selectedEndDate = this.value;
                    const selectedStartDate = startDateInput ? startDateInput.value : '';

                    if (selectedStartDate && selectedEndDate < selectedStartDate) {
                        this.value = '';
                        alert('종료일은 시작일 이후여야 합니다.');
                    }
                });
            }
        }

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
            // 날짜 입력 필드에 오늘 이후 날짜만 선택 가능하도록 설정
            setDateRestrictions();

            // 로그인 상태 확인 및 회원 정보 로드
            checkLoginStatusAndLoadInfo();

            function checkLoginStatusAndLoadInfo() {
                fetch('/bdproject/api/auth/check')
                    .then(response => response.json())
                    .then(data => {
                        if (!data.loggedIn) {
                            alert('봉사 신청은 로그인이 필요합니다.\n로그인 페이지로 이동합니다.');
                            window.location.href = '/bdproject/projectLogin.jsp';
                        } else {
                            // 로그인 상태라면 회원 정보 로드
                            loadMemberInfo();
                        }
                    })
                    .catch(error => {
                        console.error('로그인 상태 확인 실패:', error);
                        alert('로그인 상태를 확인할 수 없습니다.\n로그인 페이지로 이동합니다.');
                        window.location.href = '/bdproject/projectLogin.jsp';
                    });
            }

            // 마이페이지에서 회원 정보 불러오기
            function loadMemberInfo() {
                fetch('/bdproject/api/member/info')
                    .then(response => response.json())
                    .then(result => {
                        if (result.success && result.data) {
                            const data = result.data;
                            console.log('회원 정보 로드:', data);

                            // 이름
                            if (data.name) {
                                document.getElementById('volunteerName').value = data.name;
                            }
                            // 전화번호
                            if (data.phone) {
                                document.getElementById('volunteerPhone').value = data.phone;
                            }
                            // 이메일 분리하여 입력
                            if (data.email) {
                                const emailParts = data.email.split('@');
                                if (emailParts.length === 2) {
                                    document.getElementById('emailUser').value = emailParts[0];
                                    document.getElementById('emailDomain').value = emailParts[1];
                                }
                            }
                            // 생년월일 (YYYY-MM-DD 형식을 YYYYMMDD로 변환)
                            if (data.birth) {
                                const birthDate = data.birth.replace(/-/g, '');
                                document.getElementById('volunteerBirth').value = birthDate;
                            }
                            // 주소 정보가 있으면 로드
                            if (data.postcode) {
                                document.getElementById('postcode').value = data.postcode;
                            }
                            if (data.address) {
                                document.getElementById('address').value = data.address;
                            }
                            if (data.detailAddress) {
                                document.getElementById('detailAddress').value = data.detailAddress;
                            }
                        }
                    })
                    .catch(error => {
                        console.error('회원 정보 로드 실패:', error);
                    });
            }

            // 이메일 도메인 선택 이벤트
            const emailDomainSelect = document.getElementById('emailDomainSelect');
            if (emailDomainSelect) {
                emailDomainSelect.addEventListener('change', function() {
                    const emailDomainInput = document.getElementById('emailDomain');
                    if (this.value) {
                        emailDomainInput.value = this.value;
                        emailDomainInput.readOnly = true;
                    } else {
                        emailDomainInput.value = '';
                        emailDomainInput.readOnly = false;
                        emailDomainInput.focus();
                    }
                });
            }

            // Step indicator update
            function updateStepIndicator(currentStep) {
                // 모든 step indicator에서 active 클래스 제거
                document.querySelectorAll('.step-number, .step-text').forEach(element => {
                    element.classList.remove('active');
                });

                if (currentStep === 1) {
                    // Step 1의 indicator 활성화
                    document.getElementById('step1Number').classList.add('active');
                    document.getElementById('step1Text').classList.add('active');
                } else if (currentStep === 2) {
                    // Step 2의 모든 indicator 활성화
                    ['step2Number-s2', 'step2Text-s2'].forEach(id => {
                        const element = document.getElementById(id);
                        if (element) element.classList.add('active');
                    });
                } else if (currentStep === 3) {
                    // Step 3의 모든 indicator 활성화
                    ['step3Number-s3', 'step3Text-s3'].forEach(id => {
                        const element = document.getElementById(id);
                        if (element) element.classList.add('active');
                    });
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

                // 날짜 유효성 추가 검증 (오늘 이후 또는 당일 날짜인지 확인)
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                const startDateObj = new Date(startDate + 'T00:00:00');
                const endDateObj = new Date(endDate + 'T00:00:00');

                if (startDateObj < today) {
                    alert('시작일은 오늘 또는 이후 날짜여야 합니다.');
                    return;
                }

                if (endDateObj < startDateObj) {
                    alert('종료일은 시작일 이후 날짜여야 합니다.');
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
                const emailUser = document.getElementById('emailUser').value;
                const emailDomain = document.getElementById('emailDomain').value;
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
                if (!emailUser || !emailDomain) {
                    alert('이메일을 입력해주세요.');
                    return;
                }
                // 이메일 조합
                const email = emailUser + '@' + emailDomain;
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

                // 버튼 비활성화 (중복 제출 방지)
                finalSubmitBtn.disabled = true;
                finalSubmitBtn.textContent = '신청 중...';

                // API로 데이터 전송
                const formData = new URLSearchParams();
                formData.append('applicantName', volunteerData.name);
                formData.append('applicantPhone', volunteerData.phone);
                formData.append('applicantEmail', volunteerData.email);

                // 주소 정보 조합
                let fullAddress = volunteerData.address || '';
                if (volunteerData.detailAddress) {
                    fullAddress += ' ' + volunteerData.detailAddress;
                }
                formData.append('applicantAddress', fullAddress);

                formData.append('volunteerExperience', volunteerData.experience || '없음');
                formData.append('selectedCategory', volunteerData.category);
                formData.append('volunteerDate', volunteerData.startDate);
                formData.append('volunteerEndDate', volunteerData.endDate); // 종료일 추가
                formData.append('volunteerTime', volunteerData.availableTime || '오전');

                // 디버깅: 전송할 데이터 확인
                console.log('=== 봉사 신청 데이터 ===');
                console.log('applicantName:', volunteerData.name);
                console.log('applicantPhone:', volunteerData.phone);
                console.log('applicantEmail:', volunteerData.email);
                console.log('applicantAddress:', fullAddress);
                console.log('volunteerExperience:', volunteerData.experience);
                console.log('selectedCategory:', volunteerData.category);
                console.log('volunteerDate:', volunteerData.startDate);
                console.log('volunteerEndDate:', volunteerData.endDate); // 종료일 로그 추가
                console.log('volunteerTime:', volunteerData.availableTime);
                console.log('FormData:', formData.toString());

                fetch('/bdproject/api/volunteer/apply', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData.toString()
                })
                .then(response => {
                    console.log('응답 상태:', response.status);
                    console.log('응답 헤더:', response.headers.get('content-type'));

                    // HTML 에러 페이지가 왔는지 확인
                    const contentType = response.headers.get('content-type');
                    if (contentType && contentType.includes('text/html')) {
                        return response.text().then(html => {
                            console.error('HTML 에러 응답 전체:', html);
                            // 에러 메시지 추출 시도
                            const messageMatch = html.match(/<b>메시지<\/b>\s*(.+?)<\/p>/);
                            const descMatch = html.match(/<b>설명<\/b>\s*(.+?)<\/p>/);
                            let errorDetail = '';
                            if (messageMatch) errorDetail += '메시지: ' + messageMatch[1].replace(/<[^>]*>/g, '') + '\n';
                            if (descMatch) errorDetail += '설명: ' + descMatch[1].replace(/<[^>]*>/g, '');
                            throw new Error('서버 에러 (500): ' + (errorDetail || '서버에서 HTML 에러 페이지를 반환했습니다.'));
                        });
                    }

                    return response.json();
                })
                .then(data => {
                    console.log('응답 데이터:', data);
                    if (data.success) {
                        // 활동 로그 저장
                        const today = new Date();
                        const dateStr = today.getFullYear() + '년 ' + (today.getMonth() + 1) + '월 ' + today.getDate() + '일';
                        const volunteerDateStr = volunteerData.startDate;

                        logUserActivity({
                            type: 'volunteer_apply',
                            icon: 'fas fa-hands-helping',
                            iconColor: '#27ae60',
                            title: '봉사 활동 신청',
                            description: dateStr + '에 ' + volunteerDateStr + ' 봉사 활동(' + (volunteerData.category || '일반') + ')을 신청했습니다.',
                            timestamp: new Date().toISOString()
                        });

                        alert(volunteerData.name + '님의 봉사 신청이 완료되었습니다.\n담당자가 확인 후 연락드리겠습니다.');
                        setTimeout(() => {
                            window.location.href = '/bdproject/project.jsp';
                        }, 1500);
                    } else {
                        alert('봉사 신청에 실패했습니다.\n' + (data.message || '다시 시도해주세요.'));
                        finalSubmitBtn.disabled = false;
                        finalSubmitBtn.textContent = '신청 완료';
                    }
                })
                .catch(error => {
                    console.error('봉사 신청 오류:', error);
                    alert('봉사 신청 중 오류가 발생했습니다.\n다시 시도해주세요.\n\n콘솔창을 확인해주세요.');
                    finalSubmitBtn.disabled = false;
                    finalSubmitBtn.textContent = '신청 완료';
                });
            });

            // 초기화
            updateStepIndicator(1);
        });
    </script>

        <%@ include file="footer.jsp" %>
</body>
</html>
