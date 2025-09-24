<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <title>복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>    
	<style>
		* { 
	    box-sizing: border-box; 
	    margin : 0;
	    padding: 0;
	}
	
	body {
		background: linear-gradient(135deg, #f0f8f0, #e8f5e8);
		font-family: 'Arial', sans-serif;
		min-height: 100vh;
	}
	
	a { text-decoration: none;  }
	
	ul {
	    list-style-type: none;
	    height: 48px;
	    width: 100%;
	    background: linear-gradient(90deg, #93CC8D, #7AB872);
	    display: flex;
	    box-shadow: 0 3px 8px rgba(115, 184, 114, 0.3);
	}
	
	ul > li {
	    color: lightgray;
	    height : 100%;
	    width:90px;
	    display:flex;
	    align-items: center;
	}
	
	ul > li > a {
	    color: white;
	    margin:auto;
	    padding: 10px;
	    font-size:20px;
	    align-items: center;
	    transition: all 0.3s ease;
	}
	
	ul > li > a:hover {
	    color: #f0f8f0;
	    border-bottom: 3px solid rgba(240, 248, 240, 0.8);
	}
	
	#logo {
		color:white;
	    font-size: 18px;
	    padding-left:40px; 
	    margin-right:auto;
	    display: flex;
	    font-weight: bold;
	}
	
	/* 게시판 컨테이너 스타일 */
	.board-container {
		text-align: center;
		max-width: 1250px;
		margin: 80px auto;
		padding: 40px;
		background-color: white;
		border-radius: 12px;
		box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	}
	
	.board-container h1 {
		color: #333;
		margin-bottom: 40px;
		font-size: 28px;
		border-bottom: 3px solid #93CC8D;
		padding-bottom: 15px;
		display: inline-block;
	}
	
	/* 테이블 스타일 */
	table {
		width: 100%;
		border-collapse: collapse;
		background-color: white;
		border-radius: 8px;
		overflow: hidden;
		border: 1px solid #e9ecef;
		margin-top: 20px;
	}
	
	th {
		background-color: #7BAF7C;
		color: white;
		padding: 15px 10px;
		text-align: center;
		font-weight: bold;
		font-size: 16px;
	}
	
	td {
		padding: 12px 10px;
		text-align: center;
		border-bottom: 1px solid #e9ecef;
		color: #333;
	}
	
	tr:nth-child(even) {
		background-color: #f8f9fa;
	}
	
	tr:hover {
		background-color: #e8f5e8;
		transition: background-color 0.2s ease;
	}
	
	/* 테이블 헤더별 너비 조정 */
	th:nth-child(1), td:nth-child(1) { width: 10%; }  /* 번호 */
	th:nth-child(2), td:nth-child(2) { width: 45%; } /* 제목 */
	th:nth-child(3), td:nth-child(3) { width: 15%; } /* 아이디 */
	th:nth-child(4), td:nth-child(4) { width: 20%; } /* 등록일 */
	th:nth-child(5), td:nth-child(5) { width: 10%; } /* 조회수 */
	
	/* 제목 컬럼 스타일 */
	td:nth-child(2) {
		text-align: left;
		padding-left: 20px;
		cursor: pointer;
	}
	
	td:nth-child(2):hover {
		color: #93CC8D;
		font-weight: bold;
	}
	
	/* 반응형 디자인 */
	@media (max-width: 768px) {
		.board-container {
			margin: 30px 15px;
			padding: 25px 15px;
		}
		
		table {
			font-size: 14px;
		}
		
		th, td {
			padding: 8px 5px;
		}
		
		th:nth-child(4), td:nth-child(4),
		th:nth-child(5), td:nth-child(5) {
			display: none;
		}
		
		th:nth-child(2), td:nth-child(2) { width: 65%; }
		th:nth-child(3), td:nth-child(3) { width: 25%; }
	}
	/* 페이지 네비게이션 스타일 */
	#page {
		margin-top: 40px;
		text-align: center;
		padding: 20px 0;
	}
	
	#page a {
		display: inline-block;
		padding: 10px 15px;
		margin: 0 5px;
		background: linear-gradient(135deg, #ffffff, #f8fdf8);
		color: #4a7c59;
		text-decoration: none;
		border: 1px solid rgba(147, 204, 141, 0.3);
		border-radius: 6px;
		font-weight: 500;
		transition: all 0.3s ease;
		box-shadow: 0 2px 4px rgba(147, 204, 141, 0.1);
	}
	
	#page a:hover {
		background: linear-gradient(135deg, #93CC8D, #7AB872);
		color: white;
		border-color: #7AB872;
		box-shadow: 0 4px 8px rgba(147, 204, 141, 0.3);
		transform: translateY(-1px);
	}
	
	/* 현재 페이지 스타일 (활성화된 페이지용) */
	#page a.active {
		background: linear-gradient(135deg, #93CC8D, #7AB872);
		color: white;
		border-color: #7AB872;
		font-weight: bold;
		box-shadow: 0 2px 4px rgba(147, 204, 141, 0.2);
	}
	
	#page a.active:hover {
		transform: none;
		box-shadow: 0 2px 4px rgba(147, 204, 141, 0.2);
	}
	
	/* 이전/다음 버튼 스타일 */
	#page a.step{
		background: linear-gradient(135deg, #f0f8f0, #e8f5e8);
		border-color: rgba(147, 204, 141, 0.4);
		font-weight: bold;
		min-width: 60px;
	}
	</style>
</head>
<body>
<h1>${check }</h1>
<div id="menu">
	<ul>
	    <li id="logo">greenart</li>
	    <li><a href="<c:url value='/'/>">Home</a></li>
	    <li><a href="<c:url value='/board/list'/>">Board</a></li> 
	    <li><a href="<c:url value='/register/add'/>">Sign in</a></li>
	    <c:choose>
	    	<c:when test="${empty sessionScope.id }">
			    <li><a href="<c:url value='/login/login'/>">login</a></li>
	    	</c:when>
	    	<c:otherwise>
			    <li><a href="<c:url value='/login/logout'/>">logout</a></li>
	    	</c:otherwise>
	    </c:choose>
	    <li><a href=""><i class="fas fa-search small"></i></a></li>
	</ul> 
</div>
<div class="board-container">
	<h1>게시판 화면</h1>
	<table>
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>아이디</th>
			<th>등록일</th>
			<th>조회수</th>
		</tr>
		<c:forEach items="${list}" var="b">
			<tr>
				<td>${b.bno }</td>
				<td><a href="<c:url value='/board/read?bno=${b.bno }'/>"> ${b.title }</a></td>
				<td>${b.writer }</td>
				<td>${b.regDate }</td>
				<td>${b.viewCnt }</td>
			</tr>
		</c:forEach>
	</table>
	<div id="page">
		<c:if test="${ph.showPrev }">
			<a class="step" href='<c:url value="/board/list?page=${ph.beginPage-1 }"/>'>이전</a>
		</c:if>
		<c:forEach begin="${ph.beginPage }" end="${ph.endPage }" var="i">
			 <a class="${i == ph.page ? 'active' : ''}" 
			 	href='<c:url value="/board/list?page=${i }"/>'>${i }</a>
		</c:forEach>
		<c:if test="${ph.showNext }">
			<a class="step" href='<c:url value="/board/list?page=${ph.endPage+1 }"/>'>다음</a>
		</c:if>
	</div>
</div>
</body>
</html>