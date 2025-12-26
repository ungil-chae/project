// projectLogin.js - projectLogin.jsp JavaScript
// contextPath는 JSP에서 정의되어야 합니다: const contextPath = '${pageContext.request.contextPath}';

console.log('=== Script loaded ===');
console.log('contextPath:', contextPath);

// 페이지 로드 완료 대기
window.addEventListener('DOMContentLoaded', function() {
    console.log('=== DOM loaded ===');

    const loginForm = document.getElementById('loginForm');
    console.log('loginForm element:', loginForm);

    if (!loginForm) {
        console.error('로그인 폼을 찾을 수 없습니다!');
        return;
    }

    // 아이디 찾기에서 선택한 이메일 자동 채우기
    const foundEmail = sessionStorage.getItem('foundEmail');
    if (foundEmail) {
        const emailInput = document.querySelector('input[name="email"]');
        if (emailInput) {
            emailInput.value = foundEmail;
            emailInput.classList.add('auto-filled');
            // 비밀번호 입력란에 포커스
            const passwordInput = document.querySelector('input[name="password"]');
            if (passwordInput) {
                passwordInput.focus();
            }
        }
        // 사용 후 세션 스토리지에서 제거
        sessionStorage.removeItem('foundEmail');
    }

    // 로그인 폼 AJAX 제출
    loginForm.addEventListener('submit', function(e) {
        console.log('=== Form submitted ===');
        e.preventDefault();

        const formData = new FormData(this);
        const email = formData.get('email');
        const password = formData.get('password');
        const rememberMe = document.getElementById('rememberMe').checked;

        console.log('email:', email);
        console.log('password:', password ? '***' : 'null');
        console.log('rememberMe:', rememberMe);

        const loginUrl = contextPath + '/api/auth/login';
        console.log('Login URL:', loginUrl);

        const requestBody = 'email=' + encodeURIComponent(email) +
                          '&password=' + encodeURIComponent(password) +
                          '&rememberMe=' + encodeURIComponent(rememberMe);
        console.log('Request body:', requestBody);

        // AJAX 요청으로 로그인 처리
        fetch(loginUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: requestBody
        })
        .then(response => {
            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers);
            return response.json();
        })
        .then(data => {
            console.log('Login response:', data);

            if (data.success) {
                // 로그인 성공 시 이전 사용자의 로컬 데이터 클리어
                // (새로 가입한 경우나 다른 사용자가 로그인한 경우를 대비)
                const lastLoggedInUser = localStorage.getItem('lastLoggedInUser');
                if (lastLoggedInUser !== email) {
                    // 다른 사용자가 로그인하면 로컬 스토리지 클리어
                    localStorage.clear();
                    sessionStorage.clear();
                    localStorage.setItem('lastLoggedInUser', email);
                }

                // 회원 정보를 sessionStorage에 캐싱 (API 호출 최소화)
                fetch(contextPath + '/api/member/info')
                    .then(response => response.json())
                    .then(result => {
                        if (result.success && result.data) {
                            sessionStorage.setItem('memberInfo', JSON.stringify(result.data));
                            console.log('회원 정보 sessionStorage 캐싱 완료');
                        }
                        // 메인 페이지로 이동
                        const redirectUrl = contextPath + '/project.jsp';
                        console.log('Redirecting to:', redirectUrl);
                        window.location.href = redirectUrl;
                    })
                    .catch(error => {
                        console.error('회원 정보 캐싱 실패:', error);
                        // 캐싱 실패해도 메인 페이지로 이동
                        window.location.href = contextPath + '/project.jsp';
                    });
            } else {
                console.error('Login failed:', data.message);

                // 계정 잠금 시 비밀번호 재설정 안내
                if (data.locked) {
                    const resetPassword = confirm(data.message + '\n\n비밀번호를 재설정하시겠습니까?');
                    if (resetPassword) {
                        window.location.href = contextPath + '/project_resetPassword.jsp';
                    }
                } else {
                    alert(data.message || '로그인 실패');
                }
            }
        })
        .catch(error => {
            console.error('Fetch error:', error);
            alert('로그인 중 오류가 발생했습니다: ' + error.message);
        });
    });
});

document.querySelectorAll('.form-input').forEach(input => {
    input.addEventListener('focus', function() {
        this.parentElement.classList.add('focused');
    });

    input.addEventListener('blur', function() {
        this.parentElement.classList.remove('focused');
    });
});

// 소셜 로그인 함수들
function loginWithNaver() {
    window.location.href = 'https://nid.naver.com/nidlogin.login';
}

function loginWithKakao() {
    window.location.href = 'https://accounts.kakao.com/login';
}

function loginWithGoogle() {
    window.location.href = 'https://accounts.google.com/signin';
}

function loginWithApple() {
    window.location.href = 'https://appleid.apple.com/';
}

function loginWithFacebook() {
    window.location.href = 'https://www.facebook.com/login';
}
