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
    <link rel="stylesheet" href="resources/css/project_admin.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                <div class="menu-item" onclick="showSection('user-questions')">
                    <i class="fas fa-comments"></i>
                    <span>사용자 질문 관리</span>
                </div>
                <div class="menu-item" onclick="showSection('donations')">
                    <i class="fas fa-hand-holding-heart"></i>
                    <span>기부 내역</span>
                </div>
                <div class="menu-item" onclick="showSection('refund-requests')">
                    <i class="fas fa-undo-alt"></i>
                    <span>환불 요청 관리</span>
                    <span id="refundBadge" class="badge" style="display: none; margin-left: auto; background: #e74c3c; color: white; padding: 2px 6px; border-radius: 10px; font-size: 11px;"></span>
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
                        <div class="stat-card-label">이번 달 진행된 봉사활동 수</div>
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

                    <!-- 월별 후기 작성 현황 (라인 차트) -->
                    <div class="chart-box">
                        <div class="chart-box-title">월별 후기 작성 현황</div>
                        <canvas id="monthlyReviewChart"></canvas>
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

            <!-- 사용자 질문 관리 섹션 -->
            <section id="user-questions" class="content-section">
                <div class="content-header">
                    <h1 class="content-title">사용자 질문 관리</h1>
                    <p class="content-subtitle">사용자들이 문의한 질문에 답변합니다</p>
                </div>

                <div class="data-table-container">
                    <div class="table-header" style="flex-wrap: wrap; gap: 15px;">
                        <div class="table-title">질문 목록</div>
                        <div style="display: flex; gap: 10px; align-items: center;">
                            <input type="text" class="search-input" id="questionNameSearch" placeholder="작성자 이름 검색" style="width: 150px; padding: 8px 12px;">
                            <select class="form-select" id="questionStatusFilter" style="width: 150px; padding: 8px 12px;">
                                <option value="">모든 상태</option>
                                <option value="pending">답변 대기</option>
                                <option value="answered">답변 완료</option>
                            </select>
                            <button class="search-btn" onclick="filterUserQuestions()">
                                <i class="fas fa-search"></i> 검색
                            </button>
                        </div>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="width: 60px;">번호</th>
                                <th style="width: 100px;">카테고리</th>
                                <th>질문 제목</th>
                                <th style="width: 100px;">작성자</th>
                                <th style="width: 120px;">작성일</th>
                                <th style="width: 100px;">상태</th>
                                <th style="width: 150px;">관리</th>
                            </tr>
                        </thead>
                        <tbody id="userQuestionsTableBody">
                            <tr>
                                <td colspan="7" class="loading">
                                    <i class="fas fa-spinner fa-spin"></i> 데이터 로딩 중...
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="pagination" id="userQuestionsPagination"></div>
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

            <!-- 환불 요청 관리 섹션 -->
            <section id="refund-requests" class="content-section" style="display: none;">
                <div class="content-header">
                    <h1 class="content-title">환불 요청 관리</h1>
                    <p class="content-subtitle">사용자가 요청한 환불 건을 승인 또는 거부합니다</p>
                </div>

                <div class="data-table-container">
                    <div class="table-header">
                        <div class="table-title">환불 요청 목록 (<span id="refundCount">0</span>건)</div>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>후원자</th>
                                <th>원금</th>
                                <th>수수료</th>
                                <th>환불예정금액</th>
                                <th>분야</th>
                                <th>기부일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody id="refundRequestsTableBody">
                            <tr>
                                <td colspan="8" class="loading">
                                    <i class="fas fa-spinner fa-spin"></i> 데이터 로딩 중...
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="pagination" id="refundsPagination"></div>
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
                <h2 class="modal-title" id="faqModalTitle">FAQ 작성</h2>
                <button class="modal-close" onclick="closeFaqModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="faqForm">
                    <input type="hidden" name="faqId" id="faqId">
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
                <button class="btn-submit" id="faqSubmitBtn" onclick="submitFaq()">등록</button>
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

    <!-- 사용자 질문 답변 모달 -->
    <div id="answerQuestionModal" class="modal">
        <div class="modal-content" style="max-width: 700px;">
            <div class="modal-header">
                <h2 class="modal-title">질문 답변하기</h2>
                <button class="modal-close" onclick="closeAnswerModal()">&times;</button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="answerQuestionId">

                <!-- 질문 정보 -->
                <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <h3 style="margin: 0 0 15px 0; font-size: 16px; color: #333; border-bottom: 2px solid #667eea; padding-bottom: 10px;">
                        <i class="fas fa-question-circle"></i> 질문 내용
                    </h3>
                    <div style="margin-bottom: 10px;">
                        <strong>카테고리:</strong> <span id="answerQuestionCategory">-</span>
                    </div>
                    <div style="margin-bottom: 10px;">
                        <strong>작성자:</strong> <span id="answerQuestionAuthor">-</span>
                        (<span id="answerQuestionEmail">-</span>)
                    </div>
                    <div style="margin-bottom: 10px;">
                        <strong>제목:</strong> <span id="answerQuestionTitle" style="font-weight: 600;">-</span>
                    </div>
                    <div style="margin-bottom: 10px;">
                        <strong>내용:</strong>
                        <p id="answerQuestionContent" style="white-space: pre-wrap; background: #fff; padding: 15px; border-radius: 6px; margin-top: 5px; border: 1px solid #ddd;">-</p>
                    </div>
                    <div>
                        <strong>작성일:</strong> <span id="answerQuestionDate">-</span>
                    </div>
                </div>

                <!-- 기존 답변 (있는 경우) -->
                <div id="existingAnswerSection" style="display: none; background: #e8f5e9; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <h3 style="margin: 0 0 15px 0; font-size: 16px; color: #2e7d32; border-bottom: 2px solid #4caf50; padding-bottom: 10px;">
                        <i class="fas fa-check-circle"></i> 기존 답변
                    </h3>
                    <p id="existingAnswerContent" style="white-space: pre-wrap;">-</p>
                    <div style="margin-top: 10px; font-size: 13px; color: #666;">
                        답변자: <span id="existingAnsweredBy">-</span> |
                        답변일: <span id="existingAnsweredAt">-</span>
                    </div>
                </div>

                <!-- 답변 입력 -->
                <div id="answerInputSection" style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333; font-size: 14px;">
                        <i class="fas fa-reply"></i> 답변 내용 <span style="color: #e74c3c;">*</span>
                    </label>
                    <textarea id="answerContent" rows="6" placeholder="질문에 대한 답변을 입력해주세요..."
                        style="width: 100%; padding: 12px; border: 2px solid #ddd; border-radius: 6px; font-size: 14px; resize: vertical; font-family: inherit;"
                        onfocus="this.style.borderColor='#667eea'; this.style.boxShadow='0 0 0 3px rgba(102,126,234,0.1)'"
                        onblur="this.style.borderColor='#ddd'; this.style.boxShadow='none'"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn-submit" id="answerSubmitBtn" onclick="submitQuestionAnswer()">
                    <i class="fas fa-paper-plane"></i> 답변 등록
                </button>
                <button class="btn-cancel" onclick="closeAnswerModal()">취소</button>
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

                        <div style="color: #666; font-weight: 500;">봉사 경력:</div>
                        <div id="matchExperience" style="color: #28a745; font-weight: 600;">-</div>

                        <div style="color: #666; font-weight: 500;">신청일시:</div>
                        <div id="matchCreatedAt">-</div>
                    </div>

                    <!-- 지원동기 -->
                    <div style="margin-top: 15px; padding-top: 15px; border-top: 1px solid #ddd;">
                        <div style="color: #666; font-weight: 500; margin-bottom: 8px;"><i class="fas fa-comment-dots"></i> 지원 동기:</div>
                        <div id="matchMotivation" style="background: #fff; padding: 12px; border-radius: 6px; border: 1px solid #e9ecef; font-size: 14px; line-height: 1.6; color: #333; white-space: pre-wrap;">-</div>
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
    <!-- 관리자 페이지 JavaScript -->
    <script src="resources/js/project_admin.js"></script>
</body>
</html>
