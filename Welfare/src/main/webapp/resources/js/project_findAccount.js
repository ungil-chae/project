// 전역 변수
let verifiedEmail = '';
let verifiedCode = '';
let timer = null;
let remainingTime = 600;
let selectedEmail = '';

// 이메일 마스킹 함수 (클라이언트 측 fallback)
function maskEmailClient(email) {
    if (!email || !email.includes('@')) return email;
    const [localPart, domain] = email.split('@');
    if (localPart.length <= 2) {
        return localPart.charAt(0) + '*'.repeat(localPart.length - 1) + '@' + domain;
    }
    const visibleStart = localPart.substring(0, 2);
    const visibleEnd = localPart.substring(localPart.length - 1);
    const maskedLength = Math.max(localPart.length - 3, 1);
    return visibleStart + '*'.repeat(maskedLength) + visibleEnd + '@' + domain;
}

// 탭 전환
function switchTab(tabName) {
    const tabs = document.querySelectorAll('.tab-btn');
    const panels = document.querySelectorAll('.tab-panel');

    tabs.forEach(tab => tab.classList.remove('active'));
    panels.forEach(panel => panel.classList.remove('active'));

    if (tabName === 'findId') {
        tabs[0].classList.add('active');
        document.getElementById('findIdTab').classList.add('active');
    } else if (tabName === 'findPassword') {
        tabs[1].classList.add('active');
        document.getElementById('findPasswordTab').classList.add('active');
    }
}

// ========== 아이디 찾기 ==========
function findUserId() {
    const name = document.getElementById('findId_name').value.trim();
    const phone = document.getElementById('findId_phone').value.trim().replace(/[^0-9]/g, '');

    let isValid = true;

    if (!name) {
        document.getElementById('findId_nameError').style.display = 'block';
        document.getElementById('findId_name').classList.add('error');
        isValid = false;
    } else {
        document.getElementById('findId_nameError').style.display = 'none';
        document.getElementById('findId_name').classList.remove('error');
    }

    if (!phone) {
        document.getElementById('findId_phoneError').textContent = '전화번호를 입력해주세요.';
        document.getElementById('findId_phoneError').style.display = 'block';
        document.getElementById('findId_phone').classList.add('error');
        isValid = false;
    } else if (phone.length !== 11) {
        document.getElementById('findId_phoneError').textContent = '전화번호는 11자리여야 합니다.';
        document.getElementById('findId_phoneError').style.display = 'block';
        document.getElementById('findId_phone').classList.add('error');
        isValid = false;
    } else if (!phone.startsWith('010')) {
        document.getElementById('findId_phoneError').textContent = '올바른 휴대폰 번호를 입력해주세요.';
        document.getElementById('findId_phoneError').style.display = 'block';
        document.getElementById('findId_phone').classList.add('error');
        isValid = false;
    } else {
        document.getElementById('findId_phoneError').style.display = 'none';
        document.getElementById('findId_phone').classList.remove('error');
    }

    if (!isValid) return;

    const formData = new URLSearchParams();
    formData.append('name', name);
    formData.append('phone', phone);

    fetch(contextPath + '/api/auth/find-id-by-phone', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: formData.toString()
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // 에러 메시지 숨기기
            document.getElementById('findId_notFoundError').style.display = 'none';

            // 이메일 목록 생성 (현재는 1개지만 확장 가능)
            const emailList = document.getElementById('emailList');
            const currentDate = new Date().toISOString().split('T')[0].replace(/-/g, '.').substring(2);
            const foundEmail = data.email;
            // 마스킹된 이메일 사용 (보안)
            const maskedEmail = data.maskedEmail || maskEmailClient(foundEmail);

            // JSP EL과 JavaScript 템플릿 리터럴 충돌 방지를 위해 문자열 연결 사용
            emailList.innerHTML =
                '<div class="email-item selected" onclick="selectEmail(this, \'' + foundEmail + '\')">' +
                    '<div class="radio-circle"></div>' +
                    '<div class="email-info">' +
                        '<div class="email-address">' + maskedEmail + '</div>' +
                        '<div class="email-date">' + currentDate + ' 가입</div>' +
                    '</div>' +
                '</div>';

            selectedEmail = foundEmail;
            document.getElementById('findIdForm').classList.remove('active');
            document.getElementById('findIdResult').classList.add('active');
        } else {
            // 빨간 글씨로 에러 메시지 표시
            document.getElementById('findId_notFoundError').style.display = 'block';
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('아이디 찾기 중 오류가 발생했습니다.');
    });
}

function selectEmail(element, email) {
    // 모든 이메일 아이템에서 selected 제거
    document.querySelectorAll('.email-item').forEach(item => {
        item.classList.remove('selected');
    });

    // 클릭한 아이템에 selected 추가
    element.classList.add('selected');
    selectedEmail = email;
}

