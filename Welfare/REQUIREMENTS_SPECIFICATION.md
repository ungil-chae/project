# 복지24 프로젝트 요구사항 정의서

## 프로젝트 정보
- **프로젝트명**: 복지24 (Welfare24)
- **데이터베이스**: MySQL 8.3.0
- **개발 기간**: 2024.09 - 2024.10

---

## 요구사항 정의

| 분할자 | 구분 | 요구사항 | 요구사항 내용 |
|---|---|---|---|
| **회원 관리** | 회원가입 | 아이디 | VARCHAR(50), 기본 키, 중복 불가 |
| | | 비밀번호 | VARCHAR(255), NOT NULL, 암호화 필요 |
| | | 이름 | VARCHAR(100), NOT NULL |
| | | 이메일 | VARCHAR(100), UNIQUE, 중복 체크 필수 |
| | | 전화번호 | VARCHAR(20), NULL 허용 |
| | | 권한 | VARCHAR(10), 기본값 'USER', ADMIN/USER 구분 |
| | | 생년월일 | DATE 형식, 복지 진단 시 나이 계산 |
| | | 가입일 | TIMESTAMP, 자동 생성 (CURRENT_TIMESTAMP) |
| | | 수정일 | TIMESTAMP, 자동 업데이트 (ON UPDATE) |
| | 로그인 | 세션 관리 | JSP session, id/name 저장 |
| | | 아이디 찾기 | 이름 + 이메일로 조회 |
| | | 비밀번호 찾기 | 이름 + 이메일로 임시 비밀번호 발급 |
| **기부 시스템** | 기부 내역 | 기부 ID | BIGINT AUTO_INCREMENT, 기본 키 |
| | | 회원 ID | VARCHAR(50), NULL 허용 (비회원 기부 가능) |
| | | 기부 금액 | DECIMAL(15,2), NOT NULL |
| | | 기부 유형 | ENUM('regular', 'onetime'), 정기/일시 구분 |
| | | 기부 분야 | VARCHAR(50), 9개 카테고리 |
| | | 패키지명 | VARCHAR(100), NULL 허용 |
| | | 후원자명 | VARCHAR(100), NOT NULL |
| | | 후원자 이메일 | VARCHAR(100), NOT NULL |
| | | 후원자 전화번호 | VARCHAR(20), NULL 허용 |
| | | 후원 메시지 | TEXT, NULL 허용 |
| | | 결제 상태 | ENUM('pending', 'completed', 'failed'), 기본값 'completed' |
| | | 기부일 | TIMESTAMP, 자동 생성 |
| | 기부 후기 | 후기 ID | BIGINT AUTO_INCREMENT, 기본 키 |
| | | 회원 ID | VARCHAR(50), NULL 허용 (비회원 후기 가능) |
| | | 기부 ID | BIGINT, NULL 허용 |
| | | 작성자명 | VARCHAR(100), NOT NULL |
| | | 별점 | INT, 1~5점, CHECK 제약조건 |
| | | 후기 내용 | TEXT, NOT NULL |
| | | 익명 여부 | BOOLEAN, 기본값 FALSE |
| | | 도움됨 카운트 | INT, 기본값 0, 추천 수 집계 |
| | | 작성일 | TIMESTAMP, 자동 생성 |
| | | 수정일 | TIMESTAMP, 자동 업데이트 |
| | 도움됨 기능 | 도움됨 ID | BIGINT AUTO_INCREMENT, 기본 키 |
| | | 후기 ID | BIGINT, NOT NULL, 외래 키 |
| | | 회원 ID | VARCHAR(50), NULL 허용 |
| | | IP 주소 | VARCHAR(45), NOT NULL, 중복 방지용 |
| | | 추천일 | TIMESTAMP, 자동 생성 |
| | | 중복 방지 | UNIQUE (review_id, user_id) + UNIQUE (review_id, ip_address) |
| **복지 진단** | 진단 결과 | 진단 ID | BIGINT AUTO_INCREMENT, 기본 키 |
| | | 회원 ID | VARCHAR(50), NULL 허용 (비로그인 진단 가능) |
| | | 생년월일 | DATE, NOT NULL, 나이 계산 |
| | | 성별 | VARCHAR(20), NULL 허용 |
| | | 가구원 수 | INT, NULL 허용 |
| | | 소득 수준 | VARCHAR(50), NOT NULL |
| | | 결혼 상태 | VARCHAR(50), NULL 허용 |
| | | 자녀 수 | INT, 기본값 0 |
| | | 취업 상태 | VARCHAR(50), NULL 허용 |
| | | 시도 | VARCHAR(100), 지역 복지 매칭용 |
| | | 시군구 | VARCHAR(100), 지역 복지 매칭용 |
| | | 임신 여부 | BOOLEAN, 기본값 FALSE, 특수상황 |
| | | 장애 여부 | BOOLEAN, 기본값 FALSE, 특수상황 |
| | | 다문화 가정 | BOOLEAN, 기본값 FALSE, 특수상황 |
| | | 보훈 대상 | BOOLEAN, 기본값 FALSE, 특수상황 |
| | | 한부모 가정 | BOOLEAN, 기본값 FALSE, 특수상황 |
| | | 매칭 서비스 수 | INT, 기본값 0 |
| | | 진단일 | TIMESTAMP, 자동 생성 |
| | 매칭 결과 | 진단 ID | BIGINT, NOT NULL, 복합 기본 키 |
| | | 서비스 ID | VARCHAR(100), NOT NULL, 복합 기본 키 |
| | | 서비스명 | VARCHAR(500), NOT NULL |
| | | 소관 부처 | VARCHAR(200), NULL 허용 |
| | | 매칭 점수 | INT, NOT NULL, 최대 170점 |
| | | 매칭일 | TIMESTAMP, 자동 생성 |
| **복지 서비스** | 서비스 캐시 | 서비스 ID | VARCHAR(100), 기본 키, API 기준 |
| | | 서비스명 | VARCHAR(500), NOT NULL |
| | | 서비스 목적 | TEXT, NULL 허용 |
| | | 소관 부처 | VARCHAR(200), NULL 허용 |
| | | 신청 방법 | VARCHAR(100), NULL 허용 |
| | | 지원 유형 | VARCHAR(100), NULL 허용 |
| | | 생애주기 코드 | VARCHAR(50), NULL 허용 |
| | | 조회수 | INT, 기본값 0, 인기 TOP 10 추적 |
| | | 마지막 동기화 | TIMESTAMP, NULL 허용, API 동기화 시간 |
| | | 등록일 | TIMESTAMP, 자동 생성 |
| | | 수정일 | TIMESTAMP, 자동 업데이트 |
| | 관심 서비스 | 회원 ID | VARCHAR(50), NOT NULL, 복합 기본 키 |
| | | 서비스 ID | VARCHAR(100), NOT NULL, 복합 기본 키 |
| | | 서비스명 | VARCHAR(500), NOT NULL |
| | | 서비스 목적 | TEXT, NULL 허용 |
| | | 소관 부처 | VARCHAR(200), NULL 허용 |
| | | 신청 방법 | VARCHAR(100), NULL 허용 |
| | | 지원 유형 | VARCHAR(100), NULL 허용 |
| | | 생애주기 코드 | VARCHAR(50), NULL 허용 |
| | | 등록일 | TIMESTAMP, 자동 생성 |
| **봉사 활동** | 활동 마스터 | 활동 ID | BIGINT AUTO_INCREMENT, 기본 키 |
| | | 활동명 | VARCHAR(200), NOT NULL |
| | | 활동 설명 | TEXT, NULL 허용 |
| | | 봉사 장소 | VARCHAR(200), NOT NULL |
| | | 봉사 날짜 | DATE, NOT NULL |
| | | 시작 시간 | TIME, NULL 허용 |
| | | 종료 시간 | TIME, NULL 허용 |
| | | 최대 인원 | INT, 기본값 0 |
| | | 현재 인원 | INT, 기본값 0, 신청자 카운트 |
| | | 모집 상태 | ENUM('recruiting', 'closed', 'completed'), 기본값 'recruiting' |
| | | 등록일 | TIMESTAMP, 자동 생성 |
| | 봉사 신청 | 신청 ID | BIGINT AUTO_INCREMENT, 기본 키 |
| | | 활동 ID | BIGINT, NOT NULL, 외래 키 |
| | | 회원 ID | VARCHAR(50), NULL 허용 (비회원 신청 가능) |
| | | 신청자명 | VARCHAR(100), NOT NULL |
| | | 전화번호 | VARCHAR(20), NOT NULL |
| | | 이메일 | VARCHAR(100), NULL 허용 |
| | | 주소 | VARCHAR(255), NULL 허용 |
| | | 봉사 경험 | VARCHAR(50), 없음/1년미만/1-3년/3년이상 |
| | | 선택 분야 | VARCHAR(100), NOT NULL |
| | | 봉사 시작일 | DATE, NOT NULL |
| | | 봉사 종료일 | DATE, NULL 허용 |
| | | 봉사 시간대 | VARCHAR(50), NOT NULL |
| | | 신청 상태 | ENUM('applied', 'confirmed', 'completed', 'cancelled'), 기본값 'applied' |
| | | 완료 일시 | TIMESTAMP, NULL 허용 |
| | | 신청 일시 | TIMESTAMP, 자동 생성 |
| | | 수정일 | TIMESTAMP, 자동 업데이트 |
| | 봉사 후기 | 후기 ID | BIGINT AUTO_INCREMENT, 기본 키 |
| | | 회원 ID | VARCHAR(50), NULL 허용 (비회원 후기 가능) |
| | | 신청 ID | BIGINT, NOT NULL, 외래 키 |
| | | 작성자명 | VARCHAR(100), NOT NULL |
| | | 후기 제목 | VARCHAR(200), NOT NULL |
| | | 후기 내용 | TEXT, NOT NULL |
| | | 별점 | INT, 1~5점, CHECK 제약조건 |
| | | 작성일 | TIMESTAMP, 자동 생성 |
| **공지/FAQ** | 공지사항 | 공지 ID | BIGINT AUTO_INCREMENT, 기본 키 |
| | | 관리자 ID | VARCHAR(50), NOT NULL, 외래 키 |
| | | 제목 | VARCHAR(200), NOT NULL |
| | | 내용 | TEXT, NOT NULL |
| | | 조회수 | INT, 기본값 0 |
| | | 상단 고정 | BOOLEAN, 기본값 FALSE |
| | | 작성일 | TIMESTAMP, 자동 생성 |
| | | 수정일 | TIMESTAMP, 자동 업데이트 |
| | FAQ | FAQ ID | BIGINT AUTO_INCREMENT, 기본 키 |
| | | 카테고리 | VARCHAR(50), NOT NULL, 복지혜택/서비스이용/계정관리/기타 |
| | | 질문 | VARCHAR(500), NOT NULL |
| | | 답변 | TEXT, NOT NULL |
| | | 정렬 순서 | INT, 기본값 0, 관리자가 순서 지정 |
| | | 활성화 여부 | BOOLEAN, 기본값 TRUE |
| | | 작성일 | TIMESTAMP, 자동 생성 |
| | | 수정일 | TIMESTAMP, 자동 업데이트 |

