// 전체 복지 서비스 데이터 저장용
var matchedServices = [];

// 복지 진단 결과 저장용 (상위 10개)
var welfareResults = [];

// 서버에서 복지 매칭 결과 받기
function runComprehensiveWelfareMatching() {
    // sessionStorage에서 결과 확인
    const storedResults = sessionStorage.getItem('welfareResults');
    const storedUserInfo = sessionStorage.getItem('userInfo');

    // sessionStorage 데이터 즉시 클리어 (중복 사용 방지)
    if (storedResults || storedUserInfo) {
        sessionStorage.removeItem('welfareResults');
        sessionStorage.removeItem('userInfo');
    }

    if (storedResults && storedUserInfo) {
        try {
            matchedServices = JSON.parse(storedResults);
            const userInfo = JSON.parse(storedUserInfo);

            console.log('sessionStorage에서 복지 서비스 로드:', matchedServices.length + '개');

            // userData 업데이트
            Object.assign(userData, userInfo);

            // 데이터가 비어있으면 임시 데이터 사용
            if (!matchedServices || matchedServices.length === 0) {
                console.log('매칭 결과가 비어있음 - 임시 데이터 사용');
                matchedServices = getMockWelfareData();
            }

            // 결과 바로 표시
            displayComprehensiveResults(matchedServices);
        } catch (error) {
            console.error('저장된 결과 파싱 오류:', error);
            fallbackToApiCall();
        }
    } else {
        // sessionStorage에 데이터가 없으면 임시 데이터 바로 사용
        console.log('sessionStorage 데이터 없음 - 임시 데이터 사용');
        matchedServices = getMockWelfareData();
        displayComprehensiveResults(matchedServices);
    }
}

