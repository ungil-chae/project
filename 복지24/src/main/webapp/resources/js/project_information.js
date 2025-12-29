// 생년월일 조합
function combineDate() {
    const year = document.getElementById('year').value;
    const month = document.getElementById('month').value;
    const day = document.getElementById('day').value;

    if (!year || !month || !day) {
        return false;
    }

    document.getElementById('birthdate').value = year + '-' + month + '-' + day;
    return true;
}

// 소득 구간 변환 (상세 진단과 동일하게 맞춤)
function convertIncomeToRange() {
    const amount = parseInt(document.getElementById('income_amount').value) || 0;
    let incomeRange;

    if (amount === 0) incomeRange = 'none';
    else if (amount < 100) incomeRange = 'under_100';
    else if (amount < 200) incomeRange = '100_200';
    else if (amount < 300) incomeRange = '200_300';
    else if (amount < 400) incomeRange = '300_400';
    else if (amount < 500) incomeRange = '400_500';
    else if (amount < 600) incomeRange = '500_600';
    else incomeRange = 'over_600';

    document.getElementById('income').value = incomeRange;
    return true;
}

// 월 변경시 일자 옵션 조정
function initializeDaySelector() {
    document.getElementById('month').addEventListener('change', function() {
        const month = parseInt(this.value);
        const year = parseInt(document.getElementById('year').value) || 2025;
        const daySelect = document.getElementById('day');
        const currentDay = daySelect.value;

        let maxDays = 31;
        if ([4, 6, 9, 11].includes(month)) {
            maxDays = 30;
        } else if (month === 2) {
            maxDays = (year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0)) ? 29 : 28;
        }

        daySelect.innerHTML = '<option value="">일</option>';
        for (let d = 1; d <= maxDays; d++) {
            const option = document.createElement('option');
            option.value = String(d).padStart(2, '0');
            option.textContent = d + '일';
            daySelect.appendChild(option);
        }

        if (currentDay && parseInt(currentDay) <= maxDays) {
            daySelect.value = currentDay;
        }
    });
}

// 시도 변경시 시군구 옵션 업데이트
function initializeSigunguSelector() {
    document.getElementById('sido').addEventListener('change', function() {
        const sigunguSelect = document.getElementById('sigungu');
        const sido = this.value;

        sigunguSelect.innerHTML = '<option value="">시/군/구 선택</option>';

        const sigunguData = {
            '서울특별시': ['강남구', '강동구', '강북구', '강서구', '관악구', '광진구', '구로구', '금천구', '노원구', '도봉구', '동대문구', '동작구', '마포구', '서대문구', '서초구', '성동구', '성북구', '송파구', '양천구', '영등포구', '용산구', '은평구', '종로구', '중구', '중랑구'],
            '부산광역시': ['강서구', '금정구', '기장군', '남구', '동구', '동래구', '부산진구', '북구', '사상구', '사하구', '서구', '수영구', '연제구', '영도구', '중구', '해운대구'],
            '대구광역시': ['남구', '달서구', '달성군', '동구', '북구', '서구', '수성구', '중구'],
            '인천광역시': ['강화군', '계양구', '남동구', '동구', '미추홀구', '부평구', '서구', '연수구', '옹진군', '중구'],
            '광주광역시': ['광산구', '남구', '동구', '북구', '서구'],
            '대전광역시': ['대덕구', '동구', '서구', '유성구', '중구'],
            '울산광역시': ['남구', '동구', '북구', '울주군', '중구'],
            '세종특별자치시': ['세종시'],
            '경기도': ['고양시', '과천시', '광명시', '광주시', '구리시', '군포시', '김포시', '남양주시', '동두천시', '부천시', '성남시', '수원시', '시흥시', '안산시', '안성시', '안양시', '양주시', '양평군', '여주시', '연천군', '오산시', '용인시', '의왕시', '의정부시', '이천시', '파주시', '평택시', '포천시', '하남시', '화성시'],
            '강원특별자치도': ['강릉시', '고성군', '동해시', '삼척시', '속초시', '양구군', '양양군', '영월군', '원주시', '인제군', '정선군', '철원군', '춘천시', '태백시', '평창군', '홍천군', '화천군', '횡성군'],
            '충청북도': ['괴산군', '단양군', '보은군', '영동군', '옥천군', '음성군', '제천시', '증평군', '진천군', '청주시', '충주시'],
            '충청남도': ['계룡시', '공주시', '금산군', '논산시', '당진시', '보령시', '부여군', '서산시', '서천군', '아산시', '예산군', '천안시', '청양군', '태안군', '홍성군'],
            '전북특별자치도': ['고창군', '군산시', '김제시', '남원시', '무주군', '부안군', '순창군', '완주군', '익산시', '임실군', '장수군', '전주시', '정읍시', '진안군'],
            '전라남도': ['강진군', '고흥군', '곡성군', '광양시', '구례군', '나주시', '담양군', '목포시', '무안군', '보성군', '순천시', '신안군', '여수시', '영광군', '영암군', '완도군', '장성군', '장흥군', '진도군', '함평군', '해남군', '화순군'],
            '경상북도': ['경산시', '경주시', '고령군', '구미시', '군위군', '김천시', '문경시', '봉화군', '상주시', '성주군', '안동시', '영덕군', '영양군', '영주시', '영천시', '예천군', '울릉군', '울진군', '의성군', '청도군', '청송군', '칠곡군', '포항시'],
            '경상남도': ['거제시', '거창군', '고성군', '김해시', '남해군', '밀양시', '사천시', '산청군', '양산시', '의령군', '진주시', '창녕군', '창원시', '통영시', '하동군', '함안군', '함양군', '합천군'],
            '제주특별자치도': ['서귀포시', '제주시']
        };

        if (sigunguData[sido]) {
            sigunguData[sido].forEach(function(sigungu) {
                const option = document.createElement('option');
                option.value = sigungu;
                option.textContent = sigungu;
                sigunguSelect.appendChild(option);
            });
        }
    });
}

