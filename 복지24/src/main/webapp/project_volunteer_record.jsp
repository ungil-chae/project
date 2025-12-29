<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>봉사 후기 - 복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="resources/css/project_volunteer_record.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="main-container">
        <div class="page-header">
            <h1 class="page-title">봉사자들의 따뜻한 이야기</h1>
            <p class="page-subtitle">
                복지24와 함께한 봉사활동 후기와 감동의 순간들을 공유합니다.<br>
                함께 나누는 작은 실천이 세상을 변화시킵니다.
            </p>
        </div>

        <div class="cta-section">
            <h2 class="cta-title">당신의 이야기를 들려주세요</h2>
            <p class="cta-text">
                복지24와 함께한 따뜻한 봉사 활동 경험을 공유하면,<br>
                더 많은 사람들에게 봉사의 기쁨을 전할 수 있습니다.
            </p>
            <a href="/bdproject/project_volunteer.jsp" class="cta-button">
                <i class="fas fa-hands-helping" style="margin-right: 8px;"></i>
                봉사 신청하기
            </a>
        </div>

        <div class="stories-container" id="storiesContainer">
            <div class="loading-message">
                <i class="fas fa-spinner fa-spin"></i>
                <p>후기를 불러오는 중입니다...</p>
            </div>
        </div>

        <div class="pagination-container" id="paginationContainer" style="display: none;"></div>
    </div>

    <jsp:include page="footer.jsp" />

    <script src="resources/js/project_volunteer_record.js"></script>
</body>
</html>
