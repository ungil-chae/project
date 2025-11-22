<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>복지24 - 계정 찾기</title>
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
            padding: 20px;
        }

        .container {
            background: white;
            border: 1px solid #dbdbdb;
            border-radius: 8px;
            padding: 40px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .logo {
            font-size: 28px;
            font-weight: 700;
            color: #333;
            text-align: center;
            margin-bottom: 10px;
        }

        .subtitle {
            font-size: 15px;
            color: #8e8e8e;
            text-align: center;
            margin-bottom: 30px;
        }

        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
        }

        .tab-btn {
            flex: 1;
            padding: 12px;
            border: 1px solid #dbdbdb;
            background-color: white;
            color: #8e8e8e;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .tab-btn.active {
            background-color: #000000;
            color: white;
            border-color: #000000;
        }

        .tab-btn:hover:not(.active) {
            background-color: #f5f5f5;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-label {
            display: block;
            font-size: 14px;
            color: #333;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .form-input {
            width: 100%;
            padding: 15px 20px;
            border: 1px solid #dbdbdb;
            border-radius: 6px;
            font-size: 15px;
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

        .submit-btn {
            width: 100%;
            padding: 15px;
            background-color: #000000;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
            transition: background-color 0.2s ease;
        }

        .submit-btn:hover {
            background-color: #333333;
        }

        .info-text {
            font-size: 13px;
            color: #8e8e8e;
            margin-top: 15px;
            line-height: 1.5;
            padding: 12px;
            background-color: #f5f5f5;
            border-radius: 6px;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 25px;
            color: #0095f6;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .result-box {
            display: none;
            padding: 20px;
            background-color: #e3f2fd;
            border: 1px solid #2196f3;
            border-radius: 6px;
            margin-top: 20px;
        }

        .result-box.show {
            display: block;
        }

        .result-title {
            font-size: 15px;
            font-weight: 600;
            color: #1976d2;
            margin-bottom: 10px;
        }

        .result-content {
            font-size: 16px;
            color: #333;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <header class="top-header">
        <a href="project.jsp" class="header-logo">
            <div class="header-logo-icon"></div>
            <span class="header-logo-text">복지24</span>
        </a>
    </header>

    <div class="main-wrapper">
        <div class="container">
        <div class="logo">복지24</div>
        <div class="subtitle">계정 정보 찾기</div>

        <div class="tabs">
            <button class="tab-btn active" onclick="switchTab('id')">아이디 찾기</button>
            <button class="tab-btn" onclick="switchTab('password')">비밀번호 찾기</button>
        </div>

        <!-- 아이디 찾기 탭 -->
        <div class="tab-content active" id="id-tab">
            <form id="findIdForm">
                <div class="form-group">
                    <label class="form-label">이름</label>
                    <input type="text" class="form-input" name="name" placeholder="가입 시 입력한 이름" required>
                </div>

                <div class="form-group">
                    <label class="form-label">이메일</label>
                    <input type="email" class="form-input" name="email" placeholder="example@email.com" required>
                </div>

                <button type="submit" class="submit-btn">아이디 찾기</button>

                <div class="info-text">
                    💡 가입 시 입력한 이름과 이메일을 입력하시면<br>
                    등록된 아이디를 확인하실 수 있습니다.
                </div>

                <div class="result-box" id="id-result">
                    <div class="result-title">회원님의 아이디</div>
                    <div class="result-content" id="id-result-text"></div>
                </div>
            </form>
        </div>

        <!-- 비밀번호 찾기 탭 -->
        <div class="tab-content" id="password-tab">
            <!-- 1단계: 아이디 입력 및 보안 질문 조회 -->
            <form id="getSecurityQuestionForm" style="display: block;">
                <div class="form-group">
                    <label class="form-label">아이디</label>
                    <input type="text" class="form-input" id="reset-username" name="username" placeholder="아이디 입력" required>
                </div>

                <button type="submit" class="submit-btn">다음</button>

                <div class="info-text">
                    💡 가입 시 설정한 보안 질문에 답변하여 비밀번호를 재설정할 수 있습니다.
                </div>
            </form>

            <!-- 2단계: 보안 질문 답변 및 새 비밀번호 입력 -->
            <form id="resetPasswordForm" style="display: none;">
                <div class="form-group">
                    <label class="form-label">보안 질문</label>
                    <input type="text" class="form-input" id="display-security-question" readonly style="background-color: #f0f0f0;">
                </div>

                <div class="form-group">
                    <label class="form-label">답변</label>
                    <input type="text" class="form-input" id="security-answer" name="securityAnswer" placeholder="보안 질문 답변 입력" required>
                </div>

                <div class="form-group">
                    <label class="form-label">새 비밀번호</label>
                    <input type="password" class="form-input" id="new-password" name="newPassword" placeholder="새 비밀번호 (최소 4자)" minlength="4" required>
                </div>

                <div class="form-group">
                    <label class="form-label">비밀번호 확인</label>
                    <input type="password" class="form-input" id="confirm-password" placeholder="비밀번호 다시 입력" minlength="4" required>
                </div>

                <button type="submit" class="submit-btn">비밀번호 변경</button>
                <button type="button" class="submit-btn" onclick="showGetSecurityQuestionForm()" style="margin-top: 10px; background-color: #8e8e8e;">처음으로</button>
            </form>
        </div>

        <a href="projectLogin.jsp" class="back-link">← 로그인 페이지로 돌아가기</a>
        </div>
    </div>

    <script>
        // 탭 전환 함수
        function switchTab(tab) {
            const tabs = document.querySelectorAll('.tab-btn');
            const contents = document.querySelectorAll('.tab-content');

            tabs.forEach(t => t.classList.remove('active'));
            contents.forEach(c => c.classList.remove('active'));

            if (tab === 'id') {
                tabs[0].classList.add('active');
                document.getElementById('id-tab').classList.add('active');
            } else {
                tabs[1].classList.add('active');
                document.getElementById('password-tab').classList.add('active');
            }

            // 결과 박스 숨기기
            document.querySelectorAll('.result-box').forEach(box => {
                box.classList.remove('show');
            });
        }

        // 아이디 찾기 폼 제출
        document.getElementById('findIdForm').addEventListener('submit', function(e) {
            e.preventDefault();

            const formData = new FormData(this);
            const name = formData.get('name');
            const email = formData.get('email');

            console.log('아이디 찾기:', { name, email });

            // 제출 버튼 비활성화 및 텍스트 변경
            const submitBtn = this.querySelector('.submit-btn');
            const originalBtnText = submitBtn.textContent;
            submitBtn.disabled = true;
            submitBtn.textContent = '조회 중...';

            // 결과 박스 초기화
            const resultBox = document.getElementById('id-result');
            const resultText = document.getElementById('id-result-text');
            resultBox.classList.remove('show');

            // 서버 API 호출
            fetch('${pageContext.request.contextPath}/api/auth/find-id', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'name=' + encodeURIComponent(name) + '&email=' + encodeURIComponent(email)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    resultText.textContent = data.userId;
                    resultBox.classList.add('show');
                } else {
                    alert(data.message || '입력하신 정보와 일치하는 회원을 찾을 수 없습니다.');
                }
            })
            .catch(error => {
                console.error('아이디 찾기 오류:', error);
                alert('시스템 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
            })
            .finally(() => {
                // 제출 버튼 다시 활성화
                submitBtn.disabled = false;
                submitBtn.textContent = originalBtnText;
            });
        });

        // 전역 변수로 사용자명 저장
        let currentResetUsername = '';

        // 폼 전환 함수
        function showGetSecurityQuestionForm() {
            document.getElementById('getSecurityQuestionForm').style.display = 'block';
            document.getElementById('resetPasswordForm').style.display = 'none';
            document.getElementById('reset-username').value = '';
            document.getElementById('security-answer').value = '';
            document.getElementById('new-password').value = '';
            document.getElementById('confirm-password').value = '';
        }

        function showResetPasswordForm() {
            document.getElementById('getSecurityQuestionForm').style.display = 'none';
            document.getElementById('resetPasswordForm').style.display = 'block';
        }

        // 1단계: 보안 질문 조회
        document.getElementById('getSecurityQuestionForm').addEventListener('submit', function(e) {
            e.preventDefault();

            const username = document.getElementById('reset-username').value;
            currentResetUsername = username;

            const submitBtn = this.querySelector('.submit-btn');
            const originalBtnText = submitBtn.textContent;
            submitBtn.disabled = true;
            submitBtn.textContent = '조회 중...';

            fetch('${pageContext.request.contextPath}/api/auth/security-question?username=' + encodeURIComponent(username), {
                method: 'GET'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('display-security-question').value = data.securityQuestion;
                    showResetPasswordForm();
                } else {
                    alert(data.message || '보안 질문을 찾을 수 없습니다.');
                }
            })
            .catch(error => {
                console.error('보안 질문 조회 오류:', error);
                alert('시스템 오류가 발생했습니다.');
            })
            .finally(() => {
                submitBtn.disabled = false;
                submitBtn.textContent = originalBtnText;
            });
        });

        // 2단계: 비밀번호 재설정
        document.getElementById('resetPasswordForm').addEventListener('submit', function(e) {
            e.preventDefault();

            const securityAnswer = document.getElementById('security-answer').value;
            const newPassword = document.getElementById('new-password').value;
            const confirmPassword = document.getElementById('confirm-password').value;

            // 비밀번호 일치 확인
            if (newPassword !== confirmPassword) {
                alert('비밀번호가 일치하지 않습니다.');
                return;
            }

            const submitBtn = this.querySelector('.submit-btn');
            const originalBtnText = submitBtn.textContent;
            submitBtn.disabled = true;
            submitBtn.textContent = '변경 중...';

            fetch('${pageContext.request.contextPath}/api/auth/reset-password-security', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'username=' + encodeURIComponent(currentResetUsername) +
                      '&securityAnswer=' + encodeURIComponent(securityAnswer) +
                      '&newPassword=' + encodeURIComponent(newPassword)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message + '\n로그인 페이지로 이동합니다.');
                    window.location.href = 'projectLogin.jsp';
                } else {
                    alert(data.message || '비밀번호 변경에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('비밀번호 재설정 오류:', error);
                alert('시스템 오류가 발생했습니다.');
            })
            .finally(() => {
                submitBtn.disabled = false;
                submitBtn.textContent = originalBtnText;
            });
        });
    </script>
</body>
</html>
