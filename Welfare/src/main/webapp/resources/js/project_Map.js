// 전역 변수
var map;
var centerMarker;
var geocoder; // SDK 로드 후 초기화
var markers = [],
  infowindows = [];
var userGpsPosition,
  radiusCircle,
  currentRadius = 1;
var allFacilities = [];
var cachedFacilityTypes = null; // 시설 종류 캐싱
var Gwanghwamun; // SDK 로드 후 초기화

// 마지막 검색 파라미터 저장 (재시도용)
var lastSearchParams = { facilityCode: null, searchTerm: "", position: null };

// 컨텍스트 경로 (JSP에서 전역 변수로 정의됨)

// ============== 페이지 로드 시 실행되는 메인 함수 ==============
window.onload = async function () {
  console.log("페이지 로드 완료. 초기화를 시작합니다.");

  // 광화문 좌표 초기화 (SDK 로드 후, initMap 호출 전에 필요)
  Gwanghwamun = new kakao.maps.LatLng(37.5759, 126.9768);

  initMap();

  // 광화문을 기본 중심으로 설정 (검색은 버튼 생성 후)
  userGpsPosition = Gwanghwamun;
  centerMarker.setPosition(Gwanghwamun);
  document.querySelector(".radius-slider-container").style.display = "flex";
  drawRadiusCircle();

  try {
    // 1. API를 통해 시설 종류 데이터를 가져옵니다.
    const facilityTypes = await fetchFacilityTypes();
    // 2. 가져온 데이터로 시설 종류 버튼들을 화면에 생성합니다.
    populateFacilityButtons(facilityTypes);
    // 3. 생성된 버튼들과 다른 UI 요소들에 이벤트 핸들러를 연결합니다.
    setupButtonInteractions();
    // 4. 첫 번째 시설 버튼을 자동 클릭하여 시설 표시
    const firstFacilityButton = document.querySelector(".facility-options button");
    if (firstFacilityButton) {
      firstFacilityButton.click();
    }
  } catch (error) {
    console.error("페이지 초기화 중 심각한 오류 발생:", error);
    document.querySelector(".facility-options").innerHTML =
      "<p>시설 종류를 불러오는 데 실패했습니다.</p>";
    setupButtonInteractions();
  }
};

// ============== [카카오 방식] 시설 종류를 직접 정의 ==============
async function fetchFacilityTypes() {
  // 캐시된 데이터가 있으면 바로 반환
  if (cachedFacilityTypes) {
    return cachedFacilityTypes;
  }

  console.log("시설 종류 데이터 로드 (카카오 검색 키워드 기반)");

  // 카카오 Places API로 검색할 복지시설 키워드 목록
  cachedFacilityTypes = [
    { fcltKindCd: "01", fcltKindNm: "노인복지시설", keyword: "노인복지" },
    { fcltKindCd: "02", fcltKindNm: "장애인복지시설", keyword: "장애인복지" },
    { fcltKindCd: "03", fcltKindNm: "아동복지시설", keyword: "어린이집" },
    { fcltKindCd: "04", fcltKindNm: "여성복지시설", keyword: "여성복지" },
    { fcltKindCd: "05", fcltKindNm: "지역아동센터", keyword: "지역아동센터" },
    { fcltKindCd: "06", fcltKindNm: "사회복지관", keyword: "사회복지관" },
    { fcltKindCd: "07", fcltKindNm: "노숙인복지시설", keyword: "노숙인" },
    { fcltKindCd: "08", fcltKindNm: "정신건강복지센터", keyword: "정신건강" },
    { fcltKindCd: "09", fcltKindNm: "보건소", keyword: "보건소" },
    { fcltKindCd: "10", fcltKindNm: "주민센터", keyword: "주민센터" }
  ];
  return cachedFacilityTypes;
}

