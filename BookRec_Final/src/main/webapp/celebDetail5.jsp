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
<title>박정민의 추천 책</title>
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
		<h1>박정민</h1>
		<p class="desc">출판사 '무제'대표 박정민의 책장</p>

		<div class="thumbnail-container">
			<img src="./img/celeb/parkjungmin_thum.jpg" alt="Celeb2 이미지" />
		</div>

		<div class="text-block">"작가는 아니다. 글씨만 쓸줄 아는 그저 평범한 당신의 옆집 남자. 가끔
			텔레비전이나 영화에 나오기도 한다."</div>
		<div class="text-block">"언젠가는 나도 각도 큰 변화구를 던져볼 수 있을 거다. 여러분도 적절히
			변화구도 섞어가면서 살아가시길 바란다."</div>
		<div class="text-block">"원래 사람들은 바쁘거나 노는 게 더 좋아서 책을 안 읽잖아요. 그러니까
			책 읽기 캠페인 같은 걸 하겠죠. 책을 만드는 건, 뭘 좀 재밌게 만들어보고 싶은데 제가 책을 좋아하고 (책을 만드는 데)
			돈이 덜 들잖아요. 영화는 혼자 만들 수 없으니까요. 책으로 돈을 벌려는 게 아니라 오히려 돈을 더 써서, 예술적이고
			고급스런 물성을 갖게 하려는 게 지향점이에요."</div>

		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_193" value="/bookClick">
			<c:param name="id" value="193" />
			<c:param name="title" value="사물의 뒷모습" />
			<c:param name="author" value="안규철" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkjungmin_book01.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000001945337" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkjungmin01.png" alt="책 이미지 1">
		</div>

		<a href="${clickUrl_193}" class="book-card" data-book-id="193"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkjungmin_book01.jpg" alt="사물의 뒷모습"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">사물의 뒷모습</div>
				<p class="book-meta">저자: 안규철</p>
				<p class="book-meta">출판: 현대문학</p>
				<p class="book-meta">발매: 2021.03.19</p>
				<p class="book-desc">안규철의 내 이야기로 그린 그림, 그 두 번째 이야기</p>
			</div>
		</a>

		<c:url var="clickUrl_194" value="/bookClick">
			<c:param name="id" value="194" />
			<c:param name="title" value="사유 속의 영화" />
			<c:param name="author" value="이윤영" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkjungmin_book02.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000569720" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkjungmin02.png" alt="책 이미지 2">
		</div>

		<a href="${clickUrl_194}" class="book-card" data-book-id="194"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkjungmin_book02.jpg" alt="사유 속의 영화"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">사유 속의 영화</div>
				<p class="book-meta">저자: 이윤영</p>
				<p class="book-meta">출판: 문학과지성사</p>
				<p class="book-meta">발매: 2011.04.18</p>
				<p class="book-desc">영화 이론 선집 |</p>
			</div>
		</a>

		<c:url var="clickUrl_195" value="/bookClick">
			<c:param name="id" value="195" />
			<c:param name="title" value="아침 그리고 저녁" />
			<c:param name="author" value="욘 포세라" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkjungmin_book03.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000780415" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkjungmin03.png" alt="책 이미지 3">
		</div>

		<a href="${clickUrl_195}" class="book-card" data-book-id="195"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkjungmin_book03.jpg" alt="아침 그리고 저녁"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">아침 그리고 저녁</div>
				<p class="book-meta">저자: 욘 포세라</p>
				<p class="book-meta">출판: 문학동네</p>
				<p class="book-meta">발매: 2019.07.26</p>
				<p class="book-desc">시적이고 음악적인 문체로 묘파하는 인간의 삶과 생존투쟁, 그리고 죽음</p>
			</div>
		</a>

		<c:url var="clickUrl_196" value="/bookClick">
			<c:param name="id" value="196" />
			<c:param name="title" value="나는 나를 파괴할 권리가 있다" />
			<c:param name="author" value="김영하" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkjungmin_book04.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000061353843" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkjungmin04.png" alt="책 이미지 4">
		</div>

		<a href="${clickUrl_196}" class="book-card" data-book-id="196"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkjungmin_book04.jpg"
			alt="나는 나를 파괴할 권리가 있다" class="book-cover-link">
			<div class="book-info">
				<div class="book-title">나는 나를 파괴할 권리가 있다</div>
				<p class="book-meta">저자: 김영하</p>
				<p class="book-meta">출판: 복복서가</p>
				<p class="book-meta">발매: 2022.05.23</p>
				<p class="book-desc">『나는 나를 파괴할 권리가 있다』 개정판</p>
			</div>
		</a>

		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_197" value="/bookClick">
			<c:param name="id" value="197" />
			<c:param name="title" value="혼모노" />
			<c:param name="author" value="성해나" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkjungmin_book05.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000216111714" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkjungmin05.png" alt="책 이미지 5">
		</div>

		<a href="${clickUrl_197}" class="book-card" data-book-id="197"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkjungmin_book05.jpg" alt="혼모노"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">혼모노</div>
				<p class="book-meta">저자: 성해나</p>
				<p class="book-meta">출판: 창비</p>
				<p class="book-meta">발매: 2025.03.28</p>
				<p class="book-desc">무엇이 진짜이고 무엇이 가짜인가 그 경계에서 ‘혼모노’를 묻다</p>
			</div>
		</a>

		<c:url var="clickUrl_198" value="/bookClick">
			<c:param name="id" value="198" />
			<c:param name="title" value="죽은 왕녀를 위한 파반느" />
			<c:param name="author" value="박민규" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkjungmin_book06.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000887679" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkjungmin06.png" alt="책 이미지 6">
		</div>

		<a href="${clickUrl_198}" class="book-card" data-book-id="198"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkjungmin_book06.jpg"
			alt="죽은 왕녀를 위한 파반느" class="book-cover-link">
			<div class="book-info">
				<div class="book-title">죽은 왕녀를 위한 파반느</div>
				<p class="book-meta">저자: 박민규</p>
				<p class="book-meta">출판: 위즈덤하우스</p>
				<p class="book-meta">발매: 2009.07.20</p>
				<p class="book-desc">더욱 섬세하고 예리해진 무규칙이종소설가의 리얼 로맨틱 귀환!</p>
			</div>
		</a>

		<c:url var="clickUrl_199" value="/bookClick">
			<c:param name="id" value="199" />
			<c:param name="title" value="웬만해선 아무렇지 않다" />
			<c:param name="author" value="이기호" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkjungmin_book07.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000938918" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkjungmin07.png" alt="책 이미지 7">
		</div>

		<a href="${clickUrl_199}" class="book-card" data-book-id="199"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkjungmin_book07.jpg"
			alt="웬만해선 아무렇지 않다" class="book-cover-link">
			<div class="book-info">
				<div class="book-title">웬만해선 아무렇지 않다</div>
				<p class="book-meta">저자: 이기호</p>
				<p class="book-meta">출판: 마음산책</p>
				<p class="book-meta">발매: 2016.02.25</p>
				<p class="book-desc">웃음과 눈물의 절묘함 특별한 짧은 소설</p>
			</div>
		</a> <
		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_200" value="/bookClick">
			<c:param name="id" value="200" />
			<c:param name="title" value="음악소설집" />
			<c:param name="author" value="김애란 , 김연수 , 윤성희 , 은희경 , 편혜영" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkjungmin_book08.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000213662853" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkjungmin08.png" alt="책 이미지 8">
		</div>

		<a href="${clickUrl_200}" class="book-card" data-book-id="200"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkjungmin_book08.jpg" alt="음악소설집"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">음악소설집</div>
				<p class="book-meta">저자: 김애란 , 김연수 , 윤성희 , 은희경 , 편혜영</p>
				<p class="book-meta">출판: 프란츠</p>
				<p class="book-meta">발매: 2024.07.01</p>
				<p class="book-desc">우리 삶의 장면 속엔 늘 음악이 있었다</p>
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