// 임시 복지 혜택 데이터 (API 작동 전 테스트용)
function getMockWelfareData() {
    return [
        {
            servId: 'MOCK001',
            servNm: '기초생활수급자 생계급여',
            servDgst: '생활이 어려운 사람에게 필요한 급여를 지급하여 최저생활을 보장하고 자활을 돕는 제도입니다.',
            source: '중앙부처',
            jurMnofNm: '보건복지부',
            score: 95,
            onapPsbltYn: 'Y',
            lifeArray: '영유아,아동,청소년,청년,중장년,노년',
            trgterIndvdlArray: '저소득,한부모·조손,장애인',
            servDtlLink: 'https://www.bokjiro.go.kr',
            inqNum: 15234,
            reasons: ['저소득 가구 지원', '전 연령 대상'],
            ctpvNm: '전국'
        },
        {
            servId: 'MOCK002',
            servNm: '긴급복지 생계지원',
            servDgst: '갑작스러운 위기상황으로 생계유지가 어려운 저소득 가구에게 생계비를 일시적으로 지원합니다.',
            source: '중앙부처',
            jurMnofNm: '보건복지부',
            score: 88,
            onapPsbltYn: 'N',
            lifeArray: '청년,중장년',
            trgterIndvdlArray: '저소득,한부모·조손',
            servDtlLink: 'https://www.bokjiro.go.kr',
            inqNum: 8921,
            reasons: ['긴급 생계 위기', '저소득층 지원'],
            ctpvNm: '전국'
        },
        {
            servId: 'MOCK003',
            servNm: '청년 취업성공패키지',
            servDgst: '저소득 청년에게 취업지원 서비스와 훈련비, 구직활동비를 지원하여 노동시장 진입을 돕습니다.',
            source: '중앙부처',
            jurMnofNm: '고용노동부',
            score: 82,
            onapPsbltYn: 'Y',
            lifeArray: '청년',
            trgterIndvdlArray: '저소득,구직자',
            servDtlLink: 'https://www.bokjiro.go.kr',
            inqNum: 12456,
            reasons: ['청년 일자리 지원', '취업 훈련 제공'],
            ctpvNm: '전국'
        },
        {
            servId: 'MOCK004',
            servNm: '노인 기초연금',
            servDgst: '만 65세 이상 어르신 중 소득인정액이 선정기준액 이하인 경우 매월 기초연금을 지급합니다.',
            source: '중앙부처',
            jurMnofNm: '보건복지부',
            score: 90,
            onapPsbltYn: 'Y',
            lifeArray: '노년',
            trgterIndvdlArray: '저소득',
            servDtlLink: 'https://www.bokjiro.go.kr',
            inqNum: 23456,
            reasons: ['만 65세 이상', '소득 하위 70%'],
            ctpvNm: '전국'
        },
        {
            servId: 'MOCK005',
            servNm: '한부모가족 아동양육비 지원',
            servDgst: '저소득 한부모가족의 만 18세 미만 자녀에게 양육비를 지원합니다.',
            source: '중앙부처',
            jurMnofNm: '여성가족부',
            score: 85,
            onapPsbltYn: 'Y',
            lifeArray: '아동,청소년',
            trgterIndvdlArray: '한부모·조손,저소득',
            servDtlLink: 'https://www.bokjiro.go.kr',
            inqNum: 9876,
            reasons: ['한부모 가정', '저소득층 자녀 양육'],
            ctpvNm: '전국'
        },
        {
            servId: 'MOCK006',
            servNm: '장애인 활동지원 서비스',
            servDgst: '신체적·정신적 장애로 혼자 일상생활이 어려운 분들에게 활동보조, 방문목욕 등을 지원합니다.',
            source: '중앙부처',
            jurMnofNm: '보건복지부',
            score: 78,
            onapPsbltYn: 'Y',
            lifeArray: '청년,중장년,노년',
            trgterIndvdlArray: '장애인',
            servDtlLink: 'https://www.bokjiro.go.kr',
            inqNum: 7654,
            reasons: ['장애 등급 해당', '일상생활 지원'],
            ctpvNm: '전국'
        },
        {
            servId: 'MOCK007',
            servNm: '주거급여',
            servDgst: '저소득층의 주거 안정을 위해 실제 임차료 또는 유지수선비를 지원합니다.',
            source: '중앙부처',
            jurMnofNm: '국토교통부',
            score: 92,
            onapPsbltYn: 'Y',
            lifeArray: '영유아,아동,청소년,청년,중장년,노년',
            trgterIndvdlArray: '저소득',
            servDtlLink: 'https://www.bokjiro.go.kr',
            inqNum: 18234,
            reasons: ['주거비 부담 완화', '임차료 지원'],
            ctpvNm: '전국'
        },
        {
            servId: 'MOCK008',
            servNm: '서울시 청년수당',
            servDgst: '서울시 거주 미취업 청년에게 구직활동 지원금을 지급합니다.',
            source: '지자체',
            jurMnofNm: '서울시',
            jurOrgNm: '일자리정책과',
            score: 75,
            onapPsbltYn: 'Y',
            lifeArray: '청년',
            trgterIndvdlArray: '구직자',
            servDtlLink: 'https://www.bokjiro.go.kr',
            inqNum: 5432,
            reasons: ['서울시 거주', '미취업 청년'],
            ctpvNm: '서울특별시'
        }
    ];
}

// 백업용 API 호출 함수
function fallbackToApiCall() {
    fetch('/bdproject/welfare/match', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: new URLSearchParams(userData)
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
        matchedServices = data;
        displayComprehensiveResults(matchedServices);
    })
    .catch(error => {
        console.error('복지 매칭 오류:', error);
        // 네트워크 오류 등 기타 오류 시 500 에러 페이지로
        if (!error.message.includes('서버 응답 오류')) {
            window.location.href = '/bdproject/error/error500.jsp';
        }
    });
}

// 결과 표시
function displayComprehensiveResults(results) {
    document.getElementById('loading').style.display = 'none';
    document.getElementById('results').style.display = 'block';

    var highMatchCount = results.filter(function(r) { return r.score >= 80; }).length;
    var onlineAvailableCount = results.filter(function(r) { return r.onapPsbltYn === 'Y'; }).length;
    var centralCount = results.filter(function(r) { return r.source === '중앙부처'; }).length;
    var localCount = results.filter(function(r) { return r.source === '지자체'; }).length;

    document.getElementById('total-count').textContent = results.length;
    document.getElementById('high-match-count').textContent = highMatchCount;
    document.getElementById('online-available').textContent = onlineAvailableCount;
    document.getElementById('central-count').textContent = centralCount;
    document.getElementById('local-count').textContent = localCount;

    var grid = document.getElementById('welfare-grid');
    if (results.length === 0) {
        grid.innerHTML = '<div class="empty-state">' +
            '<div class="empty-icon">🔍</div>' +
            '<h3>매칭되는 복지 혜택이 없습니다</h3>' +
            '<p>현재 조건으로는 신청 가능한 복지 혜택을 찾을 수 없습니다.<br>' +
            '조건을 변경하거나 복지상담센터(129)로 문의해보세요.</p>' +
        '</div>';
    } else {
        grid.innerHTML = results.map(renderWelfareCard).join('');
    }

    setupFilters(results);

    // 즐겨찾기 목록 로드
    loadFavorites();
}

