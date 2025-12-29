// 숫자만 입력 허용 함수
function numbersOnly(input) {
    input.value = input.value.replace(/[^0-9]/g, '');
}

// 문자만 입력 허용 함수 (한글, 영문, 공백만)
function lettersOnly(input) {
    input.value = input.value.replace(/[^가-힣a-zA-Z\s]/g, '');
}

// 사용자 활동 로그 저장 함수
function logUserActivity(activity) {
    try {
        const userId = window.currentUserId || 'guest';
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

// 날짜 선택 제한 설정 함수
function setDateRestrictions() {
    // 사용자의 로컬 시간대 기준으로 오늘 날짜 계산
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    const todayStr = year + '-' + month + '-' + day;

    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');

    // 시작일과 종료일 모두 오늘 이후만 선택 가능
    if (startDateInput) {
        startDateInput.setAttribute('min', todayStr);

        // 시작일 변경 시 종료일의 최소값도 업데이트
        startDateInput.addEventListener('change', function() {
            const selectedStartDate = this.value;
            if (endDateInput) {
                endDateInput.setAttribute('min', selectedStartDate);

                // 이미 선택된 종료일이 시작일보다 이전이면 초기화
                if (endDateInput.value && endDateInput.value < selectedStartDate) {
                    endDateInput.value = '';
                    alert('종료일은 시작일 이후여야 합니다.');
                }
            }
        });
    }

    if (endDateInput) {
        endDateInput.setAttribute('min', todayStr);

        // 종료일 변경 시 시작일보다 이전인지 검증
        endDateInput.addEventListener('change', function() {
            const selectedEndDate = this.value;
            const selectedStartDate = startDateInput ? startDateInput.value : '';

            if (selectedStartDate && selectedEndDate < selectedStartDate) {
                this.value = '';
                alert('종료일은 시작일 이후여야 합니다.');
            }
        });
    }
}

// 봉사 신청 데이터 저장 객체
let volunteerData = {
    category: '',
    region: '',
    startDate: '',
    endDate: '',
    availableTime: '',
    name: '',
    phone: '',
    email: '',
    birth: '',
    postcode: '',
    address: '',
    detailAddress: '',
    experience: '',
    motivation: ''
};

document.addEventListener('DOMContentLoaded', function() {
    // 날짜 입력 필드에 오늘 이후 날짜만 선택 가능하도록 설정
    setDateRestrictions();

    // 로그인 상태 확인 및 회원 정보 로드
    checkLoginStatusAndLoadInfo();

    function checkLoginStatusAndLoadInfo() {
        fetch('/bdproject/api/auth/check')
            .then(response => response.json())
            .then(data => {
                if (!data.loggedIn) {
                    alert('봉사 신청은 로그인이 필요합니다.\n로그인 페이지로 이동합니다.');
                    window.location.href = '/bdproject/projectLogin.jsp';
                } else {
                    // 로그인 상태라면 회원 정보 로드
                    loadMemberInfo();
                }
            })
            .catch(error => {
                console.error('로그인 상태 확인 실패:', error);
                alert('로그인 상태를 확인할 수 없습니다.\n로그인 페이지로 이동합니다.');
                window.location.href = '/bdproject/projectLogin.jsp';
            });
    }

    // 마이페이지에서 회원 정보 불러오기
    function loadMemberInfo() {
        fetch('/bdproject/api/member/info')
            .then(response => response.json())
            .then(result => {
                if (result.success && result.data) {
                    const data = result.data;
                    console.log('회원 정보 로드:', data);

                    // 이름
                    if (data.name) {
                        document.getElementById('volunteerName').value = data.name;
                    }
                    // 전화번호
                    if (data.phone) {
                        document.getElementById('volunteerPhone').value = data.phone;
                    }
                    // 이메일 분리하여 입력
                    if (data.email) {
                        const emailParts = data.email.split('@');
                        if (emailParts.length === 2) {
                            document.getElementById('emailUser').value = emailParts[0];
                            document.getElementById('emailDomain').value = emailParts[1];
                        }
                    }
                    // 생년월일 (YYYY-MM-DD 형식을 YYYYMMDD로 변환)
                    if (data.birth) {
                        const birthDate = data.birth.replace(/-/g, '');
                        document.getElementById('volunteerBirth').value = birthDate;
                    }
                    // 주소 정보가 있으면 로드
                    if (data.postcode) {
                        document.getElementById('postcode').value = data.postcode;
                    }
                    if (data.address) {
                        document.getElementById('address').value = data.address;
                    }
                    if (data.detailAddress) {
                        document.getElementById('detailAddress').value = data.detailAddress;
                    }
                }
            })
            .catch(error => {
                console.error('회원 정보 로드 실패:', error);
            });
    }

    // 이메일 도메인 선택 이벤트
    const emailDomainSelect = document.getElementById('emailDomainSelect');
    if (emailDomainSelect) {
        emailDomainSelect.addEventListener('change', function() {
            const emailDomainInput = document.getElementById('emailDomain');
            if (this.value) {
                emailDomainInput.value = this.value;
                emailDomainInput.readOnly = true;
            } else {
                emailDomainInput.value = '';
                emailDomainInput.readOnly = false;
                emailDomainInput.focus();
            }
        });
    }

    // Step indicator update
    function updateStepIndicator(currentStep) {
        // 모든 step indicator에서 active 클래스 제거
        document.querySelectorAll('.step-number, .step-text').forEach(element => {
            element.classList.remove('active');
        });

        if (currentStep === 1) {
            // Step 1의 indicator 활성화
            document.getElementById('step1Number').classList.add('active');
            document.getElementById('step1Text').classList.add('active');
        } else if (currentStep === 2) {
            // Step 2의 모든 indicator 활성화
            ['step2Number-s2', 'step2Text-s2'].forEach(id => {
                const element = document.getElementById(id);
                if (element) element.classList.add('active');
            });
        } else if (currentStep === 3) {
            // Step 3의 모든 indicator 활성화
            ['step3Number-s3', 'step3Text-s3'].forEach(id => {
                const element = document.getElementById(id);
                if (element) element.classList.add('active');
            });
        }
    }

    // 네비바 메뉴
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

    header.addEventListener("mouseleave", () => {
        hideMenu();
    });

    // 봉사 카테고리 선택
    const volunteerCategories = document.querySelectorAll('.volunteer-category');
    volunteerCategories.forEach(category => {
        category.addEventListener('click', function() {
            volunteerCategories.forEach(cat => cat.classList.remove('selected'));
            this.classList.add('selected');
            volunteerData.category = this.dataset.category;
        });
    });

    // Step 1 -> Step 2
    const nextBtn = document.getElementById('nextBtn');
    const volunteerContainer = document.getElementById('volunteer-container');

    nextBtn.addEventListener('click', function() {
        // 검증
        if (!volunteerData.category) {
            alert('봉사 활동 분야를 선택해주세요.');
            return;
        }

        const region = document.getElementById('region').value;
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;
        const availableTime = document.querySelector('input[name="availableTime"]:checked');

        if (!region) {
            alert('지역을 선택해주세요.');
            return;
        }
        if (!startDate || !endDate) {
            alert('희망 봉사 기간을 선택해주세요.');
            return;
        }

        // 날짜 유효성 추가 검증 (오늘 이후 또는 당일 날짜인지 확인)
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        const startDateObj = new Date(startDate + 'T00:00:00');
        const endDateObj = new Date(endDate + 'T00:00:00');

        if (startDateObj < today) {
            alert('시작일은 오늘 또는 이후 날짜여야 합니다.');
            return;
        }

        if (endDateObj < startDateObj) {
            alert('종료일은 시작일 이후 날짜여야 합니다.');
            return;
        }

        if (!availableTime) {
            alert('참여 가능 시간대를 선택해주세요.');
            return;
        }

        // 데이터 저장
        volunteerData.region = region;
        volunteerData.startDate = startDate;
        volunteerData.endDate = endDate;
        volunteerData.availableTime = availableTime.value;

        // Step 2로 이동
        volunteerContainer.classList.add('view-step2');
        updateStepIndicator(2);
        window.scrollTo(0, 0);
    });

    // Step 2 -> Step 1 (뒤로가기)
    const backBtn = document.getElementById('backBtn');
    backBtn.addEventListener('click', function() {
        volunteerContainer.classList.remove('view-step2');
        updateStepIndicator(1);
        window.scrollTo(0, 0);
    });

    // Step 2 -> Step 3
    const goToStep3Btn = document.getElementById('goToStep3Btn');
    goToStep3Btn.addEventListener('click', function() {
        // 검증
        const name = document.getElementById('volunteerName').value;
        const phone = document.getElementById('volunteerPhone').value;
        const emailUser = document.getElementById('emailUser').value;
        const emailDomain = document.getElementById('emailDomain').value;
        const birth = document.getElementById('volunteerBirth').value;
        const address = document.getElementById('address').value;
        const experience = document.querySelector('input[name="experience"]:checked');

        if (!name) {
            alert('이름을 입력해주세요.');
            return;
        }
        if (!phone) {
            alert('전화번호를 입력해주세요.');
            return;
        }
        if (!emailUser || !emailDomain) {
            alert('이메일을 입력해주세요.');
            return;
        }
        // 이메일 조합
        const email = emailUser + '@' + emailDomain;
        if (!birth || birth.length !== 8) {
            alert('생년월일을 8자리로 입력해주세요.');
            return;
        }
        if (!address) {
            alert('주소를 입력해주세요.');
            return;
        }
        if (!experience) {
            alert('봉사 경험을 선택해주세요.');
            return;
        }

        // 데이터 저장
        volunteerData.name = name;
        volunteerData.phone = phone;
        volunteerData.email = email;
        volunteerData.birth = birth;
        volunteerData.postcode = document.getElementById('postcode').value;
        volunteerData.address = address;
        volunteerData.detailAddress = document.getElementById('detailAddress').value;
        volunteerData.experience = experience.value;
        volunteerData.motivation = document.getElementById('motivation').value;

        // 요약 정보 업데이트
        updateSummary();

        // Step 3으로 이동
        volunteerContainer.classList.add('view-step3');
        updateStepIndicator(3);
        window.scrollTo(0, 0);
    });

    // Step 3 -> Step 2 (뒤로가기)
    const backToStep2Btn = document.getElementById('backToStep2Btn');
    backToStep2Btn.addEventListener('click', function() {
        volunteerContainer.classList.remove('view-step3');
        updateStepIndicator(2);
        window.scrollTo(0, 0);
    });

    // 요약 정보 업데이트
    function updateSummary() {
        document.getElementById('summary-category').textContent = volunteerData.category;
        document.getElementById('summary-region').textContent = volunteerData.region;
        document.getElementById('summary-date').textContent = volunteerData.startDate + ' ~ ' + volunteerData.endDate;
        document.getElementById('summary-time').textContent = volunteerData.availableTime;
        document.getElementById('summary-name').textContent = volunteerData.name;
        document.getElementById('summary-phone').textContent = volunteerData.phone;
        document.getElementById('summary-email').textContent = volunteerData.email;

        let fullAddress = volunteerData.address;
        if (volunteerData.detailAddress) {
            fullAddress += ', ' + volunteerData.detailAddress;
        }
        document.getElementById('summary-address').textContent = fullAddress;
        document.getElementById('summary-experience').textContent = volunteerData.experience;
    }

    // 주소 검색
    const searchAddressBtn = document.getElementById('searchAddressBtn');
    searchAddressBtn.addEventListener('click', function() {
        new daum.Postcode({
            oncomplete: function(data) {
                document.getElementById('postcode').value = data.zonecode;
                document.getElementById('address').value = data.address;
                document.getElementById('detailAddress').focus();
            }
        }).open();
    });

    // 동의 체크박스
    const agreeAll = document.getElementById('agreeAll');
    const agreeItems = document.querySelectorAll('.agree-item');

    agreeAll.addEventListener('change', function() {
        agreeItems.forEach(item => {
            item.checked = this.checked;
        });
    });

    agreeItems.forEach(item => {
        item.addEventListener('change', function() {
            agreeAll.checked = Array.from(agreeItems).every(item => item.checked);
        });
    });

    // 최종 신청
    const finalSubmitBtn = document.getElementById('finalSubmitBtn');
    finalSubmitBtn.addEventListener('click', function() {
        // 필수 동의 확인
        const requiredAgree = agreeItems[0];
        if (!requiredAgree.checked) {
            alert('개인정보 수집 및 이용에 동의해주세요.');
            return;
        }

        // 버튼 비활성화 (중복 제출 방지)
        finalSubmitBtn.disabled = true;
        finalSubmitBtn.textContent = '신청 중...';

        // API로 데이터 전송
        const formData = new URLSearchParams();
        formData.append('applicantName', volunteerData.name);
        formData.append('applicantPhone', volunteerData.phone);
        formData.append('applicantEmail', volunteerData.email);

        // 주소 정보 조합
        let fullAddress = volunteerData.address || '';
        if (volunteerData.detailAddress) {
            fullAddress += ' ' + volunteerData.detailAddress;
        }
        formData.append('applicantAddress', fullAddress);

        formData.append('volunteerExperience', volunteerData.experience || '없음');
        formData.append('selectedCategory', volunteerData.category);
        formData.append('volunteerDate', volunteerData.startDate);
        formData.append('volunteerEndDate', volunteerData.endDate); // 종료일 추가
        formData.append('volunteerTime', volunteerData.availableTime || '오전');

        // 디버깅: 전송할 데이터 확인
        console.log('=== 봉사 신청 데이터 ===');
        console.log('applicantName:', volunteerData.name);
        console.log('applicantPhone:', volunteerData.phone);
        console.log('applicantEmail:', volunteerData.email);
        console.log('applicantAddress:', fullAddress);
        console.log('volunteerExperience:', volunteerData.experience);
        console.log('selectedCategory:', volunteerData.category);
        console.log('volunteerDate:', volunteerData.startDate);
        console.log('volunteerEndDate:', volunteerData.endDate); // 종료일 로그 추가
        console.log('volunteerTime:', volunteerData.availableTime);
        console.log('FormData:', formData.toString());

        fetch('/bdproject/api/volunteer/apply', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
        })
        .then(response => {
            console.log('응답 상태:', response.status);
            console.log('응답 헤더:', response.headers.get('content-type'));

            // HTML 에러 페이지가 왔는지 확인
            const contentType = response.headers.get('content-type');
            if (contentType && contentType.includes('text/html')) {
                return response.text().then(html => {
                    console.error('HTML 에러 응답 전체:', html);
                    // 에러 메시지 추출 시도
                    const messageMatch = html.match(/<b>메시지<\/b>\s*(.+?)<\/p>/);
                    const descMatch = html.match(/<b>설명<\/b>\s*(.+?)<\/p>/);
                    let errorDetail = '';
                    if (messageMatch) errorDetail += '메시지: ' + messageMatch[1].replace(/<[^>]*>/g, '') + '\n';
                    if (descMatch) errorDetail += '설명: ' + descMatch[1].replace(/<[^>]*>/g, '');
                    throw new Error('서버 에러 (500): ' + (errorDetail || '서버에서 HTML 에러 페이지를 반환했습니다.'));
                });
            }

            return response.json();
        })
        .then(data => {
            console.log('응답 데이터:', data);
            if (data.success) {
                // 활동 로그 저장
                const today = new Date();
                const dateStr = today.getFullYear() + '년 ' + (today.getMonth() + 1) + '월 ' + today.getDate() + '일';
                const volunteerDateStr = volunteerData.startDate;

                logUserActivity({
                    type: 'volunteer_apply',
                    icon: 'fas fa-hands-helping',
                    iconColor: '#27ae60',
                    title: '봉사 활동 신청',
                    description: dateStr + '에 ' + volunteerDateStr + ' 봉사 활동(' + (volunteerData.category || '일반') + ')을 신청했습니다.',
                    timestamp: new Date().toISOString()
                });

                alert(volunteerData.name + '님의 봉사 신청이 완료되었습니다.\n담당자가 확인 후 연락드리겠습니다.');
                setTimeout(() => {
                    window.location.href = '/bdproject/project.jsp';
                }, 1500);
            } else {
                alert('봉사 신청에 실패했습니다.\n' + (data.message || '다시 시도해주세요.'));
                finalSubmitBtn.disabled = false;
                finalSubmitBtn.textContent = '신청 완료';
            }
        })
        .catch(error => {
            console.error('봉사 신청 오류:', error);
            alert('봉사 신청 중 오류가 발생했습니다.\n다시 시도해주세요.\n\n콘솔창을 확인해주세요.');
            finalSubmitBtn.disabled = false;
            finalSubmitBtn.textContent = '신청 완료';
        });
    });

    // 초기화
    updateStepIndicator(1);
});
