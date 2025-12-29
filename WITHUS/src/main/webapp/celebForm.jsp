<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="model.User"%>
<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<link rel="stylesheet" href="./css/celebList.css" />
<%@ include file="css/main_css.jsp"%>
<link rel="icon" href="img/icon2.png" type="image/x-icon">
<head>
<title>게시글 작성</title>
<style>
/* 기존 스타일은 유지 */
body {
	font-family: 'Arial', sans-serif;
	margin: 0;
	padding: 0;
	background-color: #fff;
	padding: 0;
}

.container {
	max-width: 1000px;
	margin: 30px auto;
}

h2 {
	margin-bottom: 20px;
}

input[type="text"], input[type="file"], textarea {
	width: 100%;
	padding: 10px;
	margin-top: 8px;
	margin-bottom: 16px;
	border: 1px solid #ccc;
	border-radius: 6px;
	font-size: 1rem;
}

.editor-block {
	width: 100%;
	border: 1px solid #ddd;
	padding: 12px;
	border-radius: 8px;
	margin-bottom: 12px;
	background-color: #fff;
}

.editor-block textarea {
	resize: vertical;
	min-height: 80px;
}

.editor-block input[type="file"] {
	background-color: #f4f4f4;
}

.button-box {
	text-align: center;
	margin-top: 24px;
}

.button-box button {
	padding: 10px 20px;
	font-size: 1rem;
	border: none;
	border-radius: 6px;
	margin-left: 10px;
	cursor: pointer;
}

.submit-btn {
	background-color: #e6f0d7;
	color: black;
}

.cancel-btn {
	background-color: #fff;
	color: black;
}

.add-block-btn {
	display: block;
	margin: 0 auto 20px;
	padding: 8px 16px;
	border-radius: 6px;
	background-color: #fff;
	color: black;
	border: none;
	cursor: pointer;
}

#response-message { /* 응답 메시지 표시 영역 추가 */
	color: green;
	font-weight: bold;
	margin-top: 15px;
}

#error-message { /* 오류 메시지 표시 영역 추가 */
	color: #d9534f;
	font-weight: bold;
	margin-top: 15px;
}
</style>
</head>

<body>
	<%@ include file="header.jsp"%>

	<nav>
		<a href="<%=contextPath%>/aiRecommend.jsp">(AI) 책 추천</a> <a
			href="<%=contextPath%>/reviewList">리뷰</a> <a
			href="<%=contextPath%>/playlist.jsp">플레이리스트</a> <a
			href="<%=contextPath%>/celebList">셀럽추천</a> <a
			href="<%=contextPath%>/mypage.jsp">마이페이지</a>
	</nav>
	<div class="container">

		<h2>셀럽 추천 글 작성</h2>

		<form id="celebForm" enctype="multipart/form-data">
			<%-- action, method 제거, id 추가 --%>
			<label>이름</label> <input type="text" name="celebName" required>
			<label>설명</label><input type="text" name="celebDescription" required>
			<label>썸네일 이미지</label> <input type="file" name="thumbnail"
				accept="image/*">

			<div id="editor-area">
				<div class="editor-block">
					<label>텍스트 입력</label>
					<textarea name="contentBlock1_text"></textarea>
				</div>
			</div>

			<div style="text-align: center; margin-bottom: 20px;">
				<button type="button" class="add-block-btn"
					onclick="addEditorBlock('text')">+ 텍스트 블록 추가</button>
				<button type="button" class="add-block-btn"
					onclick="addEditorBlock('image')">+ 이미지 블록 추가</button>
			</div>


			<div class="button-box">
				<button type="submit" class="submit-btn">작성하기</button>
				<%-- type="submit" 유지 --%>
				<button type="button" class="cancel-btn" onclick="history.back()">취소</button>
			</div>
		</form>
		<div id="response-message"></div>
		<%-- 성공 메시지 표시 영역 --%>
		<div id="error-message"></div>
		<%-- 오류 메시지 표시 영역 --%>
	</div>
	<script>
    let blockCount = 1;

    function addEditorBlock(type) {
        blockCount++;
        const editorArea = document.getElementById("editor-area");

        const blockDiv = document.createElement("div");
        blockDiv.className = "editor-block";

        if (type === "text") {
            blockDiv.innerHTML = `
                <label>텍스트 입력</label>
                <textarea name="contentBlock${blockCount}_text"></textarea>
            `;
        } else if (type === "image") {
            blockDiv.innerHTML = `
                <label>이미지 업로드</label>
                <input type="file" name="contentBlock${blockCount}_image" accept="image/*">
            `;
        } else {
            alert("알 수 없는 블록 타입입니다.");
            return;
        }

        editorArea.appendChild(blockDiv);
    }

    document.getElementById('celebForm').addEventListener('submit', async function(event) {
        event.preventDefault(); // 폼의 기본 제출 동작(새로고침) 방지

        const form = event.target;
        const formData = new FormData(form); // 파일과 텍스트를 모두 포함하는 FormData 객체 생성

        const responseMessageDiv = document.getElementById('response-message');
        const errorMessageDiv = document.getElementById('error-message');
        responseMessageDiv.textContent = ''; // 메시지 초기화
        errorMessageDiv.textContent = ''; // 메시지 초기화

        try {
            const response = await fetch('api/celeb/recommendations', { // Servlet API 엔드포인트
                method: 'POST',
                // FormData를 사용할 때는 'Content-Type' 헤더를 명시적으로 설정하지 않습니다.
                // 브라우저가 'multipart/form-data'와 경계(boundary)를 자동으로 설정합니다.
                body: formData // FormData 객체를 직접 body에 전달
            });

            const apiResponse = await response.json(); // 응답을 JSON으로 파싱

            if (response.ok) { // HTTP 상태 코드가 2xx (성공) 범위인 경우
                responseMessageDiv.textContent = apiResponse.message || '작성 성공!';
                // 성공 시 리다이렉트 또는 추가 작업 (예: 목록 페이지로 이동)
                alert(apiResponse.message || '셀럽 추천 글이 성공적으로 작성되었습니다!');
                window.location.href = 'celebList'; // 셀럽 목록 페이지로 이동 (서블릿 URL)
            } else {
                // HTTP 상태 코드가 4xx 또는 5xx 인 경우
                errorMessageDiv.textContent = apiResponse.message || `오류 발생: ${response.statusText}`;
                console.error('API 응답 오류:', apiResponse);
            }
        } catch (error) {
            console.error('폼 제출 중 오류 발생:', error);
            errorMessageDiv.textContent = '네트워크 통신 중 오류가 발생했습니다.';
        }
    });
    </script>
</body>
</html>