<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <title>greenart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>    
	<style>
		* { 
	    box-sizing: border-box; 
	    margin : 0;
	    padding: 0;
	}
	
	a { text-decoration: none;  }
	
	ul {
	    list-style-type: none;
	    height: 48px;
	    width: 100%;
	    background-color: #93CC8D;
	    display: flex;
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
	}
	
	ul > li > a:hover {
	    color :lightgray;
	    border-bottom: 3px solid rgb(209, 209, 209);
	}
	
	#logo {
		color:white;
	    font-size: 18px;
	    padding-left:40px; 
	    margin-right:auto;
	    display: flex;
	}
	</style>
</head>
<body>
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
<div style="text-align:center">
	<h1>홈 화면</h1>
</div>
</body>
</html>

