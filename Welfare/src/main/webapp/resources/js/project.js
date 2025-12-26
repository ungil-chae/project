// project.js - project.jsp JavaScript

document.addEventListener("DOMContentLoaded", () => {
  // 인기 복지 혜택 로드
  loadPopularWelfareServices();

  // --- 스크롤 애니메이션 ---
  // 공통 관찰자 옵션
  const observerOptions = {
    root: null,
    rootMargin: "0px 0px -20% 0px",
    threshold: 0.1,
  };

  // 공통 관찰자 콜백
  const observerCallback = (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("animate-in");
        console.log(entry.target.className + " 섹션 나타남");
      } else {
        entry.target.classList.remove("animate-in");
        console.log(entry.target.className + " 섹션 사라짐");
      }
    });
  };

  const observer = new IntersectionObserver(
    observerCallback,
    observerOptions
  );

  // 메인 콘텐츠 애니메이션
  const mainContent = document.querySelector(".main-content");
  if (mainContent) {
    observer.observe(mainContent);
    console.log("Main content 스크롤 애니메이션 설정 완료");
  }

  // donation 컨테이너 애니메이션
  const donationContainer = document.getElementById("donation-container");
  if (donationContainer) {
    observer.observe(donationContainer);
    console.log("Donation container 스크롤 애니메이션 설정 완료");
  }

  const donationFormContainer =
    document.getElementById("donation-container");
  if (!donationFormContainer) return;

  let donationData = {
    donationType: "",
    amount: "",
    selectedCategory: "",
  };

  const amountInput = document.getElementById("amountInput");
  const regularBtn = document.getElementById("regularBtn");
  const onetimeBtn = document.getElementById("onetimeBtn");
  const donationAmount = document.getElementById("donationAmount");
  const donationCategories =
    document.querySelectorAll(".donation-category");

  const validateStep1 = () => {
    const amountValue = amountInput.value.replace(/,/g, "");
    if (!donationData.donationType) {
      alert("기부 방식을 선택해주세요.");
      return false;
    }
    if (!amountValue || parseInt(amountValue) <= 0) {
      alert("기부 금액을 입력해주세요.");
      amountInput.focus();
      return false;
    }
    const selectedCategory = document.querySelector(
      ".donation-category.selected"
    );
    if (!selectedCategory) {
      alert("기부 참여 분야를 선택해주세요.");
      return false;
    }
    donationData.amount = amountValue;
    donationData.selectedCategory = selectedCategory.dataset.category;
    return true;
  };

  // 기부하기 페이지로 이동하는 함수
  window.goToDonation = function () {
    if (validateStep1()) {
      const amountInput = document.getElementById("amountInput");
      const selectedCategory = document.querySelector(
        ".donation-category.selected"
      );
      const donationType = document.querySelector(".donation-btn.active");

      const donationAmount = amountInput
        ? amountInput.value.replace(/,/g, "")
        : "";
      const category = selectedCategory
        ? selectedCategory.dataset.category
        : "";
      const type = donationType
        ? donationType.id === "regularBtn"
          ? "regular"
          : "onetime"
        : "";

      console.log(
        "Amount:",
        donationAmount,
        "Category:",
        category,
        "Type:",
        type
      );

      const params = new URLSearchParams();
      if (donationAmount) params.append("amount", donationAmount);
      if (category) params.append("category", category);
      if (type) params.append("type", type);

      const url =
        "/bdproject/project_Donation.jsp" +
        (params.toString() ? "?" + params.toString() : "");
      console.log("Generated URL:", url);
      window.location.href = url;
    }
  };

  if (donationAmount)
    donationAmount.addEventListener("change", (e) => {
      const selectedValue = e.target.value;
      if (selectedValue) {
        amountInput.value =
          parseInt(selectedValue).toLocaleString("ko-KR");
        amountInput.readOnly = true;
        amountInput.classList.add("disabled");
      } else {
        amountInput.value = "";
        amountInput.readOnly = false;
        amountInput.classList.remove("disabled");
        amountInput.focus();
      }
    });

  if (amountInput)
    amountInput.addEventListener("input", (e) => {
      let value = e.target.value.replace(/[^0-9]/g, "");
      e.target.value = value
        ? parseInt(value, 10).toLocaleString("ko-KR")
        : "";
    });

  if (regularBtn)
    regularBtn.addEventListener("click", () => {
      regularBtn.classList.add("active");
      onetimeBtn.classList.remove("active");
      donationData.donationType = "regular";
    });

  if (onetimeBtn)
    onetimeBtn.addEventListener("click", () => {
      onetimeBtn.classList.add("active");
      regularBtn.classList.remove("active");
      donationData.donationType = "onetime";
    });

  if (donationCategories.length > 0) {
    donationCategories.forEach((category) => {
      category.addEventListener("click", () => {
        if (category.classList.contains("selected")) {
          category.classList.remove("selected");
        } else {
          donationCategories.forEach((c) =>
            c.classList.remove("selected")
          );
          category.classList.add("selected");
        }
      });
    });
  }
});

