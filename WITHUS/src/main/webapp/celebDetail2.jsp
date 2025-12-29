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
<title>아이유의 추천 책</title>
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
		<h1>IU</h1>
		<p class="desc">아이유가 직접 읽고 팬들에게 추천한 책</p>

		<div class="thumbnail-container">
			<img src="./img/celeb/iu_thum.jpg" alt="Celeb2 이미지" />
		</div>

		<div class="text-block">"그 애는 꽃이 아닌 홀씨로 살기로 했다."</div>
		<div class="text-block">
			"책을 읽는 과정에서 자기성찰을 하고, 생각의 깊이도 깊어지는 것 같아요. 책 속에는 여러 가지 생각이 모여 있잖아요. 한
			구절을 읽으며 생각에 잠기고, 새로운 생각에 빠져들다 보면 나중에 음악을 하는 데에도 도움이 되는 것 같아요."<br>
		</div>
		<div class="text-block">
			"독서할 때 습관이 있나요?"<br> <Br> 저는 책의 마지막 문장부터 찾아 읽는 것을 좋아해요.
			그러고는 처음부터 책을 읽다가 다시 한 번 그 마지막 문장을 읽게 됐을 때 그 느낌이 상당히 오묘하답니다.
		</div>

		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_171" value="/bookClick">
			<c:param name="id" value="171" />
			<c:param name="title" value="제이콥의 방" />
			<c:param name="author" value="버지니아 울프" />
			<c:param name="image" value="${contextPath}/img/celeb/iu_book01.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000001789142" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/iu01.png" alt="책 이미지 1">
		</div>

		<a href="${clickUrl_171}" class="book-card" data-book-id="171"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/iu_book01.jpg" alt="제이콥의 방"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">제이콥의 방</div>
				<p class="book-meta">저자: 버지니아 울프</p>
				<p class="book-meta">출판: 솔</p>
				<p class="book-meta">발매: 2019.05.15</p>
				<p class="book-desc">버지니아 울프의 방대한 문학세계를 완성하다.</p>
			</div>
		</a>

		<c:url var="clickUrl_172" value="/bookClick">
			<c:param name="id" value="172" />
			<c:param name="title" value="최선의 삶" />
			<c:param name="author" value="임솔아" />
			<c:param name="image" value="${contextPath}/img/celeb/iu_book02.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000213561796" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/iu02.png" alt="책 이미지 2">
		</div>

		<a href="${clickUrl_172}" class="book-card" data-book-id="172"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/iu_book02.jpg" alt="최선의 삶"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">최선의 삶</div>
				<p class="book-meta">저자: 임솔아</p>
				<p class="book-meta">출판: 문학동네</p>
				<p class="book-meta">발매: 2024.06.14</p>
				<p class="book-desc">상처의 크기는 나이에 비례하지 않는다.</p>
			</div>
		</a>

		<c:url var="clickUrl_173" value="/bookClick">
			<c:param name="id" value="173" />
			<c:param name="title" value="참을 수 없는 존재의 가벼움" />
			<c:param name="author" value="밀란 쿤데라" />
			<c:param name="image" value="${contextPath}/img/celeb/iu_book03.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000619722" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/iu03.png" alt="책 이미지 3">
		</div>

		<a href="${clickUrl_173}" class="book-card" data-book-id="173"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/iu_book03.jpg" alt="참을 수 없는 존재의 가벼움"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">참을 수 없는 존재의 가벼움</div>
				<p class="book-meta">저자: 밀란 쿤데라</p>
				<p class="book-meta">출판: 민음사</p>
				<p class="book-meta">발매: 2018.06.20</p>
				<p class="book-desc">특별한 동시에 잊을 수 없는 어떤 사랑 이야기!</p>
			</div>
		</a>

		<c:url var="clickUrl_174" value="/bookClick">
			<c:param name="id" value="174" />
			<c:param name="title" value="왜 나는 너를 사랑하는가" />
			<c:param name="author" value="알랭 드 보통" />
			<c:param name="image" value="${contextPath}/img/celeb/iu_book04.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000200205332" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/iu04.png" alt="책 이미지 4">
		</div>

		<a href="${clickUrl_174}" class="book-card" data-book-id="174"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/iu_book04.jpg" alt="왜 나는 너를 사랑하는가"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">왜 나는 너를 사랑하는가</div>
				<p class="book-meta">저자: 알랭 드 보통</p>
				<p class="book-meta">출판: 창미래</p>
				<p class="book-meta">발매: 2022.11.10</p>
				<p class="book-desc">연애가 사랑이 되는 순간, 우연이 사랑이 되는 순간의 비밀</p>
			</div>
		</a>

		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_175" value="/bookClick">
			<c:param name="id" value="175" />
			<c:param name="title" value="인간 실격" />
			<c:param name="author" value="다자이 오사무" />
			<c:param name="image" value="${contextPath}/img/celeb/iu_book05.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000620240" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/iu05.png" alt="책 이미지 5">
		</div>

		<a href="${clickUrl_175}" class="book-card" data-book-id="175"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/iu_book05.jpg" alt="인간 실격"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">인간 실격</div>
				<p class="book-meta">저자: 다자이 오사무</p>
				<p class="book-meta">출판: 민음사</p>
				<p class="book-meta">발매: 2012.04.10</p>
				<p class="book-desc">청춘의 한 시기를 통과 의례처럼 거쳐야 하는 일본 데카당스 문학의 대표작</p>
			</div>
		</a>

		<c:url var="clickUrl_176" value="/bookClick">
			<c:param name="id" value="176" />
			<c:param name="title" value="희한한 위로" />
			<c:param name="author" value="강세형" />
			<c:param name="image" value="${contextPath}/img/celeb/iu_book06.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000001939518" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/iu06.png" alt="책 이미지 6">
		</div>

		<a href="${clickUrl_176}" class="book-card" data-book-id="176"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/iu_book06.jpg" alt="희한한 위로"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">희한한 위로</div>
				<p class="book-meta">저자: 강세형</p>
				<p class="book-meta">출판: 수오서재</p>
				<p class="book-meta">발매: 2020.07.20</p>
				<p class="book-desc">위로는 정말 그런 걸지도 모른다 엉뚱하고 희한한 곳에서 찾아오는 것</p>
			</div>
		</a>

		<c:url var="clickUrl_177" value="/bookClick">
			<c:param name="id" value="177" />
			<c:param name="title" value="슬픔의 위안" />
			<c:param name="author" value="론 마라스코, 브라이언 셔프" />
			<c:param name="image" value="${contextPath}/img/celeb/iu_book07.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000574960" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/iu07.png" alt="책 이미지 7">
		</div>

		<a href="${clickUrl_177}" class="book-card" data-book-id="177"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/iu_book07.jpg" alt="슬픔의 위안"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">슬픔의 위안</div>
				<p class="book-meta">저자: 론 마라스코, 브라이언 셔프</p>
				<p class="book-meta">출판: 현암사</p>
				<p class="book-meta">발매: 2019.03.15</p>
				<p class="book-desc">슬픔의 발생과 과정, 회복과 흔적을 어루만지는 따스한 성찰의 에세이</p>
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