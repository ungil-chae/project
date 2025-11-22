# 복지24 데이터베이스 설계서

## 1. 개요

### 1.1 문서 정보
- **프로젝트명**: 복지24 (Welfare24)
- **데이터베이스명**: springmvc
- **DBMS**: MySQL 8.3.0
- **문자셋**: utf8mb4 / utf8mb4_unicode_ci
- **스토리지 엔진**: InnoDB
- **작성일**: 2025-01-31

### 1.2 설계 목적
복지24 플랫폼의 회원 관리, 복지 진단, 기부, 봉사활동, 공지사항 등 핵심 서비스를 지원하기 위한 데이터베이스 설계

### 1.3 주요 특징
- 회원/비회원 모두 서비스 이용 가능한 유연한 구조
- 복합 기본 키를 활용한 최적화
- 참조 무결성 보장 (외래 키 제약조건)
- 일관된 명명 규칙 (created_at, updated_at)
- 논리적 삭제 전략 (SET NULL, CASCADE)

---

## 2. 테이블 목록

| No | 테이블명 | 한글명 | 주요 용도 | 관계 |
|---|---|---|---|---|
| 1 | member | 회원 테이블 | 사용자 인증 및 회원 정보 관리 | 1:N (모든 테이블) |
| 2 | donations | 기부 테이블 | 기부 내역 관리 | N:1 (member) |
| 3 | donation_reviews | 기부 후기 테이블 | 기부 후기 및 평가 | N:1 (member, donations) |
| 4 | welfare_diagnoses | 복지 진단 결과 테이블 | 복지 혜택 진단 결과 저장 | N:1 (member) |
| 5 | notices | 공지사항 테이블 | 관리자 공지사항 | N:1 (member) |
| 6 | faqs | FAQ 테이블 | 자주 묻는 질문 | 독립 |
| 7 | volunteer_activities | 봉사 활동 마스터 테이블 | 봉사 활동 모집 공고 | 1:N (volunteer_applications) |
| 8 | volunteer_applications | 봉사 신청 테이블 | 봉사 활동 신청 내역 | N:1 (member, volunteer_activities) |
| 9 | volunteer_reviews | 봉사 후기 테이블 | 봉사 활동 후기 | N:1 (member, volunteer_applications) |
| 10 | favorite_welfare_services | 관심 복지 서비스 테이블 | 사용자 관심 복지 서비스 북마크 | N:1 (member) |
| 11 | welfare_services_cache | 복지 서비스 캐시 테이블 | 인기 복지 서비스 조회수 추적 | 독립 |
| 12 | diagnosis_results | 복지 진단 매칭 결과 테이블 | 진단별 매칭된 서비스 상세 저장 | N:1 (welfare_diagnoses) |
| 13 | review_helpfuls | 후기 도움됨 테이블 | 후기 추천 이력 및 중복 방지 | N:1 (donation_reviews, member) |

---

## 3. 테이블 상세 명세

### 3.1 member (회원 테이블)

**테이블 설명**: 복지24 서비스의 회원 정보를 관리하는 핵심 테이블. USER와 ADMIN 권한 구분.

| 컬럼명 | 데이터 타입 | NULL | 키 | 기본값 | 설명 |
|---|---|---|---|---|---|
| id | VARCHAR(50) | NOT NULL | PK | - | 사용자 ID (로그인 아이디) |
| pwd | VARCHAR(255) | NOT NULL | - | - | 비밀번호 (암호화 권장) |
| name | VARCHAR(100) | NOT NULL | - | - | 이름 |
| email | VARCHAR(100) | NOT NULL | UQ, IDX | - | 이메일 (중복 불가) |
| phone | VARCHAR(20) | NULL | - | - | 전화번호 |
| role | VARCHAR(10) | NULL | IDX | 'USER' | 사용자 권한 (USER/ADMIN) |
| birth | DATE | NULL | - | - | 생년월일 |
| created_at | TIMESTAMP | NOT NULL | - | CURRENT_TIMESTAMP | 가입일 |
| updated_at | TIMESTAMP | NOT NULL | - | CURRENT_TIMESTAMP ON UPDATE | 수정일 |

**인덱스**:
- `PRIMARY KEY`: id
- `UNIQUE KEY`: email
- `INDEX`: idx_email, idx_role

