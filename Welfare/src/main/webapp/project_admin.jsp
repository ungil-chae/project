<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // 세션에서 로그인 정보 가져오기
    String sessionUserId = (String) session.getAttribute("id");
    String sessionUsername = (String) session.getAttribute("username");
    String sessionRole = (String) session.getAttribute("role");

    // 디버깅 로그
    System.out.println("=== Admin Page Access Debug ===");
    System.out.println("sessionUserId: " + sessionUserId);
    System.out.println("sessionUsername: " + sessionUsername);
    System.out.println("sessionRole: " + sessionRole);

    // 로그인하지 않은 경우
    if (sessionUserId == null) {
        System.out.println("로그인되지 않음 - 로그인 페이지로 리다이렉트");
        response.sendRedirect("login/login");
        return;
    }

    // 관리자가 아닌 경우
    boolean isAdmin = "ADMIN".equals(sessionRole);
    if (!isAdmin) {
        System.out.println("관리자 권한 없음 - 마이페이지로 리다이렉트");
        response.sendRedirect("project_mypage.jsp");
        return;
    }

    System.out.println("관리자 접근 허용");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 페이지 - 복지24</title>
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

        .admin-container {
            display: flex;
            min-height: 100vh;
            padding-top: 60px;
        }

        /* 사이드바 스타일 */
        .sidebar {
            width: 250px;
            background: white;
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
            position: fixed;
            left: 0;
            top: 60px;
            bottom: 0;
            overflow-y: auto;
            z-index: 100;
            display: flex;
            flex-direction: column;
        }

        .sidebar-header {
            padding: 30px 20px;
            border-bottom: 1px solid #e9ecef;
        }

        .sidebar-footer {
            border-top: 1px solid #e9ecef;
            margin-top: auto;
        }

        .admin-name {
            font-size: 20px;
            font-weight: 700;
            color: #2c3e50;
        }

        .sidebar-menu {
            padding: 20px 0;
            flex: 1;
        }

        .menu-item {
            padding: 15px 25px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 12px;
            color: #495057;
            border-left: 3px solid transparent;
        }

        .menu-item:hover {
            background-color: #f8f9fa;
            color: #4A90E2;
        }

        .menu-item.active {
            background-color: #e3f2fd;
            color: #4A90E2;
            border-left-color: #4A90E2;
            font-weight: 600;
        }

        .menu-item i {
            font-size: 18px;
            width: 20px;
        }

        /* 메인 콘텐츠 영역 */
        .main-content {
            margin-left: 250px;
            flex: 1;
            padding: 40px;
        }

        .content-header {
            margin-bottom: 30px;
        }

        .content-title {
            font-size: 28px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .content-subtitle {
            font-size: 15px;
            color: #6c757d;
        }

        /* 통계 카드 */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }

        .stat-icon.blue { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .stat-icon.green { background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%); }
        .stat-icon.orange { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
        .stat-icon.purple { background: linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%); }

        .stat-info {
            flex: 1;
        }

        .stat-label {
            font-size: 14px;
            color: #6c757d;
            margin-bottom: 5px;
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #2c3e50;
        }

        /* 콘텐츠 섹션 */
        .content-section {
            display: none;
        }

        .content-section.active {
            display: block;
        }

        /* 데이터 테이블 */
        .data-table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .table-header {
            padding: 20px 25px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-title {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
        }

        .search-box {
            display: flex;
            gap: 10px;
        }

        .search-input {
            padding: 8px 15px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 14px;
            width: 250px;
        }

        .search-btn, .action-btn {
            padding: 8px 16px;
            background: #4A90E2;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: background 0.2s ease;
        }

        .search-btn:hover, .action-btn:hover {
            background: #357ABD;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table thead {
            background: #f8f9fa;
        }

        .data-table th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            font-size: 14px;
            border-bottom: 2px solid #e9ecef;
        }

        .data-table td {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            font-size: 14px;
            color: #495057;
        }

        .data-table tbody tr:hover {
            background-color: #f8f9fa;
        }

        /* 뱃지 */
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-admin {
            background: #667eea;
            color: white;
        }

        .badge-user {
            background: #e9ecef;
            color: #495057;
        }

        .badge-success {
            background: #28a745;
            color: white;
        }

        .badge-warning {
            background: #ffc107;
            color: #212529;
        }

        .badge-danger {
            background: #dc3545;
            color: white;
        }

        /* 액션 버튼 */
        .table-actions {
            display: flex;
            gap: 8px;
        }

        .btn-sm {
            padding: 5px 12px;
            font-size: 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-view {
            background: #17a2b8;
            color: white;
        }

        .btn-view:hover {
            background: #138496;
        }

        .btn-edit {
            background: #ffc107;
            color: #212529;
        }

        .btn-edit:hover {
            background: #e0a800;
        }

        .btn-delete {
            background: #dc3545;
            color: white;
        }

        .btn-delete:hover {
            background: #c82333;
        }

        .btn-warning {
            background: #ffc107;
            color: #212529;
        }

        .btn-warning:hover {
            background: #e0a800;
        }

        .btn-success {
            background: #28a745;
            color: white;
        }

        .btn-success:hover {
            background: #218838;
        }

        /* 로딩 */
        .loading {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }

        /* 빈 상태 */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.3;
        }

        /* 페이지네이션 */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 8px;
            padding: 25px;
        }

        .page-btn {
            padding: 8px 12px;
            border: 1px solid #dee2e6;
            background: white;
            color: #495057;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s ease;
            font-size: 14px;
        }

        .page-btn:hover {
            background: #e9ecef;
        }

        .page-btn.active {
            background: #4A90E2;
            color: white;
            border-color: #4A90E2;
        }

        /* 모달 */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
        }

        .modal.active {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background: white;
            border-radius: 12px;
            width: 90%;
            max-width: 600px;
            max-height: 80vh;
            overflow-y: auto;
        }

        .modal-header {
            padding: 20px 25px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-title {
            font-size: 20px;
            font-weight: 600;
            color: #2c3e50;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 24px;
            color: #6c757d;
            cursor: pointer;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: background 0.2s ease;
        }

        .modal-close:hover {
            background: #f8f9fa;
        }

        .modal-body {
            padding: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .form-input, .form-textarea, .form-select {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 14px;
            font-family: inherit;
        }

        .form-textarea {
            resize: vertical;
            min-height: 120px;
        }

        .form-input:focus, .form-textarea:focus, .form-select:focus {
            outline: none;
            border-color: #4A90E2;
        }

        .modal-footer {
            padding: 20px 25px;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        /* 기부 상세 정보 스타일 */
        .donation-detail {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .detail-row {
            display: grid;
            grid-template-columns: 140px 1fr;
            gap: 15px;
            align-items: start;
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .detail-row.full-width {
            grid-template-columns: 140px 1fr;
        }

        .detail-label {
            font-weight: 600;
            color: #495057;
            font-size: 14px;
        }

        .detail-value {
            color: #2c3e50;
            font-size: 14px;
        }

        .detail-message {
            color: #2c3e50;
            font-size: 14px;
            line-height: 1.6;
            margin: 0;
            white-space: pre-wrap;
            background: #f8f9fa;
            padding: 12px;
            border-radius: 6px;
        }

        .btn-cancel {
            padding: 10px 20px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.2s ease;
        }

        .btn-cancel:hover {
            background: #5a6268;
        }

        .btn-submit {
            padding: 10px 20px;
            background: #4A90E2;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.2s ease;
        }

        .btn-submit:hover {
            background: #357ABD;
        }

        /* 차트 컨테이너 */
        .chart-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 25px;
            margin-bottom: 30px;
        }

        .chart-title {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="admin-container">
        <!-- 사이드바 -->
        <aside class="sidebar">
            <div class="sidebar-header">

                <div class="admin-name"><%= sessionUsername != null ? sessionUsername : "관리자" %></div>
            </div>

            <nav class="sidebar-menu">
                <div class="menu-item active" onclick="showSection('dashboard')">
                    <i class="fas fa-chart-line"></i>
                    <span>대시보드</span>
                </div>
                <div class="menu-item" onclick="showSection('members')">
                    <i class="fas fa-users"></i>
                    <span>회원 관리</span>
                </div>
                <div class="menu-item" onclick="showSection('member-history')">
                    <i class="fas fa-history"></i>
                    <span>회원 상태 변경 이력</span>
                </div>
                <div class="menu-item" onclick="showSection('notices')">
                    <i class="fas fa-bullhorn"></i>
                    <span>공지사항 관리</span>
                </div>
                <div class="menu-item" onclick="showSection('faqs')">
                    <i class="fas fa-question-circle"></i>
                    <span>FAQ 관리</span>
                </div>
                <div class="menu-item" onclick="showSection('donations')">
                    <i class="fas fa-hand-holding-heart"></i>
                    <span>기부 내역</span>
                </div>
                <div class="menu-item" onclick="showSection('volunteers')">
                    <i class="fas fa-hands-helping"></i>
                    <span>봉사활동 관리</span>
                </div>
            </nav>

            <div class="sidebar-footer">
                <a href="#" class="menu-item" id="logoutBtn" style="color: #dc3545; margin-top: 15px;" onclick="logout(); return false;">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>로그아웃</span>
                </a>
            </div>
        </aside>

        <!-- 메인 콘텐츠 -->
        <main class="main-content">
            <!-- 대시보드 섹션 -->
            <section id="dashboard" class="content-section active">
                <div class="content-header">
                    <h1 class="content-title">대시보드</h1>
                    <p class="content-subtitle">복지24 플랫폼의 주요 지표를 한눈에 확인하세요</p>
                </div>

                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon blue">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-label">전체 회원</div>
                            <div class="stat-value" id="totalMembers">-</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon green">
                            <i class="fas fa-won-sign"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-label">총 기부금</div>
                            <div class="stat-value" id="totalDonations">-</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon orange">
                            <i class="fas fa-hands-helping"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-label">봉사 신청</div>
                            <div class="stat-value" id="totalVolunteers">-</div>
                        </div>
                    </div>
                </div>

                <div class="chart-container">
                    <div class="chart-title">최근 활동 현황</div>
                    <div id="recentActivity" class="loading">
                        <i class="fas fa-spinner fa-spin"></i> 데이터 로딩 중...
                    </div>
                </div>
            </section>

            <!-- 회원 관리 섹션 -->
            <section id="members" class="content-section">
                <div class="content-header">
                    <h1 class="content-title">회원 관리</h1>
                    <p class="content-subtitle">가입한 회원들의 정보를 관리합니다</p>
                </div>

                <div class="data-table-container">
                    <div class="table-header">
                        <div class="table-title">전체 회원 목록</div>
                        <div class="search-box">
                            <input type="text" class="search-input" id="memberSearch" placeholder="이름 또는 이메일 검색">
                            <button class="search-btn" onclick="searchMembers()">
                                <i class="fas fa-search"></i> 검색
                            </button>
                        </div>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>아이디</th>
                                <th>이름</th>
                                <th>이메일</th>
                                <th>전화번호</th>
                                <th>권한</th>
                                <th>상태</th>
                                <th>가입일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody id="membersTableBody">
                            <tr>
                                <td colspan="9" class="loading">
                                    <i class="fas fa-spinner fa-spin"></i> 데이터 로딩 중...
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="pagination" id="membersPagination"></div>
                </div>
            </section>

            <!-- 회원 상태 변경 이력 섹션 -->
            <section id="member-history" class="content-section">
                <div class="content-header">
                    <h1 class="content-title">회원 상태 변경 이력</h1>
                    <p class="content-subtitle">관리자의 회원 상태 변경 기록을 확인합니다</p>
                </div>

                <div class="data-table-container">
                    <div class="table-header">
                        <div class="table-title">상태 변경 이력</div>
                        <div class="search-box">
                            <input type="text" class="search-input" id="historySearch" placeholder="회원 이메일 검색">
                            <button class="search-btn" onclick="searchHistory()">
                                <i class="fas fa-search"></i> 검색
                            </button>
                        </div>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>회원 이메일</th>
                                <th>회원명</th>
                                <th>변경 전 상태</th>
                                <th>변경 후 상태</th>
                                <th>변경 사유</th>
                                <th>처리 관리자</th>
                                <th>변경 일시</th>
                                <th>IP 주소</th>
                            </tr>
                        </thead>
                        <tbody id="historyTableBody">
                            <tr>
                                <td colspan="9" class="loading">
                                    <i class="fas fa-spinner fa-spin"></i> 데이터 로딩 중...
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="pagination" id="historyPagination"></div>
                </div>
            </section>

            <!-- 공지사항 관리 섹션 -->
            <section id="notices" class="content-section">
                <div class="content-header">
                    <h1 class="content-title">공지사항 관리</h1>
                    <p class="content-subtitle">사이트 공지사항을 작성하고 관리합니다</p>
                </div>

                <div class="data-table-container">
                    <div class="table-header">
                        <div class="table-title">공지사항 목록</div>
                        <button class="action-btn" onclick="openNoticeModal()">
                            <i class="fas fa-plus"></i> 새 공지사항
                        </button>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="width: 80px;">번호</th>
                                <th>제목</th>
                                <th style="width: 100px;">조회수</th>
                                <th style="width: 100px;">고정</th>
                                <th style="width: 150px;">작성일</th>
                                <th style="width: 150px;">관리</th>
                            </tr>
                        </thead>
                        <tbody id="noticesTableBody">
                            <tr>
                                <td colspan="6" class="loading">
                                    <i class="fas fa-spinner fa-spin"></i> 데이터 로딩 중...
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="pagination" id="noticesPagination"></div>
                </div>
            </section>

            <!-- FAQ 관리 섹션 -->
            <section id="faqs" class="content-section">
                <div class="content-header">
                    <h1 class="content-title">FAQ 관리</h1>
                    <p class="content-subtitle">자주 묻는 질문을 관리합니다</p>
                </div>

                <div class="data-table-container">
                    <div class="table-header">
                        <div class="table-title">FAQ 목록</div>
                        <button class="action-btn" onclick="openFaqModal()">
                            <i class="fas fa-plus"></i> 새 FAQ
                        </button>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="width: 80px;">번호</th>
                                <th style="width: 120px;">카테고리</th>
                                <th>질문</th>
                                <th style="width: 150px;">관리</th>
                            </tr>
                        </thead>
                        <tbody id="faqsTableBody">
                            <tr>
                                <td colspan="4" class="loading">
                                    <i class="fas fa-spinner fa-spin"></i> 데이터 로딩 중...
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="pagination" id="faqsPagination"></div>
                </div>
            </section>

            <!-- 기부 내역 섹션 -->
            <section id="donations" class="content-section">
                <div class="content-header">
                    <h1 class="content-title">기부 내역</h1>
                    <p class="content-subtitle">모든 기부 내역을 확인합니다</p>
                </div>

                <div class="data-table-container">
                    <div class="table-header">
                        <div class="table-title">기부 목록</div>
                        <div class="search-box">
                            <input type="text" class="search-input" id="donationSearch" placeholder="후원자명 검색">
                            <button class="search-btn" onclick="searchDonations()">
                                <i class="fas fa-search"></i> 검색
                            </button>
                        </div>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>후원자</th>
                                <th>금액</th>
                                <th>유형</th>
                                <th>분야</th>
                                <th>상태</th>
                                <th>일시</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody id="donationsTableBody">
                            <tr>
                                <td colspan="8" class="loading">
                                    <i class="fas fa-spinner fa-spin"></i> 데이터 로딩 중...
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="pagination" id="donationsPagination"></div>
                </div>
            </section>

            <!-- 봉사활동 관리 섹션 -->
            <section id="volunteers" class="content-section">
                <div class="content-header">
                    <h1 class="content-title">봉사활동 관리</h1>
                    <p class="content-subtitle">봉사활동 신청 현황을 관리합니다</p>
                </div>

                <div class="data-table-container">
                    <div class="table-header">
                        <div class="table-title">봉사 신청 목록</div>
                        <button class="action-btn" onclick="openVolunteerModal()">
                            <i class="fas fa-plus"></i> 신규 활동 등록
                        </button>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>신청자</th>
                                <th>활동명</th>
                                <th>분야</th>
                                <th>날짜</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody id="volunteersTableBody">
                            <tr>
                                <td colspan="7" class="loading">
                                    <i class="fas fa-spinner fa-spin"></i> 데이터 로딩 중...
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="pagination" id="volunteersPagination"></div>
                </div>
            </section>

        </main>
    </div>

    <!-- 공지사항 모달 -->
    <div id="noticeModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">공지사항 작성</h2>
                <button class="modal-close" onclick="closeNoticeModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="noticeForm">
                    <div class="form-group">
                        <label class="form-label">제목</label>
                        <input type="text" class="form-input" name="title" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">내용</label>
                        <textarea class="form-textarea" name="content" required></textarea>
                    </div>
                    <div class="form-group">
                        <label>
                            <input type="checkbox" name="isPinned" value="true">
                            상단 고정
                        </label>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn-cancel" onclick="closeNoticeModal()">취소</button>
                <button class="btn-submit" onclick="submitNotice()">등록</button>
            </div>
        </div>
    </div>

    <!-- FAQ 모달 -->
    <div id="faqModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">FAQ 작성</h2>
                <button class="modal-close" onclick="closeFaqModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="faqForm">
                    <div class="form-group">
                        <label class="form-label">카테고리</label>
                        <select class="form-select" name="category" required>
                            <option value="">선택하세요</option>
                            <option value="복지혜택">복지혜택</option>
                            <option value="서비스이용">서비스이용</option>
                            <option value="계정관리">계정관리</option>
                            <option value="기타">기타</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">질문</label>
                        <input type="text" class="form-input" name="question" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">답변</label>
                        <textarea class="form-textarea" name="answer" required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn-cancel" onclick="closeFaqModal()">취소</button>
                <button class="btn-submit" onclick="submitFaq()">등록</button>
            </div>
        </div>
    </div>

    <!-- 회원 수정 모달 -->
    <div id="memberModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">회원 정보 수정</h2>
                <button class="modal-close" onclick="closeMemberModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="memberForm">
                    <input type="hidden" id="editUserId" name="userId">
                    <div class="form-group">
                        <label class="form-label">아이디</label>
                        <input type="text" class="form-input" id="editUserIdDisplay" disabled style="background-color: #f5f5f5; cursor: not-allowed;">
                        <small style="color: #666; font-size: 12px;">아이디는 보안상 수정할 수 없습니다.</small>
                    </div>
                    <div class="form-group">
                        <label class="form-label">이름</label>
                        <input type="text" class="form-input" id="editName" name="name" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">이메일</label>
                        <input type="email" class="form-input" id="editEmail" name="email" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">전화번호</label>
                        <input type="text" class="form-input" id="editPhone" name="phone">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn-cancel" onclick="closeMemberModal()">취소</button>
                <button class="btn-submit" onclick="submitMemberEdit()">수정</button>
            </div>
        </div>
    </div>

    <!-- 기부 상세 모달 -->
    <div id="donationModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">기부 상세 정보</h2>
                <button class="modal-close" onclick="closeDonationModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div class="donation-detail">
                    <div class="detail-row">
                        <span class="detail-label">기부 번호:</span>
                        <span class="detail-value" id="detailDonationId">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">후원자명:</span>
                        <span class="detail-value" id="detailDonorName">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">이메일:</span>
                        <span class="detail-value" id="detailDonorEmail">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">전화번호:</span>
                        <span class="detail-value" id="detailDonorPhone">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">기부 금액:</span>
                        <span class="detail-value" id="detailAmount" style="font-weight: 600; color: #667eea;">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">기부 유형:</span>
                        <span class="detail-value" id="detailDonationType">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">기부 분야:</span>
                        <span class="detail-value" id="detailCategory">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">패키지명:</span>
                        <span class="detail-value" id="detailPackageName">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">결제 수단:</span>
                        <span class="detail-value" id="detailPaymentMethod">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">결제 상태:</span>
                        <span class="detail-value" id="detailPaymentStatus">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">기부 일시:</span>
                        <span class="detail-value" id="detailCreatedAt">-</span>
                    </div>
                    <div class="detail-row full-width">
                        <span class="detail-label">후원 메시지:</span>
                        <p class="detail-message" id="detailMessage">-</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn-cancel" onclick="closeDonationModal()">닫기</button>
            </div>
        </div>
    </div>

    <script>
        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            loadDashboardStats();
            loadMembers();
        });

        // 섹션 전환
        function showSection(sectionId) {
            // 모든 섹션 숨기기
            document.querySelectorAll('.content-section').forEach(section => {
                section.classList.remove('active');
            });

            // 모든 메뉴 아이템 비활성화
            document.querySelectorAll('.menu-item').forEach(item => {
                item.classList.remove('active');
            });

            // 선택한 섹션 표시
            document.getElementById(sectionId).classList.add('active');

            // 선택한 메뉴 아이템 활성화
            event.currentTarget.classList.add('active');

            // 섹션별 데이터 로드
            switch(sectionId) {
                case 'dashboard':
                    loadDashboardStats();
                    break;
                case 'members':
                    loadMembers();
                    break;
                case 'member-history':
                    loadMemberHistory();
                    break;
                case 'notices':
                    loadNotices();
                    break;
                case 'faqs':
                    loadFaqs();
                    break;
                case 'donations':
                    loadDonations();
                    break;
                case 'volunteers':
                    loadVolunteers();
                    break;
            }
        }

        // 대시보드 통계 로드
        function loadDashboardStats() {
            fetch('/bdproject/api/admin/stats')
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        const data = result.data;

                        // 전체 회원 수
                        document.getElementById('totalMembers').textContent = formatNumber(data.totalMembers);

                        // 총 기부금
                        document.getElementById('totalDonations').textContent = '₩' + formatMoney(data.totalDonations);

                        // 봉사 신청 수
                        document.getElementById('totalVolunteers').textContent = formatNumber(data.totalVolunteers);

                        // 최근 활동 표시
                        document.getElementById('recentActivity').innerHTML = `
                            <div style="padding: 20px; color: #6c757d;">
                                <p style="margin-bottom: 10px;"><i class="fas fa-users"></i> 전체 회원: \${formatNumber(data.totalMembers)}명</p>
                                <p style="margin-bottom: 10px;"><i class="fas fa-hand-holding-heart"></i> 총 기부금: ₩\${formatMoney(data.totalDonations)}</p>
                                <p><i class="fas fa-hands-helping"></i> 봉사 신청: \${formatNumber(data.totalVolunteers)}건</p>
                            </div>
                        `;
                    } else {
                        console.error('통계 로드 실패:', result.message);
                        // 오류 시 기본값 표시
                        document.getElementById('totalMembers').textContent = '0';
                        document.getElementById('totalDonations').textContent = '₩0';
                        document.getElementById('totalVolunteers').textContent = '0';
                    }
                })
                .catch(error => {
                    console.error('통계 로드 오류:', error);
                    // 오류 시 기본값 표시
                    document.getElementById('totalMembers').textContent = '0';
                    document.getElementById('totalDonations').textContent = '₩0';
                    document.getElementById('totalVolunteers').textContent = '0';
                });
        }

        // 숫자 포맷팅 (천단위 콤마)
        function formatNumber(num) {
            return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }

        // 금액 포맷팅 (천단위 콤마, M/K 단위)
        function formatMoney(amount) {
            if (amount >= 1000000) {
                return (amount / 1000000).toFixed(1) + 'M';
            } else if (amount >= 1000) {
                return (amount / 1000).toFixed(0) + 'K';
            }
            return formatNumber(amount);
        }

        // 회원 상태 변경 이력 로드
        function loadMemberHistory() {
            const tbody = document.getElementById('historyTableBody');
            tbody.innerHTML = '<tr><td colspan="9" style="text-align: center;">로딩 중...</td></tr>';

            fetch('/bdproject/api/admin/member/history')
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        const history = result.data;
                        if (history.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="9" style="text-align: center;">등록된 상태 변경 이력이 없습니다.</td></tr>';
                            return;
                        }

                        tbody.innerHTML = history.map((item, index) => {
                            // 상태 한글 변환
                            const statusMap = {
                                'ACTIVE': '활성',
                                'SUSPENDED': '정지',
                                'DORMANT': '휴면'
                            };

                            const oldStatus = statusMap[item.oldStatus] || item.oldStatus;
                            const newStatus = statusMap[item.newStatus] || item.newStatus;

                            // 상태 변경 타입에 따른 뱃지 색상
                            const oldStatusClass = item.oldStatus === 'ACTIVE' ? 'badge-success' : 'badge-danger';
                            const newStatusClass = item.newStatus === 'ACTIVE' ? 'badge-success' : 'badge-danger';

                            return `
                            <tr>
                                <td>\${index + 1}</td>
                                <td>\${item.memberEmail || '-'}</td>
                                <td>\${item.memberName || '-'}</td>
                                <td><span class="badge \${oldStatusClass}">\${oldStatus}</span></td>
                                <td><span class="badge \${newStatusClass}">\${newStatus}</span></td>
                                <td>\${item.reason || '사유 없음'}</td>
                                <td>\${item.adminEmail || '시스템'}</td>
                                <td>\${item.createdAt || '-'}</td>
                                <td>\${item.ipAddress || '-'}</td>
                            </tr>
                            `;
                        }).join('');
                    } else {
                        tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
                    }
                })
                .catch(error => {
                    console.error('상태 변경 이력 로드 실패:', error);
                    tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
                });
        }

        // 회원 목록 로드
        function loadMembers() {
            const tbody = document.getElementById('membersTableBody');
            tbody.innerHTML = '<tr><td colspan="9" style="text-align: center;">로딩 중...</td></tr>';

            fetch('/bdproject/api/admin/members')
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        const members = result.data;
                        if (members.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="9" style="text-align: center;">등록된 회원이 없습니다.</td></tr>';
                            return;
                        }
                        tbody.innerHTML = members.map((member, index) => {
                            const roleText = member.role === 'ADMIN' ? 'MANAGER' : 'USER';
                            const roleClass = member.role === 'ADMIN' ? 'badge-admin' : 'badge-user';

                            // 상태 표시
                            const status = member.status || 'ACTIVE';
                            const statusText = status === 'ACTIVE' ? '활성' : '정지';
                            const statusClass = status === 'ACTIVE' ? 'badge-success' : 'badge-danger';

                            // 정지/활성화 버튼
                            const statusButton = status === 'ACTIVE'
                                ? `<button class="btn-sm btn-warning" onclick="suspendMember('\${member.userId}')" title="계정 정지">
                                        <i class="fas fa-ban"></i>
                                   </button>`
                                : `<button class="btn-sm btn-success" onclick="activateMember('\${member.userId}')" title="계정 활성화">
                                        <i class="fas fa-check-circle"></i>
                                   </button>`;

                            return `
                            <tr>
                                <td>\${index + 1}</td>
                                <td>\${member.userId || '-'}</td>
                                <td>\${member.name || '-'}</td>
                                <td>\${member.email || '-'}</td>
                                <td>\${member.phone || '-'}</td>
                                <td><span class="badge \${roleClass}">\${roleText}</span></td>
                                <td><span class="badge \${statusClass}">\${statusText}</span></td>
                                <td>\${member.createdAt || '-'}</td>
                                <td class="table-actions">
                                    <button class="btn-sm btn-edit" onclick="editMember('\${member.userId}', '\${member.name}', '\${member.email}', '\${member.phone}')" title="회원 정보 수정">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    \${statusButton}
                                    <button class="btn-sm btn-delete" onclick="deleteMember('\${member.userId}')" title="회원 삭제">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                            `;
                        }).join('');
                    } else {
                        tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
                    }
                })
                .catch(error => {
                    console.error('회원 목록 로드 실패:', error);
                    tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
                });
        }

        // 공지사항 목록 로드
        function loadNotices() {
            const tbody = document.getElementById('noticesTableBody');
            tbody.innerHTML = '<tr><td colspan="6" style="text-align: center;">로딩 중...</td></tr>';

            fetch('/bdproject/api/admin/notices')
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        const notices = result.data;
                        if (notices.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="6" style="text-align: center;">등록된 공지사항이 없습니다.</td></tr>';
                            return;
                        }
                        tbody.innerHTML = notices.map(notice => `
                            <tr>
                                <td>\${notice.noticeId || '-'}</td>
                                <td>\${notice.title || '-'}</td>
                                <td>\${notice.views || 0}</td>
                                <td><span class="badge \${notice.isPinned ? 'badge-success' : 'badge-warning'}">\${notice.isPinned ? '고정' : '일반'}</span></td>
                                <td>\${notice.createdAt || '-'}</td>
                                <td class="table-actions">
                                    <button class="btn-sm btn-view" onclick="viewNotice(\${notice.noticeId})">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn-sm btn-edit" onclick="editNotice(\${notice.noticeId})">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn-sm btn-delete" onclick="deleteNotice(\${notice.noticeId})">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        `).join('');
                    } else {
                        tbody.innerHTML = '<tr><td colspan="6" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
                    }
                })
                .catch(error => {
                    console.error('공지사항 목록 로드 실패:', error);
                    tbody.innerHTML = '<tr><td colspan="6" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
                });
        }

        // FAQ 목록 로드
        function loadFaqs() {
            const tbody = document.getElementById('faqsTableBody');
            tbody.innerHTML = '<tr><td colspan="4" style="text-align: center;">로딩 중...</td></tr>';

            fetch('/bdproject/api/admin/faqs')
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        const faqs = result.data;
                        if (faqs.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="4" style="text-align: center;">등록된 FAQ가 없습니다.</td></tr>';
                            return;
                        }
                        tbody.innerHTML = faqs.map(faq => `
                            <tr>
                                <td>\${faq.faqId || '-'}</td>
                                <td><span class="badge badge-user">\${faq.category || '-'}</span></td>
                                <td>\${faq.question || '-'}</td>
                                <td class="table-actions">
                                    <button class="btn-sm btn-view" onclick="viewFaq(\${faq.faqId})">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn-sm btn-edit" onclick="editFaq(\${faq.faqId})">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn-sm btn-delete" onclick="deleteFaq(\${faq.faqId})">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        `).join('');
                    } else {
                        tbody.innerHTML = '<tr><td colspan="4" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
                    }
                })
                .catch(error => {
                    console.error('FAQ 목록 로드 실패:', error);
                    tbody.innerHTML = '<tr><td colspan="4" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
                });
        }

        // 기부 내역 로드
        function loadDonations() {
            const tbody = document.getElementById('donationsTableBody');
            tbody.innerHTML = '<tr><td colspan="8" style="text-align: center;">로딩 중...</td></tr>';

            fetch('/bdproject/api/admin/donations')
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        const donations = result.data;
                        if (donations.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="8" style="text-align: center;">등록된 기부 내역이 없습니다.</td></tr>';
                            return;
                        }

                        // 전역 변수에 저장 (viewDonation에서 사용)
                        window.donationsData = donations;

                        tbody.innerHTML = donations.map((donation, index) => `
                            <tr>
                                <td>\${donation.donationId || '-'}</td>
                                <td>\${donation.donorName || '-'}</td>
                                <td>₩\${formatNumber(donation.amount || 0)}</td>
                                <td><span class="badge badge-user">\${donation.donationType === 'regular' ? '정기' : '일시'}</span></td>
                                <td>\${donation.category || '-'}</td>
                                <td><span class="badge badge-success">\${donation.paymentStatus === 'completed' ? '완료' : '대기'}</span></td>
                                <td>\${donation.createdAt || '-'}</td>
                                <td class="table-actions">
                                    <button class="btn-sm btn-view" onclick="viewDonation(\${index})" title="상세 보기">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </td>
                            </tr>
                        `).join('');
                    } else {
                        tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
                    }
                })
                .catch(error => {
                    console.error('기부 내역 로드 실패:', error);
                    tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
                });
        }

        // 봉사활동 목록 로드
        function loadVolunteers() {
            const tbody = document.getElementById('volunteersTableBody');
            tbody.innerHTML = '<tr><td colspan="7" style="text-align: center;">로딩 중...</td></tr>';

            fetch('/bdproject/api/admin/volunteers')
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        const volunteers = result.data;
                        if (volunteers.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="7" style="text-align: center;">등록된 봉사 신청이 없습니다.</td></tr>';
                            return;
                        }
                        tbody.innerHTML = volunteers.map(volunteer => `
                            <tr>
                                <td>\${volunteer.applicationId || '-'}</td>
                                <td>\${volunteer.applicantName || '-'}</td>
                                <td>\${volunteer.activityName || '-'}</td>
                                <td><span class="badge badge-user">\${volunteer.selectedCategory || '-'}</span></td>
                                <td>\${volunteer.volunteerDate || '-'}</td>
                                <td><span class="badge \${
                                    volunteer.status === 'completed' ? 'badge-success' :
                                    volunteer.status === 'confirmed' ? 'badge-warning' : 'badge-user'
                                }">\${
                                    volunteer.status === 'completed' ? '완료' :
                                    volunteer.status === 'confirmed' ? '확정' : '신청'
                                }</span></td>
                                <td class="table-actions">
                                    <button class="btn-sm btn-view" onclick="viewVolunteer(\${volunteer.applicationId})">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn-sm btn-edit" onclick="editVolunteer(\${volunteer.applicationId})">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                </td>
                            </tr>
                        `).join('');
                    } else {
                        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
                    }
                })
                .catch(error => {
                    console.error('봉사 신청 목록 로드 실패:', error);
                    tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
                });
        }

        // 모달 관련 함수들
        function openNoticeModal() {
            document.getElementById('noticeModal').classList.add('active');
        }

        function closeNoticeModal() {
            document.getElementById('noticeModal').classList.remove('active');
            document.getElementById('noticeForm').reset();
        }

        function openFaqModal() {
            document.getElementById('faqModal').classList.add('active');
        }

        function closeFaqModal() {
            document.getElementById('faqModal').classList.remove('active');
            document.getElementById('faqForm').reset();
        }

        function openVolunteerModal() {
            alert('봉사활동 등록 기능은 추후 구현 예정입니다.');
        }

        // 공지사항 제출
        function submitNotice() {
            const form = document.getElementById('noticeForm');
            const formData = new FormData(form);

            // 입력값 검증
            const title = formData.get('title');
            const content = formData.get('content');
            const isPinned = formData.get('isPinned') === 'true';

            if (!title || title.trim() === '') {
                alert('제목을 입력해주세요.');
                return;
            }

            if (!content || content.trim() === '') {
                alert('내용을 입력해주세요.');
                return;
            }

            // URLSearchParams로 변환
            const params = new URLSearchParams();
            params.append('title', title);
            params.append('content', content);
            params.append('isPinned', isPinned);

            // API 호출
            fetch('/bdproject/api/notices', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(response => {
                console.log('Response status:', response.status);
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(result => {
                console.log('API 응답:', result);
                if (result.success) {
                    alert('공지사항이 등록되었습니다.');
                    closeNoticeModal();
                    form.reset();
                    loadNotices(); // 목록 새로고침
                } else {
                    alert('등록 실패: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('공지사항 등록 오류:', error);
                alert('공지사항 등록 중 오류가 발생했습니다: ' + error.message);
            });
        }

        // FAQ 제출
        function submitFaq() {
            const form = document.getElementById('faqForm');
            const formData = new FormData(form);

            // 여기에 실제 API 호출 코드 추가
            alert('FAQ가 등록되었습니다.');
            closeFaqModal();
            loadFaqs();
        }

        // 검색 함수들
        function searchMembers() {
            const searchTerm = document.getElementById('memberSearch').value.toLowerCase().trim();
            const tbody = document.getElementById('membersTableBody');
            const rows = tbody.querySelectorAll('tr');

            if (!searchTerm) {
                // 검색어가 없으면 모두 표시
                rows.forEach(row => row.style.display = '');
                return;
            }

            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                if (text.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function searchHistory() {
            const searchTerm = document.getElementById('historySearch').value.toLowerCase().trim();
            const tbody = document.getElementById('historyTableBody');
            const rows = tbody.querySelectorAll('tr');

            if (!searchTerm) {
                rows.forEach(row => row.style.display = '');
                return;
            }

            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                if (text.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function searchDonations() {
            const searchTerm = document.getElementById('donationSearch').value.toLowerCase().trim();
            const tbody = document.getElementById('donationsTableBody');
            const rows = tbody.querySelectorAll('tr');

            if (!searchTerm) {
                rows.forEach(row => row.style.display = '');
                return;
            }

            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                if (text.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        // 회원 관련 함수들
        function editMember(userId, name, email, phone) {
            document.getElementById('editUserId').value = userId;
            document.getElementById('editUserIdDisplay').value = userId;
            document.getElementById('editName').value = name;
            document.getElementById('editEmail').value = email;
            document.getElementById('editPhone').value = phone || '';
            document.getElementById('memberModal').classList.add('active');
        }

        function closeMemberModal() {
            document.getElementById('memberModal').classList.remove('active');
            document.getElementById('memberForm').reset();
        }

        function submitMemberEdit() {
            const userId = document.getElementById('editUserId').value;
            const name = document.getElementById('editName').value;
            const email = document.getElementById('editEmail').value;
            const phone = document.getElementById('editPhone').value;

            if (!name || !email) {
                alert('이름과 이메일은 필수 입력 항목입니다.');
                return;
            }

            const params = new URLSearchParams();
            params.append('userId', userId);
            params.append('name', name);
            params.append('email', email);
            params.append('phone', phone);

            fetch('/bdproject/api/admin/member/update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    alert('회원 정보가 수정되었습니다.');
                    closeMemberModal();
                    loadMembers();
                } else {
                    alert('수정 실패: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('회원 수정 오류:', error);
                alert('회원 수정 중 오류가 발생했습니다.');
            });
        }

        function deleteMember(userId) {
            if (!confirm('정말 삭제하시겠습니까?')) {
                return;
            }

            fetch(`/bdproject/api/admin/member/delete?userId=\${userId}`, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    alert('회원이 삭제되었습니다.');
                    loadMembers();
                } else {
                    alert('삭제 실패: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('회원 삭제 오류:', error);
                alert('회원 삭제 중 오류가 발생했습니다.');
            });
        }

        // 회원 계정 정지
        function suspendMember(userId) {
            if (!confirm('이 계정을 정지하시겠습니까?\n정지된 계정은 로그인할 수 없습니다.')) {
                return;
            }

            fetch(`/bdproject/api/admin/member/suspend?userId=\${userId}`, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    alert('계정이 정지되었습니다.');
                    loadMembers();
                } else {
                    alert('정지 실패: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('계정 정지 오류:', error);
                alert('계정 정지 중 오류가 발생했습니다.');
            });
        }

        // 회원 계정 활성화
        function activateMember(userId) {
            if (!confirm('이 계정을 활성화하시겠습니까?')) {
                return;
            }

            fetch(`/bdproject/api/admin/member/activate?userId=\${userId}`, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    alert('계정이 활성화되었습니다.');
                    loadMembers();
                } else {
                    alert('활성화 실패: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('계정 활성화 오류:', error);
                alert('계정 활성화 중 오류가 발생했습니다.');
            });
        }

        function viewNotice(id) {
            alert('공지사항 상세 보기 기능은 추후 구현 예정입니다.');
        }

        function editNotice(id) {
            alert('공지사항 수정 기능은 추후 구현 예정입니다.');
        }

        function deleteNotice(id) {
            if (!confirm('정말 삭제하시겠습니까?')) {
                return;
            }

            fetch(`/bdproject/api/notices/\${id}/delete`, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    alert('공지사항이 삭제되었습니다.');
                    loadNotices(); // 목록 새로고침
                } else {
                    alert('삭제 실패: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('공지사항 삭제 오류:', error);
                alert('공지사항 삭제 중 오류가 발생했습니다.');
            });
        }

        function viewFaq(id) { alert('FAQ 상세: ' + id); }
        function editFaq(id) { alert('FAQ 수정: ' + id); }
        function deleteFaq(id) { if(confirm('정말 삭제하시겠습니까?')) alert('FAQ 삭제: ' + id); }

        // 기부 상세 보기
        function viewDonation(index) {
            const donation = window.donationsData[index];
            if (!donation) {
                alert('기부 정보를 찾을 수 없습니다.');
                return;
            }

            // 결제수단 변환
            const paymentMethodMap = {
                'credit_card': '신용카드',
                'bank_transfer': '계좌이체',
                'kakao_pay': '카카오페이',
                'naver_pay': '네이버페이'
            };

            // 모달에 데이터 채우기
            document.getElementById('detailDonationId').textContent = donation.donationId || '-';
            document.getElementById('detailDonorName').textContent = donation.donorName || '-';
            document.getElementById('detailDonorEmail').textContent = donation.donorEmail || '-';
            document.getElementById('detailDonorPhone').textContent = donation.donorPhone || '-';
            document.getElementById('detailAmount').textContent = '₩' + formatNumber(donation.amount || 0);
            document.getElementById('detailDonationType').textContent = donation.donationType === 'regular' ? '정기 후원' : '일시 후원';
            document.getElementById('detailCategory').textContent = donation.category || '-';
            document.getElementById('detailPackageName').textContent = donation.packageName || '-';
            document.getElementById('detailPaymentMethod').textContent = paymentMethodMap[donation.paymentMethod] || donation.paymentMethod || '-';
            document.getElementById('detailPaymentStatus').textContent = donation.paymentStatus === 'completed' ? '완료' : '대기';
            document.getElementById('detailCreatedAt').textContent = donation.createdAt || '-';
            document.getElementById('detailMessage').textContent = donation.message || '메시지 없음';

            // 모달 열기
            const modal = document.getElementById('donationModal');
            modal.classList.add('active');
            modal.style.display = 'flex';
        }

        // 기부 상세 모달 닫기
        function closeDonationModal() {
            const modal = document.getElementById('donationModal');
            modal.classList.remove('active');
            modal.style.display = 'none';
        }

        function viewVolunteer(id) { alert('봉사신청 상세: ' + id); }
        function editVolunteer(id) { alert('봉사신청 수정: ' + id); }

        // 로그아웃 함수
        function logout() {
            if (confirm('로그아웃 하시겠습니까?')) {
                window.location.href = '/bdproject/login/logout';
            }
        }
    </script>
</body>
</html>
