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
		<div class="banner">
			<a id="banner-link"
				href="https://product.kyobobook.co.kr/detail/S000215578377"
				target="_blank"> <img id="banner-image" src="img/b1.jpg"
				alt="배너 이미지" />
			</a>
			<div class="banner-controls">
				<%-- [개선 3] onclick 속성을 제거하고 JS에서 이벤트 리스너를 추가합니다. --%>
				<button id="banner-prev-btn">&#9664;</button>
				<button id="banner-toggle-btn">⏸</button>
				<button id="banner-next-btn">&#9654;</button>
			</div>
		</div>

		<div class="section-title">
			<%-- [개선 3] onclick 속성을 제거하고 JS에서 이벤트 리스너를 추가합니다. --%>
			<a href="#" data-banner="weekly" id="btn-weekly">이 주의 책</a> 
			<a href="#" data-banner="new" id="btn-new">신간 소개</a> 
			<a href="#" data-banner="featured" id="btn-featured">눈에 띄는 새책</a> 
			<a href="#" data-banner="hot" id="btn-hot">화제의 책</a> 
			<a href="#" data-banner="exclusive" id="btn-exclusive">단독 에디션</a>
		</div>

		<div class="main_list">
			<h2>
				<%-- [개선 3] onclick 속성을 제거하고 JS에서 이벤트 리스너를 추가합니다. --%>
				<button id="main-list-title" data-tag="cool"
					style="background: none; border: none; font-size: 24px; font-weight: bold; cursor: pointer;">돌고
					돌아 다시 여름</button>
			</h2>
			<div class="tag-list">
				<%-- [개선 3] onclick 속성을 제거하고 JS에서 이벤트 리스너를 추가합니다. --%>
				<button class="tag-button" data-tag="cool">서늘한 여름</button>
				<button class="tag-button" data-tag="tearful">눈물의 여름</button>
				<button class="tag-button" data-tag="moment">여름의 순간들</button>
				<button class="tag-button" data-tag="new">상반기 베스트 셀러</button>
			</div>
			<div>
				<button id="carousel-prev-btn" color="#446b3c">&#9664;</button>
				<button id="carousel-next-btn" color="#446b3c">&#9654;</button>
			</div>
			<div id="book-list-container"></div>
		</div>
	</div>
	<%-- 맨 위로 가기 버튼 --%>
	<button id="scrollToTopBtn">
		<img src="img/up1.png" alt="위로 가기 버튼" />
	</button>


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

        // --- 책 목록 캐러셀 기능 (원본 데이터 전체 유지) ---
       const booksData = {
		    cool: `
		      <div class="book-carousel">
		        <div class="carousel-window">
		          <div class="carousel-track">
		          <div class="book-item">
			          <a href="https://product.kyobobook.co.kr/detail/S000001936854" target="_blank">
			            <img src="img/love.jpg" alt="칵테일, 러브, 좀비" />
			          </a>
		              <div class="book-info">
		                <p class="book-title">칵테일, 러브, 좀비 (리커버)</p>
		                <p class="book-author">조예은</p>
		              </div>
		            </div>
		            <div class="book-item">
		            <a href="https://product.kyobobook.co.kr/detail/S000200077194" target="_blank">
		              <img src="img/9791158791971.jpg" alt="우중괴담" />
		              </a>
		              <div class="book-info">
		                <p class="book-title">우중괴담</p>
		                <p class="book-author">미쓰다 신조</p>
		              </div>
		            </div>
		            <div class="book-item">
		            <a href="https://product.kyobobook.co.kr/detail/S000061584825" target="_blank">
		              <img src="img/9791160408331.jpg" alt="트로피컬 나이트" />
		              </a>
		              <div class="book-info">
		                <p class="book-title">트로피컬 나이트</p>
		                <p class="book-author">조예은</p>
		              </div>
		            </div>
		            <div class="book-item">
		            <a href="https://product.kyobobook.co.kr/detail/S000216670282" target="_blank">
		              <img src="img/9791193190364.jpg" alt="당신의 잘린, 손" />
		              </a>
		              <div class="book-info">
		                <p class="book-title">당신의 잘린, 손</p>
		                <p class="book-author">배예람, 클레이븐</p>
		              </div>
		            </div>
		            <div class="book-item">
		            <a href="https://product.kyobobook.co.kr/detail/S000214033918" target="_blank">
		              <img src="img/9791158792183.jpg" alt="세뇌살인" />
		              </a>
		              <div class="book-info">
		                <p class="book-title">세뇌살인</p>
		                <p class="book-author">혼다 데쓰야</p>
		              </div>
		            </div>
		          </div>
		        </div>
		      </div>
		    `,
		    tearful: `
			  <div class="book-carousel">
			    <div class="carousel-window">
			      <div class="carousel-track">
			        <div class="book-item">
			        <a href="https://product.kyobobook.co.kr/detail/S000001979213" target="_blank">
			          <img src="img/9791196674380.jpg" alt="오지 않는 버스를 기다리는 아이" />
			          </a>
			          <div class="book-info">
			            <p class="book-title">오지 않는 버스를 기다리는 아이</p>
			            <p class="book-author">토마스 S. 스프래들리 , 제임스 P. 스프래들리</p>
			          </div>
			        </div>
			        <div class="book-item">
			        <a href="https://product.kyobobook.co.kr/detail/S000061353833" target="_blank">
			          <img src="img/9791191043754.jpg" alt="세상의 마지막 기차역(리커버 에디션)" />
			          </a>
			          <div class="book-info">
			            <p class="book-title">세상의 마지막 기차역(리커버 에디션)</p>
			            <p class="book-author">무라세 다케시</p>
			          </div>
			        </div>
			        <div class="book-item">
			        <a href="https://product.kyobobook.co.kr/detail/S000200550190" target="_blank">
			          <img src="img/9791167901484.jpg" alt="나미야 잡화점의 기적" />
			          </a>
			          <div class="book-info">
			            <p class="book-title">나미야 잡화점의 기적</p>
			            <p class="book-author">히가시노 게이고</p>
			          </div>
			        </div>
			        <div class="book-item">
			        <a href="https://product.kyobobook.co.kr/detail/S000001986136" target="_blank">
			          <img src="img/9791197377143.jpg" alt="어서 오세요, 휴남동 서점입니다" />
			          </a>
			          <div class="book-info">
			            <p class="book-title">어서 오세요, 휴남동 서점입니다</p>
			            <p class="book-author">황보름</p>
			          </div>
			        </div>
			      </div>
			    </div>
			  </div>
		    `,
		    moment: `
		      <div class="book-carousel">
		        <div class="carousel-window">
		          <div class="carousel-track">
		            <div class="book-item">
		            <a href="https://product.kyobobook.co.kr/detail/S000216830653" target="_blank">
		              <img src="img/9791194324799.jpg" alt="여름어 사전" />
		              </a>
		              <div class="book-info">
		                <p class="book-title">여름어 사전</p>
		                <p class="book-author">아침달 편집부</p>
		              </div>
		            </div>
		            <div class="book-item">
		            <a href="https://product.kyobobook.co.kr/detail/S000216953084" target="_blank">
		              <img src="img/9791130667607.jpg" alt="주게무의 여름" />
		              </a>
		              <div class="book-info">
		                <p class="book-title">주게무의 여름</p>
		                <p class="book-author">모가미 잇페이</p>
		              </div>
		            </div>
		            <div class="book-item">
		            <a href="https://product.kyobobook.co.kr/detail/S000216951034" target="_blank">
		              <img src="img/9791194192329.jpg" alt="스웨덴에서 보낸 여름" />
		              </a>
		              <div class="book-info">
		                <p class="book-title">스웨덴에서 보낸 여름</p>
		                <p class="book-author">김승래</p>
		              </div>
		            </div>
		            <div class="book-item">
		            <a href="https://product.kyobobook.co.kr/detail/S000216344843" target="_blank">
		              <img src="img/photo8.jpeg" alt="첫 여름, 완주" />
		              </a>
		              <div class="book-info">
		                <p class="book-title">첫 여름, 완주</p>
		                <p class="book-author">김금희</p>
		              </div>
		            </div>
		            <div class="book-item">
		            <a href="https://product.kyobobook.co.kr/detail/S000216513958" target="_blank">
		              <img src="img/photo3.jpeg" alt="고래눈이 내리다" />
		              </a>
			          <div class="book-info">
			            <p class="book-title">고래눈이 내리다</p>
			            <p class="book-author">김보영</p>
			          </div>
			        </div>
		          </div>
		        </div>
		      </div>
		    `,
		    new: `
		      <div class="book-carousel">
		        <div class="carousel-window">
		          <div class="carousel-track">
			        <div class="book-item">
			          <img src="img/Unknown.jpeg" alt="소년이 온다" />
			          <div class="book-info">
			            <p class="book-title">소년이 온다</p>
			            <p class="book-author">한강</p>
			          </div>
			        </div>
			        <div class="book-item">
			          <img src="img/9788901294742.jpg" alt="청춘의 독서" />
			          <div class="book-info">
			            <p class="book-title">청춘의 독서</p>
			            <p class="book-author">유시민</p>
			          </div>
			        </div>
			        <div class="book-item">
			          <img src="img/9788932043562.jpg" alt="빛과 실" />
			          <div class="book-info">
			            <p class="book-title">빛과 실</p>
			            <p class="book-author">한강</p>
			          </div>
			        </div>
			        <div class="book-item">
			          <img src="img/9788998441012.jpg" alt="모순" />
			          <div class="book-info">
			            <p class="book-title">모순</p>
			            <p class="book-author">양귀자</p>
			          </div>
			        </div>
		          </div>
		        </div>
		      </div>
		    `
		};

        const tags = ['cool', 'tearful', 'moment', 'new'];
        let currentTagIndex = 0;
        const bookListContainer = document.getElementById('book-list-container');
        const tagButtons = document.querySelectorAll('.tag-button');

        function getTagLabel(tag) {
            const button = document.querySelector(`.tag-button[data-tag="${tag}"]`);
            return button ? button.textContent.trim() : '';
        }

        function updateActiveTagButton() {
            tagButtons.forEach(btn => {
                btn.classList.toggle('active', btn.dataset.tag === tags[currentTagIndex]);
            });
        }

        function showBooks(tag) {
            bookListContainer.innerHTML = booksData[tag] || '<p>해당 카테고리의 책이 없습니다.</p>';
            currentTagIndex = tags.indexOf(tag);
            updateActiveTagButton();
        }

        // --- 배너 기능 ---
        const bannerImage = document.getElementById('banner-image');
        const bannerLink = document.getElementById('banner-link');
        const pauseBtn = document.getElementById('banner-toggle-btn');
        const bannerData = {
            weekly: { img: "img/b1.jpg", link: "https://product.kyobobook.co.kr/detail/S000215578377" },
            new: { img: "img/honmono_reco.jpg", link: "https://product.kyobobook.co.kr/detail/S000216111714" },
            featured: { img: "img/b3.jpg", link: "https://product.kyobobook.co.kr/detail/S000216842334" },
            hot: { img: "img/b4.jpg", link: "https://product.kyobobook.co.kr/detail/S000000781065" },
            exclusive: { img: "img/event.png", link: "#" }
        };
        const bannerKeys = Object.keys(bannerData);
        let currentBannerIndex = 0;
        let bannerInterval = null;

        function showBanner(index) {
            const key = bannerKeys[index];
            bannerImage.src = bannerData[key].img;
            bannerLink.href = bannerData[key].link;
        }

        function nextBanner() {
            currentBannerIndex = (currentBannerIndex + 1) % bannerKeys.length;
            showBanner(currentBannerIndex);
        }

        function prevBanner() {
            currentBannerIndex = (currentBannerIndex - 1 + bannerKeys.length) % bannerKeys.length;
            showBanner(currentBannerIndex);
        }

        function toggleSlide() {
            if (bannerInterval) {
                clearInterval(bannerInterval);
                bannerInterval = null;
                pauseBtn.textContent = "▶";
            } else {
                startAutoSlide();
                pauseBtn.textContent = "⏸";
            }
        }

        function startAutoSlide() {
            if (bannerInterval) clearInterval(bannerInterval);
            bannerInterval = setInterval(nextBanner, 3000);
        }

        function changeBanner(key) {
            const index = bannerKeys.indexOf(key);
            if (index !== -1) {
                currentBannerIndex = index;
                showBanner(currentBannerIndex);
                if (bannerInterval) {
                    clearInterval(bannerInterval);
                    bannerInterval = null;
                    pauseBtn.textContent = "▶";
                }
            }
        }


        // --- 이벤트 리스너 바인딩 ---
		// [수정된 부분] 로그아웃 버튼 리스너를 다른 버튼 리스너들과 함께 배치
	    const logoutBtn = document.getElementById('logout-btn');
	    if (logoutBtn) {
	        logoutBtn.addEventListener('click', async (event) => {
	            event.preventDefault();
	            if (confirm('로그아웃 하시겠습니까?')) {
	                try {
	                    // 여기의 contextPath는 이 스크립트 상단에 선언된 변수를 사용합니다.
	                    const response = await fetch(`${contextPath}/doLogout`, {
	                        cache: 'no-store'
	                    });

	                    if (!response.ok) {
	                        throw new Error(`서버 응답 오류: ${response.status}`);
	                    }

	                    const result = await response.json();
	                    if (result.status === 'success') {
	                        alert(result.message);
	                        window.location.reload();
	                    } else {
	                        alert(result.message || '로그아웃에 실패했습니다.');
	                    }
	                } catch (error) {
	                    console.error('Logout failed:', error);
	                    alert('로그아웃 처리 중 문제가 발생했습니다.');
	                }
	            }
	        });
	    }
        
        const joinBtn = document.getElementById('join-btn');
        if(joinBtn) joinBtn.addEventListener('click', () => location.href='register.jsp');

        const loginBtn = document.getElementById('login-btn');
        if(loginBtn) loginBtn.addEventListener('click', () => location.href='login.jsp');
        
        const mypageBtn = document.getElementById('mypage-btn');
        if(mypageBtn) mypageBtn.addEventListener('click', () => location.href='mypage.jsp');


        document.getElementById('banner-prev-btn').addEventListener('click', prevBanner);
        document.getElementById('banner-next-btn').addEventListener('click', nextBanner);
        document.getElementById('banner-toggle-btn').addEventListener('click', toggleSlide);

        document.querySelectorAll('.section-title a').forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                changeBanner(e.target.dataset.banner);
            });
        });

        tagButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                showBooks(e.target.dataset.tag);
            });
        });

        document.getElementById('main-list-title').addEventListener('click', (e) => {
            showBooks(e.target.dataset.tag);
        });

        document.getElementById('carousel-prev-btn').addEventListener('click', () => {
            currentTagIndex = (currentTagIndex - 1 + tags.length) % tags.length;
            showBooks(tags[currentTagIndex]);
        });

        document.getElementById('carousel-next-btn').addEventListener('click', () => {
            currentTagIndex = (currentTagIndex + 1) % tags.length;
            showBooks(tags[currentTagIndex]);
        });

        const scrollToTopBtn = document.getElementById('scrollToTopBtn');
        window.addEventListener('scroll', () => {
            scrollToTopBtn.style.display = window.scrollY > 300 ? 'block' : 'none';
        });
        scrollToTopBtn.addEventListener('click', () => {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
        

        // --- 초기화 로직 ---
        function initializePage() {
            const urlParams = new URLSearchParams(window.location.search);
            const queryFromUrl = urlParams.get('query');

            if (queryFromUrl) {
                searchInput.value = decodeURIComponent(queryFromUrl.replace(/\+/g, ' '));
                performSearch(queryFromUrl);
            } else {
                // 기본 페이지 로드
                showBanner(currentBannerIndex);
                startAutoSlide();
                showBooks('cool');
            }
        }

        initializePage();
    });
</script>
</body>
</html>