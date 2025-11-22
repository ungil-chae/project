# 데이터베이스 네이밍 개선 가이드

## 개요
현재 `schema.sql`의 테이블/컬럼명을 더 직관적이고 간결하게 개선하기 위한 가이드입니다.
포트폴리오 및 논리적 설계 문서 작성 시 참고하세요.

---

## 개선 원칙

### 1. **간결성 (Brevity)**
- 불필요하게 긴 단어 축약
- 자명한 접미사 제거
- 예: `member_id` → `id` (컨텍스트가 명확한 경우)

### 2. **직관성 (Clarity)**
- 누구나 이해할 수 있는 영어 단어 사용
- 약어보다는 짧은 단어 선택
- 예: `verification` → `verify`, `application` → `apply`

### 3. **일관성 (Consistency)**
- 비슷한 개념은 동일한 용어 사용
- 접두사/접미사 규칙 통일
- 예: 모든 날짜 컬럼은 `_at` 사용

---

## 테이블명 개선안

### 현재 → 개선안

| 현재 (schema.sql) | 개선안 | 설명 |
|-------------------|--------|------|
| `member` | `member` | ✅ 적절함 |
| `member_status_history` | `member_log` | 이력 → 로그 (간결) |
| `auto_login_tokens` | `auth_token` | 자동로그인 → 인증 토큰 |
| `email_verifications` | `email_verify` | 인증 테이블 (복수형 제거) |
| `donation_categories` | `code_donation` | 카테고리 → 코드 (명확) |
| `faq_categories` | `code_faq` | 카테고리 → 코드 |
| `donations` | `donation` | 단수형 (더 간결) |
| `donation_reviews` | `donation_review` | 단수형 |
| `welfare_diagnoses` | `diagnosis` | 복지진단 → 진단 (간결) |
| `diagnosis_results` | `diagnosis_result` | 단수형 |
| `welfare_services_cache` | `service_cache` | 복지서비스 → 서비스 (맥락상 명확) |
| `favorite_welfare_services` | `favorite` | 관심 복지 서비스 → 관심 (맥락상 명확) |
| `volunteer_activities` | `volunteer` | 봉사활동 → 봉사 (간결) |
| `volunteer_applications` | `volunteer_apply` | 신청 → 지원 |
| `volunteer_reviews` | `volunteer_review` | 단수형 |
| `notices` | `notice` | 단수형 |
| `faqs` | `faq` | 단수형 |
| `review_helpfuls` | `review_helpful` | 단수형 |
| `system_logs` | `sys_log` | 시스템 → sys (간결) |
| `notifications` | `notification` | 단수형 |

---

## 컬럼명 개선안

### PK/FK (Primary Key / Foreign Key)

| 현재 | 개선안 | 설명 |
|------|--------|------|
| `member_id` | `id` | 테이블 내에서는 단순히 `id` |
| `donation_id` | `id` | |
| `diagnosis_id` | `id` | |
| `activity_id` | `id` | |
| `admin_id` | `admin_id` | FK는 명확한 이름 유지 |
| `member_id` (FK) | `member_id` | FK는 원래 테이블명 유지 |

**원칙**: PK는 `id`, FK는 `테이블명_id`

---

### 상태 관련 컬럼

| 현재 | 개선안 | 설명 |
|------|--------|------|
| `is_verified` | `verified` | `is_` 접두사 생략 가능 (BOOLEAN) |
| `is_active` | `active` | |
| `is_pinned` | `pinned` | |
| `is_anonymous` | `anonymous` | |
| `is_visible` | `visible` | |
| `is_online_available` | `online` | |
| `is_pregnant` | `pregnant` | |
| `is_disabled` | `disabled` | |

**원칙**: BOOLEAN 타입은 `is_` 생략 가능

---

### 개수/수량 컬럼

| 현재 | 개선안 | 설명 |
|------|--------|------|
| `login_fail_count` | `fail_count` | login은 맥락상 명확 |
| `helpful_count` | `helpful` | count는 INT 타입으로 자명 |
| `report_count` | `report` | |
| `view_count` | `views` | 조회수는 복수형이 자연스러움 |
| `favorite_count` | `favorites` | |
| `application_count` | `applies` | |
| `matched_services_count` | `service_count` | matched는 맥락상 명확 |
| `children_count` | `children` | |
| `household_size` | `household` | size는 자명 |
| `max_participants` | `max_people` | 참가자 → 사람 (직관적) |
| `current_participants` | `cur_people` | 현재 → cur (간결) |

**원칙**: `_count` 생략 가능, 수량/개수는 컬럼 타입으로 자명

