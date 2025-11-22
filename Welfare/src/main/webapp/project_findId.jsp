<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디 찾기 - 복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Malgun Gothic', sans-serif;
            background-color: #f5f5f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            background: white;
            border-radius: 12px;
            padding: 50px 40px;
            max-width: 500px;
            width: 100%;
            box-shadow: 0 2px 20px rgba(0,0,0,0.08);
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        .logo {
            font-size: 32px;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
        }

        .subtitle {
            font-size: 16px;
            color: #666;
            font-weight: 400;
        }

        .step-section {
            display: none;
        }

        .step-section.active {
            display: block;
        }

        .info-text {
            font-size: 14px;
            color: #666;
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.2s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: #4A90E2;
        }

        .form-input::placeholder {
            color: #999;
        }

        .form-input.success {
            border-color: #10b981;
        }

        .form-input.error {
            border-color: #ef4444;
        }

        .error-message {
            color: #ef4444;
            font-size: 13px;
            margin-top: 6px;
            display: none;
        }

        .success-message {
            color: #10b981;
            font-size: 13px;
            margin-top: 6px;
            display: none;
        }

        .submit-btn {
            width: 100%;
            padding: 16px;
            background-color: #4A90E2;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
            transition: background-color 0.2s ease;
        }

        .submit-btn:hover {
            background-color: #357ABD;
        }

        .submit-btn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }

        .result-box {
            background-color: #f0f9ff;
            border: 1px solid #4A90E2;
            border-radius: 8px;
            padding: 30px;
            text-align: center;
            margin-bottom: 20px;
        }

        .result-label {
            font-size: 14px;
            color: #666;
            margin-bottom: 15px;
        }

        .result-email {
            font-size: 22px;
            font-weight: 700;
            color: #333;
            margin-bottom: 25px;
        }

        .divider {
            text-align: center;
            margin: 30px 0 25px;
            color: #999;
            font-size: 14px;
        }

        .bottom-links {
            text-align: center;
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .bottom-links a {
            color: #666;
            font-size: 14px;
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .bottom-links a:hover {
            color: #4A90E2;
            text-decoration: underline;
        }

        .hint-text {
            font-size: 12px;
            color: #999;
            margin-top: 6px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">복지24</div>
            <div class="subtitle">아이디 찾기</div>
        </div>

        <!-- 입력 폼 -->
        <div id="findForm" class="step-section active">
            <div class="info-text">
                회원가입 시 입력한 이름과 전화번호를 입력해주세요.
            </div>

            <div class="form-group">
                <label class="form-label">이름</label>
                <input type="text"
                       class="form-input"
                       id="name"
                       placeholder="이름"
                       required>
                <div class="error-message" id="nameError">이름을 입력해주세요.</div>
            </div>

            <div class="form-group">
                <label class="form-label">휴대폰 번호 (- 없이 입력)</label>
                <input type="tel"
                       class="form-input"
                       id="phone"
                       placeholder="01012345678"
                       maxlength="11"
                       required>
                <div class="error-message" id="phoneError">전화번호를 입력해주세요.</div>
            </div>

            <button type="button" class="submit-btn" onclick="findUserId()">
                이메일 아이디 확인
            </button>

            <div class="divider">또는</div>

            <div class="bottom-links">
                <a href="${pageContext.request.contextPath}/projectLogin.jsp">로그인</a>
                <a href="${pageContext.request.contextPath}/project_resetPassword.jsp">비밀번호 찾기</a>
                <a href="${pageContext.request.contextPath}/project_register.jsp">회원가입</a>
            </div>
        </div>

        <!-- 결과 표시 -->
        <div id="resultSection" class="step-section">
            <div class="info-text">
                고객님의 이메일 아이디를 찾았어요
            </div>

            <div class="result-box">
                <div class="result-email" id="foundEmail"></div>
            </div>

            <button type="button" class="submit-btn" onclick="location.href='${pageContext.request.contextPath}/projectLogin.jsp'">
                로그인
            </button>

            <div class="divider">또는</div>

            <div class="bottom-links">
                <a href="${pageContext.request.contextPath}/project_resetPassword.jsp">비밀번호 찾기</a>
                <a href="${pageContext.request.contextPath}/project_register.jsp">회원가입</a>
            </div>
        </div>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';

        function findUserId() {
            const name = document.getElementById('name').value.trim();
            const phone = document.getElementById('phone').value.trim().replace(/[^0-9]/g, '');

            // 유효성 검사
            let isValid = true;

            if (!name) {
                document.getElementById('nameError').style.display = 'block';
                document.getElementById('name').classList.add('error');
                isValid = false;
            } else {
                document.getElementById('nameError').style.display = 'none';
                document.getElementById('name').classList.remove('error');
            }

            if (!phone) {
                document.getElementById('phoneError').textContent = '전화번호를 입력해주세요.';
                document.getElementById('phoneError').style.display = 'block';
                document.getElementById('phone').classList.add('error');
                isValid = false;
            } else if (phone.length !== 11) {
                document.getElementById('phoneError').textContent = '전화번호는 11자리여야 합니다.';
                document.getElementById('phoneError').style.display = 'block';
                document.getElementById('phone').classList.add('error');
                isValid = false;
            } else if (!phone.startsWith('010')) {
                document.getElementById('phoneError').textContent = '올바른 휴대폰 번호를 입력해주세요.';
                document.getElementById('phoneError').style.display = 'block';
                document.getElementById('phone').classList.add('error');
                isValid = false;
            } else {
                document.getElementById('phoneError').style.display = 'none';
                document.getElementById('phone').classList.remove('error');
            }

            if (!isValid) return;

            // API 호출
            const formData = new URLSearchParams();
            formData.append('name', name);
            formData.append('phone', phone);

            fetch(contextPath + '/api/auth/find-id-by-phone', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formData.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // 아이디 찾기 성공
                    document.getElementById('foundEmail').textContent = data.email;
                    document.getElementById('findForm').classList.remove('active');
                    document.getElementById('resultSection').classList.add('active');
                } else {
                    // 실패
                    alert(data.message || '입력하신 정보와 일치하는 회원을 찾을 수 없습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('아이디 찾기 중 오류가 발생했습니다.');
            });
        }

        // 전화번호 입력 시 숫자만 입력되도록
        document.addEventListener('DOMContentLoaded', function() {
            const phoneInput = document.getElementById('phone');
            phoneInput.addEventListener('input', function(e) {
                this.value = this.value.replace(/[^0-9]/g, '');
            });

            // Enter 키 처리
            ['name', 'phone'].forEach(id => {
                document.getElementById(id).addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        findUserId();
                    }
                });
            });
        });
    </script>
</body>
</html>
