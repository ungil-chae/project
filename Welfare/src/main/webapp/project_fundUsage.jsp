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
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
          sans-serif;
        background: #f8f9fa;
        color: #333;
      }

      .hero-section {
        background: #f8f9fa;
        color: #333;
        padding: 60px 20px 40px;
        text-align: left;
      }

      .hero-title {
        font-size: 48px;
        font-weight: 700;
        margin-bottom: 15px;
        max-width: 1200px;
        margin-left: auto;
        margin-right: auto;
        padding: 0 40px;
      }

      .hero-title .highlight {
        color: #4a90e2;
      }

      .hero-subtitle {
        font-size: 18px;
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

      .fund-intro-box {
        position: relative;
        background: linear-gradient(
          90deg,
          #2c3e50 0%,
          #2c3e50 70%,
          rgba(44, 62, 80, 0.5) 85%,
          transparent 100%
        );
        padding: 18px 30px;
        margin-bottom: 40px;
        clip-path: polygon(0 0, calc(100% - 30px) 0, 100% 100%, 0 100%);
        max-width: 550px;
        box-shadow: 0 10px 30px rgba(44, 62, 80, 0.15);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
      }

      .fund-intro-box::after {
        content: "";
        position: absolute;
        right: 0;
        top: 0;
        width: 30px;
        height: 100%;
        background: linear-gradient(
          135deg,
          rgba(74, 144, 226, 0.1) 0%,
          transparent 100%
        );
        clip-path: polygon(0 0, 100% 0, 100% 100%, 0 100%);
      }

      .fund-intro-box:hover {
        transform: translateY(-3px);
        box-shadow: 0 15px 40px rgba(44, 62, 80, 0.2);
      }

      .fund-intro-box .section-title {
        color: white;
        margin-bottom: 8px;
        font-size: 20px;
        font-weight: 700;
        letter-spacing: -0.5px;
      }

      .fund-intro-box .section-subtitle {
        color: rgba(255, 255, 255, 0.95);
        margin-bottom: 0;
        font-size: 14px;
        line-height: 1.4;
      }

      /* Stats Section */
      .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 30px;
        margin-top: 40px;
      }

      .stat-card {
        background: white;
        padding: 40px 30px;
        border-radius: 15px;
        box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
        text-align: center;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
      }

      .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 25px rgba(0, 0, 0, 0.15);
      }

      .stat-icon {
        width: 70px;
        height: 70px;
        background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 20px;
        font-size: 24px;
        color: white;
      }

      .stat-value {
        font-size: 42px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 10px;
      }

      .stat-label {
        font-size: 16px;
        color: #6c757d;
      }

      /* Distribution Section */
      .distribution-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 30px;
        margin-top: 40px;
      }

      .distribution-item {
        background: white;
        padding: 25px;
        border-radius: 15px;
        box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
      }

      .distribution-header {
        display: flex;
        align-items: center;
        gap: 15px;
        margin-bottom: 15px;
      }

      .distribution-icon {
        width: 50px;
        height: 50px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        color: white;
      }

      .distribution-title {
        font-size: 18px;
        font-weight: 600;
        color: #2c3e50;
        flex: 1;
      }

      .distribution-percentage {
        font-size: 24px;
        font-weight: 700;
        color: #4a90e2;
      }

      .distribution-bar-container {
        background: #e9ecef;
        border-radius: 10px;
        height: 12px;
        overflow: hidden;
        margin-bottom: 10px;
      }

      .distribution-bar {
        height: 100%;
        border-radius: 10px;
        transition: width 1s ease;
      }

      .distribution-amount {
        font-size: 14px;
        color: #6c757d;
      }

      /* Use Cases Section */
      .use-cases-section {
        background: #f8f9fa;
      }

      .use-cases-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
        gap: 30px;
        margin-top: 40px;
      }

      .use-case-card {
        background: white;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
      }

      .use-case-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 25px rgba(0, 0, 0, 0.15);
      }

      .use-case-image {
        width: 100%;
        height: 200px;
        background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 64px;
        color: white;
      }

      .use-case-content {
        padding: 30px;
      }

      .use-case-title {
        font-size: 20px;
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 10px;
      }

      .use-case-description {
        font-size: 15px;
        color: #6c757d;
        line-height: 1.8;
        margin-bottom: 15px;
      }

      .use-case-amount {
        font-size: 18px;
        font-weight: 600;
        color: #4a90e2;
      }

      /* Reports Section */
      .reports-section {
        background: white;
      }

      .reports-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 25px;
        margin-top: 40px;
      }

      .report-card {
        background: white;
        border: 2px solid #e9ecef;
        border-radius: 12px;
        padding: 30px;
        transition: all 0.3s ease;
        cursor: pointer;
      }

      .report-card:hover {
        border-color: #4a90e2;
        box-shadow: 0 4px 15px rgba(74, 144, 226, 0.2);
      }

      .report-header {
        display: flex;
        align-items: center;
        gap: 15px;
        margin-bottom: 15px;
      }

      .report-icon {
        width: 50px;
        height: 50px;
        background: #e3f2fd;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        color: #4a90e2;
      }

      .report-title {
        font-size: 18px;
        font-weight: 600;
        color: #2c3e50;
      }

      .report-description {
        font-size: 14px;
        color: #6c757d;
        margin-bottom: 20px;
        line-height: 1.6;
      }

      .report-download-btn {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 10px 20px;
        background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
      }

      .report-download-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
      }


    </style>
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

    <script>
      // 카테고리별 아이콘 및 색상 매핑 (기부하기 9개 카테고리만 표시)
      const categoryConfig = {
        '위기가정': { icon: 'fa-home', color: '#e74c3c' },
        '화재피해': { icon: 'fa-fire', color: '#e67e22' },
        '자연재해': { icon: 'fa-cloud-rain', color: '#3498db' },
        '의료비': { icon: 'fa-heartbeat', color: '#e74c3c' },
        '범죄피해': { icon: 'fa-shield-alt', color: '#9b59b6' },
        '가정폭력': { icon: 'fa-hand-holding-heart', color: '#f39c12' },
        '한부모': { icon: 'fa-baby', color: '#e91e63' },
        '노숙인': { icon: 'fa-bed', color: '#795548' },
        '자살고위험군': { icon: 'fa-hands-helping', color: '#2ecc71' }
      };

      // 허용된 카테고리 목록 (기부하기의 9개 카테고리만 표시)
      const allowedCategories = Object.keys(categoryConfig);

      // 기본 설정 (매칭되지 않는 카테고리용)
      const defaultConfig = { icon: 'fa-heart', color: '#95a5a6' };

      // 금액 포맷팅 함수 (억/만 단위)
      function formatAmount(amount) {
        if (amount >= 100000000) {
          const eok = Math.floor(amount / 100000000);
          const man = Math.floor((amount % 100000000) / 10000);
          if (man > 0) {
            return eok + '억 ' + man.toLocaleString() + '만원';
          }
          return eok + '억원';
        } else if (amount >= 10000) {
          return Math.floor(amount / 10000).toLocaleString() + '만원';
        }
        return amount.toLocaleString() + '원';
      }

      // 분야별 기금 사용 내역 로드
      function loadCategoryStatistics() {
        console.log('📡 분야별 통계 API 호출 시작...');
        fetch('/bdproject/api/donation/category-statistics')
          .then(response => {
            console.log('📡 API 응답 수신:', response.status);
            return response.json();
          })
          .then(data => {
            console.log('📡 API 데이터:', data);
            const grid = document.getElementById('categoryStatisticsGrid');
            let html = '';

            // API 데이터를 맵으로 변환
            const apiDataMap = {};
            if (data.success && data.data) {
              data.data.forEach(stat => {
                if (allowedCategories.includes(stat.category)) {
                  apiDataMap[stat.category] = stat;
                }
              });
            }

            // 9개 카테고리 모두 표시 (기부 내역이 없어도 0원으로 표시)
            allowedCategories.forEach(category => {
              const stat = apiDataMap[category] || {
                category: category,
                totalAmount: 0,
                percentage: 0,
                donationCount: 0
              };

              const config = categoryConfig[category];
              const percentage = stat.percentage || 0;
              const formattedAmount = formatAmount(stat.totalAmount || 0);

              html += '<div class="distribution-item">' +
                '<div class="distribution-header">' +
                  '<div class="distribution-icon" style="background: ' + config.color + '">' +
                    '<i class="fas ' + config.icon + '"></i>' +
                  '</div>' +
                  '<div class="distribution-title">' + category + ' 지원</div>' +
                '</div>' +
                '<div class="distribution-percentage">' + percentage + '%</div>' +
                '<div class="distribution-bar-container">' +
                  '<div class="distribution-bar" style="width: ' + percentage + '%; background: linear-gradient(135deg, ' + config.color + ' 0%, ' + config.color + 'dd 100%);"></div>' +
                '</div>' +
                '<div class="distribution-amount">' + formattedAmount + '</div>' +
              '</div>';
            });

            grid.innerHTML = html;

            console.log('========================================');
            console.log('📊 분야별 통계 로드 완료');
            console.log('표시된 카테고리 수 (전체 9개):', allowedCategories.length);
            allowedCategories.forEach(category => {
              const stat = apiDataMap[category];
              if (stat) {
                console.log('  ' + category + ': ' + formatAmount(stat.totalAmount) + ' (' + stat.percentage + '%)');
              } else {
                console.log('  ' + category + ': 기부 내역 없음 (0원)');
              }
            });
            console.log('========================================');
          })
          .catch(error => {
            console.error('분야별 통계 API 호출 오류:', error);
            document.getElementById('categoryStatisticsGrid').innerHTML =
              '<div style="text-align: center; padding: 60px 20px; grid-column: 1 / -1;">' +
              '<i class="fas fa-exclamation-triangle" style="font-size: 48px; color: #f39c12; margin-bottom: 20px;"></i>' +
              '<p style="font-size: 16px; color: #6c757d;">데이터를 불러오는 중 오류가 발생했습니다.</p>' +
              '</div>';
          });
      }

      // 기부 통계 로드 함수
      function loadDonationStatistics() {
        fetch('/bdproject/api/donation/statistics')
          .then(response => response.json())
          .then(data => {
            if (data.success && data.data) {
              const stats = data.data;

              // 총 모금액 포맷팅 (억/만 단위)
              const amountText = formatAmount(stats.totalAmount || 0);

              // DOM 업데이트
              document.getElementById('totalAmountValue').textContent = amountText;
              document.getElementById('donorCountValue').textContent = (stats.donorCount || 0) + '명';
              document.getElementById('beneficiaryCountValue').textContent = (stats.beneficiaryCount || 0) + '명';

              console.log('========================================');
              console.log('📊 기부 통계 로드 완료');
              console.log('총 모금액:', stats.totalAmount ? stats.totalAmount.toLocaleString() + '원' : '0원');
              console.log('후원자 수:', stats.donorCount || 0, '명');
              console.log('리뷰(수혜자) 수:', stats.beneficiaryCount || 0, '명');
              console.log('⭐ 평균 만족도:', stats.averageRating ? stats.averageRating.toFixed(1) : '0.0', '/ 5.0');
              console.log('========================================');
            } else {
              console.error('통계 데이터 로드 실패:', data.message);
            }
          })
          .catch(error => {
            console.error('통계 API 호출 오류:', error);
          });
      }

      // DOM이 완전히 로드된 후 실행
      document.addEventListener("DOMContentLoaded", function () {
        try {
          console.log('🚀 페이지 로드 완료, 데이터 로딩 시작');

          // === 기부 통계 로드 ===
          loadDonationStatistics();

          // === 분야별 기금 사용 내역 로드 ===
          loadCategoryStatistics();
        } catch (error) {
          console.error('❌ 페이지 초기화 중 오류:', error);
        }

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
        const languageToggle = document.getElementById("languageToggle");
        const languageDropdown = document.getElementById("languageDropdown");

        if (languageToggle && languageDropdown) {
          languageToggle.addEventListener("click", function (e) {
            e.stopPropagation();
            languageDropdown.classList.toggle("active");
          });

          document.addEventListener("click", function () {
            languageDropdown.classList.remove("active");
          });
        }

        // 유저 아이콘 클릭
        const userIcon = document.getElementById("userIcon");
        if (userIcon) {
          userIcon.addEventListener("click", function () {
            window.location.href = "/bdproject/projectLogin.jsp";
          });
        }

        // 분포 바 애니메이션
        const distributionBars = document.querySelectorAll(".distribution-bar");
        const observer = new IntersectionObserver(
          (entries) => {
            entries.forEach((entry) => {
              if (entry.isIntersecting) {
                entry.target.style.transition = "width 1.5s ease";
              }
            });
          },
          { threshold: 0.1 }
        );

        distributionBars.forEach((bar) => observer.observe(bar));

        // 다운로드 버튼 클릭 이벤트
        const downloadButtons = document.querySelectorAll(
          ".report-download-btn"
        );
        downloadButtons.forEach((button) => {
          button.addEventListener("click", function () {
            alert("준비 중인 기능입니다. 빠른 시일 내에 제공하겠습니다.");
          });
        });
      });
    </script>
    </body>
</html>
