<%@ page import="java.net.URLDecoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css" />
    <style>
        * { 
        	box-sizing:border-box; 
        	font-size:15px;
		    font-family: 'NanumSquareNeo-Variable';        	
        }
		@font-face {
		    font-family: 'OAGothic-ExtraBold';
		    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2302@1.0/OAGothic-ExtraBold.woff2') format('woff2');
		    font-weight: 800;
		    font-style: normal;
		}
		@font-face {
		    font-family: 'NanumSquareNeo-Variable';
		    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_11-01@1.0/NanumSquareNeo-Variable.woff2') format('woff2');
		    font-weight: normal;
		    font-style: normal;
		}
        form {
            width:400px;
            height:600px;
            display : flex;
            flex-direction: column;
            align-items:center;
            position : absolute;
            top:50%;
            left:50%;
            transform: translate(-50%, -50%) ;
            border: 1px solid #004D40;
            border-radius: 10px;
        }

        .input-field {
            width: 300px;
            height: 50px;
            border : 1px solid #004D40;
            border-radius:5px;
            padding: 0 10px;
            margin: 4px 0;
        }
        label {
          	font-family:'NanumSquareNeo-Variable';
            width:300px;
            height:30px;
            margin: 5px 0;
        }

        #input-submit{
        	font-family:'NanumSquareNeo-Variable';
            background-color: #004D40;
            color : white;
            width:300px;
            padding:10px;
            height:50px;
            font-size: 17px;
            border : none;
            border-radius: 5px;
            margin : 20px 0 30px 0;
        }
 		#input-submit:hover{
 			cursor:pointer;
 		}	
    	.title {
        	font-family:OAGothic-ExtraBold;
            font-size : 50px;
            margin: 40px 0 30px 0;
            color:#004D40
        }

        .msg {
            height: 30px;
            text-align:center;
            font-size:16px;
            color:red;
            margin-bottom: 20px;
        }
        .sns-chk {
            margin-top : 5px; 
        }
    </style>
    <title>Register</title>
    <link rel="stylesheet" type="text/css" href="index.css">
</head>
<body>
	<form id="user" name="registerform" action="RegisterTest.jsp" method="post" onsubmit="return formCheck(this)"> 	
	    <div class="title">Register</div>
	    
	    <div id="msg" class="msg"></div> 
	    <label for="id">아이디</label>
	    <input class="input-field" id="id" type="text" name="id" placeholder="8~12자리의 영대소문자와 숫자 조합" autofocus>
	    <label for="pwd">비밀번호</label>
	    <input class="input-field" id="pwd" type="password" name="pwd" placeholder="8~12자리의 영대소문자와 숫자 조합">
	    <label for="cpwd">비밀번호확인</label>
	    <input class="input-field" id="cpwd" type="password" name="cpwd" placeholder="8~12자리의 영대소문자와 숫자 조합">
	    <label for="name">이름</label>
	    <input class="input-field"  id="name" type="text" name="name" 	placeholder="홍길동">
	    <label for="email">이메일</label>
	    <input class="input-field"  id="email" type="email" name="email" placeholder="example@greenart.co.kr"> 
	    <label for="birth">생일</label>
	    <input class="input-field" id="birth" type="text" name="birth" placeholder="2022/12/15" >
	    <div class="sns-chk">
	        <label><input type="checkbox" name="sns" value="facebook"/>페이스북</label>
	        <label><input type="checkbox" name="sns" value="kakaotalk"/>카카오톡</label>
	        <label><input type="checkbox" name="sns" value="instagram"/>인스타그램</label>
	    </div>
	    <input id="input-submit" type="submit" value="회원가입"></input>
   </form> 
 

   <script src="https://kit.fontawesome.com/fd1f3e5f64.js" crossorigin="anonymous"></script>
   <script>
		function formCheck(frm) {
		     var msg ='';
		
		     if(frm.id.value.length<3) {
		         setMessage('id의 길이는 3이상이어야 합니다.', frm.id);
		         return false;
		     }
		
		    return true;
		}
		
		function setMessage(msg, element){
/* 		     document.getElementById("msg").innerHTML = 
		    	 `<i class="fa-sharp fa-solid fa-triangle-exclamation">${'${msg}'}</i>`; */
		     document.querySelector("#msg").innerText = msg;
		
		     if(element) {
		         element.focus();
		     }
		}
   </script>
   
</body>
</html>