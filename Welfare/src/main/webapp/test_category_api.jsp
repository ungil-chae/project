<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Category API Test</title>
</head>
<body>
    <h1>Category Statistics API Test</h1>
    <button onclick="testApi()">Test API</button>
    <pre id="result"></pre>

    <script>
        function testApi() {
            const resultEl = document.getElementById('result');
            resultEl.textContent = 'Loading...';

            fetch('/bdproject/api/donation/category-statistics')
                .then(response => {
                    console.log('Status:', response.status);
                    console.log('Content-Type:', response.headers.get('Content-Type'));
                    return response.text();
                })
                .then(text => {
                    console.log('Response:', text);
                    resultEl.textContent = text;

                    // JSON 파싱 시도
                    try {
                        const json = JSON.parse(text);
                        resultEl.textContent = JSON.stringify(json, null, 2);
                    } catch (e) {
                        resultEl.textContent = 'HTML Response (Error):\n' + text;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    resultEl.textContent = 'Error: ' + error.message;
                });
        }
    </script>
</body>
</html>
