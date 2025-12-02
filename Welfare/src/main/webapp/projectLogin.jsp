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
            background-color: #4A90E2;
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
            background-color: #357ABD;
        }
        
        .login-btn:disabled {
            background-color: #b2dffc;
            cursor: not-allowed;
        }

        /* 로그인 상태 유지 체크박스 스타일 */
        .remember-me {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            margin: 16px 0;
            gap: 8px;
        }

        .remember-me input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #4A90E2;
        }

        .remember-me label {
            font-size: 14px;
            color: #333;
            cursor: pointer;
            user-select: none;
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
        <a href="${pageContext.request.contextPath}/project.jsp" class="header-logo">
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
                    <input type="email" class="form-input" name="email" placeholder="이메일을 입력하세요" required>
                </div>

                <div class="form-group">
                    <input type="password" class="form-input" name="password" placeholder="비밀번호를 입력하세요" required>
                </div>

                <div class="remember-me">
                    <input type="checkbox" id="rememberMe" name="rememberMe">
                    <label for="rememberMe">로그인 상태 유지</label>
                </div>

                <button type="submit" class="login-btn">로그인</button>
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
                <a href="${pageContext.request.contextPath}/project_register.jsp">회원가입</a>
                <a href="${pageContext.request.contextPath}/project_findAccount.jsp">아이디 / 비밀번호 찾기</a>
            </div>
        </div>
        </div>
    </div>
    
    <script>
        console.log('=== Script loaded ===');
        const contextPath = '${pageContext.request.contextPath}';
        console.log('contextPath:', contextPath);

        // 페이지 로드 완료 대기
        window.addEventListener('DOMContentLoaded', function() {
            console.log('=== DOM loaded ===');

            const loginForm = document.getElementById('loginForm');
            console.log('loginForm element:', loginForm);

            if (!loginForm) {
                console.error('로그인 폼을 찾을 수 없습니다!');
                return;
            }

            // 로그인 폼 AJAX 제출
            loginForm.addEventListener('submit', function(e) {
                console.log('=== Form submitted ===');
                e.preventDefault();

                const formData = new FormData(this);
                const email = formData.get('email');
                const password = formData.get('password');
                const rememberMe = document.getElementById('rememberMe').checked;

                console.log('email:', email);
                console.log('password:', password ? '***' : 'null');
                console.log('rememberMe:', rememberMe);

                const loginUrl = contextPath + '/api/auth/login';
                console.log('Login URL:', loginUrl);

                const requestBody = 'email=' + encodeURIComponent(email) +
                                  '&password=' + encodeURIComponent(password) +
                                  '&rememberMe=' + encodeURIComponent(rememberMe);
                console.log('Request body:', requestBody);

                // AJAX 요청으로 로그인 처리
                fetch(loginUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: requestBody
                })
                .then(response => {
                    console.log('Response status:', response.status);
                    console.log('Response headers:', response.headers);
                    return response.json();
                })
                .then(data => {
                    console.log('Login response:', data);

                    if (data.success) {
                        // 로그인 성공 시 이전 사용자의 로컬 데이터 클리어
                        // (새로 가입한 경우나 다른 사용자가 로그인한 경우를 대비)
                        const lastLoggedInUser = localStorage.getItem('lastLoggedInUser');
                        if (lastLoggedInUser !== email) {
                            // 다른 사용자가 로그인하면 로컬 스토리지 클리어
                            localStorage.clear();
                            sessionStorage.clear();
                            localStorage.setItem('lastLoggedInUser', email);
                        }

                        // 메인 페이지로 이동
                        const redirectUrl = contextPath + '/project.jsp';
                        console.log('Redirecting to:', redirectUrl);
                        window.location.href = redirectUrl;
                    } else {
                        console.error('Login failed:', data.message);

                        // 계정 잠금 시 비밀번호 재설정 안내
                        if (data.locked) {
                            const resetPassword = confirm(data.message + '\n\n비밀번호를 재설정하시겠습니까?');
                            if (resetPassword) {
                                window.location.href = contextPath + '/project_resetPassword.jsp';
                            }
                        } else {
                            alert(data.message || '로그인 실패');
                        }
                    }
                })
                .catch(error => {
                    console.error('Fetch error:', error);
                    alert('로그인 중 오류가 발생했습니다: ' + error.message);
                });
            });
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