---

## 데이터베이스 제약조건

### 기본 키 (Primary Key)
- **단일 기본 키**: member.id, donations.donation_id, notices.notice_id 등
- **복합 기본 키**: favorite_welfare_services(user_id, service_id), diagnosis_results(diagnosis_id, service_id)

### 외래 키 (Foreign Key) 및 삭제 정책

| 자식 테이블 | 외래 키 컬럼 | 참조 테이블 | 삭제 정책 |
|---|---|---|---|
| donations | user_id | member.id | SET NULL |
| donation_reviews | user_id | member.id | SET NULL |
| donation_reviews | donation_id | donations.donation_id | SET NULL |
| review_helpfuls | review_id | donation_reviews.review_id | CASCADE |
| review_helpfuls | user_id | member.id | SET NULL |
| welfare_diagnoses | user_id | member.id | SET NULL |
| diagnosis_results | diagnosis_id | welfare_diagnoses.diagnosis_id | CASCADE |
| notices | admin_id | member.id | CASCADE |
| volunteer_applications | activity_id | volunteer_activities.activity_id | CASCADE |
| volunteer_applications | user_id | member.id | SET NULL |
| volunteer_reviews | user_id | member.id | SET NULL |
| volunteer_reviews | application_id | volunteer_applications.application_id | CASCADE |
| favorite_welfare_services | user_id | member.id | CASCADE |