// 폼 제출 처리
function handleSubmit(event) {
    event.preventDefault();

    // 필수 필드 검증
    if (!combineDate()) {
        alert('생년월일을 모두 선택해주세요.');
        return false;
    }

    if (!convertIncomeToRange()) {
        return false;
    }

    // 폼 데이터를 JSON으로 변환
    const formData = new FormData(document.getElementById('basicDiagnosisForm'));
    const userData = {};

    for (let [key, value] of formData.entries()) {
        userData[key] = value;
    }

    // 기본값 설정 (상세 진단에서 요구하는 필드들)
    if (!userData.employment_status) userData.employment_status = 'EMPLOYED';
    if (!userData.children_count) userData.children_count = '0';
    if (!userData.sido) userData.sido = '';
    if (!userData.sigungu) userData.sigungu = '';

    // 로딩 화면 표시
    showLoading();

    // 서버로 AJAX 요청 전송 (URL-encoded form 데이터로 전송)
    const params = new URLSearchParams();
    Object.keys(userData).forEach(key => {
        params.append(key, userData[key]+"");
    });

    fetch('/bdproject/welfare/match', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params
    })
    .then(response => {
        if (!response.ok) {
            // HTTP 상태 코드별 에러 페이지 리다이렉트
            if (response.status === 404) {
                window.location.href = '/bdproject/error/error404.jsp';
            } else if (response.status === 405) {
                window.location.href = '/bdproject/error/error405.jsp';
            } else {
                window.location.href = '/bdproject/error/error500.jsp';
            }
            throw new Error('서버 응답 오류: ' + response.status);
        }
        return response.json();
    })
    .then(data => {
        proceedToResults(data, userData);
    })
    .catch(error => {
        hideLoading();
        console.error('Error:', error);
        // 네트워크 오류 등 기타 오류 시 500 에러 페이지로
        if (!error.message.includes('서버 응답 오류')) {
            window.location.href = '/bdproject/error/error500.jsp';
        }
    });

    return false;
}

// 결과 페이지로 이동
function proceedToResults(data, userData) {
    sessionStorage.setItem('welfareResults', JSON.stringify(data));
    sessionStorage.setItem('userInfo', JSON.stringify(userData));

    // POST 방식으로 데이터 전달
    var form = document.createElement('form');
    form.method = 'POST';
    form.action = '/bdproject/project_result.jsp';
    form.style.display = 'none';

    // 사용자 데이터를 폼으로 전달
    Object.keys(userData).forEach(function(key) {
        var input = document.createElement('input');
        input.type = 'hidden';
        input.name = key;
        input.value = userData[key];
        form.appendChild(input);
    });

    document.body.appendChild(form);
    form.submit();
}

// 로딩 화면 표시
function showLoading() {
    const loadingHtml = `
        <div id="loading-overlay" style="
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.9);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10000;
            flex-direction: column;
        ">
            <div style="
                width: 60px;
                height: 60px;
                border: 4px solid #f3f3f3;
                border-top: 4px solid #0061ff;
                border-radius: 50%;
                animation: spin 1s linear infinite;
                margin-bottom: 20px;
            "></div>
            <h3 style="color: #333; margin-bottom: 10px;">복지 혜택을 조회하고 있습니다</h3>
            <p style="color: #666; text-align: center;">
                잠시만 기다려주세요...
            </p>
            <style>
                @keyframes spin {
                    0% { transform: rotate(0deg); }
                    100% { transform: rotate(360deg); }
                }
            </style>
        </div>
    `;
    document.body.insertAdjacentHTML('beforeend', loadingHtml);
}

// 로딩 화면 숨기기
function hideLoading() {
    const loadingOverlay = document.getElementById('loading-overlay');
    if (loadingOverlay) {
        loadingOverlay.remove();
    }
}

// 페이지 로드 시 이벤트 리스너 초기화
document.addEventListener('DOMContentLoaded', function() {
    initializeDaySelector();
    initializeSigunguSelector();
});
