// project_Donation.js - 기부 페이지 JavaScript

// 전역 변수
let selectedPackageName = null;
let currentLanguage = "ko";

// Gift Package Selection Function
function selectGiftPackage(packageName, amount) {
    selectedPackageName = packageName;

    const amountInput = document.getElementById('amountInput');
    if (amountInput) {
        amountInput.value = amount.toLocaleString();
        amountInput.readOnly = true;
        amountInput.style.backgroundColor = '#f8f9fa';
    }

    const donationAmountSelect = document.getElementById('donationAmount');
    if (donationAmountSelect) {
        donationAmountSelect.value = '';
    }

    const onetimeBtn = document.getElementById('onetimeBtn');
    const regularBtn = document.getElementById('regularBtn');
    if (onetimeBtn && regularBtn) {
        onetimeBtn.classList.add('active');
        regularBtn.classList.remove('active');
    }

    alert(packageName + ' 패키지를 선택하셨습니다. 후원자 정보를 입력해주세요.');

    const donationContainer = document.getElementById('donation-container');
    if (donationContainer) {
        donationContainer.classList.add('view-step2');

        document.querySelectorAll('.step-number, .step-text').forEach(element => {
            element.classList.remove('active');
        });

        ['step2Number', 'step2Number2', 'step2Number3'].forEach(id => {
            const el = document.getElementById(id);
            if (el) el.classList.add('active');
        });
        ['step2Text', 'step2Text2', 'step2Text3'].forEach(id => {
            const el = document.getElementById(id);
            if (el) el.classList.add('active');
        });
    }

    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// Step indicator update function
function updateStepIndicator(currentStep) {
    document.querySelectorAll('.step-number, .step-text').forEach(element => {
        element.classList.remove('active');
    });

    const step1Numbers = ['step1Number', 'step1Number2', 'step1Number3'];
    const step1Texts = ['step1Text', 'step1Text2', 'step1Text3'];
    const step2Numbers = ['step2Number', 'step2Number2', 'step2Number3'];
    const step2Texts = ['step2Text', 'step2Text2', 'step2Text3'];
    const step3Numbers = ['step3Number', 'step3Number2', 'step3Number3'];
    const step3Texts = ['step3Text', 'step3Text2', 'step3Text3'];

    if (currentStep === 1) {
        step1Numbers.forEach(id => {
            const element = document.getElementById(id);
            if (element) element.classList.add('active');
        });
        step1Texts.forEach(id => {
            const element = document.getElementById(id);
            if (element) element.classList.add('active');
        });
    }

    if (currentStep === 2) {
        step2Numbers.forEach(id => {
            const element = document.getElementById(id);
            if (element) element.classList.add('active');
        });
        step2Texts.forEach(id => {
            const element = document.getElementById(id);
            if (element) element.classList.add('active');
        });
    }

    if (currentStep === 3) {
        step3Numbers.forEach(id => {
            const element = document.getElementById(id);
            if (element) element.classList.add('active');
        });
        step3Texts.forEach(id => {
            const element = document.getElementById(id);
            if (element) element.classList.add('active');
        });
    }
}

// 숫자만 입력 가능하도록 설정
function numbersOnly(input) {
    input.value = input.value.replace(/[^0-9]/g, '');
}

// 문자만 입력 가능하도록 설정 (이름 필드용)
function lettersOnly(input) {
    input.value = input.value.replace(/[^가-힣a-zA-Z\s]/g, '');
}

// 언어 업데이트
function updateLanguage() {
    const globeIcon = document.querySelector(".navbar-icon:first-child");
    if (globeIcon) {
        globeIcon.title = currentLanguage === "ko" ? "Switch to English" : "한국어로 전환";
    }
}

// Signature pad functionality
function initSignaturePad(canvasId) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) return;
    const ctx = canvas.getContext("2d");
    let drawing = false;

    const startDrawing = (e) => {
        drawing = true;
        draw(e);
    };

    const stopDrawing = () => {
        drawing = false;
        ctx.beginPath();
    };

    const getPos = (e) => {
        const rect = canvas.getBoundingClientRect();
        const clientX = e.clientX || e.touches[0].clientX;
        const clientY = e.clientY || e.touches[0].clientY;
        return { x: clientX - rect.left, y: clientY - rect.top };
    };

    const draw = (e) => {
        if (!drawing) return;
        const pos = getPos(e);
        ctx.lineWidth = 2;
        ctx.lineCap = "round";
        ctx.strokeStyle = "#000";
        ctx.lineTo(pos.x, pos.y);
        ctx.stroke();
        ctx.beginPath();
        ctx.moveTo(pos.x, pos.y);
    };

    canvas.addEventListener("mousedown", startDrawing);
    canvas.addEventListener("mouseup", stopDrawing);
    canvas.addEventListener("mousemove", draw);
    canvas.addEventListener("mouseleave", stopDrawing);
    canvas.addEventListener("touchstart", startDrawing);
    canvas.addEventListener("touchend", stopDrawing);
    canvas.addEventListener("touchmove", draw);
}

