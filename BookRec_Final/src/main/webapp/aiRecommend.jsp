<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ page import="model.User"%>

<%
// 페이지 맨 위에서 변수 선언
User loggedInUser = (User) session.getAttribute("loggedInUser");
String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WITHUS</title>

<%-- CSS 파일 포함 --%>
<%@ include file="css/main_css.jsp"%>

<link rel="icon" href="img/icon2.png" type="image/x-icon">
<script
	src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

</head>
<body>
	<%-- [최종 수정] header 태그 없이 include만 사용합니다. --%>
	<%@ include file="header.jsp"%>


	<nav>
		<a href="<%=contextPath%>/aiRecommend.jsp">(AI) 책 추천</a> <a
			href="<%=contextPath%>/reviewList">리뷰</a> <a
			href="<%=contextPath%>/playlistmain.jsp">플레이리스트</a> <a
			href="<%=contextPath%>/celebList">셀럽추천</a> <a
			href="<%=contextPath%>/mypage.jsp">마이페이지</a>
	</nav>
	<div id="main-content-area">
	
	<img src="img/sorry.jpg" alt="죄송합니다"/>
		
	</div>
	<%-- 맨 위로 가기 버튼 
	<button id="scrollToTopBtn">
		<img src="img/up1.png" alt="위로 가기 버튼" />
	</button> --%>


	<%-- 푸터 파일 포함 --%>
	<%@ include file="./main_footer.jsp"%>

	<%-- [수정 2] 불필요한 스크립틀릿 제거
    String query = request.getParameter("query");
    이 코드는 JavaScript 로직에서 사용되지 않으므로 삭제합니다.
    --%>

	<script>
    document.addEventListener('DOMContentLoaded', () => {
    	console.log("contextPath: '<%=request.getContextPath()%>'");
    	const contextPath = "<%=request.getContextPath()%>";
        const mainContentArea = document.getElementById('main-content-area');
        const searchInput = document.getElementById('search-box');
        const searchBtn = document.getElementById('search-btn');
        if (searchBtn) {
          searchBtn.addEventListener('click', () => {
            const query = searchInput.value.trim();
            performSearch(query);
          });
        }
        // --- 검색 기능 (회원님 기존 코드 스타일로 복원) ---
        async function performSearch(query) {
            if (!query || !query.trim()) {
                alert('검색어를 입력해주세요.');
                return;
            }
            
            mainContentArea.innerHTML = '<p class="loading-message">검색 중...</p>';

            try {
                const encodedQuery = encodeURIComponent(query);
                const apiUrl = `${'${contextPath}'}/searchBook?query=${'${encodedQuery}'}'`;
                
                const response = await fetch(apiUrl);
                if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
                
                const data = await response.json();
                displaySearchResults(data.items);
            } catch (error) {
                console.error('Search failed:', error);
                mainContentArea.innerHTML = '<p class="error-message">검색 중 오류가 발생했습니다.</p>';
            }
        }

        // --- 검색 결과 표시 (회원님 기존 코드 스타일로 복원) ---
       // main.jsp의 <script> 태그 안에 이 함수를 통째로 교체합니다.
function displaySearchResults(books) {
    mainContentArea.innerHTML = '';
    if (!books || books.length === 0) {
        mainContentArea.innerHTML = '<p class="info-message">검색 결과가 없습니다.</p>';
        return;
    }

    // 스타일 코드는 그대로 유지 (이 부분은 수정할 필요 없습니다)
    const styleId = 'search-result-styles';
    if (!document.getElementById(styleId)) {
        const style = document.createElement('style');
        style.id = styleId;
        style.innerHTML = `
            .search-results-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 25px; padding: 20px 50px; }
            .book-card { border: 1px solid #ddd; border-radius: 8px; padding: 15px; text-align: center; background-color: #f9f9f9; transition: transform 0.2s; }
            .book-card:hover { transform: translateY(-5px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
            .book-card img { width: 180px; height: 260px; object-fit: cover; border-radius: 4px; }
            .book-card h3 { font-size: 1em; margin: 10px 0 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
            .book-card p { font-size: 0.8em; color: #666; }
        `;
        document.head.appendChild(style);
    }

    const resultsGrid = document.createElement('div');
    resultsGrid.className = 'search-results-grid';

	    // books.forEach 부분을 아래의 안정적인 방식으로 변경합니다.
	    books.forEach(book => {
	        const bookCard = document.createElement('div');
	        bookCard.className = 'book-card';
	
	        // 1. 책 정보를 변수에 저장 (<b> 태그 제거)
	        const title = book.title.replace(/<b>|<\/b>/g, '');
	        const author = book.author.replace(/<b>|<\/b>/g, '');
	        const imageUrl = book.image || '<%= contextPath %>/img/icon2.png'; // 이미지가 없으면 기본 이미지
	        const originalLink = book.link;
	        const bookId = book.isbn;
	
	        // 2. BookClickServlet으로 보낼 URL 생성
	        const servletUrl = 
	            '<%= contextPath %>/bookClick' +
	            '?id=' + encodeURIComponent(bookId) +
	            '&title=' + encodeURIComponent(title) +
	            '&author=' + encodeURIComponent(author) +
	            '&image=' + encodeURIComponent(book.image) + // 원본 이미지 URL 전달
	            '&link=' + encodeURIComponent(originalLink);
	
	        // 3. HTML 요소를 직접 생성 (innerHTML 대신)
	        // 3-1. 이미지 링크 (클릭 시 최근 본 책에 저장)
	        const imageLink = document.createElement('a');
	        imageLink.href = servletUrl;
	        
	        const imageElement = document.createElement('img');
	        imageElement.src = imageUrl;
	        imageElement.alt = title;
	        imageElement.onerror = function() { this.onerror=null; this.src='<%= contextPath %>/img/icon2.png'; };
	        
	        imageLink.appendChild(imageElement);
	
	        // 3-2. 제목 링크 (클릭 시 바로 이동)
	        const titleHeader = document.createElement('h3');
	        const titleLink = document.createElement('a');
	        titleLink.href = originalLink;
	        titleLink.target = '_blank';
	        titleLink.textContent = title;
	        titleHeader.appendChild(titleLink);
	
	        // 3-3. 저자 정보
	        const authorPara = document.createElement('p');
	        authorPara.textContent = author;
	        
	        // 4. 생성한 요소들을 bookCard에 추가
	        bookCard.appendChild(imageLink);
	        bookCard.appendChild(titleHeader);
	        bookCard.appendChild(authorPara);
	        
	        resultsGrid.appendChild(bookCard);
	    });
	
	    mainContentArea.appendChild(resultsGrid);
	}

</script>
</body>
</html>