**비즈니스 규칙**:
- id는 중복 불가 (PRIMARY KEY)
- email은 중복 불가 (UNIQUE 제약)
- role 기본값은 'USER', 관리자는 'ADMIN'
- 회원 탈퇴 시 관련 데이터는 SET NULL 또는 CASCADE 정책 적용

---

### 3.2 donations (기부 테이블)

**테이블 설명**: 회원 및 비회원의 기부 내역을 저장. 정기/일시 기부 지원.

| 컬럼명 | 데이터 타입 | NULL | 키 | 기본값 | 설명 |
|---|---|---|---|---|---|
| donation_id | BIGINT | NOT NULL | PK, AI | - | 기부 ID (자동 증가) |
| user_id | VARCHAR(50) | NULL | FK, IDX | - | 회원 ID (비회원 시 NULL) |
| amount | DECIMAL(15,2) | NOT NULL | - | - | 기부 금액 |
| donation_type | ENUM | NOT NULL | - | - | 정기(regular)/일시(onetime) |
| category | VARCHAR(50) | NOT NULL | IDX | - | 기부 분야 |
| package_name | VARCHAR(100) | NULL | - | - | 후원 패키지명 |
| donor_name | VARCHAR(100) | NOT NULL | - | - | 후원자명 |
| donor_email | VARCHAR(100) | NOT NULL | - | - | 후원자 이메일 |
| donor_phone | VARCHAR(20) | NULL | - | - | 후원자 전화번호 |
| message | TEXT | NULL | - | - | 후원 메시지 |
| payment_status | ENUM | NULL | - | 'completed' | 결제 상태 (pending/completed/failed) |
| created_at | TIMESTAMP | NOT NULL | IDX | CURRENT_TIMESTAMP | 기부일 |

**인덱스**:
- `PRIMARY KEY`: donation_id
- `INDEX`: idx_user_id, idx_created_at, idx_category

**외래 키**:
- `FOREIGN KEY (user_id)` REFERENCES member(id) ON DELETE SET NULL

**비즈니스 규칙**:
- 비회원 기부 허용 (user_id NULL 가능)
- 회원 탈퇴 시 기부 내역은 유지하되 user_id만 NULL 처리
- amount는 양수여야 함 (애플리케이션 레벨 검증)

---

### 3.3 donation_reviews (기부 후기 테이블)

**테이블 설명**: 기부자 또는 수혜자가 작성한 후기 및 평가.

| 컬럼명 | 데이터 타입 | NULL | 키 | 기본값 | 설명 |
|---|---|---|---|---|---|
| review_id | BIGINT | NOT NULL | PK, AI | - | 후기 ID |
| user_id | VARCHAR(50) | NULL | FK, IDX | - | 회원 ID (비회원 후기 허용) |
| donation_id | BIGINT | NULL | FK, IDX | - | 연관된 기부 ID |
| reviewer_name | VARCHAR(100) | NOT NULL | - | - | 리뷰 작성자명 |
| rating | INT | NOT NULL | IDX | - | 별점 (1-5) |
| content | TEXT | NOT NULL | - | - | 리뷰 내용 |
| is_anonymous | BOOLEAN | NULL | - | FALSE | 익명 여부 |
| helpful_count | INT | NULL | - | 0 | 도움됨 카운트 |
| created_at | TIMESTAMP | NOT NULL | IDX | CURRENT_TIMESTAMP | 작성일 |
| updated_at | TIMESTAMP | NOT NULL | - | CURRENT_TIMESTAMP ON UPDATE | 수정일 |

**인덱스**:
- `PRIMARY KEY`: review_id
- `INDEX`: idx_user_id, idx_donation_id, idx_rating, idx_created_at

**외래 키**:
- `FOREIGN KEY (user_id)` REFERENCES member(id) ON DELETE SET NULL
- `FOREIGN KEY (donation_id)` REFERENCES donations(donation_id) ON DELETE SET NULL

**제약 조건**:
- `CHECK (rating >= 1 AND rating <= 5)`: 별점은 1~5 범위

**비즈니스 규칙**:
- 비회원 후기 작성 가능
- 익명 후기 지원 (is_anonymous = TRUE)
- 회원 탈퇴 또는 기부 삭제 시 후기는 유지하되 연관 ID만 NULL 처리

