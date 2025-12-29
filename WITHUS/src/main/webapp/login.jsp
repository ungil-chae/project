<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - 책 추천 웹사이트</title>
    <%@ include file="css/main_css.jsp" %>
    <link rel="icon" href="img/icon2.png" type="image/x-icon">
    <style>
        /* login.jsp와 register.jsp에 공통으로 적용될 스타일 */
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 0;
            background-color: #f8fcf7; /* 약간 더 밝은 배경색 */
            flex-direction: column; /* 로고와 컨테이너를 세로로 정렬 */
        }

        .auth-logo-container { /* 새로 추가된 로고 컨테이너 스타일 */
            margin-bottom: 30px; /* 폼과의 간격 */
            text-align: center;
        }

        .auth-logo-container img {
            width: 200px; /* 로고 크기 */
            height: auto;
            cursor: pointer;
        }

        .login-container, .register-container {
            background-color: #eff7e8;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 380px;
            max-width: 90%;
            text-align: center;
            box-sizing: border-box;
        }

        .login-container h2, .register-container h2 {
            color: #446b3c;
            margin-bottom: 30px;
            font-size: 28px;
        }

        .input-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .input-group label {
            display: block;
            margin-bottom: 8px;
            color: #666;
            font-weight: bold;
        }

        .input-group input[type="text"],
        .input-group input[type="password"],
        .input-group input[type="email"],
        .input-group select,
        .input-group input[type="radio"] + label { /* 라디오 버튼 라벨 스타일 조정 */
            width: calc(100% - 20px);
            padding: 12px 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
            background-color: #fff;
        }
        
        .input-group.gender-group { /* 성별 그룹 스타일 */
            display: flex;
            align-items: center;
            justify-content: flex-start;
            gap: 15px;
        }
        .input-group.gender-group label {
            display: inline-block;
            margin-right: 5px;
            margin-bottom: 0;
        }
        .input-group.gender-group input[type="radio"] {
            width: auto; /* 라디오 버튼 너비 조정 */
        }


        .btn-login, .btn-register {
            background-color: #446b3c;
            color: #fff;
            border: none;
            padding: 15px 25px;
            border-radius: 5px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.3s, color 0.3s;
            margin-top: 20px;
        }

        .btn-login:hover, .btn-register:hover {
            background-color: #2e4f25;
        }

        .links-group {
            margin-top: 25px;
            font-size: 14px;
        }

        .links-group a {
            color: #446b3c;
            text-decoration: none;
            margin: 0 10px;
            font-weight: bold;
        }

        .links-group a:hover {
            text-decoration: underline;
        }

        #error-message {
            color: #d9534f;
            margin-top: 15px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="auth-logo-container">
        <a href="main.jsp">
            <img src="img/logo.png" alt="WITHUS 로고">
        </a>
    </div>

    <div class="login-container">
        <h2>로그인</h2>
        <form id="loginForm">
            <div class="input-group">
                <label for="username">사용자 이름</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="input-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit" class="btn-login">로그인</button>
        </form>
        <div id="error-message"></div>

        <div class="links-group">
            <a href="register.jsp">회원가입</a>
            <span>|</span>
            <a href="#">비밀번호 찾기</a>
        </div>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', async function(event) {
            event.preventDefault();

            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const errorMessageDiv = document.getElementById('error-message');

            try {
                const response = await fetch('api/auth/login', { // 상대 경로로 변경
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ username: username, password: password })
                });

                const apiResponse = await response.json();

                if (apiResponse.status === 'success') {
                    alert(apiResponse.message);
                    window.location.href = 'main.jsp'; // 메인 페이지 URL
                } else {
                    errorMessageDiv.textContent = apiResponse.message || '로그인에 실패했습니다.';
                }
            } catch (error) {
                console.error('로그인 요청 중 오류 발생:', error);
                errorMessageDiv.textContent = '서버와 통신 중 오류가 발생했습니다.';
            }
        });
    </script>
</body>
</html>