// ============== API 데이터로 버튼을 동적으로 생성하는 함수 (중복 제거 버전) ==============
function populateFacilityButtons(types) {
  const container = document.querySelector(".facility-options");
  container.innerHTML = ""; // 기존 버튼들 초기화

  if (!types || types.length === 0) {
    container.innerHTML = "<p>시설 종류 정보가 없습니다.</p>";
    return;
  }

  // Set을 사용하여 중복된 시설 종류 제거
  const uniqueTypes = new Map(); // Map을 사용하여 코드를 키로 하여 중복 제거

  types.forEach((type) => {
    if (type.fcltKindCd && type.fcltKindNm) {
      // 유효한 데이터만 처리
      // 이미 같은 코드가 있는지 확인하여 중복 제거
      if (!uniqueTypes.has(type.fcltKindCd)) {
        uniqueTypes.set(type.fcltKindCd, type.fcltKindNm);
      }
    }
  });

  // Map에서 고유한 값들만 버튼으로 생성
  uniqueTypes.forEach((fcltKindNm, fcltKindCd) => {
    const button = document.createElement("button");
    button.dataset.code = fcltKindCd;
    button.textContent = fcltKindNm;
    button.classList.add("facility-btn"); // 스타일링을 위한 클래스 추가
    container.appendChild(button);
  });

  // "전체 복지시설" 버튼은 항상 필요하므로 마지막에 직접 추가
  const allButton = document.createElement("button");
  allButton.dataset.code = "ALL";
  allButton.textContent = "전체 복지시설";
  allButton.classList.add("facility-btn", "all-btn"); // 전체 버튼 구분을 위한 클래스
  container.appendChild(allButton);
}

function initMap() {
  const container = document.getElementById("map");
  const options = { center: Gwanghwamun, level: 6 };
  map = new kakao.maps.Map(container, options);
  map.addControl(
    new kakao.maps.ZoomControl(),
    kakao.maps.ControlPosition.RIGHT
  );

  // Geocoder 초기화 (SDK 로드 후)
  geocoder = new kakao.maps.services.Geocoder();

  centerMarker = new kakao.maps.Marker({
    position: map.getCenter(),
    image: new kakao.maps.MarkerImage(
      "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png",
      new kakao.maps.Size(24, 35)
    ),
  });
  centerMarker.setMap(map);

  kakao.maps.event.addListener(map, "click", function (mouseEvent) {
    updateCenter(mouseEvent.latLng, false);
  });

  document
    .getElementById("recenter-btn")
    .addEventListener("click", () => {
      const targetPosition = userGpsPosition || Gwanghwamun;
      updateCenter(targetPosition, !!userGpsPosition);
    });
}

function updateCenter(position, isGps) {
  map.setCenter(position); // 즉시 이동 (panTo는 애니메이션으로 지연 발생)
  centerMarker.setPosition(position);

  // 항상 위치를 업데이트하고 반경 원 표시
  userGpsPosition = position;
  document.querySelector(".radius-slider-container").style.display = "flex";
  drawRadiusCircle();

  // 활성화된 시설 버튼이 있으면 자동으로 검색 (클릭 위치 직접 전달)
  const activeButton = document.querySelector(
    ".facility-options button.active"
  );
  if (activeButton) {
    console.log("지도 중심 변경 → 자동 검색 실행:", activeButton.textContent);
    searchFacilities(activeButton.dataset.code, "", position);
  }
}

function tryGetCurrentLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        const gpsPosition = new kakao.maps.LatLng( // 좌표 카카오 지도 전용 객체에 전달
          position.coords.latitude, //위도 획득
          position.coords.longitude //경도 획득
        );
        updateCenter(gpsPosition, true);
        document
          .getElementById("current-location-btn")
          .classList.add("active");

        const firstFacilityButton = document.querySelector(
          ".facility-options button"
        );
        if (firstFacilityButton) {
          firstFacilityButton.click();
        }
      },
      () => {
        console.warn(
          "GPS를 찾을 수 없어 기본 위치(광화문)에서 시작합니다."
        );
        const firstFacilityButton = document.querySelector(
          ".facility-options button"
        );
        if (firstFacilityButton) {
          firstFacilityButton.click();
        }
      }
    );
  } else {
    const firstFacilityButton = document.querySelector(
      ".facility-options button"
    );
    if (firstFacilityButton) {
      firstFacilityButton.click();
    }
  }
}

