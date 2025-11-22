<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page import="model.User"%>
<%@ page import="dto.ReviewListDisplayDTO"%> <%-- DTO 클래스 임포트 --%>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>리뷰 목록</title>
<%@ include file="css/main_css.jsp"%>
<link rel="stylesheet" href="<%=contextPath%>/css/reviewList.css" />
<style>
/* 이 페이지만 적용: 컨테이너 높이로 푸터를 화면 하단에 고정 */
.container {
    min-height: calc(100vh - 250px);
}
</style>
</head>
<body>
    <%@ include file="header.jsp"%>
    <nav>
        <a href="<%=contextPath%>/aiRecommend.jsp">(AI) 책 추천</a> <a
            href="<%=contextPath%>/reviewList">리뷰</a> <a
            href="<%=contextPath%>/playlistmain.jsp">플레이리스트</a> <a
            href="<%=contextPath%>/celebList">셀럽추천</a> <a
            href="<%=contextPath%>/mypage.jsp">마이페이지</a>
    </nav>

    <div class="container">
        <div class="top-bar">
            <%-- 스크립트릿 방식으로 로그인 여부 확인 --%>
            <% if (loggedInUser != null) { %>
                <a href="<%=contextPath%>/bookSearchForReview.jsp" class="action-btn">리뷰 작성</a>
            <% } else { %>
                <a href="<%=contextPath%>/login.jsp" class="action-btn">로그인 후
                    작성</a>
            <% } %>
        </div>

        <form id="reviewListForm" action="<%=contextPath%>/deleteReview"
            method="post" onsubmit="return true;">
            <div class="grid">
                <%-- JSTL c:forEach는 그대로 사용하되, DTO 필드를 사용합니다. --%>
                <c:forEach var="reviewDisplay" items="${reviews}"> <%-- 변수 이름 변경 (reviews는 List<ReviewListDisplayDTO>) --%>
                    <div class="card"
                        onclick="if(!window.deleteMode) location.href='<%=contextPath%>/reviewDetail?id=${reviewDisplay.reviewId}';">
                        <c:if
                            test="${not empty loggedInUser and loggedInUser.userId == reviewDisplay.userId}"> <%-- user_id 타입에 따라 수정 (int vs String) --%>
                            <input type="checkbox" name="ids" value="${reviewDisplay.reviewId}"
                                class="select-checkbox" style="display: none;" />
                        </c:if>
                        <i class="fas fa-bookmark bookmark-icon"></i>
                        <img class="bg-img"
                            src="${reviewDisplay.bookCoverImageUrl}" alt="${fn:escapeXml(reviewDisplay.bookTitle)}" />
                        <img class="cover-img"
                            src="${reviewDisplay.bookCoverImageUrl}" alt="${fn:escapeXml(reviewDisplay.bookTitle)}" />
                        <div class="card-content">
                            <div class="book-title">${fn:escapeXml(reviewDisplay.bookTitle)}</div>
                            <div class="book-author">${fn:escapeXml(reviewDisplay.bookAuthor)}</div>
                            <p class="review-preview">${fn:substring(fn:escapeXml(reviewDisplay.reviewText), 0, 80)}...</p>
                            <div class="rating">
                                <c:forEach begin="1" end="${reviewDisplay.rating}">★</c:forEach>
                                <c:forEach begin="1" end="${5 - reviewDisplay.rating}">☆</c:forEach>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </form>
    </div>

    <%@ include file="main_footer.jsp"%>

    	<button id="scrollToTopBtn">
		<img src="img/up1.png" alt="위로 가기 버튼" />
	</button>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const contextPath = "<%=contextPath%>";

            const topBtn = document.getElementById('topBtn');
            window.addEventListener('scroll', () => {
                topBtn.style.display = window.scrollY > 200 ? 'block' : 'none';
            });
            topBtn.addEventListener('click', () => {
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            });

            window.deleteMode = false;

            const bulkDeleteBtn = document.getElementById('bulkDeleteBtn');
            const checkboxes = Array.from(document.querySelectorAll('.select-checkbox'));
            const form = document.getElementById('reviewListForm');

            if(bulkDeleteBtn) { // 버튼이 로그인 상태에서만 존재하므로, null 체크
                bulkDeleteBtn.addEventListener('click', () => {
                    if (!window.deleteMode) {
                        window.deleteMode = true;
                        bulkDeleteBtn.textContent = '삭제 완료';
                        checkboxes.forEach((cb) => {
                            cb.style.display = 'inline-block';
                        });
                        bulkDeleteBtn.disabled = true;

                    } else {
                        const selected = checkboxes.filter((cb) => cb.checked);
                        if (selected.length > 0) {
                            if (confirm('정말로 선택한 리뷰를 삭제하시겠습니까?')) {
                                form.submit();
                            }
                        } else {
                            alert('삭제할 리뷰를 선택해주세요.');
                        }
                    }
                });

                checkboxes.forEach((cb) => {
                    cb.addEventListener('change', () => {
                        bulkDeleteBtn.disabled = !checkboxes.some((cbx) => cbx.checked);
                    });
                });
            }
        });
    </script>
</body>
</html>