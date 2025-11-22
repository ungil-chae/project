<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
String contextPath = request.getContextPath();
%>
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
<title>박찬욱의 추천 책</title>
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
		<h1>박찬욱</h1>
		<p class="desc">"깐느박", "미장센의 제왕" 박찬욱 추천</p>

		<div class="thumbnail-container">
			<img src="./img/celeb/parkchanwook_thum.jpg" alt="Celeb1 이미지" />
		</div>

		<div class="text-block">"독서는 내 영화의 자양분이며, 문학은 영화를 만드는 힘의 원천이다."</div>
		<div class="text-block">
			"워낙 방대한 취향의 소유자이지만, 그중에서도 장르문학과 추리소설을 향한 애호가 남다른 것 같습니다. 애정의 근간은 무엇이라
			보세요?"<br> <br> 청소년 시기에 용돈을 아끼고 아껴서 동생(미디어 아티스트이자 영화감독 박찬경.
			박찬욱 감독과는 함께 팀 ‘PARKing CHANce’로 여러 편의 영화를 연출했다.)이랑 ‘동서추리문고’ 한 권씩 사
			모으는 게 삶의 낙이었어요. 머리도 빡빡 깎고, 일본식 교복을 입는 삭막한 군사주의 교육 환경에서 그게 유일하게 숨통을
			트이게 해 줬다고 할까요. 억압적이고 지루한 시대를 살다 보니 자극적이고 이국적인 것들에 끌리게 된 것 같아요. 뉴욕의
			뒷골목, 영국의 귀족이 사는 성, 우주 같은 공간에 매료돼 상상하는 것을 즐겼어요. 나는 여행도 별로 좋아하지 않는 사람이니
			직접 가 보고 싶다는 것과는 좀 다른 차원이었죠.
		</div>
		<div class="text-block">
			"책을 읽을 때 평소 이미지 연상을 잘하시는 편인가요? 『동조자』를 읽을 때 머릿속에 또렷한 이미지로 떠오른 대목이 있는지도
			궁금합니다."<br> <Br> 언어에 더 집중하는 편이지, 그걸 이미지로 바꿔 떠올리려 노력하지는 않는 것
			같네요. 다만 『동조자』의 경우에는 연출 제안을 받은 상태에서 읽었기 때문에 어쩔 수 없이 그렇게 되는 면이 있었죠.
			마지막에 ‘캡틴’ 이 보트를 타고 떠나면서 유령들을 보는 대목과, 무절제한 소령을 암살하는 장면만큼은 이미지를 꽤 구체적으로
			떠올렸던 것 같아요.
		</div>

		<%-- 최상단에 이미 선언되어 있다면 생략하세요 --%>

		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_163" value="/bookClick">
			<c:param name="id" value="163" />
			<c:param name="title" value="관촌수필" />
			<c:param name="author" value="이문구" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkchanwook_book01.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000570374" />
		</c:url>


		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkchanwook01.png" alt="책 이미지 1">
		</div>

		<!-- ★ 전체 카드를 <a> 로 감싸서, 제목·본문·이미지 어디를 눌러도 이동하도록 ★ -->
		<a href="${clickUrl_163}" class="book-card" data-book-id="163"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkchanwook_book01.jpg" alt="관촌수필"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">관촌수필</div>
				<p class="book-meta">저자: 이문구</p>
				<p class="book-meta">출판: 문학과지성사</p>
				<p class="book-meta">발매: 2018.09.03</p>
				<p class="book-desc">우리 문학 토양을 단단하고 풍요롭게 다져온 작품을 만나다.</p>
			</div>
		</a>





		<c:url var="clickUrl_164" value="/bookClick">
			<c:param name="id" value="164" />
			<c:param name="title" value="괴물들" />
			<c:param name="author" value="클레어 데더러" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkchanwook_book02.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000214356477" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkchanwook02.png" alt="책 이미지 2" />
		</div>

		<a href="${clickUrl_164}" class="book-card" data-book-id="164"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkchanwook_book02.jpg" alt="괴물들"
			class="book-cover-link" />
			<div class="book-info">
				<div class="book-title">괴물들</div>
				<p class="book-meta">저자: 클레어 데더러</p>
				<p class="book-meta">출판: 을유문화사</p>
				<p class="book-meta">발매: 2024.09.30</p>
				<p class="book-desc">위대한 걸작을 탄생시킨 괴물 예술가를 어떻게 마주할 것인가?</p>
			</div>
		</a>


		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_165" value="/bookClick">
			<c:param name="id" value="165" />
			<c:param name="title" value="브라이턴 록" />
			<c:param name="author" value="그레이엄 그린" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkchanwook_book03.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000001945339" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkchanwook03.png" alt="책 이미지 3">
		</div>

		<a href="${clickUrl_165}" class="book-card" data-book-id="165"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkchanwook_book03.jpg" alt="브라이턴 록"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">브라이턴 록</div>
				<p class="book-meta">저자: 그레이엄 그린</p>
				<p class="book-meta">출판: 현대문학</p>
				<p class="book-meta">발매: 2021.04.23</p>
				<p class="book-desc">악의 본성을 탐구한 걸작 미스터리</p>
			</div>
		</a>


		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_166" value="/bookClick">
			<c:param name="id" value="166" />
			<c:param name="title" value="오너러블 스쿨보이" />
			<c:param name="author" value="존 르카레" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkchanwook_book04.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000061448966" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkchanwook04.png" alt="책 이미지 4">
		</div>

		<a href="${clickUrl_166}" class="book-card" data-book-id="166"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkchanwook_book04.jpg"
			alt="오너러블 스쿨보이" class="book-cover-link">
			<div class="book-info">
				<div class="book-title">오너러블 스쿨보이</div>
				<p class="book-meta">저자: 존 르카레</p>
				<p class="book-meta">출판: 열린책들</p>
				<p class="book-meta">발매: 2022.07.20</p>
				<p class="book-desc">사상 최고 첩보 시리즈 카를라 3부작의 두 번째 작품 출간</p>
			</div>
		</a>


		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_167" value="/bookClick">
			<c:param name="id" value="167" />
			<c:param name="title" value="이민자들" />
			<c:param name="author" value="W. G. 제발트" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkchanwook_book05.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000612803" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkchanwook05.png" alt="책 이미지 5">
		</div>

		<a href="${clickUrl_167}" class="book-card" data-book-id="167"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkchanwook_book05.jpg" alt="이민자들"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">이민자들</div>
				<p class="book-meta">저자: W. G. 제발트</p>
				<p class="book-meta">출판: 창비</p>
				<p class="book-meta">발매: 2018.03.22</p>
				<p class="book-desc">제발트 탄생 75주년 기념 개정판 출간</p>
			</div>
		</a>

		<c:url var="clickUrl_168" value="/bookClick">
			<c:param name="id" value="168" />
			<c:param name="title" value="정확한 사랑의 실험" />
			<c:param name="author" value="신형철" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkchanwook_book06.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000938887" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkchanwook06.png" alt="책 이미지 6">
		</div>

		<a href="${clickUrl_168}" class="book-card" data-book-id="168"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkchanwook_book06.jpg"
			alt="정확한 사랑의 실험" class="book-cover-link">
			<div class="book-info">
				<div class="book-title">정확한 사랑의 실험</div>
				<p class="book-meta">저자: 신형철</p>
				<p class="book-meta">출판: 마음산책</p>
				<p class="book-meta">발매: 2014.10.01</p>
				<p class="book-desc">이야기 속에 숨어 있는 인간의 비밀을 ‘정확한 문장’으로 말한다!</p>
			</div>
		</a>

		<c:set var="contextPath" value="${pageContext.request.contextPath}" />

		<c:url var="clickUrl_169" value="/bookClick">
			<c:param name="id" value="169" />
			<c:param name="title" value="지속의 순간들" />
			<c:param name="author" value="제프 다이어" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkchanwook_book07.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000576590" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkchanwook07.png" alt="책 이미지 7">
		</div>

		<a href="${clickUrl_169}" class="book-card" data-book-id="169"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkchanwook_book07.jpg" alt="지속의 순간들"
			class="book-cover-link">
			<div class="book-info">
				<div class="book-title">지속의 순간들</div>
				<p class="book-meta">저자: 제프 다이어</p>
				<p class="book-meta">출판: 을유문화사</p>
				<p class="book-meta">발매: 2022.03.05</p>
				<p class="book-desc">사진을 찍지 않는 사진 비평가만의 새롭고 독특한 시선</p>
			</div>
		</a>

		<c:url var="clickUrl_170" value="/bookClick">
			<c:param name="id" value="170" />
			<c:param name="title" value="창백한 언덕 풍경" />
			<c:param name="author" value="가즈오 이시구로" />
			<c:param name="image"
				value="${contextPath}/img/celeb/parkchanwook_book08.jpg" />
			<c:param name="link"
				value="https://product.kyobobook.co.kr/detail/S000000621324" />
		</c:url>

		<div class="img-block">
			<img src="${contextPath}/img/celeb/parkchanwook08.png" alt="책 이미지 8">
		</div>

		<a href="${clickUrl_170}" class="book-card" data-book-id="170"
			target="_blank"> <i class="fas fa-bookmark bookmark-icon"></i> <img
			src="${contextPath}/img/celeb/parkchanwook_book08.jpg"
			alt="창백한 언덕 풍경" class="book-cover-link">
			<div class="book-info">
				<div class="book-title">창백한 언덕 풍경</div>
				<p class="book-meta">저자: 가즈오 이시구로</p>
				<p class="book-meta">출판: 민음사</p>
				<p class="book-meta">발매: 2012.11.30</p>
				<p class="book-desc">흐릿한 기억 속에서 재생되는 과거의 상처!</p>
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
