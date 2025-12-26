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
    <link rel="stylesheet" href="resources/css/project_about.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
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
    <script src="resources/js/project_about.js"></script>
</body>
</html>
