<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>기금 사용처 - 복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
    <link rel="stylesheet" href="resources/css/project_fundUsage.css" />
  </head>
  <body>
    <%@ include file="navbar.jsp" %>

    <!-- 히어로 섹션 -->
    <section class="hero-section">
      <h1 class="hero-title">
        <span class="highlight">투명한</span> 기금 운영
      </h1>
      <p class="hero-subtitle">
        복지24는 기부자 여러분의 소중한 후원금을 투명하게 운영합니다.<br />
        모든 기부금은 도움이 필요한 분들에게 직접 전달되며, 정기적인 회계감사를
        통해 투명성을 보장합니다.
      </p>
    </section>

    <!-- 통계 섹션 -->
    <section class="section">
      <div class="container">
        <div class="fund-intro-box">
          <h2 class="section-title">2025년 기금 운영 현황</h2>
          <p class="section-subtitle">
            올해 접수된 기부금과 집행 내역을 한눈에 확인하세요
          </p>
        </div>

        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-icon">
              <i class="fas fa-hand-holding-heart"></i>
            </div>
            <div class="stat-value" id="totalAmountValue">0원</div>
            <div class="stat-label">총 모금액</div>
          </div>
          <div class="stat-card">
            <div class="stat-icon">
              <i class="fas fa-users"></i>
            </div>
            <div class="stat-value" id="donorCountValue">0명</div>
            <div class="stat-label">후원자 수</div>
          </div>
          <div class="stat-card">
            <div class="stat-icon">
              <i class="fas fa-heart"></i>
            </div>
            <div class="stat-value" id="beneficiaryCountValue">0명</div>
            <div class="stat-label">수혜자 수</div>
          </div>
        </div>
      </div>
    </section>

    <!-- 카테고리별 지출 섹션 -->
    <section class="section" style="background: white">
      <div class="container">
        <h2 class="section-title">분야별 기금 사용 내역</h2>
        <p class="section-subtitle">
          2025년 기부금이 어떻게 사용되었는지 확인하세요
        </p>

        <div class="distribution-grid" id="categoryStatisticsGrid">
          <!-- 여기에 동적으로 카테고리별 통계가 삽입됩니다 -->
          <div style="text-align: center; padding: 60px 20px; grid-column: 1 / -1;">
            <i class="fas fa-spinner fa-spin" style="font-size: 48px; color: #4A90E2; margin-bottom: 20px;"></i>
            <p style="font-size: 16px; color: #6c757d;">분야별 기금 사용 내역을 불러오는 중...</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 주요 사용 사례 섹션 -->
    <section class="section use-cases-section">
      <div class="container">
        <h2 class="section-title">주요 지원 사례</h2>
        <p class="section-subtitle">
          여러분의 후원금이 실제로 어떻게 사용되는지 확인하세요
        </p>

        <div class="use-cases-grid">
          <div class="use-case-card">
            <div class="use-case-image">
              <i class="fas fa-home"></i>
            </div>
            <div class="use-case-content">
              <h3 class="use-case-title">화재로 집을 잃은 A씨 가족 지원</h3>
              <p class="use-case-description">
                갑작스러운 화재로 모든 것을 잃은 A씨 가족에게 임시 거처 마련 및
                생활비를 지원했습니다. 현재 안정적인 주거지를 확보하고 일상으로
                돌아가고 있습니다.
              </p>
              <div class="use-case-amount">지원금액: 800만원</div>
            </div>
          </div>

          <div class="use-case-card">
            <div class="use-case-image">
              <i class="fas fa-heartbeat"></i>
            </div>
            <div class="use-case-content">
              <h3 class="use-case-title">희귀병 어린이 B양 수술비 지원</h3>
              <p class="use-case-description">
                희귀병으로 고통받던 B양에게 긴급 수술비를 지원하여 성공적으로
                수술을 마쳤습니다. 현재 건강을 회복하며 밝은 미래를 준비하고
                있습니다.
              </p>
              <div class="use-case-amount">지원금액: 1,200만원</div>
            </div>
          </div>

          <div class="use-case-card">
            <div class="use-case-image">
              <i class="fas fa-baby"></i>
            </div>
            <div class="use-case-content">
              <h3 class="use-case-title">한부모 가정 C씨 생활비 지원</h3>
              <p class="use-case-description">
                홀로 두 아이를 키우며 생계를 이어가던 C씨에게 6개월간 생활비와
                자녀 교육비를 지원했습니다. 안정적인 직장을 구하고 자립할 수
                있도록 도왔습니다.
              </p>
              <div class="use-case-amount">지원금액: 450만원</div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 투명성 보고서 섹션 -->
    <section class="section reports-section">
      <div class="container">
        <h2 class="section-title">재무 보고서</h2>
        <p class="section-subtitle">복지24의 재무 현황을 투명하게 공개합니다</p>

        <div class="reports-grid">
          <div class="report-card">
            <div class="report-header">
              <div class="report-icon">
                <i class="fas fa-file-pdf"></i>
              </div>
              <div class="report-title">2025년 상반기 결산보고서</div>
            </div>
            <p class="report-description">
              2025년 1월부터 6월까지의 기부금 수입 및 지출 내역을 상세하게
              확인하실 수 있습니다.
            </p>
            <button class="report-download-btn">
              <i class="fas fa-download"></i>
              다운로드
            </button>
          </div>

          <div class="report-card">
            <div class="report-header">
              <div class="report-icon">
                <i class="fas fa-file-pdf"></i>
              </div>
              <div class="report-title">2023년 연간 결산보고서</div>
            </div>
            <p class="report-description">
              2023년 전체 기부금 운영 현황과 주요 지원 사례를 담은 연간
              보고서입니다.
            </p>
            <button class="report-download-btn">
              <i class="fas fa-download"></i>
              다운로드
            </button>
          </div>

          <div class="report-card">
            <div class="report-header">
              <div class="report-icon">
                <i class="fas fa-file-pdf"></i>
              </div>
              <div class="report-title">외부 회계감사 보고서</div>
            </div>
            <p class="report-description">
              공인회계법인의 독립적인 외부 감사를 통해 검증된 재무 현황
              보고서입니다.
            </p>
            <button class="report-download-btn">
              <i class="fas fa-download"></i>
              다운로드
            </button>
          </div>
        </div>
      </div>
    </section>

    <%@ include file="footer.jsp" %>

    <script src="resources/js/project_fundUsage.js"></script>
    </body>
</html>
