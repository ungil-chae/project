<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%-- JSTL 사용을 위한 태그 라이브러리 선언 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>에세이 - 책 추천</title>

<%@ include file="css/main_css.jsp"%>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="icon" href="img/icon2.png" type="image/x-icon">
<link rel="stylesheet" href="<%=contextPath%>/css/playlist.css">
<style>
/* a 태그 밑줄 완전 제거 */
a, a:link, a:visited, a:hover, a:active, a:focus {
    text-decoration: none !important;
}
.card, .card * {
    text-decoration: none !important;
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

		<div class="page-header">
			<a href="playlistmain.jsp" class="back-button" title="뒤로가기"><i
				class="fas fa-arrow-left"></i></a>
			<div class="page-title">에세이</div>
		</div>

		<div class="main-content">

			<div class="video-section">
				<h2 class="video-title">플레이 리스트</h2>
				<div class="video-container">
					<iframe
						src="https://www.youtube.com/embed/COKMTPmvaMA?si=-f_oHY6jr0A74xbD"
						title="YouTube video player" frameborder="0"
						allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
						referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
				</div>
			</div>

			<div class="books-section">
				<h2 class="books-title">📖 이번 달 추천 도서</h2>

				<div class="featured-book">

					<%-- 추천 도서 링크 수정 --%>
					<c:url var="featuredBookUrl" value="/bookClick">
						<c:param name="id" value="24" />
						<c:param name="title" value="단 한 번의 삶" />
						<c:param name="author" value="김영하" />
						<c:param name="image"
							value="${pageContext.request.contextPath}/img/esa1.jpg" />
						<c:param name="link"
							value="https://search.shopping.naver.com/book/catalog/53735013051" />
					</c:url>

					<a href="${featuredBookUrl}" class="featured-book-image"
						data-book-id="24"> <img src="img/esa1.jpg" alt="단 한 번의 삶">
					</a>

					<div class="featured-book-info">
						<div class="featured-book-title">단 한 번의 삶</div>
						<div class="featured-book-author">저자: 김영하</div>

						<div class="featured-book-rating">
							<span class="stars">★ 9.7</span><span>(240)</span>
						</div>

						<div class="featured-book-description">
							김영하 작가가 전하는 삶과 가족, 존재에 관한 진솔한 사유.<br> 자신만의 ‘한 번뿐인 삶’을 어떻게
							살아갈지 묻는다.
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="cards-section">
			<h2 class="cards-title">📚 WITHUS의 추천 에세이</h2>
			<div class="grid">

				<%-- 카드 1 --%>
				<c:url var="clickUrl_1" value="/bookClick">
					<c:param name="id" value="25" />
					<c:param name="title" value="무소유" />
					<c:param name="author" value="법정" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/42325184618" />
				</c:url>
				<a class="card" href="${clickUrl_1}" data-book-id="25"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp.jpg" alt=""> <img class="cover-img"
					src="img/dp.jpg" alt="">
					<div class="card-content">
						<div class="book-title">무소유</div>
						<div class="book-author">법정</div>
						<div class="review-preview">간결한 삶의 미학, 한국 에세이의 고전</div>
					</div>
				</a>

				<%-- 카드 2 --%>
				<c:url var="clickUrl_2" value="/bookClick">
					<c:param name="id" value="26" />
					<c:param name="title" value="인연" />
					<c:param name="author" value="피천득" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp1.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32482042408" />
				</c:url>
				<a class="card" href="${clickUrl_2}" data-book-id="26"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp1.jpg" alt=""> <img class="cover-img"
					src="img/dp1.jpg" alt="">
					<div class="card-content">
						<div class="book-title">인연</div>
						<div class="book-author">피천득</div>
						<div class="review-preview">삶의 소중한 인연을 회고하는 서정적 산문</div>
					</div>
				</a>

				<%-- 카드 3 --%>
				<c:url var="clickUrl_3" value="/bookClick">
					<c:param name="id" value="27" />
					<c:param name="title" value="개인주의자 선언" />
					<c:param name="author" value="문유석" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp2.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32441659387" />
				</c:url>
				<a class="card" href="${clickUrl_3}" data-book-id="27"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp2.jpg" alt=""> <img class="cover-img"
					src="img/dp2.jpg" alt="">
					<div class="card-content">
						<div class="book-title">개인주의자 선언</div>
						<div class="book-author">문유석</div>
						<div class="review-preview">사회와 개인 사이 균형을 찾는 이야기</div>
					</div>
				</a>

				<%-- 카드 4 --%>
				<c:url var="clickUrl_4" value="/bookClick">
					<c:param name="id" value="28" />
					<c:param name="title" value="나는 나로 살기로 했다" />
					<c:param name="author" value="김수현" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp3.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32465494978" />
				</c:url>
				<a class="card" href="${clickUrl_4}" data-book-id="28"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp3.jpg" alt=""> <img class="cover-img"
					src="img/dp3.jpg" alt="">
					<div class="card-content">
						<div class="book-title">나는 나로 살기로 했다</div>
						<div class="book-author">김수현</div>
						<div class="review-preview">자존감 회복을 위한 에세이</div>
					</div>
				</a>

				<%-- 카드 5 --%>
				<c:url var="clickUrl_5" value="/bookClick">
					<c:param name="id" value="29" />
					<c:param name="title" value="죽음의 수용소에서" />
					<c:param name="author" value="빅터 프랭클" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp4.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32485602637" />
				</c:url>
				<a class="card" href="${clickUrl_5}" data-book-id="29"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp4.jpg" alt=""> <img class="cover-img"
					src="img/dp4.jpg" alt="">
					<div class="card-content">
						<div class="book-title">죽음의 수용소에서</div>
						<div class="book-author">빅터 프랭클</div>
						<div class="review-preview">실존적 의미를 성찰하는 명저</div>
					</div>
				</a>

				<%-- 카드 6 (※ 원본 코드에 오타가 있어 수정했습니다: src/img -> src="img") --%>
				<c:url var="clickUrl_6" value="/bookClick">
					<c:param name="id" value="30" />
					<c:param name="title" value="어떻게 살 것인가" />
					<c:param name="author" value="유시민" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp5.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32465515855" />
				</c:url>
				<a class="card" href="${clickUrl_6}" data-book-id="30"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp5.jpg" alt=""> <img class="cover-img"
					src="img/dp5.jpg" alt="">
					<div class="card-content">
						<div class="book-title">어떻게 살 것인가</div>
						<div class="book-author">유시민</div>
						<div class="review-preview">삶의 방향을 제시하는 철학적 질문</div>
					</div>
				</a>

				<%-- 카드 7 --%>
				<c:url var="clickUrl_7" value="/bookClick">
					<c:param name="id" value="31" />
					<c:param name="title" value="혼자가 혼자에게" />
					<c:param name="author" value="이병률" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp6.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32490282198" />
				</c:url>
				<a class="card" href="${clickUrl_7}" data-book-id="31"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp6.jpg" alt=""> <img class="cover-img"
					src="img/dp6.jpg" alt="">
					<div class="card-content">
						<div class="book-title">혼자가 혼자에게</div>
						<div class="book-author">이병률</div>
						<div class="review-preview">여행과 고독 속에서 찾은 감성</div>
					</div>
				</a>

				<%-- 카드 8 --%>
				<c:url var="clickUrl_8" value="/bookClick">
					<c:param name="id" value="32" />
					<c:param name="title" value="여행의 이유" />
					<c:param name="author" value="김영하" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp7.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/46931760625" />
				</c:url>
				<a class="card" href="${clickUrl_8}" data-book-id="32"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp7.jpg" alt=""> <img class="cover-img"
					src="img/dp7.jpg" alt="">
					<div class="card-content">
						<div class="book-title">여행의 이유</div>
						<div class="book-author">김영하</div>
						<div class="review-preview">여행을 통한 삶의 의미 탐색</div>
					</div>
				</a>

				<%-- 카드 9 --%>
				<c:url var="clickUrl_9" value="/bookClick">
					<c:param name="id" value="33" />
					<c:param name="title" value="낭만적 연애와 그 후의 일상" />
					<c:param name="author" value="알랭 드 보통" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp8.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32436139331" />
				</c:url>
				<a class="card" href="${clickUrl_9}" data-book-id="33"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp8.jpg" alt=""> <img class="cover-img"
					src="img/dp8.jpg" alt="">
					<div class="card-content">
						<div class="book-title">낭만적 연애와 그 후의 일상</div>
						<div class="book-author">알랭 드 보통</div>
						<div class="review-preview">연애 이후의 삶을 성찰</div>
					</div>
				</a>

				<%-- 카드 10 --%>
				<c:url var="clickUrl_10" value="/bookClick">
					<c:param name="id" value="34" />
					<c:param name="title" value="아픔이 길이 되려면" />
					<c:param name="author" value="김승섭" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp9.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32475523886" />
				</c:url>
				<a class="card" href="${clickUrl_10}" data-book-id="34"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp9.jpg" alt=""> <img class="cover-img"
					src="img/dp9.jpg" alt="">
					<div class="card-content">
						<div class="book-title">아픔이 길이 되려면</div>
						<div class="book-author">김승섭</div>
						<div class="review-preview">아픔을 통해 사회를 바라보다</div>
					</div>
				</a>

				<%-- 카드 11 --%>
				<c:url var="clickUrl_11" value="/bookClick">
					<c:param name="id" value="35" />
					<c:param name="title" value="언어의 온도" />
					<c:param name="author" value="이기주" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp10.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32445599640" />
				</c:url>
				<a class="card" href="${clickUrl_11}" data-book-id="35"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp10.jpg" alt=""> <img class="cover-img"
					src="img/dp10.jpg" alt="">
					<div class="card-content">
						<div class="book-title">언어의 온도</div>
						<div class="book-author">이기주</div>
						<div class="review-preview">말과 글이 주는 온기를 탐구</div>
					</div>
				</a>

				<%-- 카드 12 --%>
				<c:url var="clickUrl_12" value="/bookClick">
					<c:param name="id" value="36" />
					<c:param name="title" value="내 옆에 있는 사람" />
					<c:param name="author" value="이병률" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp11.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32466975969" />
				</c:url>
				<a class="card" href="${clickUrl_12}" data-book-id="36"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp11.jpg" alt=""> <img class="cover-img"
					src="img/dp11.jpg" alt="">
					<div class="card-content">
						<div class="book-title">내 옆에 있는 사람</div>
						<div class="book-author">이병률</div>
						<div class="review-preview">일상 속 관계와 감성</div>
					</div>
				</a>

				<%-- 카드 13 --%>
				<c:url var="clickUrl_13" value="/bookClick">
					<c:param name="id" value="37" />
					<c:param name="title" value="게으를 권리" />
					<c:param name="author" value="폴 라파르그" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp12.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32466637728" />
				</c:url>
				<a class="card" href="${clickUrl_13}" data-book-id="37"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp12.jpg" alt=""> <img class="cover-img"
					src="img/dp12.jpg" alt="">
					<div class="card-content">
						<div class="book-title">게으를 권리</div>
						<div class="book-author">폴 라파르그</div>
						<div class="review-preview">“일중독” 사회에 던지는 통렬한 질문</div>
					</div>
				</a>

				<%-- 카드 14 --%>
				<c:url var="clickUrl_14" value="/bookClick">
					<c:param name="id" value="38" />
					<c:param name="title" value="월든" />
					<c:param name="author" value="헨리 D. 소로" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp13.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32445721746" />
				</c:url>
				<a class="card" href="${clickUrl_14}" data-book-id="38"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp13.jpg" alt=""> <img class="cover-img"
					src="img/dp13.jpg" alt="">
					<div class="card-content">
						<div class="book-title">월든</div>
						<div class="book-author">헨리 D. 소로</div>
						<div class="review-preview">자연 속 자급자족 실험기</div>
					</div>
				</a>

				<%-- 카드 15 --%>
				<c:url var="clickUrl_15" value="/bookClick">
					<c:param name="id" value="39" />
					<c:param name="title" value="우리는 언젠가 만난다" />
					<c:param name="author" value="채사장" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp14.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32466539178" />
				</c:url>
				<a class="card" href="${clickUrl_15}" data-book-id="39"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp14.jpg" alt=""> <img class="cover-img"
					src="img/dp14.jpg" alt="">
					<div class="card-content">
						<div class="book-title">우리는 언젠가 만난다</div>
						<div class="book-author">채사장</div>
						<div class="review-preview">관계와 삶을 철학적으로 조망</div>
					</div>
				</a>

				<%-- 카드 16 --%>
				<c:url var="clickUrl_16" value="/bookClick">
					<c:param name="id" value="40" />
					<c:param name="title" value="슬픔을 공부하는 슬픔" />
					<c:param name="author" value="신형철" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp15.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32454453350" />
				</c:url>
				<a class="card" href="${clickUrl_16}" data-book-id="40"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp15.jpg" alt=""> <img class="cover-img"
					src="img/dp15.jpg" alt="">
					<div class="card-content">
						<div class="book-title">슬픔을 공부하는 슬픔</div>
						<div class="book-author">신형철</div>
						<div class="review-preview">문학과 사회를 해석하는 섬세한 비평</div>
					</div>
				</a>

				<%-- 카드 17 --%>
				<c:url var="clickUrl_17" value="/bookClick">
					<c:param name="id" value="41" />
					<c:param name="title" value="하늘 호수로 떠난 여행" />
					<c:param name="author" value="류시화" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp16.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32487161391" />
				</c:url>
				<a class="card" href="${clickUrl_17}" data-book-id="41"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp16.jpg" alt=""> <img class="cover-img"
					src="img/dp16.jpg" alt="">
					<div class="card-content">
						<div class="book-title">하늘 호수로 떠난 여행</div>
						<div class="book-author">류시화</div>
						<div class="review-preview">영혼의 성장을 위한 인도 여행기</div>
					</div>
				</a>

				<%-- 카드 18 --%>
				<c:url var="clickUrl_18" value="/bookClick">
					<c:param name="id" value="42" />
					<c:param name="title" value="개인주의자 선언" />
					<c:param name="author" value="문유석" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp17.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32441659387" />
				</c:url>
				<a class="card" href="${clickUrl_18}" data-book-id="42"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp17.jpg" alt=""> <img class="cover-img"
					src="img/dp17.jpg" alt="">
					<div class="card-content">
						<div class="book-title">개인주의자 선언</div>
						<div class="book-author">문유석</div>
						<div class="review-preview">다시 한 번 개인·사회 균형 성찰</div>
					</div>
				</a>

				<%-- 카드 19 --%>
				<c:url var="clickUrl_19" value="/bookClick">
					<c:param name="id" value="43" />
					<c:param name="title" value="사랑의 기술" />
					<c:param name="author" value="에리히 프롬" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp18.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32457424202" />
				</c:url>
				<a class="card" href="${clickUrl_19}" data-book-id="43"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp18.jpg" alt=""> <img class="cover-img"
					src="img/dp18.jpg" alt="">
					<div class="card-content">
						<div class="book-title">사랑의 기술</div>
						<div class="book-author">에리히 프롬</div>
						<div class="review-preview">진정한 사랑의 의미를 탐색</div>
					</div>
				</a>

				<%-- 카드 20 --%>
				<c:url var="clickUrl_20" value="/bookClick">
					<c:param name="id" value="44" />
					<c:param name="title" value="태도에 관하여" />
					<c:param name="author" value="임경선" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/dp19.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/50466246618" />
				</c:url>
				<a class="card" href="${clickUrl_20}" data-book-id="44"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/dp19.jpg" alt=""> <img class="cover-img"
					src="img/dp19.jpg" alt="">
					<div class="card-content">
						<div class="book-title">태도에 관하여</div>
						<div class="book-author">임경선</div>
						<div class="review-preview">자신만의 삶의 태도를 모색</div>
					</div>
				</a>

			</div>
		</div>
	</div>
	<button id="topBtn" title="맨 위로 이동">
		<i class="fas fa-arrow-up"></i>
	</button>

	<footer>
		<div class="footer-container">
			<div class="footer-links">
				<a href="#">회사소개</a> <a href="#">이용약관</a> <a href="#">개인정보처리방침</a> <a
					href="#">고객센터</a>
			</div>
			<p>© 2024 WithUs. All rights reserved.</p>
		</div>
	</footer>
<script>
document.addEventListener('DOMContentLoaded', function () {
    // 1. JSP가 서버에서 실행되어 contextPath가 "/BookRec_Final"로 올바르게 설정됩니다.
    const contextPath = "<%=request.getContextPath()%>";
    const isLoggedIn = <%=session.getAttribute("loggedInUser") != null%>;

    async function initializeBookmarks() {
        if (!isLoggedIn) return;

        try {
            // [수정] fetch URL 앞에 contextPath 변수를 포함시킵니다.
            const url = `${'${contextPath}'}/api/users/me/wishlists`;
            
            const response = await fetch(url);
            if (!response.ok) {
                console.error(`찜 목록 로드 실패: ${'${response.status}'}, 요청 URL: ${'${response.url}'}`);
                return;
            }
            const myWishlistItems = await response.json();
            const myWishlistSet = new Set(myWishlistItems.map(item => item.bookId));

            document.querySelectorAll('.bookmark-icon').forEach(icon => {
                const card = icon.closest('[data-book-id]');
                if (card) {
                    const bookId = parseInt(card.dataset.bookId, 10);
                    if (myWishlistSet.has(bookId)) {
                        icon.classList.add('bookmarked');
                    }
                }
            });
        } catch (error) {
            console.error("찜 목록 초기화 중 네트워크 오류:", error);
        }
    }

    document.querySelectorAll('.bookmark-icon').forEach(icon => {
        icon.addEventListener('click', async function (event) {
            event.preventDefault();
            event.stopPropagation();

            if (!isLoggedIn) {
                alert('로그인이 필요한 기능입니다.');
                window.location.href = `${'${contextPath}'}/login.jsp`;
                return;
            }

            const card = this.closest('[data-book-id]');
            if (!card) {
                console.error('클릭한 아이콘의 상위에서 data-book-id를 찾을 수 없습니다.');
                return;
            }
            const bookId = card.dataset.bookId;
            if (!bookId) {
                alert('책 ID를 가져올 수 없습니다. 페이지를 새로고침 해주세요.');
                return;
            }

            try {
                // [수정] 찜 토글 요청 URL 앞에도 contextPath 변수를 포함시킵니다.
                const url = `${'${contextPath}'}/api/users/me/wishlists?bookId=${'${bookId}'}`;

                const response = await fetch(url, {
                    method: 'POST',
                });

                if (!response.ok) {
                    console.error(`찜 처리 실패: ${'${response.status}'}, 요청 URL: ${'${response.url}'}`);
                    throw new Error('서버 요청에 실패했습니다.');
                }
                
                const result = await response.json();
                if (result.status === 'added') {
                    this.classList.add('bookmarked');
                } else {
                    this.classList.remove('bookmarked');
                }
            } catch (error) {
                console.error('찜 처리 중 오류 발생:', error);
                alert('요청 처리 중 오류가 발생했습니다.');
            }
        });
    });

    initializeBookmarks();
});
</script>
</body>
</html>
