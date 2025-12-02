# Kakao Maps API 설정 가이드

## 1. Kakao Developers 계정 생성 및 애플리케이션 등록

### 1.1 Kakao Developers 접속
1. https://developers.kakao.com/ 접속
2. 카카오 계정으로 로그인

### 1.2 애플리케이션 추가
1. 상단 메뉴에서 **"내 애플리케이션"** 클릭
2. **"애플리케이션 추가하기"** 버튼 클릭
3. 앱 정보 입력:
   - **앱 이름**: 복지24 (또는 원하는 이름)
   - **사업자명**: 본인 이름 또는 회사명
4. **"저장"** 클릭

### 1.3 JavaScript 키 확인
1. 생성된 애플리케이션 클릭
2. **"요약 정보"** 탭에서 **"JavaScript 키"** 확인
3. 예시: `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`

## 2. 플랫폼 설정

### 2.1 Web 플랫폼 등록
1. 생성한 애플리케이션 상세 페이지로 이동
2. 왼쪽 메뉴에서 **"플랫폼"** 클릭
3. **"Web 플랫폼 등록"** 버튼 클릭
4. **사이트 도메인** 입력:
   - 개발 환경: `http://localhost:8080`
   - 운영 환경: 실제 도메인 (예: `https://your-domain.com`)
5. **"저장"** 클릭

## 3. 프로젝트에 API 키 적용

### 3.1 project_admin.jsp 파일 수정

**파일 위치**: `Welfare/src/main/webapp/project_admin.jsp`

**변경할 부분 찾기** (약 1265번째 줄):
```html
<!-- Kakao Maps API -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_KAKAO_API_KEY&libraries=services"></script>
```

**수정 방법**:
```html
<!-- Kakao Maps API -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6&libraries=services"></script>
```

⚠️ **주의**: `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6` 부분을 실제 발급받은 JavaScript 키로 교체하세요!

### 3.2 변경사항 저장 및 컴파일

#### 방법 1: IDE에서 빌드
1. Eclipse/IntelliJ에서 프로젝트 Clean & Build
2. 서버 재시작

#### 방법 2: 수동 복사
```bash
# Windows 명령 프롬프트에서
copy Welfare\src\main\webapp\project_admin.jsp Welfare\target\bdproject\project_admin.jsp
```

## 4. 테스트 방법

### 4.1 관리자 페이지 접속
1. 웹 브라우저에서 `http://localhost:8080/bdproject/project_admin.jsp` 접속
2. 관리자 계정으로 로그인
3. 왼쪽 메뉴에서 **"봉사활동 관리"** 클릭

### 4.2 시설 매칭 테스트
1. 봉사 신청 목록에서 **"승인"** 버튼 클릭
2. 모달 창이 열리면 **시설 검색** 입력란에 검색어 입력
   - 예: "노인복지관", "장애인시설", "지역아동센터" 등
3. **검색** 버튼 클릭
4. 지도에 마커가 표시되면 성공!

### 4.3 문제 해결

#### 지도가 표시되지 않는 경우
- **브라우저 콘솔** (F12) 열기
- 다음과 같은 오류가 있는지 확인:
  ```
  Kakao Maps API를 로드할 수 없습니다
  ```
- 원인:
  1. API 키가 올바르지 않음
  2. 플랫폼 도메인이 등록되지 않음
  3. API 키가 활성화되지 않음

#### "Invalid appkey" 오류
- Kakao Developers에서 발급받은 **JavaScript 키**가 맞는지 확인
- **REST API 키**가 아닌 **JavaScript 키**를 사용해야 함

#### "도메인이 등록되지 않았습니다" 오류
- Kakao Developers > 플랫폼 설정에서 `http://localhost:8080` 등록 확인

## 5. 보안 권장사항

### 5.1 운영 환경 배포 시
- **환경 변수**를 통해 API 키 관리:
  ```jsp
  <script type="text/javascript"
    src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%=System.getenv("KAKAO_API_KEY")%>&libraries=services">
  </script>
  ```

### 5.2 GitHub 등 버전 관리 시
- API 키를 직접 커밋하지 말 것
- `.gitignore`에 API 키 파일 추가
- 설정 파일을 별도로 관리

## 6. API 사용량 및 요금

### 무료 쿼터
- Kakao Maps JavaScript API는 **무료**로 사용 가능
- 일일 제한: 300,000건 (충분한 양)

### 사용량 확인
1. Kakao Developers > 내 애플리케이션
2. **"통계"** 탭에서 API 호출 수 확인

## 7. 추가 참고 자료

- [Kakao Maps API 공식 문서](https://apis.map.kakao.com/web/)
- [Kakao Maps API 가이드](https://apis.map.kakao.com/web/guide/)
- [Kakao Maps API 샘플](https://apis.map.kakao.com/web/sample/)

---

## 요약 체크리스트

- [ ] Kakao Developers 계정 생성
- [ ] 애플리케이션 등록
- [ ] JavaScript 키 발급
- [ ] Web 플랫폼 등록 (`http://localhost:8080`)
- [ ] project_admin.jsp 파일에 API 키 적용
- [ ] 서버 재시작
- [ ] 관리자 페이지에서 지도 테스트

모든 단계가 완료되면 봉사활동 시설 매칭 기능을 사용할 수 있습니다!
