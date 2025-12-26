<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="resources/css/project_result.css">
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="main-container">
        <div id="loading" class="loading">
            <c:choose>
                <c:when test="${not empty error}">
                    <div class="empty-state">
                        <div class="empty-icon">❌</div>
                        <h3>오류가 발생했습니다</h3>
                        <p><c:out value="${error}"/></p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="loading-spinner"></div>
                    <h3>결과를 불러오는 중...</h3>
                </c:otherwise>
            </c:choose>
        </div>

        <div id="results" style="display: none;">
            <div class="summary-card">
                <div class="summary-title">맞춤 복지 혜택 분석 결과</div>
                <p>회원님의 상황에 맞는 복지 혜택을 찾았습니다</p>
                <div class="summary-stats">
                    <div class="stat-item">
                        <div class="stat-number" id="total-count">0</div>
                        <div class="stat-label">전체 혜택</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" id="high-match-count">0</div>
                        <div class="stat-label">높은 적합도</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" id="online-available">0</div>
                        <div class="stat-label">온라인 신청 가능</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" id="central-count">0</div>
                        <div class="stat-label">중앙부처</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" id="local-count">0</div>
                        <div class="stat-label">지자체</div>
                    </div>
                </div>
            </div>

            <div class="filter-section">
                <div class="filter-title">필터</div>
                <div class="filter-buttons">
                    <button class="filter-btn active" data-filter="all">전체</button>
                    <button class="filter-btn" data-filter="high">높은 적합도</button>
                    <button class="filter-btn" data-filter="medium">중간 적합도</button>
                    <button class="filter-btn" data-filter="central">중앙부처</button>
                    <button class="filter-btn" data-filter="local">지자체</button>
                    <button class="filter-btn" data-filter="online">온라인신청</button>
                </div>
            </div>

            <div class="results-grid" id="welfare-grid">
                <!-- 복지 혜택 카드들이 여기에 동적으로 추가됩니다 -->
            </div>
        </div>
    </div>

<script>
// 서버에서 전달받은 사용자 데이터
var userData = {
<c:choose>
    <c:when test="${not empty userData}">
        birthdate: '<c:out value="${userData.birthdate}" escapeXml="true"/>',
        gender: '<c:out value="${userData.gender}" escapeXml="true"/>',
        household_size: parseInt('<c:out value="${userData.household_size}" default="1"/>'),
        income: '<c:out value="${userData.income}" escapeXml="true"/>',
        marital_status: '<c:out value="${userData.marital_status}" escapeXml="true"/>',
        children_count: parseInt('<c:out value="${userData.children_count}" default="0"/>'),
        employment_status: '<c:out value="${userData.employment_status}" escapeXml="true"/>',
        sido: '<c:out value="${userData.sido}" escapeXml="true"/>',
        sigungu: '<c:out value="${userData.sigungu}" escapeXml="true"/>',
        isPregnant: <c:out value="${userData.isPregnant}" default="false"/>,
        isDisabled: <c:out value="${userData.isDisabled}" default="false"/>,
        isMulticultural: <c:out value="${userData.isMulticultural}" default="false"/>,
        isVeteran: <c:out value="${userData.isVeteran}" default="false"/>,
        isSingleParent: <c:out value="${userData.isSingleParent}" default="false"/>
    </c:when>
    <c:otherwise>
        birthdate: '1995-03-15', gender: 'female', household_size: 2,
        income: '200_300', marital_status: 'married', children_count: 1,
        employment_status: 'employed', sido: '서울특별시', sigungu: '강남구',
        isPregnant: false, isDisabled: false, isMulticultural: false,
        isVeteran: false, isSingleParent: false
    </c:otherwise>
</c:choose>
};
</script>
<script src="resources/js/project_result.js"></script>
</body>
</html>