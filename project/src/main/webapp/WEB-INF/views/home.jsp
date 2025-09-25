<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>복지 정보 시스템</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            background-color: #1e1e1e;
            color: white;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        .navbar {
            background-color: white;
            border-bottom: 1px solid #e0e0e0;
            padding: 0 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 80px;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        .navbar-left {
            display: flex;
            align-items: center;
            gap: 60px;
        }
        .logo {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 28px;
            color: black;
            font-weight: bold;
            text-decoration: none;
        }
        .logo-icon {
            width: 50px;
            height: 50px;
            background-image: url('resources/image/복지로고.png');
            background-size: 80%;
            background-repeat: no-repeat;
            background-position: center;
            background-color: white;
            border-radius: 6px;
        }
        .nav-menu {
            display: flex;
            gap: 50px;
        }
        .nav-link {
            color: #333;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        .nav-link:hover {
            background-color: #f7f9fc;
            color: #0061ff;
        }
        .navbar-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .login-btn {
            background-color: #0061ff;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }
        .login-btn:hover {
            background-color: #0052d4;
        }
        
        .main-content {
            padding: 80px 20px;
            text-align: center;
        }
        
        h1 {
            font-size: 48px;
            font-weight: 600;
            margin-bottom: 20px;
            line-height: 1.2;
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            .nav-menu {
                display: none;
            }
            
            .navbar {
                padding: 0 15px;
            }
            
            h1 {
                font-size: 32px;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-left">
            <a href="/" class="logo">
                <div class="logo-icon">
                </div>
                복지 24
            </a>
            
            <div class="nav-menu">
                <a href="/" class="nav-link">복지정보</a>
                <a href="/welfare" class="nav-link"></a>
                <a href="/apply" class="nav-link">신청하기</a>
                <a href="/mypage" class="nav-link">마이페이지</a>
                <a href="/support" class="nav-link">공지사항</a>
            </div>
        </div>
        
        <div class="navbar-right">
            <button class="login-btn">로그인</button>
        </div>
    </nav>
    
    <div class="main-content">
        <h1>복지 24, 대한민국의 모든 복지 혜택을 한곳으로 불러 모은 공간</h1>
    </div>
    
</body>
</html>