// 폼 필드에 회원 정보 채우기
function fillMemberFormFields(memberData) {
    const nameInput = document.getElementById('sponsorName');
    if (nameInput && memberData.name) {
        nameInput.value = memberData.name;
    }
    const phoneInput = document.getElementById('sponsorPhone');
    if (phoneInput && memberData.phone) {
        phoneInput.value = memberData.phone;
    }
    const dobInput = document.getElementById('sponsorDob');
    if (dobInput && memberData.birth) {
        const birthDate = memberData.birth.replace(/-/g, '');
        dobInput.value = birthDate;
    }
    if (memberData.email) {
        const emailParts = memberData.email.split('@');
        if (emailParts.length === 2) {
            const emailUserInput = document.getElementById('emailUser');
            const emailDomainInput = document.getElementById('emailDomain');
            if (emailUserInput) emailUserInput.value = emailParts[0];
            if (emailDomainInput) emailDomainInput.value = emailParts[1];
        }
    }
    const postcodeInput = document.getElementById('postcode');
    if (postcodeInput && memberData.postcode) {
        postcodeInput.value = memberData.postcode;
    }
    const addressInput = document.getElementById('address');
    if (addressInput && memberData.address) {
        addressInput.value = memberData.address;
    }
    const detailAddressInput = document.getElementById('detailAddress');
    if (detailAddressInput && memberData.detailAddress) {
        detailAddressInput.value = memberData.detailAddress;
    }
}

// 회원 정보 로드
function loadMemberInfoForDonation() {
    const cachedInfo = sessionStorage.getItem('memberInfo');

    if (cachedInfo) {
        try {
            const memberData = JSON.parse(cachedInfo);
            console.log('기부 페이지 - sessionStorage에서 회원 정보 로드:', memberData);
            fillMemberFormFields(memberData);
            return;
        } catch (e) {
            console.error('캐시된 회원 정보 파싱 실패:', e);
            sessionStorage.removeItem('memberInfo');
        }
    }

    fetch('/bdproject/api/auth/check')
        .then(response => response.json())
        .then(data => {
            if (data.loggedIn) {
                fetch('/bdproject/api/member/info')
                    .then(response => response.json())
                    .then(result => {
                        if (result.success && result.data) {
                            const memberData = result.data;
                            console.log('기부 페이지 - API에서 회원 정보 로드:', memberData);
                            sessionStorage.setItem('memberInfo', JSON.stringify(memberData));
                            fillMemberFormFields(memberData);
                        }
                    })
                    .catch(error => {
                        console.error('회원 정보 로드 실패:', error);
                    });
            }
        })
        .catch(error => {
            console.error('로그인 상태 확인 실패:', error);
        });
}

