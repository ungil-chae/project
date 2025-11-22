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
<title>건강/스포츠 - 책 추천</title>
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
			<div class="page-title">건강/스포츠</div>
		</div>

		<div class="main-content">
			<div class="video-section">
				<h2 class="video-title">플레이 리스트</h2>
				<div class="video-container">
					<iframe
						src="https://www.youtube.com/embed/I2mo7a9XHnM?si=oJXEdj_cdjnKXJNv"
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
						<c:param name="id" value="45" />
						<c:param name="title" value="백년허리2" />
						<c:param name="author" value="정선근" />
						<c:param name="image"
							value="${pageContext.request.contextPath}/img/r1.jpg" />
						<c:param name="link"
							value="https://search.shopping.naver.com/book/catalog/32443415783?query=%EB%B0%B1%EB%85%84%ED%97%88%EB%A6%AC&NaPm=ct%3Dmcvc6auw%7Cci%3De30dcf713a00549969d85d81c1264d9e6665a3a0%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Da2bd6f54efb8470d392c712323c0d2e54d878e7a" />
					</c:url>

					<a href="${featuredBookUrl}" class="featured-book-image"
						data-book-id="45"> <img src="img/r1.jpg" alt="백년허리2">
					</a>
					<div class="featured-book-info">
						<div class="featured-book-title">백년허리2</div>
						<div class="featured-book-author">저자: 정선근</div>
						<div class="featured-book-rating">
							<span class="stars">★ 9.6</span> <span>(814)</span>
						</div>
						<div class="featured-book-description">서울대 의대 재활의학과 정선근 교수의
							스테디셀러인 백년허리1 진단편에 이어서 실제적인 치료 방법을 제시하고 있는 백년허리2 치료편이다. 치료편에서 저자는
							허리 통증에서 벗어날 수 있는 방법을 정확히, 구체적으로, 누구나 따라할 수 있도록 설명하고 있다. 일상생활, 운동,
							작업 등 허리 아픈 사람이 겪게 되는 모든 상황에서 허리를 어떻게 사용하는 것이 옳은지를 알려주는 말그대로 국민 허리
							사용설명서이다.</div>
					</div>
				</div>
			</div>
		</div>

		<div class="cards-section">
			<h2 class="cards-title">💊 WITHUS의 추천 건강/스포츠</h2>
			<div class="grid">

				<%-- 카드 1 --%>
				<c:url var="clickUrl_1" value="/bookClick">
					<c:param name="id" value="46" />
					<c:param name="title" value="백년허리2" />
					<c:param name="author" value="정선근" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/r1.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32443415783?query=%EB%B0%B1%EB%85%84%ED%97%88%EB%A6%AC&NaPm=ct%3Dmcvc6auw%7Cci%3De30dcf713a00549969d85d81c1264d9e6665a3a0%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Da2bd6f54efb8470d392c712323c0d2e54d878e7a" />
				</c:url>
				<a class="card" href="${clickUrl_1}" data-book-id="46"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/r1.jpg" alt="배경" /> <img class="cover-img"
					src="img/r1.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">백년허리2</div>
						<div class="book-author">정선근</div>
						<div class="review-preview">평생 건강한 허리를 위한 실용적인 운동법과 관리법</div>
					</div>
				</a>

				<%-- 카드 2 --%>
				<c:url var="clickUrl_2" value="/bookClick">
					<c:param name="id" value="47" />
					<c:param name="title" value="백년허리 1" />
					<c:param name="author" value="정선근" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/r2.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/32464881699?query=%EB%B0%B1%EB%85%84%ED%97%88%EB%A6%AC&NaPm=ct%3Dmcvc6kw0%7Cci%3Dbc7e43c3af21bc6f5043a294b7b095dd779799a6%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Df6d2845b0c1bba20a4a14d8bb51fdebb07606b7b" />
				</c:url>
				<a class="card" href="${clickUrl_2}" data-book-id="47"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/r2.jpg" alt="배경" /> <img class="cover-img"
					src="img/r2.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">백년허리 1</div>
						<div class="book-author">정선근</div>
						<div class="review-preview">허리 건강의 기초를 다지는 필수 가이드북</div>
					</div>
				</a>

				<%-- 카드 3 --%>
				<c:url var="clickUrl_3" value="/bookClick">
					<c:param name="id" value="48" />
					<c:param name="title" value="부모의 내면이 아이의 세상이 된다" />
					<c:param name="author" value="대니얼 J.시겔, 메리 하첼" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/r3.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/53596732377" />
				</c:url>
				<a class="card" href="${clickUrl_3}" data-book-id="48"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/r3.jpg" alt="배경" /> <img class="cover-img"
					src="img/r3.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">부모의 내면이 아이의 세상이 된다</div>
						<div class="book-author">대니얼 J.시겔, 메리 하첼</div>
						<div class="review-preview">아이의 건강한 성장을 위한 부모의 심리적 건강 관리</div>
					</div>
				</a>

				<%-- 카드 4 --%>
				<c:url var="clickUrl_4" value="/bookClick">
					<c:param name="id" value="49" />
					<c:param name="title" value="저속노화 마인드셋" />
					<c:param name="author" value="정희원" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/r4.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/55233201844" />
				</c:url>
				<a class="card" href="${clickUrl_4}" data-book-id="49"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/r4.jpg" alt="배경" /> <img class="cover-img"
					src="img/r4.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">저속노화 마인드셋</div>
						<div class="book-author">정희원</div>
						<div class="review-preview">건강한 노화를 위한 마음가짐과 생활 철학</div>
					</div>
				</a>

				<%-- 카드 5 --%>
				<c:url var="clickUrl_5" value="/bookClick">
					<c:param name="id" value="50" />
					<c:param name="title" value="길 위의 뇌" />
					<c:param name="author" value="정세희" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/r5.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/50794068618?query=%EA%B8%B8%20%EC%9C%84%EC%9D%98%20%EB%87%8C&NaPm=ct%3Dmcvc9smo%7Cci%3D9d67f65f31faa3dcadab9d161e0585248f2711e7%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D4a8ab8bb1bb33db1de9182cbe7a097da01713eec" />
				</c:url>
				<a class="card" href="${clickUrl_5}" data-book-id="50"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/r5.jpg" alt="배경" /> <img class="cover-img"
					src="img/r5.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">길 위의 뇌</div>
						<div class="book-author">정세희</div>
						<div class="review-preview">일상 속에서 뇌 건강을 지키는 실용적인 방법들</div>
					</div>
				</a>

				<%-- 카드 6 --%>
				<c:url var="clickUrl_6" value="/bookClick">
					<c:param name="id" value="51" />
					<c:param name="title" value="해독 혁명" />
					<c:param name="author" value="닥터 라이블리" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/r6.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/48703888627?query=%ED%95%B4%EB%8F%85%20%ED%98%81%EB%AA%85&NaPm=ct%3Dmcvc9zko%7Cci%3D77627ae6d187d6698827038f56c2b8643e451a12%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D64dbe4852c35b1492f68e55e44b646a190dde7a2" />
				</c:url>
				<a class="card" href="${clickUrl_6}" data-book-id="51"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/r6.jpg" alt="배경" /> <img class="cover-img"
					src="img/r6.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">해독 혁명</div>
						<div class="book-author">닥터 라이블리</div>
						<div class="review-preview">몸의 독소를 제거하고 건강을 회복하는 혁신적 방법</div>
					</div>
				</a>

				<%-- 카드 7 --%>
				<c:url var="clickUrl_7" value="/bookClick">
					<c:param name="id" value="52" />
					<c:param name="title" value="저속노화 식사법" />
					<c:param name="author" value="정희원" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/r7.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/49230537626" />
				</c:url>
				<a class="card" href="${clickUrl_7}" data-book-id="52"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/r7.jpg" alt="배경" /> <img class="cover-img"
					src="img/r7.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">저속노화 식사법</div>
						<div class="book-author">정희원</div>
						<div class="review-preview">노화를 늦추는 과학적인 식단과 영양 관리법</div>
					</div>
				</a>

				<%-- 카드 8 --%>
				<c:url var="clickUrl_8" value="/bookClick">
					<c:param name="id" value="53" />
					<c:param name="title" value="내 몸 혁명" />
					<c:param name="author" value="박용우" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/r8.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/44790604624?query=%EB%82%B4%20%EB%AA%B8%20%ED%98%81%EB%AA%85&NaPm=ct%3Dmcvcadgo%7Cci%3D50c90a0cdc31cd918c7fc29d187e1e6d6c5fa910%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D4007b7c1dfe599a3058b2b35ccf35493aec024a4" />
				</c:url>
				<a class="card" href="${clickUrl_8}" data-book-id="53"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/r8.jpg" alt="배경" /> <img class="cover-img"
					src="img/r8.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">내 몸 혁명</div>
						<div class="book-author">박용우</div>
						<div class="review-preview">건강한 몸을 만들기 위한 총체적인 생활 개선 가이드</div>
					</div>
				</a>

				<%-- 카드 9 (※ 원본 링크 오타 수정: https:// 추가) --%>
				<c:url var="clickUrl_9" value="/bookClick">
					<c:param name="id" value="54" />
					<c:param name="title" value="느리게 나이 드는 습관" />
					<c:param name="author" value="정희원" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/r9.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/43898089618?query=%EB%8A%90%EB%A6%AC%EA%B2%8C%20%EB%82%98%EC%9D%B4%20%EB%93%9C%EB%8A%94%20%EC%8A%B5%EA%B4%80&NaPm=ct%3Dmcvcanhs%7Cci%3Dd155ff5498686e214129a1b4abb15070897aae86%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3D2079cefcb2b9b9d0fb2270430b8a3ace241eab67" />
				</c:url>
				<a class="card" href="${clickUrl_9}" data-book-id="54"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/r9.jpg" alt="배경" /> <img class="cover-img"
					src="img/r9.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">느리게 나이 드는 습관</div>
						<div class="book-author">정희원</div>
						<div class="review-preview">건강한 장수를 위한 일상 습관의 중요성과 실천법</div>
					</div>
				</a>

				<%-- 카드 10 --%>
				<c:url var="clickUrl_10" value="/bookClick">
					<c:param name="id" value="55" />
					<c:param name="title" value="기적의 항암 식단" />
					<c:param name="author" value="김훈하, 김정은" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/r10.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/50395358626?query=%EA%B8%B0%EC%A0%81%EC%9D%98%20%ED%95%AD%EC%95%94%20%EC%8B%9D%EB%8B%A8&NaPm=ct%3Dmcvcavzc%7Cci%3D7d12ed3ca292bbb10294297dd696d22fb013a227%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Dcc23e32566607a2971ab2976d5dc4935a89940b7" />
				</c:url>
				<a class="card" href="${clickUrl_10}" data-book-id="55"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/r10.jpg" alt="배경" /> <img class="cover-img"
					src="img/r10.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">기적의 항암 식단</div>
						<div class="book-author">김훈하, 김정은</div>
						<div class="review-preview">암 예방과 치료에 도움이 되는 과학적 식단 가이드</div>
					</div>
				</a>

				<%-- 카드 11 --%>
				<c:url var="clickUrl_11" value="/bookClick">
					<c:param name="id" value="56" />
					<c:param name="title" value="회복탄력성의 뇌과학" />
					<c:param name="author" value="아디티 네루카" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/r11.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/54747847889" />
				</c:url>
				<a class="card" href="${clickUrl_11}" data-book-id="56"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/r11.jpg" alt="배경" /> <img class="cover-img"
					src="img/r11.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">회복탄력성의 뇌과학</div>
						<div class="book-author">아디티 네루카</div>
						<div class="review-preview">스트레스와 트라우마에 맞서는 뇌의 회복 능력 탐구</div>
					</div>
				</a>

				<%-- 카드 12 --%>
				<c:url var="clickUrl_12" value="/bookClick">
					<c:param name="id" value="57" />
					<c:param name="title" value="수면의 뇌과학" />
					<c:param name="author" value="크리스 윈터" />
					<c:param name="image"
						value="${pageContext.request.contextPath}/img/r12.jpg" />
					<c:param name="link"
						value="https://search.shopping.naver.com/book/catalog/54896514986?query=%EC%88%98%EB%A9%B4%EC%9D%98%20%EB%87%8C%EA%B3%BC%ED%95%99&NaPm=ct%3Dmcvcbei0%7Cci%3D144c48537cb5c4ceb9dfe2e50ec1387d410ffc07%7Ctr%3Dboksl%7Csn%3D95694%7Chk%3Df74436f2d976b0cb1fa0713b480ce894c1fb1af0" />
				</c:url>
				<a class="card" href="${clickUrl_12}" data-book-id="57"> <i
					class="fas fa-bookmark bookmark-icon"></i> <img class="bg-img"
					src="img/r12.jpg" alt="배경" /> <img class="cover-img"
					src="img/r12.jpg" alt="표지" />
					<div class="card-content">
						<div class="book-title">수면의 뇌과학</div>
						<div class="book-author">크리스 윈터</div>
						<div class="review-preview">양질의 수면을 위한 과학적 이해와 실천 방법</div>
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