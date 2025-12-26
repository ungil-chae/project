let verifiedEmail = '';
let verifiedCode = '';
let timer = null;
let remainingTime = 600;

// 인증 코드 발송
function sendResetCode() {
    const email = document.getElementById('email').value.trim();

    if (!email) {
        alert('이메일을 입력해주세요.');
        return;
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        alert('올바른 이메일 형식이 아닙니다.');
        return;
    }

    const sendCodeBtn = document.getElementById('sendCodeBtn');
    sendCodeBtn.disabled = true;
    sendCodeBtn.textContent = '발송중...';

    fetch(contextPath + '/api/password/send-code', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'email=' + encodeURIComponent(email)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            verifiedEmail = email;
            document.getElementById('emailError').style.display = 'none';
            document.getElementById('emailSuccess').style.display = 'block';
            document.getElementById('email').readOnly = true;
            document.getElementById('email').classList.add('success');
            sendCodeBtn.textContent = '재발송';
            sendCodeBtn.disabled = false;

            // Step 2 표시
            document.getElementById('step2').classList.add('active');
            startTimer();

            alert('인증 코드가 이메일로 발송되었습니다.');
        } else {
            sendCodeBtn.textContent = '인증요청';
            sendCodeBtn.disabled = false;
            document.getElementById('emailError').style.display = 'block';
            document.getElementById('email').classList.add('error');
            alert(data.message || '인증 코드 발송 실패');
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
    remainingTime = 600;
    updateTimerDisplay();

    if (timer) clearInterval(timer);

    timer = setInterval(function() {
        remainingTime--;
        updateTimerDisplay();

        if (remainingTime <= 0) {
            clearInterval(timer);
            document.getElementById('timerDisplay').textContent = '인증 시간이 만료되었습니다.';
            document.getElementById('verifyBtn').disabled = true;
        }
    }, 1000);
}

function updateTimerDisplay() {
    const minutes = Math.floor(remainingTime / 60);
    const seconds = remainingTime % 60;
    document.getElementById('timerDisplay').textContent =
        '남은 시간: ' + minutes + '분 ' + (seconds < 10 ? '0' : '') + seconds + '초';
}

// 인증 코드 검증
function verifyResetCode() {
    const code = document.getElementById('verificationCode').value.trim();

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
            document.getElementById('codeError').style.display = 'none';
            document.getElementById('verificationCode').readOnly = true;
            document.getElementById('verificationCode').classList.add('success');
            verifyBtn.textContent = '완료';
            document.getElementById('sendCodeBtn').disabled = true;

            if (timer) clearInterval(timer);
            document.getElementById('timerDisplay').textContent = '✓ 인증 완료';
            document.getElementById('timerDisplay').style.color = '#10b981';

            // Step 3 표시
            document.getElementById('step3').classList.add('active');

            alert('인증이 완료되었습니다. 새 비밀번호를 설정해주세요.');
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

// 비밀번호 재설정
function resetPassword() {
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    // 비밀번호 검증
    const passwordRegex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,}$/;
    if (!passwordRegex.test(newPassword)) {
        document.getElementById('passwordError').style.display = 'block';
        document.getElementById('newPassword').classList.add('error');
        alert('비밀번호는 숫자, 특수문자를 포함한 8자 이상이어야 합니다.');
        return;
    }

    if (newPassword !== confirmPassword) {
        document.getElementById('confirmError').style.display = 'block';
        document.getElementById('confirmPassword').classList.add('error');
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
            // Step 4 표시
            document.getElementById('step1').classList.remove('active');
            document.getElementById('step2').classList.remove('active');
            document.getElementById('step3').classList.remove('active');
            document.getElementById('step4').classList.add('active');

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

// 비밀번호 유효성 검사
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('newPassword').addEventListener('input', function() {
        const password = this.value;
        const regex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,}$/;

        if (password && !regex.test(password)) {
            this.classList.add('error');
            this.classList.remove('success');
            document.getElementById('passwordError').style.display = 'block';
        } else if (password) {
            this.classList.remove('error');
            this.classList.add('success');
            document.getElementById('passwordError').style.display = 'none';
        }

        checkPasswordMatch();
    });

    // 비밀번호 일치 확인
    function checkPasswordMatch() {
        const password = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (confirmPassword && password !== confirmPassword) {
            document.getElementById('confirmPassword').classList.add('error');
            document.getElementById('confirmPassword').classList.remove('success');
            document.getElementById('confirmError').style.display = 'block';
        } else if (confirmPassword) {
            document.getElementById('confirmPassword').classList.remove('error');
            document.getElementById('confirmPassword').classList.add('success');
            document.getElementById('confirmError').style.display = 'none';
        }
    }

    document.getElementById('confirmPassword').addEventListener('input', checkPasswordMatch);

    // 인증 코드 입력 시 자동으로 숫자만 입력되도록
    document.getElementById('verificationCode').addEventListener('input', function(e) {
        this.value = this.value.replace(/[^0-9]/g, '');
    });
});
