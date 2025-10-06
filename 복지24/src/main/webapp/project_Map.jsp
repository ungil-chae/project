<%-- [수정] isELIgnored="true" 속성을 추가하여 ${} 문법 충돌을 방지합니다. --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" isELIgnored="false"%>
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
        font-size: 28px;
        color: black;
        text-decoration: none;
      }
      .logo-icon {
        width: 50px;
        height: 50px;
        background-image: url("resources/image/복지로고.png");
        background-size: 80%;
        background-repeat: no-repeat;
        background-position: center;
        background-color: transparent;
        border-radius: 6px;
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
        width: 40px;
        height: 40px;
        background-color: white;
        border: 1px solid #ccc;
        border-radius: 50%;
        cursor: pointer;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
        background-image: url("https://i.imgur.com/r33a2OK.png");
        background-size: 24px 24px;
        background-position: center;
        background-repeat: no-repeat;
        z-index: 20;
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
    <header id="main-header">
      <nav class="navbar">
        <div class="navbar-left">
          <a href="/bdproject/project.jsp" class="logo">
            <div class="logo-icon"></div>
            복지 24
          </a>
        </div>
        <div class="nav-menu">
          <div class="nav-item">
            <a href="#" class="nav-link" data-menu="service">서비스</a>
          </div>
          <div class="nav-item">
            <a href="#" class="nav-link" data-menu="explore">살펴보기</a>
          </div>
          <div class="nav-item">
            <a href="#" class="nav-link" data-menu="volunteer">봉사하기</a>
          </div>
          <div class="nav-item">
            <a href="#" class="nav-link" data-menu="donate">기부하기</a>
          </div>
        </div>
        <div class="navbar-right">
          <div class="language-selector">
            <svg
              class="navbar-icon"
              id="languageToggle"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="currentColor"
            >
              <path
                d="M12 2C6.477 2 2 6.477 2 12s4.477 10 10 10 10-4.477 10-10S17.523 2 12 2zm6.93 6h-2.95a15.65 15.65 0 00-1.38-3.56A8.03 8.03 0 0118.93 8zM12 4.04c.83 1.2 1.48 2.53 1.91 3.96h-3.82c.43-1.43 1.08-2.76 1.91-3.96zM4.26 14C4.1 13.36 4 12.69 4 12s.1-1.36.26-2h3.38c-.08.66-.14 1.32-.14 2 0 .68.06 1.34.14 2H4.26zm.81 2h2.95c.32 1.25.78 2.45 1.38 3.56A7.987 7.987 0 015.07 16zm2.95-8H5.07a7.987 7.987 0 014.33-3.56A15.65 15.65 0 008.02 8zM12 19.96c-.83-1.2-1.48-2.53-1.91-3.96h3.82c-.43 1.43-1.08 2.76-1.91 3.96zM14.34 14H9.66c-.09-.66-.16-1.32-.16-2 0-.68.07-1.35.16-2h4.68c.09.65.16 1.32.16 2 0 .68-.07 1.34-.16 2zm.25 5.56c.6-1.11 1.06-2.31 1.38-3.56h2.95a8.03 8.03 0 01-4.33 3.56zM16.36 14c.08-.66.14-1.32.14-2 0-.68-.06-1.34-.14-2h3.38c.16.64.26 1.31.26 2s-.1 1.36-.26 2h-3.38z"
              ></path>
            </svg>
            <div class="language-dropdown" id="languageDropdown">
              <div class="language-option" data-lang="ko">
                <span class="country-name">대한민국</span>
                <span class="language-name">한국어</span>
              </div>
              <div class="language-option" data-lang="en">
                <span class="country-name">Australia</span>
                <span class="language-name">English</span>
              </div>
              <div class="language-option" data-lang="ja">
                <span class="country-name">日本</span>
                <span class="language-name">日本語</span>
              </div>
              <div class="language-option" data-lang="zh">
                <span class="country-name">中国</span>
                <span class="language-name">中文</span>
              </div>
              <div class="language-option" data-lang="es">
                <span class="country-name">España</span>
                <span class="language-name">Español</span>
              </div>
            </div>
          </div>
          <svg
            class="navbar-icon"
            id="userIcon"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="currentColor"
            style="cursor: pointer"
          >
            <path
              d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 4c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm0 14c-2.03 0-4.43-.82-6.14-2.88C7.55 15.8 9.68 15 12 15s4.45.8 6.14 2.12C16.43 19.18 14.03 20 12 20z"
            ></path>
          </svg>
        </div>
      </nav>
      <div id="mega-menu-wrapper">
        <div class="mega-menu-content">
          <div class="menu-column" data-menu-content="service">
            <a href="/bdproject/project_detail.jsp" class="dropdown-link">
              <div class="dropdown-link-title">복지 진단</div>
              <span class="dropdown-link-desc">나에게 맞는 복지 서비스 찾기</span>
            </a>
            <a href="/bdproject/project_Map.jsp" class="dropdown-link">
              <div class="dropdown-link-title">복지 시설 지도</div>
              <span class="dropdown-link-desc">주변 복지 시설 찾기</span>
            </a>
          </div>
          <div class="menu-column" data-menu-content="explore">
            <a href="#" class="dropdown-link">
              <div class="dropdown-link-title">복지 뉴스</div>
              <span class="dropdown-link-desc">최신 복지 소식</span>
            </a>
          </div>
          <div class="menu-column" data-menu-content="volunteer">
            <a href="#" class="dropdown-link">
              <div class="dropdown-link-title">봉사 신청</div>
              <span class="dropdown-link-desc">봉사 활동 참여하기</span>
            </a>
          </div>
          <div class="menu-column" data-menu-content="donate">
            <a href="/bdproject/project_Donation.jsp" class="dropdown-link">
              <div class="dropdown-link-title">기부하기</div>
              <span class="dropdown-link-desc">따뜻한 나눔 실천</span>
            </a>
          </div>
        </div>
      </div>
    </header>

    <div class="main-content">
      <div class="info-panel">
        <h1 class="info-title">복지지도</h1>
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
      <button id="recenter-btn" title="현위치로 복귀"></button>
    </div>

    <script
      type="text/javascript"
      src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=550cff912f02cdcf57aa419c87d2c222&libraries=services"
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

        // 광화문을 기본 중심으로 설정하고 반경 원 표시
        userGpsPosition = Gwanghwamun;
        updateCenter(Gwanghwamun, true);

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

      // ============== [수정] 시설 종류 코드를 '서버 프록시'를 통해 가져오는 함수 ==============
      async function fetchFacilityTypes() {
        // [수정] 외부 API가 아닌, 우리 서버의 프록시 주소를 호출합니다.
        const apiUrl = CONTEXT_PATH + "/api/facility-types";
        console.log("내부 서버 프록시 API 호출:", apiUrl);

        try {
          const response = await fetch(apiUrl);
          if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`API 호출 실패: ${response.status} - ${errorText}`);
          }

          const data = await response.json();
          console.log("시설 종류 API 응답 (서버 경유):", data);

          if (data.response && data.response.body && data.response.body.items) {
            return data.response.body.items.item;
          }
          return [];
        } catch (error) {
          console.error("시설 종류 코드를 가져오는 중 오류 발생:", error);
          throw error;
        }
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

        if (isGps) {
          userGpsPosition = position;
          document.querySelector(".radius-options").style.display = "flex";
          drawRadiusCircle();
        } else {
          if (userGpsPosition) {
            userGpsPosition = position;
            drawRadiusCircle();
          } else {
            if (radiusCircle) radiusCircle.setMap(null);
            document.querySelector(".radius-options").style.display = "none";
          }
        }

        const activeButton = document.querySelector(
          ".facility-options button.active"
        );
        if (activeButton) {
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
        const R = 6371;
        const dLat = ((lat2 - lat1) * Math.PI) / 180,
          dLng = ((lng2 - lng1) * Math.PI) / 180;
        const a =
          Math.sin(dLat / 2) * Math.sin(dLat / 2) +
          Math.cos((lat1 * Math.PI) / 180) *
            Math.cos((lat2 * Math.PI) / 180) *
            Math.sin(dLng / 2) *
            Math.sin(dLng / 2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return parseFloat((R * c).toFixed(2));
      }

      function adjustMapLevel(radius) {
        let level;
        if (radius <= 1) level = 5;
        else if (radius <= 3) level = 6;
        else if (radius <= 5) level = 7;
        else level = 8;
        map.setLevel(level);
      }

      async function fetchFacilitiesFromPublicAPI(params) {
        console.log("복지시설 목록 API 호출 시작, 파라미터:", params);

        try {
          const endpoint = CONTEXT_PATH + "/api/facilities";

          const urlParams = new URLSearchParams();
          if (params.fcltKindCd)
            urlParams.append("fcltKindCd", params.fcltKindCd);
          if (params.jrsdSggCd) urlParams.append("jrsdSggCd", params.jrsdSggCd);
          if (params.fcltNm) urlParams.append("fcltNm", params.fcltNm);
          urlParams.append("pageNo", params.pageNo || 1);
          urlParams.append("numOfRows", params.numOfRows || 100);

          const url = `${"${endpoint}"}?${"${urlParams.toString()}"}`;

          const response = await fetch(url);
          if (!response.ok)
            throw new Error(`서버 API 오류: ${response.status}`);

          const data = await response.json();
          console.log("복지시설 목록", data);
          if (data.response && data.response.body && data.response.body.items) {
            const items = Array.isArray(data.response.body.items.item)
              ? data.response.body.items.item
              : [data.response.body.items.item];
            console.log(items);
            return items.map((item) => ({
              fcltNm: item.fcltNm || "",
              fcltAddr: item.fcltAddr || "",
              fcltTelNo: item.fcltTelNo || item.telNo || "",
              fcltCd: item.fcltCd || "",
              fcltKindNm: item.fcltKindNm || "",
            }));
          } else {
            return [];
          }
        } catch (error) {
          console.error("복지시설 목록 조회 중 오류:", error);
          throw error;
        }
      }

      async function searchFacilities(facilityCode, searchTerm = "") {
        const searchPosition = map.getCenter();
        document.querySelector(".results-list").innerHTML =
          '<li class="loading">검색 중...</li>';

        searchAddrFromCoords(searchPosition, async (result, status) => {
          if (status === kakao.maps.services.Status.OK) {
            const districtCode = result[0].code.substr(0, 4) + "000000";
            console.log("거리 코드", districtCode);

            const params = {
              fcltKindCd: facilityCode || "",
              jrsdSggCd: districtCode,
              fcltNm: searchTerm || "",
              numOfRows: 100,
              pageNo: 1,
            };
            console.log("매개변수", params);
            try {
              allFacilities = await fetchFacilitiesFromPublicAPI(params);
              console.log("API에서 받은 시설 수:", allFacilities.length);
              console.log("모든 시설 데이터:", allFacilities);

              // 좌표 변환 및 필터링 수행
              if (userGpsPosition) {
                await filterAndDisplayFacilities(allFacilities, userGpsPosition);
              } else {
                await filterAndDisplayFacilities(allFacilities, searchPosition);
              }
            } catch (error) {
              console.error("시설 검색 실패:", error);
              document.querySelector(".results-list").innerHTML =
                "<li>시설 정보를 불러올 수 없습니다.</li>";
            }
          } else {
            document.querySelector(".results-list").innerHTML =
              "<li>주소 정보를 찾을 수 없습니다.</li>";
          }
        });
      }

      async function filterAndDisplayFacilities(facilities, centerPoint) {
        const centerLat = centerPoint.getLat();
        const centerLng = centerPoint.getLng();
        let facilitiesWithCoords = [];

        console.log(`총 ${facilities.length}개 시설에 대해 좌표 검색 시작`);
        document.querySelector(".results-list").innerHTML =
          `<li class="loading">좌표 변환 중... (0/${facilities.length})</li>`;

        for (let i = 0; i < facilities.length; i++) {
          const facility = facilities[i];

          // 진행 상황 표시
          if (i % 5 === 0) {
            document.querySelector(".results-list").innerHTML =
              `<li class="loading">좌표 변환 중... (${i}/${facilities.length})</li>`;
          }

          if (!facility.fcltAddr && !facility.fcltNm) continue;

          // API가 이미 좌표를 제공한 경우 (하드코딩된 데이터)
          if (facility.lat && facility.lng) {
            const lat = parseFloat(facility.lat);
            const lng = parseFloat(facility.lng);
            const distance = calculateDistance(centerLat, centerLng, lat, lng);

            facilitiesWithCoords.push({
              ...facility,
              lat: lat,
              lng: lng,
              distance: distance,
              kakaoAddr: facility.fcltAddr,
              kakaoPhone: facility.fcltTelNo
            });
            console.log(`✓ 하드코딩 좌표 사용 [${facilitiesWithCoords.length}/${facilities.length}]: ${facility.fcltNm}`);
            continue;
          }

          // 좌표가 없는 경우에만 Geocoder 사용
          const result = await tryMultipleGeocodingMethods(facility, centerLat, centerLng);

          if (result) {
            facilitiesWithCoords.push(result);
            console.log(`✓ 좌표 변환 성공 [${facilitiesWithCoords.length}/${facilities.length}]: ${result.fcltNm}`);
          } else {
            console.log(`✗ 좌표 변환 실패 [${i+1}/${facilities.length}]: ${facility.fcltNm} - ${facility.fcltAddr}`);
          }
          await new Promise((resolve) => setTimeout(resolve, 200)); // API 제한 방지 (간격 증가)
        }

        console.log(`좌표 검색 완료: ${facilitiesWithCoords.length}/${facilities.length}개 성공`);
        console.log("변환 성공 시설 목록:", facilitiesWithCoords.map(f => f.fcltNm));

        const validFacilities = facilitiesWithCoords.filter(
          (f) => f && (!userGpsPosition || f.distance <= currentRadius)
        );
        validFacilities.sort((a, b) => a.distance - b.distance);

        console.log(`반경 필터링 완료: ${validFacilities.length}개 시설 표시`);
        updateResultListAndMarkers(validFacilities);
      }

      // 여러 방법으로 좌표를 찾는 함수
      async function tryMultipleGeocodingMethods(facility, centerLat, centerLng) {
        // 방법 1: 원본 주소로 검색
        if (facility.fcltAddr) {
          let result = await searchByAddress(facility.fcltAddr, facility, centerLat, centerLng);
          if (result) return result;

          // 방법 2: "서울특별시" → "서울"로 변환
          let addr2 = facility.fcltAddr.replace('서울특별시', '서울');
          if (addr2 !== facility.fcltAddr) {
            result = await searchByAddress(addr2, facility, centerLat, centerLng);
            if (result) return result;
          }

          // 방법 3: 괄호 제거
          let addr3 = facility.fcltAddr.replace(/\(.*?\)/g, '').trim();
          result = await searchByAddress(addr3, facility, centerLat, centerLng);
          if (result) return result;

          // 방법 4: 번지수 제거 (동/로까지만)
          let parts = facility.fcltAddr.split(' ');
          for (let i = parts.length - 1; i >= 2; i--) {
            let addr4 = parts.slice(0, i).join(' ');
            result = await searchByAddress(addr4, facility, centerLat, centerLng);
            if (result) return result;
          }

          // 방법 5: 구 이름 + 시설명으로 장소 검색
          let guMatch = facility.fcltAddr.match(/(종로구|중구|용산구|서대문구|성북구|동대문구|마포구|영등포구|도봉구)/);
          if (guMatch) {
            let searchQuery = guMatch[1] + ' ' + facility.fcltNm;
            result = await searchByKeyword(searchQuery, facility, centerLat, centerLng);
            if (result) return result;
          }
        }

        // 방법 6: 시설명만으로 장소 검색
        if (facility.fcltNm) {
          let result = await searchByKeyword(facility.fcltNm, facility, centerLat, centerLng);
          if (result) return result;

          // 방법 7: 시설명에서 괄호/특수문자 제거
          let cleanName = facility.fcltNm.replace(/\(.*?\)/g, '').replace(/[^\w가-힣\s]/g, '').trim();
          if (cleanName !== facility.fcltNm && cleanName.length > 2) {
            result = await searchByKeyword(cleanName, facility, centerLat, centerLng);
            if (result) return result;
          }

          // 방법 8: 시설명 앞부분만 검색
          let shortName = facility.fcltNm.split(/[\s(]/)[0];
          if (shortName !== facility.fcltNm && shortName.length > 2) {
            result = await searchByKeyword(shortName, facility, centerLat, centerLng);
            if (result) return result;
          }
        }

        return null;
      }

      // 주소로 좌표 검색
      function searchByAddress(address, facility, centerLat, centerLng) {
        return new Promise((resolve) => {
          geocoder.addressSearch(address, function(result, status) {
            if (status === kakao.maps.services.Status.OK && result.length > 0) {
              const lat = parseFloat(result[0].y);
              const lng = parseFloat(result[0].x);
              const distance = getDistance(centerLat, centerLng, lat, lng);
              resolve({
                ...facility,
                lat,
                lng,
                distance,
              });
            } else {
              resolve(null);
            }
          });
        });
      }

      // 키워드로 장소 검색
      function searchByKeyword(keyword, facility, centerLat, centerLng) {
        return new Promise((resolve) => {
          const ps = new kakao.maps.services.Places();
          ps.keywordSearch(keyword, (result, status) => {
            if (status === kakao.maps.services.Status.OK && result.length > 0) {
              const place = result[0];
              const lat = parseFloat(place.y);
              const lng = parseFloat(place.x);
              const distance = getDistance(centerLat, centerLng, lat, lng);
              resolve({
                ...facility,
                lat,
                lng,
                distance,
                kakaoAddr: place.road_address_name || place.address_name,
                kakaoPhone: place.phone,
              });
            } else {
              resolve(null);
            }
          });
        });
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
          const coords = new kakao.maps.LatLng(facility.lat, facility.lng);
          const marker = new kakao.maps.Marker({ map, position: coords });

          const displayAddr = facility.kakaoAddr || facility.fcltAddr || "주소 정보 없음";
          const displayPhone = facility.kakaoPhone || facility.fcltTelNo || "전화번호 없음";

          let infoContent = '<div style="padding:15px; min-width:250px; max-width:300px; background:#fff; border-radius:8px; box-shadow:0 2px 6px rgba(0,0,0,0.15);">';
          infoContent += '<strong style="font-size:16px; color:#333; display:block; margin-bottom:8px;">' + facility.fcltNm + '</strong>';
          infoContent += '<div style="font-size:13px; color:#666; line-height:1.6;">';
          infoContent += '<div style="margin-bottom:4px;">📍 ' + displayAddr + '</div>';
          infoContent += '<div style="margin-bottom:4px;">📞 ' + displayPhone + '</div>';
          if (facility.distance) {
            infoContent += '<div style="color:#4A90E2; font-weight:500;">📏 거리: ' + facility.distance + 'km</div>';
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
            ? `<p style="color: #4A90E2; font-weight: 500;">거리: ${"${facility.distance}"}km</p>`
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
              filterAndDisplayFacilities(allFacilities, userGpsPosition);
            } else {
              const activeButton = document.querySelector(
                ".facility-options button.active"
              );
              if (activeButton) searchFacilities(activeButton.dataset.code);
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
        const navLinks = document.querySelectorAll('.nav-link');
        const megaMenuWrapper = document.getElementById('mega-menu-wrapper');
        const menuColumns = document.querySelectorAll('.menu-column');
        let currentActiveMenu = null;

        navLinks.forEach(link => {
          link.addEventListener('mouseenter', function() {
            const menuType = this.getAttribute('data-menu');

            navLinks.forEach(l => l.classList.remove('active'));
            this.classList.add('active');

            menuColumns.forEach(col => col.classList.remove('active'));
            const targetColumn = document.querySelector('[data-menu-content="' + menuType + '"]');
            if (targetColumn) {
              targetColumn.classList.add('active');
              megaMenuWrapper.classList.add('active');
              currentActiveMenu = menuType;
            }
          });
        });

        const navbar = document.querySelector('.navbar');
        navbar.addEventListener('mouseleave', function() {
          megaMenuWrapper.classList.remove('active');
          navLinks.forEach(l => l.classList.remove('active'));
          currentActiveMenu = null;
        });

        megaMenuWrapper.addEventListener('mouseenter', function() {
          this.classList.add('active');
        });

        megaMenuWrapper.addEventListener('mouseleave', function() {
          this.classList.remove('active');
          navLinks.forEach(l => l.classList.remove('active'));
          currentActiveMenu = null;
        });

        // 언어 드롭다운 이벤트
        const globeIcon = document.getElementById('languageToggle');
        const languageDropdown = document.getElementById('languageDropdown');

        if (globeIcon && languageDropdown) {
          globeIcon.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            languageDropdown.classList.toggle('active');
          });

          const languageOptions = languageDropdown.querySelectorAll('.language-option');
          languageOptions.forEach(option => {
            option.addEventListener('click', function() {
              languageOptions.forEach(opt => opt.classList.remove('active'));
              this.classList.add('active');
              languageDropdown.classList.remove('active');
              const selectedLang = this.getAttribute('data-lang');
              console.log('선택된 언어:', selectedLang);
            });
          });

          document.addEventListener('click', function(e) {
            if (!globeIcon.contains(e.target) && !languageDropdown.contains(e.target)) {
              languageDropdown.classList.remove('active');
            }
          });
        }

        // 사용자 아이콘 클릭 이벤트
        const userIcon = document.getElementById('userIcon');
        if (userIcon) {
          userIcon.addEventListener('click', function() {
            window.location.href = '/bdproject/loginForm.jsp';
          });
        }
      }
    </script>
  </body>
</html>
