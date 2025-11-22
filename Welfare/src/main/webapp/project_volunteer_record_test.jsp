<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>봉사 후기 테스트</title>
</head>
<body>
    <h1>봉사 후기 페이지 테스트</h1>
    <p>API 테스트 중...</p>
    <div id="result"></div>

    <script>
        fetch('/bdproject/api/volunteer/review/list')
            .then(response => response.json())
            .then(data => {
                document.getElementById('result').innerHTML =
                    '<pre>' + JSON.stringify(data, null, 2) + '</pre>';
            })
            .catch(error => {
                document.getElementById('result').innerHTML =
                    '<p style="color: red;">오류: ' + error.message + '</p>';
            });
    </script>
</body>
</html>
