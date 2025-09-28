<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .signup-container {
            background: white;
            border-radius: 12px;
            padding: 40px 30px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        .signup-container.expanded {
            max-width: 400px;
        }

        h1 {
            font-size: 28px;
            font-weight: 600;
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .initial-form {
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 150px;
            justify-content: center;
        }

        .email-group {
            width: 100%;
            transition: all 0.3s ease;
        }

        .input-with-button {
            display: flex;
            gap: 10px;
        }

        .input-with-button input {
            flex: 1;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="tel"] {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            transition: border-color 0.2s;
        }

        input:focus {
            outline: none;
            border-color: #0084ff;
        }

        .check-btn {
            padding: 14px 20px;
            background-color: #6c757d;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            white-space: nowrap;
            transition: background-color 0.2s;
        }

        .check-btn:hover {
            background-color: #5a6268;
        }

        .check-btn:disabled {
            background-color: #e0e0e0;
            cursor: not-allowed;
        }

        .additional-fields {
            max-height: 0;
            overflow: hidden;
            opacity: 0;
            transition: all 0.5s ease;
        }

        .additional-fields.show {
            max-height: 500px;
            opacity: 1;
            margin-top: 10px;
        }

        .submit-btn {
            width: 100%;
            padding: 14px;
            background-color: #0084ff;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 10px;
        }

        .submit-btn:hover {
            background-color: #0073e6;
        }

        .submit-btn:disabled {
            background-color: #b0b0b0;
            cursor: not-allowed;
        }

        .divider {
            text-align: center;
            margin: 20px 0;
            color: #999;
            font-size: 14px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .divider.show {
            opacity: 1;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #666;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .login-link.show {
            opacity: 1;
        }

        .login-link a {
            color: #0084ff;
            text-decoration: none;
            font-weight: 500;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .error-message {
            color: #dc3545;
            font-size: 13px;
            margin-top: 5px;
            display: none;
        }

        .success-message {
            color: #28a745;
            font-size: 13px;
            margin-top: 5px;
            display: none;
        }

        .password-hint {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }

        input.error {
            border-color: #dc3545;
        }

        input.success {
            border-color: #28a745;
        }

        .fade-in {
            animation: fadeInUp 0.5s ease;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .initial-message {
            text-align: center;
            color: #666;
            font-size: 14px;
            margin-bottom: 20px;
            transition: opacity 0.3s ease;
        }

        .initial-message.hide {
            display: none;
        }
    </style>
</head>
<body>
    <div class="signup-container" id="signupContainer">
        <a href="/bdproject/project.jsp" style="text-decoration: none; color: inherit;"><h1>복지 24</h1></a>
        
        <form id="signupForm" action="/register/save" method="POST">
            <div class="initial-form">
                <p class="initial-message" id="initialMessage">회원가입을 시작하세요</p>
                
                <!-- 아이디/이메일 -->
                <div class="email-group">
                    <div class="form-group">
                        <div class="input-with-button">
                            <input type="email" 
                                   id="email" 
                                   name="email" 
                                   placeholder="아이디 또는 이메일"
                                   required>
                            <button type="button" 
                                    class="check-btn" 
                                    id="checkBtn"
                                    onclick="checkDuplicate()">
                                중복확인
                            </button>
                        </div>
                        <div class="error-message" id="emailError">이미 사용중인 이메일입니다.</div>
                        <div class="success-message" id="emailSuccess">사용 가능한 이메일입니다.</div>
                    </div>
                </div>
            </div>

            <!-- 추가 필드들 -->
            <div class="additional-fields" id="additionalFields">
                <!-- 비밀번호 -->
                <div class="form-group fade-in">
                    <input type="password" 
                           id="password" 
                           name="password" 
                           placeholder="비밀번호"
                           required>
                    <div class="password-hint">숫자, 특수문자 포함 8자 이상</div>
                    <div class="error-message" id="passwordError">비밀번호 형식이 올바르지 않습니다.</div>
                </div>

                <!-- 비밀번호 확인 -->
                <div class="form-group fade-in">
                    <input type="password" 
                           id="passwordConfirm" 
                           name="passwordConfirm" 
                           placeholder="비밀번호 확인"
                           required>
                    <div class="error-message" id="passwordConfirmError">비밀번호가 일치하지 않습니다.</div>
                </div>

                <!-- 사용자 이름 -->
                <div class="form-group fade-in">
                    <input type="text" 
                           id="username" 
                           name="username" 
                           placeholder="사용자 이름"
                           required>
                </div>

                <!-- 전화번호 -->
                <div class="form-group fade-in">
                    <input type="tel" 
                           id="phone" 
                           name="phone" 
                           placeholder="전화번호"
                           pattern="[0-9]{3}[0-9]{4}[0-9]{4}"
                           required>
                    <div class="error-message" id="phoneError">올바른 전화번호 형식이 아닙니다.</div>
                </div>

                <button type="submit" class="submit-btn">가입하기</button>
            </div>
        </form>

        <div class="divider" id="divider">또는</div>

        <div class="login-link" id="loginLink">
            이미 계정이 있으신가요? <a href="/login">로그인</a>
        </div>
    </div>

    <script>
        let emailVerified = false;

        // 이메일 중복 확인
        function checkDuplicate() {
            const emailInput = document.getElementById('email');
            const email = emailInput.value.trim();
            
            if (!email) {
                alert('이메일을 입력해주세요.');
                return;
            }

            // 이메일 형식 검증
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert('올바른 이메일 형식이 아닙니다.');
                return;
            }

            // 버튼 비활성화
            document.getElementById('checkBtn').disabled = true;
            document.getElementById('checkBtn').textContent = '확인중...';

            // 서버에 AJAX 요청
            fetch('/register/checkId?email=' + encodeURIComponent(email))
                .then(response => response.text())
                .then(data => {
                    document.getElementById('checkBtn').disabled = false;
                    document.getElementById('checkBtn').textContent = '중복확인';
                    
                    if (data === 'duplicate') {
                        document.getElementById('emailError').style.display = 'block';
                        document.getElementById('emailSuccess').style.display = 'none';
                        emailInput.classList.add('error');
                        emailInput.classList.remove('success');
                        emailVerified = false;
                    } else {
                        document.getElementById('emailError').style.display = 'none';
                        document.getElementById('emailSuccess').style.display = 'block';
                        emailInput.classList.remove('error');
                        emailInput.classList.add('success');
                        emailVerified = true;
                        
                        // 나머지 필드 펼치기
                        expandForm();
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('중복 확인 중 오류가 발생했습니다.');
                    document.getElementById('checkBtn').disabled = false;
                    document.getElementById('checkBtn').textContent = '중복확인';
                });
        }

        // 폼 확장
        function expandForm() {
            // 초기 메시지 숨기기
            document.getElementById('initialMessage').classList.add('hide');
            
            // 추가 필드 표시
            document.getElementById('additionalFields').classList.add('show');
            
            // 하단 요소들 표시
            setTimeout(() => {
                document.getElementById('divider').classList.add('show');
                document.getElementById('loginLink').classList.add('show');
            }, 200);
            
            // 이메일 입력 필드 읽기 전용으로
            document.getElementById('email').setAttribute('readonly', true);
            
            // 중복확인 버튼을 변경 버튼으로
            document.getElementById('checkBtn').textContent = '변경';
            document.getElementById('checkBtn').onclick = resetEmail;
        }

        // 이메일 변경
        function resetEmail() {
            // 폼 초기화
            document.getElementById('email').removeAttribute('readonly');
            document.getElementById('email').classList.remove('success');
            document.getElementById('emailSuccess').style.display = 'none';
            document.getElementById('additionalFields').classList.remove('show');
            document.getElementById('divider').classList.remove('show');
            document.getElementById('loginLink').classList.remove('show');
            document.getElementById('initialMessage').classList.remove('hide');
            
            // 버튼 원래대로
            document.getElementById('checkBtn').textContent = '중복확인';
            document.getElementById('checkBtn').onclick = checkDuplicate;
            
            emailVerified = false;
            
            // 입력 필드들 초기화
            document.getElementById('password').value = '';
            document.getElementById('passwordConfirm').value = '';
            document.getElementById('username').value = '';
            document.getElementById('phone').value = '';
        }

        // 비밀번호 유효성 검사
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const regex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,}$/;
            
            if (!regex.test(password)) {
                this.classList.add('error');
                document.getElementById('passwordError').style.display = 'block';
            } else {
                this.classList.remove('error');
                document.getElementById('passwordError').style.display = 'none';
            }
            
            // 비밀번호 확인 필드도 체크
            const confirmInput = document.getElementById('passwordConfirm');
            if (confirmInput.value) {
                checkPasswordMatch();
            }
        });

        // 비밀번호 일치 확인
        function checkPasswordMatch() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('passwordConfirm').value;
            const confirmInput = document.getElementById('passwordConfirm');
            
            if (password !== confirmPassword) {
                confirmInput.classList.add('error');
                document.getElementById('passwordConfirmError').style.display = 'block';
            } else {
                confirmInput.classList.remove('error');
                document.getElementById('passwordConfirmError').style.display = 'none';
            }
        }

        document.getElementById('passwordConfirm').addEventListener('input', checkPasswordMatch);

        // 전화번호 형식 자동 변환
        document.getElementById('phone').addEventListener('input', function(e) {
            let value = e.target.value.replace(/[^\d]/g, '');
            let formattedValue = '';
            
            if (value.length <= 3) {
                formattedValue = value;
            } else if (value.length <= 7) {
                formattedValue = value.slice(0, 3) + '-' + value.slice(3);
            } else if (value.length <= 11) {
                formattedValue = value.slice(0, 3) + '-' + value.slice(3, 7) + '-' + value.slice(7);
            }
            
            e.target.value = formattedValue;
        });

        // 폼 제출
        document.getElementById('signupForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (!emailVerified) {
                alert('이메일 중복 확인을 해주세요.');
                return;
            }
            
            // 비밀번호 검증
            const password = document.getElementById('password').value;
            const passwordRegex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,}$/;
            if (!passwordRegex.test(password)) {
                alert('비밀번호는 숫자, 특수문자를 포함한 8자 이상이어야 합니다.');
                return;
            }
            
            // 비밀번호 일치 확인
            if (password !== document.getElementById('passwordConfirm').value) {
                alert('비밀번호가 일치하지 않습니다.');
                return;
            }
            
            // 실제로 서버로 폼 제출
            this.submit();
        });
    </script>
</body>
</html>