// 기부 처리 완료 함수
function processDonation(userId, selectedPackageName) {
    const finalSubmitBtn = document.getElementById("finalSubmitBtn");
    if (!finalSubmitBtn) return;

    finalSubmitBtn.addEventListener("click", function() {
        const activeForm = document.querySelector(".payment-details-form:not(.hidden)");
        const activeAgreement = activeForm.querySelector(".agreement-section .agreeAll");

        if (!activeAgreement || !activeAgreement.checked) {
            alert("개인정보 수집 및 이용에 모두 동의해야 기부가 가능합니다.");
            return;
        }

        const activePaymentMethod = document.querySelector('.payment-method-btn.active');
        const paymentType = activePaymentMethod ? activePaymentMethod.dataset.target : '';

        // 신용카드 결제 검증
        if (paymentType === 'creditCardForm') {
            const cardInputs = document.querySelectorAll('#creditCardForm .input-group input[maxlength="4"]');
            let cardNumber = '';
            let isCardValid = true;
            cardInputs.forEach(function(input) {
                if (!input.value || input.value.length !== 4 || !/^[0-9]{4}$/.test(input.value)) {
                    isCardValid = false;
                }
                cardNumber += input.value;
            });
            if (!isCardValid || cardNumber.length !== 16) {
                alert('카드번호 16자리를 정확히 입력해주세요.');
                return;
            }

            const expMonthInput = document.querySelector('#creditCardForm input[maxlength="2"][placeholder="MM"]');
            const expYearInput = document.querySelector('#creditCardForm input[maxlength="2"][placeholder="YY"]');
            if (!expMonthInput || !expMonthInput.value || !/^(0[1-9]|1[0-2])$/.test(expMonthInput.value)) {
                alert('유효기간(월)을 정확히 입력해주세요. (01~12)');
                if (expMonthInput) expMonthInput.focus();
                return;
            }
            if (!expYearInput || !expYearInput.value || !/^[0-9]{2}$/.test(expYearInput.value)) {
                alert('유효기간(년)을 정확히 입력해주세요. (YY)');
                if (expYearInput) expYearInput.focus();
                return;
            }

            const cvcInput = document.querySelector('#creditCardForm input[maxlength="3"]');
            if (!cvcInput || !cvcInput.value || !/^[0-9]{3}$/.test(cvcInput.value)) {
                alert('CVC 3자리를 정확히 입력해주세요.');
                if (cvcInput) cvcInput.focus();
                return;
            }
        }

        // 계좌이체 검증
        if (paymentType === 'bankTransferForm') {
            const bankSelect = document.querySelector('#bankTransferForm select');
            if (!bankSelect || !bankSelect.value) {
                alert('은행을 선택해주세요.');
                return;
            }
            const accountInput = document.querySelector('#bankTransferForm input[placeholder="계좌번호를 입력하세요"]');
            if (!accountInput || !accountInput.value || !/^[0-9]{10,16}$/.test(accountInput.value)) {
                alert('계좌번호를 정확히 입력해주세요. (10~16자리 숫자)');
                if (accountInput) accountInput.focus();
                return;
            }
        }

        // 기부 정보 수집
        const sponsorName = document.getElementById("sponsorName").value.trim();
        const sponsorPhone = document.getElementById("sponsorPhone").value.replace(/-/g, '');
        const amountInput = document.getElementById("amountInput").value;
        const amount = parseFloat(amountInput.replace(/,/g, ''));

        const emailUser = document.getElementById("emailUser");
        const emailDomain = document.getElementById("emailDomain");
        let sponsorEmail = '';
        if (emailUser && emailDomain) {
            sponsorEmail = emailUser.value + '@' + emailDomain.value;
        }

        const selectedCategory = document.querySelector('.donation-category.active');
        const category = selectedCategory ? selectedCategory.dataset.category : '일반기부';

        let donationType = 'ONETIME';
        const regularBtn = document.getElementById('regularBtn');
        const onetimeBtn = document.getElementById('onetimeBtn');

        if (regularBtn && regularBtn.classList.contains('active')) {
            donationType = 'REGULAR';
        } else if (onetimeBtn && onetimeBtn.classList.contains('active')) {
            donationType = 'ONETIME';
        }

        if (!sponsorName) {
            alert('후원자명을 입력해주세요.');
            return;
        }
        if (!sponsorPhone) {
            alert('전화번호를 입력해주세요.');
            return;
        }
        if (!amount || isNaN(amount) || amount <= 0) {
            alert('올바른 기부 금액을 입력해주세요.');
            return;
        }

        if (donationType === 'REGULAR') {
            const regularStartDateInput = document.getElementById('regularStartDateInput');
            if (!regularStartDateInput || !regularStartDateInput.value) {
                alert('정기 기부 시작일을 선택해주세요.');
                return;
            }

            const today = new Date();
            today.setHours(0, 0, 0, 0);
            const startDateObj = new Date(regularStartDateInput.value + 'T00:00:00');

            if (startDateObj < today) {
                alert('정기 기부 시작일은 오늘 또는 이후 날짜여야 합니다.');
                return;
            }
        }

        finalSubmitBtn.disabled = true;
        finalSubmitBtn.textContent = '처리 중...';

        const signatureCanvas = document.getElementById('signatureCanvas');
        const signatureImage = signatureCanvas ? signatureCanvas.toDataURL('image/png') : '';

        const selectedPaymentBtn = document.querySelector('.payment-method-btn.active');
        const paymentMethod = selectedPaymentBtn ? selectedPaymentBtn.dataset.method || 'CREDIT_CARD' : 'CREDIT_CARD';

        const regularStartDateInput = document.getElementById('regularStartDateInput');
        const regularStartDate = (donationType === 'REGULAR' || donationType === 'regular') && regularStartDateInput ? regularStartDateInput.value : '';

        console.log('=== 기부 요청 데이터 ===');
        console.log('후원자명:', sponsorName);
        console.log('이메일:', sponsorEmail);
        console.log('전화번호:', sponsorPhone);
        console.log('금액:', amount);
        console.log('기부 유형:', donationType);
        console.log('카테고리:', category);
        console.log('결제 방법:', paymentMethod);
        console.log('정기 기부 시작일:', regularStartDate);
        console.log('서명 이미지 길이:', signatureImage.length);

        const formData = new URLSearchParams();
        formData.append('amount', amount);
        formData.append('donationType', donationType);
        formData.append('category', category);
        formData.append('packageName', selectedPackageName || '');
        formData.append('donorName', sponsorName);
        formData.append('donorEmail', sponsorEmail);
        formData.append('donorPhone', sponsorPhone);
        formData.append('message', '');
        formData.append('signatureImage', signatureImage);
        formData.append('paymentMethod', paymentMethod);
        if (regularStartDate) {
            formData.append('regularStartDate', regularStartDate);
        }

        fetch('/bdproject/api/donation/create', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
        })
        .then(response => {
            console.log('=== API 응답 상태 ===');
            console.log('Status:', response.status);
            console.log('StatusText:', response.statusText);
            return response.json();
        })
        .then(data => {
            console.log('=== API 응답 데이터 ===');
            console.log(data);

            if (data.success) {
                const donationTypeText = donationType === 'REGULAR' || donationType === 'regular' ? '정기 기부' : '일시 기부';
                const today = new Date();
                const dateStr = today.getFullYear() + '년 ' + (today.getMonth() + 1) + '월 ' + today.getDate() + '일';

                logUserActivity(userId, {
                    type: donationType === 'REGULAR' || donationType === 'regular' ? 'donation_regular' : 'donation_onetime',
                    icon: 'fas fa-hand-holding-heart',
                    iconColor: '#e74c3c',
                    title: donationTypeText,
                    description: dateStr + '에 ' + Number(amount).toLocaleString() + '원 ' + donationTypeText + '를 신청했습니다.',
                    timestamp: new Date().toISOString()
                });

                alert('기부가 완료되었습니다. 감사합니다!');
                setTimeout(() => {
                    window.location.href = '/bdproject/project_mypage.jsp';
                }, 1500);
            } else {
                console.error('기부 실패:', data.message);
                alert('기부 처리 중 오류가 발생했습니다.\n' + (data.message || '다시 시도해주세요.'));
                finalSubmitBtn.disabled = false;
                finalSubmitBtn.textContent = '기부완료';
            }
        })
        .catch(error => {
            console.error('=== 기부 요청 오류 ===');
            console.error(error);
            alert('기부 처리 중 오류가 발생했습니다.\n다시 시도해주세요.');
            finalSubmitBtn.disabled = false;
            finalSubmitBtn.textContent = '기부완료';
        });
    });
}

