<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
/* 세션 사용자·컨텍스트 경로 변수 */
User loggedInUser = (User) session.getAttribute("loggedInUser");
String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SF/판타지 - 책 추천</title>
<%@ include file="css/main_css.jsp"%>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="icon" href="img/icon2.png" type="image/x-icon">
<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/css/playlist.css">
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
		<!-- 뒤로가기 버튼 & 페이지 타이틀 -->
		<a href="playlistmain.jsp" class="back-button" title="뒤로가기"> <i
			class="fas fa-arrow-left"></i>
		</a>
		<div class="page-title">SF/판타지</div>

		<!-- 메인 영상 + 특집 도서 -->
		<div class="main-content">
			<div class="video-section">
				<h2 class="video-title">플레이 리스트</h2>
				<div class="video-container">
					<iframe
						src="https://www.youtube.com/embed/_XFeRhG3gow?si=kZHK6a7LSqeckQEE"
						title="YouTube video player" frameborder="0"
						allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
						referrerpolicy="strict-origin-when-cross-origin" allowfullscreen>
					</iframe>
				</div>
			</div>

			<div class="books-section">
				<h2 class="books-title">📖 이번 달 추천 도서</h2>

				<c:url var="featuredBookUrl" value="/bookClick">
					<c:param name="id" value="142" />
					<c:param name="title" value="듄" />
					<c:param name="author" value="프랭크 허버트" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s4.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32472972895?query=%EB%93%84&NaPm=ct%3Dmcvbbngo%7Cci%3Da188d28f2bae158494d0e16a43aa742d09494f3a%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Df0b13e4863c1fa454967242c73261b80dc3b4fd9" />
				</c:url>

				<div class="featured-book">
					<a href="${featuredBookUrl}" class="featured-book-image"
						data-book-id="142"> <img src="img/s4.jpg" alt="듄">
					</a>
					<div class="featured-book-info">
						<div class="featured-book-title">듄</div>
						<div class="featured-book-author">저자: 프랭크 허버트</div>
						<div class="featured-book-rating">
							<span class="stars">★ 9.6</span> <span>(23)</span>
						</div>
						<div class="featured-book-description">3만 년에 걸친 인류사를 그려낸 사막
							행성 서사시. SF의 지평을 넓힌 걸작 연대기.</div>
					</div>
				</div>
			</div>
		</div>
		<div class="cards-section">
			<h2 class="cards-title">🚀 WITHUS의 추천 SF/판타지</h2>
			<div class="grid">

				<%-- 카드 1 --%>
				<c:url var="clickUrl_1" value="/bookClick">
					<c:param name="id" value="143" />
					<c:param name="title" value="반지의 제왕 1" />
					<c:param name="author" value="J.R.R. 톨킨" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s1.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32439721312?query=%EB%B0%98%EC%A7%80%EC%9D%98%20%EC%A0%9C%EC%99%95&NaPm=ct%3Dmcvbe1vs%7Cci%3D5dd760201f539cff6ce0f1e373d951d3195c9997%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D7183ec30f4cf2ff5d78a8363a5eb3a0a3e7f958c" />
				</c:url>
				<a class="card" href="${clickUrl_1}" data-book-id="143"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s1.jpg" alt="배경" /> <img class="cover-img"
					src="img/s1.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">반지의 제왕 1</div>
						<div class="book-author">J.R.R. 톨킨</div>
						<div class="review-preview">판타지 장르의 절대적 고전 ①</div>
					</div>
				</a>

				<%-- 카드 2 --%>
				<c:url var="clickUrl_2" value="/bookClick">
					<c:param name="id" value="144" />
					<c:param name="title" value="반지의 제왕 2" />
					<c:param name="author" value="J.R.R. 톨킨" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s2.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32444848610?query=%EB%B0%98%EC%A7%80%EC%9D%98%20%EC%A0%9C%EC%99%95&NaPm=ct%3Dmcvbe9lk%7Cci%3D630bce1b27562f82fdcc57ebd88170eb8175985b%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D06f21ea5f5c942e28e9893fa5549dc076d4c9dfd" />
				</c:url>
				<a class="card" href="${clickUrl_2}" data-book-id="144"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s2.jpg" alt="배경" /> <img class="cover-img"
					src="img/s2.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">반지의 제왕 2</div>
						<div class="book-author">J.R.R. 톨킨</div>
						<div class="review-preview">판타지 장르의 절대적 고전 ②</div>
					</div>
				</a>

				<%-- 카드 3 --%>
				<c:url var="clickUrl_3" value="/bookClick">
					<c:param name="id" value="145" />
					<c:param name="title" value="파운데이션" />
					<c:param name="author" value="아이작 아시모프" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s3.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32492175982?query=%ED%8C%8C%EC%9A%B4%EB%8D%B0%EC%9D%B4%EC%85%98&NaPm=ct%3Dmcvbel68%7Cci%3D42dfd17793f5503984136ba6ecbbf3dbaa22ac8c%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D9276a055236bbab018445381f8d31d512601a238" />
				</c:url>
				<a class="card" href="${clickUrl_3}" data-book-id="145"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s3.jpg" alt="배경" /> <img class="cover-img"
					src="img/s3.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">파운데이션</div>
						<div class="book-author">아이작 아시모프</div>
						<div class="review-preview">SF 우주 서사의 대명사</div>
					</div>
				</a>

				<%-- 카드 4 --%>
				<c:url var="clickUrl_4" value="/bookClick">
					<c:param name="id" value="146" />
					<c:param name="title" value="듄" />
					<c:param name="author" value="프랭크 허버트" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s4.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32472972895?query=%EB%93%84&NaPm=ct%3Dmcvbbngo%7Cci%3Da188d28f2bae158494d0e16a43aa742d09494f3a%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Df0b13e4863c1fa454967242c73261b80dc3b4fd9" />
				</c:url>
				<a class="card" href="${clickUrl_4}" data-book-id="146"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s4.jpg" alt="배경" /> <img class="cover-img"
					src="img/s4.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">듄</div>
						<div class="book-author">프랭크 허버트</div>
						<div class="review-preview">생태·정치·종교가 얽힌 SF 걸작</div>
					</div>
				</a>

				<%-- 카드 5 --%>
				<c:url var="clickUrl_5" value="/bookClick">
					<c:param name="id" value="147" />
					<c:param name="title" value="어스시의 마법사" />
					<c:param name="author" value="어슐러 르 귄" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s5.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32436270284?query=%EC%96%B4%EC%8A%A4%EC%8B%9C%EC%9D%98%20%EB%A7%88%EB%B2%95%EC%82%AC&NaPm=ct%3Dmcvbfpao%7Cci%3Dfcf8509aa4cefacb3488304e9f534bb6dfb9797d%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Df595d3fcfc516da938ce96ec60634b5e6b7a4d6e" />
				</c:url>
				<a class="card" href="${clickUrl_5}" data-book-id="147"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s5.jpg" alt="배경" /> <img class="cover-img"
					src="img/s5.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">어스시의 마법사</div>
						<div class="book-author">어슐러 르 귄</div>
						<div class="review-preview">마법·정체성·균형의 서사시</div>
					</div>
				</a>

				<%-- 카드 6 --%>
				<c:url var="clickUrl_6" value="/bookClick">
					<c:param name="id" value="148" />
					<c:param name="title" value="1984" />
					<c:param name="author" value="조지 오웰" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s6.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32486053981?query=1984&NaPm=ct%3Dmcvbfw8o%7Cci%3D31677635905914ddada1fdc6b8ea3b32ebcd1b1d%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Dd9dd9d0cc6ce17526287584db79bbf294ca8918a" />
				</c:url>
				<a class="card" href="${clickUrl_6}" data-book-id="148"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s6.jpg" alt="배경" /> <img class="cover-img"
					src="img/s6.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">1984</div>
						<div class="book-author">조지 오웰</div>
						<div class="review-preview">디스토피아 경전</div>
					</div>
				</a>

				<%-- 카드 7 --%>
				<c:url var="clickUrl_7" value="/bookClick">
					<c:param name="id" value="149" />
					<c:param name="title" value="멋진 신세계" />
					<c:param name="author" value="올더스 헉슬리" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s7.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32482025744?query=%EB%A9%8B%EC%A7%84%20%EC%8B%A0%EC%84%B8%EA%B3%84&NaPm=ct%3Dmcvbg5i0%7Cci%3D018009bef6fc9d5a21b9c61a2b933904155c5f97%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D643b0b184b748a7f1f6b2cded4615847e3e2798d" />
				</c:url>
				<a class="card" href="${clickUrl_7}" data-book-id="149"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s7.jpg" alt="배경" /> <img class="cover-img"
					src="img/s7.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">멋진 신세계</div>
						<div class="book-author">올더스 헉슬리</div>
						<div class="review-preview">기술 문명과 인간성의 비극</div>
					</div>
				</a>

				<%-- 카드 8 --%>
				<c:url var="clickUrl_8" value="/bookClick">
					<c:param name="id" value="150" />
					<c:param name="title" value="해리 포터 시리즈" />
					<c:param name="author" value="J.K. 롤링" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s8.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/51907198618?query=%ED%95%B4%EB%A6%AC%ED%8F%AC%ED%84%B0%20%EC%8B%9C%EB%A6%AC%EC%A6%88&NaPm=ct%3Dmcvbh480%7Cci%3D62db35d2c2382b475404c4c46e164325c21cdbbc%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Da470457cb584addc9d112114ce477211040629c2" />
				</c:url>
				<a class="card" href="${clickUrl_8}" data-book-id="150"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s8.jpg" alt="배경" /> <img class="cover-img"
					src="img/s8.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">해리 포터 시리즈</div>
						<div class="book-author">J.K. 롤링</div>
						<div class="review-preview">현대 판타지 문화 아이콘</div>
					</div>
				</a>

				<%-- 카드 9 --%>
				<c:url var="clickUrl_9" value="/bookClick">
					<c:param name="id" value="151" />
					<c:param name="title" value="우리가 빛의 속도로 갈 수 없다면" />
					<c:param name="author" value="김초엽" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s9.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32436342677?query=%EC%9A%B0%EB%A6%AC%EA%B0%80%20%EB%B9%9B%EC%9D%98%20%EC%86%8D%EB%8F%84%EB%A1%9C%20%EA%B0%88%20%EC%88%98%20%EC%97%86%EB%8B%A4%EB%A9%B4&NaPm=ct%3Dmcvbhcpk%7Cci%3Df033d66b09aa4df5771a0109eb7dc717ce66a7d9%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3De3ef64962388aafe01b594af36face283a4258f8" />
				</c:url>
				<a class="card" href="${clickUrl_9}" data-book-id="151"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s9.jpg" alt="배경" /> <img class="cover-img"
					src="img/s9.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">우리가 빛의 속도로 갈 수 없다면</div>
						<div class="book-author">김초엽</div>
						<div class="review-preview">한국 SF의 새로운 가능성</div>
					</div>
				</a>

				<%-- 카드 10 --%>
				<c:url var="clickUrl_10" value="/bookClick">
					<c:param name="id" value="152" />
					<c:param name="title" value="지구 끝의 온실" />
					<c:param name="author" value="김초엽" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s10.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32475579086?query=%EC%A7%80%EA%B5%AC%20%EB%81%9D%EC%9D%98%20%EC%98%A8%EC%8B%A4&NaPm=ct%3Dmcvbhl74%7Cci%3D743c8aa8e6c7f08384f0e4f680735c4e4dd2a2ba%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Daf1368280ff9abbed5b87b73821f4fb616e3fab9" />
				</c:url>
				<a class="card" href="${clickUrl_10}" data-book-id="152"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s10.jpg" alt="배경" /> <img class="cover-img"
					src="img/s10.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">지구 끝의 온실</div>
						<div class="book-author">김초엽</div>
						<div class="review-preview">기후 변화와 인류 미래</div>
					</div>
				</a>

				<%-- 카드 11 --%>
				<c:url var="clickUrl_11" value="/bookClick">
					<c:param name="id" value="153" />
					<c:param name="title" value="은하수를 여행하는 히치하이커를 위한 안내서" />
					<c:param name="author" value="더글러스 애덤스" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s11.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32474633768?query=%EC%9D%80%ED%95%98%EC%88%98%EB%A5%BC%20%EC%97%AC%ED%96%89%ED%95%98%EB%8A%94&NaPm=ct%3Dmcvbhz34%7Cci%3Dce657694c34bcf03a38938520cecb42a0ce0197e%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D1610a082f4c7437179f83f1df2120323a24fcc74" />
				</c:url>
				<a class="card" href="${clickUrl_11}" data-book-id="153"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s11.jpg" alt="배경" /> <img class="cover-img"
					src="img/s11.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">은하수를 여행하는 히치하이커를 위한 안내서</div>
						<div class="book-author">더글러스 애덤스</div>
						<div class="review-preview">유머·기발함 가득 SF 코미디</div>
					</div>
				</a>

				<%-- 카드 12 --%>
				<c:url var="clickUrl_12" value="/bookClick">
					<c:param name="id" value="154" />
					<c:param name="title" value="파리대왕" />
					<c:param name="author" value="윌리엄 골딩" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s12.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32463599839?query=%ED%8C%8C%EB%A6%AC%EB%8C%80%EC%99%95&NaPm=ct%3Dmcvbi7ko%7Cci%3Dab4f210d7fd5dffc3d29e6751be4e6a1abec5777%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Dc1602ce647c7720af4cb49f57a0c97ecd087545f" />
				</c:url>
				<a class="card" href="${clickUrl_12}" data-book-id="154"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s12.jpg" alt="배경" /> <img class="cover-img"
					src="img/s12.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">파리대왕</div>
						<div class="book-author">윌리엄 골딩</div>
						<div class="review-preview">문명·야만의 경계 탐구</div>
					</div>
				</a>

				<%-- 카드 13 --%>
				<c:url var="clickUrl_13" value="/bookClick">
					<c:param name="id" value="155" />
					<c:param name="title" value="사이보그가 되다" />
					<c:param name="author" value="김초엽, 김원영" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s13.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32474035096?query=%EC%82%AC%EC%9D%B4%EB%B3%B4%EA%B7%B8%EA%B0%80%20%EB%90%98%EB%8B%A4&NaPm=ct%3Dmcvbigu0%7Cci%3D2d785c1f6b9d0dd72806d2ef829c11ccb4c03afc%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3De83aa4edcc60fc86327fb717e0bc16440782855f" />
				</c:url>
				<a class="card" href="${clickUrl_13}" data-book-id="155"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s13.jpg" alt="배경" /> <img class="cover-img"
					src="img/s13.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">사이보그가 되다</div>
						<div class="book-author">김초엽·김원영</div>
						<div class="review-preview">기술과 인간의 경계 성찰</div>
					</div>
				</a>

				<%-- 카드 14 --%>
				<c:url var="clickUrl_14" value="/bookClick">
					<c:param name="id" value="156" />
					<c:param name="title" value="스페이스 오디세이" />
					<c:param name="author" value="아서 C. 클라크" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s14.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32463430774?query=%EC%8A%A4%ED%8E%98%EC%9D%B4%EC%8A%A4%20%EC%98%A4%EB%94%94%EC%84%B8%EC%9D%B4&NaPm=ct%3Dmcvbiuq0%7Cci%3Dea9987774a027821c9d8310a0f2d03d8425fda39%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Dbd5ed0b5e7d60434ed1ccbc791054cccd4c4d6d0" />
				</c:url>
				<a class="card" href="${clickUrl_14}" data-book-id="156"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s14.jpg" alt="배경" /> <img class="cover-img"
					src="img/s14.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">스페이스 오디세이</div>
						<div class="book-author">아서 C. 클라크</div>
						<div class="review-preview">인류 기원·진화 탐구</div>
					</div>
				</a>

				<%-- 카드 15 --%>
				<c:url var="clickUrl_15" value="/bookClick">
					<c:param name="id" value="157" />
					<c:param name="title" value="백만 광년의 고독 속에서 한 줄의 시를 읽다" />
					<c:param name="author" value="류시화" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s15.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32482671630?query=%EB%B0%B1%EB%A7%8C%EA%B4%91%EB%85%84%EC%9D%98%20%EA%B3%A0%EB%8F%85&NaPm=ct%3Dmcvbj5iw%7Cci%3D2994f618f1daff931de08777c007edcaeec83dcf%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Db5b9872894948db9afa3fc7b17ddcc673789345a" />
				</c:url>
				<a class="card" href="${clickUrl_15}" data-book-id="157"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s15.jpg" alt="배경" /> <img class="cover-img"
					src="img/s15.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">백만 광년의 고독 속에서 한 줄의 시를 읽다</div>
						<div class="book-author">류시화</div>
						<div class="review-preview">우주적 관점의 사색</div>
					</div>
				</a>

				<%-- 카드 16 --%>
				<c:url var="clickUrl_16" value="/bookClick">
					<c:param name="id" value="158" />
					<c:param name="title" value="나는 전설이다" />
					<c:param name="author" value="리처드 매드슨" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s16.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32463133625?query=%EB%82%98%EB%8A%94%20%EC%A0%84%EC%84%A4%EC%9D%B4%EB%8B%A4&NaPm=ct%3Dmcvbjcgw%7Cci%3D4312e1215b866298b9a7494a5012a26c414e7472%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Dbfc9e506355773814d6bad878c0133c33ce32aff" />
				</c:url>
				<a class="card" href="${clickUrl_16}" data-book-id="158"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s16.jpg" alt="배경" /> <img class="cover-img"
					src="img/s16.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">나는 전설이다</div>
						<div class="book-author">리처드 매드슨</div>
						<div class="review-preview">포스트 아포칼립스 원형</div>
					</div>
				</a>

				<%-- 카드 17 --%>
				<c:url var="clickUrl_17" value="/bookClick">
					<c:param name="id" value="159" />
					<c:param name="title" value="호밀밭의 파수꾼" />
					<c:param name="author" value="J.D. 샐린저" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s17.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32474243888?query=%ED%98%B8%EB%B0%80%EB%B0%AD%EC%9D%98%20%ED%8C%8C%EC%88%98%EA%BE%B8%EB%82%98&NaPm=ct%3Dmcvbjotc%7Cci%3Dd1e277f59afb1904cac7f19e2902464d67a29256%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D26aafbdff8a6f7f1da166ca223f4c6000fc2f688" />
				</c:url>
				<a class="card" href="${clickUrl_17}" data-book-id="159"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s17.jpg" alt="배경" /> <img class="cover-img"
					src="img/s17.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">호밀밭의 파수꾼</div>
						<div class="book-author">J.D. 샐린저</div>
						<div class="review-preview">청소년 성장소설 고전</div>
					</div>
				</a>

				<%-- 카드 18 --%>
				<c:url var="clickUrl_18" value="/bookClick">
					<c:param name="id" value="160" />
					<c:param name="title" value="시녀 이야기" />
					<c:param name="author" value="마거릿 애트우드" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s18.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32530942121?query=%EC%8B%9C%EB%85%80%20%EC%9D%B4%EC%95%BC%EA%B8%B0&NaPm=ct%3Dmcvbk2pc%7Cci%3D1d667de7ee54680ca883409537652c90e8f915b1%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D7448154e97fae4886ba08664058a9a5ce92c6b7f" />
				</c:url>
				<a class="card" href="${clickUrl_18}" data-book-id="160"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s18.jpg" alt="배경" /> <img class="cover-img"
					src="img/s18.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">시녀 이야기</div>
						<div class="book-author">마거릿 애트우드</div>
						<div class="review-preview">페미니즘 디스토피아</div>
					</div>
				</a>

				<%-- 카드 19 --%>
				<c:url var="clickUrl_19" value="/bookClick">
					<c:param name="id" value="161" />
					<c:param name="title" value="장미의 이름" />
					<c:param name="author" value="움베르토 에코" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s19.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32477587844?query=%EC%9E%A5%EB%AF%B8%EC%9D%98%20%EC%9D%B4%EB%A6%84&NaPm=ct%3Dmcvbkf1s%7Cci%3Dd3204571fc22947684a0509fcaee25c57b4bdf08%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D516107e1858c2cd0baece016499d26b56cdfe26d" />
				</c:url>
				<a class="card" href="${clickUrl_19}" data-book-id="161"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s19.jpg" alt="배경" /> <img class="cover-img"
					src="img/s19.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">장미의 이름</div>
						<div class="book-author">움베르토 에코</div>
						<div class="review-preview">지적 추리소설 걸작</div>
					</div>
				</a>

				<%-- 카드 20 --%>
				<c:url var="clickUrl_20" value="/bookClick">
					<c:param name="id" value="162" />
					<c:param name="title" value="설국열차" />
					<c:param name="author" value="자크 로브" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/s20.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32497866836?query=%EC%84%A4%EA%B5%AD%EC%97%B4%EC%B0%A8&NaPm=ct%3Dmcvbklzs%7Cci%3Dd7f69c4ca557890797b04ffb8b5abc2d7392413f%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D1a5047039a9fe33853ecd4fd4c5916ee7ede8196" />
				</c:url>
				<a class="card" href="${clickUrl_20}" data-book-id="162"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/s20.jpg" alt="배경" /> <img class="cover-img"
					src="img/s20.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">설국열차</div>
						<div class="book-author">자크 로브</div>
						<div class="review-preview">계급 풍자 포스트 아포칼립스</div>
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
