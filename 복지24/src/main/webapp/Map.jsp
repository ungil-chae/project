<%-- [수정] isELIgnored="true" 속성을 추가하여 ${} 문법 충돌을 방지합니다. --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" isELIgnored="false"%>
<%
    String kakaoApiKey = application.getInitParameter("kakaoApiKey");
%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>복지 기관 지도</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }
      body {
        background-color: #fafafa;
        color: #191918;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
          sans-serif;
        display: flex;
        flex-direction: column;
        height: 100vh;
      }
      #main-header {
        position: sticky;
        top: 0;
        z-index: 1000;
        background-color: white;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
      }
      .navbar {
        background-color: transparent;
        padding: 0 40px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        height: 60px;
      }
      .navbar-left {
        flex-shrink: 0;
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
        background-image: url("resources/image/복지로고.png");
        background-size: contain;
        background-repeat: no-repeat;
        background-position: center;
      }
      .logo-text {
        font-size: 24px;
        font-weight: 700;
        color: #333;
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
      .main-content {
        position: relative;
        display: flex;
        flex-grow: 1;
        overflow: hidden;
      }
      .info-panel {
        width: 380px;
        background-color: #fff;
        padding: 25px;
        border-right: 1px solid #e0e0e0;
        display: flex;
        flex-direction: column;
        overflow-y: auto;
        z-index: 10;
      }
      .info-title {
        font-size: 28px;
        font-weight: bold;
        margin-bottom: 20px;
      }
      .location-options {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 10px;
        padding-bottom: 15px;
        margin-bottom: 15px;
        border-bottom: 1px solid #000;
      }
      .radius-options {
        display: flex;
        gap: 8px;
        margin-bottom: 15px;
      }
      .radius-btn {
        flex: 1;
        background-color: white;
        color: #666;
        border: 1px solid #ddd;
        border-radius: 6px;
        padding: 8px;
        font-size: 13px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s;
      }
      .radius-btn:hover {
        border-color: #4a90e2;
      }
      .radius-btn.active {
        background-color: #4a90e2;
        color: white;
        border-color: #4a90e2;
      }
      .facility-options {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 10px;
        margin-bottom: 15px;
      }
      .location-options button,
      .facility-options button {
        background-color: #fff;
        color: #4a90e2;
        border: 1px solid #4a90e2;
        border-radius: 8px;
        padding: 12px;
        font-size: 15px;
        font-weight: 500;
        cursor: pointer;
        transition: background-color 0.3s, color 0.3s, opacity 0.3s;
      }
      .location-options button:hover,
      .facility-options button:hover {
        background-color: #4a90e2;
        color: white;
      }
      .location-options button.active,
      .facility-options button.active {
        background-color: #4a90e2;
        color: white;
      }
      .search-form {
        display: flex;
        gap: 10px;
        margin-bottom: 20px;
      }
      .search-form input {
        flex-grow: 1;
        border: 1px solid #ccc;
        border-radius: 8px;
        padding: 10px;
        font-size: 14px;
      }
      .search-form button {
        background-color: #4a90e2;
        color: white;
        border: none;
        border-radius: 8px;
        padding: 0 20px;
        font-weight: 500;
        cursor: pointer;
        transition: background-color 0.2s;
      }
      .results-header {
        padding: 10px;
        background-color: #f8f9fa;
        border-radius: 6px;
        margin-bottom: 15px;
        font-size: 14px;
      }
      .results-list {
        list-style: none;
        flex-grow: 1;
        overflow-y: auto;
      }
      .result-item {
        padding: 15px;
        border-bottom: 1px solid #eee;
        cursor: pointer;
        transition: background-color 0.2s;
      }
      .result-item:hover {
        background-color: #f8f9fa;
      }
      .result-item h3 {
        font-size: 16px;
        margin-bottom: 5px;
        color: #333;
      }
      .result-item p {
        font-size: 13px;
        color: #666;
        margin: 2px 0;
      }
      #map {
        flex-grow: 1;
        height: 100%;
      }
      #recenter-btn {
        position: absolute;
        bottom: 30px;
        right: 30px;
        width: 48px;
        height: 48px;
        background-color: white;
        border: 2px solid #4A90E2;
        border-radius: 50%;
        cursor: pointer;
        box-shadow: 0 3px 8px rgba(0, 0, 0, 0.2);
        z-index: 20;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s ease;
      }
      #recenter-btn:hover {
        background-color: #4A90E2;
        transform: scale(1.05);
      }
      #recenter-btn:hover svg {
        fill: white;
      }
      #recenter-btn svg {
        width: 24px;
        height: 24px;
        fill: #4A90E2;
        transition: fill 0.2s ease;
      }
      .loading {
        text-align: center;
        padding: 20px;
        color: #666;
      }
    </style>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  </head>
  <body>
    <%@ include file="navbar.jsp" %>

    <div class="main-content">
      <div class="info-panel">
        <h1 class="info-title">복지 시설 지도</h1>
        <div class="location-options">
          <button id="current-location-btn">현위치</button>
          <button id="address-search-btn">주소검색</button>
        </div>

        <div class="radius-options" style="display: flex">
          <button class="radius-btn active" data-radius="1">1km</button>
          <button class="radius-btn" data-radius="3">3km</button>
          <button class="radius-btn" data-radius="5">5km</button>
        </div>

        <div class="facility-options"></div>

        <form class="search-form">
          <input type="text" placeholder="시설 이름으로 검색" />
          <button type="submit">검색</button>
        </form>

        <div class="results-header">
          검색 결과 총 <strong>0건</strong>
          <span
            id="radius-info"
            style="margin-left: 10px; color: #4a90e2"
          ></span>
        </div>
        <ul class="results-list"></ul>
      </div>

      <div id="map"></div>
      <button id="recenter-btn" title="현위치로 복귀">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
          <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
        </svg>
      </button>
    </div>

    <script
      type="text/javascript"
      src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=<%= kakaoApiKey %>&libraries=services"
    ></script>
    <script>
      // 전역 변수
      var map;
      var centerMarker;
      var geocoder = new kakao.maps.services.Geocoder();
      var markers = [],
        infowindows = [];
      var userGpsPosition,
        radiusCircle,
        currentRadius = 1;
      var allFacilities = [];
      const Gwanghwamun = new kakao.maps.LatLng(37.5759, 126.9768); // 광화문 좌표

      // 컨텍스트 경로
      const CONTEXT_PATH = "${pageContext.request.contextPath}";

      // ============== 페이지 로드 시 실행되는 메인 함수 ==============
      window.onload = async function () {
        console.log("페이지 로드 완료. 초기화를 시작합니다.");

        initMap();

        // 광화문을 기본 중심으로 설정 (검색은 버튼 생성 후)
        userGpsPosition = Gwanghwamun;
        map.setCenter(Gwanghwamun);
        centerMarker.setPosition(Gwanghwamun);
        document.querySelector(".radius-options").style.display = "flex";
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
        console.log("시설 종류 데이터 로드 (카카오 검색 키워드 기반)");

        // 카카오 Places API로 검색할 복지시설 키워드 목록
        return [
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
        map.panTo(position);
        centerMarker.setPosition(position);

        // 항상 위치를 업데이트하고 반경 원 표시
        userGpsPosition = position;
        document.querySelector(".radius-options").style.display = "flex";
        drawRadiusCircle();

        // 활성화된 시설 버튼이 있으면 자동으로 검색
        const activeButton = document.querySelector(
          ".facility-options button.active"
        );
        if (activeButton) {
          console.log("지도 중심 변경 → 자동 검색 실행:", activeButton.textContent);
          searchFacilities(activeButton.dataset.code);
        }
      }

      function tryGetCurrentLocation() {
        if (navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(
            (position) => {
              const gpsPosition = new kakao.maps.LatLng(
                position.coords.latitude,
                position.coords.longitude
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
                "GPS를 찾을 수 없어 기본 위치(경복궁)에서 시작합니다."
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

      function getDistance(lat1, lng1, lat2, lng2) {
        const R = 6371; // 지구 반지름 (km)
        const dLat = ((lat2 - lat1) * Math.PI) / 180;
        const dLng = ((lng2 - lng1) * Math.PI) / 180;
        const a =
          Math.sin(dLat / 2) * Math.sin(dLat / 2) +
          Math.cos((lat1 * Math.PI) / 180) *
            Math.cos((lat2 * Math.PI) / 180) *
            Math.sin(dLng / 2) *
            Math.sin(dLng / 2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        // 반올림 전 정확한 거리 반환 후 필터링 시점에 비교
        return R * c;
      }

      function adjustMapLevel(radius) {
        let level;
        if (radius <= 1) level = 5;
        else if (radius <= 3) level = 6;
        else if (radius <= 5) level = 7;
        else level = 8;
        map.setLevel(level);
      }


      // ============== [카카오 방식] 카카오 Places API로 직접 검색 (페이지네이션 지원) ==============
      function searchFacilities(facilityCode, searchTerm = "") {
        const searchPosition = map.getCenter();
        document.querySelector(".results-list").innerHTML = '<li class="loading">검색 중...</li>';

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

          // 재귀적으로 페이지 가져오기 (최대 100개)
          function fetchAllPages(pageNum) {
            ps.keywordSearch(keyword, function(data, status, pagination) {
              if (status === kakao.maps.services.Status.OK) {
                console.log(`${pageNum}페이지 검색 성공: ${data.length}개 시설 (누적: ${allResults.length + data.length}개)`);
                allResults = allResults.concat(data);

                // 100개 미만이고 다음 페이지가 있으면 계속 가져오기
                if (allResults.length < 100 && pagination.hasNextPage) {
                  setTimeout(() => {
                    pagination.nextPage();
                    fetchAllPages(pageNum + 1);
                  }, 50);
                } else {
                  // 수집 완료 (100개 도달 또는 더 이상 페이지 없음)
                  if (allResults.length >= 100) {
                    allResults = allResults.slice(0, 100); // 정확히 100개만
                    console.log(`✅ 최대 100개 제한 도달 (${pageNum}페이지)`);
                  } else {
                    console.log(`✅ 총 ${allResults.length}개 시설 데이터 수집 완료 (${pageNum}페이지)`);
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
                  console.log(`✅ 총 ${allResults.length}개 시설 데이터 수집 완료 (${pageNum-1}페이지)`);
                  processSearchResults(allResults, centerLat, centerLng, selectedType);
                }
              } else {
                console.error("카카오 검색 실패:", status);
                if (allResults.length > 0) {
                  // 이미 수집한 데이터라도 표시
                  console.log(`일부 데이터만 표시: ${allResults.length}개`);
                  processSearchResults(allResults, centerLat, centerLng, selectedType);
                } else {
                  document.querySelector(".results-list").innerHTML =
                    "<li>검색 중 오류가 발생했습니다. 다시 시도해주세요.</li>";
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

        // 카카오 데이터를 우리 포맷으로 변환
        allFacilities = data.map(place => {
          const lat = parseFloat(place.y);
          const lng = parseFloat(place.x);
          const distance = getDistance(centerLat, centerLng, lat, lng);

          return {
            fcltNm: place.place_name,
            fcltAddr: place.road_address_name || place.address_name,
            fcltTelNo: place.phone || "전화번호 없음",
            fcltKindNm: selectedType ? selectedType.fcltKindNm : "복지시설",
            fcltCd: place.id,
            lat: lat,
            lng: lng,
            distance: distance, // 정확한 거리 (소수점)
            distanceDisplay: distance.toFixed(2), // 표시용 거리 (소수점 2자리)
            kakaoAddr: place.road_address_name || place.address_name,
            kakaoPhone: place.phone
          };
        });

        // 반경 내 시설만 필터링 (거리가 선택한 반경 이하인 것만)
        // 약간의 여유(0.01km = 10m)를 두지 않고 정확히 반경 내부만 표시
        const filteredFacilities = allFacilities.filter(f => f.distance < currentRadius);

        // 거리순 정렬
        filteredFacilities.sort((a, b) => a.distance - b.distance);

        console.log(`✅ 반경 ${currentRadius}km 내 시설: ${filteredFacilities.length}개 표시`);

        // 결과 표시
        updateResultListAndMarkers(filteredFacilities);
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
          radiusInfo.textContent = `(반경 ${"${currentRadius}"}km 내)`;
        }

        if (facilities.length === 0) {
          resultList.innerHTML = userGpsPosition
            ? `<li>반경 ${"${currentRadius}"}km 내에 검색 결과가 없습니다.</li>`
            : `<li>검색 결과가 없습니다.</li>`;
          return;
        }

        facilities.forEach((facility) => {
          // 반경 내 시설인지 재확인 (이중 검증)
          const centerPos = map.getCenter();
          const actualDistance = getDistance(
            centerPos.getLat(),
            centerPos.getLng(),
            facility.lat,
            facility.lng
          );

          // 실제 거리가 반경을 초과하면 스킵
          if (actualDistance > currentRadius) {
            console.warn(`시설 제외: ${facility.fcltNm} (거리: ${actualDistance}km > ${currentRadius}km)`);
            return;
          }

          const coords = new kakao.maps.LatLng(facility.lat, facility.lng);
          const marker = new kakao.maps.Marker({ map, position: coords });

          const displayAddr = facility.kakaoAddr || facility.fcltAddr || "주소 정보 없음";
          const displayPhone = facility.kakaoPhone || facility.fcltTelNo || "전화번호 없음";

          let infoContent = '<div style="padding:15px; min-width:250px; max-width:300px; background:#fff; border-radius:8px; box-shadow:0 2px 6px rgba(0,0,0,0.15);">';
          infoContent += '<strong style="font-size:16px; color:#333; display:block; margin-bottom:8px;">' + facility.fcltNm + '</strong>';
          infoContent += '<div style="font-size:13px; color:#666; line-height:1.6;">';
          infoContent += '<div style="margin-bottom:4px;">📍 ' + displayAddr + '</div>';
          infoContent += '<div style="margin-bottom:4px;">📞 ' + displayPhone + '</div>';
          if (facility.distanceDisplay) {
            infoContent += '<div style="color:#4A90E2; font-weight:500;">📏 거리: ' + facility.distanceDisplay + 'km</div>';
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
            ? `<p style="color: #4A90E2; font-weight: 500;">거리: ${"${facility.distanceDisplay}"}km</p>`
            : "";

          listItem.innerHTML = `
                    <h3>${"${facility.fcltNm}"}</h3>
                    <p>${"${displayAddr}"}</p>
                    <p>${"${displayPhone}"}</p>
                    <p style="color: #666; font-size: 12px;">종류: ${"${facility.fcltKindNm}"}</p>
                    ${"${distanceHTML}"}
                `;

          listItem.addEventListener("mouseover", () =>
            infowindow.open(map, marker)
          );
          listItem.addEventListener("mouseout", () => infowindow.close());
          listItem.addEventListener("click", () => map.panTo(coords));

          resultList.appendChild(listItem);
        });
      }
      function searchAddrFromCoords(coords, callback) {
        geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);
      }

      function clearMap() {
        markers.forEach((m) => m.setMap(null));
        infowindows.forEach((i) => i.close());
        markers = [];
        infowindows = [];
      }

      function setupButtonInteractions() {
        const locationButtons = document.querySelectorAll(
          ".location-options button"
        );
        const facilityOptionsContainer =
          document.querySelector(".facility-options");
        const radiusButtons = document.querySelectorAll(".radius-btn");
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

        radiusButtons.forEach((button) => {
          button.addEventListener("click", function () {
            radiusButtons.forEach((btn) => btn.classList.remove("active"));
            this.classList.add("active");
            currentRadius = parseInt(this.dataset.radius);
            if (userGpsPosition) {
              drawRadiusCircle();
              adjustMapLevel(currentRadius);
            }
            // 반경 변경 시 현재 선택된 시설 종류로 재검색
            const activeButton = document.querySelector(".facility-options button.active");
            if (activeButton) {
              searchFacilities(activeButton.dataset.code);
            }
          });
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
            window.location.href = '/bdproject/projectLogin.jsp';
          });
        }
      }
    </script>
  </body>
</html>