---

### 3.4 welfare_diagnoses (복지 진단 결과 테이블)

**테이블 설명**: 복지 혜택 진단 결과 저장. 생애주기, 소득, 가구 특성 기반 매칭.

| 컬럼명 | 데이터 타입 | NULL | 키 | 기본값 | 설명 |
|---|---|---|---|---|---|
| diagnosis_id | BIGINT | NOT NULL | PK, AI | - | 진단 ID |
| user_id | VARCHAR(50) | NULL | FK, IDX | - | 회원 ID (비로그인 시 NULL) |
| birth_date | DATE | NOT NULL | - | - | 생년월일 |
| gender | VARCHAR(20) | NULL | - | - | 성별 |
| household_size | INT | NULL | - | - | 가구원 수 |
| income_level | VARCHAR(50) | NOT NULL | - | - | 소득 수준 |
| marital_status | VARCHAR(50) | NULL | - | - | 결혼 상태 |
| children_count | INT | NULL | 0 | - | 자녀 수 |
| employment_status | VARCHAR(50) | NULL | - | - | 취업 상태 |
| sido | VARCHAR(100) | NULL | - | - | 시도 |
| sigungu | VARCHAR(100) | NULL | - | - | 시군구 |
| is_pregnant | BOOLEAN | NULL | - | FALSE | 임신 여부 |
| is_disabled | BOOLEAN | NULL | - | FALSE | 장애 여부 |
| is_multicultural | BOOLEAN | NULL | - | FALSE | 다문화 가정 |
| is_veteran | BOOLEAN | NULL | - | FALSE | 보훈 대상 |
| is_single_parent | BOOLEAN | NULL | - | FALSE | 한부모 가정 |
| matched_services_count | INT | NULL | - | 0 | 매칭된 서비스 수 |
| created_at | TIMESTAMP | NOT NULL | IDX | CURRENT_TIMESTAMP | 진단일 |

**인덱스**:
- `PRIMARY KEY`: diagnosis_id
- `INDEX`: idx_user_id, idx_created_at

**외래 키**:
- `FOREIGN KEY (user_id)` REFERENCES member(id) ON DELETE SET NULL

**비즈니스 규칙**:
- 비회원도 진단 가능 (user_id NULL 허용)
- 로그인 사용자는 진단 결과 자동 저장
- 특수 상황(임신, 장애 등) 체크 시 매칭 정확도 향상

---

### 3.5 notices (공지사항 테이블)

**테이블 설명**: 관리자가 작성한 공지사항. 상단 고정 기능 지원.

| 컬럼명 | 데이터 타입 | NULL | 키 | 기본값 | 설명 |
|---|---|---|---|---|---|
| notice_id | BIGINT | NOT NULL | PK, AI | - | 공지사항 ID |
| admin_id | VARCHAR(50) | NOT NULL | FK, IDX | - | 작성한 관리자 ID |
| title | VARCHAR(200) | NOT NULL | - | - | 제목 |
| content | TEXT | NOT NULL | - | - | 내용 |
| views | INT | NULL | - | 0 | 조회수 |
| is_pinned | BOOLEAN | NULL | IDX | FALSE | 상단 고정 여부 |
| created_at | TIMESTAMP | NOT NULL | IDX | CURRENT_TIMESTAMP | 작성일 |
| updated_at | TIMESTAMP | NOT NULL | - | CURRENT_TIMESTAMP ON UPDATE | 수정일 |

**인덱스**:
- `PRIMARY KEY`: notice_id
- `INDEX`: idx_admin_id, idx_created_at, idx_is_pinned

**외래 키**:
- `FOREIGN KEY (admin_id)` REFERENCES member(id) ON DELETE CASCADE

**비즈니스 규칙**:
- 관리자(role='ADMIN')만 작성 가능
- is_pinned=TRUE인 공지사항은 목록 상단 고정
- 관리자 계정 삭제 시 공지사항도 함께 삭제 (CASCADE)

---

### 3.6 faqs (FAQ 테이블)

**테이블 설명**: 자주 묻는 질문과 답변. 카테고리별 분류 및 정렬 순서 지원.