// 선택한 이메일을 세션에 저장하고 로그인 페이지로 이동
function goToLoginWithEmail() {
    if (selectedEmail) {
        // 세션 스토리지에 선택한 이메일 저장
        sessionStorage.setItem('foundEmail', selectedEmail);
    }
    // 로그인 페이지로 이동
    location.href = contextPath + '/projectLogin.jsp';
}

// ========== 비밀번호 찾기 ==========
function sendResetCode() {
    const name = document.getElementById('pw_name').value.trim();
    const email = document.getElementById('pw_email').value.trim();

    let isValid = true;

    if (!name) {
        document.getElementById('pw_nameError').style.display = 'block';
        document.getElementById('pw_name').classList.add('error');
        isValid = false;
    } else {
        document.getElementById('pw_nameError').style.display = 'none';
        document.getElementById('pw_name').classList.remove('error');
    }

    if (!email) {
        document.getElementById('pw_emailError').textContent = '이메일을 입력해주세요.';
        document.getElementById('pw_emailError').style.display = 'block';
        document.getElementById('pw_email').classList.add('error');
        isValid = false;
    } else {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            document.getElementById('pw_emailError').textContent = '올바른 이메일 형식이 아닙니다.';
            document.getElementById('pw_emailError').style.display = 'block';
            document.getElementById('pw_email').classList.add('error');
            isValid = false;
        } else {
            document.getElementById('pw_emailError').style.display = 'none';
            document.getElementById('pw_email').classList.remove('error');
        }
    }

    if (!isValid) return;

    const sendCodeBtn = document.getElementById('sendCodeBtn');
    sendCodeBtn.disabled = true;
    sendCodeBtn.textContent = '발송중...';

    fetch(contextPath + '/api/password/send-code', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'email=' + encodeURIComponent(email) + '&name=' + encodeURIComponent(name)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            verifiedEmail = email;
            document.getElementById('pw_emailError').style.display = 'none';
            document.getElementById('pw_notFoundError').style.display = 'none';
            document.getElementById('pw_email').readOnly = true;
            document.getElementById('pw_email').classList.add('success');
            document.getElementById('pw_name').readOnly = true;
            document.getElementById('pw_name').classList.add('success');
            sendCodeBtn.textContent = '재발송';
            sendCodeBtn.disabled = false;

            document.getElementById('pwStep2').classList.add('active');
            startTimer();

            alert('인증 코드가 이메일로 발송되었습니다.');
        } else {
            sendCodeBtn.textContent = '인증번호 받기';
            sendCodeBtn.disabled = false;
            // 빨간 글씨로 에러 메시지 표시
            document.getElementById('pw_notFoundError').style.display = 'block';
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('인증 코드 발송 중 오류가 발생했습니다.');
        sendCodeBtn.disabled = false;
        sendCodeBtn.textContent = '인증번호 받기';
    });
}

function startTimer() {
    remainingTime = 600;
    updateTimerDisplay();

    if (timer) clearInterval(timer);

    timer = setInterval(function() {
        remainingTime--;
        updateTimerDisplay();

        if (remainingTime <= 0) {
            clearInterval(timer);
            document.getElementById('pw_timerDisplay').textContent = '인증 시간이 만료되었습니다.';
            document.getElementById('verifyBtn').disabled = true;
        }
    }, 1000);
}

function updateTimerDisplay() {
    const minutes = Math.floor(remainingTime / 60);
    const seconds = remainingTime % 60;
    document.getElementById('pw_timerDisplay').textContent =
        '남은 시간: ' + minutes + '분 ' + (seconds < 10 ? '0' : '') + seconds + '초';
}

