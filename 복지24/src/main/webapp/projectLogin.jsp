<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="resources/css/projectLogin.css">
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
        const contextPath = '${pageContext.request.contextPath}';
    </script>
    <script src="resources/js/projectLogin.js"></script>
</body>
</html>
