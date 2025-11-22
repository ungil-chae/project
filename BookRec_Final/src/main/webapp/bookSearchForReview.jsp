<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ page import="model.User"%>

<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>리뷰할 책 검색</title>
<%@ include file="css/main_css.jsp"%>
<link rel="stylesheet" href="<%=contextPath%>/css/reviewList.css" />
<%-- 검색 결과 스타일을 위해 일단 포함 --%>
<style>
/* 이 페이지만 적용: 컨테이너 높이로 푸터를 화면 하단에 고정 */
.container {
	min-height: calc(100vh - 250px);
	padding: 20px;
}

.search-area {
	display: flex;
	justify-content: center;
	margin-bottom: 30px;
}

.search-area input {
	width: 60%;
	padding: 10px;
	font-size: 1em;
	border: 1px solid #ddd;
	border-radius: 5px;
	margin-right: 10px;
}

.search-area button {
	padding: 10px 20px;
	font-size: 1em;
	background-color: #4CAF50;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}

.search-area button:hover {
	background-color: #45a049;
}

.search-results-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
	gap: 25px;
	padding: 0 50px;
}

.book-card {
	border: 1px solid #ddd;
	border-radius: 8px;
	padding: 15px;
	text-align: center;
	background-color: #f9f9f9;
	transition: transform 0.2s;
}

.book-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.book-card img {
	width: 180px;
	height: 260px;
	object-fit: cover;
	border-radius: 4px;
	margin-bottom: 10px;
}

.book-card h3 {
	font-size: 1em;
	margin: 10px 0 5px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.book-card p {
	font-size: 0.8em;
	color: #666;
}

.book-card .select-button {
	background-color: #007bff;
	color: white;
	border: none;
	padding: 8px 15px;
	border-radius: 5px;
	cursor: pointer;
	margin-top: 10px;
}

.book-card .select-button:hover {
	background-color: #0056b3;
}

.loading-message, .error-message, .info-message {
	text-align: center;
	padding: 20px;
	font-size: 1.1em;
	color: #555;
}

.error-message {
	color: #d9534f;
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
		<h2>리뷰할 책 검색</h2>
		<div class="search-area">
			<input type="text" id="searchInput" placeholder="책 제목, 저자 등으로 검색...">
			<button id="searchBtn">검색</button>
		</div>
		<div id="searchResultsArea">
			<p class="info-message">책을 검색하여 리뷰를 작성할 책을 선택하세요.</p>
		</div>
	</div>

	<%@ include file="main_footer.jsp"%>

	<script>
        document.addEventListener('DOMContentLoaded', () => {
            const contextPath = "<%=contextPath%>";
            
            const searchInput = document.getElementById('searchInput'); 
            const searchBtn = document.getElementById('searchBtn');     
            const searchResultsArea = document.getElementById('searchResultsArea'); 

            // --- 책 검색 기능 ---
            searchBtn.addEventListener('click', () => {
                const query = searchInput.value.trim();
                console.log("Captured query on click:", query);
                performSearch(query);
            });

            searchInput.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') {
                    const query = searchInput.value.trim();
                    console.log("Captured query on Enter:", query);
                    performSearch(query);
                }
            });

            async function performSearch(query) {
                console.log("performSearch called with query:", query);

                if (!query) {
                    alert('검색어를 입력해주세요.');
                    return;
                }

                searchResultsArea.innerHTML = '<p class="loading-message">검색 중...</p>';

                try {
                    const encodedQuery = encodeURIComponent(query);
                    // encodedQuery도 요청하신 형식으로 수정
                    const apiUrl = `${'${contextPath}'}/searchBook?query=${'${encodedQuery}'}`; 
                    console.log("API URL being sent:", apiUrl);

                    const response = await fetch(apiUrl);
                    if (!response.ok) {
                        const errorText = await response.text();
                        console.error(`HTTP error! status: ${response.status}, response: ${errorText}`);
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }

                    const data = await response.json();
                    displaySearchResults(data.items);
                } catch (error) {
                    console.error('Search failed:', error);
                    searchResultsArea.innerHTML = '<p class=\"error-message\">검색 중 오류가 발생했습니다.</p>';
                }
            }

            // --- 검색 결과 표시 ---
            function displaySearchResults(books) {
                searchResultsArea.innerHTML = '';
                if (!books || books.length === 0) {
                    searchResultsArea.innerHTML = '<p class=\"info-message\">검색 결과가 없습니다.</p>';
                    return;
                }

                const resultsGrid = document.createElement('div');
                resultsGrid.className = 'search-results-grid';

                books.forEach(book => {
                    const bookCard = document.createElement('div');
                    bookCard.className = 'book-card';

                    const title = book.title.replace(/<b>/g, '').replace(/<\/b>/g, '');
                    const author = book.author.replace(/<b>/g, '').replace(/<\/b>/g, '');
                    
                    // imageUrl에도 적용
                    const imageUrl = book.image || `${'${contextPath}'}/img/icon2.png`;
                    const originalLink = book.link;
                    const isbn = book.isbn;

                    const imgElement = document.createElement('img');
                    imgElement.src = imageUrl;
                    imgElement.alt = title;
                    // imgElement.onerror에도 적용
                    imgElement.onerror = function() { this.onerror=null; this.src=`${'${contextPath}'}/img/icon2.png`; };

                    const titleHeader = document.createElement('h3');
                    titleHeader.textContent = title;

                    const authorPara = document.createElement('p');
                    authorPara.textContent = author;

                    const selectButton = document.createElement('button');
                    selectButton.className = 'select-button';
                    selectButton.textContent = '이 책으로 리뷰 작성';
                    selectButton.addEventListener('click', () => {
                        const urlParams = new URLSearchParams();
                        urlParams.append('isbn', isbn || '');
                        urlParams.append('title', title);
                        urlParams.append('author', author);
                        urlParams.append('coverImageUrl', book.image || '');
                        urlParams.append('naverLink', originalLink || '');

                        // location.href에도 적용
                        location.href = `${'${contextPath}'}/reviewForm.jsp?${'${urlParams.toString()}'}`;
                    });

                    bookCard.appendChild(imgElement);
                    bookCard.appendChild(titleHeader);
                    bookCard.appendChild(authorPara);
                    bookCard.appendChild(selectButton);

                    resultsGrid.appendChild(bookCard);
                });

                searchResultsArea.appendChild(resultsGrid);
            }
        });
    </script>
</body>
</html>