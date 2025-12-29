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
    <title>공지사항 - 복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="resources/css/project_notice.css">
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="container">
        <div class="page-header">
            <h1 class="page-title">공지사항</h1>
            <p class="page-subtitle">복지24의 새로운 소식과 중요한 공지사항을 확인하세요</p>
        </div>


        <!-- 로딩 표시 -->
        <div class="loading" id="loadingIndicator">
            <i class="fas fa-spinner fa-spin" style="font-size: 32px;"></i>
            <p style="margin-top: 15px;">공지사항을 불러오는 중...</p>
        </div>

        <div class="notice-list" id="noticeList" style="display: none;">
            <!-- 공지사항이 동적으로 로드됩니다 -->
        </div>

        <!-- 페이징: 공지사항이 10개 초과 시에만 표시 -->
        <div class="pagination" id="paginationContainer" style="display: none;">
            <!-- 동적으로 생성됨 -->
        </div>
    </div>
    <%@ include file="footer.jsp" %>
    <script src="resources/js/project_notice.js"></script>
</body>
</html>
