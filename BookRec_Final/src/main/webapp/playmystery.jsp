<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%-- JSTL 사용을 위한 태그 라이브러리 선언 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
// [추가] 페이지에서 사용할 변수들을 선언합니다.
User loggedInUser = (User) session.getAttribute("loggedInUser");
String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>추리/스릴러 - 책 추천</title>
<%@ include file="css/main_css.jsp"%>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="icon" href="img/icon2.png" type="image/x-icon">
<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/css/playlist.css">
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
			<a href="playlistmain.jsp" class="back-button" title="뒤로가기"> <i
				class="fas fa-arrow-left"></i>
			</a>
			<div class="page-title">미스테리/추리</div>
		</div>

		<div class="main-content">
			<div class="video-section">
				<h2 class="video-title">플레이 리스트</h2>
				<div class="video-container">
					<iframe
						src="https://www.youtube.com/embed/sMAl90ZkJHM?si=dl6ao0IHxfRxTtxh"
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
						<c:param name="id" value="79" />
						<c:param name="title" value="용의자 X의 헌신" />
						<c:param name="author" value="히가시노 게이고" />
						<c:param name="image"
							value="${pageContext.request.contextPath}/img/m3.jpg" />
						<c:param name="link"
							value="https://search.shopping.naver.com/book/catalog/32463541483" />
					</c:url>

					<a href="${featuredBookUrl}" class="featured-book-image"
						data-book-id="79"> <img src="img/m3.jpg" alt="용의자 X의 헌신">
					</a>
					<div class="featured-book-info">
						<div class="featured-book-title">용의자 X의 헌신</div>
						<div class="featured-book-author">저자: 히가시노 게이고</div>
						<div class="featured-book-rating">
							<span class="stars">★ 9.6</span> <span>(89)</span>
						</div>
						<div class="featured-book-description">천재 수학자 이시가미는 옆집에 사는
							야스코가 전남편을 살해한 것을 알게 된다. 그녀를 향한 깊은 사랑으로 그는 완벽한 알리바이를 설계하며 자신의 모든
							것을 바친다. 사건을 파고드는 천재 물리학자 유카와와의 치열한 두뇌 싸움 속에서, 상상을 초월하는 헌신적인 사랑의
							비밀이 드러난다.</div>
					</div>
				</div>
			</div>
		</div>

		<div class="cards-section">
			<h2 class="cards-title">🔍 WITHUS의 추천 미스테리/추리</h2>
			<div class="grid">

				<%-- 카드 1 --%>
				<c:url var="clickUrl_1" value="/bookClick">
					<c:param name="id" value="80" />
					<c:param name="title" value="셜록 홈즈 전집" />
					<c:param name="author" value="아서 코난 도일" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32491716827?query=%EC%85%9C%EB%A1%9D%20%ED%99%88%EC%A6%88%20%EC%A0%84%EC%A7%91%20%EC%84%B8%ED%8A%B8&NaPm=ct%3Dmcvaeik8%7Cci%3D9924dcf538bbd98cdec3038a21c4ef09fe997ba7%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D5666aaa11a614a772f79ff424a5fe0bd54be5754" />
				</c:url>
				<a class="card" href="${clickUrl_1}" data-book-id="80"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m.jpg" alt="배경" /> <img class="cover-img" src="img/m.jpg"
					alt="표지" />
					<div class="card-content">
						<div class="book-title">셜록 홈즈 전집</div>
						<div class="book-author">아서 코난 도일</div>
						<div class="review-preview">탐정 소설의 고전이자 원형</div>
					</div>
				</a>

				<%-- 카드 2 --%>
				<c:url var="clickUrl_2" value="/bookClick">
					<c:param name="id" value="81" />
					<c:param name="title" value="그리고 아무도 없었다" />
					<c:param name="author" value="애거서 크리스티" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m1.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32463426752?query=%EA%B7%B8%EB%A6%AC%EA%B3%A0%20%EC%95%84%EB%AC%B4%EB%8F%84%20%EC%97%86%EC%97%88%EB%8B%A4&NaPm=ct%3Dmcvaeqa0%7Cci%3Dd736d36b62b1227405fa14c108e3057744cebc20%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Dc969bc301fedf65fbbcc5bff76a4f9f7ee2b87e9" />
				</c:url>
				<a class="card" href="${clickUrl_2}" data-book-id="81"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m1.jpg" alt="배경" /> <img class="cover-img"
					src="img/m1.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">그리고 아무도 없었다</div>
						<div class="book-author">애거서 크리스티</div>
						<div class="review-preview">밀실 추리 소설의 대가</div>
					</div>
				</a>

				<%-- 카드 3 --%>
				<c:url var="clickUrl_3" value="/bookClick">
					<c:param name="id" value="82" />
					<c:param name="title" value="검은 고양이" />
					<c:param name="author" value="에드거 앨런 포" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m2.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/39570707619?query=%EA%B2%80%EC%9D%80%20%EA%B3%A0%EC%96%91%EC%9D%B4&NaPm=ct%3Dmcvaf5pk%7Cci%3D27332be374cfe3df039d6b41c74f3c78d84f11dd%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D5a6035d01f2cd1db89d5568d2a2d04faeee02209" />
				</c:url>
				<a class="card" href="${clickUrl_3}" data-book-id="82"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m2.jpg" alt="배경" /> <img class="cover-img"
					src="img/m2.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">검은 고양이</div>
						<div class="book-author">에드거 앨런 포</div>
						<div class="review-preview">고딕 소설과 심리 스릴러의 선구자</div>
					</div>
				</a>

				<%-- 카드 4 --%>
				<c:url var="clickUrl_4" value="/bookClick">
					<c:param name="id" value="83" />
					<c:param name="title" value="용의자 X의 헌신" />
					<c:param name="author" value="히가시노 게이고" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m3.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32463541483" />
				</c:url>
				<a class="card" href="${clickUrl_4}" data-book-id="83"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m3.jpg" alt="배경" /> <img class="cover-img"
					src="img/m3.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">용의자 X의 헌신</div>
						<div class="book-author">히가시노 게이고</div>
						<div class="review-preview">반전과 심리 묘사가 뛰어난 일본 미스터리</div>
					</div>
				</a>

				<%-- 카드 5 --%>
				<c:url var="clickUrl_5" value="/bookClick">
					<c:param name="id" value="84" />
					<c:param name="title" value="이방인" />
					<c:param name="author" value="알베르 카뮈" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m4.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32465496972?query=%EC%9D%B4%EB%B0%A9%EC%9D%B8&NaPm=ct%3Dmcvafs34%7Cci%3D2ae9a51d3cb2735b1c01d2745299b17d8da7a579%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D0daace47f658c0f1520f06f47a933df370b3adcb" />
				</c:url>
				<a class="card" href="${clickUrl_5}" data-book-id="84"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m4.jpg" alt="배경" /> <img class="cover-img"
					src="img/m4.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">이방인</div>
						<div class="book-author">알베르 카뮈</div>
						<div class="review-preview">부조리 문학의 대표작</div>
					</div>
				</a>

				<%-- 카드 6 --%>
				<c:url var="clickUrl_6" value="/bookClick">
					<c:param name="id" value="85" />
					<c:param name="title" value="살인자의 기억법" />
					<c:param name="author" value="김영하" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m5.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32445380150?query=%EC%82%B4%EC%9D%B8%EC%9E%90%EC%9D%98%20%EA%B8%B0%EC%96%B5%EB%B2%95&NaPm=ct%3Dmcvafzsw%7Cci%3Dfd2185717f8847d6d1d967b6d062c205de013e33%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D4bc0d330fa37fc48015b0ff87d32a4bf3191090a" />
				</c:url>
				<a class="card" href="${clickUrl_6}" data-book-id="85"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m5.jpg" alt="배경" /> <img class="cover-img"
					src="img/m5.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">살인자의 기억법</div>
						<div class="book-author">김영하</div>
						<div class="review-preview">기억 상실 살인범의 독특한 시점</div>
					</div>
				</a>

				<%-- 카드 7 --%>
				<c:url var="clickUrl_7" value="/bookClick">
					<c:param name="id" value="86" />
					<c:param name="title" value="눈먼 암살자" />
					<c:param name="author" value="마거릿 애트우드" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m6.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32486069451?query=%EB%88%88%EB%A8%BC%20%EC%95%94%EC%82%B4%EC%9E%90&NaPm=ct%3Dmcvag8ag%7Cci%3Dcde13f0041d6b8d706f5d02628766c98343818e8%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Dcd4765d87b777dedebccc9910056183eb81e3332" />
				</c:url>
				<a class="card" href="${clickUrl_7}" data-book-id="86"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m6.jpg" alt="배경" /> <img class="cover-img"
					src="img/m6.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">눈먼 암살자</div>
						<div class="book-author">마거릿 애트우드</div>
						<div class="review-preview">문학성과 서스펜스를 겸비한 작품</div>
					</div>
				</a>

				<%-- 카드 8 --%>
				<c:url var="clickUrl_8" value="/bookClick">
					<c:param name="id" value="87" />
					<c:param name="title" value="나를 찾아줘" />
					<c:param name="author" value="길리언 플린" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m7.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32455951957?query=%EB%82%98%EB%A5%BC%20%EC%B0%BE%EC%95%84%EC%A4%98&NaPm=ct%3Dmcvagq1c%7Cci%3D3fe2cabd833e56b6851386f1fa0eb0d384a04a33%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Dbc0aced3345f5e170a5f8773798d231667de0bc8" />
				</c:url>
				<a class="card" href="${clickUrl_8}" data-book-id="87"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m7.jpg" alt="배경" /> <img class="cover-img"
					src="img/m7.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">나를 찾아줘</div>
						<div class="book-author">길리언 플린</div>
						<div class="review-preview">예측 불허의 반전 심리 스릴러</div>
					</div>
				</a>

				<%-- 카드 9 --%>
				<c:url var="clickUrl_9" value="/bookClick">
					<c:param name="id" value="88" />
					<c:param name="title" value="침묵의 봄" />
					<c:param name="author" value="레이첼 카슨" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m8.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32441026328?cat_id=50005765&frm=PBOKPRO&query=%EC%B6%94%EB%A6%AC+%EB%AF%B8%EC%8A%A4%ED%84%B0%EB%A6%AC&NaPm=ct%3Dmcvak4q0%7Cci%3D0bec43bde67db1fdc623d9bd28e9127a5c1c93a0%7Ctr%3Dboknx%7Csn%3D95694%7Chk%3Dc33daf226c861433252aa003a9f8ff2c6e70506d" />
				</c:url>
				<a class="card" href="${clickUrl_9}" data-book-id="88"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m8.jpg" alt="배경" /> <img class="cover-img"
					src="img/m8.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">악의</div>
						<div class="book-author">히가시노 게이고</div>
						<div class="review-preview">죽음을 둘러싼 쫓고 쫓기는 두뇌게임</div>
					</div>
				</a>

				<%-- 카드 10 --%>
				<c:url var="clickUrl_10" value="/bookClick">
					<c:param name="id" value="89" />
					<c:param name="title" value="양들의 침묵" />
					<c:param name="author" value="토마스 해리스" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m9.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/37993612653?query=%EC%96%91%EB%93%A4%EC%9D%98%20%EC%B9%A8%EB%AC%B5&NaPm=ct%3Dmcvamzcg%7Cci%3D9d4dc7e2aad09170636c2801c3775b7ef0aa94a6%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D9ef8c6e267a4b2df9c67d501e0781fb068bac159" />
				</c:url>
				<a class="card" href="${clickUrl_10}" data-book-id="89"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m9.jpg" alt="배경" /> <img class="cover-img"
					src="img/m9.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">양들의 침묵</div>
						<div class="book-author">토마스 해리스</div>
						<div class="review-preview">사이코패스 범죄 스릴러의 대표작</div>
					</div>
				</a>

				<%-- 카드 11 --%>
				<c:url var="clickUrl_11" value="/bookClick">
					<c:param name="id" value="90" />
					<c:param name="title" value="나미야 잡화점의 기적" />
					<c:param name="author" value="히가시노 게이고" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m10.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/36801579622?query=%EB%82%98%EB%AF%B8%EC%95%BC%20%EC%9E%A1%ED%99%94%EC%A0%90%EC%9D%98%20%EA%B8%B0%EC%A0%81&NaPm=ct%3Dmcvavan9dk%7Cci%3D7795a37a4957224c1afa0c7091be83486272ab02%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D67107793576e49f9cfe82342e4915bfa430eb041" />
				</c:url>
				<a class="card" href="${clickUrl_11}" data-book-id="90"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m10.jpg" alt="배경" /> <img class="cover-img"
					src="img/m10.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">나미야 잡화점의 기적</div>
						<div class="book-author">히가시노 게이고</div>
						<div class="review-preview">따뜻한 판타지 미스터리</div>
					</div>
				</a>

				<%-- 카드 12 --%>
				<c:url var="clickUrl_12" value="/bookClick">
					<c:param name="id" value="91" />
					<c:param name="title" value="장미의 이름" />
					<c:param name="author" value="움베르토 에코" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m11.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32477587844?query=%EC%9E%A5%EB%AF%B8%EC%9D%98%20%EC%9D%B4%EB%A6%84&NaPm=ct%3Dmcvank6g%7Cci%3D4234cdc06363d49b3166dcc8309a4a2236c27cd8%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Dd582e4b8ec6980584783d9c83dd259d75b8b33f0" />
				</c:url>
				<a class="card" href="${clickUrl_12}" data-book-id="91"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m11.jpg" alt="배경" /> <img class="cover-img"
					src="img/m11.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">장미의 이름</div>
						<div class="book-author">움베르토 에코</div>
						<div class="review-preview">중세 수도원 배경의 지적 추리 소설</div>
					</div>
				</a>

				<%-- 카드 13 --%>
				<c:url var="clickUrl_13" value="/bookClick">
					<c:param name="id" value="92" />
					<c:param name="title" value="죄와 벌" />
					<c:param name="author" value="표도르 도스토옙스키" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m12.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32463522644?query=%EC%A3%84%EC%99%80%20%EB%B2%8C&NaPm=ct%3Dmcvvanr4g%7Cci%3D3a3bf6ac825db8dec45ead9b002bed9cca17ad11%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Dde3a2d9c024313c4b159a1d36e11dbbbbe847603" />
				</c:url>
				<a class="card" href="${clickUrl_13}" data-book-id="92"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m12.jpg" alt="배경" /> <img class="cover-img"
					src="img/m12.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">죄와 벌</div>
						<div class="book-author">표도르 도스토옙스키</div>
						<div class="review-preview">범죄와 인간 양심의 문제를 다룬 심리 소설</div>
					</div>
				</a>

				<%-- 카드 14 --%>
				<c:url var="clickUrl_14" value="/bookClick">
					<c:param name="id" value="93" />
					<c:param name="title" value="나는 고양이로소이다" />
					<c:param name="author" value="나쓰메 소세키" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m13.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32491412836?query=%EB%82%98%EB%8A%94%20%EA%B3%A0%EC%96%91%EC%9D%B4%EB%A1%9C%EC%86%8C%EC%9D%B4%EB%8B%A4&NaPm=ct%3Dmcvvao0ds%7Cci%3Db603840d303484a31812aaf5a93d7cab9e1c8a27%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Dcb5c60e1c59551d40a23beeb5b22efe62748186f" />
				</c:url>
				<a class="card" href="${clickUrl_14}" data-book-id="93"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m13.jpg" alt="배경" /> <img class="cover-img"
					src="img/m13.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">나는 고양이로소이다</div>
						<div class="book-author">나쓰메 소세키</div>
						<div class="review-preview">인간 사회 풍자</div>
					</div>
				</a>

				<%-- 카드 15 --%>
				<c:url var="clickUrl_15" value="/bookClick">
					<c:param name="id" value="94" />
					<c:param name="title" value="검은 집" />
					<c:param name="author" value="기시 유스케" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m14.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/35304167846?query=%EA%B2%80%EC%9D%80%20%EC%A7%91&NaPm=ct%3Dmcvvaoaew%7Cci%3D82cfc178b2358aa13c3d69a47b7675ebef396182%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Ddd1208b166de3096ccb105d6ca16af164b7235d6" />
				</c:url>
				<a class="card" href="${clickUrl_15}" data-book-id="94"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m14.jpg" alt="배경" /> <img class="cover-img"
					src="img/m14.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">검은 집</div>
						<div class="book-author">기시 유스케</div>
						<div class="review-preview">일본 호러 미스터리</div>
					</div>
				</a>

				<%-- 카드 16 --%>
				<c:url var="clickUrl_16" value="/bookClick">
					<c:param name="id" value="95" />
					<c:param name="title" value="애크로이드 살인 사건" />
					<c:param name="author" value="애거사 크리스티" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m15.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32486413942" />
				</c:url>
				<a class="card" href="${clickUrl_16}" data-book-id="95"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m15.jpg" alt="배경" /> <img class="cover-img"
					src="img/m15.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">애크로이드 살인 사건</div>
						<div class="book-author">애거사 크리스티</div>
						<div class="review-preview">추리 소설사에 길이 남을 혁신적인 트릭</div>
					</div>
				</a>

				<%-- 카드 17 (※ 원본 링크 오타 수정: https:// 추가) --%>
				<c:url var="clickUrl_17" value="/bookClick">
					<c:param name="id" value="96" />
					<c:param name="title" value="고독한 용의자" />
					<c:param name="author" value="찬호께이" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m16.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/54213715512" />
				</c:url>
				<a class="card" href="${clickUrl_17}" data-book-id="96"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m16.jpg" alt="배경" /> <img class="cover-img"
					src="img/m16.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">고독한 용의자</div>
						<div class="book-author">찬호께이</div>
						<div class="review-preview">홍콩 추리 소설의 독특한 매력을 보여주는 작품</div>
					</div>
				</a>

				<%-- 카드 18 --%>
				<c:url var="clickUrl_18" value="/bookClick">
					<c:param name="id" value="97" />
					<c:param name="title" value="첫번째 거짓말이 중요하다" />
					<c:param name="author" value="애슐리 엘스턴" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m17.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/54069896693" />
				</c:url>
				<a class="card" href="${clickUrl_18}" data-book-id="97"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m17.jpg" alt="배경" /> <img class="cover-img"
					src="img/m17.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">첫번째 거짓말이 중요하다</div>
						<div class="book-author">애슐리 엘스턴</div>
						<div class="review-preview">청소년을 위한 흥미진진한 미스터리 소설</div>
					</div>
				</a>

				<%-- 카드 19 --%>
				<c:url var="clickUrl_19" value="/bookClick">
					<c:param name="id" value="98" />
					<c:param name="title" value="하우스메이드" />
					<c:param name="author" value="프리다 맥파튼" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m18.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/39075448620?query=%ED%95%98%EC%9A%B0%EC%8A%A4%EB%A9%94%EC%9D%B4%EB%93%9C&NaPm=ct%3Dmcvap7lc%7Cci%3D88f55ce5b16868ed01fa793744b62d30d9c9d22a%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D6bf3b2f480eaa9e1464821155bc852bd9d0fe537" />
				</c:url>
				<a class="card" href="${clickUrl_19}" data-book-id="98"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m18.jpg" alt="배경" /> <img class="cover-img"
					src="img/m18.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">하우스메이드</div>
						<div class="book-author">프리다 맥파튼</div>
						<div class="review-preview">계급 갈등과 복수를 다룬 심리 스릴러</div>
					</div>
				</a>

				<%-- 카드 20 --%>
				<c:url var="clickUrl_20" value="/bookClick">
					<c:param name="id" value="99" />
					<c:param name="title" value="Y의 비극" />
					<c:param name="author" value="앨러리 퀸" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/m19.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32463439697?query=Y%EC%9D%98%20%EB%B9%84%EA%B7%B9&NaPm=ct%3Dmcvapejc%7Cci%3D1f818ccfe933f7026c71eab422ed9b5f6b6686a0%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Db45d508401125d562af3c9e0c37bc3d1c49d856d" />
				</c:url>
				<a class="card" href="${clickUrl_20}" data-book-id="99"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/m19.jpg" alt="배경" /> <img class="cover-img"
					src="img/m19.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">Y의 비극</div>
						<div class="book-author">앨러리 퀸</div>
						<div class="review-preview">본격 추리 소설의 황금기를 대표하는 고전</div>
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