function drawRadiusCircle() {
  if (radiusCircle) radiusCircle.setMap(null);
  const center = userGpsPosition;
  if (center) {
    radiusCircle = new kakao.maps.Circle({
      center,
      radius: currentRadius * 1000,
      strokeWeight: 2,
      strokeColor: "#4A90E2",
      strokeOpacity: 0.8,
      strokeStyle: "solid",
      fillColor: "#4A90E2",
      fillOpacity: 0.1,
    });
    radiusCircle.setMap(map);
  }
}

// getDistance 함수 삭제 - 카카오 API의 distance 필드 사용

function adjustMapLevel(radius) {
  let level;
  if (radius <= 0.5) level = 4;
  else if (radius <= 1) level = 5;
  else if (radius <= 2) level = 5;
  else if (radius <= 3) level = 6;
  else if (radius <= 4) level = 6;
  else level = 7;
  map.setLevel(level);
}


// ============== [카카오 방식] 카카오 Places API로 직접 검색 (페이지네이션 지원) ==============
function searchFacilities(facilityCode, searchTerm = "", customPosition = null) {
  const searchPosition = customPosition || map.getCenter(); // 전달된 위치 우선 사용

  // 재시도를 위해 검색 파라미터 저장
  lastSearchParams = { facilityCode, searchTerm, position: searchPosition };

  // [수정] 검색 시작 시 기존 마커와 정보창 즉시 제거
  clearMap();
  document.querySelector(".results-list").innerHTML = `
    <li class="loading-container">
      <div class="spinner"></div>
      <span class="loading-text">주변 시설을 검색하고 있습니다...</span>
    </li>
  `;

  // 선택된 시설 종류의 검색 키워드 찾기
  fetchFacilityTypes().then(facilityTypes => {
    const selectedType = facilityTypes.find(t => t.fcltKindCd === facilityCode);
    const keyword = searchTerm || (selectedType ? selectedType.keyword : "복지");

    console.log("=== 카카오 Places API 검색 시작 ===");
    console.log("키워드:", keyword, "| 위치:", searchPosition.getLat().toFixed(4), searchPosition.getLng().toFixed(4), "| 반경:", currentRadius + "km");

    // 카카오 Places 서비스 생성
    const ps = new kakao.maps.services.Places();

    // 검색 옵션 설정
    const options = {
      location: searchPosition,
      radius: currentRadius * 1000, // km를 m로 변환
      size: 15 // 페이지당 15개
    };

    const centerLat = searchPosition.getLat();
    const centerLng = searchPosition.getLng();
    let allResults = [];

    // 반복 호출 (최대 100개)
    function fetchAllPages(pageNum) {
      ps.keywordSearch(keyword, function(data, status, pagination) {
        if (status === kakao.maps.services.Status.OK) {
          console.log(`${pageNum}페이지 검색 성공: ${data.length}개 시설 (누적: ${allResults.length + data.length}개)`);

          // 반복 호출 (최대 100개)
          allResults = allResults.concat(data);

          // 100개 미만이며 다음 페이지가 있으면 가져오기
          if (allResults.length < 100 && pagination.hasNextPage) {
            setTimeout(() => {
              pagination.nextPage();
              fetchAllPages(pageNum + 1); // 다음 페이지 호출
            }, 50);
          } else {
            // 수집 완료
            if (allResults.length >= 100) {
              allResults = allResults.slice(0, 100); // 정확히 100개만
              console.log(`최대 100개 제한 도달 (${pageNum}페이지)`);
            } else {
              console.log(`총 ${allResults.length}개 시설 데이터 수집 완료 (${pageNum}페이지)`);
            }
            processSearchResults(allResults, centerLat, centerLng, selectedType);
          }
        } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
          if (pageNum === 1) {
            console.log("검색 결과 없음");
            document.querySelector(".results-list").innerHTML =
              `<li>반경 ${currentRadius}km 내에 "${keyword}" 검색 결과가 없습니다.</li>`;
            allFacilities = [];
            clearMap();
          } else {
            // 중간 페이지에서 결과 없으면 현재까지 수집한 데이터 처리
            console.log(`총 ${allResults.length}개 시설 데이터 수집 완료 (${pageNum-1}페이지)`);
            processSearchResults(allResults, centerLat, centerLng, selectedType);
          }
        } else {
          console.error("카카오 검색 실패:", status);
          if (allResults.length > 0) {
            // 이미 수집한 데이터라도 표시
            console.log(`일부 데이터만 표시: ${allResults.length}개`);
            processSearchResults(allResults, centerLat, centerLng, selectedType);
          } else {
            // 에러 메시지와 재시도 버튼 표시
            showErrorWithRetry("검색 중 오류가 발생했습니다.");
          }
        }
      }, options);
    }

    // 첫 페이지부터 시작
    fetchAllPages(1);
  });
}