---

### 시간 관련 컬럼

| 현재 | 개선안 | 설명 |
|------|--------|------|
| `last_login_at` | `login_at` | last는 맥락상 자명 |
| `last_login_fail_at` | `fail_at` | |
| `account_locked_until` | `locked_until` | account는 맥락상 명확 |
| `last_login_ip` | `login_ip` | |
| `last_synced` | `synced_at` | `_at` 일관성 |
| `expires_at` | `expires_at` | ✅ 적절함 |
| `published_at` | `pub_at` | published → pub (간결) |
| `expired_at` | `exp_at` | expired → exp |
| `verified_at` | `verified_at` | ✅ 적절함 |
| `refunded_at` | `refunded_at` | ✅ 적절함 |
| `completed_at` | `done_at` | completed → done (간결) |
| `cancelled_at` | `cancel_at` | cancelled → cancel |

**원칙**: 시간은 `_at`, 기한은 `_until`

---

### 금액/수치 컬럼

| 현재 | 개선안 | 설명 |
|------|--------|------|
| `amount` | `amount` | ✅ 적절함 |
| `monthly_income` | `income` | monthly는 맥락상 명확 |
| `matching_score` | `score` | matching은 테이블명으로 자명 |
| `lifecycle_match_score` | `score_life` | 점수 타입을 접두사로 |
| `household_match_score` | `score_house` | |
| `region_match_score` | `score_region` | |

**원칙**: 맥락상 자명한 수식어 생략

---

### 텍스트 컬럼

| 현재 | 개선안 | 설명 |
|------|--------|------|
| `security_question` | `security_q` | question → q |
| `security_answer` | `security_a` | answer → a |
| `kindness_temperature` | `temperature` | kindness는 맥락상 명확 |
| `profile_image_url` | `profile_url` | image는 자명 |
| `receipt_url` | `receipt_url` | ✅ 적절함 |
| `ip_address` | `ip` | address는 자명 |
| `user_agent` | `agent` | user는 맥락상 명확 |
| `referrer_url` | `referrer` | url은 VARCHAR(500)로 자명 |
| `package_name` | `package` | name은 자명 |
| `activity_name` | `name` | 테이블 내에서는 단순히 name |
| `donor_name` | `name` | 후원자명 (맥락상 명확) |
| `reviewer_name` | `name` | 리뷰어명 |
| `applicant_name` | `name` | 신청자명 |

**원칙**: 맥락상 자명한 접두사/접미사 생략

---

### ENUM 컬럼 값 간소화

#### 현재

 성별:
```sql
ENUM('MALE', 'FEMALE', 'OTHER')
```

#### 개선안
```sql
ENUM('M', 'F', 'O')
```

---

#### 현재 결제 수단:
```sql
ENUM('CREDIT_CARD', 'BANK_TRANSFER', 'KAKAO_PAY', 'NAVER_PAY', 'TOSS_PAY')
```

#### 개선안
```sql
ENUM('CARD', 'BANK', 'KAKAO', 'NAVER', 'TOSS')
```

---

#### 현재 결제 상태:
```sql
ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED', 'CANCELLED')
```

#### 개선안
```sql
ENUM('PENDING', 'DONE', 'FAIL', 'REFUND', 'CANCEL')
```

---

#### 현재 봉사 상태:
```sql
ENUM('RECRUITING', 'CLOSED', 'COMPLETED', 'CANCELLED')
```

#### 개선안
```sql
ENUM('RECRUIT', 'CLOSED', 'DONE', 'CANCEL')
```

---

#### 현재 신청 상태:
```sql
ENUM('APPLIED', 'CONFIRMED', 'COMPLETED', 'CANCELLED', 'REJECTED')
```

#### 개선안
```sql
ENUM('APPLIED', 'OK', 'DONE', 'CANCEL', 'REJECT')
```

---

#### 현재 로그 타입:
```sql
ENUM('LOGIN', 'LOGOUT', 'REGISTER', 'PASSWORD_CHANGE', 'DONATION', 'DIAGNOSIS', 'ERROR', 'ADMIN_ACTION')
```

#### 개선안
```sql
ENUM('LOGIN', 'LOGOUT', 'REGISTER', 'PWD_CHANGE', 'DONATION', 'DIAGNOSIS', 'ERROR', 'ADMIN')
```

---

#### 현재 소득 수준:
```sql
ENUM('LEVEL_1', 'LEVEL_2', 'LEVEL_3', 'LEVEL_4', 'LEVEL_5')
```