// 복지 카드 렌더링
function renderWelfareCard(service) { console.log(service);
    var score = service.score || 0;
    var confidenceClass = score >= 80 ? 'high' : score >= 60 ? 'medium' : 'low';
    var matchClass = score >= 80 ? 'high-match' : score >= 60 ? 'medium-match' : 'low-match';

    var reasons = service.reasons || [];
    var reasonsHtml = reasons.map(function(reason) {
        return '<div class="reason-item">' + reason + '</div>';
    }).join('') || '<div class="reason-item">기본 조건 일치</div>';

    var onlineApplicationBadge = service.onapPsbltYn === 'Y' ?
        '<span class="online-application">온라인 신청 가능</span>' : '';

    var sourceClass = service.source === '중앙부처' ? 'central' : 'local';

    return '<div class="welfare-card ' + matchClass + '" data-confidence="' + confidenceClass +
           '" data-source="' + sourceClass + '" data-online="' + service.onapPsbltYn +
           '" data-service-id="' + service.servId + '">' +
        '<div class="card-header">' +
            '<div>' +
                '<div class="card-title">' + (service.servNm || '서비스명 없음') + onlineApplicationBadge + '</div>' +
                '<div class="card-department">' +
                    '<span class="tag" style="background-color: ' + (service.source === '중앙부처' ? '#e3f2fd' : '#f3e5f5') +
                    '; color: ' + (service.source === '중앙부처' ? '#1976d2' : '#7b1fa2') + '">' + service.source + '</span> ' +
                    (service.jurMnofNm || '') +
                    (service.jurOrgNm ? ' ' + service.jurOrgNm : '') +
                '</div>' +
                '<div class="inquiry-count">조회수: ' +
                    (service.inqNum ? service.inqNum.toLocaleString() : '정보 없음') + '회</div>' +
            '</div>' +
            '<div style="display: flex; align-items: center;">' +
                '<div class="confidence-badge confidence-' + confidenceClass + '">' +
                    '적합도 ' + score + '%' +
                '</div>' +
                '<button class="favorite-btn" onclick="toggleFavorite(\'' + service.servId + '\', this)" ' +
                    'data-service-name="' + (service.servNm || '').replace(/'/g, '&apos;') + '" ' +
                    'data-service-purpose="' + (service.servDgst || '').replace(/'/g, '&apos;') + '" ' +
                    'data-department="' + (service.jurMnofNm || '').replace(/'/g, '&apos;') + '" ' +
                    'data-apply-method="' + (service.aplyMtdCn ? 'Y' : 'N') + '" ' +
                    'data-support-type="' + (service.srvPvsnNm || '').replace(/'/g, '&apos;') + '" ' +
                    'data-lifecycle="' + (service.lifeArray || '').replace(/'/g, '&apos;') + '">' +
                    '☆' +
                '</button>' +
            '</div>' +
        '</div>' +
        '<div class="card-description">' + (service.servDgst || '서비스 설명이 없습니다.') + '</div>' +
        '<div class="card-tags">' +
            (service.lifeArray ? service.lifeArray.split(',').map(function(tag) {
                return '<span class="tag">' + tag.trim() + '</span>';
            }).join('') : '') +
            (service.trgterIndvdlArray ? service.trgterIndvdlArray.split(',').map(function(tag) {
                return '<span class="tag">' + tag.trim() + '</span>';
            }).join('') : '') +
            '<span class="tag">' + (service.srvPvsnNm || '제공유형 미정') + '</span>' +
            (service.sprtCycNm ? '<span class="tag">' + service.sprtCycNm + '</span>' : '') +
        '</div>' +
        '<div class="eligibility-reasons">' +
            '<div class="reasons-title">매칭 사유</div>' +
            reasonsHtml +
        '</div>' +
        '<div class="card-actions">' +
            (service.servDtlLink ?
                '<a href="' + service.servDtlLink + '" target="_blank" class="btn btn-primary">복지로 이동</a>' :
                '<button class="btn btn-primary" onclick="showApplicationGuide()">신청 방법</button>') +
        '</div>' +
    '</div>';
}

// 필터 설정
function setupFilters(results) {
    var filterButtons = document.querySelectorAll('.filter-btn');
    var cards = document.querySelectorAll('.welfare-card');

    filterButtons.forEach(function(btn) {
        btn.addEventListener('click', function() {
            filterButtons.forEach(function(b) { b.classList.remove('active'); });
            btn.classList.add('active');

            var filter = btn.dataset.filter;

            cards.forEach(function(card) {
                var show = false;

                switch(filter) {
                    case 'all':
                        show = true;
                        break;
                    case 'high':
                    case 'medium':
                    case 'low':
                        show = card.dataset.confidence === filter;
                        break;
                    case 'central':
                    case 'local':
                        show = card.dataset.source === filter;
                        break;
                    case 'online':
                        show = card.dataset.online === 'Y';
                        break;
                }

                card.style.display = show ? 'block' : 'none';
            });
        });
    });
}

// 신청 방법 안내
function showApplicationGuide() {
    showModal(
        '신청 방법 안내',
        '<strong>복지 혜택 신청 방법:</strong><br><br>' +
        '1. <strong>온라인 신청</strong><br>' +
        '   • 복지로 웹사이트 (www.bokjiro.go.kr)<br>' +
        '   • 해당 부처 홈페이지<br><br>' +
        '2. <strong>방문 신청</strong><br>' +
        '   • 거주지 주민센터<br>' +
        '   • 시/군/구청 복지담당부서<br><br>' +
        '3. <strong>전화 상담</strong><br>' +
        '   • 보건복지상담센터: 129<br><br>' +
        '<small>정확한 신청 방법은 해당 서비스 상세 정보를 확인하세요.</small>'
    );
}

// 모달 표시
function showModal(title, content) {
    var modal = document.createElement('div');
    modal.style.cssText = `
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background-color: rgba(0,0,0,0.5); z-index: 10000;
        display: flex; align-items: center; justify-content: center;
    `;

    var modalContent = document.createElement('div');
    modalContent.style.cssText = `
        background: white; padding: 30px; border-radius: 15px;
        max-width: 600px; max-height: 80vh; overflow-y: auto;
        margin: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    `;

    modalContent.innerHTML = `
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h3 style="margin: 0; color: #2c3e50;">${title}</h3>
            <button onclick="this.closest('.modal').remove()" style="
                background: none; border: none; font-size: 24px; cursor: pointer; color: #666;
            ">&times;</button>
        </div>
        <div style="line-height: 1.6; color: #495057;">${content}</div>
    `;

    modal.className = 'modal';
    modal.appendChild(modalContent);
    document.body.appendChild(modal);

    modal.addEventListener('click', function(e) {
        if (e.target === modal) {
            modal.remove();
        }
    });
}

// 오류 표시
function showError(message) {
    document.getElementById('loading').innerHTML =
        '<div class="empty-state">' +
            '<div class="empty-icon">❌</div>' +
            '<h3>오류가 발생했습니다</h3>' +
            '<p>' + (message || '복지 혜택을 불러오는 중 문제가 발생했습니다.') + '</p>' +
            '<button onclick="location.reload()" class="btn btn-primary" style="margin-top: 20px;">다시 시도</button>' +
        '</div>';
}

// 즐겨찾기 토글 함수
function toggleFavorite(serviceId, btn) {
    event.stopPropagation();

    var isActive = btn.classList.contains('active');

    if (isActive) {
        // 즐겨찾기 삭제
        fetch('/bdproject/api/welfare/favorite/remove?serviceId=' + encodeURIComponent(serviceId), {
            method: 'DELETE'
        })
        .then(function(response) { return response.json(); })
        .then(function(data) {
            if (data.success) {
                btn.classList.remove('active');
                btn.textContent = '☆';
                console.log('즐겨찾기 삭제 성공');
            } else {
                alert(data.message || '즐겨찾기 삭제에 실패했습니다.');
            }
        })
        .catch(function(error) {
            console.error('즐겨찾기 삭제 오류:', error);
            alert('즐겨찾기 삭제 중 오류가 발생했습니다.');
        });
    } else {
        // 즐겨찾기 추가
        var serviceName = btn.getAttribute('data-service-name');
        var servicePurpose = btn.getAttribute('data-service-purpose');
        var department = btn.getAttribute('data-department');
        var applyMethod = btn.getAttribute('data-apply-method');
        var supportType = btn.getAttribute('data-support-type');
        var lifecycleCode = btn.getAttribute('data-lifecycle');

        var formData = new URLSearchParams();
        formData.append('serviceId', serviceId);
        formData.append('serviceName', serviceName);
        formData.append('servicePurpose', servicePurpose);
        formData.append('department', department);
        formData.append('applyMethod', applyMethod);
        formData.append('supportType', supportType);
        formData.append('lifecycleCode', lifecycleCode);

        fetch('/bdproject/api/welfare/favorite/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
        })
        .then(function(response) { return response.json(); })
        .then(function(data) {
            if (data.success) {
                btn.classList.add('active');
                btn.textContent = '★';
                console.log('즐겨찾기 추가 성공');
            } else {
                if (data.message && data.message.includes('로그인')) {
                    alert('로그인이 필요한 서비스입니다.');
                } else {
                    alert(data.message || '즐겨찾기 추가에 실패했습니다.');
                }
            }
        })
        .catch(function(error) {
            console.error('즐겨찾기 추가 오류:', error);
            alert('즐겨찾기 추가 중 오류가 발생했습니다.');
        });
    }
}

// 페이지 로드 시 즐겨찾기 목록 가져오기
function loadFavorites() {
    fetch('/bdproject/api/welfare/favorite/list')
        .then(function(response) { return response.json(); })
        .then(function(data) {
            if (data.success && data.data) {
                var favoriteIds = data.data.map(function(fav) { return fav.serviceId; });

                // 모든 별표 버튼에서 즐겨찾기된 항목 활성화
                document.querySelectorAll('.favorite-btn').forEach(function(btn) {
                    var card = btn.closest('.welfare-card');
                    if (card) {
                        var serviceId = card.getAttribute('data-service-id');
                        if (favoriteIds.includes(serviceId)) {
                            btn.classList.add('active');
                            btn.textContent = '★';
                        }
                    }
                });
            }
        })
        .catch(function(error) {
            console.error('즐겨찾기 목록 로드 오류:', error);
        });
}

// 페이지 로드 시 실행
document.addEventListener('DOMContentLoaded', function() {
    try {
        runComprehensiveWelfareMatching();

        // 진단 결과 저장 여부 확인 및 알림
        setTimeout(function() {
            var diagnosisSaved = sessionStorage.getItem('diagnosisSaved');
            var diagnosisSaveMessage = sessionStorage.getItem('diagnosisSaveMessage');

            if (diagnosisSaved === 'true') {
                // 성공 메시지 표시
                var successDiv = document.createElement('div');
                successDiv.style.cssText = 'position: fixed; top: 20px; right: 20px; background: #4caf50; color: white; padding: 15px 20px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); z-index: 9999; animation: slideIn 0.3s ease-out;';
                successDiv.innerHTML = '✅ ' + (diagnosisSaveMessage || '진단 결과가 마이페이지에 저장되었습니다.');
                document.body.appendChild(successDiv);

                // 3초 후 자동 제거
                setTimeout(function() {
                    successDiv.style.animation = 'slideOut 0.3s ease-out';
                    setTimeout(function() { successDiv.remove(); }, 300);
                }, 3000);

                // sessionStorage 클리어
                sessionStorage.removeItem('diagnosisSaved');
                sessionStorage.removeItem('diagnosisSaveMessage');
            } else if (diagnosisSaved === 'false') {
                // 실패 메시지 표시
                var errorDiv = document.createElement('div');
                errorDiv.style.cssText = 'position: fixed; top: 20px; right: 20px; background: #f44336; color: white; padding: 15px 20px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); z-index: 9999; animation: slideIn 0.3s ease-out;';
                errorDiv.innerHTML = '❌ ' + (diagnosisSaveMessage || '진단 결과 저장 실패');
                document.body.appendChild(errorDiv);

                // 5초 후 자동 제거
                setTimeout(function() {
                    errorDiv.style.animation = 'slideOut 0.3s ease-out';
                    setTimeout(function() { errorDiv.remove(); }, 300);
                }, 5000);

                // sessionStorage 클리어
                sessionStorage.removeItem('diagnosisSaved');
                sessionStorage.removeItem('diagnosisSaveMessage');
            }
        }, 2000);
    } catch (error) {
        console.error('복지 매칭 오류:', error);
        showError('시스템 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    }
});
