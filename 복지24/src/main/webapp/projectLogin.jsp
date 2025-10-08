<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: #fafafa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .top-header {
            padding: 20px 40px;
        }

        .header-logo {
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            color: #333;
            width: fit-content;
            transition: opacity 0.2s ease;
        }

        .header-logo:hover {
            opacity: 0.7;
        }

        .header-logo-icon {
            width: 40px;
            height: 40px;
            background-image: url('resources/image/복지로고.png');
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
        }

        .header-logo-text {
            font-size: 24px;
            font-weight: 700;
        }

        .main-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: -20px;
        }
        
        .login-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            width: 100%;
            max-width: 450px;
            padding: 20px;
        }
        
        .login-card {
            background: white;
            border: 1px solid #dbdbdb;
            border-radius: 8px;
            padding: 50px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .logo {
            font-size: 32px;
            font-weight: 700;
            color: #333;
            margin-bottom: 8px;
        }

        .subtitle {
            font-size: 16px;
            color: #8e8e8e;
            margin-bottom: 30px;
            font-weight: 400;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-input {
            width: 100%;
            padding: 15px 20px;
            border: 1px solid #dbdbdb;
            border-radius: 6px;
            font-size: 16px;
            background-color: #fafafa;
            transition: border-color 0.2s ease;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #0095f6;
            background-color: white;
        }
        
        .form-input::placeholder {
            color: #8e8e8e;
        }
        
        .login-btn {
            width: 100%;
            padding: 15px;
            background-color: #000000;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
            transition: background-color 0.2s ease;
        }
        
        .login-btn:hover {
            background-color: #333333;
        }
        
        .login-btn:disabled {
            background-color: #b2dffc;
            cursor: not-allowed;
        }
        
        .divider {
            display: flex;
            align-items: center;
            margin: 20px 0;
        }
        
        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background-color: #dbdbdb;
        }
        
        .divider span {
            margin: 0 18px;
            color: #8e8e8e;
            font-size: 13px;
            font-weight: 600;
        }
        
        .forgot-password {
            color: #00376b;
            font-size: 12px;
            text-decoration: none;
            margin-top: 15px;
            display: inline-block;
        }
        
        .forgot-password:hover {
            text-decoration: underline;
        }
        
        .bottom-links {
            text-align: center;
            margin-top: 20px;
        }

        .bottom-links a {
            color: #8e8e8e;
            font-size: 14px;
            text-decoration: none;
            margin: 0 15px;
        }

        .bottom-links a:hover {
            text-decoration: underline;
        }
        
        .signup-link {
            color: #0095f6;
            text-decoration: none;
            font-weight: 600;
        }
        
        .signup-link:hover {
            text-decoration: underline;
        }

        .social-login {
            margin: 20px 0;
        }

        .social-icons {
            display: flex;
            justify-content: center;
            gap: 15px;
        }

        .social-icon {
            width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: transform 0.2s ease;
        }

        .social-icon:hover {
            transform: scale(1.1);
        }

        .social-icon img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }
    </style>
</head>
<body>
    <header class="top-header">
        <a href="project.jsp" class="header-logo">
            <div class="header-logo-icon"></div>
            <span class="header-logo-text">복지24</span>
        </a>
    </header>

    <div class="main-wrapper">
        <div class="login-container">
        <div class="login-card">
            <div class="logo">복지24</div>
            <div class="subtitle">로그인</div>
            
            <form id="loginForm">
                <div class="form-group">
                    <input type="text" class="form-input" name="username" placeholder="이메일을 입력하세요" required>
                </div>
                
                <div class="form-group">
                    <input type="password" class="form-input" name="password" placeholder="비밀번호를 입력하세요" required>
                </div>
                
                <button type="submit" class="login-btn">이메일로 로그인</button>
            </form>
            
            <div class="divider">
                <span>또는</span>
            </div>

            <div class="social-login">
                <div class="social-icons">
                    <div class="social-icon naver" onclick="loginWithNaver()">
                        <img src="resources/image/naver.png" alt="네이버 로그인">
                    </div>
                    <div class="social-icon kakao" onclick="loginWithKakao()">
                        <img src="resources/image/kakao.png" alt="카카오톡 로그인">
                    </div>
                    <div class="social-icon google" onclick="loginWithGoogle()">
                        <img src="resources/image/google.png" alt="구글 로그인">
                    </div>
                    <div class="social-icon apple" onclick="loginWithApple()">
                        <img src="resources/image/apple.png" alt="애플 로그인">
                    </div>
                    <div class="social-icon facebook" onclick="loginWithFacebook()">
                        <img src="resources/image/facebook.png" alt="페이스북 로그인">
                    </div>
                </div>
            </div>

            <div class="bottom-links">
                <a href="project_register.jsp">회원가입</a>
                <a href="projectFindAccount.jsp">아이디/비밀번호 찾기</a>
            </div>
        </div>
        </div>
    </div>
    
    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            const username = formData.get('username');
            const password = formData.get('password');
            
            console.log('로그인 시도:', { username, password });
            alert('로그인 성공! (개발 중)');
        });
        
        document.querySelectorAll('.form-input').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('focused');
            });

            input.addEventListener('blur', function() {
                this.parentElement.classList.remove('focused');
            });
        });

        // 소셜 로그인 함수들
        function loginWithNaver() {
            window.location.href = 'https://nid.naver.com/nidlogin.login';
        }

        function loginWithKakao() {
            window.location.href = 'https://accounts.kakao.com/login';
        }

        function loginWithGoogle() {
            window.location.href = 'https://accounts.google.com/signin';
        }

        function loginWithApple() {
            window.location.href = 'https://appleid.apple.com/';
        }

        function loginWithFacebook() {
            window.location.href = 'https://www.facebook.com/login';
        }
    </script>
</body>
</html>