// 검색 결과 처리 함수
function processSearchResults(data, centerLat, centerLng, selectedType) {
  if (data.length === 0) return;

  console.log(`총 ${data.length}개 시설 데이터 처리 시작`);

  // 카카오 데이터를 우리 포맷으로 변환 (카카오 API의 distance 필드 사용)
  allFacilities = data.map(place => {
    const lat = parseFloat(place.y);
    const lng = parseFloat(place.x);

    // 거리 변환
    const distanceKm = place.distance ? parseInt(place.distance) / 1000 : 0;

    return {
      fcltNm: place.place_name,
      fcltAddr: place.road_address_name || place.address_name,
      fcltTelNo: place.phone || "전화번호 없음",
      fcltKindNm: selectedType ? selectedType.fcltKindNm : "복지시설",
      fcltCd: place.id,
      lat: lat,
      lng: lng,
      distance: distanceKm, // 카카오 API 거리 (km)
      distanceDisplay: distanceKm.toFixed(2), // 표시용 거리 (소수점 2자리)
      kakaoAddr: place.road_address_name || place.address_name,
      kakaoPhone: place.phone
    };
  });

  // 거리순 정렬
  allFacilities.sort((a, b) => a.distance - b.distance);

  console.log(`✅ 반경 ${currentRadius}km 내 시설: ${allFacilities.length}개 표시`);

  // 결과 표시
  updateResultListAndMarkers(allFacilities);
}


function updateResultListAndMarkers(facilities) {
  clearMap();
  const resultList = document.querySelector(".results-list");
  const resultHeader = document.querySelector(".results-header strong");
  const radiusInfo = document.getElementById("radius-info");

  resultList.innerHTML = "";
  resultHeader.textContent = facilities.length + "건";
  radiusInfo.style.display = userGpsPosition ? "inline" : "none";
  if (userGpsPosition) {
    radiusInfo.textContent = `(반경 ${currentRadius}km 내)`;
  }

  if (facilities.length === 0) {
    resultList.innerHTML = userGpsPosition
      ? `<li>반경 ${currentRadius}km 내에 검색 결과가 없습니다.</li>`
      : `<li>검색 결과가 없습니다.</li>`;
    return;
  }

  facilities.forEach((facility) => {
    // 카카오 API distance 기준으로 이미 필터링됨 (이중 검증 제거)
    const coords = new kakao.maps.LatLng(facility.lat, facility.lng);
    const marker = new kakao.maps.Marker({ map, position: coords });

    const displayAddr = facility.kakaoAddr || facility.fcltAddr || "주소 정보 없음";
    const displayPhone = facility.kakaoPhone || facility.fcltTelNo || "전화번호 없음";

    let infoContent = '<div style="padding:14px 16px; min-width:240px; max-width:300px; background:#fff; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.12);">';
    infoContent += '<strong style="font-size:14px; color:#111; display:block; margin-bottom:10px;">' + facility.fcltNm + '</strong>';
    infoContent += '<div style="font-size:12px; color:#333; line-height:1.7;">';
    infoContent += '<div style="margin-bottom:6px;"><i class="fas fa-map-marker-alt" style="color:#111; width:14px; margin-right:8px;"></i>' + displayAddr + '</div>';
    infoContent += '<div style="margin-bottom:6px;"><i class="fas fa-phone-alt" style="color:#111; width:14px; margin-right:8px;"></i>' + displayPhone + '</div>';
    if (facility.distanceDisplay) {
      infoContent += '<div><i class="fas fa-route" style="color:#111; width:14px; margin-right:8px;"></i>거리: ' + facility.distanceDisplay + 'km</div>';
    }
    infoContent += '</div></div>';

    const infowindow = new kakao.maps.InfoWindow({
      content: infoContent,
      removable: true
    });

    markers.push(marker);
    infowindows.push(infowindow);

    // 마커 클릭 시 정보창 표시
    kakao.maps.event.addListener(marker, 'click', function() {
      // 다른 정보창 모두 닫기
      infowindows.forEach(iw => iw.close());
      // 클릭한 정보창 열기
      infowindow.open(map, marker);
    });

    const listItem = document.createElement("li");
    listItem.className = "result-item";
    let distanceHTML = userGpsPosition
      ? `<p style="color: #4A90E2; font-weight: 500;">거리: ${facility.distanceDisplay}km</p>`
      : "";

    listItem.innerHTML = `
                <h3>${facility.fcltNm}</h3>
                <p>${displayAddr}</p>
                <p>${displayPhone}</p>
                <p style="color: #666; font-size: 12px;">종류: ${facility.fcltKindNm}</p>
                ${distanceHTML}
            `;

    listItem.addEventListener("mouseover", () =>
      infowindow.open(map, marker)
    );
    listItem.addEventListener("mouseout", () => infowindow.close());
    listItem.addEventListener("click", () => map.panTo(coords));

    resultList.appendChild(listItem);
  });
}

