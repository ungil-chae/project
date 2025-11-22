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
<%@ include file="css/main_css.jsp"%>

<style>
/* ────────── 찜 카드 축소 & 체크박스 토글 ────────── */
.grid {
   display: grid;
   grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
   gap: 20px;
   justify-content: center
}

.grid>.card {
   width: 120px !important;
   max-width: 120px !important;
   position: relative;
   text-decoration: none
}

.grid>.card img {
   width: 100% !important;
   height: auto !important;
   display: block
}

.grid>.card .bg-img {
   position: absolute;
   inset: 0;
   object-fit: cover;
   filter: blur(8px);
   opacity: .35;
   transform: scale(1.1)
}

.grid>.card .cover-img {
   position: relative;
   z-index: 1
}

/* 체크박스 기본 숨김 → delete-mode 에서만 표시 */
.wishlist-item-checkbox {
   display: none
}

.delete-mode .wishlist-item-checkbox {
   display: block
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

   <div class="main-content-wrapper">
      <div class="sidebar">
         <div class="profile">
            <img src="<%=contextPath%>/img/사진.jpg" alt="프로필사진" class="image">
            <%
            String nicknameDisplay = (loggedInUser != null) ? loggedInUser.getNickname() : "Guest";
            %>
            <p class="nickname-display"><%=nicknameDisplay%></p>
            <div class="link-group">
               <a href="#" class="a">찜</a>
            </div>
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
                        <%-- 
                  - a 태그: 책의 상세 링크(book.link)로 이동합니다.
                  - title 속성: 마우스를 올렸을 때 책 제목과 저자를 보여줍니다.
                --%>
                        <a href="${book.link}" target="_blank"
                           title="${book.title} | ${book.author}"> <%-- 
                      - img 태그: 책 이미지(book.image)를 표시합니다.
                      - style 속성: CSS 파일과 별개로 이미지 크기, 그림자 등 간단한 스타일을 직접 적용했습니다.
                    --%> <img src="${book.image}" alt="${book.title}"
                           style="width: 100px; height: 145px; object-fit: cover; margin: 0 5px; border-radius: 4px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);">
                        </a>
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
               <div id="my-reviews-list-area" class="grid review-grid">
                  <p style="text-align: center; padding: 20px;">작성하신 리뷰들을 불러오는
                     중...</p>
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
                  <p>회원 탈퇴 시 모든 정보가 삭제되며 복구할 수 없습니다.</p>
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
        <label id="wishlist-select-all-wrapper" style="display:none;">
          <input type="checkbox" id="wishlist-select-all"> 전체 선택
        </label>
        <button id="wishlist-select-toggle-btn" class="wishlist-delete-selected-btn">선택 삭제</button>
        <button id="wishlist-cancel-btn" class="wishlist-cancel-btn" style="display:none;">취소</button>`;
      con.appendChild(controls);

      const grid=document.createElement('div'); grid.className='grid';
      items.forEach(book=>{
        const img = book.coverImageUrl ? contextPath+'/'+book.coverImageUrl : contextPath+'/img/icon2.png';
        const a   = document.createElement('a');
        a.className='card'; a.href=`${'${book.link}'}`; a.target='_blank';
        a.dataset.bookId=`${'${book.bookId}'}`;
        a.innerHTML=`
          <input type="checkbox" class="wishlist-item-checkbox"
                 style="position:absolute;top:12px;left:12px;z-index:10;">
          <img class="bg-img"    src="${'${img}'}" alt="">
          <img class="cover-img" src="${'${img}'}" alt="${'${book.title}'}">
          <div class="card-content">
            <div class="book-title">${'${book.title}'}</div>
            <div class="book-author">${'${book.author}'}</div>
          </div>`;
        grid.appendChild(a);
      });
      con.appendChild(grid);
      attachWishlistHandlers(grid);
    }catch(e){
      con.innerHTML='<h2>찜목록</h2><p>불러오기 실패</p>';
    }
  }

  function attachWishlistHandlers(grid){
    const toggleBtn = document.getElementById('wishlist-select-toggle-btn');
    const cancelBtn = document.getElementById('wishlist-cancel-btn');
    const selectAllW= document.getElementById('wishlist-select-all-wrapper');
    const master    = document.getElementById('wishlist-select-all');
    let deleteMode  = false;

    if(master){
      master.onchange = e=>{
        grid.querySelectorAll('.wishlist-item-checkbox').forEach(cb=>cb.checked=e.target.checked);
      };
    }

    function enter(){
      deleteMode=true;
      grid.classList.add('delete-mode');
      selectAllW.style.display='inline-block';
      cancelBtn.style.display='inline-block';
      toggleBtn.textContent='삭제 실행';
    }
    function exit(){
      deleteMode=false;
      grid.classList.remove('delete-mode');
      selectAllW.style.display='none';
      cancelBtn.style.display='none';
      toggleBtn.textContent='선택 삭제';
      grid.querySelectorAll('.wishlist-item-checkbox').forEach(cb=>cb.checked=false);
      if(master) master.checked=false;
    }

    toggleBtn.addEventListener('click',async()=>{
      if(!deleteMode){enter();return;}
      const checked=grid.querySelectorAll('.wishlist-item-checkbox:checked');
      if(!checked.length){alert('선택된 책이 없습니다.');return;}
      if(!confirm(`선택한 ${'${checked.length}'}권을 삭제하시겠습니까?`))return;
      await Promise.all(Array.from(checked).map(cb=>{
        const id=cb.closest('.card').dataset.bookId;
        return fetch(contextPath+'/api/users/me/wishlists?bookId='+id,{method:'POST'})
               .then(r=>{if(r.ok) cb.closest('.card').remove();});
      }));
      exit();
    });
    cancelBtn.addEventListener('click',exit);
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

}); /* DOMContentLoaded 끝 */
</script>


</body>
</html>