| 컬럼명 | 데이터 타입 | NULL | 키 | 기본값 | 설명 |
|---|---|---|---|---|---|
| faq_id | BIGINT | NOT NULL | PK, AI | - | FAQ ID |
| category | VARCHAR(50) | NOT NULL | IDX | - | 카테고리 (복지혜택/서비스이용/계정관리/기타) |
| question | VARCHAR(500) | NOT NULL | - | - | 질문 |
| answer | TEXT | NOT NULL | - | - | 답변 |
| order_num | INT | NULL | IDX | 0 | 정렬 순서 |
| is_active | BOOLEAN | NULL | IDX | TRUE | 활성화 여부 |
| created_at | TIMESTAMP | NOT NULL | - | CURRENT_TIMESTAMP | 작성일 |
| updated_at | TIMESTAMP | NOT NULL | - | CURRENT_TIMESTAMP ON UPDATE | 수정일 |

**인덱스**:
- `PRIMARY KEY`: faq_id
- `INDEX`: idx_category, idx_order_num, idx_is_active

**비즈니스 규칙**:
- category별로 그룹화하여 표시
- order_num으로 정렬 순서 제어
- is_active=FALSE인 FAQ는 노출하지 않음

---

### 3.7 volunteer_activities (봉사 활동 마스터 테이블)

**테이블 설명**: 봉사 활동 모집 공고 정보. 모집 상태 및 참가 인원 관리.

| 컬럼명 | 데이터 타입 | NULL | 키 | 기본값 | 설명 |
|---|---|---|---|---|---|
| activity_id | BIGINT | NOT NULL | PK, AI | - | 봉사 활동 ID |
| activity_name | VARCHAR(200) | NOT NULL | - | - | 봉사 활동명 |
| description | TEXT | NULL | - | - | 활동 설명 |
| location | VARCHAR(200) | NOT NULL | - | - | 봉사 장소 |
| activity_date | DATE | NOT NULL | IDX | - | 봉사 날짜 |
| start_time | TIME | NULL | - | - | 시작 시간 |
| end_time | TIME | NULL | - | - | 종료 시간 |
| max_participants | INT | NULL | - | 0 | 최대 인원 |
| current_participants | INT | NULL | - | 0 | 현재 신청 인원 |
| status | ENUM | NULL | IDX | 'recruiting' | 모집 상태 (recruiting/closed/completed) |
| created_at | TIMESTAMP | NOT NULL | - | CURRENT_TIMESTAMP | 등록일 |

**인덱스**:
- `PRIMARY KEY`: activity_id
- `INDEX`: idx_activity_date, idx_status

**비즈니스 규칙**:
- current_participants가 max_participants에 도달하면 자동으로 status='closed'
- activity_date가 지나면 status='completed'로 변경
- 삭제 시 관련 신청 내역도 함께 삭제됨 (CASCADE)

---

### 3.8 volunteer_applications (봉사 신청 테이블)

**테이블 설명**: 봉사 활동 신청 내역. 회원/비회원 모두 신청 가능.

| 컬럼명 | 데이터 타입 | NULL | 키 | 기본값 | 설명 |
|---|---|---|---|---|---|
| application_id | BIGINT | NOT NULL | PK, AI | - | 신청 ID |
| activity_id | BIGINT | NOT NULL | FK, IDX | - | 봉사 활동 ID |
| user_id | VARCHAR(50) | NULL | FK, IDX | - | 회원 ID (비로그인 시 NULL) |
| applicant_name | VARCHAR(100) | NOT NULL | - | - | 신청자명 |
| applicant_phone | VARCHAR(20) | NOT NULL | - | - | 전화번호 |
| applicant_email | VARCHAR(100) | NULL | - | - | 이메일 |
| applicant_address | VARCHAR(255) | NULL | - | - | 주소 |
| volunteer_experience | VARCHAR(50) | NULL | - | - | 봉사 경험 (없음/1년미만/1-3년/3년이상) |
| selected_category | VARCHAR(100) | NOT NULL | - | - | 선택한 봉사 분야 |
| volunteer_date | DATE | NOT NULL | IDX | - | 봉사 시작 날짜 |
| volunteer_end_date | DATE | NULL | - | - | 봉사 종료 날짜 |
| volunteer_time | VARCHAR(50) | NOT NULL | - | - | 봉사 시간대 |
| status | ENUM | NULL | IDX | 'applied' | 신청 상태 (applied/confirmed/completed/cancelled) |
| completed_at | TIMESTAMP | NULL | - | - | 봉사 완료 일시 |
| created_at | TIMESTAMP | NOT NULL | IDX | CURRENT_TIMESTAMP | 신청 일시 |
| updated_at | TIMESTAMP | NOT NULL | - | CURRENT_TIMESTAMP ON UPDATE | 수정일 |

