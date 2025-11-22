<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - 복지24</title>
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
            flex-direction: column;
            min-height: 100vh;
        }

        /* navbar.jsp에서 스타일 가져옴 */

        .main-wrapper {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }

        .signup-container {
            background: white;
            padding: 40px 30px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            border-radius: 8px;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            color: #333;
            margin-bottom: 8px;
        }

        .input-with-button {
            display: flex;
            gap: 8px;
        }

        .input-with-button input {
            flex: 1;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="tel"] {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.2s;
        }

        input:focus {
            outline: none;
            border-color: #0084ff;
        }

        input.error {
            border-color: #dc3545;
        }

        input.success {
            border-color: #28a745;
        }

        .check-btn {
            padding: 12px 18px;
            background-color: #6c757d;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
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

        .error-message {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        .success-message {
            color: #28a745;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        .password-hint {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }

        /* 약관동의 스타일 */
        .terms-container {
            margin: 24px 0;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 6px;
        }

        .checkbox-group {
            margin-bottom: 12px;
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            font-size: 14px;
            color: #333;
        }

        .checkbox-label input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .checkbox-label.main {
            font-weight: 600;
            padding-bottom: 12px;
            border-bottom: 1px solid #dee2e6;
            margin-bottom: 12px;
        }

        .terms-link {
            color: #0084ff;
            text-decoration: none;
            font-size: 12px;
            margin-left: auto;
        }

        .terms-link:hover {
            text-decoration: underline;
        }

        .submit-btn {
            width: 100%;
            padding: 14px;
            background-color: #0084ff;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
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
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #666;
        }

        .login-link a {
            color: #0084ff;
            text-decoration: none;
            font-weight: 500;
        }

        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <header style="position: sticky; top: 0; z-index: 1000; background-color: white; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
        <nav style="background-color: transparent; padding: 0 40px; display: flex; align-items: center; justify-content: space-between; height: 60px;">
            <div style="flex-shrink: 0;">
                <a href="${pageContext.request.contextPath}/project.jsp" style="display: flex; align-items: center; gap: 8px; text-decoration: none; color: #333; transition: opacity 0.2s ease;">
                    <div style="width: 40px; height: 40px; background-image: url('resources/image/복지로고.png'); background-size: contain; background-repeat: no-repeat; background-position: center;"></div>
                    <span style="font-size: 24px; font-weight: 700; color: #333;">복지24</span>
                </a>
            </div>
            <div style="display: flex; align-items: center; gap: 20px;">
                <div class="language-selector" style="position: relative; display: inline-block;">
                    <svg id="languageToggle" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" style="width: 22px; height: 22px; cursor: pointer; color: #333; transition: color 0.2s;" onmouseover="this.style.color='#4A90E2'" onmouseout="this.style.color='#333'" title="언어 선택">
                        <path d="M12 2C6.477 2 2 6.477 2 12s4.477 10 10 10 10-4.477 10-10S17.523 2 12 2zm6.93 6h-2.95a15.65 15.65 0 00-1.38-3.56A8.03 8.03 0 0118.93 8zM12 4.04c.83 1.2 1.48 2.53 1.91 3.96h-3.82c.43-1.43 1.08-2.76 1.91-3.96zM4.26 14C4.1 13.36 4 12.69 4 12s.1-1.36.26-2h3.38c-.08.66-.14 1.32-.14 2 0 .68.06 1.34.14 2H4.26zm.81 2h2.95c.32 1.25.78 2.45 1.38 3.56A7.987 7.987 0 015.07 16zm2.95-8H5.07a7.987 7.987 0 014.33-3.56A15.65 15.65 0 008.02 8zM12 19.96c-.83-1.2-1.48-2.53-1.91-3.96h3.82c-.43 1.43-1.08 2.76-1.91 3.96zM14.34 14H9.66c-.09-.66-.16-1.32-.16-2 0-.68.07-1.35.16-2h4.68c.09.65.16 1.32.16 2 0 .68-.07 1.34-.16 2zm.25 5.56c.6-1.11 1.06-2.31 1.38-3.56h2.95a8.03 8.03 0 01-4.33 3.56zM16.36 14c.08-.66.14-1.32.14-2 0-.68-.06-1.34-.14-2h3.38c.16.64.26 1.31.26 2s-.1 1.36-.26 2h-3.38z"></path>
                    </svg>
                    <div id="google_translate_element" style="position: absolute; top: calc(100% + 8px); right: 0; background: white; padding: 12px; border-radius: 12px; box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15); z-index: 9999; min-width: 200px; display: none;"></div>
                </div>
                <svg id="userIcon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" style="width: 22px; height: 22px; cursor: pointer; color: #333; transition: color 0.2s;" onmouseover="this.style.color='#4A90E2'" onmouseout="this.style.color='#333'" title="로그인">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 4c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm0 14c-2.03 0-4.43-.82-6.14-2.88C7.55 15.8 9.68 15 12 15s4.45.8 6.14 2.12C16.43 19.18 14.03 20 12 20z"></path>
                </svg>
            </div>
        </nav>
    </header>

    <style>
        /* Google Translate 스타일 */
        .goog-te-banner-frame {
            display: none !important;
        }

        body {
            top: 0 !important;
        }

        .goog-te-gadget {
            font-family: inherit !important;
        }

        .goog-te-gadget-simple {
            background-color: transparent !important;
            border: none !important;
            padding: 0 !important;
            font-size: 14px !important;
        }

        .goog-te-menu-value {
            color: #333 !important;
        }

        .goog-te-menu-value:hover {
            text-decoration: none !important;
        }

        .goog-te-menu2 {
            max-width: 100% !important;
            overflow-x: hidden !important;
            border-radius: 8px !important;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1) !important;
        }

        .goog-te-menu2-item {
            padding: 10px 16px !important;
            border-left: 3px solid transparent !important;
            transition: all 0.2s !important;
        }

        .goog-te-menu2-item:hover {
            background-color: #f8f9fa !important;
            border-left-color: #4A90E2 !important;
        }

        .goog-te-menu2-item-selected {
            background-color: #e3f2fd !important;
            color: #4A90E2 !important;
            font-weight: 600 !important;
            border-left-color: #4A90E2 !important;
        }

        .goog-te-menu2-item div {
            color: inherit !important;
        }
    </style>

    <script type="text/javascript">
        // Google Translate 초기화
        function googleTranslateElementInit() {
            new google.translate.TranslateElement({
                pageLanguage: 'ko',
                includedLanguages: 'ko,en,ja,zh-CN,zh-TW,es,fr,de,ru,vi,th',
                layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
                autoDisplay: false
            }, 'google_translate_element');
        }

        // Google Translate 토글
        document.addEventListener('DOMContentLoaded', function() {
            const languageToggle = document.getElementById("languageToggle");
            const translateElement = document.getElementById("google_translate_element");

            if (languageToggle && translateElement) {
                languageToggle.addEventListener("click", function(e) {
                    e.stopPropagation();
                    if (translateElement.style.display === "none" || translateElement.style.display === "") {
                        translateElement.style.display = "block";
                    } else {
                        translateElement.style.display = "none";
                    }
                });

                document.addEventListener("click", function(e) {
                    if (!e.target.closest(".language-selector")) {
                        translateElement.style.display = "none";
                    }
                });
            }

            // 유저 아이콘 클릭 - 로그인 페이지로
            const userIcon = document.getElementById('userIcon');
            if (userIcon) {
                userIcon.addEventListener('click', function() {
                    window.location.href = '${pageContext.request.contextPath}/projectLogin.jsp';
                });
            }
        });
    </script>
    <script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>

    <div class="main-wrapper">
        <div class="signup-container">
            <h2 class="page-title">회원가입</h2>

            <form id="signupForm">
                <!-- 이메일/아이디 -->
                <div class="form-group">
                    <div class="input-with-button">
                        <input type="email"
                               id="email"
                               name="email"
                               placeholder="이메일"
                               required>
                        <button type="button"
                                class="check-btn"
                                id="sendCodeBtn"
                                onclick="sendVerificationCode()">
                            인증요청
                        </button>
                    </div>
                    <div class="error-message" id="emailError">이미 사용중인 이메일입니다.</div>
                    <div class="success-message" id="emailSent">인증 코드가 발송되었습니다.</div>
                </div>

                <!-- 인증 코드 입력 -->
                <div class="form-group" id="verificationCodeGroup" style="display: none;">
                    <div class="input-with-button">
                        <input type="text"
                               id="verificationCode"
                               name="verificationCode"
                               placeholder="인증 코드 6자리"
                               maxlength="6"
                               pattern="[0-9]{6}">
                        <button type="button"
                                class="check-btn"
                                id="verifyBtn"
                                onclick="verifyCode()">
                            확인
                        </button>
                    </div>
                    <div class="error-message" id="codeError">인증 코드가 올바르지 않습니다.</div>
                    <div id="timerDisplay" style="font-size: 12px; color: #f44336; margin-top: 5px;"></div>
                </div>

                <!-- 비밀번호 -->
                <div class="form-group">
                    <input type="password"
                           id="password"
                           name="password"
                           placeholder="비밀번호"
                           required>
                    <div class="password-hint">숫자, 특수문자 포함 8자 이상</div>
                    <div class="error-message" id="passwordError">비밀번호 형식이 올바르지 않습니다.</div>
                </div>

                <!-- 비밀번호 확인 -->
                <div class="form-group">
                    <input type="password"
                           id="passwordConfirm"
                           name="passwordConfirm"
                           placeholder="비밀번호 확인"
                           required>
                    <div class="error-message" id="passwordConfirmError">비밀번호가 일치하지 않습니다.</div>
                </div>

                <!-- 사용자 이름 -->
                <div class="form-group">
                    <input type="text"
                           id="username"
                           name="username"
                           placeholder="사용자 이름"
                           required>
                </div>

                <!-- 전화번호 -->
                <div class="form-group">
                    <input type="tel"
                           id="phone"
                           name="phone"
                           placeholder="전화번호 (010-1234-5678)"
                           pattern="[0-9]{3}-[0-9]{3,4}-[0-9]{4}"
                           required>
                    <div class="error-message" id="phoneError">올바른 전화번호 형식이 아닙니다 (010-1234-5678).</div>
                </div>

                <!-- 약관동의 -->
                <div class="terms-container">
                    <div class="checkbox-group">
                        <label class="checkbox-label main">
                            <input type="checkbox" id="agreeAll">
                            <span>전체 동의</span>
                        </label>
                    </div>
                    <div class="checkbox-group">
                        <label class="checkbox-label">
                            <input type="checkbox" class="terms-check" id="agreeTerms" required>
                            <span>이용 약관에 동의합니다. (필수)</span>
                        </label>
                    </div>
                    <div class="checkbox-group">
                        <label class="checkbox-label">
                            <input type="checkbox" class="terms-check" id="agreePrivacy" required>
                            <span>개인정보 처리방침에 동의합니다. (필수)</span>
                        </label>
                    </div>
                    <div class="checkbox-group">
                        <label class="checkbox-label">
                            <input type="checkbox" class="terms-check" id="agreeAge" required>
                            <span>만 14세 이상입니다. (필수)</span>
                        </label>
                    </div>
                </div>

                <button type="submit" class="submit-btn">가입하기</button>
            </form>

            <div class="divider">또는</div>

            <div class="login-link">
                이미 계정이 있으신가요? <a href="${pageContext.request.contextPath}/projectLogin.jsp">로그인</a>
            </div>
        </div>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        let emailVerified = false;
        let verificationTimer = null;
        let remainingTime = 600; // 10분

        // 전체 동의 체크박스
        document.getElementById('agreeAll').addEventListener('change', function() {
            const isChecked = this.checked;
            document.querySelectorAll('.terms-check').forEach(checkbox => {
                checkbox.checked = isChecked;
            });
        });

        // 개별 체크박스 - 전체 동의 상태 업데이트
        document.querySelectorAll('.terms-check').forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                const allChecked = Array.from(document.querySelectorAll('.terms-check'))
                    .every(cb => cb.checked);
                document.getElementById('agreeAll').checked = allChecked;
            });
        });

        // 이메일 인증 코드 발송
        function sendVerificationCode() {
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
            const sendCodeBtn = document.getElementById('sendCodeBtn');
            sendCodeBtn.disabled = true;
            sendCodeBtn.textContent = '발송중...';

            // 서버에 인증 코드 발송 요청
            fetch(contextPath + '/api/email/send-signup-code', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'email=' + encodeURIComponent(email)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    sendCodeBtn.textContent = '재발송';
                    sendCodeBtn.disabled = false;
                    document.getElementById('emailError').style.display = 'none';
                    document.getElementById('emailSent').style.display = 'block';
                    document.getElementById('verificationCodeGroup').style.display = 'block';
                    emailInput.readOnly = true;
                    emailInput.classList.add('success');

                    // 타이머 시작
                    startTimer();

                    alert('인증 코드가 이메일로 발송되었습니다.');
                } else {
                    sendCodeBtn.textContent = '인증요청';
                    sendCodeBtn.disabled = false;
                    if (data.message.includes('이미 가입된')) {
                        document.getElementById('emailError').style.display = 'block';
                        emailInput.classList.add('error');
                    }
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
            remainingTime = 600; // 10분 리셋
            updateTimerDisplay();

            if (verificationTimer) {
                clearInterval(verificationTimer);
            }

            verificationTimer = setInterval(function() {
                remainingTime--;
                updateTimerDisplay();

                if (remainingTime <= 0) {
                    clearInterval(verificationTimer);
                    document.getElementById('timerDisplay').textContent = '인증 시간이 만료되었습니다. 다시 요청해주세요.';
                    document.getElementById('verifyBtn').disabled = true;
                }
            }, 1000);
        }

        // 타이머 표시 업데이트
        function updateTimerDisplay() {
            const minutes = Math.floor(remainingTime / 60);
            const seconds = remainingTime % 60;
            document.getElementById('timerDisplay').textContent =
                '남은 시간: ' + minutes + '분 ' + (seconds < 10 ? '0' : '') + seconds + '초';
        }

        // 인증 코드 검증
        function verifyCode() {
            const email = document.getElementById('email').value.trim();
            const code = document.getElementById('verificationCode').value.trim();

            if (!code || code.length !== 6) {
                alert('6자리 인증 코드를 입력해주세요.');
                return;
            }

            const verifyBtn = document.getElementById('verifyBtn');
            verifyBtn.disabled = true;
            verifyBtn.textContent = '확인중...';

            fetch(contextPath + '/api/email/verify-signup-code', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'email=' + encodeURIComponent(email) + '&code=' + encodeURIComponent(code)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    emailVerified = true;
                    document.getElementById('codeError').style.display = 'none';
                    document.getElementById('verificationCode').readOnly = true;
                    document.getElementById('verificationCode').classList.add('success');
                    verifyBtn.textContent = '완료';
                    verifyBtn.disabled = true;
                    document.getElementById('sendCodeBtn').disabled = true;

                    // 타이머 정지
                    if (verificationTimer) {
                        clearInterval(verificationTimer);
                    }
                    document.getElementById('timerDisplay').textContent = '인증 완료';
                    document.getElementById('timerDisplay').style.color = '#28a745';
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

        // 비밀번호 유효성 검사
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const regex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,}$/;

            if (password && !regex.test(password)) {
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

            if (confirmPassword && password !== confirmPassword) {
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
                alert('이메일 인증을 완료해주세요.');
                return;
            }

            // 약관 동의 확인
            const agreeTerms = document.getElementById('agreeTerms').checked;
            const agreePrivacy = document.getElementById('agreePrivacy').checked;
            const agreeAge = document.getElementById('agreeAge').checked;

            if (!agreeTerms || !agreePrivacy || !agreeAge) {
                alert('필수 약관에 모두 동의해주세요.');
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
            const passwordConfirm = document.getElementById('passwordConfirm').value;
            if (password !== passwordConfirm) {
                alert('비밀번호가 일치하지 않습니다.');
                return;
            }

            // 폼 데이터 수집
            const formData = {
                pwd: password,
                name: document.getElementById('username').value,
                email: document.getElementById('email').value,
                phone: document.getElementById('phone').value.replace(/-/g, '')
            };

            // 디버깅: 전송 데이터 확인
            console.log('=== 회원가입 데이터 전송 ===');
            console.log('formData:', formData);

            // URLSearchParams로 변환
            const params = new URLSearchParams(formData).toString();
            console.log('params:', params);

            // AJAX 요청으로 회원가입 처리
            fetch(contextPath + '/api/auth/register', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('회원가입이 완료되었습니다! 로그인 페이지로 이동합니다.');
                    setTimeout(function() {
                        window.location.href = contextPath + '/projectLogin.jsp';
                    }, 500);
                } else {
                    alert(data.message || '회원가입 실패');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('회원가입 중 오류가 발생했습니다.');
            });
        });
    </script>
</body>
</html>
