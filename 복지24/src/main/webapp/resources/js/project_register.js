// Global variables
let emailVerified = false;
let verificationTimer = null;
let remainingTime = 600; // 10분
let isTimerExpired = false; // 타이머 만료 여부
let contextPath = ''; // JSP에서 초기화됨

// Google Translate 초기화
function googleTranslateElementInit() {
    new google.translate.TranslateElement({
        pageLanguage: 'ko',
        includedLanguages: 'ko,en,ja,zh-CN,zh-TW,es,fr,de,ru,vi,th',
        layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
        autoDisplay: false
    }, 'google_translate_element');
}

// 가입하기 버튼 활성화/비활성화 함수
function updateSubmitButton() {
    const allChecked = Array.from(document.querySelectorAll('.terms-check'))
        .every(cb => cb.checked);
    const submitBtn = document.querySelector('.submit-btn');

    if (allChecked) {
        submitBtn.classList.add('active');
        submitBtn.disabled = false;
    } else {
        submitBtn.classList.remove('active');
        submitBtn.disabled = true;
    }
}

// 이메일 인증 코드 발송
function sendVerificationCode() {
    const emailInput = document.getElementById('email');
    const email = emailInput.value.trim();

    if (!email) {
        alert('이메일을 입력해주세요.');
        return;
    }

    // 이메일 형식 검증
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        alert('올바른 이메일 형식이 아닙니다.');
        return;
    }

    // 버튼 비활성화
    const sendCodeBtn = document.getElementById('sendCodeBtn');
    sendCodeBtn.disabled = true;
    sendCodeBtn.textContent = '발송중...';

    // 서버에 인증 코드 발송 요청
    fetch(contextPath + '/api/email/send-signup-code', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'email=' + encodeURIComponent(email)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            sendCodeBtn.textContent = '재발송';
            sendCodeBtn.disabled = false;
            document.getElementById('emailError').style.display = 'none';
            document.getElementById('emailSent').style.display = 'block';
            document.getElementById('verificationCodeGroup').style.display = 'block';
            emailInput.readOnly = true;
            emailInput.classList.add('success');

            // 타이머 시작
            startTimer();

            alert('인증 코드가 이메일로 발송되었습니다.');
        } else {
            sendCodeBtn.textContent = '인증요청';
            sendCodeBtn.disabled = false;

            // 이미 가입된 이메일인 경우 가입일자 표시
            if (data.alreadyRegistered && data.joinDate) {
                document.getElementById('emailError').textContent =
                    '이미 가입되어 있는 계정입니다. (가입일: ' + data.joinDate + ')';
                document.getElementById('emailError').style.display = 'block';
                emailInput.classList.add('error');
                alert('이미 가입되어 있는 계정입니다.\n가입일: ' + data.joinDate);
            } else if (data.message && data.message.includes('이미 가입된')) {
                document.getElementById('emailError').textContent = '이미 가입된 이메일입니다.';
                document.getElementById('emailError').style.display = 'block';
                emailInput.classList.add('error');
                alert(data.message);
            } else {
                alert(data.message || '인증 코드 발송 실패');
            }
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('인증 코드 발송 중 오류가 발생했습니다.');
        sendCodeBtn.disabled = false;
        sendCodeBtn.textContent = '인증요청';
    });
}

// 타이머 시작
function startTimer() {
    remainingTime = 600; // 10분 리셋
    isTimerExpired = false; // 타이머 만료 상태 초기화
    updateTimerDisplay();

    // 인증코드 입력란 활성화
    const codeInput = document.getElementById('verificationCode');
    codeInput.disabled = false;
    codeInput.readOnly = false;

    if (verificationTimer) {
        clearInterval(verificationTimer);
    }

    verificationTimer = setInterval(function() {
        remainingTime--;
        updateTimerDisplay();

        if (remainingTime <= 0) {
            clearInterval(verificationTimer);
            isTimerExpired = true; // 타이머 만료 플래그 설정
            document.getElementById('timerDisplay').textContent = '인증 시간이 만료되었습니다. 다시 요청해주세요.';
            document.getElementById('verifyBtn').disabled = true;

            // 인증코드 입력란 비활성화 (요구사항 3)
            codeInput.disabled = true;
            codeInput.placeholder = '인증 시간이 만료되었습니다';
        }
    }, 1000);
}