**인덱스**:
- `PRIMARY KEY`: application_id
- `INDEX`: idx_activity_id, idx_user_id, idx_status, idx_volunteer_date, idx_created_at

**외래 키**:
- `FOREIGN KEY (activity_id)` REFERENCES volunteer_activities(activity_id) ON DELETE CASCADE
- `FOREIGN KEY (user_id)` REFERENCES member(id) ON DELETE SET NULL

**비즈니스 규칙**:
- 비회원 신청 가능 (user_id NULL 허용)
- 활동 삭제 시 관련 신청도 함께 삭제 (CASCADE)
- 신청 시 volunteer_activities의 current_participants 증가
- 신청 취소 시 current_participants 감소

---

### 3.9 volunteer_reviews (봉사 후기 테이블)

**테이블 설명**: 봉사 활동 완료 후 작성하는 후기.

| 컬럼명 | 데이터 타입 | NULL | 키 | 기본값 | 설명 |
|---|---|---|---|---|---|
| review_id | BIGINT | NOT NULL | PK, AI | - | 후기 ID |
| user_id | VARCHAR(50) | NULL | FK, IDX | - | 회원 ID (비회원 후기 허용) |
| application_id | BIGINT | NOT NULL | FK, IDX | - | 봉사 신청 ID |
| reviewer_name | VARCHAR(100) | NOT NULL | - | - | 후기 작성자명 |
| title | VARCHAR(200) | NOT NULL | - | - | 후기 제목 |
| content | TEXT | NOT NULL | - | - | 후기 내용 |
| rating | INT | NULL | - | - | 별점 (1-5) |
| created_at | TIMESTAMP | NOT NULL | IDX | CURRENT_TIMESTAMP | 작성일 |

**인덱스**:
- `PRIMARY KEY`: review_id
- `INDEX`: idx_user_id, idx_application_id, idx_created_at

**외래 키**:
- `FOREIGN KEY (user_id)` REFERENCES member(id) ON DELETE SET NULL
- `FOREIGN KEY (application_id)` REFERENCES volunteer_applications(application_id) ON DELETE CASCADE

**제약 조건**:
- `CHECK (rating >= 1 AND rating <= 5)`: 별점은 1~5 범위

**비즈니스 규칙**:
- 비회원 후기 작성 가능
- 봉사 신청 삭제 시 후기도 함께 삭제 (CASCADE)
- 신청 상태가 'completed'일 때만 후기 작성 가능 (애플리케이션 레벨 검증)

---

### 3.10 favorite_welfare_services (관심 복지 서비스 테이블)

**테이블 설명**: 사용자가 관심 등록한 복지 서비스 북마크. 복합 기본 키 사용.

| 컬럼명 | 데이터 타입 | NULL | 키 | 기본값 | 설명 |
|---|---|---|---|---|---|
| user_id | VARCHAR(50) | NOT NULL | PK, FK, IDX | - | 회원 ID |
| service_id | VARCHAR(100) | NOT NULL | PK | - | 복지 서비스 ID |
| service_name | VARCHAR(500) | NOT NULL | - | - | 서비스명 |
| service_purpose | TEXT | NULL | - | - | 서비스 목적 |
| department | VARCHAR(200) | NULL | - | - | 소관 부처 |
| apply_method | VARCHAR(100) | NULL | - | - | 신청 방법 |
| support_type | VARCHAR(100) | NULL | - | - | 지원 유형 |
| lifecycle_code | VARCHAR(50) | NULL | - | - | 생애주기 코드 |
| created_at | TIMESTAMP | NOT NULL | IDX | CURRENT_TIMESTAMP | 등록일 |

**인덱스**:
- `PRIMARY KEY`: (user_id, service_id) - 복합 기본 키
- `INDEX`: idx_user_id, idx_created_at

