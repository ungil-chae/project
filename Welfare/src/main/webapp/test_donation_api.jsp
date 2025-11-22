<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>기부 API 테스트</title>
</head>
<body>
    <h1>기부 API 테스트</h1>

    <div>
        <h2>세션 정보</h2>
        <p>세션 ID (id): <%= session.getAttribute("id") %></p>
        <p>세션 userId: <%= session.getAttribute("userId") %></p>
    </div>

    <button onclick="testLogin()">테스트 로그인</button>
    <button onclick="testDonation()">기부 테스트</button>

    <div id="result" style="margin-top: 20px; padding: 10px; border: 1px solid #ccc;">
        결과가 여기에 표시됩니다.
    </div>

    <script>
        function testLogin() {
            // 임시 세션 설정
            fetch('/bdproject/login/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'id=admin&pwd=admin123&toURL=/test_donation_api.jsp&rememberId=false'
            })
            .then(response => {
                console.log('로그인 응답:', response);
                if (response.redirected) {
                    window.location.href = response.url;
                }
            })
            .catch(error => {
                console.error('로그인 오류:', error);
            });
        }

        function testDonation() {
            const formData = new URLSearchParams();
            formData.append('amount', 50000);
            formData.append('donationType', 'onetime');
            formData.append('category', '노인복지');
            formData.append('donorName', '테스트후원자');
            formData.append('donorEmail', 'test@test.com');
            formData.append('donorPhone', '010-1234-5678');
            formData.append('message', '테스트 기부입니다');

            console.log('전송 데이터:', formData.toString());

            fetch('/bdproject/api/donation/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formData.toString()
            })
            .then(response => {
                console.log('응답 상태:', response.status);
                console.log('응답 타입:', response.headers.get('content-type'));

                const contentType = response.headers.get('content-type');
                if (contentType && contentType.includes('text/html')) {
                    return response.text().then(html => {
                        document.getElementById('result').innerHTML =
                            '<h3>HTML 에러 응답 (500):</h3><pre>' +
                            html.substring(0, 1000).replace(/</g, '&lt;').replace(/>/g, '&gt;') +
                            '</pre>';
                        throw new Error('서버 오류');
                    });
                }

                return response.json();
            })
            .then(data => {
                console.log('응답 데이터:', data);
                document.getElementById('result').innerHTML =
                    '<h3>성공 응답:</h3><pre>' + JSON.stringify(data, null, 2) + '</pre>';
            })
            .catch(error => {
                console.error('오류:', error);
                document.getElementById('result').innerHTML +=
                    '<h3>오류:</h3><p>' + error.message + '</p>';
            });
        }
    </script>
</body>
</html>