#### 개선안
```sql
ENUM('L1', 'L2', 'L3', 'L4', 'L5')
```

---

#### 현재 봉사 경험:
```sql
ENUM('NONE', 'LESS_THAN_1YEAR', '1_TO_3YEARS', 'MORE_THAN_3YEARS')
```

#### 개선안
```sql
ENUM('NONE', 'LT1', '1TO3', 'GT3')
```
- LT = Less Than
- GT = Greater Than

---

#### 현재 봉사 카테고리:
```sql
ENUM('ELDERLY', 'CHILD', 'DISABLED', 'ENVIRONMENT', 'EDUCATION', 'COMMUNITY', 'ETC')
```

#### 개선안
```sql
ENUM('ELDERLY', 'CHILD', 'DISABLED', 'ENV', 'EDU', 'COMMUNITY', 'ETC')
```

---

#### 현재 공지 카테고리:
```sql
ENUM('SYSTEM', 'EVENT', 'MAINTENANCE', 'UPDATE', 'GENERAL')
```

#### 개선안
```sql
ENUM('SYSTEM', 'EVENT', 'MAINT', 'UPDATE', 'GENERAL')
```

---

#### 현재 인증 타입:
```sql
ENUM('SIGNUP', 'PASSWORD_RESET', 'EMAIL_CHANGE')
```

#### 개선안
```sql
ENUM('SIGNUP', 'RESET', 'CHANGE')
```

**원칙**: 맥락상 명확한 경우 축약 가능, 3-6자 단어 선호

---

## 개선 전후 비교 예시

### 예시 1: member 테이블

**현재 (schema.sql)**
```sql
CREATE TABLE member (
    member_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    pwd VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone CHAR(11),
    birth DATE,
    gender ENUM('MALE', 'FEMALE', 'OTHER'),
    role ENUM('USER', 'ADMIN') DEFAULT 'USER',
    status ENUM('ACTIVE', 'SUSPENDED', 'DORMANT') DEFAULT 'ACTIVE',
    security_question VARCHAR(200),
    security_answer VARCHAR(255),
    login_fail_count INT UNSIGNED DEFAULT 0,
    last_login_fail_at TIMESTAMP NULL,
    account_locked_until TIMESTAMP NULL,
    kindness_temperature DECIMAL(5, 2) DEFAULT 36.50,
    profile_image_url VARCHAR(500),
    last_login_at TIMESTAMP NULL,
    last_login_ip VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);
```

**개선안**
```sql
CREATE TABLE member (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    pwd VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone CHAR(11),
    birth DATE,
    gender ENUM('M', 'F', 'O'),
    role ENUM('USER', 'ADMIN') DEFAULT 'USER',
    status ENUM('ACTIVE', 'SUSPENDED', 'DORMANT') DEFAULT 'ACTIVE',
    security_q VARCHAR(200),
    security_a VARCHAR(255),
    fail_count INT UNSIGNED DEFAULT 0,
    fail_at TIMESTAMP NULL,
    locked_until TIMESTAMP NULL,
    temperature DECIMAL(5, 2) DEFAULT 36.50,
    profile_url VARCHAR(500),
    login_at TIMESTAMP NULL,
    login_ip VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);
```

**개선 효과**:
- 컬럼수 동일, 가독성 향상
- 영문 약 20-30% 단축
- 의미는 명확히 유지

---

### 예시 2: donation 테이블

**현재**
```sql
CREATE TABLE donations (
    donation_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    member_id BIGINT UNSIGNED NULL,
    category_id INT UNSIGNED NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    donation_type ENUM('REGULAR', 'ONETIME') NOT NULL,
    package_name VARCHAR(100) NULL,
    donor_name VARCHAR(100) NOT NULL,
    donor_email VARCHAR(100) NOT NULL,
    donor_phone CHAR(11),
    message TEXT,
    payment_method ENUM('CREDIT_CARD', 'BANK_TRANSFER', 'KAKAO_PAY', 'NAVER_PAY', 'TOSS_PAY'),
    payment_status ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED', 'CANCELLED'),
    transaction_id VARCHAR(100) UNIQUE,
    receipt_url VARCHAR(500),
    receipt_issued BOOLEAN DEFAULT FALSE,
    tax_deduction_eligible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    refunded_at TIMESTAMP NULL
);
```