**외래 키**:
- `FOREIGN KEY (user_id)` REFERENCES member(id) ON DELETE CASCADE

**비즈니스 규칙**:
- 복합 기본 키로 중복 등록 방지
- 회원 탈퇴 시 관심 서비스 목록도 함께 삭제 (CASCADE)
- service_id는 외부 API(공공데이터포털)의 복지 서비스 ID

---

### 3.11 welfare_services_cache (복지 서비스 캐시 테이블)

**테이블 설명**: 외부 API에서 조회한 복지 서비스를 캐싱하여 조회수 추적 및 인기 서비스 TOP 10 제공.

| 컬럼명 | 데이터 타입 | NULL | 키 | 기본값 | 설명 |
|---|---|---|---|---|---|
| service_id | VARCHAR(100) | NOT NULL | PK | - | 복지 서비스 ID (API 기준) |
| service_name | VARCHAR(500) | NOT NULL | - | - | 서비스명 |
| service_purpose | TEXT | NULL | - | - | 서비스 목적 |
| department | VARCHAR(200) | NULL | - | - | 소관 부처 |
| apply_method | VARCHAR(100) | NULL | - | - | 신청 방법 |
| support_type | VARCHAR(100) | NULL | - | - | 지원 유형 |
| lifecycle_code | VARCHAR(50) | NULL | - | - | 생애주기 코드 |
| view_count | INT | NULL | - | 0 | 조회수 (인기 서비스 추적) |
| last_synced | TIMESTAMP | NULL | - | - | 마지막 API 동기화 시간 |
| created_at | TIMESTAMP | NOT NULL | - | CURRENT_TIMESTAMP | 등록일 |
| updated_at | TIMESTAMP | NOT NULL | - | CURRENT_TIMESTAMP ON UPDATE | 수정일 |

**인덱스**:
- `PRIMARY KEY`: service_id
- `INDEX`: idx_view_count (내림차순), idx_last_synced

**비즈니스 규칙**:
- 메인 페이지 "인기 복지 서비스 TOP 10"은 view_count 기준 정렬
- 서비스 상세 조회 시 view_count +1 증가
- 주기적으로 외부 API와 동기화 (last_synced 업데이트)
- 조회수가 없는 서비스는 API에서 실시간 조회

---

### 3.12 diagnosis_results (복지 진단 매칭 결과 테이블)

**테이블 설명**: 복지 진단 후 매칭된 서비스 목록을 저장하여 마이페이지에서 진단 이력 조회 가능.

| 컬럼명 | 데이터 타입 | NULL | 키 | 기본값 | 설명 |
|---|---|---|---|---|---|
| diagnosis_id | BIGINT | NOT NULL | PK, FK, IDX | - | 진단 ID (welfare_diagnoses.diagnosis_id) |
| service_id | VARCHAR(100) | NOT NULL | PK | - | 매칭된 복지 서비스 ID |
| service_name | VARCHAR(500) | NOT NULL | - | - | 서비스명 |
| department | VARCHAR(200) | NULL | - | - | 소관 부처 |
| matching_score | INT | NOT NULL | IDX | - | 매칭 점수 (최대 170점) |
| created_at | TIMESTAMP | NOT NULL | - | CURRENT_TIMESTAMP | 매칭일 |

**인덱스**:
- `PRIMARY KEY`: (diagnosis_id, service_id) - 복합 기본 키
- `INDEX`: idx_diagnosis_id, idx_matching_score (내림차순)

**외래 키**:
- `FOREIGN KEY (diagnosis_id)` REFERENCES welfare_diagnoses(diagnosis_id) ON DELETE CASCADE

**비즈니스 규칙**:
- 진단 결과 저장 시 매칭된 모든 서비스를 함께 저장
- 복합 기본 키로 중복 저장 방지
- 진단 삭제 시 매칭 결과도 함께 삭제 (CASCADE)
- matching_score 10점 이상만 저장
- 마이페이지에서 과거 진단 결과 재확인 가능

---

### 3.13 review_helpfuls (후기 도움됨 테이블)

**테이블 설명**: 기부 후기의 "도움됨" 추천 이력을 저장하여 중복 클릭 방지.

