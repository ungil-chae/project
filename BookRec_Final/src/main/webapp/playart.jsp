<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%-- JSTL 사용을 위한 태그 라이브러리 선언 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문화/예술 - 책 추천</title>
<%@ include file="css/main_css.jsp"%>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="icon" href="img/icon2.png" type="image/x-icon">

<link rel="stylesheet" href="<%=contextPath%>/css/playlist.css">
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
			<div class="page-title">문화/예술</div>
		</div>

		<div class="main-content">

			<div class="video-section">
				<h2 class="video-title">플레이 리스트</h2>
				<div class="video-container">
					<iframe
						src="https://www.youtube.com/embed/lda2bk7RtC8?si=3fXzfH4cbS4OGGTI"
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
						<c:param name="id" value="3"/>
						<c:param name="title" value="나의 문화유산답사기 9: 서울편 1"/>
						<c:param name="author" value="유홍준"/>
						<c:param name="image" value="${pageContext.request.contextPath}/img/n1.jpg"/>
						<c:param name="link" value="https://search.shopping.naver.com/book/catalog/32445567453"/>
					</c:url>
					
					<a href="${featuredBookUrl}" class="featured-book-image" data-book-id="3">
						<img src="img/n1.jpg" alt="나의 문화유산답사기 9">
					</a>

					<div class="featured-book-info">
						<div class="featured-book-title">나의 문화유산답사기 9: 서울편 1</div>
						<div class="featured-book-author">저자: 유홍준</div>

						<div class="featured-book-rating">
							<span class="stars">★ 9.6</span><span>(213)</span>
						</div>

						<div class="featured-book-description">25년 만에 서울을 다룬 ‘답사기’
							신간. 거대 도시 서울의 문화유산과 역사를 섬세하게 풀어낸다.</div>
					</div>
				</div>
			</div>
		</div>
		<div class="cards-section">
			<h2 class="cards-title">🎨 WITHUS의 추천 문화/예술</h2>

			<div class="grid">
				<%-- 카드 1 --%>
				<c:url var="clickUrl_1" value="/bookClick">
					<c:param name="id" value="4"/>
					<c:param name="title" value="다른 방식으로 보기"/>
					<c:param name="author" value="존 버거"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/32490815625"/>
				</c:url>
				<a class="card" href="${clickUrl_1}" data-book-id="4">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d.jpg" alt=""> <img class="cover-img" src="img/d.jpg" alt="">
					<div class="card-content">
						<div class="book-title">다른 방식으로 보기</div>
						<div class="book-author">존 버거</div>
						<div class="review-preview">미술 감상을 새롭게 바라보게 하는 고전</div>
					</div>
				</a>

				<%-- 카드 2 --%>
				<c:url var="clickUrl_2" value="/bookClick">
					<c:param name="id" value="5"/>
					<c:param name="title" value="나의 문화유산답사기"/>
					<c:param name="author" value="유홍준"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d1.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/32445567453"/>
				</c:url>
				<a class="card" href="${clickUrl_2}" data-book-id="5">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d1.jpg" alt=""> <img class="cover-img" src="img/d1.jpg" alt="">
					<div class="card-content">
						<div class="book-title">나의 문화유산답사기</div>
						<div class="book-author">유홍준</div>
						<div class="review-preview">한국 문화유산을 향한 대중적 안내서</div>
					</div>
				</a>

				<%-- 카드 3 --%>
				<c:url var="clickUrl_3" value="/bookClick">
					<c:param name="id" value="6"/>
					<c:param name="title" value="사진에 관하여"/>
					<c:param name="author" value="수전 손택"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d2.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/32441018601"/>
				</c:url>
				<a class="card" href="${clickUrl_3}" data-book-id="6">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d2.jpg" alt=""> <img class="cover-img" src="img/d2.jpg" alt="">
					<div class="card-content">
						<div class="book-title">사진에 관하여</div>
						<div class="book-author">수전 손택</div>
						<div class="review-preview">사진의 본질과 사회적 의미를 탐구</div>
					</div>
				</a>

				<%-- 카드 4 --%>
				<c:url var="clickUrl_4" value="/bookClick">
					<c:param name="id" value="7"/>
					<c:param name="title" value="미학 오디세이"/>
					<c:param name="author" value="진중권"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d3.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/32466555822"/>
				</c:url>
				<a class="card" href="${clickUrl_4}" data-book-id="7">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d3.jpg" alt=""> <img class="cover-img" src="img/d3.jpg" alt="">
					<div class="card-content">
						<div class="book-title">미학 오디세이</div>
						<div class="book-author">진중권</div>
						<div class="review-preview">대중을 위한 철학적 미학 입문</div>
					</div>
				</a>

				<%-- 카드 5 --%>
				<c:url var="clickUrl_5" value="/bookClick">
					<c:param name="id" value="8"/>
					<c:param name="title" value="죽기 전에 꼭 봐야 할 세계 건축"/>
					<c:param name="author" value="피터 클락슨"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d4.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/32436153694"/>
				</c:url>
				<a class="card" href="${clickUrl_5}" data-book-id="8">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d4.jpg" alt=""> <img class="cover-img" src="img/d4.jpg" alt="">
					<div class="card-content">
						<div class="book-title">죽기 전에 꼭 봐야 할 세계 건축</div>
						<div class="book-author">피터 클락슨</div>
						<div class="review-preview">전 세계 주요 건축물 가이드</div>
					</div>
				</a>

				<%-- 카드 6 --%>
				<c:url var="clickUrl_6" value="/bookClick">
					<c:param name="id" value="9"/>
					<c:param name="title" value="한국의 미 특강"/>
					<c:param name="author" value="오주석"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d5.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/32436144306"/>
				</c:url>
				<a class="card" href="${clickUrl_6}" data-book-id="9">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d5.jpg" alt=""> <img class="cover-img" src="img/d5.jpg" alt="">
					<div class="card-content">
						<div class="book-title">한국의 미 특강</div>
						<div class="book-author">오주석</div>
						<div class="review-preview">한국 미술의 특징과 아름다움</div>
					</div>
				</a>

				<%-- 카드 7 --%>
				<c:url var="clickUrl_7" value="/bookClick">
					<c:param name="id" value="10"/>
					<c:param name="title" value="컬러 앤 라이트"/>
					<c:param name="author" value="제임스 거니"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/mm1.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/51676555623"/>
				</c:url>
				<a class="card" href="${clickUrl_7}" data-book-id="10">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/mm1.jpg" alt=""> <img class="cover-img" src="img/mm1.jpg" alt="">
					<div class="card-content">
						<div class="book-title">컬러 앤 라이트</div>
						<div class="book-author">제임스 거니</div>
						<div class="review-preview">빛과 색을 사실적으로 그리기</div>
					</div>
				</a>

				<%-- 카드 8 --%>
				<c:url var="clickUrl_8" value="/bookClick">
					<c:param name="id" value="11"/>
					<c:param name="title" value="음악의 역사"/>
					<c:param name="author" value="클로드 팔리스카"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d7.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/55485250979"/>
				</c:url>
				<a class="card" href="${clickUrl_8}" data-book-id="11">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d7.jpg" alt=""> <img class="cover-img" src="img/d7.jpg" alt="">
					<div class="card-content">
						<div class="book-title">음악의 역사</div>
						<div class="book-author">클로드 팔리스카</div>
						<div class="review-preview">서양 음악사의 흐름 정리</div>
					</div>
				</a>

				<%-- 카드 9 --%>
				<c:url var="clickUrl_9" value="/bookClick">
					<c:param name="id" value="12"/>
					<c:param name="title" value="영화의 이해"/>
					<c:param name="author" value="루이스 자네티"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d8.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/32442163261"/>
				</c:url>
				<a class="card" href="${clickUrl_9}" data-book-id="12">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d8.jpg" alt=""> <img class="cover-img" src="img/d8.jpg" alt="">
					<div class="card-content">
						<div class="book-title">영화의 이해</div>
						<div class="book-author">루이스 자네티</div>
						<div class="review-preview">영화 이론 입문서의 고전</div>
					</div>
				</a>

				<%-- 카드 10 --%>
				<c:url var="clickUrl_10" value="/bookClick">
					<c:param name="id" value="13"/>
					<c:param name="title" value="길 위의 인문학"/>
					<c:param name="author" value="김정남"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d9.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/33189944618"/>
				</c:url>
				<a class="card" href="${clickUrl_10}" data-book-id="13">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d9.jpg" alt=""> <img class="cover-img" src="img/d9.jpg" alt="">
					<div class="card-content">
						<div class="book-title">길 위의 인문학</div>
						<div class="book-author">김정남</div>
						<div class="review-preview">여행과 인문학의 만남</div>
					</div>
				</a>

				<%-- 카드 11 --%>
				<c:url var="clickUrl_11" value="/bookClick">
					<c:param name="id" value="14"/>
					<c:param name="title" value="아리스토텔레스의 시학"/>
					<c:param name="author" value="아리스토텔레스"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d10.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/32436012778"/>
				</c:url>
				<a class="card" href="${clickUrl_11}" data-book-id="14">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d10.jpg" alt=""> <img class="cover-img" src="img/d10.jpg" alt="">
					<div class="card-content">
						<div class="book-title">아리스토텔레스의 시학</div>
						<div class="book-author">아리스토텔레스</div>
						<div class="review-preview">비극 이론의 원전</div>
					</div>
				</a>

				<%-- 카드 12 --%>
				<c:url var="clickUrl_12" value="/bookClick">
					<c:param name="id" value="15"/>
					<c:param name="title" value="미술관에 간 과학자"/>
					<c:param name="author" value="이정모"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d11.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/32438202741"/>
				</c:url>
				<a class="card" href="${clickUrl_12}" data-book-id="15">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d11.jpg" alt=""> <img class="cover-img" src="img/d11.jpg" alt="">
					<div class="card-content">
						<div class="book-title">미술관에 간 과학자</div>
						<div class="book-author">이정모</div>
						<div class="review-preview">과학적 시선으로 읽는 미술</div>
					</div>
				</a>

				<%-- 카드 13 --%>
				<c:url var="clickUrl_13" value="/bookClick">
					<c:param name="id" value="16"/>
					<c:param name="title" value="에디토리얼 씽킹"/>
					<c:param name="author" value="최혜진"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d12.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/44417064619"/>
				</c:url>
				<a class="card" href="${clickUrl_13}" data-book-id="16">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d12.jpg" alt=""> <img class="cover-img" src="img/d12.jpg" alt="">
					<div class="card-content">
						<div class="book-title">에디토리얼 씽킹</div>
						<div class="book-author">최혜진</div>
						<div class="review-preview">편집 디자인의 창의적 사고</div>
					</div>
				</a>

				<%-- 카드 14 --%>
				<c:url var="clickUrl_14" value="/bookClick">
					<c:param name="id" value="17"/>
					<c:param name="title" value="현대 물리학과 동양사상"/>
					<c:param name="author" value="프리초프 카프라"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d13.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/32473020311"/>
				</c:url>
				<a class="card" href="${clickUrl_14}" data-book-id="17">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d13.jpg" alt=""> <img class="cover-img" src="img/d13.jpg" alt="">
					<div class="card-content">
						<div class="book-title">현대 물리학과 동양사상</div>
						<div class="book-author">프리초프 카프라</div>
						<div class="review-preview">동서양 사상의 교차점</div>
					</div>
				</a>

				<%-- 카드 15 --%>
				<c:url var="clickUrl_15" value="/bookClick">
					<c:param name="id" value="18"/>
					<c:param name="title" value="문학이란 무엇인가"/>
					<c:param name="author" value="장폴 사르트르"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d14.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/32486736931"/>
				</c:url>
				<a class="card" href="${clickUrl_15}" data-book-id="18">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d14.jpg" alt=""> <img class="cover-img" src="img/d14.jpg" alt="">
					<div class="card-content">
						<div class="book-title">문학이란 무엇인가</div>
						<div class="book-author">장폴 사르트르</div>
						<div class="review-preview">문학의 존재론적 의미 탐구</div>
					</div>
				</a>

				<%-- 카드 16 --%>
				<c:url var="clickUrl_16" value="/bookClick">
					<c:param name="id" value="19"/>
					<c:param name="title" value="클래식 왜 안 좋아하세요?"/>
					<c:param name="author" value="권태영"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/dp30.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/54417375837"/>
				</c:url>
				<a class="card" href="${clickUrl_16}" data-book-id="19">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/dp30.jpg" alt=""> <img class="cover-img" src="img/dp30.jpg" alt="">
					<div class="card-content">
						<div class="book-title">클래식 왜 안 좋아하세요?</div>
						<div class="book-author">권태영</div>
						<div class="review-preview">클래식 입문자를 위한 20인의 음악가</div>
					</div>
				</a>


				<%-- 카드 17 --%>
				<c:url var="clickUrl_17" value="/bookClick">
					<c:param name="id" value="20"/>
					<c:param name="title" value="모 이야기"/>
					<c:param name="author" value="최연주"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d16.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/37524796620"/>
				</c:url>
				<a class="card" href="${clickUrl_17}" data-book-id="20">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d16.jpg" alt=""> <img class="cover-img" src="img/d16.jpg" alt="">
					<div class="card-content">
						<div class="book-title">모 이야기</div>
						<div class="book-author">최연주</div>
						<div class="review-preview">현대인의 일상을 그린 따뜻한 에세이</div>
					</div>
				</a>

				<%-- 카드 18 --%>
				<c:url var="clickUrl_18" value="/bookClick">
					<c:param name="id" value="21"/>
					<c:param name="title" value="나는 고양이로소이다"/>
					<c:param name="author" value="나쓰메 소세키"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d17.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/53632315796"/>
				</c:url>
				<a class="card" href="${clickUrl_18}" data-book-id="21">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d17.jpg" alt=""> <img class="cover-img" src="img/d17.jpg" alt="">
					<div class="card-content">
						<div class="book-title">나는 고양이로소이다</div>
						<div class="book-author">나쓰메 소세키</div>
						<div class="review-preview">유쾌한 사회 풍자 소설</div>
					</div>
				</a>

				<%-- 카드 19 --%>
				<c:url var="clickUrl_19" value="/bookClick">
					<c:param name="id" value="22"/>
					<c:param name="title" value="방구석 미술관"/>
					<c:param name="author" value="조원재"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d18.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/32436144217"/>
				</c:url>
				<a class="card" href="${clickUrl_19}" data-book-id="22">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d18.jpg" alt=""> <img class="cover-img" src="img/d18.jpg" alt="">
					<div class="card-content">
						<div class="book-title">방구석 미술관</div>
						<div class="book-author">조원재</div>
						<div class="review-preview">집에서도 즐기는 미술 이야기</div>
					</div>
				</a>

				<%-- 카드 20 --%>
				<c:url var="clickUrl_20" value="/bookClick">
					<c:param name="id" value="23"/>
					<c:param name="title" value="자연스러운 인체 드로잉"/>
					<c:param name="author" value="드로잉 전문가"/>
					<c:param name="image" value="${pageContext.request.contextPath}/img/d19.jpg"/>
					<c:param name="link" value="https://search.shopping.naver.com/book/catalog/33895602632"/>
				</c:url>
				<a class="card" href="${clickUrl_20}" data-book-id="23">
					<i class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img" src="img/d19.jpg" alt=""> <img class="cover-img" src="img/d19.jpg" alt="">
					<div class="card-content">
						<div class="book-title">자연스러운 인체 드로잉</div>
						<div class="book-author">드로잉 전문가</div>
						<div class="review-preview">자연스러운 인체 표현 기법</div>
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
    const contextPath = "<%= request.getContextPath() %>";
    const isLoggedIn = <%= session.getAttribute("loggedInUser") != null %>;

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
