# 인기 복지 혜택 API 구현 방식

## 개요
복지24 프로젝트의 "인기 복지 혜택" 섹션은 **복지로(bokjiro.go.kr) 공공 API**를 실시간으로 연동하여 조회수가 높은 복지 서비스를 자동으로 표시합니다.

## 시스템 아키텍처

```
[Frontend: project1.jsp]
        ↓ AJAX 요청
[Controller: WelfareController.java]
        ↓ Service 호출
[Service: WelfareService.java]
        ↓ HTTP 요청
[복지로 공공 API] ← 중앙부처 + 지자체 복지 서비스 데이터
        ↓ JSON 응답
[Service: 데이터 병합 및 정렬]
        ↓ 정렬된 데이터 반환
[Controller: JSON 응답]
        ↓
[Frontend: 슬라이더 UI 렌더링]
```

## 기술 스택

### Backend
- **Framework**: Spring Framework 5.0.7
- **Language**: Java 11
- **HTTP Client**: Spring RestTemplate
- **JSON Processing**: Jackson ObjectMapper
- **Logging**: SLF4J + Log4j

### Frontend
- **View Engine**: JSP
- **JavaScript**: Vanilla JavaScript (ES6+)
- **UI Pattern**: Slider (4-item carousel)
- **Communication**: AJAX (Fetch API)

## API 구현 세부 사항

### 1. Controller Layer (WelfareController.java)

**역할**: HTTP 요청을 받아 Service를 호출하고 JSON 응답을 반환

**엔드포인트**: `GET /welfare/popular`

**코드 위치**: `src/main/java/com/greenart/bdproject/controller/WelfareController.java:133-156`

```java
@GetMapping(value = "/popular", produces = "application/json; charset=UTF-8")
@ResponseBody
public ResponseEntity<String> getPopularWelfareServices() {
    try {
        logger.info("인기 복지 서비스 조회 요청 (실시간 복지로 API)");

        // Service Layer 호출
        List<Map<String, Object>> popularServices = welfareService.getPopularWelfareServices();

        logger.info("인기 복지 서비스 조회 완료: {}개", popularServices.size());

        // JSON 변환
        String jsonResult = objectMapper.writeValueAsString(popularServices);

        return ResponseEntity.ok()
            .header("Content-Type", "application/json; charset=UTF-8")
            .body(jsonResult);

    } catch (Exception e) {
        logger.error("인기 복지 서비스 조회 중 오류 발생: ", e);
        return ResponseEntity.status(500)
            .body("{\"error\":\"인기 복지 서비스 조회 중 오류가 발생했습니다.\"}");
    }
}
```

**특징**:
- `@ResponseBody`: 응답을 JSON으로 직접 반환
- `produces = "application/json; charset=UTF-8"`: UTF-8 인코딩 명시
- 예외 처리를 통한 안정적인 에러 응답

---

### 2. Service Layer (WelfareService.java)

**역할**: 복지로 API 호출 및 데이터 가공

**메서드**: `getPopularWelfareServices()`

**코드 위치**: `src/main/java/com/greenart/bdproject/service/WelfareService.java:635-697`

#### 2.1 API 호출 구조

**사용하는 API**:
1. **중앙부처 복지 서비스 API**: `NationalWelfareInformationsV001`
2. **지방자치단체 복지 서비스 API**: `LocalGovernmentWelfareInformations`

```java
public List<Map<String, Object>> getPopularWelfareServices() {
    List<Map<String, Object>> allServices = new ArrayList<>();

    try {
        // 1. 중앙부처 API 호출
        String centralUrl = "https://www.bokjiro.go.kr/openapi/rest/gvmtWelSvc" +
            "?crtiKey=" + API_KEY +
            "&callTp=L" +
            "&pageNum=1" +
            "&numOfRows=10";

        String centralResponse = restTemplate.getForObject(centralUrl, String.class);
        List<Map<String, Object>> centralServices = parseApiResponse(centralResponse);

        // 출처 표시
        centralServices.forEach(service -> service.put("source", "중앙부처"));
        allServices.addAll(centralServices);

        // 2. 지자체 API 호출
        String localUrl = "https://www.bokjiro.go.kr/openapi/rest/locgvWelSvc" +
            "?crtiKey=" + API_KEY +
            "&callTp=L" +
            "&pageNum=1" +
            "&numOfRows=10";

        String localResponse = restTemplate.getForObject(localUrl, String.class);
        List<Map<String, Object>> localServices = parseApiResponse(localResponse);

        localServices.forEach(service -> service.put("source", "지자체"));
        allServices.addAll(localServices);

        // 3. 조회수(inqNum) 기준 내림차순 정렬
        allServices.sort((a, b) -> {
            Integer aViews = Integer.parseInt(a.getOrDefault("inqNum", "0").toString());
            Integer bViews = Integer.parseInt(b.getOrDefault("inqNum", "0").toString());
            return bViews.compareTo(aViews);
        });

        // 4. 상위 10개 반환
        return allServices.stream()
            .limit(10)
            .collect(Collectors.toList());

    } catch (Exception e) {
        logger.error("복지로 API 호출 중 오류 발생: ", e);
        return new ArrayList<>();
    }
}
```