function clearMap() {
  markers.forEach((m) => m.setMap(null));
  infowindows.forEach((i) => i.close());
  markers = [];
  infowindows = [];
}

// 에러 메시지와 재시도 버튼 표시 함수
function showErrorWithRetry(message) {
  const resultList = document.querySelector(".results-list");
  resultList.innerHTML = `
    <li class="error-container">
      <p class="error-message">${message}</p>
      <button class="retry-btn" onclick="retryLastSearch()">다시 시도</button>
    </li>
  `;
}

// 마지막 검색 재시도 함수
function retryLastSearch() {
  if (lastSearchParams.facilityCode) {
    console.log("검색 재시도:", lastSearchParams);
    searchFacilities(
      lastSearchParams.facilityCode,
      lastSearchParams.searchTerm,
      lastSearchParams.position
    );
  } else {
    console.warn("재시도할 검색 정보가 없습니다.");
    // 첫 번째 시설 버튼으로 검색 시도
    const firstFacilityButton = document.querySelector(".facility-options button");
    if (firstFacilityButton) {
      firstFacilityButton.click();
    }
  }
}

// 디바운스 함수 (API 호출 최적화)
let searchDebounceTimer = null;
function debounceSearch(callback, delay = 300) {
  if (searchDebounceTimer) clearTimeout(searchDebounceTimer);
  searchDebounceTimer = setTimeout(callback, delay);
}

