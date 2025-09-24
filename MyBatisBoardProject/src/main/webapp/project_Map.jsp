<%-- [수정] isELIgnored="true" 속성을 추가하여 ${} 문법 충돌을 방지합니다. --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background-color: #FAFAFA; color: #191918; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; display: flex; flex-direction: column; height: 100vh; }
        #main-header { position: sticky; top: 0; z-index: 1000; background-color: white; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .navbar { background-color: transparent; padding: 0 40px; display: flex; align-items: center; justify-content: space-between; height: 60px; flex-shrink: 0; }
        .navbar-left { flex-shrink: 0; }
        .navbar-right { display: flex; align-items: center; gap: 20px; }
        .logo { display: flex; align-items: center; gap: 8px; font-size: 28px; color: black; text-decoration: none; }
        .logo-icon { width: 50px; height: 50px; background-image: url('resources/image/복지로고.png'); background-size: 80%; background-repeat: no-repeat; background-position: center; background-color: transparent; border-radius: 6px; }
        .nav-menu { display: flex; gap: 50px; }
        .nav-link { color: #333; text-decoration: none; font-size: 14px; font-weight: 500; }
        .navbar-right .login-btn { background-color: white; color: black; border: 2px solid black; padding: 10px 20px; border-radius: 20px; font-size: 14px; font-weight: 500; cursor: pointer; transition: background-color 0.3s ease, color 0.3s ease; }
        .navbar-right .login-btn:hover { background-color: black; color: white; }
        .main-content { position: relative; display: flex; flex-grow: 1; overflow: hidden; }
        .info-panel { width: 380px; background-color: #fff; padding: 25px; border-right: 1px solid #e0e0e0; display: flex; flex-direction: column; overflow-y: auto; z-index: 10; }
        .info-title { font-size: 28px; font-weight: bold; margin-bottom: 20px; }
        .location-options { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; padding-bottom: 15px; margin-bottom: 15px; border-bottom: 1px solid #000; }
        .radius-options { display: flex; gap: 8px; margin-bottom: 15px; }
        .radius-btn { flex: 1; background-color: white; color: #666; border: 1px solid #ddd; border-radius: 6px; padding: 8px; font-size: 13px; font-weight: 500; cursor: pointer; transition: all 0.3s; }
        .radius-btn:hover { border-color: #4A90E2; }
        .radius-btn.active { background-color: #4A90E2; color: white; border-color: #4A90E2; }
        .facility-options { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 15px; }
        .location-options button, .facility-options button { background-color: #fff; color: #4A90E2; border: 1px solid #4A90E2; border-radius: 8px; padding: 12px; font-size: 15px; font-weight: 500; cursor: pointer; transition: background-color 0.3s, color 0.3s, opacity 0.3s; }
        .location-options button:hover, .facility-options button:hover { background-color: #4A90E2; color: white; }
        .location-options button.active, .facility-options button.active { background-color: #4A90E2; color: white; }
        .search-form { display: flex; gap: 10px; margin-bottom: 20px; }
        .search-form input { flex-grow: 1; border: 1px solid #ccc; border-radius: 8px; padding: 10px; font-size: 14px; }
        .search-form button { background-color: #4A90E2; color: white; border: none; border-radius: 8px; padding: 0 20px; font-weight: 500; cursor: pointer; transition: background-color 0.2s; }
        .results-header { padding: 10px; background-color: #f8f9fa; border-radius: 6px; margin-bottom: 15px; font-size: 14px; }
        .results-list { list-style: none; flex-grow: 1; overflow-y: auto; }
        .result-item { padding: 15px; border-bottom: 1px solid #eee; cursor: pointer; transition: background-color 0.2s; }
        .result-item:hover { background-color: #f8f9fa; }
        .result-item h3 { font-size: 16px; margin-bottom: 5px; color: #333; }
        .result-item p { font-size: 13px; color: #666; margin: 2px 0; }
        #map { flex-grow: 1; height: 100%; }
        #recenter-btn { position: absolute; bottom: 30px; right: 30px; width: 40px; height: 40px; background-color: white; border: 1px solid #ccc; border-radius: 50%; cursor: pointer; box-shadow: 0 2px 6px rgba(0,0,0,0.3); background-image: url('https://i.imgur.com/r33a2OK.png'); background-size: 24px 24px; background-position: center; background-repeat: no-repeat; z-index: 20; }
        .loading { text-align: center; padding: 20px; color: #666; }
    </style>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
    <header id="main-header">
        <nav class="navbar">
            <div class="navbar-left">
                <a href="/bdproject/project.jsp" class="logo"><div class="logo-icon"></div>복지 24</a>
            </div>
            <div class="navbar-right">
                <button class="login-btn">로그인</button>
            </div>
        </nav>
    </header>
    
    <div class="main-content">
        <div class="info-panel">
            <h1 class="info-title">복지지도 🔊</h1>
            <div class="location-options">
                <button id="current-location-btn">현위치</button>
                <button id="address-search-btn">주소검색</button>
            </div>
            
            <div class="radius-options" style="display: none;">
                <button class="radius-btn active" data-radius="1">1km</button>
                <button class="radius-btn" data-radius="3">3km</button>
                <button class="radius-btn" data-radius="5">5km</button>
            </div>
            
            <div class="facility-options">
                </div>
            
            <form class="search-form">
                <input type="text" placeholder="시설 이름으로 검색">
                <button type="submit">검색</button>
            </form>
            
            <div class="results-header">
                검색 결과 총 <strong>0건</strong>
                <span id="radius-info" style="margin-left: 10px; color: #4A90E2;"></span>
            </div>
            <ul class="results-list"></ul>
        </div>
        
        <div id="map"></div>
        <button id="recenter-btn" title="현위치로 복귀"></button>
    </div>

    <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=550cff912f02cdcf57aa419c87d2c222&libraries=services"></script>
    <script>
        // 전역 변수
        var map;
        var centerMarker;
        var geocoder = new kakao.maps.services.Geocoder();
        var markers = [], infowindows = [];
        var userGpsPosition, radiusCircle, currentRadius = 1;
        var allFacilities = [];
        const Gyeongbokgung = new kakao.maps.LatLng(37.5796, 126.9770);
        
        // 컨텍스트 경로
        const CONTEXT_PATH = '${pageContext.request.contextPath}';

        // ============== 페이지 로드 시 실행되는 메인 함수 ==============
        window.onload = async function() {
            console.log('페이지 로드 완료. 초기화를 시작합니다.');
            
            initMap();
            
            try {
                // 1. API를 통해 시설 종류 데이터를 가져옵니다.
                const facilityTypes = await fetchFacilityTypes();
                // 2. 가져온 데이터로 시설 종류 버튼들을 화면에 생성합니다.
                populateFacilityButtons(facilityTypes);
                // 3. 생성된 버튼들과 다른 UI 요소들에 이벤트 핸들러를 연결합니다.
                setupButtonInteractions();
                // 4. 모든 UI가 준비되면, 사용자 위치를 기반으로 첫 검색을 시도합니다.
                tryGetCurrentLocation();
            } catch (error) {
                console.error("페이지 초기화 중 심각한 오류 발생:", error);
                document.querySelector('.facility-options').innerHTML = '<p>시설 종류를 불러오는 데 실패했습니다.</p>';
                setupButtonInteractions(); 
                tryGetCurrentLocation();
            }
        };
        
        // ============== [수정] 시설 종류 코드를 '서버 프록시'를 통해 가져오는 함수 ==============
        async function fetchFacilityTypes() {
            // [수정] 외부 API가 아닌, 우리 서버의 프록시 주소를 호출합니다.
            const apiUrl = CONTEXT_PATH + '/api/facility-types';
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
            const container = document.querySelector('.facility-options');
            container.innerHTML = ''; // 기존 버튼들 초기화

            if (!types || types.length === 0) {
                container.innerHTML = '<p>시설 종류 정보가 없습니다.</p>';
                return;
            }

            // Set을 사용하여 중복된 시설 종류 제거
            const uniqueTypes = new Map(); // Map을 사용하여 코드를 키로 하여 중복 제거
            
            types.forEach(type => {
                if (type.fcltKindCd && type.fcltKindNm) { // 유효한 데이터만 처리
                    // 이미 같은 코드가 있는지 확인하여 중복 제거
                    if (!uniqueTypes.has(type.fcltKindCd)) {
                        uniqueTypes.set(type.fcltKindCd, type.fcltKindNm);
                    }
                }
            });

            // Map에서 고유한 값들만 버튼으로 생성
            uniqueTypes.forEach((fcltKindNm, fcltKindCd) => {
                const button = document.createElement('button');
                button.dataset.code = fcltKindCd;
                button.textContent = fcltKindNm;
                button.classList.add('facility-btn'); // 스타일링을 위한 클래스 추가
                container.appendChild(button);
            });

            // "전체 복지시설" 버튼은 항상 필요하므로 마지막에 직접 추가
            const allButton = document.createElement('button');
            allButton.dataset.code = 'ALL';
            allButton.textContent = '전체 복지시설';
            allButton.classList.add('facility-btn', 'all-btn'); // 전체 버튼 구분을 위한 클래스
            container.appendChild(allButton);
        }

        function initMap() {
            const container = document.getElementById('map');
            const options = { center: Gyeongbokgung, level: 5 };
            map = new kakao.maps.Map(container, options);
            map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
            
            centerMarker = new kakao.maps.Marker({
                position: map.getCenter(),
                image: new kakao.maps.MarkerImage('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png', new kakao.maps.Size(24, 35))
            });
            centerMarker.setMap(map);
            
            kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
                updateCenter(mouseEvent.latLng, false);
            });

            document.getElementById('recenter-btn').addEventListener('click', () => {
                const targetPosition = userGpsPosition || Gyeongbokgung;
                updateCenter(targetPosition, !!userGpsPosition);
            });
        }

        function updateCenter(position, isGps) {
            map.panTo(position);
            centerMarker.setPosition(position);
            
            if (isGps) {
                userGpsPosition = position;
                document.querySelector('.radius-options').style.display = 'flex';
                drawRadiusCircle();
            } else {
                if (userGpsPosition) {
                    userGpsPosition = position;
                    drawRadiusCircle();
                } else {
                    if (radiusCircle) radiusCircle.setMap(null);
                    document.querySelector('.radius-options').style.display = 'none';
                }
            }
            
            const activeButton = document.querySelector('.facility-options button.active');
            if (activeButton) {
                searchFacilities(activeButton.dataset.code);
            }
        }
        
        function tryGetCurrentLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(position => {
                    const gpsPosition = new kakao.maps.LatLng(position.coords.latitude, position.coords.longitude);
                    updateCenter(gpsPosition, true);
                    document.getElementById('current-location-btn').classList.add('active');

                    const firstFacilityButton = document.querySelector('.facility-options button');
                    if (firstFacilityButton) {
                        firstFacilityButton.click();
                    }
                }, () => {
                    console.warn("GPS를 찾을 수 없어 기본 위치(경복궁)에서 시작합니다.");
                    const firstFacilityButton = document.querySelector('.facility-options button');
                    if (firstFacilityButton) {
                        firstFacilityButton.click();
                    }
                });
            } else {
                const firstFacilityButton = document.querySelector('.facility-options button');
                if (firstFacilityButton) {
                    firstFacilityButton.click();
                }
            }
        }

        function drawRadiusCircle() {
            if (radiusCircle) radiusCircle.setMap(null);
            const center = userGpsPosition;
            if (center) {
                radiusCircle = new kakao.maps.Circle({ center, radius: currentRadius * 1000, strokeWeight: 2, strokeColor: '#4A90E2', strokeOpacity: 0.8, strokeStyle: 'solid', fillColor: '#4A90E2', fillOpacity: 0.1 });
                radiusCircle.setMap(map);
            }
        }
        
        function getDistance(lat1, lng1, lat2, lng2) {
            const R = 6371;
            const dLat = (lat2 - lat1) * Math.PI / 180, dLng = (lng2 - lng1) * Math.PI / 180;
            const a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * Math.sin(dLng/2) * Math.sin(dLng/2);
            const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
            return  parseFloat((R * c).toFixed(2));
        }

        function adjustMapLevel(radius) {
            let level;
            if (radius <= 1) level = 5; else if (radius <= 3) level = 6; else if (radius <= 5) level = 7; else level = 8;
            map.setLevel(level);
        }
        
        async function fetchFacilitiesFromPublicAPI(params) {
            console.log("복지시설 목록 API 호출 시작, 파라미터:", params);
            
            try {
                const endpoint = CONTEXT_PATH + '/api/facilities';
                
                const urlParams = new URLSearchParams();
                if (params.fcltKindCd) urlParams.append('fcltKindCd', params.fcltKindCd);
                if (params.jrsdSggCd) urlParams.append('jrsdSggCd', params.jrsdSggCd);
                if (params.fcltNm) urlParams.append('fcltNm', params.fcltNm);
                urlParams.append('pageNo', params.pageNo || 1);
                urlParams.append('numOfRows', params.numOfRows || 100);
                
                const url = `${'${endpoint}'}?${'${urlParams.toString()}'}`;
                
                const response = await fetch(url);
                if (!response.ok) throw new Error(`서버 API 오류: ${response.status}`);
                
                const data = await response.json();
                console.log('복지시설 목록', data);
                if (data.response && data.response.body && data.response.body.items) {
                    const items = Array.isArray(data.response.body.items.item) ? data.response.body.items.item : [data.response.body.items.item];
                    console.log(items)
                    return items.map(item => ({
                        fcltNm: item.fcltNm || '', fcltAddr: item.fcltAddr || '',
                        fcltTelNo: item.fcltTelNo || item.telNo || '', fcltCd: item.fcltCd || '',
                        fcltKindNm: item.fcltKindNm || ''
                    }));
                } else {
                    return [];
                }
            } catch (error) {
                console.error("복지시설 목록 조회 중 오류:", error);
                throw error;
            }
        }

        async function searchFacilities(facilityCode, searchTerm = '') {
            const searchPosition = map.getCenter();
            document.querySelector('.results-list').innerHTML = '<li class="loading">검색 중...</li>';
            
            searchAddrFromCoords(searchPosition, async (result, status) => {
                if (status === kakao.maps.services.Status.OK) {
                    const districtCode = result[0].code.substr(0, 4) + "000000";
                    console.log('거리 코드', districtCode)
                    
                    const params = {
                        fcltKindCd: facilityCode || '', jrsdSggCd: districtCode,
                        fcltNm: searchTerm || '', numOfRows: 100, pageNo: 1
                    };
                    console.log('매개변수', params);
                    try {
                        allFacilities = await fetchFacilitiesFromPublicAPI(params);
                        console.log("모든 시설",allFacilities )
                        updateResultListAndMarkers(allFacilities);
                    } catch (error) {
                        console.error("시설 검색 실패:", error);
                        document.querySelector('.results-list').innerHTML = '<li>시설 정보를 불러올 수 없습니다.</li>';
                    }
                } else {
                    document.querySelector('.results-list').innerHTML = '<li>주소 정보를 찾을 수 없습니다.</li>';
                }
            });
        }
        
        async function filterAndDisplayFacilities(facilities, centerPoint) {
            const centerLat = centerPoint.getLat();
            const centerLng = centerPoint.getLng();
            let facilitiesWithCoords = [];

            for (const facility of facilities) {
            	
                // [수정] 주소 대신 시설명으로 검색
                if (!facility.fcltNm) continue;
                
                const result = await new Promise(resolve => {
                    // [수정] 카카오 장소 검색 API 사용 (키워드 검색)
                    const ps = new kakao.maps.services.Places();
                    ps.keywordSearch(facility.fcltNm, (result, status) => {
                        if (status === kakao.maps.services.Status.OK && result.length > 0) {
                            // 가장 첫 번째 결과 사용
                            const place = result[0];
                            const lat = parseFloat(place.y);
                            const lng = parseFloat(place.x);
                            const distance = getDistance(centerLat, centerLng, lat, lng);
                            
                            resolve({ 
                                ...facility, 
                                lat, 
                                lng, 
                                distance,
                                // 카카오에서 가져온 주소 정보도 추가
                                kakaoAddr: place.road_address_name || place.address_name,
                                kakaoPhone: place.phone
                            });
                        } else { 
                            resolve(null); 
                        }
                    });
                });
                
                if (result) facilitiesWithCoords.push(result);
                await new Promise(resolve => setTimeout(resolve, 100)); // API 호출 간격 증가
            }

            const validFacilities = facilitiesWithCoords.filter(f => f && (!userGpsPosition || f.distance <= currentRadius));
            validFacilities.sort((a, b) => a.distance - b.distance);
            updateResultListAndMarkers(validFacilities);
        }
        
        function updateResultListAndMarkers(facilities) {
            clearMap();
            const resultList = document.querySelector('.results-list');
            const resultHeader = document.querySelector('.results-header strong');
            const radiusInfo = document.getElementById('radius-info');
            
            resultList.innerHTML = '';
            resultHeader.textContent = facilities.length + '건';
            radiusInfo.style.display = userGpsPosition ? 'inline' : 'none';
            if (userGpsPosition) {
                radiusInfo.textContent = `(반경 ${'${currentRadius}'}km 내)`;
            }

            if (facilities.length === 0) {
                resultList.innerHTML = userGpsPosition ? 
                    `<li>반경 ${'${currentRadius}'}km 내에 검색 결과가 없습니다.</li>` : 
                    `<li>검색 결과가 없습니다.</li>`;
                return;
            }

            facilities.forEach((facility) => {
                const coords = new kakao.maps.LatLng(facility.lat, facility.lng);
                const marker = new kakao.maps.Marker({ map, position: coords });
                const infowindow = new kakao.maps.InfoWindow({    
                    content: `<div style="padding:5px;font-size:12px;"><strong>${'${facility.fcltNm}'}</strong></div>`,
                    disableAutoPan: true    
                });
                
                markers.push(marker);
                infowindows.push(infowindow);

                const listItem = document.createElement('li');
                listItem.className = 'result-item';
                let distanceHTML = userGpsPosition ? 
                    `<p style="color: #4A90E2; font-weight: 500;">거리: ${'${facility.distance}'}km</p>` : '';
                
                // [수정] 주소는 카카오에서 가져온 것 사용, 전화번호도 카카오 우선
                const displayAddr = facility.kakaoAddr || facility.fcltAddr || '주소 정보 없음';
                const displayPhone = facility.kakaoPhone || facility.fcltTelNo || '전화번호 없음';
                
                listItem.innerHTML = `
                    <h3>${'${facility.fcltNm}'}</h3>
                    <p>${'${displayAddr}'}</p>
                    <p>${'${displayPhone}'}</p>
                    <p style="color: #666; font-size: 12px;">종류: ${'${facility.fcltKindNm}'}</p>
                    ${'${distanceHTML}'}
                `;
                
                listItem.addEventListener('mouseover', () => infowindow.open(map, marker));
                listItem.addEventListener('mouseout', () => infowindow.close());
                listItem.addEventListener('click', () => map.panTo(coords));
                
                resultList.appendChild(listItem);
            });
        }
        function searchAddrFromCoords(coords, callback) { geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback); }

        function clearMap() {
            markers.forEach(m => m.setMap(null));
            infowindows.forEach(i => i.close());
            markers = []; infowindows = [];
        }

        function setupButtonInteractions() {
            const locationButtons = document.querySelectorAll('.location-options button');
            const facilityOptionsContainer = document.querySelector('.facility-options');
            const radiusButtons = document.querySelectorAll('.radius-btn');
            const searchForm = document.querySelector('.search-form');
            const searchInput = document.querySelector('.search-form input');
            
            document.getElementById('current-location-btn').addEventListener('click', function() {
                locationButtons.forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');
                tryGetCurrentLocation();
            });

            document.getElementById('address-search-btn').addEventListener('click', () => {
                new daum.Postcode({
                    oncomplete: function(data) {
                        geocoder.addressSearch(data.address, function(result, status) {
                            if (status === kakao.maps.services.Status.OK) {
                                updateCenter(new kakao.maps.LatLng(result[0].y, result[0].x), false);
                            }
                        });
                    }
                }).open();
            });
            
            radiusButtons.forEach(button => {
                button.addEventListener('click', function() {
                    radiusButtons.forEach(btn => btn.classList.remove('active'));
                    this.classList.add('active');
                    currentRadius = parseInt(this.dataset.radius);
                    if (userGpsPosition) {
                        drawRadiusCircle();
                        adjustMapLevel(currentRadius);
                        filterAndDisplayFacilities(allFacilities, userGpsPosition);
                    } else {
                        const activeButton = document.querySelector('.facility-options button.active');
                        if(activeButton) searchFacilities(activeButton.dataset.code);
                    }
                });
            });

            facilityOptionsContainer.addEventListener('click', e => {
                if (e.target.tagName === 'BUTTON') {
                    facilityOptionsContainer.querySelectorAll('button').forEach(btn => btn.classList.remove('active'));
                    e.target.classList.add('active');
                    
                    const facilityCode = e.target.dataset.code;
                    const searchTerm = searchInput.value.trim();
                    searchFacilities(facilityCode, searchTerm);
                }
            });

            searchForm.addEventListener('submit', e => {
                e.preventDefault();
                const activeButton = document.querySelector('.facility-options button.active');
                if (!activeButton) {
                    alert("먼저 시설 종류를 선택해주세요.");
                    return;
                }
                const searchTerm = searchInput.value.trim();
                searchFacilities(activeButton.dataset.code, searchTerm);
            });
        }
    </script>
</body>
</html>