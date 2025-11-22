<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            background-color: #f8f9fa;
            color: #333;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        #main-header {
            position: sticky;
            top: 0;
            z-index: 1000;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .navbar {
            background-color: transparent;
            padding: 0 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 60px;
        }

        
        .logo {
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            color: #333;
            width: fit-content;
            transition: opacity 0.2s ease;
        }

        .logo:hover {
            opacity: 0.7;
        }

        .logo-icon {
            width: 40px;
            height: 40px;
            background-image: url('resources/image/복지로고.png');
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
        }

        .logo-text {
            font-size: 24px;
            font-weight: 700;
            color: #333;
        }
        
        .main-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .loading {
            text-align: center;
            padding: 60px 20px;
        }

        .loading-spinner {
            width: 60px;
            height: 60px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid #4A90E2;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .progress-container {
            width: 100%;
            background-color: #f0f0f0;
            border-radius: 10px;
            margin: 20px 0;
        }

        .progress-bar {
            height: 20px;
            background: linear-gradient(90deg, #4A90E2, #357ABD);
            border-radius: 10px;
            transition: width 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 12px;
            font-weight: 600;
        }

        .summary-card {
            background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%);
            color: white;
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 30px;
            text-align: center;
        }

        .summary-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .summary-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }

        .stat-item {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 20px;
        }

        .stat-number {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 14px;
            opacity: 0.9;
        }

        .filter-section {
            background-color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .filter-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .filter-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .filter-btn {
            padding: 8px 16px;
            border: 2px solid #e9ecef;
            border-radius: 20px;
            background-color: white;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.2s ease;
        }

        .filter-btn.active {
            background-color: #4A90E2;
            color: white;
            border-color: #4A90E2;
        }

        .filter-btn:hover {
            border-color: #4A90E2;
        }

        .results-grid {
            display: grid;
            gap: 20px;
        }

        .welfare-card {
            background-color: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border-left: 5px solid #e9ecef;
        }

        .welfare-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 25px rgba(0,0,0,0.15);
        }

        .welfare-card.high-match {
            border-left-color: #28a745;
        }

        .welfare-card.medium-match {
            border-left-color: #ffc107;
        }

        .welfare-card.low-match {
            border-left-color: #dc3545;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .card-title {
            font-size: 20px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
            flex: 1;
        }

        .favorite-btn {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            padding: 0;
            margin-left: 10px;
            transition: transform 0.2s ease;
            color: #ccc;
        }

        .favorite-btn.active {
            color: #ffd700;
        }

        .favorite-btn:hover {
            transform: scale(1.2);
        }

        .confidence-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 15px;
        }

        .confidence-high {
            background-color: #d4edda;
            color: #155724;
        }

        .confidence-medium {
            background-color: #fff3cd;
            color: #856404;
        }

        .confidence-low {
            background-color: #f8d7da;
            color: #721c24;
        }

        .card-department {
            color: #6c757d;
            font-size: 14px;
            margin-bottom: 15px;
        }

        .card-description {
            color: #495057;
            margin-bottom: 15px;
            line-height: 1.5;
        }

        .card-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 15px;
        }

        .tag {
            padding: 4px 8px;
            background-color: #f8f9fa;
            border-radius: 12px;
            font-size: 12px;
            color: #6c757d;
        }

        .eligibility-reasons {
            background-color: #f8f9ff;
            border-radius: 8px;
            padding: 15px;
            margin-top: 15px;
        }

        .reasons-title {
            font-size: 14px;
            font-weight: 600;
            color: #4A90E2;
            margin-bottom: 8px;
        }

        .reason-item {
            font-size: 13px;
            color: #495057;
            margin-bottom: 4px;
            padding-left: 12px;
            position: relative;
        }

        .reason-item:before {
            content: "•";
            color: #4A90E2;
            position: absolute;
            left: 0;
        }

        .card-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background-color: #4A90E2;
            color: white;
        }

        .btn-primary:hover {
            background-color: #0052d4;
        }

        .btn-outline {
            background-color: white;
            color: #4A90E2;
            border: 2px solid #4A90E2;
        }

        .btn-outline:hover {
            background-color: #4A90E2;
            color: white;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }

        .empty-icon {
            font-size: 48px;
            margin-bottom: 20px;
        }

        .inquiry-count {
            color: #6c757d;
            font-size: 12px;
            margin-top: 5px;
        }

        .online-application {
            background-color: #e8f5e8;
            color: #2e7d32;
            font-size: 11px;
            padding: 2px 6px;
            border-radius: 8px;
            margin-left: 8px;
        }

        @media (max-width: 768px) {
            .summary-stats { grid-template-columns: 1fr 1fr; }
            .filter-buttons { justify-content: center; }
            .card-header { flex-direction: column; }
            .confidence-badge { margin-left: 0; margin-top: 10px; align-self: flex-start; }
        }

        /* 알림 애니메이션 */
        @keyframes slideIn {
            from {
                transform: translateX(400px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(400px);
                opacity: 0;
            }
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="main-container">
        <div id="loading" class="loading">
            <c:choose>
                <c:when test="${not empty error}">
                    <div class="empty-state">
                        <div class="empty-icon">❌</div>
                        <h3>오류가 발생했습니다</h3>
                        <p><c:out value="${error}"/></p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="loading-spinner"></div>
                    <h3>복지 혜택을 분석하고 있습니다...</h3>
                    <p>중앙부처 및 지자체 복지 서비스를 조회하고 매칭 분석 중입니다.</p>
                    <div class="progress-container">
                        <div class="progress-bar" id="progress-bar" style="width: 0%">0%</div>
                    </div>
                    <p id="status-text">서버에 연결 중...</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div id="results" style="display: none;">
            <div class="summary-card">
                <div class="summary-title">맞춤 복지 혜택 분석 결과</div>
                <p>회원님의 상황에 맞는 복지 혜택을 찾았습니다</p>
                <div class="summary-stats">
                    <div class="stat-item">
                        <div class="stat-number" id="total-count">0</div>
                        <div class="stat-label">전체 혜택</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" id="high-match-count">0</div>
                        <div class="stat-label">높은 적합도</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" id="online-available">0</div>
                        <div class="stat-label">온라인 신청 가능</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" id="central-count">0</div>
                        <div class="stat-label">중앙부처</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" id="local-count">0</div>
                        <div class="stat-label">지자체</div>
                    </div>
                </div>
            </div>

            <div class="filter-section">
                <div class="filter-title">필터</div>
                <div class="filter-buttons">
                    <button class="filter-btn active" data-filter="all">전체</button>
                    <button class="filter-btn" data-filter="high">높은 적합도</button>
                    <button class="filter-btn" data-filter="medium">중간 적합도</button>
                    <button class="filter-btn" data-filter="central">중앙부처</button>
                    <button class="filter-btn" data-filter="local">지자체</button>
                    <button class="filter-btn" data-filter="online">온라인신청</button>
                </div>
            </div>

            <div class="results-grid" id="welfare-grid">
                <!-- 복지 혜택 카드들이 여기에 동적으로 추가됩니다 -->
            </div>
        </div>
    </div>

<script>
// 서버에서 전달받은 사용자 데이터
var userData = {
<c:choose>	
    <c:when test="${not empty userData}">
        birthdate: '<c:out value="${userData.birthdate}" escapeXml="true"/>',
        gender: '<c:out value="${userData.gender}" escapeXml="true"/>',
        household_size: parseInt('<c:out value="${userData.household_size}" default="1"/>'),
        income: '<c:out value="${userData.income}" escapeXml="true"/>',
        marital_status: '<c:out value="${userData.marital_status}" escapeXml="true"/>',
        children_count: parseInt('<c:out value="${userData.children_count}" default="0"/>'),
        employment_status: '<c:out value="${userData.employment_status}" escapeXml="true"/>',
        sido: '<c:out value="${userData.sido}" escapeXml="true"/>',
        sigungu: '<c:out value="${userData.sigungu}" escapeXml="true"/>',
        isPregnant: <c:out value="${userData.isPregnant}" default="false"/>,
        isDisabled: <c:out value="${userData.isDisabled}" default="false"/>,
        isMulticultural: <c:out value="${userData.isMulticultural}" default="false"/>,
        isVeteran: <c:out value="${userData.isVeteran}" default="false"/>,
        isSingleParent: <c:out value="${userData.isSingleParent}" default="false"/>
    </c:when>
    <c:otherwise>
        birthdate: '1995-03-15', gender: 'female', household_size: 2,
        income: '200_300', marital_status: 'married', children_count: 1,
        employment_status: 'employed', sido: '서울특별시', sigungu: '강남구',
        isPregnant: false, isDisabled: false, isMulticultural: false, 
        isVeteran: false, isSingleParent: false
    </c:otherwise>
</c:choose>
};

// 전체 복지 서비스 데이터 저장용
var matchedServices = [];

// 복지 진단 결과 저장용 (상위 10개)
var welfareResults = [];

// 진행률 업데이트
function updateProgress(percentage, status) {
    var progressBar = document.getElementById('progress-bar');
    var statusText = document.getElementById('status-text');
    
    if (progressBar) {
        progressBar.style.width = percentage + '%';
        progressBar.textContent = percentage + '%';
    }
    
    if (statusText) {
        statusText.textContent = status;
    }
}

// 서버에서 복지 매칭 결과 받기
function runComprehensiveWelfareMatching() {
    updateProgress(10, '저장된 매칭 결과 불러오는 중...');

    // sessionStorage에서 결과 확인
    const storedResults = sessionStorage.getItem('welfareResults');
    const storedUserInfo = sessionStorage.getItem('userInfo');

    // sessionStorage 데이터 즉시 클리어 (중복 사용 방지)
    if (storedResults || storedUserInfo) {
        sessionStorage.removeItem('welfareResults');
        sessionStorage.removeItem('userInfo');
    }

    if (storedResults && storedUserInfo) {
        updateProgress(50, '매칭 결과 처리 중...');
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

            setTimeout(function() {
                updateProgress(100, '분석 완료!');
                displayComprehensiveResults(matchedServices);
            }, 1000);
        } catch (error) {
            console.error('저장된 결과 파싱 오류:', error);
            fallbackToApiCall();
        }
    } else {
        // sessionStorage에 데이터가 없으면 임시 데이터 바로 사용
        console.log('sessionStorage 데이터 없음 - 임시 데이터 사용');
        updateProgress(50, '임시 데이터 로드 중...');
        matchedServices = getMockWelfareData();

        setTimeout(function() {
            updateProgress(100, '분석 완료!');
            displayComprehensiveResults(matchedServices);
        }, 500);
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
    updateProgress(30, '서버에서 복지 서비스 조회 중...');

    fetch('/bdproject/welfare/match', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: new URLSearchParams(userData)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('서버 응답 오류');
        }
        return response.json();
    })
    .then(data => {
        updateProgress(90, '매칭 결과 처리 중...');
        matchedServices = data;

        setTimeout(function() {
            updateProgress(100, '분석 완료!');
            displayComprehensiveResults(matchedServices);
        }, 500);
    })
    .catch(error => {
        console.error('복지 매칭 오류:', error);
        console.log('임시 데이터를 사용합니다.');

        // API 실패 시 임시 데이터 사용
        updateProgress(70, '임시 복지 데이터 로드 중...');
        matchedServices = getMockWelfareData();

        setTimeout(function() {
            updateProgress(100, '분석 완료!');
            displayComprehensiveResults(matchedServices);
        }, 800);
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
</script>
</body>
</html>