| 컬럼명 | 데이터 타입 | NULL | 키 | 기본값 | 설명 |
|---|---|---|---|---|---|
| helpful_id | BIGINT | NOT NULL | PK, AI | - | 도움됨 ID |
| review_id | BIGINT | NOT NULL | FK, IDX | - | 후기 ID (donation_reviews.review_id) |
| user_id | VARCHAR(50) | NULL | FK | - | 회원 ID (비회원 시 NULL) |
| ip_address | VARCHAR(45) | NOT NULL | - | - | IP 주소 (중복 방지용) |
| created_at | TIMESTAMP | NOT NULL | - | CURRENT_TIMESTAMP | 추천일 |

**인덱스**:
- `PRIMARY KEY`: helpful_id
- `UNIQUE KEY`: unique_helpful_user (review_id, user_id)
- `UNIQUE KEY`: unique_helpful_ip (review_id, ip_address)
- `INDEX`: idx_review_id

**외래 키**:
- `FOREIGN KEY (review_id)` REFERENCES donation_reviews(review_id) ON DELETE CASCADE
- `FOREIGN KEY (user_id)` REFERENCES member(id) ON DELETE SET NULL

**비즈니스 규칙**:
- 회원: review_id + user_id로 중복 방지
- 비회원: review_id + ip_address로 중복 방지
- 후기 삭제 시 추천 이력도 함께 삭제 (CASCADE)
- donation_reviews.helpful_count = COUNT(*)로 계산
- 동일 후기에 회원/비회원 상관없이 1인 1회만 추천 가능

---

## 4. 테이블 관계도 (ERD)

### 4.1 주요 관계 요약

```
member (1) ----< (N) donations
member (1) ----< (N) donation_reviews
member (1) ----< (N) welfare_diagnoses
member (1) ----< (N) notices (관리자만)
member (1) ----< (N) volunteer_applications
member (1) ----< (N) volunteer_reviews
member (1) ----< (N) favorite_welfare_services
member (1) ----< (N) review_helpfuls

volunteer_activities (1) ----< (N) volunteer_applications
volunteer_applications (1) ----< (N) volunteer_reviews

donations (1) ----< (N) donation_reviews
donation_reviews (1) ----< (N) review_helpfuls

welfare_diagnoses (1) ----< (N) diagnosis_results

welfare_services_cache (독립 테이블, 외래 키 없음)
```

### 4.2 외래 키 삭제 정책

| 부모 테이블 | 자식 테이블 | 삭제 정책 | 이유 |
|---|---|---|---|
| member | donations | SET NULL | 기부 내역 보존 필요 |
| member | donation_reviews | SET NULL | 후기 보존 필요 |
| member | welfare_diagnoses | SET NULL | 진단 통계 보존 필요 |
| member | notices | CASCADE | 관리자 삭제 시 공지도 삭제 |
| member | volunteer_applications | SET NULL | 신청 내역 보존 필요 |
| member | volunteer_reviews | SET NULL | 후기 보존 필요 |
| member | favorite_welfare_services | CASCADE | 개인 북마크는 삭제 |
| member | review_helpfuls | SET NULL | 추천 이력 보존 필요 |
| volunteer_activities | volunteer_applications | CASCADE | 활동 삭제 시 신청도 삭제 |
| volunteer_applications | volunteer_reviews | CASCADE | 신청 삭제 시 후기도 삭제 |
| donations | donation_reviews | SET NULL | 후기 보존 필요 |
| donation_reviews | review_helpfuls | CASCADE | 후기 삭제 시 추천도 삭제 |
| welfare_diagnoses | diagnosis_results | CASCADE | 진단 삭제 시 결과도 삭제 |

---

## 5. 인덱스 전략

### 5.1 인덱스 설계 원칙
- **검색 조건**에 자주 사용되는 컬럼에 인덱스 생성
- **외래 키**는 모두 인덱스 생성 (JOIN 성능 향상)
- **정렬 기준** (created_at, order_num 등)에 인덱스 생성
- **카디널리티**가 높은 컬럼 우선 (email, id 등)

### 5.2 주요 인덱스 목록

