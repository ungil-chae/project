<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
String contextPath = request.getContextPath();
if (loggedInUser == null) {
   response.sendRedirect(contextPath + "/login.jsp");
   return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WITHUS - 마이페이지</title>

<link rel="icon" href="<%=contextPath%>/img/icon2.png"
   type="image/x-icon">
<link rel="stylesheet" type="text/css"
   href="<%=contextPath%>/css/mypage.css">
<link rel="stylesheet"
   href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<%@ include file="css/main_css.jsp"%>

<!-- 모든 스타일은 css/mypage.css에서 관리됩니다 -->
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

   <div class="main-content-wrapper">
      <div class="sidebar">
         <div class="profile">
            <div class="profile-image-wrapper">
               <%
               String profileImageUrl = (loggedInUser != null && loggedInUser.getProfileImage() != null && !loggedInUser.getProfileImage().isEmpty())
                  ? contextPath + "/" + loggedInUser.getProfileImage()
                  : null;
               %>
               <% if (profileImageUrl != null) { %>
                  <img src="<%=profileImageUrl%>" alt="프로필사진" class="image" id="profile-image">
               <% } else { %>
                  <div class="default-profile-icon" id="profile-image">
                     <i class="fas fa-user"></i>
                  </div>
               <% } %>
               <button type="button" class="profile-add-btn" id="profile-add-btn" title="프로필 이미지 변경">
                  <i class="fas fa-plus"></i>
               </button>
               <input type="file" id="profile-image-input" accept="image/*" style="display: none;">
            </div>
            <%
            String nicknameDisplay = (loggedInUser != null) ? loggedInUser.getNickname() : "Guest";
            %>
            <p class="nickname-display"><%=nicknameDisplay%></p>
         </div>

         <div class="sidebar-menu">
            <div class="menu-category">라이브러리</div>
            <ul>
               <li class="active"><a href="#" data-content="recent-history">찜목록</a></li>
               <li><a href="#" data-content="order-delivery">리뷰 관리</a></li>
            </ul>

            <div class="menu-category">회원정보</div>
            <ul>
               <li><a href="#" data-content="edit-profile">회원정보수정</a></li>
               <li><a href="#" data-content="withdraw">회원탈퇴</a></li>
               <li><a href="#" data-content="customer-service">고객센터</a></li>
            </ul>
         </div>
      </div>

      <div class="right-section-wrapper">
         <div class="top-main-banner">
            <div class="recent-books-header">
               <h2>최근 본 책들</h2>
            </div>
            <div class="recent-books-list">
               <%-- JSTL choose-when-otherwise 구문을 사용하여 조건에 따라 다른 내용을 표시합니다. --%>
               <c:choose>
                  <%-- 1. 세션에 'recentBooks' 목록이 비어있지 않을 때 (c:when) --%>
                  <c:when test="${not empty sessionScope.recentBooks}">
                     <%-- 목록을 반복하면서 각 책(book)에 대한 링크와 이미지를 생성합니다. --%>
                     <c:forEach var="book" items="${sessionScope.recentBooks}">
                        <div class="recent-book-item">
                           <a href="${book.link}" target="_blank" title="${book.title} | ${book.author}">
                              <img src="${book.image}" alt="${book.title}" class="recent-book-img">
                           </a>
                           <div class="recent-book-info">
                              <div class="recent-book-title">${book.title}</div>
                              <div class="recent-book-author">${book.author}</div>
                           </div>
                        </div>
                     </c:forEach>
                  </c:when>

                  <%-- 2. 세션에 'recentBooks' 목록이 비어 있거나 없을 때 (c:otherwise) --%>
                  <c:otherwise>
                     <p>최근 본 책 내역이 없습니다.</p>
                  </c:otherwise>
               </c:choose>
            </div>

            <div class="banner-controls">
               <button onclick="prevImage()">&#9664;</button>
               <button onclick="nextImage()">&#9654;</button>
            </div>
         </div>

         <div class="main-container">
            <div id="recent-history-content" class="content-section active">
               <h2>찜목록</h2>
               <p>찜한 책 내역이 여기에 표시됩니다.</p>
            </div>
            <div id="order-delivery-content" class="content-section">
               <h2>리뷰 관리</h2>
               <div id="my-reviews-list-area">
                  <p style="text-align: center; padding: 20px;">리뷰를 불러오는 중...</p>
               </div>
            </div>

            <div id="edit-profile-content" class="content-section">
               <h2>회원정보수정</h2>
               <p>회원 정보 수정을 위해 비밀번호를 입력해주세요.</p>
               <form id="edit-profile-password-form" class="password-check-form">
                  <label for="edit-profile-confirm-pw">비밀번호:</label> <input
                     type="password" id="edit-profile-confirm-pw"
                     name="edit-profile-confirm-pw" required>
                  <button type="submit">확인</button>
               </form>
            </div>

            <div id="withdraw-content" class="content-section">
               <h2>회원 탈퇴</h2>
               <form id="withdraw-form" class="password-check-form">
                  <label for="withdraw-reason">탈퇴 사유 (선택 사항):</label>
                  <textarea id="withdraw-reason" name="withdraw-reason" rows="5"
                     placeholder="탈퇴하시려는 이유를 알려주시면 서비스 개선에 큰 도움이 됩니다."></textarea>
                  <label for="withdraw-password">비밀번호:</label> <input
                     type="password" id="withdraw-password" name="password" required>
                  <label for="confirm-withdraw"> <input type="checkbox"
                     id="confirm-withdraw" required> 회원 탈퇴에 동의합니다.
                  </label>
                  <button type="submit">회원 탈퇴</button>
               </form>
            </div>

            <div id="edit-profile-detail-content" class="content-section">
               <h2>회원 정보 상세 수정</h2>
               <p>회원 정보를 수정합니다.</p>
               <form id="edit-profile-detail-form">
                  <label for="detail-id">아이디:</label> <input type="text"
                     id="detail-id" name="detail-id"
                     value="<%=loggedInUser != null ? loggedInUser.getUsername() : ""%>"
                     readonly> <label for="detail-new-password">새
                     비밀번호:</label> <input type="password" id="detail-new-password"
                     name="detail-new-password" placeholder="새 비밀번호 입력 (변경 시)">
                  <label for="detail-confirm-new-password">새 비밀번호 확인:</label> <input
                     type="password" id="detail-confirm-new-password"
                     name="detail-confirm-new-password" placeholder="새 비밀번호 다시 입력">

                  <label for="detail-nickname">닉네임:</label> <input type="text"
                     id="detail-nickname" name="detail-nickname"
                     value="<%=nicknameDisplay%>"> <label for="detail-gender">성별:</label>
                  <input type="radio" id="gender-male" name="detail-gender"
                     value="M"
                     <%=(loggedInUser != null && "M".equals(loggedInUser.getGender())) ? "checked" : ""%>>
                  <label for="gender-male" style="display: inline;">남성</label> <input
                     type="radio" id="gender-female" name="detail-gender" value="F"
                     <%=(loggedInUser != null && "F".equals(loggedInUser.getGender())) ? "checked" : ""%>>
                  <label for="gender-female" style="display: inline;">여성</label> <input
                     type="radio" id="gender-other" name="detail-gender" value="O"
                     <%=(loggedInUser != null && "O".equals(loggedInUser.getGender())) ? "checked" : ""%>>
                  <label for="gender-other" style="display: inline;">선택 안 함</label>
                  <br> <br> <label for="detail-email">이메일:</label> <input
                     type="email" id="detail-email" name="detail-email"
                     value="<%=loggedInUser != null ? loggedInUser.getEmail() : ""%>">

                  <label for="detail-name">이름:</label> <input type="text"
                     id="detail-name" name="detail-name"
                     value="<%=loggedInUser != null ? loggedInUser.getName() : ""%>"
                     required> <label for="detail-mbti">MBTI:</label> <select
                     id="detail-mbti" name="detail-mbti" required>
                     <option value="">선택</option>
                     <%
                     String userMbti = (loggedInUser != null) ? loggedInUser.getMbti() : "";
                     String[] validMbti = {"ISTJ", "ISFJ", "INFJ", "INTJ", "ISTP", "ISFP", "INFP", "INTP", "ESTP", "ESFP", "ENFP", "ENTP",
                           "ESTJ", "ESFJ", "ENFJ", "ENTJ"};
                     for (String mbtiOption : validMbti) {
                     %>
                     <option value="<%=mbtiOption%>"
                        <%=mbtiOption.equals(userMbti) ? "selected" : ""%>>
                        <%=mbtiOption%>
                     </option>
                     <%
                     }
                     %>
                  </select> <label for="detail-hobbies">취미/관심사:</label>
                  <div class="checkbox-group" id="detail-hobbies-checkbox-group">
                     <%
                     String userHobbies = (loggedInUser != null) ? loggedInUser.getHobbies() : "";
                     String[] userHobbiesArray = userHobbies != null && !userHobbies.isEmpty() ? userHobbies.split(",") : new String[]{};
                     java.util.LinkedHashMap<String, String> hobbyMap = new java.util.LinkedHashMap<>();
                     hobbyMap.put("reading", "독서");
                     hobbyMap.put("movie", "영화");
                     hobbyMap.put("music", "음악");
                     hobbyMap.put("sports", "운동");
                     hobbyMap.put("travel", "여행");
                     hobbyMap.put("gaming", "게임");
                     hobbyMap.put("cooking", "요리");
                     hobbyMap.put("art", "미술");
                     hobbyMap.put("science", "과학");
                     hobbyMap.put("coding", "코딩");
                     hobbyMap.put("fashion", "패션");
                     hobbyMap.put("photography", "사진");
                     hobbyMap.put("technology", "기술");
                     hobbyMap.put("history", "역사");
                     hobbyMap.put("writing", "글쓰기");
                     hobbyMap.put("education", "교육");
                     for (java.util.Map.Entry<String, String> entry : hobbyMap.entrySet()) {
                        String hobbyValue = entry.getKey();
                        String hobbyDisplay = entry.getValue();
                        boolean isChecked = false;
                        for (String userHobby : userHobbiesArray) {
                           if (userHobby.trim().equalsIgnoreCase(hobbyValue)) {
                        isChecked = true;
                        break;
                           }
                        }
                     %>
                     <label><input type="checkbox" name="hobbies"
                        value="<%=hobbyValue%>" <%=isChecked ? "checked" : ""%>>
                        <%=hobbyDisplay%></label>
                     <%
                     }
                     %>
                  </div>
                  <button type="submit">정보 저장</button>
               </form>
            </div>

            <div id="customer-service-content" class="content-section">
               <h2>고객센터</h2>
               <p>문의사항이나 불편한 점을 알려주시면 친절하게 도와드리겠습니다.</p>
               <form id="customer-service-form">
                  <label for="cs-subject">제목:</label> <input type="text"
                     id="cs-subject" name="cs-subject" placeholder="문의 제목을 입력해주세요.">
                  <label for="cs-message">내용:</label>
                  <textarea id="cs-message" name="cs-message"
                     placeholder="문의 내용을 입력해주세요."></textarea>
                  <button type="submit">문의 제출</button>
               </form>
            </div>
         </div>
      </div>
   </div>

   </div>
   </div>
   </div>

   <footer>
      <div class="footer-container">
         <p>&copy; 2025 WITHUS. All rights reserved.</p>
         <div class="footer-links">
            <a href="#">이용약관</a> | <a href="#">개인정보처리방침</a> | <a href="#">고객센터</a>
         </div>
      </div>
   </footer>

   <script>
/* ── 배너 자리표시자 (원본 유지) ─────────────────────────────── */
function prevImage(){} function nextImage(){} function toggleSlide(){}

/* ── 초기화 ───────────────────────────────────────────────── */
document.addEventListener('DOMContentLoaded', () => {
  const contextPath = "<%=contextPath%>";

  /* ========================================================
     1.  검색(API) 기능  ― main.jsp와 동일
  ======================================================== */
  const mainContentArea = document.querySelector('.main-content-wrapper');
  const searchInput     = document.getElementById('search-box');
  const searchBtn       = document.getElementById('search-btn');

  if (searchBtn && searchInput && mainContentArea){
    searchBtn.addEventListener('click', () => performSearch(searchInput.value));
    searchInput.addEventListener('keypress', e=>{
      if(e.key==='Enter'){ e.preventDefault(); performSearch(searchInput.value);}
    });
  }

  async function performSearch(q){
    if(!q.trim()){alert('검색어를 입력해주세요.');return;}
    mainContentArea.innerHTML='<p class="loading-message" style="text-align:center;padding:50px;">검색 중...</p>';
    try{
      const url = contextPath + '/searchBook?query=' + encodeURIComponent(q.trim());
      const res = await fetch(url);  if(!res.ok) throw new Error();
      const data= await res.json();
      displaySearchResults(data.items);
    }catch(e){
      mainContentArea.innerHTML='<p class="error-message" style="text-align:center;padding:50px;color:red;">검색 오류</p>';
    }
  }

  function displaySearchResults(books){
    mainContentArea.innerHTML='';
    if(!books.length){
      mainContentArea.innerHTML='<p style="text-align:center;padding:50px;">검색 결과가 없습니다.</p>';return;
    }
    if(!document.getElementById('search-result-styles')){
      const st=document.createElement('style'); st.id='search-result-styles'; st.textContent=`
        .search-results-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));
          gap:25px;padding:20px 50px;max-width:1200px;margin:0 auto}
        .book-card{border:1px solid #ddd;border-radius:8px;padding:15px;background:#f9f9f9;text-align:center;transition:transform .2s}
        .book-card:hover{transform:translateY(-5px);box-shadow:0 4px 8px rgba(0,0,0,.1)}
        .book-card img{width:180px;height:260px;object-fit:cover;border-radius:4px}
        .book-card h3{font-size:1em;margin:10px 0 5px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
        .book-card p{font-size:.8em;color:#666}`; document.head.appendChild(st);
    }
    const g=document.createElement('div'); g.className='search-results-grid';
    books.forEach(b=>{
      const title=b.title.replace(/<b>|<\/b>/g,'');
      const author=b.author.replace(/<b>|<\/b>/g,'');
      const img=b.image?b.image:contextPath+'/img/icon2.png';
      const c=document.createElement('div'); c.className='book-card';
      c.innerHTML=
        `<a href="${b.link}" target="_blank"><img src="${img}"
           alt="${title}" onerror="this.onerror=null;this.src='${contextPath}/img/icon2.png';"></a>
         <h3><a href="${b.link}" target="_blank">${title}</a></h3><p>${author}</p>`;
      g.appendChild(c);
    });
    mainContentArea.appendChild(g);
  }

  /* ========================================================
  2.  사이드바 / 컨텐츠 토글
======================================================== */
const sidebarLinks    = document.querySelectorAll('.sidebar-menu a');
const contentSections = document.querySelectorAll('.content-section');
function hideAll(){contentSections.forEach(s=>{s.style.display='none';s.classList.remove('active');});}
function deactivate(){sidebarLinks.forEach(l=>l.classList.remove('active'));}

sidebarLinks.forEach(link=>{
 link.addEventListener('click',e=>{
   e.preventDefault();
   const id=link.dataset.content+'-content';
   hideAll();
   const target=document.getElementById(id);
   if(target){ target.style.display='block'; target.classList.add('active'); }
   deactivate(); link.classList.add('active');
   
   // 추가: '리뷰 관리' 탭 클릭 시 리뷰 목록 로드
   if(link.dataset.content==='recent-history') {
       loadWishlist();
   } else if (link.dataset.content === 'order-delivery') { // '리뷰 관리'의 data-content는 'order-delivery'
       loadMyReviews();
   }
 });
});

  /* ========================================================
     3.  회원정보 수정 / 비밀번호 변경 / 탈퇴 / 문의
         (기존 로직 그대로)
  ======================================================== */
  /* 3-1. 비밀번호 확인 → 상세 수정 진입 */
  const editProfilePasswordForm=document.getElementById('edit-profile-password-form');
  if(editProfilePasswordForm){
    editProfilePasswordForm.addEventListener('submit',async ev=>{
      ev.preventDefault();
      const pw=document.getElementById('edit-profile-confirm-pw').value;
      try{
        const res=await fetch(contextPath+'/verifyPassword',{
          method:'POST',headers:{'Content-Type':'application/json'},
          body:JSON.stringify({password:pw})
        });
        const r=await res.json();
        if(res.ok&&r.success){
          alert('비밀번호가 확인되었습니다.');
          hideAll();
          const detail=document.getElementById('edit-profile-detail-content');
          if(detail){detail.style.display='block';detail.classList.add('active');}
          deactivate();
          document.querySelector('.sidebar-menu a[data-content="edit-profile"]').classList.add('active');
        }else alert(r.message||'비밀번호가 올바르지 않습니다.');
      }catch(e){alert('서버 오류가 발생했습니다.');}
      document.getElementById('edit-profile-confirm-pw').value='';
    });
  }

  /* 3-2. 프로필 + 비밀번호 변경 */
  const profileForm=document.getElementById('edit-profile-detail-form');
  if(profileForm){
    profileForm.addEventListener('submit',async ev=>{
      ev.preventDefault();
      const newPw   = document.getElementById('detail-new-password').value;
      const newPwC  = document.getElementById('detail-confirm-new-password').value;
      const nickname= document.getElementById('detail-nickname').value;
      const email   = document.getElementById('detail-email').value;
      const nameVal = document.getElementById('detail-name').value;
      const gender  = document.querySelector('input[name="detail-gender"]:checked')?.value||'';
      const mbti    = document.getElementById('detail-mbti').value;
      const hobbies = Array.from(document.querySelectorAll('#detail-hobbies-checkbox-group input[name="hobbies"]:checked'))
                      .map(cb=>cb.value).join(',');

      if(!nickname||!email||!nameVal||!gender||!mbti||!hobbies){alert('모든 필수 정보를 입력해주세요.');return;}

      /* 프로필 정보 업데이트 */
      let okProfile=false, okPw=true;
      try{
        const res=await fetch(contextPath+'/updateUserProfile',{
          method:'POST',headers:{'Content-Type':'application/json'},
          body:JSON.stringify({nickname,email,gender,mbti,name:nameVal,hobbies})
        });
        const r=await res.json();
        if(res.ok&&r.success) okProfile=true; else alert(r.message||'프로필 업데이트 실패');
      }catch(e){alert('프로필 업데이트 오류');}

      /* 비밀번호 변경(선택) */
      if(newPw){
        if(newPw.length<8||!/[!@#$%^&*()]/.test(newPw)){alert('새 비밀번호는 8자 이상, 특수문자 포함'); okPw=false;}
        else if(newPw!==newPwC){alert('새 비밀번호 확인 불일치'); okPw=false;}
        if(okPw){
          try{
            const res=await fetch(contextPath+'/changePassword',{
              method:'POST',headers:{'Content-Type':'application/json'},
              body:JSON.stringify({newPassword:newPw})
            });
            const r=await res.json();
            if(!(res.ok&&r.success)){alert(r.message||'비밀번호 변경 실패'); okPw=false;}
          }catch(e){alert('비밀번호 변경 오류'); okPw=false;}
        }
      }

      if(okProfile&&okPw){alert('정보 변경 완료'); window.location.href='main.jsp';}
      else alert('정보 변경 실패');
    });
  }

  /* 3-3. 회원 탈퇴 */
  const withdrawForm=document.getElementById('withdraw-form');
  if(withdrawForm){
    withdrawForm.addEventListener('submit',async ev=>{
      ev.preventDefault();
      if(!document.getElementById('confirm-withdraw').checked){alert('탈퇴 동의가 필요합니다.');return;}
      if(!confirm('정말 탈퇴하시겠습니까?')) return;
      const pw=document.getElementById('withdraw-password').value;
      const reason=document.getElementById('withdraw-reason').value;
      try{
        const res=await fetch(contextPath+'/withdrawUser',{
          method:'POST',headers:{'Content-Type':'application/json'},
          body:JSON.stringify({password:pw,reason})
        });
        const r=await res.json();
        if(res.ok&&r.success){alert('탈퇴 완료'); window.location.href=contextPath+'/login.jsp';}
        else alert(r.message||'탈퇴 실패');
      }catch(e){alert('탈퇴 중 오류');}
    });
  }

  /* 3-4. 고객센터 문의 */
  const csForm=document.getElementById('customer-service-form');
  if(csForm){
    csForm.addEventListener('submit',ev=>{
      ev.preventDefault();
      const sub=document.getElementById('cs-subject').value.trim();
      const msg=document.getElementById('cs-message').value.trim();
      if(!sub||!msg){alert('제목과 내용을 입력하세요.');return;}
      alert('문의가 접수되었습니다.'); csForm.reset();
    });
  }

  /* ========================================================
     4.  찜목록 로드 + 선택 삭제 / 취소 / 전체선택
  ======================================================== */
  async function loadWishlist(){
    const con=document.getElementById('recent-history-content');
    if(!con) return;
    con.innerHTML='<h2>찜목록</h2><p>불러오는 중...</p>';
    try{
      const res=await fetch(contextPath+'/api/users/me/wishlists');
      if(!res.ok) throw new Error();
      const items=await res.json();

      con.innerHTML='<h2>찜목록</h2>';
      if(!items.length){con.innerHTML+='<p style="text-align:center;padding:50px;">찜한 도서가 없습니다.</p>';return;}

      const controls=document.createElement('div'); controls.className='wishlist-controls';
      controls.innerHTML=`
        <button id="wishlist-delete-all-btn" class="wishlist-delete-all-btn">전체 삭제</button>`;
      con.appendChild(controls);

      const grid=document.createElement('div'); grid.className='grid';
      items.forEach(book=>{
        const img = book.coverImageUrl ? contextPath+'/'+book.coverImageUrl : contextPath+'/img/icon2.png';
        const card = document.createElement('div');
        card.className='card';
        card.dataset.bookId = book.bookId;
        card.dataset.link = book.link;

        // X 삭제 버튼 (스타일은 mypage.css에서 관리)
        const deleteBtn = document.createElement('span');
        deleteBtn.className = 'wishlist-delete-btn';
        deleteBtn.dataset.bookId = book.bookId;
        deleteBtn.title = '삭제';
        deleteBtn.textContent = '×';
        card.appendChild(deleteBtn);

        // 배경 이미지
        const bgImg = document.createElement('img');
        bgImg.className = 'bg-img';
        bgImg.src = img;
        bgImg.alt = '';
        card.appendChild(bgImg);

        // 커버 이미지
        const coverImg = document.createElement('img');
        coverImg.className = 'cover-img';
        coverImg.src = img;
        coverImg.alt = book.title;
        card.appendChild(coverImg);

        // 카드 내용
        const content = document.createElement('div');
        content.className = 'card-content';
        content.innerHTML = '<div class="book-title">' + book.title + '</div><div class="book-author">' + book.author + '</div>';
        card.appendChild(content);

        // 카드 클릭 시 링크 이동 (X 버튼 제외)
        card.addEventListener('click', (e)=>{
          if(!e.target.classList.contains('wishlist-delete-btn')){
            window.open(book.link, '_blank');
          }
        });
        grid.appendChild(card);
      });
      con.appendChild(grid);
      attachWishlistHandlers(grid, items);
    }catch(e){
      con.innerHTML='<h2>찜목록</h2><p>불러오기 실패</p>';
    }
  }

  function attachWishlistHandlers(grid, items){
    const deleteAllBtn = document.getElementById('wishlist-delete-all-btn');

    // 개별 삭제 X 버튼 이벤트
    grid.querySelectorAll('.wishlist-delete-btn').forEach(btn=>{
      btn.addEventListener('click', async(e)=>{
        e.preventDefault();
        e.stopPropagation();
        const bookId = btn.dataset.bookId;
        const card = btn.closest('.card');
        const bookTitle = card.querySelector('.book-title').textContent;

        if(!confirm(`"${'${bookTitle}'}"을(를) 찜목록에서 삭제하시겠습니까?`)) return;

        try {
          const res = await fetch(contextPath+'/api/users/me/wishlists?bookId='+bookId, {method:'POST'});
          if(res.ok) {
            card.remove();
            // 찜목록이 비었는지 확인
            if(grid.querySelectorAll('.card').length === 0) {
              const con = document.getElementById('recent-history-content');
              con.innerHTML = '<h2>찜목록</h2><p style="text-align:center;padding:50px;">찜한 도서가 없습니다.</p>';
            }
          }
        } catch(err) {
          alert('삭제 중 오류가 발생했습니다.');
        }
      });
    });

    // 전체 삭제 버튼 이벤트
    if(deleteAllBtn){
      deleteAllBtn.addEventListener('click', async()=>{
        const cards = grid.querySelectorAll('.card');
        if(!cards.length) { alert('삭제할 항목이 없습니다.'); return; }
        if(!confirm(`찜목록의 모든 도서(${'${cards.length}'}권)를 삭제하시겠습니까?`)) return;

        try {
          await Promise.all(Array.from(cards).map(card=>{
            const id = card.dataset.bookId;
            return fetch(contextPath+'/api/users/me/wishlists?bookId='+id, {method:'POST'})
                   .then(r=>{ if(r.ok) card.remove(); });
          }));
          // 모두 삭제 후 빈 메시지 표시
          const con = document.getElementById('recent-history-content');
          con.innerHTML = '<h2>찜목록</h2><p style="text-align:center;padding:50px;">찜한 도서가 없습니다.</p>';
        } catch(err) {
          alert('삭제 중 오류가 발생했습니다.');
        }
      });
    }
  }

  /* ========================================================
  5.  나의 리뷰 목록 로드 (새로 추가)
======================================================= */
async function loadMyReviews(){
   const myReviewsListArea = document.getElementById('my-reviews-list-area');
   if(!myReviewsListArea) return;

   myReviewsListArea.innerHTML = '<p style="text-align:center;padding:20px;">나의 리뷰를 불러오는 중...</p>';

   try {
       const url = contextPath + '/api/myReviews';
       const res = await fetch(url);

       if(!res.ok) {
           const errorData = await res.json();
           throw new Error(errorData.error || `HTTP error! status: ${res.status}`);
       }
       
       const myReviews = await res.json();

       myReviewsListArea.innerHTML = ' ';

       if(myReviews.length === 0) {
           myReviewsListArea.innerHTML = '<p style="text-align:center;padding:50px;">작성하신 리뷰가 없습니다.</p>';
           return;
       }

       const reviewsGrid = document.createElement('div');
       reviewsGrid.className = 'grid review-grid'; 

       myReviews.forEach(review => {
           console.log("Processing review object:", review); // 디버깅용 로그
           console.log("Review ID:", review.reviewId);
           console.log("Review Rating:", review.rating);
           console.log("Book Title:", review.bookTitle);


           const reviewLink = contextPath + '/reviewDetail?id=' + review.reviewId;
           const coverImg = review.bookCoverImageUrl ? review.bookCoverImageUrl : contextPath + '/img/icon2.png';
           const reviewTextPreview = review.reviewText.length > 80 ? review.reviewText.substring(0, 80) + '...' : review.reviewText;

           const reviewCard = document.createElement('div');
           reviewCard.className = 'card';

           // --- 템플릿 리터럴 내부의 변수 참조 방식 및 별점 렌더링 수정 ---
           // 'repeat()' 대신 Array.join()을 사용하며, 모든 변수에 ${'${변수}'} 형태를 적용합니다.
           reviewCard.innerHTML = `
               <a href="${'${reviewLink}'}" class="card-link">
                   <img class="bg-img" src="${'${coverImg}'}" alt="">
                   <img class="cover-img" src="${'${coverImg}'}" alt="${'${review.bookTitle}'}">
                   <div class="card-content">
                       <div class="book-title">${'${review.bookTitle}'}</div>
                       <div class="book-author">${'${review.bookAuthor}'}</div>
                       <p class="review-preview">${'${reviewTextPreview}'}</p>
                       <div class="rating">
                           ${'${Array(review.rating + 1).join("★")}'}${'${Array(5 - review.rating + 1).join("☆")}'}
                       </div>
                   </div>
               </a>
           `;
           reviewsGrid.appendChild(reviewCard);
       });

       myReviewsListArea.appendChild(reviewsGrid);

   } catch (error) {
       console.error('Error loading my reviews:', error);
       myReviewsListArea.innerHTML = '<p class="error-message" style="text-align:center;padding:50px;color:red;">나의 리뷰를 불러오는 데 실패했습니다: ' + error.message + '</p>';
   }
}
/* ========================================================
  6.  초기 표시 (찜목록 탭)
======================================================== */
hideAll();
const firstContent = document.getElementById('recent-history-content');
if(firstContent){firstContent.style.display='block';firstContent.classList.add('active');}
const firstSidebarLink = document.querySelector('.sidebar-menu a[data-content="recent-history"]');
if(firstSidebarLink) firstSidebarLink.classList.add('active');
loadWishlist();  // 최초 찜목록 조회

/* ========================================================
  7.  프로필 이미지 업로드 기능
======================================================== */
const profileAddBtn = document.getElementById('profile-add-btn');
const profileImageInput = document.getElementById('profile-image-input');

if(profileAddBtn && profileImageInput) {
    // + 버튼 클릭 시 파일 선택 창 열기
    profileAddBtn.addEventListener('click', () => {
        profileImageInput.click();
    });

    // 파일 선택 시 업로드 처리
    profileImageInput.addEventListener('change', async (e) => {
        const file = e.target.files[0];
        if(!file) return;

        // 파일 크기 체크 (5MB)
        if(file.size > 5 * 1024 * 1024) {
            alert('파일 크기는 5MB 이하만 가능합니다.');
            return;
        }

        // 이미지 파일 여부 체크
        if(!file.type.startsWith('image/')) {
            alert('이미지 파일만 업로드 가능합니다.');
            return;
        }

        const formData = new FormData();
        formData.append('profileImage', file);

        try {
            const res = await fetch(contextPath + '/api/uploadProfileImage', {
                method: 'POST',
                body: formData
            });

            const result = await res.json();

            if(res.ok && result.success) {
                alert('프로필 이미지가 변경되었습니다.');
                // 페이지 새로고침하여 새 이미지 표시
                window.location.reload();
            } else {
                alert(result.message || '프로필 이미지 업로드에 실패했습니다.');
            }
        } catch(error) {
            console.error('프로필 이미지 업로드 오류:', error);
            alert('프로필 이미지 업로드 중 오류가 발생했습니다.');
        }

        // 같은 파일 재선택 가능하도록 초기화
        profileImageInput.value = '';
    });
}

}); /* DOMContentLoaded 끝 */
</script>


</body>
</html>