**개선안**
```sql
CREATE TABLE donation (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    member_id BIGINT UNSIGNED NULL,
    category_id INT UNSIGNED NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    type ENUM('REGULAR', 'ONETIME') NOT NULL,
    package VARCHAR(100) NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone CHAR(11),
    message TEXT,
    pay_method ENUM('CARD', 'BANK', 'KAKAO', 'NAVER', 'TOSS'),
    pay_status ENUM('PENDING', 'DONE', 'FAIL', 'REFUND', 'CANCEL'),
    transaction_id VARCHAR(100) UNIQUE,
    receipt_url VARCHAR(500),
    receipt_issued BOOLEAN DEFAULT FALSE,
    tax_eligible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    refunded_at TIMESTAMP NULL
);
```

**개선 효과**:
- `donation_id` → `id` (4자 절약)
- `donation_type` → `type` (8자 절약)
- `donor_name` → `name` (6자 절약)
- ENUM 값들 간소화 (평균 5-8자 절약)
- 전체적으로 약 30% 단축

---

## 논리적 설계 문서 작성 시 권장 사항

### 1. **ERD (Entity-Relationship Diagram)**
- 테이블명은 개선안 사용
- 관계는 명확하게 표시
- 카디널리티 표기

### 2. **테이블 정의서**

#### 권장 포맷:

**테이블명**: member (회원)

| 컬럼명 | 타입 | NULL | 키 | 기본값 | 설명 |
|--------|------|------|-----|--------|------|
| id | BIGINT | NO | PK | AUTO | 회원 ID |
| email | VARCHAR(100) | NO | UNI | - | 이메일 (로그인 ID) |
| pwd | VARCHAR(255) | NO | - | - | 비밀번호 (BCrypt) |
| name | VARCHAR(100) | NO | - | - | 이름 |
| phone | CHAR(11) | YES | IDX | - | 전화번호 |
| birth | DATE | YES | - | - | 생년월일 |
| gender | ENUM | YES | - | - | 성별 (M/F/O) |
| role | ENUM | NO | IDX | USER | 권한 |
| status | ENUM | NO | IDX | ACTIVE | 상태 |
| temperature | DECIMAL(5,2) | NO | - | 36.50 | 선행 온도 |
| created_at | TIMESTAMP | NO | IDX | NOW() | 가입일 |
| deleted_at | TIMESTAMP | YES | IDX | - | 탈퇴일 |

### 3. **인덱스 전략 문서화**
- 어떤 컬럼에 인덱스를 생성했는지
- 복합 인덱스의 이유
- 쿼리 성능 고려 사항

### 4. **제약 조건 명시**
- CHECK 제약조건
- FOREIGN KEY 제약조건
- UNIQUE 제약조건

---

## 적용 방법

### 방법 1: 새 프로젝트에 적용
1. 개선안 스키마를 새 파일로 생성
2. Java DTO 클래스도 동일하게 변경
3. MyBatis 매퍼 XML 업데이트

### 방법 2: 기존 프로젝트에 점진적 적용
1. 논리적 설계 문서에만 개선안 사용
2. 실제 DB는 기존 스키마 유지 (호환성)
3. 새 버전 개발 시 마이그레이션

### 방법 3: 별칭(Alias) 활용
```sql
SELECT
    member_id AS id,
    kindness_temperature AS temperature,
    last_login_at AS login_at
FROM member;
```

---

## 체크리스트

**논리적 설계 작성 시**:
- [ ] 테이블명 단수형 사용
- [ ] PK는 `id`, FK는 `테이블명_id`
- [ ] ENUM 값은 간결하게 (3-6자)
- [ ] Boolean 컬럼은 `is_` 생략 가능
- [ ] `_count`, `_size` 등 자명한 접미사 생략
- [ ] 시간은 `_at`, 기한은 `_until`
- [ ] 맥락상 자명한 수식어 생략

**가독성 검토**:
- [ ] 컬럼명만 보고 의미 파악 가능한가?
- [ ] 지나치게 축약하지 않았나?
- [ ] 일관성 있게 작성되었나?
- [ ] 다른 개발자가 이해하기 쉬운가?

---

## 결론

**개선의 핵심**:
1. **간결함**: 불필요한 단어 제거
2. **명확함**: 누구나 이해 가능한 용어
3. **일관성**: 동일한 개념은 동일한 이름

**주의사항**:
- 지나친 축약은 오히려 가독성 저하
- 도메인 특화 용어는 명확히 유지
- 팀 내 컨벤션이 최우선

**포트폴리오 작성 시**:
- 개선안으로 논리적 설계 문서 작성
- "네이밍 컨벤션 개선"을 강조 포인트로 활용
- Before/After 비교로 개선 효과 시각화

---

**문서 버전**: 1.0
**작성일**: 2025-01-19
**작성자**: Welfare24 Development Team
