<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // 세션에서 로그인 정보 가져오기
    String sessionUserId = (String) session.getAttribute("id");
    String sessionUsername = (String) session.getAttribute("username");
    String sessionRole = (String) session.getAttribute("role");
    boolean isAdmin = "ADMIN".equals(sessionRole);
%>
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

        .faq-icon.user-question {
            background-color: #6c757d;
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

        /* 사용자 질문 목록 스타일 */
        .user-questions-section {
            margin-bottom: 40px;
        }

        .section-title {
            font-size: 24px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #4A90E2;
        }

        .user-question-item {
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 15px;
            overflow: hidden;
        }

        .user-question-header {
            padding: 20px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.2s ease;
            border-radius: 10px;
        }

        .user-question-header:hover {
            background-color: #f0f8ff;
            transform: translateX(5px);
        }

        .user-question-header:active {
            transform: translateX(5px) scale(0.98);
        }

        .user-question-info {
            flex: 1;
        }

        .question-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            margin-right: 10px;
        }

        .badge-pending {
            background: #fff3cd;
            color: #856404;
        }

        .badge-answered {
            background: #d4edda;
            color: #155724;
        }

        .user-question-title {
            font-size: 16px;
            font-weight: 600;
            color: #2c3e50;
            margin: 8px 0;
        }

        .user-question-meta {
            font-size: 13px;
            color: #6c757d;
        }

        .user-question-body {
            padding: 0 20px;
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.5s ease, padding 0.5s ease;
        }

        .user-question-item.active .user-question-body {
            max-height: 3000px;
            padding: 20px;
            padding-top: 0;
        }

        .question-content {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .answer-content {
            padding: 15px;
            background: #e3f2fd;
            border-left: 4px solid #4A90E2;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .answer-form {
            margin-top: 15px;
            padding: 20px;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
        }

        .answer-form-title {
            font-size: 15px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .answer-form-title i {
            color: #4A90E2;
        }

        .answer-textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            font-size: 14px;
            resize: vertical;
            min-height: 120px;
            font-family: inherit;
            transition: border-color 0.2s;
        }

        .answer-textarea:focus {
            outline: none;
            border-color: #4A90E2;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }

        .answer-btn {
            margin-top: 10px;
            padding: 10px 20px;
            background-color: #4A90E2;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .answer-btn:hover {
            background-color: #357ABD;
        }


        /* 페이지네이션 */
        .pagination-btn {
            padding: 10px 15px;
            border: 1px solid #dee2e6;
            background: white;
            color: #495057;
            cursor: pointer;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .pagination-btn:hover:not(:disabled) {
            background: #4A90E2;
            color: white;
            border-color: #4A90E2;
        }

        .pagination-btn:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }

        .pagination-btn.active {
            background: #4A90E2;
            color: white;
            border-color: #4A90E2;
        }

        .pagination-info {
            font-size: 14px;
            color: #6c757d;
            font-weight: 600;
        }

    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <!-- 메인 컨텐츠 -->
    <div class="container">
        <div class="page-header">
            <h1 class="page-title">자주묻는 질문</h1>
            <p class="page-subtitle">궁금한 점을 빠르게 찾아보세요</p>
        </div>

        <div class="search-box">
            <input type="text" class="search-input" id="searchInput" placeholder="FAQ 또는 이름/이메일로 내 질문 검색..." autocomplete="off">
            <i class="fas fa-search search-icon" id="searchIcon"></i>
            <div class="search-autocomplete" id="searchAutocomplete"></div>
        </div>

        <div class="faq-categories">
            <% if (!isAdmin) { %>
            <button class="ask-question-btn" id="askQuestionBtn">
                <i class="fas fa-plus"></i> 질문하기
            </button>
            <% } %>
            <% if (isAdmin) { %>
            <button class="ask-question-btn" id="answerQuestionBtn" style="background: #28a745;">
                <i class="fas fa-comment-dots"></i> 답변하기
            </button>
            <% } %>
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
                    <p><i class="fas fa-info-circle"></i> 답변은 마이페이지의 알림에서 확인하실 수 있으며, 영업일 기준 1-2일 이내에 답변드립니다.</p>
                </div>

                <div class="form-group">
                    <label class="form-label">이름 <span class="required">*</span></label>
                    <input type="text" class="form-input" name="userName" placeholder="이름을 입력하세요"
                        value="<%= sessionUsername != null ? sessionUsername : "" %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label">이메일 <span class="required">*</span></label>
                    <input type="email" class="form-input" name="userEmail" placeholder="이메일을 입력하세요" required>
                </div>

                <div class="form-group">
                    <label class="form-label">카테고리 <span class="required">*</span></label>
                    <select class="form-input" name="category" required>
                        <option value="">카테고리를 선택하세요</option>
                        <option value="복지혜택">복지혜택</option>
                        <option value="서비스이용">서비스이용</option>
                        <option value="계정관리">계정관리</option>
                        <option value="기타">기타</option>
                    </select>
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

        <!-- 사용자 질문 목록 (관리자 전용) -->
        <% if (isAdmin) { %>
        <div id="userQuestionsContainer" style="display: none;"></div>
        <% } %>

        <!-- 자주 묻는 질문 (상단 고정) -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 3px solid #4A90E2; cursor: pointer;" id="faqToggleHeader">
            <h2 style="font-size: 28px; font-weight: 700; color: #2c3e50; margin: 0;">
                자주 묻는 질문 (FAQ)
            </h2>
            <i class="fas fa-chevron-down" id="faqToggleIcon" style="font-size: 24px; color: #4A90E2; transition: transform 0.3s ease; margin-right: 15px; margin-top: 3px;"></i>
        </div>
        <div class="faq-list" id="fixedFaqList" style="transition: max-height 0.5s ease, opacity 0.5s ease; overflow: hidden;">
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

            <div class="faq-item" data-category="service">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <div class="faq-icon">Q</div>
                    <div class="faq-question-text">봉사 활동은 어떻게 참여하나요?</div>
                    <i class="fas fa-chevron-down faq-toggle"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-text">
                        메인 메뉴에서 '봉사활동' 메뉴를 선택하시면 다양한 봉사 활동 정보를 확인하실 수 있습니다.
                        원하시는 활동을 선택한 후 신청 양식을 작성하시면 됩니다. 봉사 완료 후에는 후기를 작성하실 수 있으며,
                        마이페이지에서 봉사 이력을 관리하실 수 있습니다.
                    </div>
                </div>
            </div>

            <div class="faq-item" data-category="welfare">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <div class="faq-icon">Q</div>
                    <div class="faq-question-text">기부는 어떻게 하나요?</div>
                    <i class="fas fa-chevron-down faq-toggle"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-text">
                        메인 메뉴에서 '기부하기'를 선택하시면 다양한 기부 분야와 금액을 선택하실 수 있습니다.
                        정기 기부와 일시 기부 중 선택 가능하며, 신용카드, 계좌이체, 간편결제 등 다양한 결제 수단을 지원합니다.
                        기부금 영수증 발급도 가능하며, 모든 기부 내역은 마이페이지에서 확인하실 수 있습니다.
                    </div>
                </div>
            </div>
        </div>

        <!-- 사용자 질문 목록 (모든 사용자) -->
        <h2 style="font-size: 28px; font-weight: 700; color: #2c3e50; margin: 60px 0 20px 0; padding-bottom: 15px; border-bottom: 3px solid #6c757d;">
            사용자 질문
        </h2>
        <div class="faq-list" id="userQuestionsList">
            <div style="text-align: center; padding: 40px; color: #6c757d;">
                <i class="fas fa-spinner fa-spin" style="font-size: 32px; margin-bottom: 15px;"></i>
                <p>질문을 불러오는 중...</p>
            </div>
        </div>

        <!-- 페이지네이션 -->
        <div id="pagination" style="display: flex; justify-content: center; align-items: center; gap: 10px; margin-top: 30px; margin-bottom: 60px;">
        </div>
    </div>

    <script>
        // FAQ 데이터는 HTML에 이미 하드코딩되어 있으므로 API 호출 불필요

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
        async function submitQuestion(event) {
            event.preventDefault();

            const formData = new FormData(event.target);

            try {
                const response = await fetch('/bdproject/api/questions', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: new URLSearchParams({
                        userName: formData.get('userName'),
                        userEmail: formData.get('userEmail'),
                        category: formData.get('category'),
                        title: formData.get('title'),
                        content: formData.get('content')
                    })
                });

                const result = await response.json();

                if (result.success) {
                    const questionId = result.questionId || '확인불가';
                    alert('질문이 성공적으로 접수되었습니다!\n\n📌 질문 번호: ' + questionId + '\n\n답변 확인:\n✅ 회원: 마이페이지 > 알림\n✅ 비회원: 상단 검색창에 이름 또는 이메일 입력');
                    event.target.reset();
                    // 질문 섹션 닫기
                    toggleQuestionSection();
                    // 페이지 새로고침하여 질문 목록 업데이트
                    location.reload();
                } else {
                    alert('질문 등록에 실패했습니다: ' + (result.message || '알 수 없는 오류'));
                }
            } catch (error) {
                console.error('질문 제출 오류:', error);
                alert('질문 제출 중 오류가 발생했습니다.');
            }
        }

        // 사용자 질문 불러오기
        async function loadUserQuestions() {
            const isAdmin = <%= isAdmin %>;

            try {
                const response = await fetch('/bdproject/api/questions');
                const result = await response.json();

                if (result.success && result.data && result.data.length > 0) {
                    const container = document.getElementById('userQuestionsContainer');
                    let html = '<div class="user-questions-section"><h2 class="section-title">사용자 질문</h2>';

                    console.log('질문 데이터:', result.data);

                    result.data.forEach(q => {
                        console.log('질문 ID:', q.questionId, '타입:', typeof q.questionId);

                        const statusBadge = q.status === 'answered' ?
                            '<span class="question-badge badge-answered">답변완료</span>' :
                            '<span class="question-badge badge-pending">대기중</span>';

                        const date = new Date(q.createdAt).toLocaleDateString('ko-KR');
                        const qId = String(q.questionId);

                        html += '<div class="user-question-item" data-question-id="' + qId + '">' +
                                '<div class="user-question-header">' +
                                '<div class="user-question-info">' +
                                statusBadge +
                                '<div class="user-question-title">' + q.title + '</div>' +
                                '<div class="user-question-meta">' +
                                q.category + ' | ' + q.userName + ' | ' + date +
                                '</div>' +
                                '</div>' +
                                '<i class="fas fa-chevron-down faq-toggle"></i>' +
                                '</div>' +
                                '<div class="user-question-body">' +
                                '<div class="question-content">' +
                                '<strong>질문:</strong><br>' + q.content +
                                '</div>';

                        if (q.answer) {
                            const answeredDate = new Date(q.answeredAt).toLocaleString('ko-KR');
                            html += '<div class="answer-content">' +
                                '<strong>답변:</strong><br>' + q.answer +
                                '<div style="margin-top:10px; font-size:12px; color:#6c757d;">' +
                                '답변일: ' + answeredDate +
                                '</div>' +
                                '</div>';
                        } else if (isAdmin) {
                            console.log('답변 폼 생성 - questionId:', qId);
                            const textareaIdFull = 'answer-' + qId;
                            console.log('생성할 textarea ID:', textareaIdFull);

                            html += '<div class="answer-form">' +
                                '<div class="answer-form-title">' +
                                '<i class="fas fa-edit"></i> 관리자 답변 작성 (질문 ID: ' + qId + ')' +
                                '</div>' +
                                '<textarea class="answer-textarea" id="answer-' + qId + '" placeholder="질문에 대한 답변을 작성해주세요. 사용자의 마이페이지에 알림이 전송됩니다."></textarea>' +
                                '<button class="answer-btn" data-question-id="' + qId + '">' +
                                '<i class="fas fa-paper-plane"></i> 답변 등록' +
                                '</button>' +
                                '</div>';

                            console.log('생성된 HTML 일부:', html.substring(html.length - 200));
                        }

                        html += '</div>' +
                                '</div>';
                    });

                    html += '</div>';
                    container.innerHTML = html;

                    // 이벤트 위임 방식으로 클릭 이벤트 처리
                    setTimeout(() => {
                        const questionHeaders = document.querySelectorAll('.user-question-header');
                        console.log('등록된 헤더 개수:', questionHeaders.length);

                        questionHeaders.forEach((header, index) => {
                            header.style.cursor = 'pointer';
                            const questionItem = header.closest('.user-question-item');
                            const questionId = questionItem.getAttribute('data-question-id');
                            console.log('헤더', index, '- questionId:', questionId);

                            header.addEventListener('click', function() {
                                const item = this.closest('.user-question-item');
                                const qId = item.getAttribute('data-question-id');
                                console.log('클릭된 질문 ID:', qId);
                                toggleUserQuestion(qId);
                            });
                        });

                        // 답변 등록 버튼 이벤트
                        const answerBtns = document.querySelectorAll('.answer-btn');
                        console.log('등록된 답변 버튼 개수:', answerBtns.length);

                        answerBtns.forEach((btn, index) => {
                            const questionId = btn.getAttribute('data-question-id');
                            console.log('답변 버튼', index, '- questionId:', questionId);

                            btn.addEventListener('click', function() {
                                const qId = this.getAttribute('data-question-id');
                                console.log('답변 등록 버튼 클릭 - questionId:', qId);
                                submitAnswer(qId);
                            });
                        });
                    }, 100);
                } else {
                    // 질문이 없을 때
                    const container = document.getElementById('userQuestionsContainer');
                    container.innerHTML = '<div class="user-questions-section">' +
                        '<h2 class="section-title">사용자 질문</h2>' +
                        '<div class="empty-state" style="text-align: center; padding: 60px 20px; background: white; border-radius: 15px;">' +
                        '<i class="fas fa-comments" style="font-size: 48px; color: #dee2e6; margin-bottom: 20px;"></i>' +
                        '<p style="font-size: 16px; color: #6c757d;">아직 등록된 질문이 없습니다.</p>' +
                        '</div>' +
                        '</div>';
                }
            } catch (error) {
                console.error('질문 목록 로딩 오류:', error);
                const container = document.getElementById('userQuestionsContainer');
                if (container) {
                    container.innerHTML = '<div class="user-questions-section">' +
                        '<h2 class="section-title">사용자 질문</h2>' +
                        '<div class="empty-state" style="text-align: center; padding: 60px 20px; background: white; border-radius: 15px;">' +
                        '<i class="fas fa-exclamation-triangle" style="font-size: 48px; color: #ffc107; margin-bottom: 20px;"></i>' +
                        '<p style="font-size: 16px; color: #6c757d;">질문 목록을 불러오는 중 오류가 발생했습니다.</p>' +
                        '<p style="font-size: 14px; color: #999; margin-top: 10px;">페이지를 새로고침하거나 잠시 후 다시 시도해주세요.</p>' +
                        '</div>' +
                        '</div>';
                }
            }
        }

        // 사용자 질문 토글
        function toggleUserQuestion(questionId) {
            console.log('질문 토글 - questionId:', questionId, '타입:', typeof questionId);

            // 문자열로 변환
            const qIdStr = String(questionId);
            console.log('변환된 questionId:', qIdStr);

            // 모든 질문 아이템 확인
            const allItems = document.querySelectorAll('.user-question-item');
            console.log('전체 질문 아이템 개수:', allItems.length);

            // Array.from으로 변환하여 find 사용
            let targetItem = null;
            allItems.forEach((item, idx) => {
                const dataId = item.getAttribute('data-question-id');
                console.log(`아이템 ${idx} - data-question-id:`, dataId, '비교:', dataId === qIdStr);
                if (dataId === qIdStr) {
                    targetItem = item;
                    console.log('✅ 매칭된 아이템 찾음!');
                }
            });

            console.log('최종 선택된 아이템:', targetItem);

            if (targetItem) {
                const isActive = targetItem.classList.contains('active');

                // 다른 모든 질문 닫기
                allItems.forEach(q => {
                    q.classList.remove('active');
                    const t = q.querySelector('.faq-toggle');
                    if (t) t.classList.remove('active');
                });

                // 현재 질문 토글
                if (!isActive) {
                    targetItem.classList.add('active');
                    const toggle = targetItem.querySelector('.faq-toggle');
                    if (toggle) {
                        toggle.classList.add('active');
                    }
                    console.log('✅ 질문 펼침 완료');
                } else {
                    console.log('질문 접음');
                }
            } else {
                console.error('❌ 질문 아이템을 찾을 수 없습니다. questionId:', qIdStr);
                console.error('현재 페이지의 모든 data-question-id:',
                    Array.from(allItems).map(i => i.getAttribute('data-question-id')));
            }
        }

        // 관리자 답변 등록
        async function submitAnswer(questionId) {
            console.log('========== submitAnswer 시작 ==========');
            console.log('전달받은 파라미터:', questionId);
            console.log('파라미터 타입:', typeof questionId);
            console.log('파라미터 길이:', String(questionId).length);
            console.log('파라미터 값:', JSON.stringify(questionId));

            // 문자열로 확실히 변환
            const qIdStr = String(questionId).trim();
            console.log('변환된 questionId:', qIdStr, '길이:', qIdStr.length);

            const textareaId = 'answer-' + qIdStr;
            console.log('생성된 textarea ID:', textareaId);

            // 모든 textarea 확인
            const allTextareas = document.querySelectorAll('textarea');
            console.log('페이지의 모든 textarea 개수:', allTextareas.length);
            allTextareas.forEach((ta, idx) => {
                console.log(`  textarea ${idx} - id:`, ta.id);
            });

            const textarea = document.getElementById(textareaId);
            console.log('document.getElementById 결과:', textarea);

            if (!textarea) {
                console.error('❌ textarea를 찾을 수 없습니다.');
                console.error('찾으려고 한 ID:', textareaId);
                console.error('현재 페이지의 모든 ID:',
                    Array.from(allTextareas).map(t => t.id));
                alert('답변 입력란을 찾을 수 없습니다. 페이지를 새로고침해주세요.');
                return;
            }

            const answer = textarea.value.trim();
            console.log('답변 내용:', answer);

            if (!answer) {
                alert('답변을 입력해주세요.');
                return;
            }

            const apiUrl = '/bdproject/api/questions/' + qIdStr + '/answer';
            console.log('API 호출 URL:', apiUrl);

            try {
                const response = await fetch(apiUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: new URLSearchParams({
                        answer: answer
                    })
                });

                console.log('HTTP 상태:', response.status);
                console.log('Content-Type:', response.headers.get('content-type'));

                // 응답이 JSON이 아닌 경우 처리
                const contentType = response.headers.get('content-type');
                if (!contentType || !contentType.includes('application/json')) {
                    const text = await response.text();
                    console.error('서버가 JSON이 아닌 응답 반환:', text.substring(0, 500));

                    if (response.status === 500) {
                        alert('서버 오류가 발생했습니다.\n\n서버 콘솔 로그를 확인해주세요:\n1. 관리자 로그인 확인\n2. 데이터베이스 연결 확인\n3. NotificationService 빈 등록 확인');
                    } else {
                        alert('서버 응답 오류 (상태 코드: ' + response.status + ')');
                    }
                    return;
                }

                const result = await response.json();
                console.log('서버 응답:', result);

                if (result.success) {
                    alert('답변이 등록되었습니다.\n질문 작성자의 마이페이지에 알림이 전송되었습니다.');
                    location.reload();
                } else {
                    alert('답변 등록에 실패했습니다:\n' + (result.message || '알 수 없는 오류'));
                }
            } catch (error) {
                console.error('답변 등록 오류:', error);
                alert('답변 등록 중 오류가 발생했습니다:\n' + error.message);
            }
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


        // ========== 고급 검색 엔진 (Server-Side API) ==========

        // 검색 캐시 (동일 검색어 재검색 방지)
        const searchCache = new Map();
        let searchDebounceTimer = null;
        let currentSearchQuery = '';

        // 검색 API 호출 (Debouncing 적용)
        async function searchFAQ() {
            const searchInput = document.getElementById('searchInput');
            const searchText = searchInput.value.trim();

            // 자동완성 숨기기
            hideAutocomplete();

            // 빈 검색어인 경우 모든 FAQ 표시
            if (searchText === '') {
                showAllFaqs();
                return;
            }

            // 이미 검색 중이면 취소
            if (searchDebounceTimer) {
                clearTimeout(searchDebounceTimer);
            }

            // 300ms debounce
            searchDebounceTimer = setTimeout(async () => {
                await performSearch(searchText);
            }, 300);
        }

        // 실제 검색 수행
        async function performSearch(query) {
            // 먼저 사용자 질문에서 이름/이메일로 검색
            await searchUserQuestions(query);

            // FAQ 검색도 수행
            const activeCategoryBtn = document.querySelector('.category-btn.active');
            const category = activeCategoryBtn ? activeCategoryBtn.dataset.category : 'all';

            try {
                // API 호출
                const url = '/bdproject/api/faq/search?q=' + encodeURIComponent(query) +
                           (category !== 'all' ? '&category=' + encodeURIComponent(category) : '');

                console.log('검색 API 호출:', url);

                const response = await fetch(url);
                const result = await response.json();

                if (result.success) {
                    console.log('검색 결과:', result.count + '건', '평균 점수:', result.avgRelevanceScore);

                    // 캐시 저장 (최대 50개)
                    if (searchCache.size >= 50) {
                        const firstKey = searchCache.keys().next().value;
                        searchCache.delete(firstKey);
                    }
                    searchCache.set(query, result);

                    displaySearchResults(result, query);
                } else {
                    console.error('검색 실패:', result.message);
                    showNoResults(query);
                }
            } catch (error) {
                console.error('검색 API 오류:', error);
                showNoResults(query);
            }
        }

        // 검색 결과 표시
        function displaySearchResults(result, query) {
            const faqList = document.querySelector('.faq-list');

            if (!result.data || result.data.length === 0) {
                showNoResults(query);
                return;
            }

            let html = '';
            result.data.forEach(item => {
                // 하이라이팅이 적용된 텍스트 사용 (서버에서 제공)
                const questionHtml = item.highlightedQuestion || item.question;
                const answerHtml = item.highlightedAnswer || item.answer;

                html += '<div class="faq-item" data-category="' + item.category + '">' +
                        '<div class="faq-question" onclick="toggleFAQ(this)">' +
                        '<div class="faq-icon">Q</div>' +
                        '<div class="faq-question-text">' + questionHtml + '</div>' +
                        '<i class="fas fa-chevron-down faq-toggle"></i>' +
                        '</div>' +
                        '<div class="faq-answer">' +
                        '<div class="faq-answer-text">' + answerHtml + '</div>' +
                        '</div>' +
                        '</div>';
            });

            faqList.innerHTML = html;

            // <mark> 태그 스타일 추가
            addMarkStyles();
        }

        // 검색 결과 없음 표시
        function showNoResults(query) {
            const faqList = document.querySelector('.faq-list');
            faqList.innerHTML = '<div style="padding:60px 20px; text-align:center;">' +
                '<i class="fas fa-search" style="font-size:48px; color:#dee2e6; margin-bottom:20px;"></i>' +
                '<p style="font-size:18px; color:#6c757d; margin-bottom:10px;">"' + query + '"에 대한 검색 결과가 없습니다.</p>' +
                '<p style="font-size:14px; color:#999;">다른 검색어로 시도해보세요.</p>' +
                '</div>';
        }

        // 모든 FAQ 표시
        function showAllFaqs() {
            // 기존 하드코딩된 FAQ는 그대로 유지됨 (페이지 로드 시 상태로 복원)
            location.reload();
        }

        // 사용자 질문 검색 (이름 또는 이메일)
        async function searchUserQuestions(query) {
            const questionsList = document.getElementById('userQuestionsList');
            const pagination = document.getElementById('pagination');

            try {
                const response = await fetch('/bdproject/api/questions');
                const result = await response.json();

                if (result.success && result.data && result.data.length > 0) {
                    // 이름 또는 이메일로 필터링
                    const filteredQuestions = result.data.filter(q => {
                        const nameMatch = q.userName && q.userName.toLowerCase().includes(query.toLowerCase());
                        const emailMatch = q.userEmail && q.userEmail.toLowerCase().includes(query.toLowerCase());
                        const titleMatch = q.title && q.title.toLowerCase().includes(query.toLowerCase());
                        return nameMatch || emailMatch || titleMatch;
                    });

                    if (filteredQuestions.length > 0) {
                        // 최신순 정렬
                        filteredQuestions.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

                        // 검색 결과 HTML 생성
                        let html = '';
                        filteredQuestions.forEach(q => {
                            const date = new Date(q.createdAt).toLocaleDateString('ko-KR');
                            const statusBadge = q.status === 'answered' ?
                                '<span style="display:inline-block; padding:3px 8px; background:#d4edda; color:#155724; border-radius:8px; font-size:11px; font-weight:600; margin-left:8px;">답변완료</span>' :
                                '<span style="display:inline-block; padding:3px 8px; background:#fff3cd; color:#856404; border-radius:8px; font-size:11px; font-weight:600; margin-left:8px;">답변대기</span>';

                            // 검색어 하이라이트
                            let displayName = q.userName;
                            let displayEmail = q.userEmail;
                            let displayTitle = q.title;

                            if (q.userName && q.userName.toLowerCase().includes(query.toLowerCase())) {
                                const regex = new RegExp('(' + query + ')', 'gi');
                                displayName = q.userName.replace(regex, '<mark>$1</mark>');
                            }
                            if (q.userEmail && q.userEmail.toLowerCase().includes(query.toLowerCase())) {
                                const regex = new RegExp('(' + query + ')', 'gi');
                                displayEmail = q.userEmail.replace(regex, '<mark>$1</mark>');
                            }
                            if (q.title && q.title.toLowerCase().includes(query.toLowerCase())) {
                                const regex = new RegExp('(' + query + ')', 'gi');
                                displayTitle = q.title.replace(regex, '<mark>$1</mark>');
                            }

                            html += '<div class="faq-item">' +
                                    '<div class="faq-question" onclick="toggleFAQ(this)">' +
                                    '<div class="faq-icon user-question">Q</div>' +
                                    '<div class="faq-question-text">' + displayTitle + statusBadge +
                                    '<div style="font-size:12px; color:#6c757d; font-weight:400; margin-top:5px;">' +
                                    q.category + ' | ' + displayName + ' (' + displayEmail + ') | ' + date +
                                    '</div></div>' +
                                    '<i class="fas fa-chevron-down faq-toggle"></i>' +
                                    '</div>' +
                                    '<div class="faq-answer">' +
                                    '<div class="faq-answer-text">' +
                                    '<strong>질문:</strong><br>' + q.content + '<br><br>';

                            if (q.answer) {
                                const answerDate = new Date(q.answeredAt).toLocaleDateString('ko-KR');
                                html += '<div style="background:#e3f2fd; padding:15px; border-left:4px solid #4A90E2; border-radius:8px; margin-top:15px;">' +
                                        '<strong>답변:</strong><br>' + q.answer +
                                        '<div style="margin-top:10px; font-size:12px; color:#6c757d;">답변일: ' + answerDate + '</div>' +
                                        '</div>';
                            } else {
                                html += '<div style="background:#fff3cd; padding:15px; border-left:4px solid:#ffc107; border-radius:8px; margin-top:15px;">' +
                                        '<strong>답변 대기 중입니다.</strong>' +
                                        '</div>';
                            }

                            html += '</div></div></div>';
                        });

                        questionsList.innerHTML = html;
                        pagination.innerHTML = '<div style="text-align:center; padding:20px; color:#6c757d; font-size:14px;">' +
                            '<i class="fas fa-search" style="margin-right:8px;"></i>' +
                            '<strong>' + filteredQuestions.length + '개의 질문</strong>을 찾았습니다.</div>';

                        console.log('✅ 검색 결과:', filteredQuestions.length + '개');

                        // mark 태그 스타일 적용
                        addMarkStyles();
                    } else {
                        // 검색 결과 없음
                        questionsList.innerHTML = '<div style="text-align: center; padding: 40px; color: #6c757d;">' +
                            '<i class="fas fa-search" style="font-size: 48px; margin-bottom: 15px; opacity: 0.3;"></i>' +
                            '<p><strong>"' + query + '"</strong>에 대한 질문을 찾을 수 없습니다.</p>' +
                            '<p style="font-size:14px; margin-top:10px;">이름 또는 이메일을 정확히 입력해주세요.</p>' +
                            '</div>';
                        pagination.innerHTML = '';
                    }
                }
            } catch (error) {
                console.error('사용자 질문 검색 오류:', error);
            }
        }

        // <mark> 하이라이팅 스타일
        function addMarkStyles() {
            if (!document.getElementById('mark-styles')) {
                const style = document.createElement('style');
                style.id = 'mark-styles';
                style.innerHTML = 'mark { background-color: #fff3cd; color: #856404; font-weight: 600; padding: 2px 4px; border-radius: 3px; }';
                document.head.appendChild(style);
            }
        }

        // 자동완성 표시 (서버 API 기반)
        async function showAutocomplete() {
            const searchInput = document.getElementById('searchInput');
            const searchText = searchInput.value.trim();
            const autocompleteDiv = document.getElementById('searchAutocomplete');

            if (searchText === '' || searchText.length < 2) {
                hideAutocomplete();
                return;
            }

            // 캐시 확인
            if (searchCache.has(searchText)) {
                const cachedResult = searchCache.get(searchText);
                displayAutocomplete(cachedResult.data, searchText);
                return;
            }

            try {
                const url = '/bdproject/api/faq/search?q=' + encodeURIComponent(searchText);
                const response = await fetch(url);
                const result = await response.json();

                if (result.success && result.data.length > 0) {
                    displayAutocomplete(result.data, searchText);
                } else {
                    autocompleteDiv.innerHTML = '<div class="autocomplete-empty">검색 결과가 없습니다</div>';
                    autocompleteDiv.classList.add('active');
                    searchInput.classList.add('autocomplete-active');
                }
            } catch (error) {
                console.error('자동완성 API 오류:', error);
                hideAutocomplete();
            }
        }

        // 자동완성 결과 표시
        function displayAutocomplete(data, searchText) {
            const autocompleteDiv = document.getElementById('searchAutocomplete');
            const searchInput = document.getElementById('searchInput');

            let html = '';
            data.slice(0, 5).forEach(item => {
                const questionText = item.question.replace(/'/g, "\\'");
                const highlightedQuestion = highlightMatch(item.question, searchText);
                html += '<div class="autocomplete-item" onclick="selectAutocomplete(\'' + questionText + '\')">' +
                        highlightedQuestion +
                        '</div>';
            });

            autocompleteDiv.innerHTML = html;
            autocompleteDiv.classList.add('active');
            searchInput.classList.add('autocomplete-active');
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

        // 답변하기 버튼 토글 (관리자 전용)
        function toggleAnswerSection() {
            const container = document.getElementById('userQuestionsContainer');
            const answerBtn = document.getElementById('answerQuestionBtn');

            if (container.style.display === 'none') {
                container.style.display = 'block';
                answerBtn.innerHTML = '<i class="fas fa-minus"></i> 답변 닫기';
                answerBtn.style.background = '#dc3545';
                // 질문 목록 로드
                loadUserQuestions();
            } else {
                container.style.display = 'none';
                answerBtn.innerHTML = '<i class="fas fa-comment-dots"></i> 답변하기';
                answerBtn.style.background = '#28a745';
            }
        }

        // DOM이 완전히 로드된 후 실행
        document.addEventListener('DOMContentLoaded', function() {
            // 질문하기 버튼 이벤트
            const askQuestionBtn = document.getElementById('askQuestionBtn');
            if (askQuestionBtn) {
                askQuestionBtn.addEventListener('click', toggleQuestionSection);
            }

            // 답변하기 버튼 이벤트 (관리자 전용)
            const answerQuestionBtn = document.getElementById('answerQuestionBtn');
            if (answerQuestionBtn) {
                answerQuestionBtn.addEventListener('click', toggleAnswerSection);
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

            // 카테고리 필터링 (서버 API 기반)
            const categoryBtns = document.querySelectorAll('.category-btn');
            if (categoryBtns) {
                categoryBtns.forEach(btn => {
                    btn.addEventListener('click', async function() {
                        const category = this.dataset.category;
                        const searchInput = document.getElementById('searchInput');
                        const searchText = searchInput.value.trim();

                        // 버튼 활성화 상태 변경
                        document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
                        this.classList.add('active');

                        // 검색어가 있으면 카테고리 필터링 적용하여 재검색
                        if (searchText !== '') {
                            await performSearch(searchText);
                        } else {
                            // 검색어 없이 카테고리만 필터링 (클라이언트 사이드)
                            const faqItems = document.querySelectorAll('.faq-item');
                            faqItems.forEach(item => {
                                const itemCategory = item.dataset.category;
                                if (category === 'all' || itemCategory === category) {
                                    item.style.display = 'block';
                                } else {
                                    item.style.display = 'none';
                                }
                            });
                        }
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

            // ✅ 페이지 로드 시 서버에서 FAQ 가져오기
            loadFaqsFromServer();

            // ✅ 사용자 질문 목록 로드
            loadPublicUserQuestions(1);

            // ✅ FAQ 접기/펼치기 기능
            const faqToggleHeader = document.getElementById('faqToggleHeader');
            const faqToggleIcon = document.getElementById('faqToggleIcon');
            const fixedFaqList = document.getElementById('fixedFaqList');
            let faqExpanded = true;

            if (faqToggleHeader) {
                faqToggleHeader.addEventListener('click', function() {
                    faqExpanded = !faqExpanded;

                    if (faqExpanded) {
                        // 펼치기
                        fixedFaqList.style.maxHeight = '10000px';
                        fixedFaqList.style.opacity = '1';
                        fixedFaqList.style.marginBottom = '0';
                        faqToggleIcon.style.transform = 'rotate(0deg)';
                    } else {
                        // 접기
                        fixedFaqList.style.maxHeight = '0';
                        fixedFaqList.style.opacity = '0';
                        fixedFaqList.style.marginBottom = '0';
                        faqToggleIcon.style.transform = 'rotate(-180deg)';
                    }
                });
            }
        });

        // 서버에서 FAQ 목록 가져오기 (상단 고정용)
        async function loadFaqsFromServer() {
            // 이미 HTML에 하드코딩되어 있으므로 별도 처리 불필요
            console.log('✅ 고정 FAQ는 HTML에 이미 존재');
        }

        // 사용자 질문 목록 로드 (페이지네이션)
        let currentPage = 1;
        const questionsPerPage = 10;
        let totalQuestions = 0;

        async function loadPublicUserQuestions(page) {
            currentPage = page;
            const questionsList = document.getElementById('userQuestionsList');
            const pagination = document.getElementById('pagination');

            try {
                const response = await fetch('/bdproject/api/questions');
                const result = await response.json();

                if (result.success && result.data && result.data.length > 0) {
                    const questions = result.data;
                    totalQuestions = questions.length;

                    // 최신순 정렬
                    questions.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

                    // 페이지네이션 계산
                    const startIndex = (page - 1) * questionsPerPage;
                    const endIndex = startIndex + questionsPerPage;
                    const pageQuestions = questions.slice(startIndex, endIndex);

                    // 질문 목록 HTML 생성
                    let html = '';
                    pageQuestions.forEach(q => {
                        const date = new Date(q.createdAt).toLocaleDateString('ko-KR');
                        const statusBadge = q.status === 'answered' ?
                            '<span style="display:inline-block; padding:3px 8px; background:#d4edda; color:#155724; border-radius:8px; font-size:11px; font-weight:600; margin-left:8px;">답변완료</span>' :
                            '<span style="display:inline-block; padding:3px 8px; background:#fff3cd; color:#856404; border-radius:8px; font-size:11px; font-weight:600; margin-left:8px;">답변대기</span>';

                        html += '<div class="faq-item">' +
                                '<div class="faq-question" onclick="toggleFAQ(this)">' +
                                '<div class="faq-icon user-question">Q</div>' +
                                '<div class="faq-question-text">' + q.title + statusBadge +
                                '<div style="font-size:12px; color:#6c757d; font-weight:400; margin-top:5px;">' +
                                q.category + ' | ' + q.userName + ' | ' + date +
                                '</div></div>' +
                                '<i class="fas fa-chevron-down faq-toggle"></i>' +
                                '</div>' +
                                '<div class="faq-answer">' +
                                '<div class="faq-answer-text">' +
                                '<strong>질문:</strong><br>' + q.content + '<br><br>';

                        if (q.answer) {
                            const answerDate = new Date(q.answeredAt).toLocaleDateString('ko-KR');
                            html += '<div style="background:#e3f2fd; padding:15px; border-left:4px solid #4A90E2; border-radius:8px; margin-top:15px;">' +
                                    '<strong>답변:</strong><br>' + q.answer +
                                    '<div style="margin-top:10px; font-size:12px; color:#6c757d;">답변일: ' + answerDate + '</div>' +
                                    '</div>';
                        } else {
                            html += '<div style="background:#fff3cd; padding:15px; border-left:4px solid:#ffc107; border-radius:8px; margin-top:15px;">' +
                                    '<strong>답변 대기 중입니다.</strong>' +
                                    '</div>';
                        }

                        html += '</div></div></div>';
                    });

                    questionsList.innerHTML = html;

                    // 페이지네이션 버튼 생성
                    renderPagination(totalQuestions, page);

                    console.log('✅ 사용자 질문 로드 완료:', pageQuestions.length + '개 (총 ' + totalQuestions + '개)');
                } else {
                    questionsList.innerHTML = '<div style="text-align: center; padding: 40px; color: #6c757d;">' +
                        '<i class="fas fa-comments" style="font-size: 48px; margin-bottom: 15px; opacity: 0.3;"></i>' +
                        '<p>아직 등록된 질문이 없습니다.</p>' +
                        '</div>';
                    pagination.innerHTML = '';
                }
            } catch (error) {
                console.error('사용자 질문 로딩 실패:', error);
                questionsList.innerHTML = '<div style="text-align: center; padding: 40px; color: #dc3545;">' +
                    '<i class="fas fa-exclamation-triangle" style="font-size: 48px; margin-bottom: 15px;"></i>' +
                    '<p>질문 목록을 불러올 수 없습니다.</p>' +
                    '</div>';
            }
        }

        // 페이지네이션 렌더링
        function renderPagination(total, current) {
            const pagination = document.getElementById('pagination');
            const totalPages = Math.ceil(total / questionsPerPage);

            if (totalPages <= 1) {
                pagination.innerHTML = '';
                return;
            }

            let html = '';

            // 이전 버튼
            html += '<button class="pagination-btn" onclick="loadPublicUserQuestions(' + (current - 1) + ')" ' +
                    (current === 1 ? 'disabled' : '') + '>' +
                    '<i class="fas fa-chevron-left"></i> 이전' +
                    '</button>';

            // 페이지 번호
            const startPage = Math.max(1, current - 2);
            const endPage = Math.min(totalPages, current + 2);

            if (startPage > 1) {
                html += '<button class="pagination-btn" onclick="loadPublicUserQuestions(1)">1</button>';
                if (startPage > 2) {
                    html += '<span class="pagination-info">...</span>';
                }
            }

            for (let i = startPage; i <= endPage; i++) {
                html += '<button class="pagination-btn ' + (i === current ? 'active' : '') + '" ' +
                        'onclick="loadPublicUserQuestions(' + i + ')">' + i + '</button>';
            }

            if (endPage < totalPages) {
                if (endPage < totalPages - 1) {
                    html += '<span class="pagination-info">...</span>';
                }
                html += '<button class="pagination-btn" onclick="loadPublicUserQuestions(' + totalPages + ')">' + totalPages + '</button>';
            }

            // 다음 버튼
            html += '<button class="pagination-btn" onclick="loadPublicUserQuestions(' + (current + 1) + ')" ' +
                    (current === totalPages ? 'disabled' : '') + '>' +
                    '다음 <i class="fas fa-chevron-right"></i>' +
                    '</button>';

            // 페이지 정보
            html += '<span class="pagination-info" style="margin-left: 15px;">' +
                    current + ' / ' + totalPages + ' 페이지</span>';

            pagination.innerHTML = html;
        }
    </script>
        <%@ include file="footer.jsp" %>
</body>
</html>
