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