// 타이머 표시 업데이트
function updateTimerDisplay() {
    const minutes = Math.floor(remainingTime / 60);
    const seconds = remainingTime % 60;
    document.getElementById('timerDisplay').textContent =
        '남은 시간: ' + minutes + '분 ' + (seconds < 10 ? '0' : '') + seconds + '초';
}

// 인증 코드 검증
function verifyCode() {
    // 타이머 만료 확인 (요구사항 4)
    if (isTimerExpired || remainingTime <= 0) {
        alert('인증번호 유효시간이 초과되었습니다.');
        return;
    }

    const email = document.getElementById('email').value.trim();
    const code = document.getElementById('verificationCode').value.trim();

    if (!code || code.length !== 6) {
        alert('6자리 인증 코드를 입력해주세요.');
        return;
    }

    const verifyBtn = document.getElementById('verifyBtn');
    verifyBtn.disabled = true;
    verifyBtn.textContent = '확인중...';

    fetch(contextPath + '/api/email/verify-signup-code', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'email=' + encodeURIComponent(email) + '&code=' + encodeURIComponent(code)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            emailVerified = true;
            document.getElementById('codeError').style.display = 'none';
            document.getElementById('verificationCode').readOnly = true;
            document.getElementById('verificationCode').classList.add('success');
            verifyBtn.textContent = '완료';
            verifyBtn.disabled = true;
            document.getElementById('sendCodeBtn').disabled = true;

            // 타이머 정지
            if (verificationTimer) {
                clearInterval(verificationTimer);
            }
            document.getElementById('timerDisplay').textContent = '인증 완료';
            document.getElementById('timerDisplay').style.color = '#28a745';
        } else {
            verifyBtn.textContent = '확인';
            verifyBtn.disabled = false;
            document.getElementById('codeError').style.display = 'block';
            document.getElementById('verificationCode').classList.add('error');
            alert(data.message || '인증 코드 검증 실패');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('인증 코드 검증 중 오류가 발생했습니다.');
        verifyBtn.disabled = false;
        verifyBtn.textContent = '확인';
    });
}

// 비밀번호 일치 확인
function checkPasswordMatch() {
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('passwordConfirm').value;
    const confirmInput = document.getElementById('passwordConfirm');

    if (confirmPassword && password !== confirmPassword) {
        confirmInput.classList.add('error');
        document.getElementById('passwordConfirmError').style.display = 'block';
    } else {
        confirmInput.classList.remove('error');
        document.getElementById('passwordConfirmError').style.display = 'none';
    }
}

// 성공 모달 표시
function showSuccessModal() {
    const modal = document.getElementById('successModal');
    modal.classList.add('show');
}

// 로그인 페이지로 이동
function goToLogin() {
    window.location.href = contextPath + '/projectLogin.jsp';
}

