<%-- header.jsp (최종 수정 버전) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>

<%--
    [수정] 이 파일이 단독으로 동작하도록 변수 선언을 제거하고,
    session과 request 객체를 직접 사용하도록 변경합니다.
--%>
<header>
    <div id="logo">
        <a href="<%= request.getContextPath() %>/main.jsp">
            <img src="<%= request.getContextPath() %>/img/logo.png" alt="로고">
        </a>
    </div>

    <%@ include file="searchBar.jsp" %>

    <div id="user-buttons">
        <%--
            변수 loggedInUser를 사용하는 대신, session에서 직접 User 객체를 가져와 확인합니다.
            이렇게 하면 다른 페이지에 변수가 있든 없든 이 파일은 독립적으로 동작합니다.
        --%>
        <% if (session.getAttribute("loggedInUser") == null) { %>
            <button id="join-btn" onclick="location.href='<%= request.getContextPath() %>/register.jsp'">회원가입</button>
            <button id="login-btn" onclick="location.href='<%= request.getContextPath() %>/login.jsp'">로그인</button>
        <% } else { %>
            <%--
                매번 session에서 값을 가져와야 하므로, 편의를 위해 여기서만 사용할 임시 변수를 만듭니다.
                이 변수는 이 <% %> 블록 안에서만 유효하므로 다른 파일과 충돌하지 않습니다.
            --%>
            <% User tempUser = (User) session.getAttribute("loggedInUser"); %>
            <span class="welcome-message">환영합니다, <%= tempUser.getNickname() %>님!</span>
            <a href="<%= request.getContextPath() %>/mypage.jsp" class="header-action-btn">마이페이지</a>
            <a href="<%= request.getContextPath() %>/doLogout" class="header-action-btn" onclick="return confirm('정말 로그아웃 하시겠습니까?');">로그아웃</a>
        <% } %>
    </div>
    
    
</header>
