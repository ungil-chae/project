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
<title>시/소설 - 책 추천</title>
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
		<a href="playlistmain.jsp" class="back-button" title="뒤로가기"> <i
			class="fas fa-arrow-left"></i>
		</a>

		<div class="page-title">시/소설</div>

		<div class="main-content">
			<div class="video-section">
				<h2 class="video-title">플레이 리스트</h2>
				<div class="video-container">
					<iframe
						src="https://www.youtube.com/embed/Ha7964DxrO0?si=6m-fxoCcJWO_U5el"
						title="YouTube video player" frameborder="0"
						allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
						referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
				</div>
			</div>

			<div class="books-section">
				<h2 class="books-title">📖 이번 달 추천 도서</h2>

				<c:url var="featuredBookUrl" value="/bookClick">
					<c:param name="id" value="121" />
					<c:param name="title" value="궤도" />
					<c:param name="author" value="서맨사 하비" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/추천1.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/55283479358?cat_id=50005754&frm=PBOKMOD&query=%EA%B6%A4%EB%8F%84+%EC%B1%85&NaPm=ct%3Dmcu73ndk%7Cci%3Dbb6593432c0957c6fe92b57ac2d4fefff4976b09%7Ctr%3Dboknx%7Csn%3D95694%7Chk%3D30c230fd815215174a368650d1652d3033a631da" />
				</c:url>

				<div class="featured-book">
					<a href="${featuredBookUrl}" class="featured-book-image"
						data-book-id="121"> <img src="img/추천1.jpg" alt="궤도 책 표지">
					</a>
					<div class="featured-book-info">
						<div class="featured-book-title">궤도</div>
						<div class="featured-book-author">저자: 서맨사 하비</div>
						<div class="featured-book-rating">
							<span class="stars">★ 9.6</span> <span>(5)</span>
						</div>
						<div class="featured-book-description">서정적인 언어, 예리한 질문과 탐구의
							글쓰기로 펼쳐 보이는 장대한 우주 목가. 2024년 부커상 수상작으로, 우주정거장에서 지구를 공전하는 여섯
							우주비행사의 하루를 그린 아름다운 소설입니다.</div>
					</div>
				</div>
			</div>

		</div>
		<div class="cards-section">
			<h2 class="cards-title">📚 WITHUS의 추천 도서</h2>
			<div class="grid">

				<%-- 카드 1 --%>
				<c:url var="clickUrl_1" value="/bookClick">
					<c:param name="id" value="122" />
					<c:param name="title" value="하늘과 바람과 별과 시" />
					<c:param name="author" value="윤동주" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl1.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32463733922?query=%EC%9C%A4%EB%8F%99%EC%A3%BC%2C%20%ED%95%98%EB%8A%98%EA%B3%BC%20%EB%B0%94%EB%9E%8C%EA%B3%BC%20%EB%B3%84%EA%B3%BC%20%EC%8B%9C&NaPm=ct%3Dmcu86sbs%7Cci%3D0b201b2f1ee8b755148c272297406e5f53b79831%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D521fda1db9a9c45ad8bbf93f027adb476800f668" />
				</c:url>
				<a class="card" href="${clickUrl_1}" data-book-id="122"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl1.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl1.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">하늘과 바람과 별과 시</div>
						<div class="book-author">윤동주</div>
						<div class="review-preview">한국 근대시의 정수</div>
					</div>
				</a>

				<%-- 카드 2 --%>
				<c:url var="clickUrl_2" value="/bookClick">
					<c:param name="id" value="123" />
					<c:param name="title" value="진달래꽃" />
					<c:param name="author" value="김소월" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl2.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/54546391727?query=%EC%A7%84%EB%8B%AC%EB%9E%98%EA%BD%83&NaPm=ct%3Dmcu87k3s%7Cci%3D98f5bb26f4fb4aac39f92a1fde7d410a564b4386%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D84e3f197210529dd657d0cf773ced25f72cfef46" />
				</c:url>
				<a class="card" href="${clickUrl_2}" data-book-id="123"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl2.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl2.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">진달래꽃</div>
						<div class="book-author">김소월</div>
						<div class="review-preview">한국 서정시의 대표작</div>
					</div>
				</a>

				<%-- 카드 3 --%>
				<c:url var="clickUrl_3" value="/bookClick">
					<c:param name="id" value="124" />
					<c:param name="title" value="꽃" />
					<c:param name="author" value="김춘수" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl3.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32466876665?query=%EA%BD%83%20%EA%B9%80%EC%B6%98%EC%88%98&NaPm=ct%3Dmcu88bvs%7Cci%3D36b3356ec5616ca27e758267c0be3b7ebacc25f4%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Db0f973e6ab5ac4e2bc740da31be566b8115ce975" />
				</c:url>
				<a class="card" href="${clickUrl_3}" data-book-id="124"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl3.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl3.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">꽃</div>
						<div class="book-author">김춘수</div>
						<div class="review-preview">존재론적 탐구를 담은 대표 시집</div>
					</div>
				</a>

				<%-- 카드 4 --%>
				<c:url var="clickUrl_4" value="/bookClick">
					<c:param name="id" value="125" />
					<c:param name="title" value="님의 침묵" />
					<c:param name="author" value="한용운" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl4.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/47639297631?query=%EB%8B%98%EC%9D%98%20%EC%B9%A8%EB%AC%B5&NaPm=ct%3Dmcu88v68%7Cci%3Dc9654931ed63ce8a45e813838250bfce2f4a727b%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D39d33a2b9ce8a56dff09000c7ecc37d1b6910a15" />
				</c:url>
				<a class="card" href="${clickUrl_4}" data-book-id="125"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl4.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl4.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">님의 침묵</div>
						<div class="book-author">한용운</div>
						<div class="review-preview">독립과 사랑을 노래한 민족시</div>
					</div>
				</a>

				<%-- 카드 5 --%>
				<c:url var="clickUrl_5" value="/bookClick">
					<c:param name="id" value="126" />
					<c:param name="title" value="별 헤는 밤" />
					<c:param name="author" value="윤동주" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl5.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32438215646?cat_id=50005587&frm=PBOKMOD&query=%EB%B3%84+%ED%97%A4%EB%8A%94+%EB%B0%A4+%EC%9C%A4%EB%8F%99%EC%A3%BC" />
				</c:url>
				<a class="card" href="${clickUrl_5}" data-book-id="126"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl5.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl5.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">별 헤는 밤</div>
						<div class="book-author">윤동주</div>
						<div class="review-preview">서정성과 저항 정신의 조화</div>
					</div>
				</a>

				<%-- 카드 6 --%>
				<c:url var="clickUrl_6" value="/bookClick">
					<c:param name="id" value="127" />
					<c:param name="title" value="서랍에 저녁을 넣어 두었다" />
					<c:param name="author" value="한강" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl6.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/55401590140?query=%EB%B3%84%20%ED%97%A4%EB%8A%94%20%EB%B0%A4&NaPm=ct%3Dmcu898ag%7Cci%3D19eb4669abf28bb2b51b1d8df79d18f03697e7af%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D3e07160217814a77bd6adc8d7912dc386cfd2d1b" />
				</c:url>
				<a class="card" href="${clickUrl_6}" data-book-id="127"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl6.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl6.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">서랍에 저녁을 넣어 두었다</div>
						<div class="book-author">한강</div>
						<div class="review-preview">일상의 소중함을 시적으로 담아낸 감성적 에세이</div>
					</div>
				</a>

				<%-- 카드 7 --%>
				<c:url var="clickUrl_7" value="/bookClick">
					<c:param name="id" value="128" />
					<c:param name="title" value="풀꽃" />
					<c:param name="author" value="나태주" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl7.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32466957130?query=%ED%92%80%EA%BD%83&NaPm=ct%3Dmcu8a1m0%7Cci%3D81bd91e62c7c7dcf1bcba153534b2a7414dcb024%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D04d2a1b1faf7fbaf5b8f63344eb53c571055b3e1" />
				</c:url>
				<a class="card" href="${clickUrl_7}" data-book-id="128"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl7.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl7.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">풀꽃</div>
						<div class="book-author">나태주</div>
						<div class="review-preview">짧지만 깊은 울림을 주는 현대시</div>
					</div>
				</a>

				<%-- 카드 8 --%>
				<c:url var="clickUrl_8" value="/bookClick">
					<c:param name="id" value="129" />
					<c:param name="title" value="사랑하라 한번도 상처받지 않은 것처럼" />
					<c:param name="author" value="류시화 엮음" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl8.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32467019677?query=%EC%82%AC%EB%9E%91%ED%95%98%EB%9D%BC%20%ED%95%9C%20%EB%B2%88%EB%8F%84&NaPm=ct%3Dmcu8ahtc%7Cci%3D1fe856b0792789565b3e1fa46c3f0c62a362ec0b%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D57e76d25d2ee49bc6560933d44a188b81fc4cbf8" />
				</c:url>
				<a class="card" href="${clickUrl_8}" data-book-id="129"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl8.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl8.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">사랑하라 한번도 상처받지 않은 것처럼</div>
						<div class="book-author">류시화 엮음</div>
						<div class="review-preview">대중에게 사랑받는 외국 시 모음</div>
					</div>
				</a>

				<%-- 카드 9 --%>
				<c:url var="clickUrl_9" value="/bookClick">
					<c:param name="id" value="130" />
					<c:param name="title" value="슬픔이 기쁨에게" />
					<c:param name="author" value="정호승" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl9.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32485499679?query=%EC%8A%AC%ED%94%94%EC%9D%B4%20%EA%B8%B0%EC%81%A8%EC%97%90%EA%B2%8C&NaPm=ct%3Dmcu8auxk%7Cci%3Db319d6951b20de091a36ab7145805e1ec90370bd%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D47483bdd4a9277b325ded48e89c346d5b36a68a5" />
				</c:url>
				<a class="card" href="${clickUrl_9}" data-book-id="130"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl9.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl9.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">슬픔이 기쁨에게</div>
						<div class="book-author">정호승</div>
						<div class="review-preview">현실 비판과 따뜻한 시선</div>
					</div>
				</a>

				<%-- 카드 10 --%>
				<c:url var="clickUrl_10" value="/bookClick">
					<c:param name="id" value="131" />
					<c:param name="title" value="입속의 검은 잎" />
					<c:param name="author" value="기형도" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl10.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32483636914?query=%EC%9E%85%EC%86%8D%EC%9D%98%20%EA%B2%80%EC%9D%80%20%EC%9E%85&NaPm=ct%3Dmcu8be80%7Cci%3D7ffbb2ffe244550a91d57d5d0eac8fe71cbee3b4%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D012b1a13e506ae8eb5f86b2812c4525745c65414" />
				</c:url>
				<a class="card" href="${clickUrl_10}" data-book-id="131"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl10.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl10.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">입속의 검은 잎</div>
						<div class="book-author">기형도</div>
						<div class="review-preview">도시인의 불안과 절망을 담은 대표작</div>
					</div>
				</a>

				<%-- 카드 11 --%>
				<c:url var="clickUrl_11" value="/bookClick">
					<c:param name="id" value="132" />
					<c:param name="title" value="서시" />
					<c:param name="author" value="윤동주" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl11.jpg" />
					<c:param name="link"
						value="https://www.aladin.co.kr/shop/wproduct.aspx?ISBN=E002535323&start=pnaverebook" />
				</c:url>
				<a class="card" href="${clickUrl_11}" data-book-id="132"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl11.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl11.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">서시</div>
						<div class="book-author">윤동주</div>
						<div class="review-preview">시대의 아픔을 노래한 대표 서시</div>
					</div>
				</a>

				<%-- 카드 12 --%>
				<c:url var="clickUrl_12" value="/bookClick">
					<c:param name="id" value="133" />
					<c:param name="title" value="나와 나타샤와 흰 당나귀" />
					<c:param name="author" value="백석" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl12.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32503753847?query=%EB%82%98%EC%99%80%20%EB%82%98%ED%83%80%EC%83%A4%EC%99%80%20%ED%9D%B0%20%EB%8B%B9%EB%82%98%EA%B7%80&NaPm=ct%3Dmcu8elyo%7Cci%3D113440d25100a6cd0085f6624e6552d5da871e96%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Dd40d88ce2a9446810a8e9f5aa2606e30a7bec69c" />
				</c:url>
				<a class="card" href="${clickUrl_12}" data-book-id="133"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl12.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl12.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">나와 나타샤와 흰 당나귀</div>
						<div class="book-author">백석</div>
						<div class="review-preview">토속적이고 향토적인 언어</div>
					</div>
				</a>

				<%-- 카드 13 --%>
				<c:url var="clickUrl_13" value="/bookClick">
					<c:param name="id" value="134" />
					<c:param name="title" value="혼모노" />
					<c:param name="author" value="성해나" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl13.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/53688114534?query=%ED%98%BC%EB%AA%A8%EB%85%B8&NaPm=ct%3Dmcu8eyb4%7Cci%3Dc35f544c863c396e178a97de6d90e9c1f1b6616f%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D7bcf34d126b808fab7dee86d832e3f995ec2696a" />
				</c:url>
				<a class="card" href="${clickUrl_13}" data-book-id="134"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl13.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl13.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">혼모노</div>
						<div class="book-author">성해나</div>
						<div class="review-preview">현대 사회의 허위와 진실을 탐구하는 예리한 통찰</div>
					</div>
				</a>

				<%-- 카드 14 --%>
				<c:url var="clickUrl_14" value="/bookClick">
					<c:param name="id" value="135" />
					<c:param name="title" value="소년이 온다" />
					<c:param name="author" value="한강" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl14.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32491401626?query=%EC%86%8C%EB%85%84%EC%9D%B4%20%EC%98%A8%EB%8B%A4&NaPm=ct%3Dmcu8f7kg%7Cci%3Dcf3e900ab3de60f99efdcefcce42765f67381b17%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Ddeeef330fea457cfa641f1ccf1e1b507e2f2147e" />
				</c:url>
				<a class="card" href="${clickUrl_14}" data-book-id="135"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl14.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl14.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">소년이 온다</div>
						<div class="book-author">한강</div>
						<div class="review-preview">5·18 광주를 배경으로 한 역사의 아픔과 인간성 탐구</div>
					</div>
				</a>

				<%-- 카드 15 --%>
				<c:url var="clickUrl_15" value="/bookClick">
					<c:param name="id" value="136" />
					<c:param name="title" value="급류" />
					<c:param name="author" value="정대건" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl15.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/36801578630?query=%EA%B8%89%EB%A5%98&NaPm=ct%3Dmcu8fg20%7Cci%3D3ad1a4e4dbd70dc47540dbc16c0fd029fed32f7d%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D765152e955dd021174e81218a9e920968dd51145" />
				</c:url>
				<a class="card" href="${clickUrl_15}" data-book-id="136"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl15.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl15.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">급류</div>
						<div class="book-author">정대건</div>
						<div class="review-preview">격동하는 시대 속 인간의 삶과 의지를 그린 힘 있는 소설</div>
					</div>
				</a>

				<%-- 카드 16 --%>
				<c:url var="clickUrl_16" value="/bookClick">
					<c:param name="id" value="137" />
					<c:param name="title" value="채식주의자" />
					<c:param name="author" value="한강" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl16.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32482041666?query=%EC%B1%84%EC%8B%9D%EC%A3%BC%EC%9D%98%EC%9E%90&NaPm=ct%3Dmcu8fpbc%7Cci%3D7a760c6ab456e96150acdfd84b2010a01526f045%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D6a3d887e1dc1453859db0a2c86ce90f8c57893c4" />
				</c:url>
				<a class="card" href="${clickUrl_16}" data-book-id="137"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl16.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl16.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">채식주의자</div>
						<div class="book-author">한강</div>
						<div class="review-preview">여성의 의식과 해방을 그린 충격적이고 강렬한 작품</div>
					</div>
				</a>

				<%-- 카드 17 --%>
				<c:url var="clickUrl_17" value="/bookClick">
					<c:param name="id" value="138" />
					<c:param name="title" value="작별하지 않는다" />
					<c:param name="author" value="한강" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl17.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32436366634?query=%EC%9E%91%EB%B3%84%ED%95%98%EC%A7%80%20%EC%95%8A%EB%8A%94%EB%8B%A4&NaPm=ct%3Dmcu8fxsw%7Cci%3D304c1edc0baea0a2ec2de55a7a3685fe3f264871%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Dd006a111d798c8b14bad596b815dc17b9e812a36" />
				</c:url>
				<a class="card" href="${clickUrl_17}" data-book-id="138"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl17.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl17.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">작별하지 않는다</div>
						<div class="book-author">한강</div>
						<div class="review-preview">이별과 기억, 존재에 대한 철학적 성찰이 담긴 시적 소설</div>
					</div>
				</a>

				<%-- 카드 18 --%>
				<c:url var="clickUrl_18" value="/bookClick">
					<c:param name="id" value="139" />
					<c:param name="title" value="외눈박이 물고기의 사랑" />
					<c:param name="author" value="류시화" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl18.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32466557894?query=%EC%99%B8%EB%88%88%EB%B0%95%EC%9D%B4%20%EB%AC%BC%EA%B3%A0%EA%B8%B0&NaPm=ct%3Dmcu8g9dk%7Cci%3D662c7e19493954b5f593b254c6475bb8856127a0%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Dbc70a5dd10527ca20a949dcd253b1fa893f68e1f" />
				</c:url>
				<a class="card" href="${clickUrl_18}" data-book-id="139"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl18.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl18.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">외눈박이 물고기의 사랑</div>
						<div class="book-author">류시화</div>
						<div class="review-preview">결핍 속에서도 사랑과 이해를 찾아가는 에세이.</div>
					</div>
				</a>

				<%-- 카드 19 --%>
				<c:url var="clickUrl_19" value="/bookClick">
					<c:param name="id" value="140" />
					<c:param name="title" value="내가 사랑하는 사람" />
					<c:param name="author" value="정호승" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl20.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32466974725?query=%EB%82%B4%EA%B0%80%20%EC%82%AC%EB%9E%91%ED%95%98%EB%8A%94%20%EC%82%AC%EB%9E%8C&NaPm=ct%3Dmcu8glq0%7Cci%3Dec8daf1474f3dc318a0475df920c4086acaa9fe6%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3De78ed1b41e4a46813c8d33c7fd0465c92955cd9c" />
				</c:url>
				<a class="card" href="${clickUrl_19}" data-book-id="140"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl20.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl20.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">내가 사랑하는 사람</div>
						<div class="book-author">정호승</div>
						<div class="review-preview">사랑과 존재의 의미</div>
					</div>
				</a>

				<%-- 카드 20 --%>
				<c:url var="clickUrl_20" value="/bookClick">
					<c:param name="id" value="141" />
					<c:param name="title" value="흰" />
					<c:param name="author" value="한강" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/tl21.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/53686290980?query=%ED%9D%B0&NaPm=ct%3Dmcu8gtfs%7Cci%3D1a853d7382a9a090790d8b305d41166eaac2c51d%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D42d0353d1e49315652138dc8da823e6e8935d5ed" />
				</c:url>
				<a class="card" href="${clickUrl_20}" data-book-id="141"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/tl21.jpg" alt="배경" /> <img class="cover-img"
					src="img/tl21.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">흰</div>
						<div class="book-author">한강</div>
						<div class="review-preview">색깔과 기억을 통해 삶과 죽음을 탐구하는 서정적 산문</div>
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
