<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ page import="model.User"%>
<%@ page import="dto.ReviewDetailDisplayDTO"%>
<%-- 이제 이 DTO를 사용합니다 --%>
<%@ page import="model.ContentBlock"%>
<%-- ContentBlock 모델 임포트 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
String contextPath = request.getContextPath();
// ReviewDetailServlet에서 request.setAttribute("reviewDetail", reviewDetailDisplay);로 전달됨
ReviewDetailDisplayDTO reviewDetail = (ReviewDetailDisplayDTO) request.getAttribute("reviewDetail");

// 리뷰 객체가 없으면 (예: 잘못된 ID로 접근 시) 에러 처리 또는 리스트로 리다이렉트
if (reviewDetail == null) {
	response.sendRedirect(contextPath + "/reviewList?message=Review not found.");
	return;
}
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>리뷰 상세 - ${fn:escapeXml(reviewDetail.bookTitle)}</title>
<%@ include file="css/main_css.jsp"%>
<link rel="stylesheet" href="<%=contextPath%>/css/reviewDetail.css" />
<style>
/* 상세 페이지 스타일 */
.container {
	min-height: calc(100vh - 250px);
	padding: 40px;
	max-width: 900px;
	margin: 30px auto;
	background-color: #fff;
	border-radius: 10px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

h2 {
	text-align: center;
	color: #333;
	margin-bottom: 40px;
	font-size: 2.2em;
}

.review-header {
	display: flex;
	align-items: flex-start;
	margin-bottom: 30px;
	border-bottom: 1px solid #eee;
	padding-bottom: 20px;
}

.review-header img {
	width: 150px;
	height: 220px;
	object-fit: cover;
	border-radius: 8px;
	margin-right: 30px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.book-meta {
	flex-grow: 1;
}

.book-meta .title {
	font-size: 1.8em;
	font-weight: bold;
	color: #222;
	margin-bottom: 10px;
}

.book-meta .author, .book-meta .publisher {
	font-size: 1.1em;
	color: #555;
	margin-bottom: 5px;
}

.review-info {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 15px;
	font-size: 0.95em;
	color: #777;
}

.review-info .user-rating {
	font-size: 1.2em;
	color: #f8d601;
}

.review-content-blocks { /* 새롭게 추가될 블록 컨테이너 */
	margin-top: 20px;
}

.content-block {
	margin-bottom: 20px;
	line-height: 1.8;
	font-size: 1.1em;
	color: #444;
}

.content-block.text {
	white-space: pre-wrap; /* 텍스트 블록의 줄바꿈 유지 */
}

.content-block.image img {
	max-width: 100%;
	height: auto;
	display: block;
	margin: 0 auto;
	border-radius: 5px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.review-actions {
	text-align: right;
	margin-top: 40px;
}

.review-actions .action-btn {
	background-color: #6c757d;
	color: white;
	border: none;
	padding: 10px 20px;
	border-radius: 5px;
	cursor: pointer;
	margin-left: 10px;
	text-decoration: none;
	transition: background-color 0.3s ease;
}

.review-actions .action-btn.edit {
	background-color: #007bff;
}

.review-actions .action-btn.delete {
	background-color: #dc3545;
}

.review-actions .action-btn:hover {
	opacity: 0.9;
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
		<h2>리뷰 상세</h2>
		<div class="review-header">
			<img src="${fn:escapeXml(reviewDetail.bookCoverImageUrl)}"
				alt="${fn:escapeXml(reviewDetail.bookTitle)} 표지"
				onerror="this.onerror=null; this.src='<%=contextPath%>/img/icon2.png';" />
			<div class="book-meta">
				<div class="title">${fn:escapeXml(reviewDetail.bookTitle)}</div>
				<div class="author">${fn:escapeXml(reviewDetail.bookAuthor)}</div>
				<div class="review-info">
					<span>작성자: ${fn:escapeXml(reviewDetail.userId)}</span>
					<%-- 이 부분은 user_id(int)를 표시하므로, 나중에 사용자 닉네임/이름을 가져와 표시하도록 변경해야 합니다. --%>
					<div class="user-rating">
						<c:forEach begin="1" end="${reviewDetail.rating}">★</c:forEach>
						<c:forEach begin="1" end="${5 - reviewDetail.rating}">☆</c:forEach>
					</div>
				</div>
				<p class="created-at">작성일:
					${reviewDetail.createdAt.toLocalDate()}</p>
			</div>
		</div>

		<div class="review-content-blocks">
			<c:choose>
				<c:when test="${not empty reviewDetail.contentBlocks}">
					<c:forEach var="block" items="${reviewDetail.contentBlocks}">
						<div class="content-block ${block.blockType}">
							<c:choose>
								<c:when test="${block.blockType == 'text'}">
									<p>${fn:escapeXml(block.textContent)}</p>
								</c:when>
								<c:when test="${block.blockType == 'image'}">
									<img src="${fn:escapeXml(block.imageUrl)}" alt="리뷰 이미지" />
								</c:when>
								<%-- 다른 블록 타입이 있다면 여기에 추가 --%>
							</c:choose>
						</div>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div class="content-block text">
						<%-- ReviewDetailDisplayDTO의 reviewText를 ContentBlock이 없으면 사용 (reviewForm에서 reviewText만 저장할 때) --%>
						<p>${fn:escapeXml(reviewDetail.reviewText)}</p>
					</div>
				</c:otherwise>
			</c:choose>
		</div>

		<div class="review-actions">
			<c:if
				test="${not empty loggedInUser and loggedInUser.userId == reviewDetail.userId}">
				<a href="<%=contextPath%>/editReview?id=${reviewDetail.reviewId}"
					class="action-btn edit">수정</a>
				<a href="<%=contextPath%>/deleteReview?id=${reviewDetail.reviewId}"
					class="action-btn delete"
					onclick="return confirm('정말로 이 리뷰를 삭제하시겠습니까?');">삭제</a>
			</c:if>
			<a href="<%=contextPath%>/reviewList" class="action-btn">목록으로</a>
		</div>
	</div>

	<%@ include file="main_footer.jsp"%>
</body>
</html>