| 테이블 | 인덱스 컬럼 | 용도 |
|---|---|---|
| member | email | 로그인 조회, 중복 체크 |
| member | role | 관리자/사용자 필터링 |
| donations | user_id, created_at | 회원별 기부 내역 조회 |
| donation_reviews | rating, created_at | 평점별 정렬, 최신순 정렬 |
| notices | is_pinned, created_at | 공지사항 목록 (고정글 우선) |
| faqs | category, order_num | 카테고리별 정렬 |
| volunteer_activities | activity_date, status | 날짜별 모집 중인 활동 조회 |
| volunteer_applications | activity_id, status | 활동별 신청자 목록 |
| favorite_welfare_services | user_id, created_at | 회원별 관심 서비스 목록 |
| welfare_services_cache | view_count (DESC) | 인기 복지 서비스 TOP 10 조회 |
| diagnosis_results | diagnosis_id, matching_score | 진단 결과 조회, 고득점순 정렬 |
| review_helpfuls | review_id, user_id | 중복 추천 방지 |

---

## 6. 데이터 타입 선정 기준

### 6.1 문자열 타입
- **VARCHAR(50)**: ID, 코드성 데이터
- **VARCHAR(100)**: 이름, 짧은 텍스트
- **VARCHAR(200~500)**: 제목, 중간 길이 텍스트
- **TEXT**: 내용, 긴 텍스트 (검색 불가)

### 6.2 숫자 타입
- **BIGINT**: ID, 대용량 데이터 예상 (AUTO_INCREMENT)
- **INT**: 카운트, 작은 범위 숫자
- **DECIMAL(15,2)**: 금액 (정확한 소수점 계산)

### 6.3 날짜/시간 타입
- **DATE**: 생년월일, 봉사 날짜
- **TIME**: 봉사 시작/종료 시간
- **TIMESTAMP**: 생성/수정 일시 (자동 업데이트)

### 6.4 특수 타입
- **ENUM**: 고정된 선택지 (status, donation_type 등)
- **BOOLEAN**: 참/거짓 (is_pinned, is_active 등)

---

## 7. 보안 및 성능 고려사항

### 7.1 보안
- [ ] **비밀번호 암호화**: BCrypt 또는 PBKDF2 권장
- [ ] **SQL Injection 방지**: PreparedStatement 사용
- [ ] **개인정보 암호화**: 민감 정보(주민번호 등) 암호화 저장
- [ ] **접근 권한 제어**: DB 사용자별 권한 최소화

### 7.2 성능
- [ ] **커넥션 풀링**: HikariCP 등 사용
- [ ] **쿼리 최적화**: EXPLAIN으로 실행 계획 확인
- [ ] **인덱스 모니터링**: 사용하지 않는 인덱스 제거
- [ ] **파티셔닝**: 대용량 데이터 시 날짜별 파티셔닝 고려

### 7.3 백업 및 복구
- [ ] **정기 백업**: 일 1회 전체 백업
- [ ] **증분 백업**: 시간별 바이너리 로그 백업
- [ ] **복구 테스트**: 백업 복구 시나리오 정기 테스트

---

## 8. 변경 이력

| 버전 | 날짜 | 변경 내용 | 작성자 |
|---|---|---|---|
| 1.0 | 2025-01-31 | 초안 작성 | - |
| 1.1 | 2025-01-31 | users 테이블 삭제, member 테이블로 통합 | - |
| 1.2 | 2025-01-31 | BOOLEAN 타입 통일, created_at/updated_at 명명 통일 | - |
| 1.3 | 2025-01-31 | favorite_welfare_services 복합 기본 키 적용 | - |
| 1.4 | 2025-01-31 | 후기 테이블 정책 일관성 확보 (reviewer_name 추가) | - |
| 1.5 | 2025-01-31 | volunteer_applications에 activity_id 외래 키 추가 | - |
| 1.6 | 2025-01-31 | 치명적 모순 수정: welfare_services_cache, diagnosis_results, review_helpfuls 테이블 추가 | - |

---

## 9. 참고 자료

- **프로젝트 저장소**: C:\workspace\Study\Welfare
- **스키마 파일**: src/main/resources/schema.sql
- **MyBatis 매퍼**: src/main/resources/mapper/
- **데이터베이스 접속 정보**:
  - Host: localhost:3306
  - Database: springmvc
  - User: root
  - Charset: utf8mb4
