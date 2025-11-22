<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>API Test Page</title>
    <style>
        body {
            font-family: 'Courier New', monospace;
            padding: 20px;
            background: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 10px;
        }
        .test-section {
            margin: 20px 0;
            padding: 15px;
            background: #f9f9f9;
            border-left: 4px solid #2196F3;
        }
        button {
            background: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 4px;
            margin-right: 10px;
        }
        button:hover {
            background: #45a049;
        }
        .result {
            margin-top: 15px;
            padding: 10px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        .success {
            color: #4CAF50;
        }
        .error {
            color: #f44336;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔧 복지24 API 테스트 페이지</h1>

        <div class="test-section">
            <h2>0. Health Check (기본 서버 상태)</h2>
            <button onclick="testHealth()">Health Check</button>
            <div id="healthResult" class="result"></div>
        </div>

        <div class="test-section">
            <h2>1. Auth API 테스트</h2>
            <button onclick="testAuthApi()">Auth API 테스트</button>
            <div id="authResult" class="result"></div>
        </div>

        <div class="test-section">
            <h2>2. Email API 테스트</h2>
            <button onclick="testEmailApi()">Email API 테스트</button>
            <div id="emailResult" class="result"></div>
        </div>

        <div class="test-section">
            <h2>3. 이메일 인증 코드 발송 테스트</h2>
            <input type="email" id="testEmail" placeholder="이메일 입력" value="test123@test.com" style="padding: 8px; width: 300px;">
            <button onclick="testSendCode()">인증 코드 발송</button>
            <div id="sendCodeResult" class="result"></div>
        </div>

        <div class="test-section">
            <h2>4. 서버 정보</h2>
            <div class="result">
                <strong>Context Path:</strong> ${pageContext.request.contextPath}<br>
                <strong>Server Info:</strong> <%= application.getServerInfo() %><br>
                <strong>Servlet Version:</strong> <%= application.getMajorVersion() %>.<%=application.getMinorVersion() %>
            </div>
        </div>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';

        function testHealth() {
            const resultDiv = document.getElementById('healthResult');
            resultDiv.innerHTML = '테스트 중...';

            fetch(contextPath + '/api/health')
                .then(response => {
                    console.log('Health check status:', response.status);
                    return response.json();
                })
                .then(data => {
                    resultDiv.innerHTML = '<span class="success">✅ 성공</span>\n' + JSON.stringify(data, null, 2);
                })
                .catch(error => {
                    resultDiv.innerHTML = '<span class="error">❌ 실패</span>\n' + error.toString();
                });
        }

        function testAuthApi() {
            const resultDiv = document.getElementById('authResult');
            resultDiv.innerHTML = '테스트 중...';

            fetch(contextPath + '/api/auth/test')
                .then(response => response.json())
                .then(data => {
                    resultDiv.innerHTML = '<span class="success">✅ 성공</span>\n' + JSON.stringify(data, null, 2);
                })
                .catch(error => {
                    resultDiv.innerHTML = '<span class="error">❌ 실패</span>\n' + error.toString();
                });
        }

        function testEmailApi() {
            const resultDiv = document.getElementById('emailResult');
            resultDiv.innerHTML = '테스트 중...';

            fetch(contextPath + '/api/email/test')
                .then(response => response.json())
                .then(data => {
                    resultDiv.innerHTML = '<span class="success">✅ 성공</span>\n' + JSON.stringify(data, null, 2);
                })
                .catch(error => {
                    resultDiv.innerHTML = '<span class="error">❌ 실패</span>\n' + error.toString();
                });
        }

        function testSendCode() {
            const resultDiv = document.getElementById('sendCodeResult');
            const email = document.getElementById('testEmail').value;

            if (!email) {
                resultDiv.innerHTML = '<span class="error">이메일을 입력하세요</span>';
                return;
            }

            resultDiv.innerHTML = '발송 중...';

            const formData = new URLSearchParams();
            formData.append('email', email);

            fetch(contextPath + '/api/email/send-signup-code', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formData.toString()
            })
            .then(response => {
                console.log('Response status:', response.status);
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error('HTTP ' + response.status + ': ' + text.substring(0, 200));
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    resultDiv.innerHTML = '<span class="success">✅ 성공</span>\n' + JSON.stringify(data, null, 2);
                } else {
                    resultDiv.innerHTML = '<span class="error">❌ 실패</span>\n' + JSON.stringify(data, null, 2);
                }
            })
            .catch(error => {
                resultDiv.innerHTML = '<span class="error">❌ 오류</span>\n' + error.toString();
            });
        }
    </script>
</body>
</html>