#### 2.2 API 파라미터 설명

| 파라미터 | 값 | 설명 |
|---------|---|------|
| `crtiKey` | API_KEY | 인증키 (복지로에서 발급) |
| `callTp` | "L" | 호출 타입 (List: 목록 조회) |
| `pageNum` | 1 | 페이지 번호 |
| `numOfRows` | 10 | 한 페이지당 결과 수 |

#### 2.3 데이터 가공 프로세스

1. **중앙부처 + 지자체 API 동시 호출**
2. **데이터 병합**: 두 API의 응답을 하나의 리스트로 통합
3. **출처 태깅**: `source` 필드 추가 (중앙부처/지자체 구분)
4. **정렬**: `inqNum` (조회수) 기준 내림차순 정렬
5. **필터링**: 상위 10개만 선택

---

### 3. Frontend Layer (project1.jsp)

**역할**: API 호출 및 슬라이더 UI 렌더링

**코드 위치**: `src/main/webapp/project1.jsp:1023-1065` (API 호출), `1143-1277` (슬라이더)

#### 3.1 API 호출 코드

```javascript
function loadPopularWelfareServices() {
    console.log("인기 복지 서비스 로드 시작");

    fetch("/bdproject/welfare/popular")
        .then((response) => {
            if (!response.ok) {
                throw new Error("Network response was not ok");
            }
            return response.json();
        })
        .then((data) => {
            console.log("받은 데이터:", data);
            displayPopularWelfareServices(data);
        })
        .catch((error) => {
            console.error("인기 복지 서비스 로드 실패:", error);
            const popularList = document.getElementById("popular-welfare-list");
            popularList.innerHTML =
                '<div class="loading-popular">' +
                '<p>복지 서비스를 불러올 수 없습니다.</p>' +
                '</div>';
        });
}

// 페이지 로드 시 자동 실행
document.addEventListener("DOMContentLoaded", () => {
    loadPopularWelfareServices();
});
```

#### 3.2 슬라이더 UI 구현

**특징**:
- **4개씩 표시**: 한 화면에 4개의 카드
- **총 12개 데이터**: 3개의 슬라이드 (4개 × 3)
- **좌우 네비게이션**: 화살표 버튼으로 이동
- **인디케이터**: 현재 슬라이드 위치 표시

```javascript
// 슬라이더 상태 관리
let currentSlide = 0;
let totalSlides = 0;
const itemsPerSlide = 4;

function displayPopularWelfareServices(services) {
    // 1. 조회수 기준 정렬 후 상위 12개 선택
    welfareServices = services
        .sort((a, b) => parseInt(b.inqNum) - parseInt(a.inqNum))
        .slice(0, 12);

    // 2. 슬라이드 개수 계산
    totalSlides = Math.ceil(welfareServices.length / itemsPerSlide);

    // 3. 카드 생성
    welfareServices.forEach((service, index) => {
        const item = createWelfareCard(service, index);
        popularList.appendChild(item);
    });

    // 4. 인디케이터 및 네비게이션 초기화
    createSliderIndicators();
    updateSlider();
    updateNavigationButtons();
}

// 슬라이드 이동 함수
function moveSlide(direction) {
    currentSlide += direction;
    if (currentSlide < 0) currentSlide = 0;
    if (currentSlide >= totalSlides) currentSlide = totalSlides - 1;

    updateSlider();
    updateNavigationButtons();
    updateIndicators();
}

// 슬라이더 위치 업데이트 (CSS Transform 사용)
function updateSlider() {
    const slider = document.getElementById("popular-welfare-list");
    const offset = currentSlide * 100; // 100% = 4개 카드
    slider.style.transform = `translateX(-${offset}%)`;
}
```

---

## 데이터 흐름 다이어그램