function verifyResetCode() {
    const code = document.getElementById('pw_verificationCode').value.trim();

    if (!code || code.length !== 6) {
        alert('6자리 인증 코드를 입력해주세요.');
        return;
    }

    const verifyBtn = document.getElementById('verifyBtn');
    verifyBtn.disabled = true;
    verifyBtn.textContent = '확인중...';

    fetch(contextPath + '/api/password/verify-code', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'email=' + encodeURIComponent(verifiedEmail) + '&code=' + encodeURIComponent(code)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            verifiedCode = code;
            document.getElementById('pw_codeError').style.display = 'none';
            document.getElementById('pw_verificationCode').readOnly = true;
            document.getElementById('pw_verificationCode').classList.add('success');
            verifyBtn.textContent = '완료';
            document.getElementById('sendCodeBtn').disabled = true;

            if (timer) clearInterval(timer);
            document.getElementById('pw_timerDisplay').textContent = '✓ 인증 완료';
            document.getElementById('pw_timerDisplay').classList.add('success');

            document.getElementById('pwStep3').classList.add('active');

            alert('인증이 완료되었습니다. 새 비밀번호를 설정해주세요.');
        } else {
            verifyBtn.textContent = '확인';
            verifyBtn.disabled = false;
            document.getElementById('pw_codeError').style.display = 'block';
            document.getElementById('pw_verificationCode').classList.add('error');
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

function resetPassword() {
    const newPassword = document.getElementById('pw_newPassword').value;
    const confirmPassword = document.getElementById('pw_confirmPassword').value;

    // 비밀번호 유효성 검사 (영문, 숫자, 특수문자 모두 포함, 8자 이상)
    const hasLetter = /[a-zA-Z]/.test(newPassword);
    const hasNumber = /[0-9]/.test(newPassword);
    const hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(newPassword);
    const hasLength = newPassword.length >= 8;

    if (!hasLength || !hasLetter || !hasNumber || !hasSpecial) {
        document.getElementById('pw_passwordError').style.display = 'block';
        document.getElementById('pw_newPassword').classList.add('error');

        let missingMsg = [];
        if (!hasLength) missingMsg.push('8자 이상');
        if (!hasLetter) missingMsg.push('영문자');
        if (!hasNumber) missingMsg.push('숫자');
        if (!hasSpecial) missingMsg.push('특수문자');

        alert('비밀번호는 ' + missingMsg.join(', ') + '이(가) 필요합니다.');
        return;
    }

    if (newPassword !== confirmPassword) {
        document.getElementById('pw_confirmError').style.display = 'block';
        document.getElementById('pw_confirmPassword').classList.add('error');
        alert('비밀번호가 일치하지 않습니다.');
        return;
    }

    const resetBtn = document.getElementById('resetBtn');
    resetBtn.disabled = true;
    resetBtn.textContent = '변경중...';

    fetch(contextPath + '/api/password/reset', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'email=' + encodeURIComponent(verifiedEmail) +
              '&code=' + encodeURIComponent(verifiedCode) +
              '&newPassword=' + encodeURIComponent(newPassword)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            document.getElementById('pwStep1').classList.remove('active');
            document.getElementById('pwStep2').classList.remove('active');
            document.getElementById('pwStep3').classList.remove('active');
            document.getElementById('pwStep4').classList.add('active');

            alert('비밀번호가 성공적으로 변경되었습니다.');
        } else {
            resetBtn.disabled = false;
            resetBtn.textContent = '확인';
            alert(data.message || '비밀번호 변경 실패');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('비밀번호 변경 중 오류가 발생했습니다.');
        resetBtn.disabled = false;
        resetBtn.textContent = '확인';
    });
}

// 이벤트 리스너
document.addEventListener('DOMContentLoaded', function() {
    // 아이디 찾기 - 전화번호 숫자만
    const findIdPhone = document.getElementById('findId_phone');
    findIdPhone.addEventListener('input', function(e) {
        this.value = this.value.replace(/[^0-9]/g, '');
    });

    // 아이디 찾기 - Enter 키
    ['findId_name', 'findId_phone'].forEach(id => {
        document.getElementById(id).addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                findUserId();
            }
        });
    });

    // 비밀번호 찾기 - 비밀번호 유효성 검사 (영문, 숫자, 특수문자 모두 포함, 8자 이상)
    document.getElementById('pw_newPassword').addEventListener('input', function() {
        const password = this.value;

        const hasLetter = /[a-zA-Z]/.test(password);
        const hasNumber = /[0-9]/.test(password);
        const hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password);
        const hasLength = password.length >= 8;

        const isValid = hasLength && hasLetter && hasNumber && hasSpecial;

        if (password && !isValid) {
            this.classList.add('error');
            this.classList.remove('success');
            document.getElementById('pw_passwordError').style.display = 'block';
        } else if (password) {
            this.classList.remove('error');
            this.classList.add('success');
            document.getElementById('pw_passwordError').style.display = 'none';
        }

        checkPasswordMatch();
    });

    function checkPasswordMatch() {
        const password = document.getElementById('pw_newPassword').value;
        const confirmPassword = document.getElementById('pw_confirmPassword').value;

        if (confirmPassword && password !== confirmPassword) {
            document.getElementById('pw_confirmPassword').classList.add('error');
            document.getElementById('pw_confirmPassword').classList.remove('success');
            document.getElementById('pw_confirmError').style.display = 'block';
        } else if (confirmPassword) {
            document.getElementById('pw_confirmPassword').classList.remove('error');
            document.getElementById('pw_confirmPassword').classList.add('success');
            document.getElementById('pw_confirmError').style.display = 'none';
        }
    }

    document.getElementById('pw_confirmPassword').addEventListener('input', checkPasswordMatch);

    // 인증 코드 숫자만
    document.getElementById('pw_verificationCode').addEventListener('input', function(e) {
        this.value = this.value.replace(/[^0-9]/g, '');
    });
});
