<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디/비밀번호 찾기 - 복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="resources/css/project_findAccount.css">
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

                    <div class="error-message" id="findId_notFoundError" style="text-align: center; margin-bottom: 15px;">입력하신 정보와 일치하는 회원이 없습니다. 다시 시도해주세요.</div>

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
                            <button class="action-btn primary" onclick="goToLoginWithEmail()">로그인</button>
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

                    <div class="error-message" id="pw_notFoundError" style="text-align: center; margin-bottom: 15px;">입력하신 정보와 일치하는 회원이 없습니다. 다시 시도해주세요.</div>

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
                        <div class="hint-text">영문, 숫자, 특수문자를 모두 포함하여 8자 이상으로 입력해주세요.</div>
                        <div class="error-message" id="pw_passwordError">영문, 숫자, 특수문자를 모두 포함하여 8자 이상이어야 합니다.</div>
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

    <!-- JSP 변수를 JavaScript로 전달 -->
    <script>
        const contextPath = '${pageContext.request.contextPath}';
    </script>

    <!-- 외부 JavaScript 파일 로드 -->
    <script src="resources/js/project_findAccount.js"></script>
</body>
</html>
