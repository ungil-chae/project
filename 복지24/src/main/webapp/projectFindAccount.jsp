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
            <form id="findPasswordForm">
                <div class="form-group">
                    <label class="form-label">아이디</label>
                    <input type="text" class="form-input" name="username" placeholder="아이디 입력" required>
                </div>

                <div class="form-group">
                    <label class="form-label">이메일</label>
                    <input type="email" class="form-input" name="email" placeholder="가입 시 입력한 이메일" required>
                </div>

                <button type="submit" class="submit-btn">임시 비밀번호 발송</button>

                <div class="info-text">
                    💡 등록된 이메일로 임시 비밀번호를 발송합니다.<br>
                    로그인 후 반드시 비밀번호를 변경해주세요.
                </div>

                <div class="result-box" id="password-result">
                    <div class="result-title">✅ 임시 비밀번호 발송 완료</div>
                    <div class="result-content" id="password-result-text">등록된 이메일로 임시 비밀번호가 발송되었습니다.</div>
                </div>
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

            // 실제로는 서버 API 호출 후 결과를 받아야 함
            // 여기서는 데모를 위해 임시 데이터 표시
            const maskedId = email.split('@')[0].substring(0, 3) + '***';
            document.getElementById('id-result-text').textContent = maskedId + '@' + email.split('@')[1];
            document.getElementById('id-result').classList.add('show');

            // 실제 구현 예시:
            // fetch('/api/find-id', {
            //     method: 'POST',
            //     headers: { 'Content-Type': 'application/json' },
            //     body: JSON.stringify({ name, email })
            // })
            // .then(res => res.json())
            // .then(data => {
            //     document.getElementById('id-result-text').textContent = data.userId;
            //     document.getElementById('id-result').classList.add('show');
            // });
        });

        // 비밀번호 찾기 폼 제출
        document.getElementById('findPasswordForm').addEventListener('submit', function(e) {
            e.preventDefault();

            const formData = new FormData(this);
            const username = formData.get('username');
            const email = formData.get('email');

            console.log('비밀번호 찾기:', { username, email });

            // 결과 표시
            document.getElementById('password-result').classList.add('show');

            // 실제 구현 예시:
            // fetch('/api/reset-password', {
            //     method: 'POST',
            //     headers: { 'Content-Type': 'application/json' },
            //     body: JSON.stringify({ username, email })
            // })
            // .then(res => res.json())
            // .then(data => {
            //     document.getElementById('password-result').classList.add('show');
            // });
        });
    </script>
</body>
</html>