### 고유 제약조건 (Unique Constraints)
- member.email - 이메일 중복 방지
- review_helpfuls(review_id, user_id) - 회원 중복 추천 방지
- review_helpfuls(review_id, ip_address) - 비회원 중복 추천 방지

### CHECK 제약조건
- donation_reviews.rating: 1 <= rating <= 5
- volunteer_reviews.rating: 1 <= rating <= 5

### 인덱스 전략

| 테이블 | 인덱스 컬럼 | 목적 |
|---|---|---|
| member | email, role | 로그인 조회, 권한 필터링 |
| donations | user_id, created_at, category | 회원별 기부 내역, 분야별 조회 |
| donation_reviews | rating, created_at | 평점순, 최신순 정렬 |
| welfare_services_cache | view_count (DESC) | 인기 TOP 10 조회 |
| diagnosis_results | matching_score (DESC) | 고득점 매칭 우선 표시 |
| notices | is_pinned, created_at | 고정 공지 우선, 최신순 |
| faqs | category, order_num | 카테고리별, 정렬 순서 |
| volunteer_activities | activity_date, status | 날짜별, 모집 중인 활동 |
| volunteer_applications | activity_id, status | 활동별 신청자, 상태별 |

---

## 비즈니스 규칙

### 1. 회원/비회원 처리
- **비회원 허용**: 기부, 기부 후기, 복지 진단, 봉사 신청, 봉사 후기
- **로그인 필수**: 상세 복지 진단, 관심 서비스 등록, 공지사항 작성(관리자)

