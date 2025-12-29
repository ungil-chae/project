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
<title>문상훈의 추천 책</title>
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
		<h1>문상훈</h1>
		<p class="desc">빠더너스 문상훈이 사랑한 시집들</p>

		<div class="thumbnail-container">
			<img src="./img/celeb/munsanghoon_thum.jpg" alt="Celeb3 이미지" />
		</div>

		<div class="text-block">"내가 한 말을 내가 오해하지 않기로 함"</div>
		<div class="text-block">
			"일기장을 덮어놓고 천장을 보면서 아무도 보고 있지 않다는 외로움에 대해 생각한다. 기분도 남 눈치 보면서 들고 생각도 다른
			사람 허락받고 한다니. 취향과 호오의 기준이 내게 없고 내가 좋아하는 것이 정말 좋은 건지 자꾸 다른 사람에게 물어보게
			된다. 나는 뭐 하나 하려고 해도 늘 누가 옆에서 지켜봐 주어야 한다. 혼자서는 아무것도 할 수 없다는 것이 문득 외롭다."<br>
		</div>
		<div class="text-block">"시인은 술도 밥도 그냥 먹지 않고 비도 허투루 맞지 않는다. 시인은
			사람들이 피하는 눈과 비와 해풍도 동해 오징어처럼 처절하게 얼리고 녹이고 말리는 데 쓴다. 글씨 쓸 줄 알면 글도 써지는 줄
			아는 사람들 사이에서 한글로 시를 쓴다는 것은 앞이 보이지 않는 사람에게 검은색을 설명하는 일. 검은색도 빛을 본 적이 있는
			사람들의 표현이고 검은색은 반사해낼 빛도 없는데 시인은 설명을 포기하지 않는다.</div>

		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_178" value="/bookClick">
			<c:param name="id" value="178" />
			<c:param name="title" value="최선은 그런 것이에요" />
			<c:param name="author" value="이규리" />
			<c:param name="image"
				value="${contextPath}/img/celeb/munsanghoon_book01.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000778987" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/munsanghoon01.png" alt="책 이미지 1">
		</div>

		<a href="${clickUrl_178}" class="book-card" data-book-id="178"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/munsanghoon_book01.jpg"
			alt="최선은 그런 것이에요" class="book-cover-link">
			<div class="book-info">
				<div class="book-title">최선은 그런 것이에요</div>
				<p class="book-meta">저자: 이규리</p>
				<p class="book-meta">출판: 문학동네</p>
				<p class="book-meta">발매: 2014.05.10</p>
				<p class="book-desc">지상의 존재들이 빚어내는 삶의 비의에 응답하는 따뜻한 시선</p>
			</div>
		</a>

		<c:url var="clickUrl_179" value="/bookClick">
			<c:param name="id" value="179" />
			<c:param name="title" value="서른, 잔치는 끝났다" />
			<c:param name="author" value="최영미" />
			<c:param name="image"
				value="${contextPath}/img/celeb/munsanghoon_book02.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000001979711" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/munsanghoon02.png" alt="책 이미지 2">
		</div>

		<a href="${clickUrl_179}" class="book-card" data-book-id="179"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/munsanghoon_book02.jpg"
			alt="서른, 잔치는 끝났다" class="book-cover-link">
			<div class="book-info">
				<div class="book-title">서른, 잔치는 끝났다</div>
				<p class="book-meta">저자: 최영미</p>
				<p class="book-meta">출판: 이미</p>
				<p class="book-meta">발매: 2020.09.15</p>
				<p class="book-desc">시대의 아픔과 상처를 위로하는 사랑</p>
			</div>
		</a>

		<c:url var="clickUrl_180" value="/bookClick">
			<c:param name="id" value="180" />
			<c:param name="title" value="황금빛 모서리" />
			<c:param name="author" value="김중식" />
			<c:param name="image"
				value="${contextPath}/img/celeb/munsanghoon_book03.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000568234" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/munsanghoon03.png" alt="책 이미지 3">
		</div>

		<a href="${clickUrl_180}" class="book-card" data-book-id="180"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/munsanghoon_book03.jpg" alt="황금빛 모서리"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">황금빛 모서리</div>
				<p class="book-meta">저자: 김중식</p>
				<p class="book-meta">출판: 문학과지성사</p>
				<p class="book-meta">발매: 1993.05.01</p>
				<p class="book-desc">짧은 글귀 안에 담긴 심오한 뜻.</p>
			</div>
		</a>


		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_181" value="/bookClick">
			<c:param name="id" value="181" />
			<c:param name="title" value="바다는 잘 있습니다" />
			<c:param name="author" value="이병률" />
			<c:param name="image"
				value="${contextPath}/img/celeb/munsanghoon_book04.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000570297" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/munsanghoon04.png" alt="책 이미지 4">
		</div>

		<a href="${clickUrl_181}" class="book-card" data-book-id="181"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/munsanghoon_book04.jpg"
			alt="바다는 잘 있습니다" class="book-cover-link">
			<div class="book-info">
				<div class="book-title">바다는 잘 있습니다</div>
				<p class="book-meta">저자: 이병률</p>
				<p class="book-meta">출판: 문학과지성사</p>
				<p class="book-meta">발매: 2017.09.20</p>
				<p class="book-desc">숱한 낙담 끝에 오는 다짐들,그럴 수밖에 없는 최종의 마음들</p>
			</div>
		</a>

		<c:url var="clickUrl_182" value="/bookClick">
			<c:param name="id" value="182" />
			<c:param name="title" value="그 여름의 끝" />
			<c:param name="author" value="이성복" />
			<c:param name="image"
				value="${contextPath}/img/celeb/munsanghoon_book05.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000568113" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/munsanghoon05.png" alt="책 이미지 5">
		</div>

		<a href="${clickUrl_182}" class="book-card" data-book-id="182"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/munsanghoon_book05.jpg" alt="그 여름의 끝"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">그 여름의 끝</div>
				<p class="book-meta">저자: 이성복</p>
				<p class="book-meta">출판: 문학과지성사</p>
				<p class="book-meta">발매: 1990.06.01</p>
				<p class="book-desc">나와 타자에 대한 진정성의 사랑</p>
			</div>
		</a>

		<c:url var="clickUrl_183" value="/bookClick">
			<c:param name="id" value="183" />
			<c:param name="title" value="수학자의 아침" />
			<c:param name="author" value="김소연" />
			<c:param name="image"
				value="${contextPath}/img/celeb/munsanghoon_book06.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000569961" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/munsanghoon06.png" alt="책 이미지 6">
		</div>

		<a href="${clickUrl_183}" class="book-card" data-book-id="183"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/munsanghoon_book06.jpg" alt="수학자의 아침"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">수학자의 아침</div>
				<p class="book-meta">저자: 김소연</p>
				<p class="book-meta">출판: 문학과지성사</p>
				<p class="book-meta">발매: 2013.11.11</p>
				<p class="book-desc">정지한 사물들의 고요한 그림자를 둘러보는 시간</p>
			</div>
		</a>

		<c:url var="clickUrl_184" value="/bookClick">
			<c:param name="id" value="184" />
			<c:param name="title" value="지금 여기가 맨 앞" />
			<c:param name="author" value="이문재" />
			<c:param name="image"
				value="${contextPath}/img/celeb/munsanghoon_book07.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000778919" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/munsanghoon07.png" alt="책 이미지 7">
		</div>

		<a href="${clickUrl_184}" class="book-card" data-book-id="184"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/munsanghoon_book07.jpg"
			alt="지금 여기가 맨 앞" class="book-cover-link">
			<div class="book-info">
				<div class="book-title">지금 여기가 맨 앞</div>
				<p class="book-meta">저자: 이문재</p>
				<p class="book-meta">출판: 문학동네</p>
				<p class="book-meta">발매: 2014.05.20</p>
				<p class="book-desc">기도하듯 주문 외듯 신탁을 전하듯 씌어진 잠언 지향의 시편들</p>
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