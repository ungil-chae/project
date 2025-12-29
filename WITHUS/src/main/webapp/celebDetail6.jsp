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
<title>RM의 추천 책</title>
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
		<h1>RM</h1>
		<p class="desc">방탄소년단 RM이 추천하는 인생책</p>

		<div class="thumbnail-container">
			<img src="./img/celeb/rm_thum.jpg" alt="Celeb2 이미지" />
		</div>

		<div class="text-block">"서울에서는 책을 읽으려고 일부러 공원을 찾아다닌다. "</div>
		<div class="text-block">"리더의 무게는 무겁다. RM은 공식 석상이나 인터뷰에서 남다른 언변으로
			주목을 받아왔다. 그 비결은 독서에 있다. 그는 철학, 역사, 문학 등 다양한 분야의 책을 읽는 걸로 유명하다. 한
			인터뷰에서 말한 바로는 책을 통해 지식과 통찰을 넓히고 음악 작업에도 영향을 준다고 했다."</div>

		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_201" value="/bookClick">
			<c:param name="id" value="201" />
			<c:param name="title" value="블로노트" />
			<c:param name="author" value="타블로" />
			<c:param name="image" value="${contextPath}/img/celeb/rm_book01.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000001764060" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/rm01.png" alt="책 이미지 1">
		</div>

		<a href="${clickUrl_201}" class="book-card" data-book-id="201"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/rm_book01.jpg" alt="블로노트"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">블로노트</div>
				<p class="book-meta">저자: 타블로</p>
				<p class="book-meta">출판: 달</p>
				<p class="book-meta">발매: 2026.09.28</p>
				<p class="book-desc">매일 한 줄로 인생을 말하는 블로노트!</p>
			</div>
		</a>

		<c:url var="clickUrl_202" value="/bookClick">
			<c:param name="id" value="202" />
			<c:param name="title" value="한입 코끼리" />
			<c:param name="author" value="황경신" />
			<c:param name="image" value="${contextPath}/img/celeb/rm_book02.jpg" />
			<c:param name="link"
				value="https://ebook-product.kyobobook.co.kr/dig/epd/ebook/E000002994770" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/rm02.png" alt="책 이미지 2">
		</div>

		<a href="${clickUrl_202}" class="book-card" data-book-id="202"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/rm_book02.jpg" alt="한입 코끼리"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">한입 코끼리</div>
				<p class="book-meta">저자: 황경신</p>
				<p class="book-meta">출판: 큐리어스</p>
				<p class="book-meta">발매: 2014.11.20</p>
				<p class="book-desc">생에 대한 성찰이 돋보이는 황경신의 연작 소설!</p>
			</div>
		</a>

		<c:url var="clickUrl_203" value="/bookClick">
			<c:param name="id" value="203" />
			<c:param name="title" value="모순" />
			<c:param name="author" value="양귀자" />
			<c:param name="image" value="${contextPath}/img/celeb/rm_book03.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000001632467" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/rm03.png" alt="책 이미지 3">
		</div>

		<a href="${clickUrl_203}" class="book-card" data-book-id="203"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/rm_book03.jpg" alt="모순"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">모순</div>
				<p class="book-meta">저자: 양귀자</p>
				<p class="book-meta">출판: 쓰다</p>
				<p class="book-meta">발매: 2013.04.01</p>
				<p class="book-desc">인생은 살아가면서 탐구하는 것!</p>
			</div>
		</a>

		<c:url var="clickUrl_204" value="/bookClick">
			<c:param name="id" value="204" />
			<c:param name="title" value="해변의 카프카" />
			<c:param name="author" value="무라카미 하루키" />
			<c:param name="image" value="${contextPath}/img/celeb/rm_book04.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000213398973" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/rm04.png" alt="책 이미지 4">
		</div>

		<a href="${clickUrl_204}" class="book-card" data-book-id="204"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/rm_book04.jpg" alt="해변의 카프카"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">해변의 카프카</div>
				<p class="book-meta">저자: 무라카미 하루키</p>
				<p class="book-meta">출판: 문학사상</p>
				<p class="book-meta">발매: 2024.06.10</p>
				<p class="book-desc">묘한 고독감과 서정성으로 독자들의 시선을 사로잡는다.</p>
			</div>
		</a>

		<c:url var="clickUrl_205" value="/bookClick">
			<c:param name="id" value="205" />
			<c:param name="title" value="데미안" />
			<c:param name="author" value="헤르만 헤세" />
			<c:param name="image" value="${contextPath}/img/celeb/rm_book05.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000620240" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/rm05.png" alt="책 이미지 5">
		</div>

		<a href="${clickUrl_205}" class="book-card" data-book-id="205"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/rm_book05.jpg" alt="데미안"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">데미안</div>
				<p class="book-meta">저자: 헤르만 헤세</p>
				<p class="book-meta">출판: 민음사</p>
				<p class="book-meta">발매: 2009.01.20</p>
				<p class="book-desc">새는 알에서 나오려고 투쟁한다. 알은 세계이다. 태어나려는 자는 하나의 세계를
					깨뜨려야 한다.</p>
			</div>
		</a>

		<c:url var="clickUrl_206" value="/bookClick">
			<c:param name="id" value="206" />
			<c:param name="title" value="1984" />
			<c:param name="author" value="조지 오웰" />
			<c:param name="image" value="${contextPath}/img/celeb/rm_book06.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000620240" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/rm06.png" alt="책 이미지 6">
		</div>

		<a href="${clickUrl_206}" class="book-card" data-book-id="206"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/rm_book06.jpg" alt="1984"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">1984</div>
				<p class="book-meta">저자: 조지 오웰</p>
				<p class="book-meta">출판: 민음사</p>
				<p class="book-meta">발매: 2007.03.30</p>
				<p class="book-desc">세계가 나아갈 방향을 제시하는 탁월한 통찰</p>
			</div>
		</a>

		<c:url var="clickUrl_207" value="/bookClick">
			<c:param name="id" value="207" />
			<c:param name="title" value="지금 알고 있는 걸 그때도 알았더라면" />
			<c:param name="author" value="류시화" />
			<c:param name="image" value="${contextPath}/img/celeb/rm_book07.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000001079757" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/rm07.png" alt="책 이미지 7">
		</div>

		<a href="${clickUrl_207}" class="book-card" data-book-id="207"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/rm_book07.jpg"
			alt="지금 알고 있는 걸 그때도 알았더라면" class="book-cover-link">
			<div class="book-info">
				<div class="book-title">지금 알고 있는 걸 그때도 알았더라면</div>
				<p class="book-meta">저자: 류시화</p>
				<p class="book-meta">출판: 열림원</p>
				<p class="book-meta">발매: 2014.12.03</p>
				<p class="book-desc">지역과 시대를 뛰어넘은 고백록과 기도문을 엮은 잠언시집!</p>
			</div>
		</a>

		<c:url var="clickUrl_208" value="/bookClick">
			<c:param name="id" value="208" />
			<c:param name="title" value="언어의 무게" />
			<c:param name="author" value="파스칼 메르시어" />
			<c:param name="image" value="${contextPath}/img/celeb/rm_book08.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000201368764" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/rm08.png" alt="책 이미지 8">
		</div>

		<a href="${clickUrl_208}" class="book-card" data-book-id="208"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/rm_book08.jpg" alt="언어의 무게"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">언어의 무게</div>
				<p class="book-meta">저자: 파스칼 메르시어</p>
				<p class="book-meta">출판: 비채</p>
				<p class="book-meta">발매: 2023.04.03</p>
				<p class="book-desc">《리스본행 야간열차》 이후 16년 만의 신작 장편소설</p>
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