### 2. 권한 관리
- **USER**: 일반 사용자, 모든 서비스 이용 가능
- **ADMIN**: 관리자, 공지사항/FAQ 작성 권한

### 3. 데이터 보존 정책
- **SET NULL**: 회원 탈퇴 시 데이터는 보존하되 user_id만 NULL 처리 (기부, 후기, 진단)
- **CASCADE**: 종속성이 강한 데이터는 함께 삭제 (공지사항, 관심 서비스, 매칭 결과)

### 4. 중복 방지
- **복합 기본 키**: 관심 서비스(user_id, service_id), 매칭 결과(diagnosis_id, service_id)
- **UNIQUE 제약**: 도움됨(review_id + user_id/ip_address)

### 5. 자동 계산 필드
- **조회수**: welfare_services_cache.view_count (인기 서비스 추적)
- **도움됨 카운트**: donation_reviews.helpful_count (review_helpfuls 집계)
- **현재 인원**: volunteer_activities.current_participants (신청자 카운트)

---

## 샘플 데이터

### 초기 데이터 (INSERT 구문 포함)
- **회원**: 관리자 1명, 테스트 사용자 1명
- **FAQ**: 7건 (카테고리별)
- **봉사 활동**: 3건 (모집 중)
- **공지사항**: 5건 (상단 고정 1건)
- **기부**: 10건 (비회원 기부)
- **기부 후기**: 9건 (비회원 후기)

---

## 기술 스택
- **DBMS**: MySQL 8.3.0
- **문자셋**: utf8mb4 / utf8mb4_unicode_ci
- **스토리지 엔진**: InnoDB
- **트랜잭션**: AUTO COMMIT
- **외래 키 체크**: 활성화
