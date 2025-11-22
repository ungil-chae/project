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
<%-- 외부 CSS 파일 링크 --%>
<%@ include file="css/main_css.jsp"%>
<%-- main_css를 include --%>
<link rel="icon" href="img/icon2.png" type="image/x-icon">
<head>
<meta charset="UTF-8">
<title>셀럽 추천 리스트</title>
<style>
/* 기존 celebList.css에 정의된 스타일이 여기에 복사되지 않도록 주의하세요. */
/* 아래 스타일은 celebList.css에 추가되거나, 해당 파일에서 정의되어 있어야 합니다. */

/* === 새로 추가될 또는 확인해야 할 CSS === */
.action-buttons {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	margin-bottom: 20px;
}

.action-buttons button, .action-buttons a {
	padding: 10px 16px;
	background-color: #e6f0d7;
	color: black;
	text-decoration: none;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	font-weight: bold;
	transition: background-color 0.2s ease;
}

.action-buttons button:hover, .action-buttons a:hover {
	background-color: #cce0b8;
}

/* 개별 카드 내 삭제 버튼 스타일 */
.card-actions {
	position: absolute; /* .celeb-card-container 내에서 절대 위치 */
	top: 10px;
	right: 10px;
	z-index: 10; /* 다른 요소 위에 표시 */
	/* ⭐ 기본적으로 숨김 ⭐ */
	opacity: 0;
	visibility: hidden;
	transition: opacity 0.3s ease, visibility 0.3s ease;
}