// DOM 로드 완료 후 실행
document.addEventListener('DOMContentLoaded', function() {
    // Google Translate 토글
    const languageToggle = document.getElementById("languageToggle");
    const translateElement = document.getElementById("google_translate_element");

    if (languageToggle && translateElement) {
        languageToggle.addEventListener("click", function(e) {
            e.stopPropagation();
            if (translateElement.style.display === "none" || translateElement.style.display === "") {
                translateElement.style.display = "block";
            } else {
                translateElement.style.display = "none";
            }
        });

        document.addEventListener("click", function(e) {
            if (!e.target.closest(".language-selector")) {
                translateElement.style.display = "none";
            }
        });
    }

    // 유저 아이콘 클릭 이벤트는 JSP에서 처리 (contextPath 필요)

    // 전체 동의 체크박스
    document.getElementById('agreeAll').addEventListener('change', function() {
        const isChecked = this.checked;
        document.querySelectorAll('.terms-check').forEach(checkbox => {
            checkbox.checked = isChecked;
        });
        updateSubmitButton();  // 버튼 상태 업데이트
    });

    // 개별 체크박스 - 전체 동의 상태 업데이트
    document.querySelectorAll('.terms-check').forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            const allChecked = Array.from(document.querySelectorAll('.terms-check'))
                .every(cb => cb.checked);
            document.getElementById('agreeAll').checked = allChecked;
            updateSubmitButton();  // 버튼 상태 업데이트
        });
    });

    // 페이지 로드 시 버튼 상태 초기화
    updateSubmitButton();

    // 비밀번호 유효성 검사 (영문, 숫자, 특수문자 3가지 조합 8자 이상)
    document.getElementById('password').addEventListener('input', function() {
        const password = this.value;
        // 영문, 숫자, 특수문자 3가지 모두 포함 필수
        const regex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;

        if (password && !regex.test(password)) {
            this.classList.add('error');
            document.getElementById('passwordError').style.display = 'block';
        } else {
            this.classList.remove('error');
            document.getElementById('passwordError').style.display = 'none';
        }

        // 비밀번호 확인 필드도 체크
        const confirmInput = document.getElementById('passwordConfirm');
        if (confirmInput.value) {
            checkPasswordMatch();
        }
    });

    // 비밀번호 확인 입력 이벤트
    document.getElementById('passwordConfirm').addEventListener('input', checkPasswordMatch);

    // 인증번호 입력란 - 숫자만 입력 가능 (요구사항 2)
    document.getElementById('verificationCode').addEventListener('input', function(e) {
        // 숫자가 아닌 문자 제거
        this.value = this.value.replace(/[^0-9]/g, '');
    });

    // 전화번호 형식 자동 변환
    document.getElementById('phone').addEventListener('input', function(e) {
        let value = e.target.value.replace(/[^\d]/g, '');
        let formattedValue = '';

        if (value.length <= 3) {
            formattedValue = value;
        } else if (value.length <= 7) {
            formattedValue = value.slice(0, 3) + '-' + value.slice(3);
        } else if (value.length <= 11) {
            formattedValue = value.slice(0, 3) + '-' + value.slice(3, 7) + '-' + value.slice(7);
        }

        e.target.value = formattedValue;
    });

    // 폼 제출
    document.getElementById('signupForm').addEventListener('submit', function(e) {
        e.preventDefault();

        if (!emailVerified) {
            alert('이메일 인증을 완료해주세요.');
            return;
        }

        // 약관 동의 확인
        const agreeTerms = document.getElementById('agreeTerms').checked;
        const agreePrivacy = document.getElementById('agreePrivacy').checked;
        const agreeAge = document.getElementById('agreeAge').checked;

        if (!agreeTerms || !agreePrivacy || !agreeAge) {
            alert('필수 약관에 모두 동의해주세요.');
            return;
        }

        // 비밀번호 검증 (영문, 숫자, 특수문자 3가지 조합 8자 이상)
        const password = document.getElementById('password').value;
        const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;
        if (!passwordRegex.test(password)) {
            alert('비밀번호는 영문, 숫자, 특수문자를 모두 포함한 8자 이상이어야 합니다.');
            return;
        }

        // 비밀번호 일치 확인
        const passwordConfirm = document.getElementById('passwordConfirm').value;
        if (password !== passwordConfirm) {
            alert('비밀번호가 일치하지 않습니다.');
            return;
        }

        // 폼 데이터 수집
        const formData = {
            pwd: password,
            name: document.getElementById('username').value,
            email: document.getElementById('email').value,
            phone: document.getElementById('phone').value.replace(/-/g, '')
        };

        // 디버깅: 전송 데이터 확인
        console.log('=== 회원가입 데이터 전송 ===');
        console.log('formData:', formData);

        // URLSearchParams로 변환
        const params = new URLSearchParams(formData).toString();
        console.log('params:', params);

        // AJAX 요청으로 회원가입 처리
        fetch(contextPath + '/api/auth/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // 성공 모달 표시
                showSuccessModal();
            } else {
                alert(data.message || '회원가입 실패');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('회원가입 중 오류가 발생했습니다.');
        });
    });
});
