<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- ─────────── 검색 입력창 + 버튼 ─────────── -->
<div class="search-group">
  <input type="text" id="search-box" placeholder="검색어를 입력하세요..." class="search-input"/>
  <button type="button" id="search-btn" class="search-button">검색</button>
</div>

<!-- ─────────── 검색 전용 JS ─────────── -->
<script>
document.addEventListener('DOMContentLoaded', () => {
  /* ❗ contextPath를 변수로 새로 만들지 말고, 표현식으로 바로 삽입 */
  const contextPath = "<%= request.getContextPath() %>";

  const searchInput = document.getElementById('search-box');
  const searchBtn   = document.getElementById('search-btn');

  function goToMain() {
    const q = searchInput.value.trim();
    if (!q) { alert('검색어를 입력하세요.'); return; }
    location.href = contextPath + '/main.jsp?query=' + encodeURIComponent(q);
  }

  searchBtn.addEventListener('click', goToMain);
  searchInput.addEventListener('keypress', e => {
    if (e.key === 'Enter') { e.preventDefault(); goToMain(); }
  });
});
</script>