// 사용자 아이콘 클릭 이벤트
document.addEventListener("DOMContentLoaded", function () {
  const userIcon = document.getElementById("userIcon");
  if (userIcon) {
    userIcon.addEventListener("click", function (e) {
      e.preventDefault();

      fetch("/bdproject/api/auth/check")
        .then(response => response.json())
        .then(data => {
          if (data.loggedIn) {
            window.location.href = "/bdproject/project_mypage.jsp";
          } else {
            window.location.href = "/bdproject/projectLogin.jsp";
          }
        })
        .catch(error => {
          console.error("로그인 상태 확인 오류:", error);
          window.location.href = "/bdproject/projectLogin.jsp";
        });
    });
  }
});

// 인기 복지 서비스 조회 함수
function loadPopularWelfareServices() {
  console.log("인기 복지 서비스 로딩 시작 (실시간 API)");
  const popularList = document.getElementById("popular-welfare-list");

  fetch("/bdproject/welfare/popular")
    .then((response) => {
      console.log("API 응답 상태:", response.status, response.statusText);
      if (!response.ok) {
        throw new Error("서버 응답 오류: " + response.status);
      }
      return response.json();
    })
    .then((data) => {
      console.log("받은 데이터:", data);
      displayPopularWelfareServices(data);
    })
    .catch((error) => {
      console.error("인기 복지 서비스 조회 오류:", error);
      popularList.innerHTML =
        '<div class="loading-popular">' +
        '<p style="color: #dc3545;">인기 복지 혜택을 불러올 수 없습니다.</p>' +
        '<p style="color: #666; font-size: 12px;">오류: ' +
        error.message +
        "</p>" +
        "</div>";
    });
}

// 슬라이더 상태 관리
let currentSlide = 0;
let totalSlides = 0;
let welfareServices = [];
const itemsPerSlide = 4;

