<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // 세션에서 로그인 정보 가져오기
    String sessionUserId = (String) session.getAttribute("id");
    String sessionUsername = (String) session.getAttribute("username");
    String sessionEmail = (String) session.getAttribute("id"); // 이메일은 id에 저장됨
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
    <link rel="stylesheet" href="resources/css/project_faq.css">
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
                    <input type="email" class="form-input" name="userEmail" placeholder="이메일을 입력하세요"
                        value="<%= sessionEmail != null ? sessionEmail : "" %>" required>
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
        <!-- 고정 FAQ 목록 (DB에서 로드) -->
        <div class="faq-list" id="fixedFaqList" style="display: block; opacity: 1; overflow: visible;">
            <!-- FAQ는 JavaScript loadFixedFaqs()에서 동적으로 로드됩니다 -->
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
        // JSP 변수를 JavaScript 전역 변수로 전달
        window.isAdmin = <%= isAdmin %>;
    </script>
    <script src="resources/js/project_faq.js"></script>

    <!-- 질문 접수 완료 모달 -->
    <div id="successModal" class="success-modal">
        <div class="success-modal-content">
            <h2 class="success-title">질문이 접수되었습니다</h2>
            <p class="success-message">소중한 질문 감사합니다.<br>빠른 시일 내에 답변 드리겠습니다.</p>

            <div class="answer-info">
                <div class="answer-info-title">
                    <i class="fas fa-bell"></i> 답변 확인 방법
                </div>
                <div class="answer-info-item">회원: 마이페이지 &gt; 알림에서 확인</div>
                <div class="answer-info-item">비회원: 상단 검색창에 이름 또는 이메일 입력</div>
            </div>

            <button class="close-modal-btn" onclick="closeSuccessModal()">
                확인
            </button>
        </div>
    </div>

        <%@ include file="footer.jsp" %>
</body>
</html>