function setupButtonInteractions() {
  const locationButtons = document.querySelectorAll(
    ".location-options button"
  );
  const facilityOptionsContainer =
    document.querySelector(".facility-options");
  const radiusSlider = document.getElementById("radius-slider");
  const radiusValueDisplay = document.getElementById("radius-value");
  const searchForm = document.querySelector(".search-form");
  const searchInput = document.querySelector(".search-form input");

  document
    .getElementById("current-location-btn")
    .addEventListener("click", function () {
      locationButtons.forEach((btn) => btn.classList.remove("active"));
      this.classList.add("active");
      tryGetCurrentLocation();
    });

  document
    .getElementById("address-search-btn")
    .addEventListener("click", () => {
      new daum.Postcode({
        oncomplete: function (data) {
          geocoder.addressSearch(data.address, function (result, status) {
            if (status === kakao.maps.services.Status.OK) {
              updateCenter(
                new kakao.maps.LatLng(result[0].y, result[0].x),
                false
              );
            }
          });
        },
      }).open();
    });

  // 슬라이더 트랙 채움 업데이트 함수
  function updateSliderFill() {
    const min = parseFloat(radiusSlider.min);
    const max = parseFloat(radiusSlider.max);
    const val = parseFloat(radiusSlider.value);
    const percentage = ((val - min) / (max - min)) * 100;
    radiusSlider.style.background = `linear-gradient(to right, #4a90e2 0%, #4a90e2 ${percentage}%, #ddd ${percentage}%, #ddd 100%)`;
  }

  // 초기 슬라이더 채움 설정
  updateSliderFill();

  // 슬라이더 실시간 업데이트 (드래그 중 - 원만 변경)
  radiusSlider.addEventListener("input", function () {
    currentRadius = parseFloat(this.value);
    radiusValueDisplay.textContent = currentRadius.toFixed(1) + "km";
    updateSliderFill();

    // 실시간으로 원 크기 변경
    if (userGpsPosition) {
      drawRadiusCircle();
      adjustMapLevel(currentRadius);
    }
  });

  // 슬라이더 변경 완료 (드래그 끝 - API 호출)
  radiusSlider.addEventListener("change", function () {
    currentRadius = parseFloat(this.value);

    // 반경 변경 완료 시 시설 재검색
    debounceSearch(() => {
      const activeButton = document.querySelector(".facility-options button.active");
      if (activeButton) {
        searchFacilities(activeButton.dataset.code);
      }
    }, 200);
  });

  facilityOptionsContainer.addEventListener("click", (e) => {
    if (e.target.tagName === "BUTTON") {
      facilityOptionsContainer
        .querySelectorAll("button")
        .forEach((btn) => btn.classList.remove("active"));
      e.target.classList.add("active");

      const facilityCode = e.target.dataset.code;
      const searchTerm = searchInput.value.trim();
      searchFacilities(facilityCode, searchTerm);
    }
  });

  searchForm.addEventListener("submit", (e) => {
    e.preventDefault();
    const activeButton = document.querySelector(
      ".facility-options button.active"
    );
    if (!activeButton) {
      alert("먼저 시설 종류를 선택해주세요.");
      return;
    }
    const searchTerm = searchInput.value.trim();
    searchFacilities(activeButton.dataset.code, searchTerm);
  });

  // 네비바 메가메뉴 이벤트
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

  // 언어 드롭다운 이벤트
  const globeIcon = document.getElementById('languageToggle');
  const languageDropdown = document.getElementById('languageDropdown');

  if (globeIcon && languageDropdown) {
    globeIcon.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();

      const isVisible = languageDropdown.style.display === 'block';

      if (isVisible) {
        languageDropdown.style.opacity = '0';
        languageDropdown.style.visibility = 'hidden';
        languageDropdown.style.transform = 'translateY(-10px)';
        setTimeout(() => {
          languageDropdown.style.display = 'none';
        }, 200);
      } else {
        languageDropdown.style.display = 'block';
        setTimeout(() => {
          languageDropdown.style.opacity = '1';
          languageDropdown.style.visibility = 'visible';
          languageDropdown.style.transform = 'translateY(0)';
        }, 10);
      }
    });

    const languageOptions = languageDropdown.querySelectorAll('.language-option');
    languageOptions.forEach(option => {
      option.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        const selectedLang = this.getAttribute('data-lang');
        console.log('선택된 언어:', selectedLang);

        languageOptions.forEach(opt => opt.classList.remove('active'));
        this.classList.add('active');

        languageDropdown.style.opacity = '0';
        languageDropdown.style.visibility = 'hidden';
        languageDropdown.style.transform = 'translateY(-10px)';
        setTimeout(() => {
          languageDropdown.style.display = 'none';
        }, 200);
      });
    });

    document.addEventListener('click', function(e) {
      if (!globeIcon.contains(e.target) && !languageDropdown.contains(e.target)) {
        if (languageDropdown.style.display === 'block') {
          languageDropdown.style.opacity = '0';
          languageDropdown.style.visibility = 'hidden';
          languageDropdown.style.transform = 'translateY(-10px)';
          setTimeout(() => {
            languageDropdown.style.display = 'none';
          }, 200);
        }
      }
    });
  }

  // 사용자 아이콘 클릭 이벤트
  const userIcon = document.getElementById('userIcon');
  if (userIcon) {
    userIcon.addEventListener('click', function() {
      window.location.href = CONTEXT_PATH + '/projectLogin.jsp';
    });
  }
}
