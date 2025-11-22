<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 재설정 - 복지24</title>
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

        .input-with-button {
            display: flex;
            gap: 8px;
        }

        .input-with-button input {
            flex: 1;
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

        .check-btn {
            padding: 14px 20px;
            background-color: #4A90E2;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
            transition: background-color 0.2s ease;
        }

        .check-btn:hover {
            background-color: #357ABD;
        }

        .check-btn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
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

        .hint-text {
            font-size: 12px;
            color: #999;
            margin-top: 6px;
        }

        .timer-display {
            font-size: 13px;
            color: #ef4444;
            margin-top: 6px;
            font-weight: 500;
        }

        .success-box {
            background-color: #f0f9ff;
            border: 1px solid #4A90E2;
            border-radius: 8px;
            padding: 30px;
            text-align: center;
            margin-bottom: 20px;
        }

        .success-box h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 20px;
        }

        .success-box p {
            color: #666;
            font-size: 14px;
            line-height: 1.6;
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
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">복지24</div>
            <div class="subtitle">비밀번호 재설정</div>
        </div>

        <!-- Step 1: 이메일 입력 -->
        <div id="step1" class="step-section active">
            <div class="info-text">
                인증이 완료되었어요<br>
                비밀번호를 재설정 해주세요
            </div>

            <div class="form-group">
                <label class="form-label">이메일</label>
                <div class="input-with-button">
                    <input type="email"
                           class="form-input"
                           id="email"
                           placeholder="이메일 주소"
                           required>
                    <button type="button"
                            class="check-btn"
                            id="sendCodeBtn"
                            onclick="sendResetCode()">
                        인증요청
                    </button>
                </div>
                <div class="error-message" id="emailError">등록되지 않은 이메일입니다.</div>
                <div class="success-message" id="emailSuccess">✓ 인증 코드가 발송되었습니다.</div>
            </div>
        </div>

        <!-- Step 2: 인증 코드 입력 -->
        <div id="step2" class="step-section">
            <div class="form-group">
                <label class="form-label">인증 코드</label>
                <div class="input-with-button">
                    <input type="text"
                           class="form-input"
                           id="verificationCode"
                           placeholder="인증 코드 6자리"
                           maxlength="6">
                    <button type="button"
                            class="check-btn"
                            id="verifyBtn"
                            onclick="verifyResetCode()">
                        확인
                    </button>
                </div>
                <div class="error-message" id="codeError">인증 코드가 올바르지 않습니다.</div>
                <div class="timer-display" id="timerDisplay"></div>
            </div>
        </div>

        <!-- Step 3: 새 비밀번호 설정 -->
        <div id="step3" class="step-section">
            <div class="form-group">
                <label class="form-label">새 비밀번호</label>
                <input type="password"
                       class="form-input"
                       id="newPassword"
                       placeholder="새 비밀번호"
                       required>
                <div class="hint-text">영문/숫자/특수문자 중 2가지 이상을 포함하여 8~12자로 입력해주세요.</div>
                <div class="error-message" id="passwordError">비밀번호 형식이 올바르지 않습니다.</div>
            </div>

            <div class="form-group">
                <label class="form-label">새 비밀번호 확인</label>
                <input type="password"
                       class="form-input"
                       id="confirmPassword"
                       placeholder="새 비밀번호 확인"
                       required>
                <div class="error-message" id="confirmError">비밀번호가 일치하지 않습니다.</div>
            </div>

            <button type="button"
                    class="submit-btn"
                    id="resetBtn"
                    onclick="resetPassword()">
                확인
            </button>
        </div>

        <!-- Step 4: 완료 -->
        <div id="step4" class="step-section">
            <div class="success-box">
                <h3>비밀번호 변경 완료</h3>
                <p>비밀번호가 성공적으로 변경되었습니다.<br>새로운 비밀번호로 로그인해주세요.</p>
            </div>
            <button type="button"
                    class="submit-btn"
                    onclick="location.href='${pageContext.request.contextPath}/projectLogin.jsp'">
                로그인
            </button>
        </div>

        <div class="divider">또는</div>

        <div class="bottom-links">
            <a href="${pageContext.request.contextPath}/projectLogin.jsp">로그인</a>
            <a href="${pageContext.request.contextPath}/project_findId.jsp">아이디 찾기</a>
            <a href="${pageContext.request.contextPath}/project_register.jsp">회원가입</a>
        </div>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        let verifiedEmail = '';
        let verifiedCode = '';
        let timer = null;
        let remainingTime = 600;

        // 인증 코드 발송
        function sendResetCode() {
            const email = document.getElementById('email').value.trim();

            if (!email) {
                alert('이메일을 입력해주세요.');
                return;
            }

            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert('올바른 이메일 형식이 아닙니다.');
                return;
            }

            const sendCodeBtn = document.getElementById('sendCodeBtn');
            sendCodeBtn.disabled = true;
            sendCodeBtn.textContent = '발송중...';

            fetch(contextPath + '/api/password/send-code', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'email=' + encodeURIComponent(email)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    verifiedEmail = email;
                    document.getElementById('emailError').style.display = 'none';
                    document.getElementById('emailSuccess').style.display = 'block';
                    document.getElementById('email').readOnly = true;
                    document.getElementById('email').classList.add('success');
                    sendCodeBtn.textContent = '재발송';
                    sendCodeBtn.disabled = false;

                    // Step 2 표시
                    document.getElementById('step2').classList.add('active');
                    startTimer();

                    alert('인증 코드가 이메일로 발송되었습니다.');
                } else {
                    sendCodeBtn.textContent = '인증요청';
                    sendCodeBtn.disabled = false;
                    document.getElementById('emailError').style.display = 'block';
                    document.getElementById('email').classList.add('error');
                    alert(data.message || '인증 코드 발송 실패');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('인증 코드 발송 중 오류가 발생했습니다.');
                sendCodeBtn.disabled = false;
                sendCodeBtn.textContent = '인증요청';
            });
        }

        // 타이머 시작
        function startTimer() {
            remainingTime = 600;
            updateTimerDisplay();

            if (timer) clearInterval(timer);

            timer = setInterval(function() {
                remainingTime--;
                updateTimerDisplay();

                if (remainingTime <= 0) {
                    clearInterval(timer);
                    document.getElementById('timerDisplay').textContent = '인증 시간이 만료되었습니다.';
                    document.getElementById('verifyBtn').disabled = true;
                }
            }, 1000);
        }

        function updateTimerDisplay() {
            const minutes = Math.floor(remainingTime / 60);
            const seconds = remainingTime % 60;
            document.getElementById('timerDisplay').textContent =
                '남은 시간: ' + minutes + '분 ' + (seconds < 10 ? '0' : '') + seconds + '초';
        }

        // 인증 코드 검증
        function verifyResetCode() {
            const code = document.getElementById('verificationCode').value.trim();

            if (!code || code.length !== 6) {
                alert('6자리 인증 코드를 입력해주세요.');
                return;
            }

            const verifyBtn = document.getElementById('verifyBtn');
            verifyBtn.disabled = true;
            verifyBtn.textContent = '확인중...';

            fetch(contextPath + '/api/password/verify-code', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'email=' + encodeURIComponent(verifiedEmail) + '&code=' + encodeURIComponent(code)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    verifiedCode = code;
                    document.getElementById('codeError').style.display = 'none';
                    document.getElementById('verificationCode').readOnly = true;
                    document.getElementById('verificationCode').classList.add('success');
                    verifyBtn.textContent = '완료';
                    document.getElementById('sendCodeBtn').disabled = true;

                    if (timer) clearInterval(timer);
                    document.getElementById('timerDisplay').textContent = '✓ 인증 완료';
                    document.getElementById('timerDisplay').style.color = '#10b981';

                    // Step 3 표시
                    document.getElementById('step3').classList.add('active');

                    alert('인증이 완료되었습니다. 새 비밀번호를 설정해주세요.');
                } else {
                    verifyBtn.textContent = '확인';
                    verifyBtn.disabled = false;
                    document.getElementById('codeError').style.display = 'block';
                    document.getElementById('verificationCode').classList.add('error');
                    alert(data.message || '인증 코드 검증 실패');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('인증 코드 검증 중 오류가 발생했습니다.');
                verifyBtn.disabled = false;
                verifyBtn.textContent = '확인';
            });
        }

        // 비밀번호 재설정
        function resetPassword() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            // 비밀번호 검증
            const passwordRegex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,}$/;
            if (!passwordRegex.test(newPassword)) {
                document.getElementById('passwordError').style.display = 'block';
                document.getElementById('newPassword').classList.add('error');
                alert('비밀번호는 숫자, 특수문자를 포함한 8자 이상이어야 합니다.');
                return;
            }

            if (newPassword !== confirmPassword) {
                document.getElementById('confirmError').style.display = 'block';
                document.getElementById('confirmPassword').classList.add('error');
                alert('비밀번호가 일치하지 않습니다.');
                return;
            }

            const resetBtn = document.getElementById('resetBtn');
            resetBtn.disabled = true;
            resetBtn.textContent = '변경중...';

            fetch(contextPath + '/api/password/reset', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'email=' + encodeURIComponent(verifiedEmail) +
                      '&code=' + encodeURIComponent(verifiedCode) +
                      '&newPassword=' + encodeURIComponent(newPassword)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Step 4 표시
                    document.getElementById('step1').classList.remove('active');
                    document.getElementById('step2').classList.remove('active');
                    document.getElementById('step3').classList.remove('active');
                    document.getElementById('step4').classList.add('active');

                    alert('비밀번호가 성공적으로 변경되었습니다.');
                } else {
                    resetBtn.disabled = false;
                    resetBtn.textContent = '확인';
                    alert(data.message || '비밀번호 변경 실패');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('비밀번호 변경 중 오류가 발생했습니다.');
                resetBtn.disabled = false;
                resetBtn.textContent = '확인';
            });
        }

        // 비밀번호 유효성 검사
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('newPassword').addEventListener('input', function() {
                const password = this.value;
                const regex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,}$/;

                if (password && !regex.test(password)) {
                    this.classList.add('error');
                    this.classList.remove('success');
                    document.getElementById('passwordError').style.display = 'block';
                } else if (password) {
                    this.classList.remove('error');
                    this.classList.add('success');
                    document.getElementById('passwordError').style.display = 'none';
                }

                checkPasswordMatch();
            });

            // 비밀번호 일치 확인
            function checkPasswordMatch() {
                const password = document.getElementById('newPassword').value;
                const confirmPassword = document.getElementById('confirmPassword').value;

                if (confirmPassword && password !== confirmPassword) {
                    document.getElementById('confirmPassword').classList.add('error');
                    document.getElementById('confirmPassword').classList.remove('success');
                    document.getElementById('confirmError').style.display = 'block';
                } else if (confirmPassword) {
                    document.getElementById('confirmPassword').classList.remove('error');
                    document.getElementById('confirmPassword').classList.add('success');
                    document.getElementById('confirmError').style.display = 'none';
                }
            }

            document.getElementById('confirmPassword').addEventListener('input', checkPasswordMatch);

            // 인증 코드 입력 시 자동으로 숫자만 입력되도록
            document.getElementById('verificationCode').addEventListener('input', function(e) {
                this.value = this.value.replace(/[^0-9]/g, '');
            });
        });
    </script>
</body>
</html>
