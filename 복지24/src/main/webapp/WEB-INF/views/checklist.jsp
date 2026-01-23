<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>서류 체크리스트 - 복지24</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/resources/image/복지로고.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/project_checklist.css">
    <script>
        var contextPath = '${pageContext.request.contextPath}';
    </script>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <a href="${pageContext.request.contextPath}/" class="logo">
                <div class="logo-icon">복</div>
                복지24
            </a>
            <nav class="nav-menu">
                <a href="${pageContext.request.contextPath}/project_result">복지 검색</a>
                <a href="${pageContext.request.contextPath}/mypage" class="login-required">마이페이지</a>
            </nav>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-clipboard-check"></i>
                서류 체크리스트
            </h1>
            <p class="page-subtitle">복지 서비스 신청에 필요한 서류를 체크하고 준비 상황을 관리하세요</p>
        </div>

        <!-- Service Info (동적으로 채워짐) -->
        <div id="serviceInfo" class="service-info-card" style="display: none;">
            <div class="service-header">
                <h2 id="serviceName" class="service-name"></h2>
                <span id="serviceOrg" class="service-org"></span>
            </div>
            <div class="progress-section">
                <div class="progress-header">
                    <span class="progress-label">준비 진행률</span>
                    <span id="progressText" class="progress-text">0 / 0</span>
                </div>
                <div class="progress-bar">
                    <div id="progressFill" class="progress-fill" style="width: 0%"></div>
                </div>
                <div id="progressPercent" class="progress-percent">0%</div>
            </div>
        </div>

        <!-- Checklist Container -->
        <div id="checklistContainer" class="checklist-container">
            <!-- 로딩 상태 -->
            <div id="loadingState" class="loading-state">
                <i class="fas fa-spinner fa-spin"></i>
                <p>체크리스트를 불러오는 중...</p>
            </div>

            <!-- 빈 상태 (서비스 선택 전) -->
            <div id="emptyState" class="empty-state" style="display: none;">
                <i class="fas fa-file-alt"></i>
                <h3>서비스를 선택해주세요</h3>
                <p>복지 서비스 상세 페이지에서 "서류 체크리스트" 버튼을 클릭하거나,<br>
                   아래에서 진행 중인 체크리스트를 확인하세요.</p>
            </div>

            <!-- 서류 없음 상태 -->
            <div id="noDocumentsState" class="empty-state" style="display: none;">
                <i class="fas fa-info-circle"></i>
                <h3>등록된 서류 정보가 없습니다</h3>
                <p>이 서비스의 필요 서류 정보가 아직 등록되지 않았습니다.</p>
            </div>

            <!-- 체크리스트 아이템들 -->
            <div id="checklistItems" class="checklist-items" style="display: none;">
                <!-- JavaScript로 동적 생성 -->
            </div>
        </div>

        <!-- 내 진행 중인 체크리스트 -->
        <div class="my-checklists-section">
            <h2 class="section-title">
                <i class="fas fa-list-check"></i>
                내 진행 중인 체크리스트
            </h2>
            <div id="myChecklistsContainer" class="my-checklists-container">
                <div class="loading-state">
                    <i class="fas fa-spinner fa-spin"></i>
                    <p>불러오는 중...</p>
                </div>
            </div>
        </div>

        <!-- 공통 서류 안내 -->
        <div class="common-docs-section">
            <h2 class="section-title">
                <i class="fas fa-folder-open"></i>
                자주 필요한 서류 안내
            </h2>
            <div id="commonDocsContainer" class="common-docs-grid">
                <!-- JavaScript로 동적 생성 -->
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <p>&copy; 2024 복지24. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/resources/js/checklist.js"></script>
</body>
</html>
