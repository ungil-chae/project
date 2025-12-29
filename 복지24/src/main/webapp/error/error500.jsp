<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>서버 오류 - 복지24</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: #ffffff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .error-container {
            text-align: center;
            padding: 40px 30px;
            max-width: 450px;
        }
        .error-icon-wrapper {
            width: 120px;
            height: 140px;
            margin: 0 auto 30px;
        }
        .chat-bubble {
            width: 120px;
            height: 100px;
            background: linear-gradient(180deg, #4A90E2 0%, #3a7bc8 100%);
            border-radius: 20px;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 10px 40px rgba(74, 144, 226, 0.3);
        }
        .chat-bubble::after {
            content: '';
            position: absolute;
            bottom: -15px;
            left: 50%;
            transform: translateX(-50%);
            border-left: 15px solid transparent;
            border-right: 15px solid transparent;
            border-top: 20px solid #3a7bc8;
        }
        .chat-bubble i {
            font-size: 45px;
            color: white;
        }
        .error-title {
            font-size: 22px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 15px;
        }
        .error-message {
            font-size: 15px;
            color: #64748b;
            line-height: 1.8;
            margin-bottom: 30px;
        }
        .btn-home {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            max-width: 280px;
            background: linear-gradient(180deg, #4A90E2 0%, #3a7bc8 100%);
            color: white;
            padding: 14px 30px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(74, 144, 226, 0.3);
        }
        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(74, 144, 226, 0.4);
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon-wrapper">
            <div class="chat-bubble">
                <i class="fas fa-exclamation"></i>
            </div>
        </div>

        <h1 class="error-title">Internal Server Error</h1>
        <p class="error-message">
            일시적인 서버 장애로 인하여 페이지에 접속할 수 없습니다.<br>
            잠시 후 다시 시도해 주시기 바랍니다.
        </p>

        <a href="${pageContext.request.contextPath}/project.jsp" class="btn-home">
            복지24 홈으로
        </a>
    </div>
</body>
</html>
