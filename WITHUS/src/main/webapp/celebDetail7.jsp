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
<title>한강의 추천 책</title>
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
		<h1>한강</h1>
		<p class="desc">노벨문학상 한강 작가의 책장</p>

		<div class="thumbnail-container">
			<img src="./img/celeb/hankang_thum.jpg" alt="Celeb2 이미지" />
		</div>

		<div class="text-block">"문학이라는 것은 끊임없이 타인의 내면으로 들어가고 그런 과정에서 자신의
			내면을 깊게 파고 들어가는 행위이기 때문에 계속해서 그런 행위들을 반복하면서 내적인 힘이 생기게 되죠. 그래서 어떤 갑작스런
			상황이 왔을 때, 스스로 판단하고 생각하고 최선을 다해서 결정할 수 있는 힘이 생길 수 있다고 생각합니다. 문학은 여분의
			것이 아니라 꼭 필요한 것이라고 생각합니다.ㅣ"</div>
		<div class="text-block">"모든 독자가 작가는 아니지만, 모든 작가는 독자입니다. 좋은 독자들이
			깊게 읽고 흥미롭게 읽는 독자들이 많이 나오는 것이 가장 좋을 거라고 생각합니다."</div>
		<div class="text-block">"때로는 희망이 있나 생각을 할 때도 있습니다. 하지만 희망이 있을
			거라고 희망하는 것도 희망이라고 부를 수 있지 않나 생각합니다."</div>

		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_209" value="/bookClick">
			<c:param name="id" value="209" />
			<c:param name="title" value="이별 없는 세대" />
			<c:param name="author" value="볼프강 보르헤르트" />
			<c:param name="image"
				value="${contextPath}/img/celeb/hankang_book01.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000570406" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/hankang01.png" alt="책 이미지 1">
		</div>

		<a href="${clickUrl_209}" class="book-card" data-book-id="209"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/hankang_book01.jpg" alt="이별 없는 세대"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">이별 없는 세대</div>
				<p class="book-meta">저자: 볼프강 보르헤르트</p>
				<p class="book-meta">출판: 문학과지성사</p>
				<p class="book-meta">발매: 2018.11.05</p>
				<p class="book-desc">버지니아 울프의 방대한 문학세계를 완성하다.</p>
			</div>
		</a>

		<c:url var="clickUrl_210" value="/bookClick">
			<c:param name="id" value="210" />
			<c:param name="title" value="카라마조프가의 형제들" />
			<c:param name="author" value="표도르 도스토옙스키" />
			<c:param name="image"
				value="${contextPath}/img/celeb/hankang_book02.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000620291" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/hankang02.png" alt="책 이미지 2">
		</div>

		<a href="${clickUrl_210}" class="book-card" data-book-id="210"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/hankang_book02.jpg" alt="카라마조프가의 형제들"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">카라마조프가의 형제들</div>
				<p class="book-meta">저자: 표도르 도스토옙스키</p>
				<p class="book-meta">출판: 민음사</p>
				<p class="book-meta">발매: 2007.09.20</p>
				<p class="book-desc">도스토예프스키가 남긴 마지막 작품이자 최고의 작품!</p>
			</div>
		</a>

		<c:url var="clickUrl_211" value="/bookClick">
			<c:param name="id" value="211" />
			<c:param name="title" value="케테 콜비츠" />
			<c:param name="author" value="카테리네 크라머" />
			<c:param name="image"
				value="${contextPath}/img/celeb/hankang_book03.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000210455283" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/hankang03.png" alt="책 이미지 3">
		</div>

		<a href="${clickUrl_211}" class="book-card" data-book-id="211"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/hankang_book03.jpg" alt="케테 콜비츠"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">케테 콜비츠</div>
				<p class="book-meta">저자: 카테리네 크라머</p>
				<p class="book-meta">출판: 이온서가</p>
				<p class="book-meta">발매: 2023.10.07</p>
				<p class="book-desc">슬픔을 구출하는 예술</p>
			</div>
		</a>

		<c:url var="clickUrl_212" value="/bookClick">
			<c:param name="id" value="212" />
			<c:param name="title" value="어느 시인의 죽음" />
			<c:param name="author" value="보리스 파스테르나크" />
			<c:param name="image"
				value="${contextPath}/img/celeb/hankang_book04.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000001128430" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/hankang04.png" alt="책 이미지 4">
		</div>

		<a href="${clickUrl_212}" class="book-card" data-book-id="212"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/hankang_book04.jpg" alt="어느 시인의 죽음"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">어느 시인의 죽음</div>
				<p class="book-meta">저자: 보리스 파스테르나크</p>
				<p class="book-meta">출판: 까치</p>
				<p class="book-meta">발매: 2011.05.25</p>
				<p class="book-desc">영적 교감의 기록이자 내면을 향한 끝없는 여로의 기록</p>
			</div>
		</a>

		<c:url var="clickUrl_213" value="/bookClick">
			<c:param name="id" value="213" />
			<c:param name="title" value="아버지의 땅" />
			<c:param name="author" value="임철우" />
			<c:param name="image"
				value="${contextPath}/img/celeb/hankang_book05.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000570377" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/hankang05.png" alt="책 이미지 5">
		</div>

		<a href="${clickUrl_213}" class="book-card" data-book-id="213"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/hankang_book05.jpg" alt="아버지의 땅"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">아버지의 땅</div>
				<p class="book-meta">저자: 임철우</p>
				<p class="book-meta">출판: 문학과지성사</p>
				<p class="book-meta">발매: 2018.09.03</p>
				<p class="book-desc">우리 문학 토양을 단단하고 풍요롭게 다져온 작품을 만나다!</p>
			</div>
		</a>

		<c:url var="clickUrl_214" value="/bookClick">
			<c:param name="id" value="214" />
			<c:param name="title" value="사자왕 형제의 모험" />
			<c:param name="author" value="아스트리드 린드그렌" />
			<c:param name="image"
				value="${contextPath}/img/celeb/hankang_book06.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000611315" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/hankang06.png" alt="책 이미지 6">
		</div>

		<a href="${clickUrl_214}" class="book-card" data-book-id="214"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/hankang_book06.jpg" alt="사자왕 형제의 모험"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">사자왕 형제의 모험</div>
				<p class="book-meta">저자: 아스트리드 린드그렌</p>
				<p class="book-meta">출판: 창비</p>
				<p class="book-meta">발매: 2015.07.10</p>
				<p class="book-desc">삶과 문학의 영원한 화두에 관해 이야기하는 고전</p>
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
