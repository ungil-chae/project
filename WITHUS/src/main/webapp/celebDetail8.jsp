<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
String contextPath = request.getContextPath();
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<link rel="stylesheet" href="./css/celebList.css" />
<link rel="stylesheet" href="./css/celebDetail.css" />
<%-- 외부 CSS 파일 링크 --%>
<%@ include file="css/main_css.jsp"%>
<%-- main_css를 include --%>
<link rel="icon" href="img/icon2.png" type="image/x-icon">
<head>
<meta charset="UTF-8">
<title>홍경의 추천 책</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<link rel="icon" href="img/icon2.png" type="image/x-icon">

</head>
<body>
	<%@ include file="header.jsp"%>

	<nav>
		<a href="<%=contextPath%>/aiRecommend.jsp">(AI) 책 추천</a> <a
			href="<%=contextPath%>/reviewList.jsp">리뷰</a> <a
			href="<%=contextPath%>/playlistmain.jsp">플레이리스트</a> <a
			href="<%=contextPath%>/celebList.jsp">셀럽추천</a> <a
			href="<%=contextPath%>/mypage.jsp">마이페이지</a>
	</nav>
	<div class="container">
		<h1>홍경</h1>
		<p class="desc">배우 홍경이 추천하는 책</p>

		<div class="thumbnail-container">
			<img src="./img/celeb/hongkyung_thum.jpg" alt="Celeb2 이미지" />
		</div>

		<div class="text-block">
			"지금은 책을 점점 안 읽는다고 하지만, 1990년대까지만 해도 사람들은 책을 많이 읽었죠. 그때까지는 적어도 활자의
			시대였어요. 홍경 씨가 말한 것처럼 책을 읽으며 각자 상상할 수 있었죠."<br> <Br> 저는 매번 많이
			읽지는 못하고 하나를 오래 읽는 타입이에요. 책은 예고편 같은 게 없잖아요? 어쨌든 내가 열 페이지고 스무 페이지고 읽어
			봐야 이 책이 어떤 내용이겠구나 짐작이 되니까요. 그런 것들을 견디지 못하는 사람들도 있는 것 같아요. 예고편이 있어야 하는
			거죠. 저는 그게 책의 매력인 것 같아요. 내가 읽어 보기 전까지는 뭐가 나올지 모르는 거요. 누가 어떤 얘기라고 책 설명을
			해 줘도 사실 알 수가 없잖아요. 아무리 짧은 소설이어도 책은 길죠. 책은 그게 재미있는 것 같아요.
		</div>
		<div class="text-block">
			"너무 좋아서 이 이야기 속으로 들어가고 싶은 책도 있었어요?"<br> <Br> 재미있는 질문이네요. 너무
			많아서 하나만 고르기 좀 어려운데요. 저는 앞서 이야기한 『여름은 오래 그곳에 남아』를 고르고 싶어요. 그 소설 속 인물의
			삶을 살아 보고 싶어요. 그리고 『색채가 없는 다자키 쓰쿠루와 그가 순례를 떠난 해』도 한번 해 보고 싶고요. 내 과거의
			상처를 쫓거나, 과거를 쫓아서 현재에서 과거로 되돌아 가는 건 불가능하잖아요. 가능하더라도 많은 시간과 용기가 필요한 것
			같아요. 나와 연관됐던 사람들은 그 시기를 묻어 버렸거나 지워 버렸을 수 있는데, 다시 돌아가서 그걸 파헤쳐야 하는
			거잖아요. 그 자체가 큰 용기인 것 같아요. 그 여정이 너무 재미있더라고요.
		</div>

		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_215" value="/bookClick">
			<c:param name="id" value="215" />
			<c:param name="title" value="어둠 속에서 헤엄치기" />
			<c:param name="author" value="토마시 예드로프스키" />
			<c:param name="image"
				value="${contextPath}/img/celeb/hongkyung_book01.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000001744907" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/hongkyung01.png" alt="책 이미지 1">
		</div>

		<a href="${clickUrl_215}" class="book-card" data-book-id="215"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/hongkyung_book01.jpg" alt="어둠 속에서 헤엄치기"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">어둠 속에서 헤엄치기</div>
				<p class="book-meta">저자: 토마시 예드로프스키</p>
				<p class="book-meta">출판: 푸른숲</p>
				<p class="book-meta">발매: 2021.06.18</p>
				<p class="book-desc">우리가 읽은 것 중에 가장 놀라운 동시대의 퀴어 소설</p>
			</div>
		</a>

		<c:url var="clickUrl_216" value="/bookClick">
			<c:param name="id" value="216" />
			<c:param name="title" value="집을 순례하다" />
			<c:param name="author" value="나카무라 요시후미" />
			<c:param name="image"
				value="${contextPath}/img/celeb/hongkyung_book02.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000001519683" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/hongkyung02.png" alt="책 이미지 2">
		</div>

		<a href="${clickUrl_216}" class="book-card" data-book-id="216"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/hongkyung_book02.jpg" alt="집을 순례하다"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">집을 순례하다</div>
				<p class="book-meta">저자: 나카무라 요시후미</p>
				<p class="book-meta">출판: 사이</p>
				<p class="book-meta">발매: 2011.03.30</p>
				<p class="book-desc">20세기 건축의 거장 8명이 지은 9개의 ＜명작의 집＞ 순례기!</p>
			</div>
		</a>

		<c:url var="clickUrl_217" value="/bookClick">
			<c:param name="id" value="217" />
			<c:param name="title" value="아침의 피아노" />
			<c:param name="author" value="김진영" />
			<c:param name="image"
				value="${contextPath}/img/celeb/hongkyung_book03.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000216668744" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/hongkyung03.png" alt="책 이미지 3">
		</div>

		<a href="${clickUrl_217}" class="book-card" data-book-id="217"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/hongkyung_book03.jpg" alt="아침의 피아노"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">아침의 피아노</div>
				<p class="book-meta">저자: 김진영</p>
				<p class="book-meta">출판: 한겨레출판사</p>
				<p class="book-meta">발매: 2018.10.05</p>
				<p class="book-desc">철학자 김진영의 애도 일기</p>
			</div>
		</a>

		<c:url var="clickUrl_218" value="/bookClick">
			<c:param name="id" value="218" />
			<c:param name="title" value="예민함이라는 무기" />
			<c:param name="author" value="롤프 젤린" />
			<c:param name="image"
				value="${contextPath}/img/celeb/hongkyung_book04.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000001808222" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/hongkyung04.png" alt="책 이미지 4">
		</div>

		<a href="${clickUrl_218}" class="book-card" data-book-id="218"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/hongkyung_book04.jpg" alt="예민함이라는 무기"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">예민함이라는 무기</div>
				<p class="book-meta">저자: 롤프 젤린</p>
				<p class="book-meta">출판: 나무생각</p>
				<p class="book-meta">발매: 2018.07.18</p>
				<p class="book-desc">자극에 둔감해진 시대를 살아가는 우리에게 필요한</p>
			</div>
		</a>

		<c:url var="clickUrl_219" value="/bookClick">
			<c:param name="id" value="219" />
			<c:param name="title" value="일인칭 단수" />
			<c:param name="author" value="무라카미 하루키" />
			<c:param name="image"
				value="${contextPath}/img/celeb/hongkyung_book05.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000780790" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/hongkyung05.png" alt="책 이미지 5">
		</div>

		<a href="${clickUrl_219}" class="book-card" data-book-id="219"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/hongkyung_book05.jpg" alt="일인칭 단수"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">일인칭 단수</div>
				<p class="book-meta">저자: 무라카미 하루키</p>
				<p class="book-meta">출판: 문학동네</p>
				<p class="book-meta">발매: 2020.11.26</p>
				<p class="book-desc">‘나’라는 소우주를 탐색하는 여덟 갈래의 이야기</p>
			</div>
		</a>

		<c:url var="clickUrl_220" value="/bookClick">
			<c:param name="id" value="220" />
			<c:param name="title" value="여수의 사랑" />
			<c:param name="author" value="한강" />
			<c:param name="image"
				value="${contextPath}/img/celeb/hongkyung_book06.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000570387" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/hongkyung06.png" alt="책 이미지 6">
		</div>

		<a href="${clickUrl_220}" class="book-card" data-book-id="220"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/hongkyung_book06.jpg" alt="여수의 사랑"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">여수의 사랑</div>
				<p class="book-meta">저자: 한강</p>
				<p class="book-meta">출판: 문학과지성사</p>
				<p class="book-meta">발매: 2018.11.09</p>
				<p class="book-desc">오늘의 한강을 있게 한 어제의 한강을 읽다!</p>
			</div>
		</a>

		<button class="back-btn" onclick="history.back()">← 뒤로가기</button>
	</div>
	<button id="scrollToTopBtn">
		<img src="img/up1.png" alt="위로 가기 버튼" />
	</button>

	<footer>
		<div class="footer-container">
			<p>&copy; 2025 WITHUS. All rights reserved.</p>
			<div class="footer-links">
				<a href="#">이용약관</a> | <a href="#">개인정보처리방침</a> | <a href="#">고객센터</a>
			</div>
		</div>
	</footer>

	<script>
