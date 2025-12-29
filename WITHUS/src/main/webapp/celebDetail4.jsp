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
<title>페이커의 추천 책</title>
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
		<h1>페이커</h1>
		<p class="desc">페이커 대상혁이 추천하는 책</p>

		<div class="thumbnail-container">
			<img src="./img/celeb/faker_thum.jpg" alt="Celeb2 이미지" />
		</div>
		<div class="text-block">
			"끊임없이 발전할 부분을 찾고, 만들어가는 사람이라는 게 느껴진다. 그렇다면, 가장 크게 발전한 부분은 무엇인가."<br>
			<Br> 예전에는 좀 더 자기중심적이고, 뭐랄까. 숲을 보지 않고, 나무를 보는 그런 게 좀 있었다. 지금은 그런
			것들이 좀 많이 발전을 한 것 같다. 여러 방면에서 성장하기 위해 좀 더 많은 것을 수용하려고 하는 게, 가장 많이 바뀐
			부분이다. <br> 이렇게 바뀌게 된 가장 큰 요인은 독서다. 15년도 때 우연히 책 하나 접하면서 몇 번씩
			읽었는데, 그런 책들이 나를 더 수용적이고 개방적으로 바꿔줬고, 그런 변화 하나하나가 내 행동 양식에 큰 변화를 준 것
			같다. 그것도 내가 오랫동안 프로게이머를 하는데 있어서 많은 도움이 됐다.
		</div>
		<div class="text-block">
			"독서가 취미라는 건 너무 유명한 사실이다. 혹시 추천할 만한 책이 있나."<br> <Br> 최근에는
			뇌과학 책이나 심리학 쪽으로 많이 읽고 있는데, 이건 좀 매니악한 분야다. 그리고 과거에는 다 좀 딱딱한 책들을 많이 읽어서
			그것도 취향을 많이 탄다. 그래서 특정 책을 추천하는 건 어려울 것 같다. 내가 읽었던 책들은 팬분들이 많이 정리를
			해주셨다. 추천을 드리기보다는 그 중에 재미있어 보이는 거를 읽으시면 될 것 같다. 내가 읽었던 책들은 모두 나에게 도움이
			됐고, 별로였던 책은 없었다.
		</div>
		<div class="text-block">
			"책을 통해 위로받은 경험도 있을까."<br> <Br> 위로를 주는 책도 몇 권 읽었었는데, 그때 되게
			많이 도움이 됐다. 또, 책을 읽는다는 행위 자체가 사람 마음에 위안을 많이 주는 것 같다. 이건 과학적으로도 증명된 거긴
			하다. 가끔 책을 읽으면 스트레스가 굉장히 많이 줄어드는 느낌을 받는다.
		</div>

		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_185" value="/bookClick">
			<c:param name="id" value="185" />
			<c:param name="title" value="이기적 유전자" />
			<c:param name="author" value="리처드 도킨스" />
			<c:param name="image"
				value="${contextPath}/img/celeb/faker_book01.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000576524" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/faker01.png" alt="책 이미지 1">
		</div>

		<a href="${clickUrl_185}" class="book-card" data-book-id="185"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/faker_book01.jpg" alt="이기적 유전자"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">이기적 유전자</div>
				<p class="book-meta">저자: 리처드 도킨스</p>
				<p class="book-meta">출판: 을유문화사</p>
				<p class="book-meta">발매: 2023.01.30</p>
				<p class="book-desc">과학을 넘어선 우리 시대의 고전</p>
			</div>
		</a>

		<c:url var="clickUrl_186" value="/bookClick">
			<c:param name="id" value="186" />
			<c:param name="title" value="우리는 왜 잠을 자야 할까" />
			<c:param name="author" value="매슈 워커" />
			<c:param name="image"
				value="${contextPath}/img/celeb/faker_book02.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000582009" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/faker02.png" alt="책 이미지 2">
		</div>

		<a href="${clickUrl_186}" class="book-card" data-book-id="186"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/faker_book02.jpg" alt="우리는 왜 잠을 자야 할까"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">우리는 왜 잠을 자야 할까</div>
				<p class="book-meta">저자: 매슈 워커</p>
				<p class="book-meta">출판: 열린책들</p>
				<p class="book-meta">발매: 2019.02.25</p>
				<p class="book-desc">수면과 꿈의 과학</p>
			</div>
		</a>

		<c:url var="clickUrl_187" value="/bookClick">
			<c:param name="id" value="187" />
			<c:param name="title" value="내가 틀릴 수도 있습니다" />
			<c:param name="author" value="밀비욘 나티코 린데블라드" />
			<c:param name="image"
				value="${contextPath}/img/celeb/faker_book03.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000001687471" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/faker03.png" alt="책 이미지 3">
		</div>

		<a href="${clickUrl_187}" class="book-card" data-book-id="187"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/faker_book03.jpg" alt="내가 틀릴 수도 있습니다"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">내가 틀릴 수도 있습니다</div>
				<p class="book-meta">저자: 밀비욘 나티코 린데블라드</p>
				<p class="book-meta">출판: 다산초당</p>
				<p class="book-meta">발매: 2024.01.08</p>
				<p class="book-desc">전 세계가 사랑한 어느 다정한 승려의 삶과 지혜</p>
			</div>
		</a>

		<c:url var="clickUrl_188" value="/bookClick">
			<c:param name="id" value="188" />
			<c:param name="title" value="수도자처럼 생각하기" />
			<c:param name="author" value="제이 셰티" />
			<c:param name="image"
				value="${contextPath}/img/celeb/faker_book04.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000001687276" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/faker04.png" alt="책 이미지 4">
		</div>

		<a href="${clickUrl_188}" class="book-card" data-book-id="188"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/faker_book04.jpg" alt="수도자처럼 생각하기"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">수도자처럼 생각하기</div>
				<p class="book-meta">저자: 제이 셰티</p>
				<p class="book-meta">출판: 다산초당</p>
				<p class="book-meta">발매: 2024.08.14</p>
				<p class="book-desc">소진되고 지친 삶을 위한 고요함의 기술</p>
			</div>
		</a>


		<c:url var="clickUrl_189" value="/bookClick">
			<c:param name="id" value="189" />
			<c:param name="title" value="죽음의 수용소에서" />
			<c:param name="author" value="빅터 프랭클" />
			<c:param name="image"
				value="${contextPath}/img/celeb/faker_book05.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000616949" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/faker05.png" alt="책 이미지 5">
		</div>

		<a href="${clickUrl_189}" class="book-card" data-book-id="189"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/faker_book05.jpg" alt="죽음의 수용소에서"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">죽음의 수용소에서</div>
				<p class="book-meta">저자: 빅터 프랭클</p>
				<p class="book-meta">출판: 청아출판사</p>
				<p class="book-meta">발매: 2020.05.30</p>
				<p class="book-desc">죽음조차 희망으로 승화시킨 인간 존엄성의 승리</p>
			</div>
		</a>


		<c:url var="clickUrl_190" value="/bookClick">
			<c:param name="id" value="190" />
			<c:param name="title" value="사피엔스" />
			<c:param name="author" value="유발 하라리" />
			<c:param name="image"
				value="${contextPath}/img/celeb/faker_book06.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000597165" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/faker06.png" alt="책 이미지 6">
		</div>

		<a href="${clickUrl_190}" class="book-card" data-book-id="190"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/faker_book06.jpg" alt="사피엔스"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">사피엔스</div>
				<p class="book-meta">저자: 유발 하라리</p>
				<p class="book-meta">출판: 김영사</p>
				<p class="book-meta">발매: 2023.04.01</p>
				<p class="book-desc">인간의 역사와 미래에 대한 가장 논쟁적이고 대담한 대서사</p>
			</div>
		</a>


		<c:url var="clickUrl_191" value="/bookClick">
			<c:param name="id" value="191" />
			<c:param name="title" value="1Q84" />
			<c:param name="author" value="무라카미 하루키" />
			<c:param name="image"
				value="${contextPath}/img/celeb/faker_book07.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000777513" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/faker07.png" alt="책 이미지 7">
		</div>

		<a href="${clickUrl_191}" class="book-card" data-book-id="191"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/faker_book07.jpg" alt="1Q84"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">1Q84</div>
				<p class="book-meta">저자: 무라카미 하루키</p>
				<p class="book-meta">출판: 문학동네</p>
				<p class="book-meta">발매: 2009.08.25</p>
				<p class="book-desc">무라카미 하루키 문학의 결정판!</p>
			</div>
		</a>


		<c:url var="clickUrl_192" value="/bookClick">
			<c:param name="id" value="192" />
			<c:param name="title" value="월든" />
			<c:param name="author" value="헨리 데이빗 소로우" />
			<c:param name="image"
				value="${contextPath}/img/celeb/faker_book08.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000828212" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/faker08.png" alt="책 이미지 8">
		</div>

		<a href="${clickUrl_192}" class="book-card" data-book-id="192"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/faker_book08.jpg" alt="월든"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">월든</div>
				<p class="book-meta">저자: 헨리 데이빗 소로우</p>
				<p class="book-meta">출판: 은행나무</p>
				<p class="book-meta">발매: 2011.08.22</p>
				<p class="book-desc">대자연의 예찬과 문명사회에 대한 통렬한 비판이 담긴 불멸의 고전</p>
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