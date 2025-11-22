<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디/비밀번호 찾기 - 복지24</title>
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
            flex-direction: column;
        }

        .main-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .container {
            background: white;
            border-radius: 12px;
            max-width: 500px;
            width: 100%;
            box-shadow: 0 2px 20px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .tab-header {
            display: flex;
            border-bottom: 1px solid #e0e0e0;
        }

        .tab-btn {
            flex: 1;
            padding: 20px;
            background: none;
            border: none;
            font-size: 16px;
            font-weight: 600;
            color: #999;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .tab-btn.active {
            color: #333;
        }

        .tab-btn.active::after {
            content: '';
            position: absolute;
            bottom: -1px;
            left: 0;
            right: 0;
            height: 3px;
            background-color: #333;
        }

        .tab-content {
            padding: 40px;
        }

        .tab-panel {
            display: none;
        }

        .tab-panel.active {
            display: block;
        }

        .page-title {
            font-size: 20px;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
        }

        .info-text {
            font-size: 14px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .step-section {
            display: none;
        }

        .step-section.active {
            display: block;
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

        .result-section {
            margin-top: 20px;
        }

        .result-title {
            font-size: 18px;
            font-weight: 700;
            color: #333;
            margin-bottom: 20px;
        }

        .email-item {
            display: flex;
            align-items: center;
            padding: 16px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            margin-bottom: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .email-item:hover {
            border-color: #4A90E2;
            background-color: #f8f9fa;
        }

        .email-item.selected {
            border-color: #4A90E2;
            background-color: #f0f9ff;
        }

        .radio-circle {
            width: 20px;
            height: 20px;
            border: 2px solid #ddd;
            border-radius: 50%;
            margin-right: 15px;
            position: relative;
            transition: all 0.2s ease;
        }

        .email-item.selected .radio-circle {
            border-color: #4A90E2;
        }

        .email-item.selected .radio-circle::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 10px;
            height: 10px;
            background-color: #4A90E2;
            border-radius: 50%;
        }

        .email-info {
            flex: 1;
        }

        .email-address {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 4px;
        }

        .email-date {
            font-size: 13px;
            color: #999;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }

        .action-btn {
            flex: 1;
            padding: 16px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: white;
            color: #333;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .action-btn:hover {
            border-color: #4A90E2;
            color: #4A90E2;
        }

        .action-btn.primary {
            background-color: #4A90E2;
            color: white;
            border-color: #4A90E2;
        }

        .action-btn.primary:hover {
            background-color: #357ABD;
        }

        .result-box {
            background-color: #f0f9ff;
            border: 1px solid #4A90E2;
            border-radius: 8px;
            padding: 30px;
            text-align: center;
            margin-bottom: 20px;
        }

        .result-box h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 20px;
        }

        .result-box p {
            color: #666;
            font-size: 14px;
            line-height: 1.6;
        }

        .divider {
            text-align: center;
            margin: 20px 0 15px;
            color: #999;
            font-size: 14px;
            position: relative;
        }

        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background-color: #e0e0e0;
            z-index: 0;
        }

        .divider span {
            background-color: white;
            padding: 0 15px;
            position: relative;
            z-index: 1;
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
            background-color: #e8f4ff !important;
            border-left-color: #4A90E2 !important;
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
                <svg id="userIcon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" style="width: 22px; height: 22px; cursor: pointer; color: #333; transition: color 0.2s;" onmouseover="this.style.color='#4A90E2'" onmouseout="this.style.color='#333'" title="로그인" onclick="location.href='${pageContext.request.contextPath}/projectLogin.jsp'">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 4c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm0 14c-2.03 0-4.43-.82-6.14-2.88C7.55 15.8 9.68 15 12 15s4.45.8 6.14 2.12C16.43 19.18 14.03 20 12 20z"></path>
                </svg>
            </div>
        </nav>
    </header>

    <div class="main-wrapper">
    <div class="container">
        <!-- 탭 헤더 -->
        <div class="tab-header">
            <button class="tab-btn active" onclick="switchTab('findId')">아이디 찾기</button>
            <button class="tab-btn" onclick="switchTab('findPassword')">비밀번호 찾기</button>
        </div>

        <div class="tab-content">
            <!-- 아이디 찾기 탭 -->
            <div id="findIdTab" class="tab-panel active">
                <div class="page-title">휴대폰 번호로 찾기</div>

                <!-- 입력 폼 -->
                <div id="findIdForm" class="step-section active">
                    <div class="info-text">
                        입력하신 이름과 휴대폰 번호가 회원 정보와<br>
                        일치할 경우 이메일 아이디를 알려드려요.
                    </div>

                    <div class="form-group">
                        <input type="text"
                               class="form-input"
                               id="findId_name"
                               placeholder="이름"
                               required>
                        <div class="error-message" id="findId_nameError">이름을 입력해주세요.</div>
                    </div>

                    <div class="form-group">
                        <input type="tel"
                               class="form-input"
                               id="findId_phone"
                               placeholder="휴대폰 번호 (- 없이 입력)"
                               maxlength="11"
                               required>
                        <div class="error-message" id="findId_phoneError">전화번호를 입력해주세요.</div>
                    </div>

                    <button type="button" class="submit-btn" onclick="findUserId()">
                        이메일 아이디 확인
                    </button>

                    <div class="divider">
                        <span>또는</span>
                    </div>

                    <div class="bottom-links" style="padding: 0;">
                        <a href="${pageContext.request.contextPath}/projectLogin.jsp">로그인</a>
                        <a href="${pageContext.request.contextPath}/project_register.jsp">회원가입</a>
                    </div>
                </div>

                <!-- 결과 표시 -->
                <div id="findIdResult" class="step-section">
                    <div class="result-section">
                        <div class="result-title">고객님의<br>이메일 아이디를 찾았어요</div>

                        <div id="emailList">
                            <!-- 이메일 목록이 여기에 동적으로 추가됩니다 -->
                        </div>

                        <div class="action-buttons">
                            <button class="action-btn" onclick="switchTab('findPassword')">비밀번호 찾기</button>
                            <button class="action-btn primary" onclick="location.href='${pageContext.request.contextPath}/projectLogin.jsp'">로그인</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 비밀번호 찾기 탭 -->
            <div id="findPasswordTab" class="tab-panel">
                <div class="page-title">이메일로 찾기</div>

                <!-- Step 1: 이메일 입력 -->
                <div id="pwStep1" class="step-section active">
                    <div class="info-text">
                        입력하신 이름과 이메일 아이디가 회원 정보와<br>
                        일치할 경우 에게 메일로 인증번호가 발송됩니다.
                    </div>

                    <div class="form-group">
                        <input type="text"
                               class="form-input"
                               id="pw_name"
                               placeholder="이름"
                               required>
                        <div class="error-message" id="pw_nameError">이름을 입력해주세요.</div>
                    </div>

                    <div class="form-group">
                        <input type="email"
                               class="form-input"
                               id="pw_email"
                               placeholder="이메일 아이디"
                               required>
                        <div class="error-message" id="pw_emailError">등록되지 않은 이메일입니다.</div>
                    </div>

                    <button type="button"
                            class="submit-btn"
                            id="sendCodeBtn"
                            onclick="sendResetCode()">
                        인증번호 받기
                    </button>

                    <div class="divider">
                        <span>또는</span>
                    </div>

                    <div class="bottom-links" style="padding: 0;">
                        <a href="${pageContext.request.contextPath}/projectLogin.jsp">로그인</a>
                        <a href="${pageContext.request.contextPath}/project_register.jsp">회원가입</a>
                    </div>
                </div>

                <!-- Step 2: 인증 코드 입력 -->
                <div id="pwStep2" class="step-section">
                    <div class="form-group">
                        <label class="form-label">인증 코드</label>
                        <div class="input-with-button">
                            <input type="text"
                                   class="form-input"
                                   id="pw_verificationCode"
                                   placeholder="인증 코드 6자리"
                                   maxlength="6">
                            <button type="button"
                                    class="check-btn"
                                    id="verifyBtn"
                                    onclick="verifyResetCode()">
                                확인
                            </button>
                        </div>
                        <div class="error-message" id="pw_codeError">인증 코드가 올바르지 않습니다.</div>
                        <div class="timer-display" id="pw_timerDisplay"></div>
                    </div>
                </div>

                <!-- Step 3: 새 비밀번호 설정 -->
                <div id="pwStep3" class="step-section">
                    <div class="form-group">
                        <label class="form-label">새 비밀번호</label>
                        <input type="password"
                               class="form-input"
                               id="pw_newPassword"
                               placeholder="새 비밀번호"
                               required>
                        <div class="hint-text">영문/숫자/특수문자 중 2가지 이상을 포함하여 8~12자로 입력해주세요.</div>
                        <div class="error-message" id="pw_passwordError">비밀번호 형식이 올바르지 않습니다.</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">새 비밀번호 확인</label>
                        <input type="password"
                               class="form-input"
                               id="pw_confirmPassword"
                               placeholder="새 비밀번호 확인"
                               required>
                        <div class="error-message" id="pw_confirmError">비밀번호가 일치하지 않습니다.</div>
                    </div>

                    <button type="button"
                            class="submit-btn"
                            id="resetBtn"
                            onclick="resetPassword()">
                        확인
                    </button>
                </div>

                <!-- Step 4: 완료 -->
                <div id="pwStep4" class="step-section">
                    <div class="result-box">
                        <h3>비밀번호 변경 완료</h3>
                        <p>비밀번호가 성공적으로 변경되었습니다.<br>새로운 비밀번호로 로그인해주세요.</p>
                    </div>
                    <button type="button"
                            class="submit-btn"
                            onclick="location.href='${pageContext.request.contextPath}/projectLogin.jsp'">
                        로그인
                    </button>
                </div>
            </div>
        </div>
    </div>
    </div>

    <script type="text/javascript">
        function googleTranslateElementInit() {
            new google.translate.TranslateElement({
                pageLanguage: 'ko',
                includedLanguages: 'ko,en,ja,zh-CN,zh-TW,es,fr,de,ru,pt,it,vi,th,id,ar',
                layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
                autoDisplay: false
            }, 'google_translate_element');
        }

        document.addEventListener('DOMContentLoaded', function() {
            const languageToggle = document.getElementById('languageToggle');
            const translateElement = document.getElementById('google_translate_element');

            if (languageToggle && translateElement) {
                languageToggle.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const isVisible = translateElement.style.display === 'block';
                    translateElement.style.display = isVisible ? 'none' : 'block';
                });

                document.addEventListener('click', function(e) {
                    if (!translateElement.contains(e.target) && e.target !== languageToggle) {
                        translateElement.style.display = 'none';
                    }
                });
            }
        });
    </script>
    <script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        let verifiedEmail = '';
        let verifiedCode = '';
        let timer = null;
        let remainingTime = 600;
        let selectedEmail = '';

        // 탭 전환
        function switchTab(tabName) {
            const tabs = document.querySelectorAll('.tab-btn');
            const panels = document.querySelectorAll('.tab-panel');

            tabs.forEach(tab => tab.classList.remove('active'));
            panels.forEach(panel => panel.classList.remove('active'));

            if (tabName === 'findId') {
                tabs[0].classList.add('active');
                document.getElementById('findIdTab').classList.add('active');
            } else if (tabName === 'findPassword') {
                tabs[1].classList.add('active');
                document.getElementById('findPasswordTab').classList.add('active');
            }
        }

        // ========== 아이디 찾기 ==========
        function findUserId() {
            const name = document.getElementById('findId_name').value.trim();
            const phone = document.getElementById('findId_phone').value.trim().replace(/[^0-9]/g, '');

            let isValid = true;

            if (!name) {
                document.getElementById('findId_nameError').style.display = 'block';
                document.getElementById('findId_name').classList.add('error');
                isValid = false;
            } else {
                document.getElementById('findId_nameError').style.display = 'none';
                document.getElementById('findId_name').classList.remove('error');
            }

            if (!phone) {
                document.getElementById('findId_phoneError').textContent = '전화번호를 입력해주세요.';
                document.getElementById('findId_phoneError').style.display = 'block';
                document.getElementById('findId_phone').classList.add('error');
                isValid = false;
            } else if (phone.length !== 11) {
                document.getElementById('findId_phoneError').textContent = '전화번호는 11자리여야 합니다.';
                document.getElementById('findId_phoneError').style.display = 'block';
                document.getElementById('findId_phone').classList.add('error');
                isValid = false;
            } else if (!phone.startsWith('010')) {
                document.getElementById('findId_phoneError').textContent = '올바른 휴대폰 번호를 입력해주세요.';
                document.getElementById('findId_phoneError').style.display = 'block';
                document.getElementById('findId_phone').classList.add('error');
                isValid = false;
            } else {
                document.getElementById('findId_phoneError').style.display = 'none';
                document.getElementById('findId_phone').classList.remove('error');
            }

            if (!isValid) return;

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
                    // 이메일 목록 생성 (현재는 1개지만 확장 가능)
                    const emailList = document.getElementById('emailList');
                    const currentDate = new Date().toISOString().split('T')[0].replace(/-/g, '.').substring(2);

                    emailList.innerHTML = `
                        <div class="email-item selected" onclick="selectEmail(this, '${data.email}')">
                            <div class="radio-circle"></div>
                            <div class="email-info">
                                <div class="email-address">${data.email}</div>
                                <div class="email-date">${currentDate} 가입</div>
                            </div>
                        </div>
                    `;

                    selectedEmail = data.email;
                    document.getElementById('findIdForm').classList.remove('active');
                    document.getElementById('findIdResult').classList.add('active');
                } else {
                    alert(data.message || '입력하신 정보와 일치하는 회원을 찾을 수 없습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('아이디 찾기 중 오류가 발생했습니다.');
            });
        }

        function selectEmail(element, email) {
            // 모든 이메일 아이템에서 selected 제거
            document.querySelectorAll('.email-item').forEach(item => {
                item.classList.remove('selected');
            });

            // 클릭한 아이템에 selected 추가
            element.classList.add('selected');
            selectedEmail = email;
        }

        // ========== 비밀번호 찾기 ==========
        function sendResetCode() {
            const name = document.getElementById('pw_name').value.trim();
            const email = document.getElementById('pw_email').value.trim();

            let isValid = true;

            if (!name) {
                document.getElementById('pw_nameError').style.display = 'block';
                document.getElementById('pw_name').classList.add('error');
                isValid = false;
            } else {
                document.getElementById('pw_nameError').style.display = 'none';
                document.getElementById('pw_name').classList.remove('error');
            }

            if (!email) {
                document.getElementById('pw_emailError').textContent = '이메일을 입력해주세요.';
                document.getElementById('pw_emailError').style.display = 'block';
                document.getElementById('pw_email').classList.add('error');
                isValid = false;
            } else {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    document.getElementById('pw_emailError').textContent = '올바른 이메일 형식이 아닙니다.';
                    document.getElementById('pw_emailError').style.display = 'block';
                    document.getElementById('pw_email').classList.add('error');
                    isValid = false;
                } else {
                    document.getElementById('pw_emailError').style.display = 'none';
                    document.getElementById('pw_email').classList.remove('error');
                }
            }

            if (!isValid) return;

            const sendCodeBtn = document.getElementById('sendCodeBtn');
            sendCodeBtn.disabled = true;
            sendCodeBtn.textContent = '발송중...';

            fetch(contextPath + '/api/password/send-code', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'email=' + encodeURIComponent(email) + '&name=' + encodeURIComponent(name)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    verifiedEmail = email;
                    document.getElementById('pw_emailError').style.display = 'none';
                    document.getElementById('pw_email').readOnly = true;
                    document.getElementById('pw_email').classList.add('success');
                    document.getElementById('pw_name').readOnly = true;
                    document.getElementById('pw_name').classList.add('success');
                    sendCodeBtn.textContent = '재발송';
                    sendCodeBtn.disabled = false;

                    document.getElementById('pwStep2').classList.add('active');
                    startTimer();

                    alert('인증 코드가 이메일로 발송되었습니다.');
                } else {
                    sendCodeBtn.textContent = '인증번호 받기';
                    sendCodeBtn.disabled = false;
                    document.getElementById('pw_emailError').textContent = data.message || '등록되지 않은 이메일입니다.';
                    document.getElementById('pw_emailError').style.display = 'block';
                    document.getElementById('pw_email').classList.add('error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('인증 코드 발송 중 오류가 발생했습니다.');
                sendCodeBtn.disabled = false;
                sendCodeBtn.textContent = '인증번호 받기';
            });
        }

        function startTimer() {
            remainingTime = 600;
            updateTimerDisplay();

            if (timer) clearInterval(timer);

            timer = setInterval(function() {
                remainingTime--;
                updateTimerDisplay();

                if (remainingTime <= 0) {
                    clearInterval(timer);
                    document.getElementById('pw_timerDisplay').textContent = '인증 시간이 만료되었습니다.';
                    document.getElementById('verifyBtn').disabled = true;
                }
            }, 1000);
        }

        function updateTimerDisplay() {
            const minutes = Math.floor(remainingTime / 60);
            const seconds = remainingTime % 60;
            document.getElementById('pw_timerDisplay').textContent =
                '남은 시간: ' + minutes + '분 ' + (seconds < 10 ? '0' : '') + seconds + '초';
        }

        function verifyResetCode() {
            const code = document.getElementById('pw_verificationCode').value.trim();

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
                    document.getElementById('pw_codeError').style.display = 'none';
                    document.getElementById('pw_verificationCode').readOnly = true;
                    document.getElementById('pw_verificationCode').classList.add('success');
                    verifyBtn.textContent = '완료';
                    document.getElementById('sendCodeBtn').disabled = true;

                    if (timer) clearInterval(timer);
                    document.getElementById('pw_timerDisplay').textContent = '✓ 인증 완료';
                    document.getElementById('pw_timerDisplay').style.color = '#10b981';

                    document.getElementById('pwStep3').classList.add('active');

                    alert('인증이 완료되었습니다. 새 비밀번호를 설정해주세요.');
                } else {
                    verifyBtn.textContent = '확인';
                    verifyBtn.disabled = false;
                    document.getElementById('pw_codeError').style.display = 'block';
                    document.getElementById('pw_verificationCode').classList.add('error');
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

        function resetPassword() {
            const newPassword = document.getElementById('pw_newPassword').value;
            const confirmPassword = document.getElementById('pw_confirmPassword').value;

            const passwordRegex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,}$/;
            if (!passwordRegex.test(newPassword)) {
                document.getElementById('pw_passwordError').style.display = 'block';
                document.getElementById('pw_newPassword').classList.add('error');
                alert('비밀번호는 숫자, 특수문자를 포함한 8자 이상이어야 합니다.');
                return;
            }

            if (newPassword !== confirmPassword) {
                document.getElementById('pw_confirmError').style.display = 'block';
                document.getElementById('pw_confirmPassword').classList.add('error');
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
                    document.getElementById('pwStep1').classList.remove('active');
                    document.getElementById('pwStep2').classList.remove('active');
                    document.getElementById('pwStep3').classList.remove('active');
                    document.getElementById('pwStep4').classList.add('active');

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

        // 이벤트 리스너
        document.addEventListener('DOMContentLoaded', function() {
            // 아이디 찾기 - 전화번호 숫자만
            const findIdPhone = document.getElementById('findId_phone');
            findIdPhone.addEventListener('input', function(e) {
                this.value = this.value.replace(/[^0-9]/g, '');
            });

            // 아이디 찾기 - Enter 키
            ['findId_name', 'findId_phone'].forEach(id => {
                document.getElementById(id).addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        findUserId();
                    }
                });
            });

            // 비밀번호 찾기 - 비밀번호 유효성 검사
            document.getElementById('pw_newPassword').addEventListener('input', function() {
                const password = this.value;
                const regex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,}$/;

                if (password && !regex.test(password)) {
                    this.classList.add('error');
                    this.classList.remove('success');
                    document.getElementById('pw_passwordError').style.display = 'block';
                } else if (password) {
                    this.classList.remove('error');
                    this.classList.add('success');
                    document.getElementById('pw_passwordError').style.display = 'none';
                }

                checkPasswordMatch();
            });

            function checkPasswordMatch() {
                const password = document.getElementById('pw_newPassword').value;
                const confirmPassword = document.getElementById('pw_confirmPassword').value;

                if (confirmPassword && password !== confirmPassword) {
                    document.getElementById('pw_confirmPassword').classList.add('error');
                    document.getElementById('pw_confirmPassword').classList.remove('success');
                    document.getElementById('pw_confirmError').style.display = 'block';
                } else if (confirmPassword) {
                    document.getElementById('pw_confirmPassword').classList.remove('error');
                    document.getElementById('pw_confirmPassword').classList.add('success');
                    document.getElementById('pw_confirmError').style.display = 'none';
                }
            }

            document.getElementById('pw_confirmPassword').addEventListener('input', checkPasswordMatch);

            // 인증 코드 숫자만
            document.getElementById('pw_verificationCode').addEventListener('input', function(e) {
                this.value = this.value.replace(/[^0-9]/g, '');
            });
        });
    </script>
</body>
</html>