.card-actions .delete-btn {
	background-color: rgba(255, 0, 0, 0.7); /* 빨간색 배경 */
	color: white;
	border: none;
	border-radius: 5px;
	padding: 5px 8px;
	font-size: 0.8em;
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.card-actions .delete-btn:hover {
	background-color: rgba(255, 0, 0, 0.9);
}

/* ⭐ '선택 삭제' 모드일 때 개별 삭제 버튼 표시 ⭐ */
body.delete-mode-active .card-actions {
	opacity: 1;
	visibility: visible;
}

/* --- 이미지/카드 크기 문제 해결을 위한 CSS (이전에 제안했던 부분, 필요하다면 celebList.css에 반영) --- */
.celeb-card-container { /* 각 셀럽 카드를 감싸는 div (position:relative를 가짐) */
	position: relative;
	background-color: #fcfcfc;
	border: 1px solid #e0e0e0;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
	display: flex;
	flex-direction: column;
	transition: transform 0.2s ease-in-out;
	/* cursor: pointer; */ /* 링크가 있으므로 컨테이너 커서는 제거 */

	/* --- 이미지/카드 크기 문제 해결을 위함 (이전 제안) --- */
	/* height: 350px; */ /* 모든 카드의 높이를 고정 (필요 시 주석 해제하여 사용) */
}

.celeb-card-container:hover {
	transform: translateY(-5px);
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

/* 실제 링크가 되는 카드 부분 */
.card { /* 이전에는 a.card였는데 이제 div.celeb-card-container 안의 a.card가 됨 */
	text-decoration: none; /* 링크 밑줄 제거 */
	color: inherit; /* 텍스트 색상 상속 */
	display: flex; /* 내부 요소 세로 정렬 */
	flex-direction: column;
	flex-grow: 1; /* 남은 공간 채우기 */
	cursor: pointer; /* 링크에 포인터 커서 */
}

/* 이미지 스타일 */
.card img {
	width: 100%; /* 부모 너비에 꽉 채움 */
	height: 280px; /* 이미지 높이 고정 (필요 시) */
	object-fit: cover; /* 이미지가 잘리더라도 비율 유지하며 컨테이너 채움 */
	border-bottom: 1px solid #eee;
}

/* 카드 내용 부분 */
.card-content {
	padding: 15px;
	text-align: left;
	flex-grow: 1;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
}

.card-title {
	font-size: 1.2em;
	font-weight: bold;
	color: #444;
	margin-bottom: 8px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.card-desc {
	font-size: 0.9em;
	color: #666;
	line-height: 1.4;
	overflow: hidden;
	text-overflow: ellipsis;
	display: -webkit-box;
	-webkit-line-clamp: 3; /* 텍스트 3줄 초과 시 ... */
	-webkit-box-orient: vertical;
}

/* 그리드 레이아웃 */
.grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
	gap: 20px;
	justify-content: center;
	padding: 20px 0;
}

.bookmark-icon {
	position: absolute;
	top: 12px;
	right: 12px;
	font-size: 1.2rem;
	color: rgba(255, 255, 255, 0.5);
	padding: 6px;
	border-radius: 50%;
	transition: color 0.2s ease;
}

.bookmark-icon:hover {
	color: #fff;
}
</style>

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
		<div class="grid">
			<!-- 박찬욱 (id=1) -->
			<div class="celeb-card-container" data-celeb-id="1">
				<i
					class="fas fa-bookmark bookmark-icon master-bookmark ${celebList[0].isFullyBookmarked ? 'bookmarked' : ''}"></i>
				<div class="card-actions">
					<button class="delete-btn">삭제</button>
				</div>
				<a class="card"
					href="${pageContext.request.contextPath}/celebDetail?id=1"> <img
					src="./img/celeb/parkchanwook_thum.jpg" alt="박찬욱 이미지" />
					<div class="card-content">
						<div class="card-title">박찬욱</div>
						<div class="card-desc">"깐느박", "미장센의 제왕" 박찬욱 추천</div>
					</div>
				</a>
			</div>
			<!-- 아이유 (id=2) -->
			<div class="celeb-card-container" data-celeb-id="2">
				<i
					class="fas fa-bookmark bookmark-icon master-bookmark ${celebList[1].isFullyBookmarked ? 'bookmarked' : ''}"></i>
				<div class="card-actions">
					<button class="delete-btn">삭제</button>
				</div>
				<a class="card"
					href="${pageContext.request.contextPath}/celebDetail?id=2"> <img
					src="./img/celeb/iu_thum.jpg" alt="아이유 이미지" />
					<div class="card-content">
						<div class="card-title">아이유</div>
						<div class="card-desc">아이유가 직접 읽고 팬들에게 추천한 책</div>
					</div>
				</a>
			</div>
			<!-- 문상훈 (id=3) -->
			<div class="celeb-card-container" data-celeb-id="3">
				<i
					class="fas fa-bookmark bookmark-icon master-bookmark ${celebList[2].isFullyBookmarked ? 'bookmarked' : ''}"></i>
				<div class="card-actions">
					<button class="delete-btn">삭제</button>
				</div>
				<a class="card"
					href="${pageContext.request.contextPath}/celebDetail?id=3"> <img
					src="./img/celeb/munsanghoon_thum.jpg" alt="문상훈 이미지" />
					<div class="card-content">
						<div class="card-title">문상훈</div>
						<div class="card-desc">빠더너스 문상훈이 사랑한 시집들</div>
					</div>
				</a>
			</div>
			<!-- 페이커 (id=4) -->
			<div class="celeb-card-container" data-celeb-id="4">
				<i
					class="fas fa-bookmark bookmark-icon master-bookmark ${celebList[3].isFullyBookmarked ? 'bookmarked' : ''}"></i>
				<div class="card-actions">
					<button class="delete-btn">삭제</button>
				</div>
				<a class="card"
					href="${pageContext.request.contextPath}/celebDetail?id=4"> <img
					src="./img/celeb/faker_thum.jpg" alt="페이커 이미지" />
					<div class="card-content">
						<div class="card-title">페이커</div>
						<div class="card-desc">페이커 대상혁이 추천하는 책</div>
					</div>
				</a>
			</div>
			<!-- 박정민 (id=5) -->
			<div class="celeb-card-container" data-celeb-id="5">
				<i
					class="fas fa-bookmark bookmark-icon master-bookmark ${celebList[4].isFullyBookmarked ? 'bookmarked' : ''}"></i>
				<div class="card-actions">
					<button class="delete-btn">삭제</button>
				</div>
				<a class="card"
					href="${pageContext.request.contextPath}/celebDetail?id=5"> <img
					src="./img/celeb/parkjungmin_thum.jpg" alt="박정민 이미지" />
					<div class="card-content">
						<div class="card-title">박정민</div>
						<div class="card-desc">출판사 '무제'대표 박정민의 책장</div>
					</div>
				</a>
			</div>
			<!-- RM (id=6) -->
			<div class="celeb-card-container" data-celeb-id="6">
				<i
					class="fas fa-bookmark bookmark-icon master-bookmark ${celebList[5].isFullyBookmarked ? 'bookmarked' : ''}"></i>
				<div class="card-actions">
					<button class="delete-btn">삭제</button>
				</div>
				<a class="card"
					href="${pageContext.request.contextPath}/celebDetail?id=6"> <img
					src="./img/celeb/rm_thum.jpg" alt="RM 이미지" />
					<div class="card-content">
						<div class="card-title">RM</div>
						<div class="card-desc">방탄소년단 RM이 추천하는 인생책</div>
					</div>
				</a>
			</div>
			<!-- 한강 (id=7) -->
			<div class="celeb-card-container" data-celeb-id="7">
				<i
					class="fas fa-bookmark bookmark-icon master-bookmark ${celebList[6].isFullyBookmarked ? 'bookmarked' : ''}"></i>
				<div class="card-actions">
					<button class="delete-btn">삭제</button>
				</div>
				<a class="card"
					href="${pageContext.request.contextPath}/celebDetail?id=7"> <img
					src="./img/celeb/hankang_thum.jpg" alt="한강 이미지" />
					<div class="card-content">
						<div class="card-title">한강</div>
						<div class="card-desc">노벨문학상 한강 작가의 책장</div>
					</div>
				</a>
			</div>
			<!-- 홍경 (id=8) -->
			<div class="celeb-card-container" data-celeb-id="8">
				<i
					class="fas fa-bookmark bookmark-icon master-bookmark ${celebList[7].isFullyBookmarked ? 'bookmarked' : ''}"></i>
				<div class="card-actions">
					<button class="delete-btn">삭제</button>
				</div>
				<a class="card"
					href="${pageContext.request.contextPath}/celebDetail?id=8"> <img
					src="./img/celeb/hongkyung_thum.jpg" alt="홍경 이미지" />
					<div class="card-content">
						<div class="card-title">홍경</div>
						<div class="card-desc">배우 홍경이 추천하는 책</div>
					</div>
				</a>
			</div>
		</div>
	</div>

	<button id="scrollToTopBtn">
		<img src="img/up1.png" alt="위로 가기 버튼" />
	</button>

	<script>
document.addEventListener("DOMContentLoaded", () => {
    // 이 방식은 톰캣/JSP 환경에서 가장 기본적이고 안전합니다.
    const contextPath = "<%=request.getContextPath()%>";
    const isLoggedIn = <%=loggedInUser != null%>;
    let isProcessing = false;

    // --- 스크롤 및 버튼 관련 코드는 그대로 유지 ---
    const scrollToTopBtn = document.getElementById('scrollToTopBtn');
    if(scrollToTopBtn) {
        scrollToTopBtn.addEventListener('click', () => {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    }
    const deleteSelectedBtn = document.getElementById('deleteSelectedBtn');
    if(deleteSelectedBtn) {
        deleteSelectedBtn.addEventListener('click', () => {
            document.body.classList.toggle('delete-mode-active');
            const btnText = document.body.classList.contains('delete-mode-active') ? '삭제 모드 종료' : '선택 삭제';
            deleteSelectedBtn.textContent = btnText;
        });
    }

    const grid = document.querySelector('.grid');
    if (grid) {
        grid.addEventListener('click', async (event) => {
            // 2. 아이콘 내부를 클릭해도 인식하도록 closest()를 사용합니다.
            const bookmarkIcon = event.target.closest('.master-bookmark');
            const deleteBtn = event.target.closest('.delete-btn');

            // 3. 북마크 아이콘 클릭 시
            if (bookmarkIcon) {
                event.preventDefault();
                event.stopPropagation();
                if (!isLoggedIn) {
                    alert('로그인이 필요한 기능입니다.');
                    // 4. JSP와 충돌이 없는 '+' 연산자로 URL을 만듭니다.
                    window.location.href = contextPath + '/login.jsp';
                    return;
                }
                const card = bookmarkIcon.closest('.celeb-card-container');
                const celebId = card.dataset.celebId;
                const isBookmarked = bookmarkIcon.classList.contains('bookmarked');
                const method = isBookmarked ? 'DELETE' : 'POST';
                if (isBookmarked && !confirm('정말 저장된 모든 찜 목록을 삭제하시겠습니까?')) {
                    return;
                }
                isProcessing = true;
                bookmarkIcon.style.opacity = '0.5';
                try {
                    // 5. JSP와 충돌이 없는 '+' 연산자로 fetch URL을 만듭니다.
                    const response = await fetch(contextPath + '/api/celebs/wishlists?celebId=' + celebId, {
                        method: method
                    });
                    if (!response.ok) {
                        const errorResult = await response.json();
                        throw new Error(errorResult.message || '서버 요청 실패');
                    }
                    bookmarkIcon.classList.toggle('bookmarked');
                } catch (error) {
                    console.error('전체 찜 처리 중 오류:', error);
                    alert(error.message);
                } finally {
                    isProcessing = false;
                    bookmarkIcon.style.opacity = '1';
                }
            }
            // 6. 삭제 버튼 클릭 시 (서버에 관련 서블릿 구현 필요)
            else if (deleteBtn) {
                event.preventDefault();
                event.stopPropagation();
                const card = deleteBtn.closest('.celeb-card-container');
                const celebId = card ? card.dataset.celebId : null;
                if (!celebId) {
                    alert('삭제할 셀럽 ID를 찾을 수 없습니다.');
                    return;
                }
                if (!confirm('정말로 이 셀럽 추천 글을 삭제하시겠습니까?')) return;
                try {
                    // 404 에러의 원인: 이 URL을 처리할 서블릿을 서버에 만들어야 합니다.
                    const urlToDelete = contextPath + '/celebList/' + celebId;
                    const response = await fetch(urlToDelete, { method: 'DELETE' });
                    if (response.ok) {
                        alert('삭제되었습니다.');
                        window.location.reload();
                    } else {
                        alert('삭제 실패: 서버에 요청을 처리할 수 있는 핸들러가 없습니다 (404).');
                    }
                } catch (error) {
                    console.error('삭제 요청 중 오류 발생:', error);
                    alert('삭제 요청 중 통신 오류가 발생했습니다.');
                }
            }
        });
    }
});
</script>

</body>
</html>