```
사용자 브라우저
    │
    │ 1. 페이지 로드
    ↓
project1.jsp
    │
    │ 2. AJAX GET 요청 (/bdproject/welfare/popular)
    ↓
WelfareController
    │
    │ 3. Service 호출
    ↓
WelfareService
    │
    ├─→ 4a. 중앙부처 API 호출 (HTTP GET)
    │       https://www.bokjiro.go.kr/openapi/rest/gvmtWelSvc
    │
    └─→ 4b. 지자체 API 호출 (HTTP GET)
            https://www.bokjiro.go.kr/openapi/rest/locgvWelSvc
    │
    │ 5. XML 응답 파싱 → Map<String, Object> 변환
    │ 6. 데이터 병합 및 조회수 기준 정렬
    │ 7. 상위 10개 선택
    ↓
WelfareController
    │
    │ 8. JSON 변환 (Jackson)
    │ 9. HTTP 200 OK 응답
    ↓
project1.jsp
    │
    │ 10. JSON 파싱 및 슬라이더 렌더링
    ↓
브라우저 화면 표시
```

---

## 응답 데이터 구조

### API 원본 응답 (XML → JSON 변환 후)

```json
[
    {
        "servId": "WLF2024000001",
        "servNm": "청년도약계좌",
        "servDgst": "청년의 자산형성을 지원합니다",
        "jurMnofNm": "기획재정부",
        "jurOrgNm": "금융위원회",
        "inqNum": "125847",
        "servDtlLink": "https://www.bokjiro.go.kr/ssis-tbu/...",
        "source": "중앙부처"
    },
    {
        "servId": "WLF2024000002",
        "servNm": "기초생활수급자 지원",
        "servDgst": "기초생활이 어려운 분들을 지원합니다",
        "jurMnofNm": "보건복지부",
        "jurOrgNm": "",
        "inqNum": "98234",
        "servDtlLink": "https://www.bokjiro.go.kr/ssis-tbu/...",
        "source": "중앙부처"
    }
]
```

### Frontend에서 사용하는 필드

| 필드명 | 설명 | 사용 위치 |
|--------|------|----------|
| `servNm` | 서비스명 | 카드 제목 |
| `jurMnofNm` | 소관 부처명 | 카드 부가 정보 |
| `jurOrgNm` | 소관 기관명 | 카드 부가 정보 |
| `inqNum` | 조회수 | 정렬 기준 (표시 안함) |
| `servDtlLink` | 상세 페이지 링크 | 클릭 시 이동 |
| `source` | 출처 (중앙부처/지자체) | (현재 미표시) |

---

## 성능 최적화

### 1. 캐싱 미적용 (실시간 데이터)
- **이유**: 조회수가 실시간으로 변경되므로 매번 API 호출
- **개선 방안**: 필요시 5분 단위 캐싱 적용 가능

### 2. 비동기 로딩
- 페이지 로드와 별도로 AJAX로 데이터 로드
- 로딩 중 스피너 표시로 UX 개선

### 3. 에러 처리
- API 호출 실패 시 빈 배열 반환 (서버 크래시 방지)
- Frontend에서 사용자 친화적 메시지 표시

---

## 보안 고려사항

### 1. API 키 관리
- **현재**: `WelfareService.java`에 하드코딩
- **권장**: 환경변수 또는 `application.properties`로 분리

```java
// 개선 예시
@Value("${welfare.api.key}")
private String API_KEY;
```

### 2. CORS 설정
- Spring Boot에서 CORS 허용 필요 시 `@CrossOrigin` 사용

### 3. Rate Limiting
- 복지로 API 호출 제한 준수 (일일 1,000회 등)

---

## 테스트 방법

### 1. Backend 테스트 (Postman/cURL)

```bash
curl -X GET "http://localhost:8080/bdproject/welfare/popular" \
  -H "Accept: application/json"
```

**예상 응답**: 200 OK + JSON 배열 (최대 10개)

### 2. Frontend 테스트
1. 브라우저에서 `http://localhost:8080/bdproject/project1.jsp` 접속
2. 개발자 도구 → Network 탭에서 `/welfare/popular` 요청 확인
3. Console에서 "인기 복지 서비스 로드 시작" 로그 확인

---

## 향후 개선 사항

1. **캐싱 도입**: Redis를 활용한 5분 단위 캐싱
2. **페이지네이션**: 무한 스크롤 또는 더보기 버튼 추가
3. **필터링 기능**: 생애주기, 가구유형 등으로 필터링
4. **즐겨찾기**: 사용자별 관심 복지 서비스 저장
5. **SSE/WebSocket**: 실시간 조회수 업데이트

---

## 참고 자료

- [복지로 공공 API 문서](https://www.data.go.kr/data/15059096/openapi.do)
- [Spring RestTemplate 가이드](https://spring.io/guides/gs/consuming-rest/)
- [Jackson JSON 라이브러리](https://github.com/FasterXML/jackson)

---

**문서 작성일**: 2025-10-29
**작성자**: 복지24 개발팀
**버전**: 1.0
