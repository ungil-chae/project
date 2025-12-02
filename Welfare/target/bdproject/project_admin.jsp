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
        response.sendRedirect("/bdproject/projectLogin.jsp");
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
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

        /* 대시보드 상단 통계 카드 */
        .dashboard-stats-row {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 15px;
            margin-bottom: 25px;
        }

        .dashboard-stat-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border-top: 3px solid #4a90d9;
        }

        .dashboard-stat-card:nth-child(2) { border-top-color: #5cb85c; }
        .dashboard-stat-card:nth-child(3) { border-top-color: #f0ad4e; }
        .dashboard-stat-card:nth-child(4) { border-top-color: #5bc0de; }
        .dashboard-stat-card:nth-child(5) { border-top-color: #d9534f; }
        .dashboard-stat-card:nth-child(6) { border-top-color: #9b59b6; }

        .stat-card-label {
            font-size: 12px;
            color: #6c757d;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .stat-card-value {
            font-size: 24px;
            font-weight: 700;
            color: #2c3e50;
        }

        /* 차트 그리드 */
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .chart-box {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 20px;
        }

        .chart-box-title {
            font-size: 14px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .chart-box canvas {
            max-height: 250px;
        }

        @media (max-width: 1400px) {
            .dashboard-stats-row {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 992px) {
            .dashboard-stats-row {
                grid-template-columns: repeat(2, 1fr);
            }
            .charts-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 576px) {
            .dashboard-stats-row {
                grid-template-columns: 1fr;
            }
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

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
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

                <!-- 상단 통계 카드 6개 -->
                <div class="dashboard-stats-row">
                    <div class="dashboard-stat-card">
                        <div class="stat-card-label">오늘 기부 건수</div>
                        <div class="stat-card-value" id="todayDonations">0건</div>
                    </div>
                    <div class="dashboard-stat-card">
                        <div class="stat-card-label">진행 중인 봉사활동 수</div>
                        <div class="stat-card-value" id="activeVolunteers">0건</div>
                    </div>
                    <div class="dashboard-stat-card">
                        <div class="stat-card-label">봉사 완료율</div>
                        <div class="stat-card-value" id="volunteerCompletionRate">0%</div>
                    </div>
                    <div class="dashboard-stat-card">
                        <div class="stat-card-label">총 기부금액</div>
                        <div class="stat-card-value" id="totalDonations">0원</div>
                    </div>
                    <div class="dashboard-stat-card">
                        <div class="stat-card-label">복지 진단 건수</div>
                        <div class="stat-card-value" id="totalDiagnoses">0건</div>
                    </div>
                    <div class="dashboard-stat-card">
                        <div class="stat-card-label">활동 중인 총 회원 수</div>
                        <div class="stat-card-value" id="totalMembers">0명</div>
                    </div>
                </div>

                <!-- 차트 그리드 -->
                <div class="charts-grid">
                    <!-- 최근 6개월 기부금 현황 (선형 차트) -->
                    <div class="chart-box">
                        <div class="chart-box-title">최근 6개월 간 기부금 현황</div>
                        <canvas id="donationTrendChart"></canvas>
                    </div>

                    <!-- 회원 증가 추이 (영역 차트) -->
                    <div class="chart-box">
                        <div class="chart-box-title">회원 증가 추이</div>
                        <canvas id="memberGrowthChart"></canvas>
                    </div>

                    <!-- 봉사활동 카테고리별 신청률 (막대 차트) -->
                    <div class="chart-box">
                        <div class="chart-box-title">봉사활동 카테고리별 신청률</div>
                        <canvas id="volunteerCategoryChart"></canvas>
                    </div>

                    <!-- 월별 봉사활동 현황 (막대 차트) -->
                    <div class="chart-box">
                        <div class="chart-box-title">월별 봉사활동 현황</div>
                        <canvas id="volunteerMonthlyChart"></canvas>
                    </div>

                    <!-- 복지서비스 이용 비율 (도넛 차트) -->
                    <div class="chart-box">
                        <div class="chart-box-title">복지서비스 이용 비율</div>
                        <canvas id="welfareServiceChart"></canvas>
                    </div>

                    <!-- 기부 카테고리별 분포 (도넛 차트) -->
                    <div class="chart-box">
                        <div class="chart-box-title">기부 카테고리별 분포</div>
                        <canvas id="donationCategoryChart"></canvas>
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
                    <!-- 필터 및 검색 영역 -->
                    <div class="table-header" style="flex-wrap: wrap; gap: 15px; padding: 20px 25px;">
                        <div class="table-title" style="width: 100%; margin-bottom: 10px;">전체 회원 리스트</div>

                        <div style="display: flex; gap: 10px; align-items: center; flex: 1;">
                            <select class="form-select" id="statusFilter" style="width: 150px; padding: 8px 12px;">
                                <option value="">모든 상태</option>
                                <option value="ACTIVE">활동중</option>
                                <option value="SUSPENDED">활동정지</option>
                                <option value="DORMANT">휴면</option>
                            </select>

                            <select class="form-select" id="roleFilter" style="width: 150px; padding: 8px 12px;">
                                <option value="">모든 등급</option>
                                <option value="USER">USER</option>
                                <option value="ADMIN">MANAGER</option>
                            </select>

                            <input type="text" class="search-input" id="memberSearch" placeholder="Search Here" style="flex: 1; max-width: 300px;">

                            <button class="search-btn" onclick="filterMembers()" style="white-space: nowrap;">
                                <i class="fas fa-search"></i> 전체조회
                            </button>
                        </div>

                        <div style="display: flex; gap: 10px; align-items: center;">
                            <select class="form-select" id="bulkActionSelect" style="width: 180px; padding: 8px 12px;">
                                <option value="">활동 상태 변경</option>
                                <option value="activate">활동중</option>
                                <option value="suspend">활동정지</option>
                                <option value="dormant">탈퇴</option>
                            </select>

                            <select class="form-select" id="bulkRoleSelect" style="width: 150px; padding: 8px 12px;">
                                <option value="">등급 변경</option>
                                <option value="USER">USER</option>
                                <option value="ADMIN">MANAGER</option>
                            </select>

                            <button class="action-btn" onclick="applyBulkAction()" style="white-space: nowrap; background: #667eea;">
                                <i class="fas fa-check"></i> 변경적용
                            </button>
                        </div>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="width: 40px;">
                                    <input type="checkbox" id="selectAllMembers" onchange="toggleSelectAll(this)">
                                </th>
                                <th>이메일/아이디</th>
                                <th>이름</th>
                                <th>휴대폰번호</th>
                                <th>가입일시</th>
                                <th>활동상태</th>
                                <th>마지막 로그인 일시</th>
                                <th>활동상태 변경일시</th>
                                <th>등급</th>
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
                    <p class="content-subtitle">봉사활동 신청 현황을 관리하고 시설을 매칭합니다</p>
                </div>

                <div class="data-table-container">
                    <!-- 필터 영역 -->
                    <div class="table-header" style="flex-wrap: wrap; gap: 15px; padding: 20px 25px;">
                        <div class="table-title" style="width: 100%; margin-bottom: 10px;">봉사 신청 목록</div>

                        <div style="display: flex; gap: 10px; align-items: center; flex: 1;">
                            <select class="form-select" id="volunteerStatusFilter" style="width: 150px; padding: 8px 12px;">
                                <option value="">모든 상태</option>
                                <option value="APPLIED">신청됨</option>
                                <option value="CONFIRMED">승인됨</option>
                                <option value="COMPLETED">완료됨</option>
                                <option value="CANCELLED">취소됨</option>
                                <option value="REJECTED">거절됨</option>
                            </select>

                            <input type="text" class="search-input" id="volunteerSearch" placeholder="신청자 이름, 이메일, 전화번호 검색" style="flex: 1; max-width: 350px;">

                            <button class="search-btn" onclick="filterVolunteers()" style="white-space: nowrap;">
                                <i class="fas fa-search"></i> 검색
                            </button>
                        </div>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="width: 50px;">번호</th>
                                <th>신청자 정보</th>
                                <th>봉사 분야</th>
                                <th>봉사 일정</th>
                                <th>신청일시</th>
                                <th>상태</th>
                                <th>배정 시설</th>
                                <th style="width: 150px;">관리</th>
                            </tr>
                        </thead>
                        <tbody id="volunteersTableBody">
                            <tr>
                                <td colspan="8" class="loading">
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
                <h2 class="modal-title" id="noticeModalTitle">공지사항 작성</h2>
                <button class="modal-close" onclick="closeNoticeModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="noticeForm">
                    <input type="hidden" name="noticeId" id="noticeId">
                    <div class="form-group">
                        <label class="form-label">제목</label>
                        <input type="text" class="form-input" name="title" id="noticeTitle" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">내용</label>
                        <textarea class="form-textarea" name="content" id="noticeContent" required></textarea>
                    </div>
                    <div class="form-group">
                        <label>
                            <input type="checkbox" name="isPinned" id="noticePinned" value="true">
                            상단 고정
                        </label>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn-cancel" onclick="closeNoticeModal()">취소</button>
                <button class="btn-submit" id="noticeSubmitBtn" onclick="submitNotice()">등록</button>
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

    <!-- 봉사활동 시설 매칭 모달 -->
    <div id="facilityMatchModal" class="modal">
        <div class="modal-content" style="max-width: 700px;">
            <div class="modal-header">
                <h2 class="modal-title">봉사활동 승인 및 시설 배정</h2>
                <button class="modal-close" onclick="closeFacilityMatchModal()">&times;</button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="matchApplicationId">

                <!-- 신청자 상세 정보 -->
                <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <h3 style="margin: 0 0 15px 0; font-size: 16px; color: #333; border-bottom: 2px solid #667eea; padding-bottom: 10px;">
                        <i class="fas fa-user-circle"></i> 신청자 정보
                    </h3>
                    <div style="display: grid; grid-template-columns: 120px 1fr; gap: 10px; font-size: 14px;">
                        <div style="color: #666; font-weight: 500;">신청자:</div>
                        <div id="matchApplicantName" style="font-weight: 600;">-</div>

                        <div style="color: #666; font-weight: 500;">연락처:</div>
                        <div id="matchApplicantPhone">-</div>

                        <div style="color: #666; font-weight: 500;">이메일:</div>
                        <div id="matchApplicantEmail">-</div>

                        <div style="color: #666; font-weight: 500;">주소:</div>
                        <div id="matchApplicantAddress">-</div>

                        <div style="color: #666; font-weight: 500;">봉사 분야:</div>
                        <div id="matchCategory" style="color: #667eea; font-weight: 600;">-</div>

                        <div style="color: #666; font-weight: 500;">봉사 일정:</div>
                        <div id="matchSchedule" style="font-weight: 600;">-</div>

                        <div style="color: #666; font-weight: 500;">신청일시:</div>
                        <div id="matchCreatedAt">-</div>
                    </div>
                </div>

                <!-- 시설 정보 입력 -->
                <div style="background: #fff; padding: 20px; border: 2px solid #667eea; border-radius: 8px; margin-bottom: 20px;">
                    <h3 style="margin: 0 0 15px 0; font-size: 16px; color: #333; border-bottom: 2px solid #667eea; padding-bottom: 10px;">
                        <i class="fas fa-building"></i> 배정할 시설 정보
                    </h3>

                    <div style="margin-bottom: 15px;">
                        <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333; font-size: 14px;">
                            <i class="fas fa-home"></i> 시설명 <span style="color: #e74c3c;">*</span>
                        </label>
                        <input type="text" id="selectedFacilityName" placeholder="예: 행복노인복지관" required
                            style="width: 100%; padding: 12px; border: 2px solid #ddd; border-radius: 6px; font-size: 14px; transition: all 0.3s;"
                            onfocus="this.style.borderColor='#667eea'; this.style.boxShadow='0 0 0 3px rgba(102,126,234,0.1)'"
                            onblur="this.style.borderColor='#ddd'; this.style.boxShadow='none'">
                    </div>

                    <div style="margin-bottom: 15px;">
                        <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333; font-size: 14px;">
                            <i class="fas fa-map-marker-alt"></i> 시설 주소 <span style="color: #e74c3c;">*</span>
                        </label>
                        <div style="display: flex; gap: 8px;">
                            <input type="text" id="selectedFacilityAddress" placeholder="주소 검색 버튼을 클릭하세요" readonly required
                                style="flex: 1; padding: 12px; border: 2px solid #ddd; border-radius: 6px; font-size: 14px; background: #f8f9fa; cursor: pointer;"
                                onclick="openAddressSearch()">
                            <button type="button" onclick="openAddressSearch()"
                                style="padding: 12px 20px; background: #4A90E2; color: white; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; white-space: nowrap; transition: all 0.3s; box-shadow: 0 2px 5px rgba(74,144,226,0.3);"
                                onmouseover="this.style.background='#357ABD'; this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 10px rgba(74,144,226,0.4)'"
                                onmouseout="this.style.background='#4A90E2'; this.style.transform='translateY(0)'; this.style.boxShadow='0 2px 5px rgba(74,144,226,0.3)'">
                                <i class="fas fa-search"></i> 주소 검색
                            </button>
                        </div>
                        <small style="display: block; margin-top: 6px; color: #666; font-size: 12px;">
                            <i class="fas fa-info-circle"></i> 신청자 주소: <strong id="applicantAddressHint" style="color: #4A90E2;">-</strong>
                        </small>
                    </div>

                    <input type="hidden" id="selectedFacilityLat">
                    <input type="hidden" id="selectedFacilityLng">
                </div>

                <!-- 관리자 메모 -->
                <div style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333; font-size: 14px;">
                        <i class="fas fa-sticky-note"></i> 관리자 메모 <span style="color: #999; font-weight: 400;">(선택사항)</span>
                    </label>
                    <textarea id="adminNote" rows="4" placeholder="신청자에게 전달할 메시지를 입력하세요 (예: 첫 방문 시 신분증 지참)"
                        style="width: 100%; padding: 12px; border: 2px solid #ddd; border-radius: 6px; font-size: 14px; resize: vertical; font-family: inherit; transition: all 0.3s;"
                        onfocus="this.style.borderColor='#667eea'; this.style.boxShadow='0 0 0 3px rgba(102,126,234,0.1)'"
                        onblur="this.style.borderColor='#ddd'; this.style.boxShadow='none'"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn-submit" onclick="approveVolunteer()">
                    <i class="fas fa-check"></i> 승인 및 시설 배정
                </button>
                <button class="btn-cancel" onclick="closeFacilityMatchModal()">취소</button>
            </div>
        </div>
    </div>

    <!-- Daum 주소 검색 API -->
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
        // Daum Postcode API 로딩 확인
        window.addEventListener('load', function() {
            if (typeof daum !== 'undefined' && typeof daum.Postcode !== 'undefined') {
                console.log('✓ Daum Postcode API 로드 성공');
            } else {
                console.error('✗ Daum Postcode API 로드 실패');
            }
        });
    </script>

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

        // 차트 인스턴스 저장
        let chartInstances = {};

        // 대시보드 통계 로드
        function loadDashboardStats() {
            fetch('/bdproject/api/admin/dashboard/stats')
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        const data = result.data;

                        // 상단 6개 카드 업데이트
                        document.getElementById('todayDonations').textContent = formatNumber(data.todayDonations || 0) + '건';
                        document.getElementById('activeVolunteers').textContent = formatNumber(data.activeVolunteers || 0) + '건';
                        document.getElementById('volunteerCompletionRate').textContent = (data.volunteerCompletionRate || 0).toFixed(2) + '%';
                        document.getElementById('totalDonations').textContent = formatMoney(data.totalDonations || 0) + '원';
                        document.getElementById('totalDiagnoses').textContent = formatNumber(data.totalDiagnoses || 0) + '건';
                        document.getElementById('totalMembers').textContent = formatNumber(data.totalMembers || 0) + '명';
                    }
                })
                .catch(error => {
                    console.error('통계 로드 오류:', error);
                });

            // 차트 데이터 로드
            loadChartData();
        }

        // 차트 데이터 로드 및 초기화
        function loadChartData() {
            console.log('차트 데이터 로드 시작...');
            fetch('/bdproject/api/admin/dashboard/charts')
                .then(response => {
                    console.log('API 응답 상태:', response.status);
                    return response.json();
                })
                .then(result => {
                    console.log('차트 API 응답:', result);
                    if (result.success) {
                        const data = result.data;
                        console.log('차트 데이터:', data);
                        initializeCharts(data);
                    } else {
                        console.warn('차트 데이터 실패:', result.message);
                        initializeChartsWithDefaultData();
                    }
                })
                .catch(error => {
                    console.error('차트 데이터 로드 오류:', error);
                    initializeChartsWithDefaultData();
                });
        }

        // 차트 초기화
        function initializeCharts(data) {
            // 기존 차트 파괴
            Object.values(chartInstances).forEach(chart => chart.destroy());
            chartInstances = {};

            // 1. 최근 6개월 기부금 현황 (선형 차트)
            const donationCtx = document.getElementById('donationTrendChart').getContext('2d');
            chartInstances.donationTrend = new Chart(donationCtx, {
                type: 'line',
                data: {
                    labels: data.donationTrend?.labels || getLastSixMonths(),
                    datasets: [{
                        label: '기부금 (원)',
                        data: data.donationTrend?.data || [0, 0, 0, 0, 0, 0],
                        borderColor: '#ff6b9d',
                        backgroundColor: 'rgba(255, 107, 157, 0.1)',
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, ticks: { callback: value => formatMoney(value) } }
                    }
                }
            });

            // 2. 회원 증가 추이 (영역 차트)
            const memberCtx = document.getElementById('memberGrowthChart').getContext('2d');
            chartInstances.memberGrowth = new Chart(memberCtx, {
                type: 'line',
                data: {
                    labels: data.memberGrowth?.labels || getLastSixMonths(),
                    datasets: [
                        {
                            label: '신규 회원',
                            data: data.memberGrowth?.newMembers || [0, 0, 0, 0, 0, 0],
                            borderColor: '#4bc0c0',
                            backgroundColor: 'rgba(75, 192, 192, 0.3)',
                            fill: true
                        },
                        {
                            label: '누적 회원',
                            data: data.memberGrowth?.totalMembers || [0, 0, 0, 0, 0, 0],
                            borderColor: '#ffce56',
                            backgroundColor: 'rgba(255, 206, 86, 0.3)',
                            fill: true
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { position: 'bottom' } },
                    scales: { y: { beginAtZero: true } }
                }
            });

            // 3. 봉사활동 카테고리별 신청률 (막대 차트)
            const volunteerCatCtx = document.getElementById('volunteerCategoryChart').getContext('2d');
            chartInstances.volunteerCategory = new Chart(volunteerCatCtx, {
                type: 'bar',
                data: {
                    labels: data.volunteerCategory?.labels || ['노인돌봄', '아동교육', '환경보호', '의료봉사', '재난구호', '문화행사'],
                    datasets: [{
                        label: '신청률 (%)',
                        data: data.volunteerCategory?.data || [0, 0, 0, 0, 0, 0],
                        backgroundColor: [
                            'rgba(255, 159, 64, 0.8)',
                            'rgba(255, 159, 64, 0.8)',
                            'rgba(255, 159, 64, 0.8)',
                            'rgba(255, 159, 64, 0.8)',
                            'rgba(255, 159, 64, 0.8)',
                            'rgba(255, 159, 64, 0.8)'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: { y: { beginAtZero: true, max: 100, ticks: { callback: value => value + '%' } } }
                }
            });

            // 4. 월별 봉사활동 현황 (막대 차트)
            const volunteerMonthCtx = document.getElementById('volunteerMonthlyChart').getContext('2d');
            chartInstances.volunteerMonthly = new Chart(volunteerMonthCtx, {
                type: 'bar',
                data: {
                    labels: data.volunteerMonthly?.labels || getLastSixMonths(),
                    datasets: [{
                        label: '봉사활동 건수',
                        data: data.volunteerMonthly?.data || [0, 0, 0, 0, 0, 0],
                        backgroundColor: 'rgba(54, 162, 235, 0.8)'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: { y: { beginAtZero: true } }
                }
            });

            // 5. 복지서비스 이용 비율 (도넛 차트)
            const welfareCtx = document.getElementById('welfareServiceChart').getContext('2d');
            chartInstances.welfareService = new Chart(welfareCtx, {
                type: 'doughnut',
                data: {
                    labels: data.welfareService?.labels || ['기부', '봉사', '복지진단', '기타'],
                    datasets: [{
                        data: data.welfareService?.data || [25, 25, 25, 25],
                        backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { position: 'bottom' } }
                }
            });

            // 6. 기부 카테고리별 분포 (도넛 차트)
            const categoryCtx = document.getElementById('donationCategoryChart').getContext('2d');
            chartInstances.donationCategory = new Chart(categoryCtx, {
                type: 'doughnut',
                data: {
                    labels: data.donationCategory?.labels || ['위기가정', '의료비', '화재피해', '한부모', '자연재해', '노숙인', '가정폭력', '자살고위험', '범죄피해'],
                    datasets: [{
                        data: data.donationCategory?.data || [0, 0, 0, 0, 0, 0, 0, 0, 0],
                        backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40', '#E7E9ED', '#8B5CF6', '#EC4899']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'right', labels: { boxWidth: 12, font: { size: 11 } } },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return context.label + ': ' + formatMoney(context.raw) + '원';
                                }
                            }
                        }
                    }
                }
            });
        }

        // 기본 데이터로 차트 초기화
        function initializeChartsWithDefaultData() {
            initializeCharts({
                donationTrend: { labels: getLastSixMonths(), data: [0, 0, 0, 0, 0, 0] },
                memberGrowth: { labels: getLastSixMonths(), newMembers: [0, 0, 0, 0, 0, 0], totalMembers: [0, 0, 0, 0, 0, 0] },
                volunteerCategory: { labels: ['노인돌봄', '아동교육', '환경보호', '의료봉사', '재난구호', '문화행사'], data: [0, 0, 0, 0, 0, 0] },
                volunteerMonthly: { labels: getLastSixMonths(), data: [0, 0, 0, 0, 0, 0] },
                welfareService: { labels: ['기부', '봉사', '복지진단', '기타'], data: [0, 0, 0, 0] },
                donationCategory: { labels: ['위기가정', '의료비', '화재피해', '한부모', '자연재해', '노숙인', '가정폭력', '자살고위험', '범죄피해'], data: [0, 0, 0, 0, 0, 0, 0, 0, 0] }
            });
        }

        // 최근 6개월 라벨 생성
        function getLastSixMonths() {
            const months = [];
            const date = new Date();
            for (let i = 5; i >= 0; i--) {
                const d = new Date(date.getFullYear(), date.getMonth() - i, 1);
                months.push((d.getMonth() + 1) + '월');
            }
            return months;
        }

        // 숫자 포맷팅 (천단위 콤마)
        function formatNumber(num) {
            return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }

        // 금액 포맷팅 (천단위 콤마, 한글 단위)
        function formatMoney(amount) {
            if (amount >= 100000000) {
                return (amount / 100000000).toFixed(1) + '억';
            } else if (amount >= 10000) {
                return Math.floor(amount / 10000) + '만';
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
                            // 상태/권한 한글 변환
                            const statusMap = {
                                'ACTIVE': '활성',
                                'SUSPENDED': '정지',
                                'DORMANT': '탈퇴',
                                'USER': '일반회원',
                                'MANAGER': '매니저',
                                'ADMIN': '관리자'
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

        // 전역 변수에 회원 데이터 저장
        let allMembersData = [];

        // 회원 목록 로드
        function loadMembers() {
            const tbody = document.getElementById('membersTableBody');
            tbody.innerHTML = '<tr><td colspan="9" style="text-align: center;">로딩 중...</td></tr>';

            fetch('/bdproject/api/admin/members')
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        allMembersData = result.data;
                        renderMemberTable(allMembersData);
                    } else {
                        tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
                    }
                })
                .catch(error => {
                    console.error('회원 목록 로드 실패:', error);
                    tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
                });
        }

        // 회원 테이블 렌더링
        function renderMemberTable(members) {
            const tbody = document.getElementById('membersTableBody');

            if (members.length === 0) {
                tbody.innerHTML = '<tr><td colspan="9" style="text-align: center;">등록된 회원이 없습니다.</td></tr>';
                return;
            }

            tbody.innerHTML = members.map((member, index) => {
                const roleText = member.role === 'ADMIN' ? 'MANAGER' : 'USER';
                const roleClass = member.role === 'ADMIN' ? 'badge-admin' : 'badge-user';

                // 상태 표시
                const status = member.status || 'ACTIVE';
                let statusText = '';
                let statusClass = '';

                if (status === 'ACTIVE') {
                    statusText = '활동중';
                    statusClass = 'badge-success';
                } else if (status === 'SUSPENDED') {
                    statusText = '활동정지';
                    statusClass = 'badge-warning';
                } else if (status === 'DORMANT') {
                    statusText = '탈퇴';
                    statusClass = 'badge-danger';
                } else {
                    statusText = '활동중';
                    statusClass = 'badge-success';
                }

                // 날짜 포맷팅
                const createdAt = member.createdAt ? formatDateTime(member.createdAt) : '-';
                const lastLoginAt = member.lastLoginAt ? formatDateTime(member.lastLoginAt) : '-';
                const statusUpdatedAt = member.statusUpdatedAt ? formatDateTime(member.statusUpdatedAt) : '-';

                return '<tr data-user-id="' + member.userId + '">' +
                        '<td><input type="checkbox" class="member-checkbox" value="' + member.userId + '"' + (member.role === 'ADMIN' ? ' disabled' : '') + '></td>' +
                        '<td>' + (member.email || '-') + '<br><small style="color: #999;">' + (member.userId || '-') + '</small></td>' +
                        '<td>' + (member.name || '-') + '</td>' +
                        '<td>' + (member.phone || '-') + '</td>' +
                        '<td>' + createdAt + '</td>' +
                        '<td><span class="badge ' + statusClass + '">' + statusText + '</span></td>' +
                        '<td>' + lastLoginAt + '</td>' +
                        '<td>' + statusUpdatedAt + '</td>' +
                        '<td><span class="badge ' + roleClass + '">' + roleText + '</span></td>' +
                    '</tr>';
            }).join('');
        }

        // 날짜 시간 포맷팅
        function formatDateTime(dateString) {
            if (!dateString) return '-';
            try {
                const date = new Date(dateString);
                const year = date.getFullYear();
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const day = String(date.getDate()).padStart(2, '0');
                const hours = String(date.getHours()).padStart(2, '0');
                const minutes = String(date.getMinutes()).padStart(2, '0');
                return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;
            } catch (e) {
                return dateString;
            }
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

            // 모달을 기본 상태(작성 모드)로 되돌림
            document.getElementById('noticeModalTitle').textContent = '공지사항 작성';
            document.getElementById('noticeSubmitBtn').textContent = '등록';
            document.getElementById('noticeId').value = '';
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
            const noticeId = formData.get('noticeId');

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

            // 수정 모드인지 확인
            const isUpdate = noticeId && noticeId.trim() !== '';
            const url = isUpdate ? '/bdproject/api/notices/' + noticeId + '/update' : '/bdproject/api/notices';
            const successMessage = isUpdate ? '공지사항이 수정되었습니다.' : '공지사항이 등록되었습니다.';

            // API 호출
            fetch(url, {
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
                    alert(successMessage);
                    closeNoticeModal();
                    form.reset();
                    loadNotices(); // 목록 새로고침
                } else {
                    alert('실패: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('공지사항 처리 오류:', error);
                alert('공지사항 처리 중 오류가 발생했습니다: ' + error.message);
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

        // 필터링 함수
        function filterMembers() {
            const searchTerm = document.getElementById('memberSearch').value.toLowerCase().trim();
            const statusFilter = document.getElementById('statusFilter').value;
            const roleFilter = document.getElementById('roleFilter').value;

            let filteredMembers = allMembersData.filter(member => {
                // 검색어 필터
                const matchesSearch = !searchTerm ||
                    (member.email && member.email.toLowerCase().includes(searchTerm)) ||
                    (member.userId && member.userId.toLowerCase().includes(searchTerm)) ||
                    (member.name && member.name.toLowerCase().includes(searchTerm)) ||
                    (member.phone && member.phone.toLowerCase().includes(searchTerm));

                // 상태 필터
                const memberStatus = member.status || 'ACTIVE';
                const matchesStatus = !statusFilter || memberStatus === statusFilter;

                // 등급 필터
                const matchesRole = !roleFilter || member.role === roleFilter;

                return matchesSearch && matchesStatus && matchesRole;
            });

            renderMemberTable(filteredMembers);
        }

        // 전체 선택/해제
        function toggleSelectAll(checkbox) {
            const checkboxes = document.querySelectorAll('.member-checkbox');
            checkboxes.forEach(cb => cb.checked = checkbox.checked);
        }

        // 일괄 처리 적용
        function applyBulkAction() {
            const selectedUserIds = getSelectedUserIds();

            if (selectedUserIds.length === 0) {
                alert('회원을 선택해주세요.');
                return;
            }

            const bulkAction = document.getElementById('bulkActionSelect').value;
            const bulkRole = document.getElementById('bulkRoleSelect').value;

            if (!bulkAction && !bulkRole) {
                alert('변경할 항목을 선택해주세요.');
                return;
            }

            // 상태 변경
            if (bulkAction) {
                if (!confirm(selectedUserIds.length + '명의 회원 상태를 변경하시겠습니까?')) {
                    return;
                }
                bulkUpdateStatus(selectedUserIds, bulkAction);
            }

            // 등급 변경
            if (bulkRole) {
                if (!confirm(selectedUserIds.length + '명의 회원 등급을 ' + (bulkRole === 'ADMIN' ? 'MANAGER' : 'USER') + '로 변경하시겠습니까?')) {
                    return;
                }
                bulkUpdateRole(selectedUserIds, bulkRole);
            }
        }

        // 선택된 회원 ID 가져오기
        function getSelectedUserIds() {
            const checkboxes = document.querySelectorAll('.member-checkbox:checked');
            return Array.from(checkboxes).map(cb => cb.value);
        }

        // 일괄 상태 변경
        function bulkUpdateStatus(userIds, action) {
            const params = new URLSearchParams();
            params.append('userIds', userIds.join(','));
            params.append('action', action);

            fetch('/bdproject/api/admin/member/bulk-status', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    alert('상태가 변경되었습니다.');
                    loadMembers();
                    document.getElementById('selectAllMembers').checked = false;
                    document.getElementById('bulkActionSelect').value = '';
                } else {
                    alert('상태 변경 실패: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('일괄 상태 변경 오류:', error);
                alert('상태 변경 중 오류가 발생했습니다.');
            });
        }

        // 일괄 등급 변경
        function bulkUpdateRole(userIds, role) {
            const params = new URLSearchParams();
            params.append('userIds', userIds.join(','));
            params.append('role', role);

            fetch('/bdproject/api/admin/member/bulk-role', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    alert('등급이 변경되었습니다.');
                    loadMembers();
                    document.getElementById('selectAllMembers').checked = false;
                    document.getElementById('bulkRoleSelect').value = '';
                } else {
                    alert('등급 변경 실패: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('일괄 등급 변경 오류:', error);
                alert('등급 변경 중 오류가 발생했습니다.');
            });
        }

        // 검색 함수들
        function searchMembers() {
            filterMembers();
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
            if (!confirm('이 회원을 탈퇴 처리하시겠습니까?\n탈퇴된 계정은 로그인할 수 없습니다.')) {
                return;
            }

            fetch(`/bdproject/api/admin/member/delete?userId=\${userId}`, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    alert('회원이 탈퇴 처리되었습니다.');
                    loadMembers();
                } else {
                    alert('탈퇴 처리 실패: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('회원 탈퇴 처리 오류:', error);
                alert('회원 탈퇴 처리 중 오류가 발생했습니다.');
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
            // 공지사항 상세 조회
            fetch('/bdproject/api/notices/' + id)
                .then(response => response.json())
                .then(result => {
                    if (result.success && result.data) {
                        const notice = result.data;

                        // 폼 필드에 데이터 채우기
                        document.getElementById('noticeId').value = notice.noticeId;
                        document.getElementById('noticeTitle').value = notice.title;
                        document.getElementById('noticeContent').value = notice.content;
                        document.getElementById('noticePinned').checked = notice.isPinned;

                        // 모달 제목 및 버튼 텍스트 변경
                        document.getElementById('noticeModalTitle').textContent = '공지사항 수정';
                        document.getElementById('noticeSubmitBtn').textContent = '수정';

                        // 모달 열기
                        openNoticeModal();
                    } else {
                        alert('공지사항을 불러올 수 없습니다.');
                    }
                })
                .catch(error => {
                    console.error('공지사항 조회 오류:', error);
                    alert('공지사항 조회 중 오류가 발생했습니다.');
                });
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

        // 봉사활동 관리 관련 함수들
        let allVolunteersData = [];

        // 봉사 신청 목록 로드
        function loadVolunteers() {
            const tbody = document.getElementById('volunteersTableBody');
            tbody.innerHTML = '<tr><td colspan="8" style="text-align: center;">로딩 중...</td></tr>';

            fetch('/bdproject/api/admin/volunteers')
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        allVolunteersData = result.data;
                        renderVolunteerTable(allVolunteersData);
                    } else {
                        tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; color: red;">데이터 로드 실패</td></tr>';
                    }
                })
                .catch(error => {
                    console.error('봉사 신청 목록 로드 실패:', error);
                    tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; color: red;">오류가 발생했습니다.</td></tr>';
                });
        }

        // 봉사 신청 테이블 렌더링
        function renderVolunteerTable(volunteers) {
            const tbody = document.getElementById('volunteersTableBody');

            if (volunteers.length === 0) {
                tbody.innerHTML = '<tr><td colspan="8" style="text-align: center;">등록된 봉사 신청이 없습니다.</td></tr>';
                return;
            }

            tbody.innerHTML = volunteers.map((vol, index) => {
                const statusText = getVolunteerStatusText(vol.status);
                const statusClass = getVolunteerStatusClass(vol.status);
                const createdAt = vol.createdAt ? formatDateTime(vol.createdAt) : '-';
                const schedule = vol.volunteerDate + ' ' + (vol.volunteerTime || '');

                const facilityInfo = vol.assignedFacilityName
                    ? '<div style="font-size: 12px;"><strong>' + vol.assignedFacilityName + '</strong><br><small style="color: #666;">' + (vol.assignedFacilityAddress || '') + '</small></div>'
                    : '<span style="color: #999;">미배정</span>';

                const actionButtons = vol.status === 'APPLIED'
                    ? '<button class="btn-sm btn-success" onclick="openFacilityMatchModal(' + vol.applicationId + ')" title="승인 및 시설 배정"><i class="fas fa-check"></i> 승인</button>' +
                      '<button class="btn-sm btn-danger" onclick="rejectVolunteer(' + vol.applicationId + ')" title="거절"><i class="fas fa-times"></i></button>'
                    : '<button class="btn-sm btn-edit" onclick="viewVolunteerDetail(' + vol.applicationId + ')" title="상세보기"><i class="fas fa-eye"></i></button>';

                return '<tr>' +
                    '<td>' + (index + 1) + '</td>' +
                    '<td><strong>' + (vol.applicantName || '-') + '</strong></td>' +
                    '<td>' + (vol.selectedCategory || '-') + '</td>' +
                    '<td>' + schedule + '</td>' +
                    '<td>' + createdAt + '</td>' +
                    '<td><span class="badge ' + statusClass + '">' + statusText + '</span></td>' +
                    '<td>' + facilityInfo + '</td>' +
                    '<td class="table-actions">' + actionButtons + '</td>' +
                '</tr>';
            }).join('');
        }

        // 봉사 신청 상태 텍스트 변환
        function getVolunteerStatusText(status) {
            const statusMap = {
                'APPLIED': '신청됨',
                'CONFIRMED': '승인됨',
                'COMPLETED': '완료됨',
                'CANCELLED': '취소됨',
                'REJECTED': '거절됨'
            };
            return statusMap[status] || status;
        }

        // 봉사 신청 상태 클래스 변환
        function getVolunteerStatusClass(status) {
            const classMap = {
                'APPLIED': 'badge-warning',
                'CONFIRMED': 'badge-success',
                'COMPLETED': 'badge-info',
                'CANCELLED': 'badge-secondary',
                'REJECTED': 'badge-danger'
            };
            return classMap[status] || 'badge-secondary';
        }

        // 필터링
        function filterVolunteers() {
            const searchTerm = document.getElementById('volunteerSearch').value.toLowerCase().trim();
            const statusFilter = document.getElementById('volunteerStatusFilter').value;

            let filteredVolunteers = allVolunteersData.filter(vol => {
                const matchesSearch = !searchTerm ||
                    (vol.applicantName && vol.applicantName.toLowerCase().includes(searchTerm)) ||
                    (vol.applicantEmail && vol.applicantEmail.toLowerCase().includes(searchTerm)) ||
                    (vol.applicantPhone && vol.applicantPhone.includes(searchTerm));

                const matchesStatus = !statusFilter || vol.status === statusFilter;

                return matchesSearch && matchesStatus;
            });

            renderVolunteerTable(filteredVolunteers);
        }

        // 시설 매칭 모달 열기
        function openFacilityMatchModal(applicationId) {
            const volunteer = allVolunteersData.find(v => v.applicationId === applicationId);
            if (!volunteer) {
                alert('봉사 신청 정보를 찾을 수 없습니다.');
                return;
            }

            // 신청자 상세 정보 표시
            document.getElementById('matchApplicationId').value = applicationId;
            document.getElementById('matchApplicantName').textContent = volunteer.applicantName || '-';
            document.getElementById('matchApplicantPhone').textContent = volunteer.applicantPhone || '-';
            document.getElementById('matchApplicantEmail').textContent = volunteer.applicantEmail || '-';
            document.getElementById('matchApplicantAddress').textContent = volunteer.applicantAddress || '-';
            document.getElementById('matchCategory').textContent = volunteer.selectedCategory || '-';
            document.getElementById('matchSchedule').textContent = (volunteer.volunteerDate || '') + ' ' + (volunteer.volunteerTime || '');
            document.getElementById('matchCreatedAt').textContent = volunteer.createdAt || '-';

            // 신청자 주소 힌트 표시
            const applicantAddress = volunteer.applicantAddress || '주소 정보 없음';
            document.getElementById('applicantAddressHint').textContent = applicantAddress;

            // 입력 필드 초기화
            document.getElementById('selectedFacilityName').value = '';
            document.getElementById('selectedFacilityAddress').value = '';
            document.getElementById('selectedFacilityLat').value = '';
            document.getElementById('selectedFacilityLng').value = '';
            document.getElementById('adminNote').value = '';

            const modal = document.getElementById('facilityMatchModal');
            modal.classList.add('active');
            modal.style.display = 'flex';
        }

        // 시설 매칭 모달 닫기
        function closeFacilityMatchModal() {
            const modal = document.getElementById('facilityMatchModal');
            modal.classList.remove('active');
            modal.style.display = 'none';
        }

        // Daum 주소 검색 팝업 열기
        function openAddressSearch() {
            // Daum Postcode API 로딩 확인
            if (typeof daum === 'undefined' || typeof daum.Postcode === 'undefined') {
                alert('주소 검색 서비스를 불러오는 중입니다. 잠시 후 다시 시도해주세요.');
                console.error('Daum Postcode API가 로드되지 않았습니다.');
                return;
            }

            new daum.Postcode({
                oncomplete: function(data) {
                    // 선택한 주소를 입력 필드에 설정
                    const fullAddress = data.roadAddress || data.jibunAddress;
                    document.getElementById('selectedFacilityAddress').value = fullAddress;

                    // 상세 주소가 있으면 추가
                    let extraAddress = '';
                    if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                        extraAddress += data.bname;
                    }
                    if (data.buildingName !== '' && data.apartment === 'Y') {
                        extraAddress += (extraAddress !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    if (extraAddress !== '') {
                        document.getElementById('selectedFacilityAddress').value = fullAddress + ' (' + extraAddress + ')';
                    }

                    // 위도/경도는 선택사항이므로 비워둠 (필요시 Kakao Local API로 변환 가능)
                    document.getElementById('selectedFacilityLat').value = '';
                    document.getElementById('selectedFacilityLng').value = '';

                    console.log('주소 선택 완료:', fullAddress);
                },
                onclose: function(state) {
                    if (state === 'FORCE_CLOSE') {
                        console.log('주소 검색 팝업이 강제로 닫혔습니다.');
                    } else if (state === 'COMPLETE_CLOSE') {
                        console.log('주소 검색 완료 후 닫힘');
                    }
                },
                width: '100%',
                height: '100%',
                autoClose: true
            }).open();
        }

        // 봉사 활동 승인
        function approveVolunteer() {
            const applicationId = document.getElementById('matchApplicationId').value;
            const facilityName = document.getElementById('selectedFacilityName').value.trim();
            const facilityAddress = document.getElementById('selectedFacilityAddress').value.trim();
            const facilityLat = document.getElementById('selectedFacilityLat').value;
            const facilityLng = document.getElementById('selectedFacilityLng').value;
            const adminNote = document.getElementById('adminNote').value;

            // 필수 입력 검증
            if (!facilityName) {
                alert('시설명을 입력해주세요.');
                document.getElementById('selectedFacilityName').focus();
                return;
            }

            if (!facilityAddress) {
                alert('시설 주소를 입력해주세요.');
                document.getElementById('selectedFacilityAddress').focus();
                return;
            }

            if (!confirm('이 봉사 신청을 승인하고 시설을 배정하시겠습니까?')) {
                return;
            }

            const params = new URLSearchParams();
            params.append('applicationId', applicationId);
            params.append('facilityName', facilityName);
            params.append('facilityAddress', facilityAddress);
            params.append('facilityLat', facilityLat || '');
            params.append('facilityLng', facilityLng || '');
            params.append('adminNote', adminNote || '');

            fetch('/bdproject/api/admin/volunteer/approve', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(response => {
                if (!response.ok) {
                    console.error('HTTP 오류:', response.status, response.statusText);
                }
                return response.json();
            })
            .then(result => {
                if (result.success) {
                    alert('봉사 활동이 승인되고 시설이 배정되었습니다.');
                    closeFacilityMatchModal();
                    loadVolunteers();
                } else {
                    alert('승인 실패: ' + (result.message || '알 수 없는 오류'));
                    console.error('승인 실패 상세:', result);
                }
            })
            .catch(error => {
                console.error('승인 오류:', error);
                alert('승인 중 오류가 발생했습니다. 콘솔을 확인해주세요.');
            });
        }

        // 봉사 활동 거절
        function rejectVolunteer(applicationId) {
            const reason = prompt('거절 사유를 입력하세요:');
            if (!reason) return;

            if (!confirm('이 봉사 신청을 거절하시겠습니까?')) {
                return;
            }

            const params = new URLSearchParams();
            params.append('applicationId', applicationId);
            params.append('reason', reason);

            fetch('/bdproject/api/admin/volunteer/reject', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    alert('봉사 신청이 거절되었습니다.');
                    loadVolunteers();
                } else {
                    alert('거절 실패: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('거절 오류:', error);
                alert('거절 중 오류가 발생했습니다.');
            });
        }

        // 봉사 활동 상세보기
        function viewVolunteerDetail(applicationId) {
            const volunteer = allVolunteersData.find(v => v.applicationId === applicationId);
            if (!volunteer) {
                alert('봉사 신청 정보를 찾을 수 없습니다.');
                return;
            }

            let message = '=== 봉사 신청 상세 정보 ===\n\n';
            message += '신청자: ' + volunteer.applicantName + '\n';
            message += '연락처: ' + volunteer.applicantPhone + '\n';
            message += '이메일: ' + (volunteer.applicantEmail || '-') + '\n';
            message += '분야: ' + volunteer.selectedCategory + '\n';
            message += '일정: ' + volunteer.volunteerDate + ' ' + (volunteer.volunteerTime || '') + '\n';
            message += '상태: ' + getVolunteerStatusText(volunteer.status) + '\n';

            if (volunteer.assignedFacilityName) {
                message += '\n=== 배정된 시설 ===\n';
                message += '시설명: ' + volunteer.assignedFacilityName + '\n';
                message += '주소: ' + (volunteer.assignedFacilityAddress || '-') + '\n';
            }

            if (volunteer.adminNote) {
                message += '\n관리자 메모: ' + volunteer.adminNote + '\n';
            }

            alert(message);
        }

        // 로그아웃 함수
        function logout() {
            if (confirm('로그아웃 하시겠습니까?')) {
                window.location.href = '/bdproject/login/logout';
            }
        }
    </script>
</body>
</html>
