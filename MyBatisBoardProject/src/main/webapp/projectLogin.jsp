<%@ page language="java" contentType="text/html; charset=UTF-8"%>
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
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            width: 100%;
            max-width: 350px;
            padding: 20px;
        }
        
        .login-card {
            background: white;
            border: 1px solid #dbdbdb;
            border-radius: 8px;
            padding: 40px;
            text-align: center;
        }
        
        .logo {
            font-size: 32px;
            font-weight: 800;
            color: #333;
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #dbdbdb;
            border-radius: 6px;
            font-size: 14px;
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
            padding: 12px;
            background-color: #0095f6;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
            transition: background-color 0.2s ease;
        }
        
        .login-btn:hover {
            background-color: #1877f2;
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
        
        .signup-card {
            background: white;
            border: 1px solid #dbdbdb;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            font-size: 14px;
        }
        
        .signup-link {
            color: #0095f6;
            text-decoration: none;
            font-weight: 600;
        }
        
        .signup-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <a href="/bdproject/project.jsp" class="logo" style="text-decoration: none; color: inherit;">복지 24</a>
            
            <form id="loginForm">
                <div class="form-group">
                    <input type="text" class="form-input" name="username" placeholder="사용자 이름 또는 이메일" required>
                </div>
                
                <div class="form-group">
                    <input type="password" class="form-input" name="password" placeholder="비밀번호" required>
                </div>
                
                <button type="submit" class="login-btn">로그인</button>
            </form>
            
            <div class="divider">
                <span>또는</span>
            </div>
            
            <a href="#" class="forgot-password">비밀번호를 잊으셨나요?</a>
        </div>
        
        <div class="signup-card">
            계정이 없으신가요? <a href="#" class="signup-link">가입하기</a>
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
    </script>
</body>
</html>