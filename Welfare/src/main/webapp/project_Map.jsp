<%-- [수정] isELIgnored="true" 속성을 추가하여 ${} 문법 충돌을 방지합니다. --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>복지 기관 지도</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="resources/css/project_Map.css">
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

        <div class="radius-slider-container" style="display: flex">
          <div class="radius-slider-row">
            <span class="radius-label">반경</span>
            <input type="range" id="radius-slider" class="radius-slider"
                   min="0.1" max="5.0" step="0.1" value="1.0">
            <span class="radius-value" id="radius-value">1.0km</span>
          </div>
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

    <%
      String kakaoApiKey = application.getInitParameter("kakaoApiKey");
    %>
    <script type="text/javascript">
      var CONTEXT_PATH = "${pageContext.request.contextPath}";
    </script>
    <script
      type="text/javascript"
      src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=<%= kakaoApiKey %>&libraries=services"
    ></script>
    <script src="resources/js/project_Map.js"></script>
  </body>
</html>
