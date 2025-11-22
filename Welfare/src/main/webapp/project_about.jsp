<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>소개 - 복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f8f9fa;
            color: #333;
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

        .navbar-left { flex-shrink: 0; }

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

        .nav-menu {
            display: flex;
            gap: 50px;
            align-items: center;
            justify-content: center;
            flex-grow: 1;
        }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .navbar-icon {
            width: 22px;
            height: 22px;
            cursor: pointer;
            color: #333;
        }

        .language-selector {
            position: relative;
            display: inline-block;
        }

        .language-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 8px 0;
            min-width: 160px;
            max-height: 300px;
            overflow-y: auto;
            z-index: 9999;
            margin-top: 5px;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.2s ease;
        }

        .language-dropdown.active {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .language-option {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            padding: 12px 16px;
            cursor: pointer;
            transition: background-color 0.2s ease;
            border-bottom: 1px solid #f0f0f0;
        }

        .language-option:last-child {
            border-bottom: none;
        }

        .language-option:hover {
            background-color: #f5f5f5;
        }

        .language-option.active {
            background-color: #e3f2fd;
        }

        .country-name {
            font-weight: 600;
            color: #333;
            font-size: 14px;
            margin-bottom: 2px;
        }

        .language-name {
            font-size: 12px;
            color: #666;
        }

        .nav-item {
            height: 100%;
            display: flex;
            align-items: center;
        }

        .nav-link {
            color: #333;
            text-decoration: none;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.2s ease;
            padding: 18px 15px;
            border-radius: 8px;
        }

        .nav-link:hover,
        .nav-link.active {
            background-color: #f5f5f5;
            color: #333;
        }

        #mega-menu-wrapper {
            position: absolute;
            width: 100%;
            background-color: white;
            color: #333;
            left: 0;
            top: 60px;
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.4s ease-in-out, padding 0.4s ease-in-out, border-top 0.4s ease-in-out;
            border-top: 1px solid transparent;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.05);
        }

        #mega-menu-wrapper.active {
            max-height: 500px;
            padding: 30px 0 40px 0;
            border-top: 1px solid #e0e0e0;
        }

        .mega-menu-content {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 40px;
            display: flex;
            justify-content: flex-start;
            gap: 60px;
        }

        .menu-column {
            display: none;
            flex-direction: column;
            gap: 25px;
        }

        .menu-column.active {
            display: flex;
        }

        .dropdown-link {
            color: #333;
            text-decoration: none;
            display: block;
        }

        .dropdown-link-title {
            font-weight: 700;
            font-size: 15px;
            display: inline-block;
            position: relative;
            padding-bottom: 5px;
            color: #000000;
        }

        .dropdown-link-title::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background-color: #000000;
            transition: width 0.3s ease;
        }

        .dropdown-link:hover .dropdown-link-title::after {
            width: 100%;
        }

        .dropdown-link-desc {
            font-size: 13px;
            color: #555;
            margin-top: 6px;
            display: block;
        }

        .hero-section {
            background: #f8f9fa;
            color: #333;
            padding: 100px 20px;
            text-align: left;
        }

        .hero-title {
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 20px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
            padding: 0 40px;
        }

        .hero-title .highlight {
            color: #4a90e2;
        }

        .hero-subtitle {
            font-size: 20px;
            opacity: 0.95;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
            padding: 0 40px;
            line-height: 1.6;
            color: #495057;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .section {
            padding: 40px 20px 80px;
        }

        .section-title {
            font-size: 28px;
            font-weight: 600;
            color: #2c3e50;
            text-align: left;
            margin-bottom: 15px;
        }

        .section-subtitle {
            font-size: 16px;
            color: #6c757d;
            text-align: left;
            margin-bottom: 60px;
            line-height: 1.6;
        }

        .service-intro-box {
            position: relative;
            background: linear-gradient(90deg, #2c3e50 0%, #2c3e50 70%, rgba(44, 62, 80, 0.5) 85%, transparent 100%);
            padding: 18px 30px;
            margin-bottom: 40px;
            clip-path: polygon(0 0, calc(100% - 30px) 0, 100% 100%, 0 100%);
            max-width: 550px;
            box-shadow: 0 10px 30px rgba(44, 62, 80, 0.15);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .service-intro-box::after {
            content: '';
            position: absolute;
            right: 0;
            top: 0;
            width: 30px;
            height: 100%;
            background: linear-gradient(135deg, rgba(74, 144, 226, 0.1) 0%, transparent 100%);
            clip-path: polygon(0 0, 100% 0, 100% 100%, 0 100%);
        }

        .service-intro-box:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(44, 62, 80, 0.2);
        }

        .service-intro-box .section-title {
            color: white;
            margin-bottom: 8px;
            font-size: 20px;
            font-weight: 700;
            letter-spacing: -0.5px;
        }

        .service-intro-box .section-subtitle {
            color: rgba(255, 255, 255, 0.95);
            margin-bottom: 0;
            font-size: 14px;
            line-height: 1.4;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
            margin-top: 40px;
        }

        .feature-card {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 25px rgba(0,0,0,0.15);
        }

        .feature-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
            font-size: 36px;
            color: white;
        }

        .feature-title {
            font-size: 22px;
            font-weight: 600;
            color: #212529;
            margin-bottom: 15px;
        }

        .feature-description {
            font-size: 15px;
            color: #6c757d;
            line-height: 1.8;
        }

        .stats-section {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 80px 20px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            margin-top: 40px;
        }

        .stat-card {
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 20px;
        }

        .stat-circle {
            position: relative;
            width: 200px;
            height: 200px;
        }

        .stat-circle canvas {
            max-width: 100%;
            max-height: 100%;
        }

        .stat-info {
            text-align: center;
            margin-top: 10px;
        }

        .stat-number {
            font-size: 22px;
            font-weight: 700;
            color: white;
            display: block;
            margin-bottom: 5px;
        }

        .stat-percentage {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.85);
            font-weight: 500;
        }

        .stat-label {
            font-size: 18px;
            opacity: 0.9;
            color: white;
        }

        .mission-section {
            background: white;
        }

        .mission-content {
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
        }

        .mission-text {
            font-size: 18px;
            color: #495057;
            line-height: 2;
            margin-bottom: 30px;
        }

        .values-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 30px;
            margin-top: 50px;
        }

        .value-item {
            text-align: center;
            padding: 30px 20px;
        }

        .value-emoji {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .value-title {
            font-size: 18px;
            font-weight: 600;
            color: #212529;
            margin-bottom: 10px;
        }

        .value-desc {
            font-size: 14px;
            color: #6c757d;
        }

        .contact-section {
            background: #f8f9fa;
        }

        .contact-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }

        .contact-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
        }

        .contact-icon {
            font-size: 36px;
            color: #4a90e2;
            margin-bottom: 20px;
        }

        .contact-title {
            font-size: 20px;
            font-weight: 600;
            color: #212529;
            margin-bottom: 10px;
        }

        .contact-info {
            font-size: 16px;
            color: #495057;
        }

  
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <!-- 히어로 섹션 -->
    <section class="hero-section">
        <h1 class="hero-title">우리는 <span class="highlight">공평합니다</span></h1>
        <p class="hero-subtitle">
            복지24는 민족, 종교, 정치와 관계없이 모든 국민에게 필요한 복지 혜택 정보를 제공합니다.<br>
            우리는 복지가 가장 필요한 곳을 찾아갑니다. 우리는 복지의 사각지대를 없앱니다.
        </p>
    </section>

    <!-- 주요 기능 섹션 -->
    <section class="section">
        <div class="container">
            <div class="service-intro-box">
                <h2 class="section-title">복지24의 주요 서비스</h2>
                <p class="section-subtitle">누구나 쉽게 이용할 수 있는 맞춤형 복지 서비스를 제공합니다</p>
            </div>

            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <h3 class="feature-title">맞춤형 복지 혜택 찾기</h3>
                    <p class="feature-description">
                        간단한 정보 입력만으로 나에게 맞는 복지 혜택을 추천해 드립니다.
                        중앙부처와 지방자치단체의 모든 복지 서비스를 한 번에 검색할 수 있습니다.
                    </p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-map-marked-alt"></i>
                    </div>
                    <h3 class="feature-title">복지 지도</h3>
                    <p class="feature-description">
                        내 주변의 복지시설을 지도에서 쉽게 찾을 수 있습니다.
                        복지관, 주민센터, 상담센터 등 다양한 시설의 위치와 정보를 제공합니다.
                    </p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-hands-helping"></i>
                    </div>
                    <h3 class="feature-title">봉사 및 기부</h3>
                    <p class="feature-description">
                        봉사활동 신청과 기부를 통해 지역사회에 기여할 수 있습니다.
                        함께 만드는 따뜻한 사회, 복지24가 연결해 드립니다.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- 통계 섹션 -->
    <section class="stats-section">
        <div class="container">
            <h2 class="section-title" style="color: white; text-align: center;">복지24의 주요 기능</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-circle">
                        <canvas id="chart1"></canvas>
                    </div>
                    <div class="stat-info">
                        <span class="stat-number">중앙 + 지방</span>
                        <span class="stat-percentage">2개 API</span>
                    </div>
                    <div class="stat-label">복지 서비스 연동</div>
                </div>
                <div class="stat-card">
                    <div class="stat-circle">
                        <canvas id="chart2"></canvas>
                    </div>
                    <div class="stat-info">
                        <span class="stat-number">생애주기</span>
                        <span class="stat-percentage">맞춤형</span>
                    </div>
                    <div class="stat-label">복지 진단 시스템</div>
                </div>
                <div class="stat-card">
                    <div class="stat-circle">
                        <canvas id="chart3"></canvas>
                    </div>
                    <div class="stat-info">
                        <span class="stat-number">전국 시설</span>
                        <span class="stat-percentage">지도 검색</span>
                    </div>
                    <div class="stat-label">복지 시설 찾기</div>
                </div>
                <div class="stat-card">
                    <div class="stat-circle">
                        <canvas id="chart4"></canvas>
                    </div>
                    <div class="stat-info">
                        <span class="stat-number">봉사 + 기부</span>
                        <span class="stat-percentage">참여 가능</span>
                    </div>
                    <div class="stat-label">사회 공헌 활동</div>
                </div>
            </div>
        </div>
    </section>

    <!-- 미션 및 비전 섹션 -->
    <section class="section mission-section">
        <div class="container">
            <h2 class="section-title" style="text-align: center;">우리의 미션</h2>
            <div class="mission-content">
                <p class="mission-text">
                    <strong>모든 국민이 복지 사각지대 없이 자신에게 맞는 혜택을 누릴 수 있는 세상</strong>을 만듭니다.
                    복잡한 복지 제도를 쉽게 이해하고, 간편하게 신청할 수 있도록 기술과 정보를 연결합니다.
                </p>
                <p class="mission-text">
                    복지24는 단순한 정보 제공을 넘어, 실질적인 도움이 필요한 분들에게
                    <strong>맞춤형 솔루션</strong>을 제공하여 삶의 질을 향상시키는 것을 목표로 합니다.
                </p>
            </div>

            <div class="values-grid">
                <div class="value-item">
                    <div class="value-emoji">🤝</div>
                    <div class="value-title">신뢰</div>
                    <div class="value-desc">정확한 정보로 신뢰를 만듭니다</div>
                </div>
                <div class="value-item">
                    <div class="value-emoji">💡</div>
                    <div class="value-title">혁신</div>
                    <div class="value-desc">기술로 복지를 혁신합니다</div>
                </div>
                <div class="value-item">
                    <div class="value-emoji">❤️</div>
                    <div class="value-title">배려</div>
                    <div class="value-desc">사용자를 먼저 생각합니다</div>
                </div>
                <div class="value-item">
                    <div class="value-emoji">🌍</div>
                    <div class="value-title">포용</div>
                    <div class="value-desc">모두를 위한 서비스를 만듭니다</div>
                </div>
            </div>
        </div>
    </section>

    <!-- 문의 섹션 -->
    <section class="section contact-section">
        <div class="container">
            <h2 class="section-title">문의하기</h2>
            <p class="section-subtitle">복지24에 대해 궁금한 점이 있으신가요? 언제든 연락주세요</p>

            <div class="contact-grid">
                <div class="contact-card">
                    <div class="contact-icon">
                        <i class="fas fa-phone"></i>
                    </div>
                    <h3 class="contact-title">전화 문의</h3>
                    <p class="contact-info">1544-1234<br>평일 09:00 - 18:00</p>
                </div>

                <div class="contact-card">
                    <div class="contact-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <h3 class="contact-title">이메일</h3>
                    <p class="contact-info">support@welfare24.kr<br>24시간 접수 가능</p>
                </div>

                <div class="contact-card">
                    <div class="contact-icon">
                        <i class="fas fa-comments"></i>
                    </div>
                    <h3 class="contact-title">채팅 상담</h3>
                    <p class="contact-info">웹사이트 우측 하단<br>실시간 상담 가능</p>
                </div>
            </div>
        </div>
    </section>

       <%@ include file="footer.jsp" %>
    <script>
        // DOM이 완전히 로드된 후 실행
        document.addEventListener('DOMContentLoaded', function() {
            // --- Chart.js 통계 차트 초기화 ---
            const chartConfig = [
                { id: 'chart1', percentage: 90, colors: ['#4a90e2', '#357abd'] },
                { id: 'chart2', percentage: 95, colors: ['#27ae60', '#229954'] },
                { id: 'chart3', percentage: 85, colors: ['#f39c12', '#e67e22'] },
                { id: 'chart4', percentage: 95, colors: ['#e74c3c', '#c0392b'] }
            ];

            chartConfig.forEach(config => {
                const ctx = document.getElementById(config.id);
                if (ctx) {
                    new Chart(ctx, {
                        type: 'doughnut',
                        data: {
                            datasets: [{
                                data: [config.percentage, 100 - config.percentage],
                                backgroundColor: [
                                    createGradient(ctx, config.colors),
                                    'rgba(255, 255, 255, 0.1)'
                                ],
                                borderWidth: 0,
                                cutout: '75%'
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: true,
                            plugins: {
                                legend: { display: false },
                                tooltip: { enabled: false }
                            },
                            animation: {
                                animateRotate: true,
                                animateScale: true,
                                duration: 2000,
                                easing: 'easeInOutQuart'
                            }
                        }
                    });
                }
            });

            function createGradient(ctx, colors) {
                const canvas = ctx.canvas || ctx;
                const chartCtx = canvas.getContext('2d');
                const gradient = chartCtx.createLinearGradient(0, 0, canvas.width, canvas.height);
                gradient.addColorStop(0, colors[0]);
                gradient.addColorStop(1, colors[1]);
                return gradient;
            }
            // --- Chart.js 로직 끝 ---

            // --- 네비바 드롭다운 메뉴 ---
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
            // --- 네비바 로직 끝 ---

            // 언어 선택 드롭다운
            const languageToggle = document.getElementById('languageToggle');
            const languageDropdown = document.getElementById('languageDropdown');

            if (languageToggle && languageDropdown) {
                languageToggle.addEventListener('click', function(e) {
                    e.stopPropagation();
                    languageDropdown.classList.toggle('active');
                });

                document.addEventListener('click', function() {
                    languageDropdown.classList.remove('active');
                });
            }

            // 유저 아이콘 클릭
            const userIcon = document.getElementById('userIcon');
            if (userIcon) {
                userIcon.addEventListener('click', function() {
                    window.location.href = '/bdproject/projectLogin.jsp';
                });
            }
        });
    </script>
</body>
</html>