// 인기 복지 서비스 표시 함수
function displayPopularWelfareServices(services) {
  console.log("displayPopularWelfareServices 호출됨, 데이터 개수:", services ? services.length : 0);
  const popularList = document.getElementById("popular-welfare-list");

  if (!services || services.length === 0) {
    popularList.innerHTML = '<div class="loading-popular"><p>표시할 복지 혜택이 없습니다.</p></div>';
    return;
  }

  welfareServices = services
    .sort((a, b) => {
      const aViews = parseInt(a.inqNum) || 0;
      const bViews = parseInt(b.inqNum) || 0;
      return bViews - aViews;
    })
    .slice(0, 12);

  console.log("정렬 후 서비스 개수:", welfareServices.length);

  popularList.innerHTML = "";
  popularList.className = "welfare-slider";
  totalSlides = Math.ceil(welfareServices.length / itemsPerSlide);

  welfareServices.forEach((service, index) => {
    const serviceName = service.servNm || "서비스명 없음";
    const jurMnofNm = service.jurMnofNm || "";
    const jurOrgNm = service.jurOrgNm || "";
    const viewCount = parseInt(service.inqNum) || 0;
    const rank = index + 1;

    const daysAgo = Math.floor(Math.random() * 30);
    const date = new Date();
    date.setDate(date.getDate() - daysAgo);
    const dateStr = date.getFullYear() + "." +
      String(date.getMonth() + 1).padStart(2, "0") + "." +
      String(date.getDate()).padStart(2, "0");

    const item = document.createElement("div");
    item.className = "popular-welfare-item";

    const formattedViews = viewCount >= 1000
      ? (viewCount / 1000).toFixed(1) + 'K'
      : viewCount.toLocaleString();

    item.innerHTML =
      '<div class="welfare-logo">' + rank + "</div>" +
      '<div class="welfare-name">' + serviceName + "</div>" +
      '<div class="welfare-org">' + (jurMnofNm + (jurOrgNm ? " " + jurOrgNm : "")) + "</div>" +
      '<div class="welfare-footer">' +
        '<div class="welfare-date">' +
          '<i class="far fa-calendar-alt"></i>' +
          dateStr +
        '</div>' +
        '<div class="welfare-views-badge">' +
          '<i class="far fa-eye"></i>' +
          formattedViews +
        '</div>' +
      '</div>';

    item.addEventListener("click", () => {
      if (service.servDtlLink) {
        window.open(service.servDtlLink, "_blank");
      } else {
        alert("해당 서비스의 상세 정보가 없습니다.");
      }
    });

    popularList.appendChild(item);
  });

  console.log("카드 생성 완료");

  createSliderIndicators();

  currentSlide = 0;
  updateSlider();
  updateNavigationButtons();
}

// 슬라이더 인디케이터 생성
function createSliderIndicators() {
  const indicatorsContainer = document.getElementById("sliderIndicators");
  if (!indicatorsContainer) return;

  indicatorsContainer.innerHTML = "";

  for (let i = 0; i < totalSlides; i++) {
    const indicator = document.createElement("div");
    indicator.className = "slider-indicator" + (i === 0 ? " active" : "");
    indicator.onclick = function() { goToSlide(i); };
    indicatorsContainer.appendChild(indicator);
  }
}

// 슬라이드 이동
function moveSlide(direction) {
  currentSlide += direction;
  if (currentSlide < 0) currentSlide = 0;
  if (currentSlide >= totalSlides) currentSlide = totalSlides - 1;

  updateSlider();
  updateNavigationButtons();
  updateIndicators();
}

// 특정 슬라이드로 이동
function goToSlide(index) {
  currentSlide = index;
  updateSlider();
  updateNavigationButtons();
  updateIndicators();
}

// 슬라이더 위치 업데이트
function updateSlider() {
  const slider = document.getElementById("popular-welfare-list");
  if (!slider) return;

  const offset = currentSlide * 100;
  slider.style.transform = "translateX(-" + offset + "%)";
  console.log("슬라이더 이동:", currentSlide, "offset:", offset);
}

// 네비게이션 버튼 상태 업데이트
function updateNavigationButtons() {
  const prevBtn = document.getElementById("prevBtn");
  const nextBtn = document.getElementById("nextBtn");

  if (prevBtn && nextBtn) {
    prevBtn.disabled = currentSlide === 0;
    nextBtn.disabled = currentSlide === totalSlides - 1;
  }
}

// 인디케이터 상태 업데이트
function updateIndicators() {
  const indicators = document.querySelectorAll(".slider-indicator");
  indicators.forEach((indicator, index) => {
    if (index === currentSlide) {
      indicator.classList.add("active");
    } else {
      indicator.classList.remove("active");
    }
  });
}