document.addEventListener('DOMContentLoaded', function () {
    const contextPath = '<%=contextPath%>';
    const isLoggedIn  = <%=loggedInUser != null%>;

    // 초기 북마크 상태 세팅
    const wishedBookIds = new Set([
        <c:forEach var="id" items="${wishedBookIds}" varStatus="s">
            ${id}<c:if test="${not s.last}">,</c:if>
        </c:forEach>
    ]);
    document.querySelectorAll('.bookmark-icon').forEach(icon => {
        const card = icon.closest('.book-card');
        if (card && wishedBookIds.has(+card.dataset.bookId)) {
            icon.classList.add('bookmarked');
        }
    });

    // 토글 기능: DELETE 대신 POST만 사용
    document.querySelectorAll('.bookmark-icon').forEach(icon => {
        icon.addEventListener('click', async e => {
        	
        	e.preventDefault();
            e.stopPropagation();
            if (!isLoggedIn) {
                alert('로그인이 필요한 기능입니다.');
                return window.location.href = contextPath + '/login.jsp';
            }
            const card   = icon.closest('.book-card');
            const bookId = card.dataset.bookId;

            try {
                // 항상 POST로 요청
                const res = await fetch(
                    contextPath + '/api/users/me/wishlists?bookId=' + encodeURIComponent(bookId),
                    { method: 'POST' }
                );
                if (!res.ok) throw new Error('서버 요청 실패');

                const { status } = await res.json();
                // status로 토글 처리
                if (status === 'added') {
                    icon.classList.add('bookmarked');
                } else { // 서버에서 "removed" 같은 상태를 내려준다 가정
                    icon.classList.remove('bookmarked');
                }
            } catch (err) {
                console.error('찜 처리 중 오류:', err);
                alert('요청 처리 중 오류가 발생했습니다.');
            }
        });
    });

    // 책 카드 클릭 리디렉션
    document.querySelectorAll('.book-card').forEach(card => {
        card.addEventListener('click', e => {
            if (e.target.classList.contains('bookmark-icon')) return;
            const link = card.dataset.link;
            if (link) window.open(link, '_blank');
        });
    });
});
</script>


</body>
</html>