// 사용자 활동 로그 저장 함수
function logUserActivity(userId, activity) {
    try {
        const activityLog = JSON.parse(localStorage.getItem('userActivityLog_' + userId) || '[]');
        activityLog.unshift(activity);
        if (activityLog.length > 100) {
            activityLog.splice(100);
        }
        localStorage.setItem('userActivityLog_' + userId, JSON.stringify(activityLog));
    } catch (error) {
        console.error('활동 로그 저장 오류:', error);
    }
}

// 페이지 초기화
function initDonationPage(donationParams, userId) {
    // 파라미터가 있으면 강제로 단계 2를 활성화
    if (donationParams && donationParams.skipFirstStep) {
        console.log('Forcing step 2 activation');
        setTimeout(() => {
            const step1Number = document.getElementById('step1Number');
            const step1Text = document.getElementById('step1Text');
            const step2Number = document.getElementById('step2Number');
            const step2Text = document.getElementById('step2Text');

            if (step1Number) step1Number.classList.remove('active');
            if (step1Text) step1Text.classList.remove('active');
            if (step2Number) step2Number.classList.add('active');
            if (step2Text) step2Text.classList.add('active');
        }, 100);
    }

    // 회원 정보 로드
    loadMemberInfoForDonation();

    // 정기기부/일시기부 버튼 기능
    const regularBtn = document.getElementById('regularBtn');
    const onetimeBtn = document.getElementById('onetimeBtn');
    const regularStartDateContainer = document.getElementById('regularStartDateContainer');

    if (regularBtn) {
        regularBtn.addEventListener('click', function() {
            regularBtn.classList.add('active');
            onetimeBtn.classList.remove('active');
            if (regularStartDateContainer) {
                regularStartDateContainer.style.display = 'block';
                const regularStartDateInput = document.getElementById('regularStartDateInput');
                if (regularStartDateInput) {
                    const today = new Date();
                    const year = today.getFullYear();
                    const month = String(today.getMonth() + 1).padStart(2, '0');
                    const day = String(today.getDate()).padStart(2, '0');
                    const todayStr = year + '-' + month + '-' + day;
                    regularStartDateInput.setAttribute('min', todayStr);
                }
            }
        });
    }

    if (onetimeBtn) {
        onetimeBtn.addEventListener('click', function() {
            onetimeBtn.classList.add('active');
            regularBtn.classList.remove('active');
            if (regularStartDateContainer) {
                regularStartDateContainer.style.display = 'none';
            }
        });
    }

    // 기부금액 드롭다운 선택 이벤트
    const donationAmountSelect = document.getElementById('donationAmount');
    const amountInput = document.getElementById('amountInput');

    if (donationAmountSelect && amountInput) {
        donationAmountSelect.addEventListener('change', function() {
            const selectedValue = this.value;
            if (selectedValue) {
                amountInput.value = Number(selectedValue).toLocaleString();
                amountInput.readOnly = true;
                amountInput.style.backgroundColor = '#f8f9fa';
            } else {
                amountInput.value = '';
                amountInput.readOnly = false;
                amountInput.style.backgroundColor = '';
                amountInput.focus();
            }
        });
    }

    // 기부 참여 분야 클릭 이벤트
    const donationCategories = document.querySelectorAll('.donation-category');
    donationCategories.forEach(category => {
        category.addEventListener('click', function() {
            donationCategories.forEach(cat => cat.classList.remove('active'));
            this.classList.add('active');
        });
    });

    // 단계 전환 기능
    const nextBtn = document.getElementById('nextBtn');
    const donationContainer = document.getElementById('donation-container');

    if (nextBtn && donationContainer) {
        nextBtn.addEventListener('click', function() {
            donationContainer.classList.add('view-step2');
            updateStepIndicator(2);
        });
    }

    // 이름 필드 - 문자만 입력
    const sponsorNameInput = document.getElementById('sponsorName');
    if (sponsorNameInput) {
        let isComposing = false;

        sponsorNameInput.addEventListener('compositionstart', function() {
            isComposing = true;
        });

        sponsorNameInput.addEventListener('compositionend', function() {
            isComposing = false;
            lettersOnly(this);
        });

        sponsorNameInput.addEventListener('input', function() {
            if (!isComposing) {
                lettersOnly(this);
            }
        });
    }

    // 전화번호 필드 - 숫자만 입력
    const sponsorPhoneInput = document.getElementById('sponsorPhone');
    if (sponsorPhoneInput) {
        sponsorPhoneInput.addEventListener('input', function() {
            numbersOnly(this);
        });
    }

    // 생년월일 필드 - 숫자만 입력
    const sponsorDobInput = document.getElementById('sponsorDob');
    if (sponsorDobInput) {
        sponsorDobInput.addEventListener('input', function() {
            numbersOnly(this);
        });
    }

    // 신용카드 번호 필드들 - 숫자만 입력
    document.querySelectorAll('#creditCardForm .input-group input[type="text"]').forEach(function(input) {
        input.addEventListener('input', function() {
            numbersOnly(this);
        });
    });

    // CVC 필드 - 숫자만 입력
    const cvcInput = document.querySelector('#creditCardForm input[maxlength="3"]');
    if (cvcInput) {
        cvcInput.addEventListener('input', function() {
            numbersOnly(this);
        });
    }

    // 계좌번호 필드 - 숫자만 입력
    const accountInput = document.querySelector('#bankTransferForm input[placeholder="계좌번호를 입력하세요"]');
    if (accountInput) {
        accountInput.addEventListener('input', function() {
            numbersOnly(this);
        });
    }

    // 후원자 정보 -> 결제 수단
    const goToStep3Btn = document.getElementById('goToStep3Btn');
    if (goToStep3Btn && donationContainer) {
        goToStep3Btn.addEventListener('click', function() {
            const sponsorName = document.getElementById('sponsorName').value.trim();
            const sponsorPhone = document.getElementById('sponsorPhone').value.trim();
            const sponsorDob = document.getElementById('sponsorDob').value.trim();
            const emailUser = document.getElementById('emailUser').value.trim();
            const emailDomain = document.getElementById('emailDomain').value.trim();
            const address = document.getElementById('address').value.trim();

            if (!sponsorName) {
                alert('이름을 입력해주세요.');
                document.getElementById('sponsorName').focus();
                return;
            }

            if (!sponsorPhone) {
                alert('전화번호를 입력해주세요.');
                document.getElementById('sponsorPhone').focus();
                return;
            }
            if (!/^[0-9]{10,11}$/.test(sponsorPhone)) {
                alert('전화번호는 10~11자리 숫자만 입력해주세요.');
                document.getElementById('sponsorPhone').focus();
                return;
            }

            if (!sponsorDob) {
                alert('생년월일을 입력해주세요.');
                document.getElementById('sponsorDob').focus();
                return;
            }
            if (!/^[0-9]{8}$/.test(sponsorDob)) {
                alert('생년월일은 8자리 숫자로 입력해주세요. (예: 19900101)');
                document.getElementById('sponsorDob').focus();
                return;
            }
            const year = parseInt(sponsorDob.substring(0, 4));
            const month = parseInt(sponsorDob.substring(4, 6));
            const day = parseInt(sponsorDob.substring(6, 8));
            if (year < 1900 || year > new Date().getFullYear() || month < 1 || month > 12 || day < 1 || day > 31) {
                alert('올바른 생년월일을 입력해주세요.');
                document.getElementById('sponsorDob').focus();
                return;
            }

            if (!emailUser) {
                alert('이메일 아이디를 입력해주세요.');
                document.getElementById('emailUser').focus();
                return;
            }
            if (!emailDomain) {
                alert('이메일 도메인을 입력해주세요.');
                document.getElementById('emailDomain').focus();
                return;
            }
            const fullEmail = emailUser + '@' + emailDomain;
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(fullEmail)) {
                alert('올바른 이메일 형식을 입력해주세요.');
                document.getElementById('emailUser').focus();
                return;
            }

            if (!address) {
                alert('주소를 입력해주세요.');
                document.getElementById('searchAddressBtn').click();
                return;
            }

            console.log('Moving to step 3');
            donationContainer.classList.add('view-step3');
            updateStepIndicator(3);
            console.log('Step 3 classes:', donationContainer.className);
        });
    }

    // 뒤로 가기 버튼 (후원자 정보 -> 기부하기)
    const backBtn = document.getElementById('backBtn');
    if (backBtn && donationContainer) {
        backBtn.addEventListener('click', function() {
            donationContainer.classList.remove('view-step2');
            updateStepIndicator(1);
        });
    }

    // 뒤로 가기 버튼 (결제 수단 -> 후원자 정보)
    const backToStep2Btn = document.getElementById('backToStep2Btn');
    if (backToStep2Btn && donationContainer) {
        backToStep2Btn.addEventListener('click', function() {
            donationContainer.classList.remove('view-step3');
            updateStepIndicator(2);
        });
    }

    // 이메일 도메인 선택
    const emailDomainSelect = document.getElementById("emailDomainSelect");
    if (emailDomainSelect) {
        emailDomainSelect.addEventListener("change", (e) => {
            const selectedValue = e.target.value;
            const emailDomain = document.getElementById("emailDomain");
            emailDomain.value = selectedValue ? selectedValue : "";
            emailDomain.readOnly = !!selectedValue;
            emailDomain.classList.toggle("disabled", !!selectedValue);
            if (!selectedValue) emailDomain.focus();
        });
    }

    // 주소 검색
    const searchAddressBtn = document.getElementById("searchAddressBtn");
    if (searchAddressBtn) {
        searchAddressBtn.addEventListener("click", () => {
            new daum.Postcode({
                oncomplete: function (data) {
                    document.getElementById("postcode").value = data.zonecode;
                    document.getElementById("address").value = data.address;
                    document.getElementById("detailAddress").focus();
                },
            }).open();
        });
    }

    // 결제 방법 선택
    const paymentMethodBtns = document.querySelectorAll(".payment-method-btn");
    paymentMethodBtns.forEach((btn) => {
        btn.addEventListener("click", () => {
            paymentMethodBtns.forEach((b) => b.classList.remove("active"));
            btn.classList.add("active");
            document.querySelectorAll(".payment-details-form").forEach((form) => form.classList.add("hidden"));
            document.getElementById(btn.dataset.target).classList.remove("hidden");
        });
    });

    // 동의 체크박스 기능
    document.querySelectorAll(".agreement-section").forEach((section) => {
        const agreeAll = section.querySelector(".agreeAll");
        const agreeItems = section.querySelectorAll(".agree-item");
        if (!agreeAll) return;

        agreeAll.addEventListener("change", (e) => {
            agreeItems.forEach((checkbox) => (checkbox.checked = e.target.checked));
        });

        agreeItems.forEach((checkbox) => {
            checkbox.addEventListener("change", () => {
                agreeAll.checked = [...agreeItems].every((item) => item.checked);
            });
        });
    });

    // 기부 처리 완료 이벤트 등록
    processDonation(userId, selectedPackageName);

    // Signature pad 초기화
    initSignaturePad("cardCanvas");
    initSignaturePad("bankCanvas");

    document.querySelectorAll(".clear-signature-btn").forEach((button) => {
        button.addEventListener("click", () => {
            const canvas = document.getElementById(button.dataset.target);
            const ctx = canvas.getContext("2d");
            ctx.clearRect(0, 0, canvas.width, canvas.height);
        });
    });

    // Modal functionality
    const detailButtons = document.querySelectorAll(".view-details-btn");
    const modals = document.querySelectorAll(".modal-overlay");
    const closeButtons = document.querySelectorAll(".modal-close-btn");

    detailButtons.forEach((button) =>
        button.addEventListener("click", (e) => {
            e.preventDefault();
            document.getElementById(button.dataset.modal).classList.add("active");
        })
    );

    const closeModal = () =>
        modals.forEach((modal) => modal.classList.remove("active"));

    closeButtons.forEach((button) =>
        button.addEventListener("click", closeModal)
    );

    modals.forEach((modal) =>
        modal.addEventListener("click", (e) => {
            if (e.target === modal) closeModal();
        })
    );

    // User icon navigation
    const userIcon = document.getElementById("userIcon");
    if (userIcon) {
        userIcon.addEventListener("click", function() {
            window.location.href = '/bdproject/projectLogin.jsp';
        });
    }

    // 언어 드롭다운 관련 JavaScript
    const languageToggle = document.getElementById("languageToggle");
    const languageDropdown = document.getElementById("languageDropdown");

    if (languageToggle && languageDropdown) {
        languageToggle.addEventListener("click", function(e) {
            e.preventDefault();
            languageDropdown.classList.toggle("active");
        });

        document.querySelectorAll(".language-option").forEach(option => {
            option.addEventListener("click", function(e) {
                e.preventDefault();
                document.querySelectorAll(".language-option").forEach(opt => {
                    opt.classList.remove("active");
                });
                this.classList.add("active");
                currentLanguage = this.getAttribute("data-lang");
                languageDropdown.classList.remove("active");
                updateLanguage();
            });
        });

        document.addEventListener("click", function(e) {
            if (!languageToggle.contains(e.target) && !languageDropdown.contains(e.target)) {
                languageDropdown.classList.remove("active");
            }
        });
    }

    // 네비바 드롭다운 메뉴
    const header = document.getElementById("main-header");
    const navLinks = document.querySelectorAll(".nav-link[data-menu]");
    const megaMenuWrapper = document.getElementById("mega-menu-wrapper");
    const menuColumns = document.querySelectorAll(".menu-column");
    let menuTimeout;

    const showMenu = (targetMenu) => {
        clearTimeout(menuTimeout);
        megaMenuWrapper.classList.add("active");

        menuColumns.forEach((col) => {
            if (col.dataset.menuContent === targetMenu) {
                col.style.display = "flex";
            } else {
                col.style.display = "none";
            }
        });

        navLinks.forEach((link) => {
            if (link.dataset.menu === targetMenu) {
                link.classList.add("active");
            } else {
                link.classList.remove("active");
            }
        });
    };

    const hideMenu = () => {
        menuTimeout = setTimeout(() => {
            megaMenuWrapper.classList.remove("active");
            navLinks.forEach((link) => link.classList.remove("active"));
        }, 200);
    };

    navLinks.forEach((link) => {
        link.addEventListener("mouseenter", () => {
            showMenu(link.dataset.menu);
        });
    });

    if (header) {
        header.addEventListener("mouseleave", () => {
            hideMenu();
        });
    }

    document.querySelectorAll('.dropdown-link').forEach(link => {
        link.addEventListener('click', function(e) {
            if (this.href && this.href !== '#') {
                window.location.href = this.href;
            }
        });
    });

    // 초기 설정
    updateStepIndicator(1);
}
