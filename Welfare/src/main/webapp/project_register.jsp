<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - 복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="resources/css/project_register.css">
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

    <script type="text/javascript">
        // JSP 변수를 JavaScript로 전달
        const contextPath = '${pageContext.request.contextPath}';

        // 유저 아이콘 클릭 이벤트 (JSP 표현식 포함)
        document.addEventListener('DOMContentLoaded', function() {
            const userIcon = document.getElementById('userIcon');
            if (userIcon) {
                userIcon.addEventListener('click', function() {
                    window.location.href = '${pageContext.request.contextPath}/projectLogin.jsp';
                });
            }
        });
    </script>
    <script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
    <script src="resources/js/project_register.js"></script>

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
                               pattern="[0-9]{6}"
                               inputmode="numeric">
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
                    <div class="password-hint">영문, 숫자, 특수문자 3가지 조합 8자 이상</div>
                    <div class="error-message" id="passwordError">영문, 숫자, 특수문자를 모두 포함한 8자 이상이어야 합니다.</div>
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

                <div class="terms-container">
                    <div class="checkbox-group">
                        <label class="checkbox-label main">
                            <input type="checkbox" id="agreeAll">
                            <span>약관 전체 동의</span>
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


    <div id="successModal" class="success-modal">
        <div class="success-content">
            <h2 class="success-title">복지24 회원가입이<br>완료되었습니다</h2>
            <p class="success-subtitle">로그인 후 복지24의 다양한 서비스를<br>이용하실 수 있습니다.</p>
            <button class="goto-login-btn" onclick="goToLogin()">
                로그인 하러가기
            </button>
        </div>
    </div>
</body>
</html>
