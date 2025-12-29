<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 재설정 - 복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="resources/css/project_resetPassword.css">
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
    </script>
    <script src="resources/js/project_resetPassword.js"></script>
</body>
</html>
