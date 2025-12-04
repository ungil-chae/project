-- ================================================
-- 복지24 데이터베이스 스키마 (최적화 버전)
-- 버전: 2.1.0
-- 최종 수정일: 2025-01-21
-- 변경사항:
--   v2.0.0: 미사용 테이블 5개 제거, 미사용 컬럼 4개 제거
--   v2.1.0: 알림 설정 테이블(notification_settings) 추가
-- ================================================

SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;

-- 데이터베이스 완전 초기화
DROP DATABASE IF EXISTS springmvc;
CREATE DATABASE springmvc CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE springmvc;

-- 1-1. 회원 테이블 (모든 테이블의 기준)
CREATE TABLE member (
    -- 기본키
    member_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '회원 고유번호',

    -- 로그인 정보
    email VARCHAR(100) NOT NULL UNIQUE COMMENT '이메일 (로그인 ID)',
    pwd VARCHAR(255) NOT NULL COMMENT '비밀번호 (BCrypt 해시)',

    -- 기본 정보
    name VARCHAR(100) NOT NULL COMMENT '이름',
    phone CHAR(11) NOT NULL COMMENT '전화번호 (하이픈 제거, 01012345678)',
    birth DATE NOT NULL COMMENT '생년월일',
    gender ENUM('MALE', 'FEMALE', 'OTHER') NOT NULL DEFAULT 'OTHER' COMMENT '성별',

    -- 주소 정보
    postcode VARCHAR(10) NULL COMMENT '우편번호',
    address VARCHAR(255) NULL COMMENT '기본 주소',
    detail_address VARCHAR(255) NULL COMMENT '상세 주소',

    -- 권한 및 상태
    role ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER' COMMENT '사용자 권한',
    status ENUM('ACTIVE', 'SUSPENDED', 'DORMANT') NOT NULL DEFAULT 'ACTIVE' COMMENT '계정 상태',

    login_fail_count INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '로그인 실패 횟수',

    -- 부가 정보
    kindness_temperature DECIMAL(5, 2) NOT NULL DEFAULT 36.50 COMMENT '선행 온도',
    profile_image_url VARCHAR(500) NULL COMMENT '프로필 이미지 URL',
    volunteer_ban_until DATETIME NULL DEFAULT NULL COMMENT '봉사활동 신청 금지 해제일시',

    -- 시스템 정보
    last_login_at TIMESTAMP NULL COMMENT '마지막 로그인 일시',
    last_login_ip VARCHAR(45) NULL COMMENT '마지막 로그인 IP (IPv6 지원)',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    deleted_at TIMESTAMP NULL COMMENT '탈퇴일 (소프트 삭제)',

    INDEX idx_email (email),
    INDEX idx_phone (phone),
    INDEX idx_role (role),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    INDEX idx_deleted_at (deleted_at),
    INDEX idx_last_login_at (last_login_at),

    CHECK (kindness_temperature BETWEEN 0.00 AND 100.00),
    CHECK (login_fail_count <= 10)
) ENGINE=InnoDB COMMENT='회원 테이블';

-- 1-2. 회원 상태 변경 이력 테이블
CREATE TABLE member_status_history (
    -- 기본키
    history_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '이력 ID',

    -- 외래키
    member_id BIGINT UNSIGNED NOT NULL COMMENT '회원 고유번호',
    admin_id BIGINT UNSIGNED NULL COMMENT '처리한 관리자 ID',

    -- 상태 변경 정보
    old_status ENUM('ACTIVE', 'SUSPENDED', 'DORMANT') NOT NULL COMMENT '변경 전 상태',
    new_status ENUM('ACTIVE', 'SUSPENDED', 'DORMANT') NOT NULL COMMENT '변경 후 상태',
    reason VARCHAR(500) NULL COMMENT '변경 사유',

    -- 시스템 정보
    ip_address VARCHAR(45) NULL COMMENT '변경 시 IP 주소',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '변경 일시',

    -- 인덱스
    INDEX idx_member_id (member_id),
    INDEX idx_admin_id (admin_id),
    INDEX idx_created_at (created_at),

    -- 외래키 제약조건
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES member(member_id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='회원 상태 변경 이력 테이블';

-- 1-2-1. 비밀번호 변경 이력 테이블 (이전 비밀번호 재사용 방지)
CREATE TABLE password_history (
    -- 기본키
    history_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '이력 ID',

    -- 외래키
    member_id BIGINT UNSIGNED NOT NULL COMMENT '회원 고유번호',

    -- 비밀번호 정보
    password_hash VARCHAR(255) NOT NULL COMMENT '비밀번호 해시 (BCrypt)',

    -- 시스템 정보
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '변경 일시',

    -- 인덱스
    INDEX idx_member_id (member_id),
    INDEX idx_created_at (created_at),

    -- 외래키 제약조건
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='비밀번호 변경 이력 테이블 (최근 5개 비밀번호 재사용 방지)';

-- 1-3. 자동 로그인 토큰 테이블
CREATE TABLE auto_login_tokens (
    -- 기본키
    token_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '토큰 ID',

    -- 외래키
    member_id BIGINT UNSIGNED NOT NULL COMMENT '회원 고유번호',

    -- 토큰 정보
    token VARCHAR(255) UNIQUE NOT NULL COMMENT '자동 로그인 토큰 (UUID)',

    -- 유효 기간
    expires_at TIMESTAMP NOT NULL COMMENT '만료 일시',

    -- 시스템 정보
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',

    INDEX idx_token (token),
    INDEX idx_member_id (member_id),
    INDEX idx_expires_at (expires_at),

    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='자동 로그인 토큰 테이블 (last_used_at 컬럼 제거 - 미사용)';

-- 1-4. 이메일 인증 테이블
CREATE TABLE email_verifications (
    -- 기본키
    verification_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '인증 ID',

    -- 이메일 정보
    email VARCHAR(100) NOT NULL COMMENT '인증할 이메일',

    -- 인증 정보
    verification_code VARCHAR(6) NOT NULL COMMENT '6자리 인증 코드',

    -- 인증 유형
    verification_type ENUM('SIGNUP', 'PASSWORD_RESET', 'EMAIL_CHANGE') NOT NULL COMMENT '인증 유형',

    -- 상태
    is_verified BOOLEAN NOT NULL DEFAULT FALSE COMMENT '인증 완료 여부',

    -- 유효 기간
    expires_at TIMESTAMP NOT NULL COMMENT '만료 일시 (발급 후 10분)',

    -- 시스템 정보
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    verified_at TIMESTAMP NULL COMMENT '인증 완료 일시',

    INDEX idx_email (email),
    INDEX idx_verification_code (verification_code),
    INDEX idx_expires_at (expires_at),
    INDEX idx_is_verified (is_verified)
) ENGINE=InnoDB COMMENT='이메일 인증 테이블';

-- ========================================================================
-- PART 2: 마스터 코드 테이블 (참조용 기준 데이터)
-- ========================================================================

-- 2-1. 기부 카테고리 마스터
CREATE TABLE donation_categories (
    category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '카테고리 ID',
    category_code VARCHAR(30) UNIQUE NOT NULL COMMENT '카테고리 코드',
    category_name VARCHAR(50) NOT NULL COMMENT '카테고리명',
    display_order INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '정렬 순서',
    is_active BOOLEAN NOT NULL DEFAULT TRUE COMMENT '활성화 여부',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',

    INDEX idx_display_order (display_order),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB COMMENT='기부 카테고리 마스터';

-- 2-2. FAQ 카테고리 마스터
CREATE TABLE faq_categories (
    category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '카테고리 ID',
    category_code VARCHAR(30) UNIQUE NOT NULL COMMENT '카테고리 코드',
    category_name VARCHAR(50) NOT NULL COMMENT '카테고리명',
    display_order INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '정렬 순서',
    is_active BOOLEAN NOT NULL DEFAULT TRUE COMMENT '활성화 여부',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',

    INDEX idx_display_order (display_order),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB COMMENT='FAQ 카테고리 마스터';

-- ========================================================================
-- PART 3: 기부 도메인
-- ========================================================================

-- 3-1. 기부 테이블
CREATE TABLE donations (
    -- 기본키
    donation_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '기부 ID',

    -- 외래키
    member_id BIGINT UNSIGNED NULL COMMENT '회원 고유번호 (비회원 시 NULL)',
    category_id INT UNSIGNED NOT NULL COMMENT '기부 카테고리 ID',

    -- 기부 정보
    amount DECIMAL(15, 2) NOT NULL COMMENT '기부 금액',
    donation_type ENUM('REGULAR', 'ONETIME') NOT NULL COMMENT '정기/일시',
    package_name VARCHAR(100) NULL COMMENT '후원 패키지명',
    message TEXT NULL COMMENT '후원 메시지',

    -- 후원자 정보 (비회원 포함)
    donor_name VARCHAR(100) NOT NULL COMMENT '후원자명',
    donor_email VARCHAR(100) NOT NULL COMMENT '후원자 이메일',
    donor_phone CHAR(11) NOT NULL COMMENT '후원자 전화번호 (하이픈 제거)',

    -- 결제 정보
    payment_method ENUM('CREDIT_CARD', 'BANK_TRANSFER', 'KAKAO_PAY', 'NAVER_PAY', 'TOSS_PAY')
        NOT NULL DEFAULT 'CREDIT_CARD' COMMENT '결제수단',
    payment_status ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED', 'CANCELLED')
        NOT NULL DEFAULT 'COMPLETED' COMMENT '결제 상태',
    transaction_id VARCHAR(100) UNIQUE NULL COMMENT '결제 트랜잭션 ID (PG사 제공)',

    -- 영수증 정보
    receipt_issued BOOLEAN NOT NULL DEFAULT FALSE COMMENT '영수증 발급 여부',

    -- 서명 정보
    signature_image LONGTEXT NULL COMMENT '서명 이미지 (Base64)',

    -- 정기 기부 정보
    regular_start_date DATE NULL COMMENT '정기 기부 시작일 (정기 기부인 경우)',

    -- 환불 정보
    refund_amount INT NULL DEFAULT NULL COMMENT '환불 금액 (수수료 제외)',
    refund_fee INT NULL DEFAULT NULL COMMENT '환불 수수료 (24시간 이후 10%)',

    -- 시스템 정보
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '기부일',
    refunded_at TIMESTAMP NULL COMMENT '환불일',

    INDEX idx_member_id (member_id),
    INDEX idx_category_id (category_id),
    INDEX idx_donation_type (donation_type),
    INDEX idx_payment_status (payment_status),
    INDEX idx_created_at (created_at DESC),
    INDEX idx_donor_email (donor_email),
    INDEX idx_donor_phone (donor_phone),
    INDEX idx_amount (amount DESC),
    INDEX idx_composite_member_date (member_id, created_at DESC),

    CHECK (amount > 0),
    CHECK (amount <= 999999999999.99),

    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES donation_categories(category_id)
) ENGINE=InnoDB COMMENT='기부 테이블 (receipt_url, tax_deduction_eligible, updated_at 제거 - 미사용)';

-- 3-2. 기부 후기 테이블
CREATE TABLE donation_reviews (
    -- 기본키
    review_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '후기 ID',

    -- 외래키
    member_id BIGINT UNSIGNED NULL COMMENT '회원 고유번호 (비회원 후기 허용)',
    donation_id BIGINT UNSIGNED NULL COMMENT '연관된 기부 ID',

    -- 후기 정보
    reviewer_name VARCHAR(100) NOT NULL COMMENT '리뷰 작성자명',
    title VARCHAR(200) NOT NULL COMMENT '후기 제목',
    content TEXT NOT NULL COMMENT '리뷰 내용',
    rating INT UNSIGNED NOT NULL COMMENT '별점 1-5',

    -- 부가 정보
    is_anonymous BOOLEAN NOT NULL DEFAULT FALSE COMMENT '익명 여부',
    is_visible BOOLEAN NOT NULL DEFAULT TRUE COMMENT '노출 여부 (관리자 숨김 처리)',
    helpful_count INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '도움됨 카운트',
    report_count INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '신고 횟수',

    -- 시스템 정보
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    deleted_at TIMESTAMP NULL COMMENT '삭제일 (소프트 삭제)',

    INDEX idx_member_id (member_id),
    INDEX idx_donation_id (donation_id),
    INDEX idx_rating (rating DESC),
    INDEX idx_created_at (created_at DESC),
    INDEX idx_deleted_at (deleted_at),
    INDEX idx_helpful_count (helpful_count DESC),
    INDEX idx_is_visible (is_visible),

    CHECK (rating BETWEEN 1 AND 5),
    CHECK (helpful_count >= 0),
    CHECK (report_count <= 100),

    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE SET NULL,
    FOREIGN KEY (donation_id) REFERENCES donations(donation_id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='기부 후기 테이블';

-- ========================================================================
-- PART 4: 복지 진단 도메인
-- ========================================================================

-- 4-1. 복지 진단 결과 테이블
CREATE TABLE welfare_diagnoses (
    -- 기본키
    diagnosis_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '진단 ID',

    -- 외래키
    member_id BIGINT UNSIGNED NULL COMMENT '회원 고유번호 (비로그인 시 NULL)',

    -- 기본 정보
    birth_date DATE NOT NULL COMMENT '생년월일',
    age INT UNSIGNED NOT NULL COMMENT '나이 (성능을 위해 저장)',
    gender ENUM('MALE', 'FEMALE', 'OTHER') NOT NULL DEFAULT 'OTHER' COMMENT '성별',

    -- 가구 정보
    household_size INT UNSIGNED NULL COMMENT '가구원 수',
    marital_status ENUM('SINGLE', 'MARRIED', 'DIVORCED', 'WIDOWED', 'SEPARATED') NULL COMMENT '결혼 상태',
    children_count INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '자녀 수',

    -- 경제 정보
    income_level ENUM('LEVEL_1', 'LEVEL_2', 'LEVEL_3', 'LEVEL_4', 'LEVEL_5') NOT NULL COMMENT '소득 수준 (5단계)',
    monthly_income DECIMAL(12, 2) NULL COMMENT '월 소득 (원)',
    employment_status ENUM('EMPLOYED', 'UNEMPLOYED', 'SELF_EMPLOYED', 'STUDENT', 'RETIRED', 'HOMEMAKER') NULL COMMENT '취업 상태',

    -- 지역 정보
    sido VARCHAR(50) NULL COMMENT '시도',
    sigungu VARCHAR(50) NULL COMMENT '시군구',

    -- 특성 정보
    is_pregnant BOOLEAN NOT NULL DEFAULT FALSE COMMENT '임신 여부',
    is_disabled BOOLEAN NOT NULL DEFAULT FALSE COMMENT '장애 여부',
    disability_grade INT UNSIGNED NULL COMMENT '장애 등급 (1-6)',
    is_multicultural BOOLEAN NOT NULL DEFAULT FALSE COMMENT '다문화 가정',
    is_veteran BOOLEAN NOT NULL DEFAULT FALSE COMMENT '보훈 대상',
    is_single_parent BOOLEAN NOT NULL DEFAULT FALSE COMMENT '한부모 가정',
    is_elderly_living_alone BOOLEAN NOT NULL DEFAULT FALSE COMMENT '독거노인 여부',
    is_low_income BOOLEAN NOT NULL DEFAULT FALSE COMMENT '저소득층 여부',

    -- 매칭 결과
    matched_services JSON NULL COMMENT '매칭된 서비스 JSON 배열',
    matched_services_count INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '매칭된 서비스 수',
    total_matching_score INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '전체 매칭 점수 합계',

    -- 개인정보 동의
    save_consent BOOLEAN NOT NULL DEFAULT TRUE COMMENT '저장 동의 여부',
    privacy_consent BOOLEAN NOT NULL DEFAULT FALSE COMMENT '개인정보 수집 동의',
    marketing_consent BOOLEAN NOT NULL DEFAULT FALSE COMMENT '마케팅 활용 동의',

    -- 시스템 정보
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '진단일',

    INDEX idx_member_id (member_id),
    INDEX idx_created_at (created_at DESC),
    INDEX idx_sido (sido),
    INDEX idx_sigungu (sigungu),
    INDEX idx_income_level (income_level),
    INDEX idx_age (age),
    INDEX idx_composite_member_date (member_id, created_at DESC),
    INDEX idx_matched_count (matched_services_count DESC),

    CHECK (household_size IS NULL OR household_size > 0),
    CHECK (children_count >= 0),
    CHECK (age IS NULL OR age BETWEEN 0 AND 150),
    CHECK (disability_grade IS NULL OR disability_grade BETWEEN 1 AND 6),
    CHECK (monthly_income IS NULL OR monthly_income >= 0),

    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='복지 진단 결과 테이블 (ip_address, user_agent, referrer_url 컬럼 제거 - 개인정보 이슈)';

-- 4-2. 복지 진단 매칭 결과 테이블 (제거됨 - welfare_diagnoses.matched_services JSON으로 대체, Java 코드에서 미사용)

-- 4-3. 복지 서비스 캐시 테이블 (제거됨 - API 실시간 호출 사용, Java 코드에서 미사용)

-- 4-4. 관심 복지 서비스 테이블
CREATE TABLE favorite_welfare_services (
    -- 복합키
    member_id BIGINT UNSIGNED NOT NULL COMMENT '회원 고유번호',
    service_id VARCHAR(100) NOT NULL COMMENT '복지 서비스 ID',

    -- 서비스 정보
    service_name VARCHAR(500) NOT NULL COMMENT '서비스명',
    service_purpose TEXT NULL COMMENT '서비스 목적',
    department VARCHAR(200) NULL COMMENT '소관 부처',
    apply_method VARCHAR(100) NULL COMMENT '신청 방법',
    support_type VARCHAR(100) NULL COMMENT '지원 유형',
    lifecycle_code VARCHAR(50) NULL COMMENT '생애주기 코드',

    -- 사용자 메모
    memo TEXT NULL COMMENT '메모 (사용자가 작성)',

    -- 시스템 정보
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',

    PRIMARY KEY (member_id, service_id),
    INDEX idx_member_id (member_id),
    INDEX idx_created_at (created_at DESC),

    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='관심 복지 서비스 테이블';

-- ========================================================================
-- PART 5: 봉사 활동 도메인
-- ========================================================================

-- 5-1. 봉사 활동 마스터 테이블
CREATE TABLE volunteer_activities (
    -- 기본키
    activity_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '봉사 활동 ID',

    -- 활동 정보
    activity_name VARCHAR(200) NOT NULL COMMENT '봉사 활동명',
    description TEXT NULL COMMENT '활동 설명',
    category ENUM('ELDERLY', 'CHILD', 'DISABLED', 'ENVIRONMENT', 'EDUCATION', 'COMMUNITY', 'ETC') NOT NULL DEFAULT 'ETC' COMMENT '봉사 분야',

    -- 장소 정보
    location VARCHAR(200) NOT NULL COMMENT '봉사 장소',
    location_detail VARCHAR(500) NULL COMMENT '상세 주소',
    sido VARCHAR(50) NULL COMMENT '시도',
    sigungu VARCHAR(50) NULL COMMENT '시군구',

    -- 일정 정보
    activity_date DATE NOT NULL COMMENT '봉사 날짜',
    start_time TIME NULL COMMENT '시작 시간',
    end_time TIME NULL COMMENT '종료 시간',
    duration_hours INT UNSIGNED NULL COMMENT '봉사 시간 (시간 단위)',

    -- 모집 정보
    max_participants INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '최대 인원',
    current_participants INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '현재 신청 인원',
    min_age INT UNSIGNED NULL COMMENT '최소 연령',
    max_age INT UNSIGNED NULL COMMENT '최대 연령',
    status ENUM('RECRUITING', 'CLOSED', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'RECRUITING' COMMENT '모집 상태',

    -- 담당자 정보
    contact_person VARCHAR(100) NULL COMMENT '담당자명',
    contact_phone CHAR(11) NULL COMMENT '담당자 전화번호',

    -- 시스템 정보
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',

    INDEX idx_activity_date (activity_date DESC),
    INDEX idx_status (status),
    INDEX idx_category (category),
    INDEX idx_sido (sido),
    INDEX idx_composite_search (status, activity_date DESC),
    INDEX idx_location (sido, sigungu),

    CHECK (max_participants >= 0),
    CHECK (current_participants >= 0),
    CHECK (current_participants <= max_participants),
    CHECK (duration_hours IS NULL OR duration_hours > 0),
    CHECK (min_age IS NULL OR min_age >= 0),
    CHECK (max_age IS NULL OR max_age <= 150),
    CHECK (min_age IS NULL OR max_age IS NULL OR min_age <= max_age),
    CHECK (start_time IS NULL OR end_time IS NULL OR end_time > start_time)
) ENGINE=InnoDB COMMENT='봉사 활동 마스터 테이블';

-- 5-2. 봉사 신청 테이블
CREATE TABLE volunteer_applications (
    -- 기본키
    application_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '신청 ID',

    -- 외래키
    activity_id BIGINT UNSIGNED NULL COMMENT '봉사 활동 ID (일반 신청의 경우 NULL)',
    member_id BIGINT UNSIGNED NULL COMMENT '회원 고유번호 (비로그인 시 NULL)',

    -- 신청자 정보
    applicant_name VARCHAR(100) NOT NULL COMMENT '신청자명',
    applicant_email VARCHAR(100) NULL COMMENT '이메일',
    applicant_phone CHAR(11) NOT NULL COMMENT '전화번호 (하이픈 제거)',
    applicant_birth DATE NULL COMMENT '생년월일',
    applicant_gender ENUM('MALE', 'FEMALE', 'OTHER') NULL COMMENT '성별',
    applicant_address VARCHAR(255) NULL COMMENT '주소',

    -- 봉사 정보
    volunteer_experience ENUM('NONE', 'LESS_THAN_1YEAR', '1_TO_3YEARS', 'MORE_THAN_3YEARS') NULL COMMENT '봉사 경험',
    selected_category VARCHAR(100) NOT NULL COMMENT '선택한 봉사 분야',
    motivation TEXT NULL COMMENT '지원 동기',

    -- 일정 정보
    volunteer_date DATE NOT NULL COMMENT '봉사 시작 날짜',
    volunteer_end_date DATE NULL COMMENT '봉사 종료 날짜',
    volunteer_time VARCHAR(50) NOT NULL COMMENT '봉사 시간대',

    -- 상태 정보
    status ENUM('APPLIED', 'CONFIRMED', 'COMPLETED', 'CANCELLED', 'REJECTED') NOT NULL DEFAULT 'APPLIED' COMMENT '신청 상태',
    attendance_checked BOOLEAN NOT NULL DEFAULT FALSE COMMENT '출석 확인 여부',
    actual_hours INT UNSIGNED NULL COMMENT '실제 봉사 시간',

    -- 사유
    cancel_reason TEXT NULL COMMENT '취소 사유',
    reject_reason TEXT NULL COMMENT '거절 사유',

    -- 관리자 승인 및 시설 매칭 정보
    approved_by BIGINT UNSIGNED NULL COMMENT '승인한 관리자 ID',
    approved_at TIMESTAMP NULL COMMENT '승인 일시',
    assigned_facility_name VARCHAR(200) NULL COMMENT '배정된 복지시설명',
    assigned_facility_address VARCHAR(500) NULL COMMENT '배정된 시설 주소',
    assigned_facility_lat DECIMAL(10, 8) NULL COMMENT '시설 위도',
    assigned_facility_lng DECIMAL(11, 8) NULL COMMENT '시설 경도',
    admin_note TEXT NULL COMMENT '관리자 메모',

    -- 시스템 정보
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '신청 일시',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    completed_at TIMESTAMP NULL COMMENT '봉사 완료 일시',
    cancelled_at TIMESTAMP NULL COMMENT '취소 일시',

    INDEX idx_activity_id (activity_id),
    INDEX idx_member_id (member_id),
    INDEX idx_status (status),
    INDEX idx_volunteer_date (volunteer_date DESC),
    INDEX idx_created_at (created_at DESC),
    INDEX idx_applicant_email (applicant_email),
    INDEX idx_applicant_phone (applicant_phone),
    INDEX idx_approved_by (approved_by),
    INDEX idx_approved_at (approved_at DESC),
    INDEX idx_composite_activity_status (activity_id, status),
    INDEX idx_composite_member_status (member_id, status),

    CHECK (actual_hours IS NULL OR actual_hours <= 24),
    CHECK (volunteer_end_date IS NULL OR volunteer_end_date >= volunteer_date),

    FOREIGN KEY (activity_id) REFERENCES volunteer_activities(activity_id) ON DELETE SET NULL,
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE SET NULL,
    FOREIGN KEY (approved_by) REFERENCES member(member_id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='봉사 신청 테이블';

-- 5-3. 봉사 후기 테이블
CREATE TABLE volunteer_reviews (
    -- 기본키
    review_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '후기 ID',

    -- 외래키
    member_id BIGINT UNSIGNED NULL COMMENT '회원 고유번호 (비회원 후기 허용)',
    application_id BIGINT UNSIGNED NOT NULL COMMENT '봉사 신청 ID',

    -- 후기 정보
    reviewer_name VARCHAR(100) NOT NULL COMMENT '후기 작성자명',
    title VARCHAR(200) NOT NULL COMMENT '후기 제목',
    content TEXT NOT NULL COMMENT '후기 내용',
    rating INT UNSIGNED NOT NULL COMMENT '별점 (1-5)',
    image_urls JSON NULL COMMENT '후기 이미지 URL 배열',

    -- 부가 정보
    is_visible BOOLEAN NOT NULL DEFAULT TRUE COMMENT '노출 여부',
    helpful_count INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '도움됨 카운트',
    report_count INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '신고 횟수',

    -- 시스템 정보
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    deleted_at TIMESTAMP NULL COMMENT '삭제일 (소프트 삭제)',

    INDEX idx_member_id (member_id),
    INDEX idx_application_id (application_id),
    INDEX idx_created_at (created_at DESC),
    INDEX idx_deleted_at (deleted_at),
    INDEX idx_rating (rating DESC),
    INDEX idx_helpful_count (helpful_count DESC),

    CHECK (rating IS NULL OR rating BETWEEN 1 AND 5),
    CHECK (helpful_count >= 0),
    CHECK (report_count <= 100),

    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE SET NULL,
    FOREIGN KEY (application_id) REFERENCES volunteer_applications(application_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='봉사 후기 테이블';

-- ========================================================================
-- PART 6: 컨텐츠 관리 도메인
-- ========================================================================

-- 6-1. 공지사항 테이블
CREATE TABLE notices (
    -- 기본키
    notice_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '공지사항 ID',

    -- 외래키
    admin_id BIGINT UNSIGNED NOT NULL COMMENT '작성한 관리자 ID',

    -- 공지 정보
    title VARCHAR(200) NOT NULL COMMENT '제목',
    content TEXT NOT NULL COMMENT '내용',
    category ENUM('SYSTEM', 'EVENT', 'MAINTENANCE', 'UPDATE', 'GENERAL') NOT NULL DEFAULT 'GENERAL' COMMENT '공지 유형',
    priority ENUM('LOW', 'NORMAL', 'HIGH', 'URGENT') NOT NULL DEFAULT 'NORMAL' COMMENT '중요도',

    -- 부가 정보
    views INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '조회수',
    is_pinned BOOLEAN NOT NULL DEFAULT FALSE COMMENT '상단 고정 여부',

    -- 노출 기간
    published_at TIMESTAMP NULL COMMENT '게시 시작일',
    expired_at TIMESTAMP NULL COMMENT '게시 종료일',

    -- 시스템 정보
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    deleted_at TIMESTAMP NULL COMMENT '삭제일 (소프트 삭제)',

    INDEX idx_admin_id (admin_id),
    INDEX idx_created_at (created_at DESC),
    INDEX idx_is_pinned (is_pinned),
    INDEX idx_deleted_at (deleted_at),
    INDEX idx_category (category),
    INDEX idx_priority (priority DESC),
    INDEX idx_published_at (published_at),
    INDEX idx_composite_active (is_pinned DESC, priority DESC, created_at DESC),

    CHECK (views >= 0),
    CHECK (expired_at IS NULL OR published_at IS NULL OR expired_at >= published_at),

    FOREIGN KEY (admin_id) REFERENCES member(member_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='공지사항 테이블';

-- 6-2. FAQ 테이블
CREATE TABLE faqs (
    -- 기본키
    faq_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'FAQ ID',

    -- 외래키
    category_id INT UNSIGNED NOT NULL COMMENT 'FAQ 카테고리 ID',

    -- FAQ 정보
    question VARCHAR(500) NOT NULL COMMENT '질문',
    answer TEXT NOT NULL COMMENT '답변',

    -- 부가 정보
    order_num INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '정렬 순서 (낮을수록 먼저 표시)',
    views INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '조회수',
    helpful_count INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '도움됨 카운트',
    is_active BOOLEAN NOT NULL DEFAULT TRUE COMMENT '활성화 여부',

    -- 시스템 정보
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',

    INDEX idx_category_id (category_id),
    INDEX idx_order_num (order_num ASC),
    INDEX idx_is_active (is_active),
    INDEX idx_views (views DESC),
    INDEX idx_helpful_count (helpful_count DESC),
    INDEX idx_composite_display (category_id, order_num ASC),

    CHECK (views >= 0),
    CHECK (helpful_count >= 0),

    FOREIGN KEY (category_id) REFERENCES faq_categories(category_id)
) ENGINE=InnoDB COMMENT='FAQ 테이블';

-- ========================================================================
-- PART 7: 공통 기능 테이블
-- ========================================================================

-- 7-1. 후기 도움됨 테이블 (제거됨 - helpful_count 컬럼으로 충분, Java 코드에서 미사용)

-- 7-2. 알림 테이블
CREATE TABLE IF NOT EXISTS notifications (
    -- 기본키
    notification_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '알림 ID',

    -- 외래키
    member_id BIGINT UNSIGNED NOT NULL COMMENT '회원 고유번호',

    -- 알림 정보
    notification_type ENUM('DONATION_REMINDER', 'VOLUNTEER_REMINDER', 'CALENDAR_EVENT', 'GENERAL', 'FAQ_ANSWER', 'VOLUNTEER_APPROVED') NOT NULL COMMENT '알림 유형',
    title VARCHAR(200) NOT NULL COMMENT '알림 제목',
    message TEXT NOT NULL COMMENT '알림 내용',

    -- 관련 정보
    related_id BIGINT UNSIGNED NULL COMMENT '관련 항목 ID (기부 ID, 봉사 ID 등)',
    event_date DATE NULL COMMENT '이벤트 날짜',

    -- 상태
    is_read BOOLEAN NOT NULL DEFAULT FALSE COMMENT '읽음 여부',
    is_sent BOOLEAN NOT NULL DEFAULT FALSE COMMENT '전송 여부',

    -- 시스템 정보
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    sent_at TIMESTAMP NULL COMMENT '전송일',
    read_at TIMESTAMP NULL COMMENT '읽은 일시',
    deleted_at TIMESTAMP NULL COMMENT '삭제일 (소프트 삭제)',

    INDEX idx_member_id (member_id),
    INDEX idx_is_read (is_read),
    INDEX idx_is_sent (is_sent),
    INDEX idx_event_date (event_date),
    INDEX idx_created_at (created_at DESC),
    INDEX idx_notification_type (notification_type),
    INDEX idx_deleted_at (deleted_at),
    INDEX idx_composite_member_unread (member_id, is_read, created_at DESC),

    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='알림 테이블';

-- 7-3. 알림 설정 테이블
CREATE TABLE IF NOT EXISTS notification_settings (
    -- 기본키
    setting_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '설정 ID',

    -- 외래키
    member_id BIGINT UNSIGNED NOT NULL COMMENT '회원 고유번호',

    -- 알림 설정 항목
    event_notification BOOLEAN NOT NULL DEFAULT TRUE COMMENT '일정 알림',
    donation_notification BOOLEAN NOT NULL DEFAULT TRUE COMMENT '기부 알림',
    volunteer_notification BOOLEAN NOT NULL DEFAULT TRUE COMMENT '봉사 활동 알림',
    faq_answer_notification BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'FAQ 답변 알림',

    -- 시스템 정보
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',

    -- 인덱스
    UNIQUE INDEX idx_member_id (member_id),

    -- 외래키 제약조건
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='회원별 알림 설정 테이블';

-- 7-3. 최근 활동 숨김 테이블
CREATE TABLE IF NOT EXISTS hidden_recent_activities (
    -- 기본키
    hidden_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '숨김 ID',

    -- 외래키
    member_id BIGINT UNSIGNED NOT NULL COMMENT '회원 고유번호',

    -- 숨김 대상 정보
    activity_type ENUM('VOLUNTEER', 'DONATION') NOT NULL COMMENT '활동 유형 (봉사/기부)',
    activity_id BIGINT UNSIGNED NOT NULL COMMENT '활동 ID (봉사 신청 ID 또는 기부 ID)',

    -- 시스템 정보
    hidden_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '숨김 처리 일시',

    -- 인덱스
    UNIQUE INDEX idx_unique_hidden (member_id, activity_type, activity_id) COMMENT '중복 숨김 방지',
    INDEX idx_member_id (member_id),
    INDEX idx_activity_type (activity_type),
    INDEX idx_hidden_at (hidden_at DESC),

    -- 외래키 제약조건
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='최근 활동 숨김 테이블 (사용자별 최근 활동 목록 숨김 처리)';

-- ========================================================================
-- PART 8: 시스템 관리 테이블
-- ========================================================================

-- 8-1. 시스템 로그 테이블 (제거됨 - Log4j2/SLF4J 사용, Java 코드에서 미사용)

-- ========================================================================
-- PART 9: 초기 데이터 삽입
-- ========================================================================

-- 9-1. 기부 카테고리 마스터 데이터
INSERT INTO donation_categories (category_code, category_name, display_order) VALUES
('CRISIS_FAMILY', '위기가정', 1),
('MEDICAL', '의료비', 2),
('FIRE_DAMAGE', '화재피해', 3),
('SINGLE_PARENT', '한부모', 4),
('NATURAL_DISASTER', '자연재해', 5),
('HOMELESS', '노숙인', 6),
('DOMESTIC_VIOLENCE', '가정폭력', 7),
('SUICIDE_RISK', '자살고위험', 8),
('CRIME_VICTIM', '범죄피해', 9),
('EDUCATION', '교육지원', 10),
('ELDERLY', '노인복지', 11),
('CHILD', '아동복지', 12),
('DISABILITY', '장애인복지', 13),
('REFUGEE', '난민지원', 14),
('ANIMAL', '동물보호', 15);

-- 9-2. FAQ 카테고리 마스터 데이터
INSERT INTO faq_categories (category_code, category_name, display_order) VALUES
('WELFARE', '복지혜택', 1),
('SERVICE', '서비스이용', 2),
('ACCOUNT', '계정관리', 3),
('DONATION', '기부/후원', 4),
('VOLUNTEER', '봉사활동', 5),
('ETC', '기타', 99);

-- 9-3. 초기 회원 데이터 (BCrypt 해시 사용)
-- 비밀번호: admin1234! → BCrypt 해시
-- 비밀번호: test1234! → BCrypt 해시
INSERT INTO member (email, pwd, name, phone, role, birth, gender, kindness_temperature, created_at) VALUES
('admin@welfare24.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '관리자', '01000000001', 'ADMIN', '1990-01-01', 'MALE', 36.50, NOW()),
('test@test.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '테스트유저', '01012345678', 'USER', '1995-05-15', 'FEMALE', 36.50, NOW()),
('test2@test.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '김민지', '01098765432', 'USER', '1998-03-22', 'FEMALE', 37.20, NOW());

-- 9-4. FAQ 샘플 데이터
INSERT INTO faqs (category_id, question, answer, order_num, is_active) VALUES
(1, '복지 혜택은 어떻게 찾나요?', '메인 페이지에서 "복지 혜택 찾기" 메뉴를 클릭하시면 간단한 정보 입력 후 맞춤형 복지 혜택을 추천받으실 수 있습니다. 나이, 가구 구성, 소득 수준 등의 정보를 입력하시면 AI가 자동으로 적합한 복지 서비스를 매칭해 드립니다.', 1, TRUE),
(1, '복지 혜택 신청은 어떻게 하나요?', '복지 혜택 검색 결과에서 원하는 혜택의 "신청하기" 버튼을 클릭하시면 해당 기관의 신청 페이지로 이동합니다. 온라인 신청이 가능한 경우 바로 신청이 가능하며, 방문 신청이 필요한 경우 주변 시설 정보를 안내해 드립니다.', 2, TRUE),
(1, '저소득층 기준은 어떻게 되나요?', '저소득층 기준은 정부 정책에 따라 변동될 수 있으며, 일반적으로 기준 중위소득의 일정 비율 이하를 기준으로 합니다. 정확한 기준은 복지 혜택 찾기에서 소득 정보 입력 시 자동으로 판단되어 적용됩니다.', 3, TRUE),
(4, '기부는 어떻게 하나요?', '메인 메뉴에서 "기부하기"를 선택하시면 다양한 기부 분야와 금액을 선택하실 수 있습니다. 정기 기부와 일시 기부 중 선택 가능하며, 신용카드, 계좌이체, 간편결제 등 다양한 결제 수단을 지원합니다.', 1, TRUE),
(4, '기부금 영수증은 어떻게 발급받나요?', '기부 완료 후 마이페이지 > 기부 내역에서 영수증 발급 버튼을 클릭하시면 PDF 형태로 다운로드하실 수 있습니다. 연말정산 시 국세청 홈택스에서도 조회 가능합니다.', 2, TRUE),
(2, '복지 지도는 어떻게 사용하나요?', '"복지 지도" 메뉴에서 현재 위치 또는 주소를 입력하시면 주변의 복지시설을 지도에서 확인하실 수 있습니다. 복지관, 주민센터, 상담센터 등 다양한 시설의 위치, 연락처, 운영시간 정보를 제공합니다.', 1, TRUE),
(5, '봉사 활동은 어떻게 참여하나요?', '메인 메뉴에서 "봉사활동" 메뉴를 선택하시면 다양한 봉사 활동 정보를 확인하실 수 있습니다. 원하시는 활동을 선택한 후 신청 양식을 작성하시면 됩니다.', 1, TRUE),
(2, '개인정보는 안전한가요?', '복지24는 개인정보보호법에 따라 모든 개인정보를 암호화하여 안전하게 관리하고 있습니다. 수집된 정보는 복지 서비스 매칭 목적으로만 사용되며, 제3자에게 제공되지 않습니다.', 2, TRUE),
(3, '회원가입은 필수인가요?', '복지 혜택 검색과 정보 조회는 회원가입 없이도 가능합니다. 다만, 맞춤형 추천 서비스와 신청 내역 관리를 위해서는 회원가입이 필요합니다.', 1, TRUE),
(3, '비밀번호를 잊어버렸어요', '로그인 페이지에서 "비밀번호 찾기"를 클릭하시면 가입 시 등록한 이메일로 임시 비밀번호를 발송해 드립니다.', 2, TRUE),
(6, '서비스 이용 중 오류가 발생했어요', '서비스 이용 중 오류가 발생하신 경우 페이지를 새로고침하거나 브라우저 캐시를 삭제해 보세요. 문제가 계속되는 경우 고객센터(1544-1234)로 문의하시거나 온라인 채팅 상담을 이용해 주세요.', 1, TRUE);

-- 9-5. 봉사 활동 샘플 데이터
INSERT INTO volunteer_activities (activity_name, description, category, location, sido, sigungu, activity_date, start_time, end_time, duration_hours, max_participants, contact_person, contact_phone, status) VALUES
('독거노인 도시락 배달', '혼자 사시는 어르신들께 따뜻한 도시락을 배달하는 봉사활동입니다.', 'ELDERLY', '서울시 강남구 복지관', '서울특별시', '강남구', '2025-02-01', '10:00:00', '14:00:00', 4, 20, '김복지', '01012341234', 'RECRUITING'),
('아동 교육 봉사', '지역아동센터에서 아이들의 학습을 도와주는 활동입니다.', 'CHILD', '서울시 서초구 지역아동센터', '서울특별시', '서초구', '2025-02-05', '15:00:00', '18:00:00', 3, 15, '이선생', '01023452345', 'RECRUITING'),
('환경 정화 활동', '지역 공원 및 하천 주변 환경 정화 활동입니다.', 'ENVIRONMENT', '서울시 송파구 올림픽공원', '서울특별시', '송파구', '2025-02-10', '09:00:00', '12:00:00', 3, 30, '박환경', '01034563456', 'RECRUITING'),
('장애인 보조 활동', '장애인 분들의 외출 및 일상생활을 보조하는 활동입니다.', 'DISABLED', '서울시 마포구 장애인복지관', '서울특별시', '마포구', '2025-02-15', '10:00:00', '16:00:00', 6, 10, '최도움', '01045674567', 'RECRUITING');

-- 9-6. 공지사항 샘플 데이터
INSERT INTO notices (admin_id, title, content, category, priority, views, is_pinned, published_at, created_at) VALUES
(1, '복지24 서비스 오픈 안내', '안녕하세요. 복지24 서비스가 정식으로 오픈되었습니다.\n\n본 서비스는 복지 혜택 진단, 기부, 봉사활동 등 다양한 복지 관련 서비스를 제공합니다.\n\n많은 이용 부탁드립니다.', 'SYSTEM', 'HIGH', 150, TRUE, '2025-01-01 00:00:00', '2025-01-01 10:00:00'),
(1, '설날 연휴 운영 안내', '설날 연휴 기간(2025-01-28 ~ 02-01) 동안 고객센터 운영이 제한됩니다.\n긴급 문의는 이메일로 보내주시기 바랍니다.', 'GENERAL', 'NORMAL', 80, FALSE, '2025-01-20 00:00:00', '2025-01-20 14:00:00'),
(1, '개인정보 처리방침 변경 안내', '2025년 2월 1일부터 개인정보 처리방침이 변경됩니다.\n자세한 내용은 홈페이지를 참조해주세요.', 'SYSTEM', 'NORMAL', 60, FALSE, '2025-01-25 00:00:00', '2025-01-25 09:00:00'),
(1, '2025년 복지 서비스 확대 시행', '2025년부터 복지 서비스가 대폭 확대됩니다.\n\n주요 변경사항:\n- 소득 기준 완화\n- 지원 금액 인상\n- 신청 절차 간소화\n\n자세한 내용은 복지 혜택 진단을 통해 확인하실 수 있습니다.', 'UPDATE', 'HIGH', 120, FALSE, '2025-01-10 00:00:00', '2025-01-10 09:00:00');

-- 9-7. 기부 샘플 데이터 (2025년 7월~12월, 월별 들쑥날쑥한 금액)
INSERT INTO donations (member_id, category_id, amount, donation_type, donor_name, donor_email, donor_phone, message, payment_method, payment_status, created_at) VALUES
-- 2025년 7월 기부 (총 약 180만원 - 시작 월)
(NULL, 1, 500000.00, 'ONETIME', '(주)희망나눔', 'hope@company.com', '01010000001', '위기가정에 희망을 전합니다.', 'BANK_TRANSFER', 'COMPLETED', '2025-07-03 10:00:00'),
(NULL, 2, 150000.00, 'REGULAR', '김민수', 'donor1@test.com', '01010000002', '의료비 지원에 동참합니다.', 'CREDIT_CARD', 'COMPLETED', '2025-07-08 14:30:00'),
(NULL, 3, 80000.00, 'ONETIME', '이지은', 'donor2@test.com', '01010000003', '화재 피해자 분들께 힘이 되길.', 'KAKAO_PAY', 'COMPLETED', '2025-07-15 11:20:00'),
(2, 4, 200000.00, 'REGULAR', '테스트유저', 'test@test.com', '01012345678', '한부모 가정 응원합니다.', 'CREDIT_CARD', 'COMPLETED', '2025-07-22 09:45:00'),
(NULL, 5, 120000.00, 'ONETIME', '박철수', 'donor3@test.com', '01010000004', '재난 복구 지원합니다.', 'NAVER_PAY', 'COMPLETED', '2025-07-28 16:00:00'),
(NULL, 1, 550000.00, 'ONETIME', '정현우', 'donor5@test.com', '01010000005', '어려운 이웃에게 도움을.', 'TOSS_PAY', 'COMPLETED', '2025-07-30 13:15:00'),
-- 2025년 8월 기부 (총 약 320만원 - 증가)
(NULL, 6, 800000.00, 'ONETIME', '삼성전자 봉사팀', 'samsung@company.com', '01020000001', '노숙인 지원 사업에 함께합니다.', 'BANK_TRANSFER', 'COMPLETED', '2025-08-02 09:00:00'),
(NULL, 7, 250000.00, 'REGULAR', '이영희', 'donor6@test.com', '01020000002', '가정폭력 피해자 분들 응원합니다.', 'CREDIT_CARD', 'COMPLETED', '2025-08-07 11:30:00'),
(NULL, 8, 180000.00, 'ONETIME', '최동욱', 'donor7@test.com', '01020000003', '자살 예방에 작은 힘을 보탭니다.', 'KAKAO_PAY', 'COMPLETED', '2025-08-12 14:00:00'),
(NULL, 9, 300000.00, 'ONETIME', '강서연', 'donor8@test.com', '01020000004', '범죄 피해자 지원에 동참.', 'BANK_TRANSFER', 'COMPLETED', '2025-08-18 10:45:00'),
(3, 10, 450000.00, 'REGULAR', '김민지', 'test2@test.com', '01098765432', '교육 지원으로 미래를 밝힙니다.', 'CREDIT_CARD', 'COMPLETED', '2025-08-23 16:20:00'),
(NULL, 11, 700000.00, 'ONETIME', '현대자동차 직원일동', 'hyundai@company.com', '01020000005', '노인복지에 정성을 담아.', 'BANK_TRANSFER', 'COMPLETED', '2025-08-28 09:30:00'),
(NULL, 2, 120000.00, 'ONETIME', '윤재호', 'donor9@test.com', '01020000006', '의료비 지원 함께합니다.', 'NAVER_PAY', 'COMPLETED', '2025-08-30 15:00:00'),
-- 2025년 9월 기부 (총 약 210만원 - 감소)
(NULL, 12, 350000.00, 'ONETIME', 'LG전자 나눔회', 'lg@company.com', '01030000001', '아동복지 사업 지원.', 'BANK_TRANSFER', 'COMPLETED', '2025-09-03 10:00:00'),
(NULL, 13, 280000.00, 'REGULAR', '손지영', 'donor13@test.com', '01030000002', '장애인 자립 응원합니다.', 'CREDIT_CARD', 'COMPLETED', '2025-09-09 13:30:00'),
(NULL, 14, 150000.00, 'ONETIME', '김하늘', 'donor14@test.com', '01030000003', '난민 지원에 동참합니다.', 'KAKAO_PAY', 'COMPLETED', '2025-09-15 11:00:00'),
(NULL, 15, 200000.00, 'REGULAR', '동물사랑연합회', 'animal@nonprofit.org', '01030000004', '유기동물 보호 함께해요.', 'BANK_TRANSFER', 'COMPLETED', '2025-09-20 14:45:00'),
(NULL, 1, 420000.00, 'ONETIME', '박서준', 'donor15@test.com', '01030000005', '위기가정 지원합니다.', 'TOSS_PAY', 'COMPLETED', '2025-09-25 09:15:00'),
(NULL, 3, 300000.00, 'ONETIME', '최유나', 'donor16@test.com', '01030000006', '화재 피해 복구 응원.', 'CREDIT_CARD', 'COMPLETED', '2025-09-28 16:30:00'),
(NULL, 4, 180000.00, 'ONETIME', '이준호', 'donor17@test.com', '01030000007', '한부모 가정 화이팅.', 'NAVER_PAY', 'COMPLETED', '2025-09-30 10:20:00'),
-- 2025년 10월 기부 (총 약 450만원 - 크게 증가)
(NULL, 2, 1500000.00, 'ONETIME', '서울대학교병원', 'snuh@hospital.com', '01040000001', '의료비 지원 사업 동참.', 'BANK_TRANSFER', 'COMPLETED', '2025-10-02 09:00:00'),
(NULL, 5, 600000.00, 'ONETIME', '대한적십자사', 'redcross@org.kr', '01040000002', '재난 구호 지원합니다.', 'BANK_TRANSFER', 'COMPLETED', '2025-10-08 11:30:00'),
(NULL, 6, 350000.00, 'REGULAR', '한국사회복지협회', 'welfare@org.kr', '01040000003', '노숙인 겨울나기 지원.', 'CREDIT_CARD', 'COMPLETED', '2025-10-12 14:00:00'),
(NULL, 7, 280000.00, 'ONETIME', '김태희', 'donor18@test.com', '01040000004', '가정폭력 피해자 새출발 응원.', 'KAKAO_PAY', 'COMPLETED', '2025-10-17 10:45:00'),
(NULL, 8, 420000.00, 'ONETIME', '이민호', 'donor19@test.com', '01040000005', '자살예방 캠페인 지원.', 'TOSS_PAY', 'COMPLETED', '2025-10-22 15:30:00'),
(NULL, 9, 180000.00, 'REGULAR', '송중기', 'donor20@test.com', '01040000006', '범죄피해자 치료비 지원.', 'CREDIT_CARD', 'COMPLETED', '2025-10-26 09:20:00'),
(NULL, 10, 550000.00, 'ONETIME', 'SK텔레콤 나눔재단', 'skt@company.com', '01040000007', '교육 기회 확대 지원.', 'BANK_TRANSFER', 'COMPLETED', '2025-10-30 16:00:00'),
-- 2025년 11월 기부 (총 약 280만원 - 감소)
(NULL, 11, 500000.00, 'ONETIME', '포스코 봉사단', 'posco@company.com', '01050000001', '노인복지 증진 지원.', 'BANK_TRANSFER', 'COMPLETED', '2025-11-03 10:00:00'),
(NULL, 12, 380000.00, 'REGULAR', '롯데그룹 나눔회', 'lotte@company.com', '01050000002', '아동복지 사업 함께.', 'CREDIT_CARD', 'COMPLETED', '2025-11-08 13:45:00'),
(NULL, 13, 220000.00, 'ONETIME', '정수진', 'donor21@test.com', '01050000003', '장애인 재활 응원합니다.', 'KAKAO_PAY', 'COMPLETED', '2025-11-12 11:30:00'),
(NULL, 14, 180000.00, 'ONETIME', '오세훈', 'donor22@test.com', '01050000004', '난민 정착 지원.', 'NAVER_PAY', 'COMPLETED', '2025-11-17 14:20:00'),
(NULL, 15, 250000.00, 'REGULAR', '유재석', 'donor23@test.com', '01050000005', '동물보호 활동 지원.', 'CREDIT_CARD', 'COMPLETED', '2025-11-21 09:50:00'),
(NULL, 1, 620000.00, 'ONETIME', 'CJ그룹 사회공헌팀', 'cj@company.com', '01050000006', '위기가정 긴급지원.', 'BANK_TRANSFER', 'COMPLETED', '2025-11-25 16:10:00'),
(NULL, 2, 150000.00, 'ONETIME', '강동원', 'donor24@test.com', '01050000007', '의료비 부담 경감 지원.', 'TOSS_PAY', 'COMPLETED', '2025-11-28 10:30:00'),
-- 2025년 12월 기부 (총 약 380만원 - 연말 증가)
(NULL, 3, 800000.00, 'ONETIME', '(주)행복나눔', 'happyshare@company.com', '01060000001', '연말 화재피해 복구 지원.', 'BANK_TRANSFER', 'COMPLETED', '2025-12-01 09:00:00'),
(NULL, 4, 450000.00, 'REGULAR', '한부모가정지원재단', 'singleparent@org.kr', '01060000002', '한부모 가정 연말 선물.', 'CREDIT_CARD', 'COMPLETED', '2025-12-01 14:30:00'),
(NULL, 5, 350000.00, 'ONETIME', '김수현', 'donor25@test.com', '01060000003', '재난구호 성금 전달.', 'KAKAO_PAY', 'COMPLETED', '2025-12-01 11:20:00'),
(NULL, 6, 580000.00, 'ONETIME', '네이버 임직원일동', 'naver@company.com', '01060000004', '노숙인 따뜻한 겨울나기.', 'BANK_TRANSFER', 'COMPLETED', '2025-12-01 16:00:00'),
(NULL, 7, 300000.00, 'REGULAR', '카카오 나눔팀', 'kakao@company.com', '01060000005', '가정폭력 피해자 쉼터 지원.', 'CREDIT_CARD', 'COMPLETED', '2025-12-02 09:45:00'),
(NULL, 8, 220000.00, 'ONETIME', '공유', 'donor26@test.com', '01060000006', '생명존중 캠페인 후원.', 'NAVER_PAY', 'COMPLETED', '2025-12-02 10:15:00'),
(NULL, 9, 400000.00, 'ONETIME', '토스 사회공헌팀', 'toss@company.com', '01060000007', '범죄피해자 지원 연말성금.', 'TOSS_PAY', 'COMPLETED', '2025-12-02 11:30:00'),
(NULL, 1, 700000.00, 'ONETIME', '배달의민족 봉사단', 'baemin@company.com', '01060000008', '연말 위기가정 긴급지원.', 'BANK_TRANSFER', 'COMPLETED', '2025-12-02 13:00:00');

-- 9-8. 기부 후기 샘플 데이터 (총 9개 리뷰)
INSERT INTO donation_reviews (member_id, donation_id, reviewer_name, rating, title, content, is_anonymous, created_at) VALUES
(NULL, 1, '김민수', 5, '정말 감사합니다', '어려운 시기에 도움을 받을 수 있어서 정말 감사했습니다. 복지24를 통해 신청한 지원금 덕분에 가족이 다시 희망을 찾을 수 있었습니다.', FALSE, '2025-07-15 11:00:00'),
(NULL, 2, '익명', 5, '의료비 지원 감사합니다', '가족의 수술비 때문에 고민이 많았는데, 복지24에서 의료비 지원 프로그램을 찾을 수 있었습니다. 정말 감사드립니다.', TRUE, '2025-07-20 12:30:00'),
(NULL, 3, '박철수', 5, '다시 일어설 수 있었습니다', '화재로 모든 것을 잃었을 때, 복지24를 통해 긴급 지원을 받을 수 있었습니다. 진심으로 감사드립니다.', FALSE, '2025-08-05 15:20:00'),
(2, 4, '테스트유저', 5, '한부모 가정에 큰 도움', '한부모 가정을 위한 다양한 지원 프로그램이 있어서 좋았습니다. 아이 양육비에 큰 도움이 되고 있어요.', FALSE, '2025-08-18 10:15:00'),
(NULL, 5, '정현우', 5, '재난 복구 지원 감사합니다', '태풍 피해로 집이 침수되었을 때 긴급 지원금을 받았습니다. 복지24의 빠른 대응 덕분에 빠르게 일상으로 돌아갈 수 있었습니다.', FALSE, '2025-09-08 17:00:00'),
(NULL, 6, '이영희', 5, '따뜻한 나눔에 감사드립니다', '노숙인 분들을 위한 겨울나기 프로그램이 정말 좋았습니다. 작은 기부가 큰 변화를 만든다는 것을 느꼈습니다.', FALSE, '2025-09-25 10:30:00'),
(NULL, 7, '익명', 4, '새출발의 기회를 주셔서 감사합니다', '가정폭력 피해로 힘들었는데 복지24를 통해 안전한 곳으로 옮길 수 있었습니다. 새로운 시작을 할 수 있게 도와주셔서 감사합니다.', TRUE, '2025-10-12 15:00:00'),
(NULL, 8, '강서연', 5, '심리 상담 지원 정말 좋았습니다', '심리 상담 지원 프로그램 덕분에 힘든 시기를 잘 극복할 수 있었습니다. 전문 상담사님들의 도움이 정말 컸어요.', FALSE, '2025-11-05 12:00:00'),
(NULL, 9, '익명', 5, '범죄 피해 치료비 지원 감사합니다', '범죄 피해로 인한 트라우마 치료비 지원을 받았습니다. 경제적 부담이 줄어들어 치료에 집중할 수 있었고, 심리적으로도 많이 회복되었습니다.', TRUE, '2025-11-28 17:00:00');

-- ========================================================================
-- 9-10. 대시보드용 추가 샘플 데이터
-- ========================================================================

-- 9-10-1. 추가 회원 데이터 (회원 증가 추이 차트용 - 최근 6개월)
INSERT INTO member (email, pwd, name, phone, role, birth, gender, kindness_temperature, created_at) VALUES
-- 2025년 7월 가입 회원 (8명 - 서비스 초기)
('user01@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '홍길동', '01011111001', 'USER', '1985-03-15', 'MALE', 38.50, '2025-07-05 10:30:00'),
('user02@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '김영희', '01011111002', 'USER', '1992-08-22', 'FEMALE', 37.80, '2025-07-12 14:20:00'),
('user03@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '박민준', '01011111003', 'USER', '1988-11-30', 'MALE', 36.90, '2025-07-18 09:15:00'),
('user04@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '이서연', '01011111004', 'USER', '1995-06-08', 'FEMALE', 39.20, '2025-07-22 16:40:00'),
('user05@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '정우진', '01011111005', 'USER', '1990-01-25', 'MALE', 37.10, '2025-07-25 11:00:00'),
('user06@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '최수빈', '01011111006', 'USER', '1998-04-12', 'FEMALE', 36.70, '2025-07-28 13:30:00'),
('user07@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '강지훈', '01011111007', 'USER', '1983-09-03', 'MALE', 40.50, '2025-07-29 10:00:00'),
('user08@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '윤하은', '01011111008', 'USER', '1997-12-18', 'FEMALE', 37.30, '2025-07-31 15:45:00'),
-- 2025년 8월 가입 회원 (12명 - 홍보 효과)
('user09@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '임도현', '01011111009', 'USER', '1991-02-14', 'MALE', 38.00, '2025-08-03 09:20:00'),
('user10@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '송예진', '01011111010', 'USER', '1994-07-29', 'FEMALE', 36.80, '2025-08-06 11:30:00'),
('user11@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '한승우', '01011111011', 'USER', '1987-10-05', 'MALE', 41.20, '2025-08-09 14:00:00'),
('user12@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '오지아', '01011111012', 'USER', '1996-03-21', 'FEMALE', 37.60, '2025-08-12 16:15:00'),
('user13@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '신준혁', '01011111013', 'USER', '1989-08-17', 'MALE', 38.90, '2025-08-15 10:45:00'),
('user14@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '권민서', '01011111014', 'USER', '1993-11-08', 'FEMALE', 36.50, '2025-08-18 13:20:00'),
('user15@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '배정훈', '01011111015', 'USER', '1986-05-30', 'MALE', 39.70, '2025-08-20 09:00:00'),
('user16@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '조유나', '01011111016', 'USER', '1999-01-14', 'FEMALE', 37.40, '2025-08-22 15:30:00'),
('user17@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '유태양', '01011111017', 'USER', '1984-06-25', 'MALE', 42.00, '2025-08-25 11:10:00'),
('user18@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '장소연', '01011111018', 'USER', '1992-09-12', 'FEMALE', 38.30, '2025-08-27 14:45:00'),
('user19@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '문성민', '01011111019', 'USER', '1988-12-03', 'MALE', 37.90, '2025-08-29 10:30:00'),
('user20@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '양지은', '01011111020', 'USER', '1995-04-19', 'FEMALE', 36.60, '2025-08-31 16:00:00'),
-- 2025년 9월 가입 회원 (15명 - 가을 봉사시즌)
('user21@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '허재원', '01011111021', 'USER', '1990-07-08', 'MALE', 39.10, '2025-09-02 09:30:00'),
('user22@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '남수현', '01011111022', 'USER', '1997-02-28', 'FEMALE', 37.50, '2025-09-04 13:15:00'),
('user23@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '백동혁', '01011111023', 'USER', '1985-10-15', 'MALE', 40.80, '2025-09-06 11:00:00'),
('user24@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '안예림', '01011111024', 'USER', '1993-05-22', 'FEMALE', 38.20, '2025-09-08 15:40:00'),
('user25@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '곽시우', '01011111025', 'USER', '1991-08-09', 'MALE', 37.70, '2025-09-10 10:20:00'),
('user26@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '서하린', '01011111026', 'USER', '1998-01-31', 'FEMALE', 36.90, '2025-09-12 14:00:00'),
('user27@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '고민재', '01011111027', 'USER', '1986-11-18', 'MALE', 41.50, '2025-09-14 09:45:00'),
('user28@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '류아영', '01011111028', 'USER', '1994-06-07', 'FEMALE', 38.60, '2025-09-16 16:30:00'),
('user29@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '황준서', '01011111029', 'USER', '1989-03-24', 'MALE', 37.20, '2025-09-18 11:15:00'),
('user30@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '전소희', '01011111030', 'USER', '1996-09-11', 'FEMALE', 39.40, '2025-09-20 13:50:00'),
('user31@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '노현우', '01011111031', 'USER', '1987-12-29', 'MALE', 38.80, '2025-09-22 10:00:00'),
('user32@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '성다인', '01011111032', 'USER', '1992-04-16', 'FEMALE', 37.00, '2025-09-24 15:20:00'),
('user33@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '차승호', '01011111033', 'USER', '1983-07-03', 'MALE', 43.20, '2025-09-26 09:30:00'),
('user34@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '원서윤', '01011111034', 'USER', '1999-10-20', 'FEMALE', 36.70, '2025-09-28 14:10:00'),
('user35@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '하동현', '01011111035', 'USER', '1990-02-08', 'MALE', 38.40, '2025-09-30 11:45:00'),
-- 2025년 10월 가입 회원 (18명 - 기부 캠페인)
('user36@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '심우빈', '01011111036', 'USER', '1988-05-14', 'MALE', 39.60, '2025-10-02 10:00:00'),
('user37@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '피수아', '01011111037', 'USER', '1995-08-27', 'FEMALE', 37.80, '2025-10-04 13:30:00'),
('user38@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '공재민', '01011111038', 'USER', '1991-11-06', 'MALE', 40.10, '2025-10-06 09:15:00'),
('user39@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '탁서영', '01011111039', 'USER', '1997-03-19', 'FEMALE', 38.00, '2025-10-08 15:45:00'),
('user40@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '표민혁', '01011111040', 'USER', '1984-06-02', 'MALE', 41.80, '2025-10-10 11:20:00'),
('user41@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '방예나', '01011111041', 'USER', '1993-09-25', 'FEMALE', 37.30, '2025-10-12 14:00:00'),
('user42@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '설현수', '01011111042', 'USER', '1986-12-11', 'MALE', 39.90, '2025-10-14 10:30:00'),
('user43@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '길지민', '01011111043', 'USER', '1998-04-28', 'FEMALE', 36.80, '2025-10-16 16:10:00'),
('user44@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '봉태훈', '01011111044', 'USER', '1989-07-15', 'MALE', 38.50, '2025-10-18 09:45:00'),
('user45@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '엄서현', '01011111045', 'USER', '1994-10-08', 'FEMALE', 37.60, '2025-10-20 13:20:00'),
('user46@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '국준영', '01011111046', 'USER', '1987-01-22', 'MALE', 40.40, '2025-10-22 11:00:00'),
('user47@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '빈다은', '01011111047', 'USER', '1996-06-05', 'FEMALE', 38.20, '2025-10-24 15:30:00'),
('user48@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '옥성현', '01011111048', 'USER', '1991-09-18', 'MALE', 37.10, '2025-10-26 10:15:00'),
('user49@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '선아린', '01011111049', 'USER', '1999-12-01', 'FEMALE', 36.60, '2025-10-27 14:40:00'),
('user50@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '마동건', '01011111050', 'USER', '1985-03-14', 'MALE', 42.30, '2025-10-28 09:00:00'),
('user51@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '복소율', '01011111051', 'USER', '1992-08-27', 'FEMALE', 37.90, '2025-10-29 13:50:00'),
('user52@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '도현준', '01011111052', 'USER', '1988-11-10', 'MALE', 39.20, '2025-10-30 11:30:00'),
('user53@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '편서진', '01011111053', 'USER', '1995-02-23', 'FEMALE', 38.70, '2025-10-31 16:20:00'),
-- 2025년 11월 가입 회원 (22명 - 연말 준비)
('user54@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '견태호', '01011111054', 'USER', '1990-04-09', 'MALE', 40.00, '2025-11-01 10:00:00'),
('user55@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '추다현', '01011111055', 'USER', '1997-07-16', 'FEMALE', 37.40, '2025-11-02 13:45:00'),
('user56@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '석재원', '01011111056', 'USER', '1986-10-30', 'MALE', 41.60, '2025-11-03 09:30:00'),
('user57@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '팽유진', '01011111057', 'USER', '1993-01-13', 'FEMALE', 38.10, '2025-11-04 15:15:00'),
('user58@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '초민수', '01011111058', 'USER', '1984-05-26', 'MALE', 43.00, '2025-11-05 11:00:00'),
('user59@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '홍예빈', '01011111059', 'USER', '1998-08-09', 'FEMALE', 36.70, '2025-11-06 14:30:00'),
('user60@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '강승민', '01011111060', 'USER', '1991-11-22', 'MALE', 39.50, '2025-11-07 10:20:00'),
('user61@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '윤서아', '01011111061', 'USER', '1996-02-05', 'FEMALE', 37.80, '2025-11-08 16:00:00'),
('user62@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '임진우', '01011111062', 'USER', '1987-06-18', 'MALE', 40.70, '2025-11-09 09:45:00'),
('user63@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '송나윤', '01011111063', 'USER', '1994-09-01', 'FEMALE', 38.40, '2025-11-10 13:10:00'),
('user64@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '한시원', '01011111064', 'USER', '1989-12-14', 'MALE', 37.20, '2025-11-11 11:35:00'),
('user65@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '오채원', '01011111065', 'USER', '1999-03-27', 'FEMALE', 36.90, '2025-11-12 15:50:00'),
('user66@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '신동현', '01011111066', 'USER', '1983-08-10', 'MALE', 44.10, '2025-11-13 10:05:00'),
('user67@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '권하늘', '01011111067', 'USER', '1992-11-23', 'FEMALE', 37.60, '2025-11-14 14:20:00'),
('user68@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '배준혁', '01011111068', 'USER', '1988-02-06', 'MALE', 39.80, '2025-11-15 09:15:00'),
('user69@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '조수민', '01011111069', 'USER', '1995-05-19', 'FEMALE', 38.30, '2025-11-16 13:40:00'),
('user70@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '유건우', '01011111070', 'USER', '1990-08-02', 'MALE', 40.20, '2025-11-18 11:25:00'),
('user71@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '장이서', '01011111071', 'USER', '1997-10-15', 'FEMALE', 37.10, '2025-11-20 16:30:00'),
('user72@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '문성훈', '01011111072', 'USER', '1985-01-28', 'MALE', 42.50, '2025-11-22 10:50:00'),
('user73@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '양지유', '01011111073', 'USER', '1993-04-11', 'FEMALE', 38.00, '2025-11-24 14:05:00'),
('user74@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '허도윤', '01011111074', 'USER', '1986-07-24', 'MALE', 41.30, '2025-11-26 09:20:00'),
('user75@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '남서연', '01011111075', 'USER', '1998-11-07', 'FEMALE', 36.80, '2025-11-28 15:40:00'),
-- 2025년 12월 가입 회원 (25명 - 연말 기부 시즌)
('user76@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '백준호', '01011111076', 'USER', '1991-02-20', 'MALE', 39.70, '2025-12-01 10:00:00'),
('user77@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '안지안', '01011111077', 'USER', '1996-05-03', 'FEMALE', 37.50, '2025-12-02 13:30:00'),
('user78@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '곽민성', '01011111078', 'USER', '1984-08-16', 'MALE', 43.50, '2025-12-03 09:15:00'),
('user79@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '서예은', '01011111079', 'USER', '1993-11-29', 'FEMALE', 38.20, '2025-12-04 15:45:00'),
('user80@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '고우진', '01011111080', 'USER', '1989-03-12', 'MALE', 40.60, '2025-12-05 11:20:00'),
('user81@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '류다온', '01011111081', 'USER', '1997-06-25', 'FEMALE', 37.30, '2025-12-06 14:00:00'),
('user82@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '황재현', '01011111082', 'USER', '1986-09-08', 'MALE', 41.90, '2025-12-07 10:35:00'),
('user83@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '전하은', '01011111083', 'USER', '1994-12-21', 'FEMALE', 38.50, '2025-12-08 16:10:00'),
('user84@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '노시후', '01011111084', 'USER', '1990-04-04', 'MALE', 39.30, '2025-12-09 09:50:00'),
('user85@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '성민지', '01011111085', 'USER', '1999-07-17', 'FEMALE', 36.70, '2025-12-10 13:25:00'),
('user86@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '차형준', '01011111086', 'USER', '1985-10-30', 'MALE', 42.80, '2025-12-11 11:00:00'),
('user87@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '원소미', '01011111087', 'USER', '1992-01-13', 'FEMALE', 37.90, '2025-12-12 15:30:00'),
('user88@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '하승우', '01011111088', 'USER', '1988-05-26', 'MALE', 40.40, '2025-12-13 10:15:00'),
('user89@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '심채린', '01011111089', 'USER', '1995-08-09', 'FEMALE', 38.60, '2025-12-14 14:40:00'),
('user90@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '피동욱', '01011111090', 'USER', '1987-11-22', 'MALE', 41.10, '2025-12-15 09:00:00'),
('user91@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '공서윤', '01011111091', 'USER', '1996-02-05', 'FEMALE', 37.40, '2025-12-16 13:55:00'),
('user92@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '탁현우', '01011111092', 'USER', '1983-06-18', 'MALE', 44.50, '2025-12-17 11:30:00'),
('user93@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '표수아', '01011111093', 'USER', '1991-09-01', 'FEMALE', 38.10, '2025-12-18 16:05:00'),
('user94@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '방준서', '01011111094', 'USER', '1988-12-14', 'MALE', 39.90, '2025-12-19 10:40:00'),
('user95@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '설아영', '01011111095', 'USER', '1997-03-27', 'FEMALE', 37.20, '2025-12-20 14:15:00'),
('user96@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '길태민', '01011111096', 'USER', '1984-07-10', 'MALE', 43.20, '2025-12-22 09:25:00'),
('user97@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '봉하린', '01011111097', 'USER', '1993-10-23', 'FEMALE', 38.40, '2025-12-24 13:00:00'),
('user98@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '엄도현', '01011111098', 'USER', '1989-01-06', 'MALE', 40.80, '2025-12-26 11:45:00'),
('user99@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '국지민', '01011111099', 'USER', '1996-04-19', 'FEMALE', 37.70, '2025-12-28 15:20:00'),
('user100@welfare24.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '빈성현', '01011111100', 'USER', '1986-08-02', 'MALE', 42.00, '2025-12-30 10:10:00');

-- 9-10-2. 봉사 신청 데이터 (카테고리별 신청률 및 월별 현황 차트용)
-- 봉사 카테고리: ELDERLY(노인돌봄), CHILD(아동교육), DISABLED(장애인), ENVIRONMENT(환경보호), EDUCATION(교육), COMMUNITY(지역사회), ETC(기타)
INSERT INTO volunteer_applications (activity_id, member_id, applicant_name, applicant_email, applicant_phone, selected_category, volunteer_date, volunteer_time, status, created_at) VALUES
-- 노인돌봄 카테고리 (30건 - 85% 신청률)
(1, 4, '이서연', 'user04@welfare24.com', '01011111004', 'ELDERLY', '2025-08-15', '10:00-14:00', 'COMPLETED', '2025-08-10 09:00:00'),
(1, 7, '강지훈', 'user07@welfare24.com', '01011111007', 'ELDERLY', '2025-08-20', '10:00-14:00', 'COMPLETED', '2025-08-15 10:30:00'),
(1, 11, '한승우', 'user11@welfare24.com', '01011111011', 'ELDERLY', '2025-09-05', '10:00-14:00', 'COMPLETED', '2025-09-01 11:00:00'),
(1, 17, '유태양', 'user17@welfare24.com', '01011111017', 'ELDERLY', '2025-09-12', '10:00-14:00', 'COMPLETED', '2025-09-08 14:20:00'),
(1, 23, '백동혁', 'user23@welfare24.com', '01011111023', 'ELDERLY', '2025-09-20', '10:00-14:00', 'COMPLETED', '2025-09-15 09:45:00'),
(1, 27, '고민재', 'user27@welfare24.com', '01011111027', 'ELDERLY', '2025-10-01', '10:00-14:00', 'COMPLETED', '2025-09-26 13:00:00'),
(1, 33, '차승호', 'user33@welfare24.com', '01011111033', 'ELDERLY', '2025-10-08', '10:00-14:00', 'COMPLETED', '2025-10-03 10:15:00'),
(1, 40, '표민혁', 'user40@welfare24.com', '01011111040', 'ELDERLY', '2025-10-15', '10:00-14:00', 'COMPLETED', '2025-10-10 15:30:00'),
(1, 46, '국준영', 'user46@welfare24.com', '01011111046', 'ELDERLY', '2025-10-22', '10:00-14:00', 'COMPLETED', '2025-10-17 11:45:00'),
(1, 50, '마동건', 'user50@welfare24.com', '01011111050', 'ELDERLY', '2025-10-29', '10:00-14:00', 'COMPLETED', '2025-10-24 09:00:00'),
(1, 58, '초민수', 'user58@welfare24.com', '01011111058', 'ELDERLY', '2025-11-05', '10:00-14:00', 'COMPLETED', '2025-10-31 14:00:00'),
(1, 62, '임진우', 'user62@welfare24.com', '01011111062', 'ELDERLY', '2025-11-12', '10:00-14:00', 'COMPLETED', '2025-11-07 10:30:00'),
(1, 66, '신동현', 'user66@welfare24.com', '01011111066', 'ELDERLY', '2025-11-19', '10:00-14:00', 'COMPLETED', '2025-11-14 16:00:00'),
(1, 72, '문성훈', 'user72@welfare24.com', '01011111072', 'ELDERLY', '2025-11-26', '10:00-14:00', 'COMPLETED', '2025-11-21 09:20:00'),
(1, 78, '곽민성', 'user78@welfare24.com', '01011111078', 'ELDERLY', '2025-12-03', '10:00-14:00', 'COMPLETED', '2025-11-28 13:45:00'),
(1, 82, '황재현', 'user82@welfare24.com', '01011111082', 'ELDERLY', '2025-12-10', '10:00-14:00', 'COMPLETED', '2025-12-05 11:00:00'),
(1, 86, '차형준', 'user86@welfare24.com', '01011111086', 'ELDERLY', '2025-12-17', '10:00-14:00', 'COMPLETED', '2025-12-12 15:15:00'),
(1, 90, '피동욱', 'user90@welfare24.com', '01011111090', 'ELDERLY', '2025-12-24', '10:00-14:00', 'COMPLETED', '2025-12-19 10:00:00'),
(1, 92, '탁현우', 'user92@welfare24.com', '01011111092', 'ELDERLY', '2025-12-27', '10:00-14:00', 'COMPLETED', '2025-12-22 14:30:00'),
(1, 96, '길태민', 'user96@welfare24.com', '01011111096', 'ELDERLY', '2025-12-08', '10:00-14:00', 'CONFIRMED', '2025-11-29 09:00:00'),
(1, 98, '엄도현', 'user98@welfare24.com', '01011111098', 'ELDERLY', '2025-12-15', '10:00-14:00', 'CONFIRMED', '2025-12-01 11:20:00'),
(1, 100, '빈성현', 'user100@welfare24.com', '01011111100', 'ELDERLY', '2025-12-22', '10:00-14:00', 'APPLIED', '2025-12-02 16:00:00'),
(NULL, NULL, '김봉사', 'volunteer1@test.com', '01099990001', 'ELDERLY', '2025-09-15', '10:00-14:00', 'COMPLETED', '2025-09-10 10:00:00'),
(NULL, NULL, '이헌신', 'volunteer2@test.com', '01099990002', 'ELDERLY', '2025-10-20', '10:00-14:00', 'COMPLETED', '2025-10-15 13:30:00'),
(NULL, NULL, '박나눔', 'volunteer3@test.com', '01099990003', 'ELDERLY', '2025-11-10', '10:00-14:00', 'COMPLETED', '2025-11-05 09:45:00'),
(NULL, NULL, '최도움', 'volunteer4@test.com', '01099990004', 'ELDERLY', '2025-11-25', '10:00-14:00', 'COMPLETED', '2025-11-20 15:00:00'),
(NULL, NULL, '정사랑', 'volunteer5@test.com', '01099990005', 'ELDERLY', '2025-12-05', '10:00-14:00', 'COMPLETED', '2025-11-30 11:30:00'),
(NULL, NULL, '강희망', 'volunteer6@test.com', '01099990006', 'ELDERLY', '2025-12-15', '10:00-14:00', 'COMPLETED', '2025-12-10 14:20:00'),
(NULL, NULL, '윤따뜻', 'volunteer7@test.com', '01099990007', 'ELDERLY', '2025-12-28', '10:00-14:00', 'COMPLETED', '2025-12-23 10:45:00'),
(NULL, NULL, '임행복', 'volunteer8@test.com', '01099990008', 'ELDERLY', '2025-12-18', '10:00-14:00', 'CONFIRMED', '2025-12-01 09:00:00'),
-- 아동교육 카테고리 (25건 - 72% 신청률)
(2, 6, '최수빈', 'user06@welfare24.com', '01011111006', 'CHILD', '2025-08-18', '15:00-18:00', 'COMPLETED', '2025-08-13 14:00:00'),
(2, 10, '송예진', 'user10@welfare24.com', '01011111010', 'CHILD', '2025-08-25', '15:00-18:00', 'COMPLETED', '2025-08-20 11:30:00'),
(2, 14, '권민서', 'user14@welfare24.com', '01011111014', 'CHILD', '2025-09-08', '15:00-18:00', 'COMPLETED', '2025-09-03 09:15:00'),
(2, 18, '장소연', 'user18@welfare24.com', '01011111018', 'CHILD', '2025-09-15', '15:00-18:00', 'COMPLETED', '2025-09-10 16:00:00'),
(2, 22, '남수현', 'user22@welfare24.com', '01011111022', 'CHILD', '2025-09-22', '15:00-18:00', 'COMPLETED', '2025-09-17 10:20:00'),
(2, 26, '서하린', 'user26@welfare24.com', '01011111026', 'CHILD', '2025-10-06', '15:00-18:00', 'COMPLETED', '2025-10-01 13:45:00'),
(2, 30, '전소희', 'user30@welfare24.com', '01011111030', 'CHILD', '2025-10-13', '15:00-18:00', 'COMPLETED', '2025-10-08 11:00:00'),
(2, 34, '원서윤', 'user34@welfare24.com', '01011111034', 'CHILD', '2025-10-20', '15:00-18:00', 'COMPLETED', '2025-10-15 15:30:00'),
(2, 37, '피수아', 'user37@welfare24.com', '01011111037', 'CHILD', '2025-10-27', '15:00-18:00', 'COMPLETED', '2025-10-22 09:00:00'),
(2, 41, '방예나', 'user41@welfare24.com', '01011111041', 'CHILD', '2025-11-03', '15:00-18:00', 'COMPLETED', '2025-10-29 14:15:00'),
(2, 45, '엄서현', 'user45@welfare24.com', '01011111045', 'CHILD', '2025-11-10', '15:00-18:00', 'COMPLETED', '2025-11-05 10:40:00'),
(2, 49, '선아린', 'user49@welfare24.com', '01011111049', 'CHILD', '2025-11-17', '15:00-18:00', 'COMPLETED', '2025-11-12 16:20:00'),
(2, 55, '추다현', 'user55@welfare24.com', '01011111055', 'CHILD', '2025-11-24', '15:00-18:00', 'COMPLETED', '2025-11-19 11:10:00'),
(2, 59, '홍예빈', 'user59@welfare24.com', '01011111059', 'CHILD', '2025-12-01', '15:00-18:00', 'COMPLETED', '2025-11-26 13:30:00'),
(2, 63, '송나윤', 'user63@welfare24.com', '01011111063', 'CHILD', '2025-12-08', '15:00-18:00', 'COMPLETED', '2025-12-03 09:50:00'),
(2, 67, '권하늘', 'user67@welfare24.com', '01011111067', 'CHILD', '2025-12-15', '15:00-18:00', 'COMPLETED', '2025-12-10 15:00:00'),
(2, 71, '장이서', 'user71@welfare24.com', '01011111071', 'CHILD', '2025-12-22', '15:00-18:00', 'COMPLETED', '2025-12-17 10:30:00'),
(2, 77, '안지안', 'user77@welfare24.com', '01011111077', 'CHILD', '2025-12-29', '15:00-18:00', 'COMPLETED', '2025-12-24 14:00:00'),
(2, 81, '류다온', 'user81@welfare24.com', '01011111081', 'CHILD', '2025-12-09', '15:00-18:00', 'CONFIRMED', '2025-11-30 11:45:00'),
(2, 85, '성민지', 'user85@welfare24.com', '01011111085', 'CHILD', '2025-12-16', '15:00-18:00', 'CONFIRMED', '2025-12-01 09:20:00'),
(2, 89, '심채린', 'user89@welfare24.com', '01011111089', 'CHILD', '2025-12-23', '15:00-18:00', 'APPLIED', '2025-12-02 16:30:00'),
(NULL, NULL, '신미래', 'volunteer9@test.com', '01099990009', 'CHILD', '2025-10-05', '15:00-18:00', 'COMPLETED', '2025-09-30 10:00:00'),
(NULL, NULL, '조꿈나', 'volunteer10@test.com', '01099990010', 'CHILD', '2025-11-15', '15:00-18:00', 'COMPLETED', '2025-11-10 13:00:00'),
(NULL, NULL, '이빛나', 'volunteer11@test.com', '01099990011', 'CHILD', '2025-12-10', '15:00-18:00', 'COMPLETED', '2025-12-05 09:30:00'),
(NULL, NULL, '박하늘', 'volunteer12@test.com', '01099990012', 'CHILD', '2025-12-19', '15:00-18:00', 'CONFIRMED', '2025-12-01 14:00:00'),
-- 환경보호 카테고리 (20건 - 58% 신청률)
(3, 5, '정우진', 'user05@welfare24.com', '01011111005', 'ENVIRONMENT', '2025-08-22', '09:00-12:00', 'COMPLETED', '2025-08-17 10:00:00'),
(3, 9, '임도현', 'user09@welfare24.com', '01011111009', 'ENVIRONMENT', '2025-09-07', '09:00-12:00', 'COMPLETED', '2025-09-02 13:20:00'),
(3, 15, '배정훈', 'user15@welfare24.com', '01011111015', 'ENVIRONMENT', '2025-09-21', '09:00-12:00', 'COMPLETED', '2025-09-16 09:40:00'),
(3, 21, '허재원', 'user21@welfare24.com', '01011111021', 'ENVIRONMENT', '2025-10-05', '09:00-12:00', 'COMPLETED', '2025-09-30 15:10:00'),
(3, 25, '곽시우', 'user25@welfare24.com', '01011111025', 'ENVIRONMENT', '2025-10-12', '09:00-12:00', 'COMPLETED', '2025-10-07 11:30:00'),
(3, 29, '황준서', 'user29@welfare24.com', '01011111029', 'ENVIRONMENT', '2025-10-19', '09:00-12:00', 'COMPLETED', '2025-10-14 14:00:00'),
(3, 35, '하동현', 'user35@welfare24.com', '01011111035', 'ENVIRONMENT', '2025-10-26', '09:00-12:00', 'COMPLETED', '2025-10-21 10:15:00'),
(3, 38, '공재민', 'user38@welfare24.com', '01011111038', 'ENVIRONMENT', '2025-11-02', '09:00-12:00', 'COMPLETED', '2025-10-28 16:30:00'),
(3, 44, '봉태훈', 'user44@welfare24.com', '01011111044', 'ENVIRONMENT', '2025-11-09', '09:00-12:00', 'COMPLETED', '2025-11-04 09:00:00'),
(3, 48, '옥성현', 'user48@welfare24.com', '01011111048', 'ENVIRONMENT', '2025-11-16', '09:00-12:00', 'COMPLETED', '2025-11-11 13:45:00'),
(3, 52, '도현준', 'user52@welfare24.com', '01011111052', 'ENVIRONMENT', '2025-11-23', '09:00-12:00', 'COMPLETED', '2025-11-18 11:20:00'),
(3, 56, '석재원', 'user56@welfare24.com', '01011111056', 'ENVIRONMENT', '2025-11-30', '09:00-12:00', 'COMPLETED', '2025-11-25 15:00:00'),
(3, 60, '강승민', 'user60@welfare24.com', '01011111060', 'ENVIRONMENT', '2025-12-07', '09:00-12:00', 'COMPLETED', '2025-12-02 10:30:00'),
(3, 68, '배준혁', 'user68@welfare24.com', '01011111068', 'ENVIRONMENT', '2025-12-14', '09:00-12:00', 'COMPLETED', '2025-12-09 14:15:00'),
(3, 74, '허도윤', 'user74@welfare24.com', '01011111074', 'ENVIRONMENT', '2025-12-21', '09:00-12:00', 'COMPLETED', '2025-12-16 09:45:00'),
(3, 80, '고우진', 'user80@welfare24.com', '01011111080', 'ENVIRONMENT', '2025-12-28', '09:00-12:00', 'COMPLETED', '2025-12-23 13:00:00'),
(3, 84, '노시후', 'user84@welfare24.com', '01011111084', 'ENVIRONMENT', '2025-12-10', '09:00-12:00', 'CONFIRMED', '2025-11-30 11:30:00'),
(3, 88, '하승우', 'user88@welfare24.com', '01011111088', 'ENVIRONMENT', '2025-12-20', '09:00-12:00', 'CONFIRMED', '2025-12-01 15:50:00'),
(NULL, NULL, '초록별', 'volunteer13@test.com', '01099990013', 'ENVIRONMENT', '2025-10-15', '09:00-12:00', 'COMPLETED', '2025-10-10 10:00:00'),
(NULL, NULL, '지구맘', 'volunteer14@test.com', '01099990014', 'ENVIRONMENT', '2025-12-01', '09:00-12:00', 'COMPLETED', '2025-11-26 14:00:00'),
-- 의료봉사 카테고리 (15건 - 43% 신청률)
(4, 8, '윤하은', 'user08@welfare24.com', '01011111008', 'DISABLED', '2025-09-10', '10:00-16:00', 'COMPLETED', '2025-09-05 10:30:00'),
(4, 12, '오지아', 'user12@welfare24.com', '01011111012', 'DISABLED', '2025-09-24', '10:00-16:00', 'COMPLETED', '2025-09-19 14:00:00'),
(4, 19, '문성민', 'user19@welfare24.com', '01011111019', 'DISABLED', '2025-10-08', '10:00-16:00', 'COMPLETED', '2025-10-03 09:20:00'),
(4, 24, '안예림', 'user24@welfare24.com', '01011111024', 'DISABLED', '2025-10-22', '10:00-16:00', 'COMPLETED', '2025-10-17 15:45:00'),
(4, 31, '노현우', 'user31@welfare24.com', '01011111031', 'DISABLED', '2025-11-05', '10:00-16:00', 'COMPLETED', '2025-10-31 11:00:00'),
(4, 39, '탁서영', 'user39@welfare24.com', '01011111039', 'DISABLED', '2025-11-19', '10:00-16:00', 'COMPLETED', '2025-11-14 13:30:00'),
(4, 47, '빈다은', 'user47@welfare24.com', '01011111047', 'DISABLED', '2025-12-03', '10:00-16:00', 'COMPLETED', '2025-11-28 10:15:00'),
(4, 53, '편서진', 'user53@welfare24.com', '01011111053', 'DISABLED', '2025-12-17', '10:00-16:00', 'COMPLETED', '2025-12-12 16:00:00'),
(4, 61, '윤서아', 'user61@welfare24.com', '01011111061', 'DISABLED', '2025-12-31', '10:00-16:00', 'COMPLETED', '2025-12-26 09:45:00'),
(4, 69, '조수민', 'user69@welfare24.com', '01011111069', 'DISABLED', '2025-12-12', '10:00-16:00', 'CONFIRMED', '2025-12-01 14:20:00'),
(4, 75, '남서연', 'user75@welfare24.com', '01011111075', 'DISABLED', '2025-12-24', '10:00-16:00', 'APPLIED', '2025-12-02 11:00:00'),
(NULL, NULL, '건강지킴', 'volunteer15@test.com', '01099990015', 'DISABLED', '2025-10-25', '10:00-16:00', 'COMPLETED', '2025-10-20 10:00:00'),
(NULL, NULL, '치유손길', 'volunteer16@test.com', '01099990016', 'DISABLED', '2025-11-28', '10:00-16:00', 'COMPLETED', '2025-11-23 13:30:00'),
(NULL, NULL, '사랑케어', 'volunteer17@test.com', '01099990017', 'DISABLED', '2025-12-20', '10:00-16:00', 'COMPLETED', '2025-12-15 15:00:00'),
(NULL, NULL, '희망간호', 'volunteer18@test.com', '01099990018', 'DISABLED', '2025-12-18', '10:00-16:00', 'CONFIRMED', '2025-12-01 09:30:00'),
-- 재난구호 카테고리 (12건 - 35% 신청률)
(NULL, 13, '신준혁', 'user13@welfare24.com', '01011111013', 'COMMUNITY', '2025-09-18', '09:00-17:00', 'COMPLETED', '2025-09-13 10:00:00'),
(NULL, 20, '양지은', 'user20@welfare24.com', '01011111020', 'COMMUNITY', '2025-10-02', '09:00-17:00', 'COMPLETED', '2025-09-27 14:30:00'),
(NULL, 28, '류아영', 'user28@welfare24.com', '01011111028', 'COMMUNITY', '2025-10-16', '09:00-17:00', 'COMPLETED', '2025-10-11 11:15:00'),
(NULL, 36, '심우빈', 'user36@welfare24.com', '01011111036', 'COMMUNITY', '2025-10-30', '09:00-17:00', 'COMPLETED', '2025-10-25 09:45:00'),
(NULL, 42, '설현수', 'user42@welfare24.com', '01011111042', 'COMMUNITY', '2025-11-13', '09:00-17:00', 'COMPLETED', '2025-11-08 15:20:00'),
(NULL, 51, '복소율', 'user51@welfare24.com', '01011111051', 'COMMUNITY', '2025-11-27', '09:00-17:00', 'COMPLETED', '2025-11-22 10:40:00'),
(NULL, 57, '팽유진', 'user57@welfare24.com', '01011111057', 'COMMUNITY', '2025-12-11', '09:00-17:00', 'COMPLETED', '2025-12-06 13:00:00'),
(NULL, 64, '한시원', 'user64@welfare24.com', '01011111064', 'COMMUNITY', '2025-12-25', '09:00-17:00', 'COMPLETED', '2025-12-20 09:30:00'),
(NULL, 70, '유건우', 'user70@welfare24.com', '01011111070', 'COMMUNITY', '2025-12-14', '09:00-17:00', 'CONFIRMED', '2025-12-01 15:00:00'),
(NULL, NULL, '긴급출동', 'volunteer19@test.com', '01099990019', 'COMMUNITY', '2025-10-20', '09:00-17:00', 'COMPLETED', '2025-10-15 11:00:00'),
(NULL, NULL, '희망구조', 'volunteer20@test.com', '01099990020', 'COMMUNITY', '2025-11-20', '09:00-17:00', 'COMPLETED', '2025-11-15 14:00:00'),
(NULL, NULL, '재난지원', 'volunteer21@test.com', '01099990021', 'COMMUNITY', '2025-12-18', '09:00-17:00', 'COMPLETED', '2025-12-13 10:30:00'),
-- 문화행사 카테고리 (10건 - 28% 신청률)
(NULL, 16, '조유나', 'user16@welfare24.com', '01011111016', 'EDUCATION', '2025-09-25', '13:00-17:00', 'COMPLETED', '2025-09-20 10:15:00'),
(NULL, 32, '성다인', 'user32@welfare24.com', '01011111032', 'EDUCATION', '2025-10-09', '13:00-17:00', 'COMPLETED', '2025-10-04 14:30:00'),
(NULL, 43, '길지민', 'user43@welfare24.com', '01011111043', 'EDUCATION', '2025-10-23', '13:00-17:00', 'COMPLETED', '2025-10-18 11:00:00'),
(NULL, 54, '견태호', 'user54@welfare24.com', '01011111054', 'EDUCATION', '2025-11-06', '13:00-17:00', 'COMPLETED', '2025-11-01 09:45:00'),
(NULL, 65, '오채원', 'user65@welfare24.com', '01011111065', 'EDUCATION', '2025-11-20', '13:00-17:00', 'COMPLETED', '2025-11-15 15:30:00'),
(NULL, 73, '양지유', 'user73@welfare24.com', '01011111073', 'EDUCATION', '2025-12-04', '13:00-17:00', 'COMPLETED', '2025-11-29 10:20:00'),
(NULL, 79, '서예은', 'user79@welfare24.com', '01011111079', 'EDUCATION', '2025-12-18', '13:00-17:00', 'COMPLETED', '2025-12-13 13:45:00'),
(NULL, 83, '전하은', 'user83@welfare24.com', '01011111083', 'EDUCATION', '2025-11-30', '13:00-17:00', 'COMPLETED', '2025-11-25 09:00:00'),
(NULL, NULL, '문화나래', 'volunteer22@test.com', '01099990022', 'EDUCATION', '2025-11-10', '13:00-17:00', 'COMPLETED', '2025-11-05 11:30:00'),
(NULL, NULL, '예술꿈터', 'volunteer23@test.com', '01099990023', 'EDUCATION', '2025-12-15', '13:00-17:00', 'COMPLETED', '2025-12-10 14:15:00');

-- 9-10-3. 복지 진단 데이터 (복지서비스 이용 비율 차트용)
INSERT INTO welfare_diagnoses (member_id, birth_date, age, gender, household_size, income_level, sido, sigungu, is_disabled, is_single_parent, is_elderly_living_alone, is_low_income, matched_services_count, total_matching_score, save_consent, created_at) VALUES
-- 복지 진단 이용자 데이터 (다양한 조건)
(4, '1995-06-08', 29, 'FEMALE', 3, 'LEVEL_2', '서울특별시', '강남구', FALSE, FALSE, FALSE, TRUE, 8, 245, TRUE, '2025-07-25 10:30:00'),
(7, '1983-09-03', 41, 'MALE', 4, 'LEVEL_3', '서울특별시', '서초구', FALSE, FALSE, FALSE, FALSE, 5, 180, TRUE, '2025-08-02 14:15:00'),
(11, '1987-10-05', 37, 'MALE', 2, 'LEVEL_2', '경기도', '성남시', FALSE, FALSE, FALSE, TRUE, 12, 320, TRUE, '2025-08-15 09:45:00'),
(14, '1993-11-08', 31, 'FEMALE', 1, 'LEVEL_1', '서울특별시', '마포구', FALSE, TRUE, FALSE, TRUE, 15, 410, TRUE, '2025-08-22 16:20:00'),
(18, '1992-09-12', 32, 'FEMALE', 4, 'LEVEL_3', '인천광역시', '남동구', FALSE, FALSE, FALSE, FALSE, 6, 195, TRUE, '2025-09-03 11:00:00'),
(22, '1997-02-28', 27, 'FEMALE', 2, 'LEVEL_2', '경기도', '수원시', FALSE, FALSE, FALSE, TRUE, 9, 275, TRUE, '2025-09-10 13:30:00'),
(25, '1991-08-09', 33, 'MALE', 3, 'LEVEL_2', '서울특별시', '송파구', TRUE, FALSE, FALSE, TRUE, 18, 520, TRUE, '2025-09-18 10:15:00'),
(30, '1996-09-11', 28, 'FEMALE', 1, 'LEVEL_1', '부산광역시', '해운대구', FALSE, TRUE, FALSE, TRUE, 14, 385, TRUE, '2025-09-25 15:45:00'),
(33, '1983-07-03', 41, 'MALE', 5, 'LEVEL_4', '서울특별시', '강서구', FALSE, FALSE, FALSE, FALSE, 4, 140, TRUE, '2025-10-02 09:00:00'),
(38, '1991-11-06', 33, 'MALE', 3, 'LEVEL_2', '대구광역시', '수성구', FALSE, FALSE, FALSE, TRUE, 10, 290, TRUE, '2025-10-08 14:30:00'),
(42, '1986-12-11', 38, 'MALE', 4, 'LEVEL_3', '경기도', '고양시', TRUE, FALSE, FALSE, FALSE, 16, 465, TRUE, '2025-10-15 11:20:00'),
(47, '1996-06-05', 28, 'FEMALE', 2, 'LEVEL_2', '서울특별시', '영등포구', FALSE, FALSE, FALSE, TRUE, 11, 315, TRUE, '2025-10-22 16:00:00'),
(51, '1992-08-27', 32, 'FEMALE', 1, 'LEVEL_1', '광주광역시', '서구', FALSE, TRUE, FALSE, TRUE, 13, 355, TRUE, '2025-10-29 10:45:00'),
(55, '1997-07-16', 27, 'FEMALE', 3, 'LEVEL_2', '대전광역시', '유성구', FALSE, FALSE, FALSE, TRUE, 8, 240, TRUE, '2025-11-05 13:15:00'),
(58, '1984-05-26', 40, 'MALE', 2, 'LEVEL_2', '서울특별시', '관악구', FALSE, FALSE, FALSE, TRUE, 9, 265, TRUE, '2025-11-12 09:30:00'),
(62, '1987-06-18', 37, 'MALE', 4, 'LEVEL_3', '경기도', '용인시', FALSE, FALSE, FALSE, FALSE, 6, 185, TRUE, '2025-11-18 15:00:00'),
(66, '1983-08-10', 41, 'MALE', 1, 'LEVEL_1', '서울특별시', '종로구', FALSE, FALSE, TRUE, TRUE, 20, 580, TRUE, '2025-11-25 11:45:00'),
(70, '1990-08-02', 34, 'MALE', 3, 'LEVEL_2', '울산광역시', '남구', TRUE, FALSE, FALSE, TRUE, 17, 490, TRUE, '2025-12-02 14:20:00'),
(75, '1998-11-07', 26, 'FEMALE', 2, 'LEVEL_2', '세종특별자치시', NULL, FALSE, FALSE, FALSE, TRUE, 7, 210, TRUE, '2025-12-08 10:00:00'),
(78, '1984-08-16', 40, 'MALE', 5, 'LEVEL_4', '경기도', '화성시', FALSE, FALSE, FALSE, FALSE, 5, 165, TRUE, '2025-12-15 16:30:00'),
(82, '1986-09-08', 38, 'MALE', 3, 'LEVEL_2', '서울특별시', '동작구', FALSE, FALSE, FALSE, TRUE, 10, 295, TRUE, '2025-12-22 09:15:00'),
(85, '1999-07-17', 25, 'FEMALE', 1, 'LEVEL_1', '제주특별자치도', '제주시', FALSE, TRUE, FALSE, TRUE, 12, 340, TRUE, '2025-12-28 13:00:00'),
(88, '1988-05-26', 36, 'MALE', 4, 'LEVEL_3', '경상남도', '창원시', TRUE, FALSE, FALSE, FALSE, 14, 405, TRUE, '2025-11-03 11:30:00'),
(92, '1983-06-18', 41, 'MALE', 2, 'LEVEL_2', '전라북도', '전주시', FALSE, FALSE, FALSE, TRUE, 8, 235, TRUE, '2025-11-18 15:45:00'),
(95, '1997-03-27', 27, 'FEMALE', 3, 'LEVEL_2', '충청남도', '천안시', FALSE, FALSE, FALSE, TRUE, 9, 270, TRUE, '2025-11-28 10:20:00'),
-- 비회원 진단 데이터
(NULL, '1975-03-15', 49, 'MALE', 1, 'LEVEL_1', '서울특별시', '강북구', FALSE, FALSE, TRUE, TRUE, 22, 620, TRUE, '2025-08-10 14:00:00'),
(NULL, '1960-08-22', 64, 'FEMALE', 1, 'LEVEL_1', '부산광역시', '동래구', FALSE, FALSE, TRUE, TRUE, 25, 710, TRUE, '2025-09-05 10:30:00'),
(NULL, '1988-12-05', 36, 'FEMALE', 4, 'LEVEL_2', '경기도', '안양시', FALSE, TRUE, FALSE, TRUE, 16, 445, TRUE, '2025-09-28 15:15:00'),
(NULL, '1955-04-18', 69, 'MALE', 2, 'LEVEL_2', '대구광역시', '중구', TRUE, FALSE, FALSE, TRUE, 28, 790, TRUE, '2025-10-12 11:00:00'),
(NULL, '1992-07-30', 32, 'MALE', 3, 'LEVEL_3', '인천광역시', '연수구', FALSE, FALSE, FALSE, FALSE, 5, 155, TRUE, '2025-11-08 13:45:00'),
(NULL, '1978-11-12', 46, 'FEMALE', 5, 'LEVEL_2', '광주광역시', '북구', FALSE, TRUE, FALSE, TRUE, 13, 375, TRUE, '2025-12-01 09:20:00'),
(NULL, '1965-02-28', 59, 'MALE', 1, 'LEVEL_1', '서울특별시', '노원구', TRUE, FALSE, TRUE, TRUE, 30, 850, TRUE, '2025-12-20 16:00:00'),
(NULL, '1995-09-08', 29, 'FEMALE', 2, 'LEVEL_2', '경기도', '부천시', FALSE, FALSE, FALSE, TRUE, 9, 260, TRUE, '2025-11-10 10:45:00'),
(NULL, '1982-06-20', 42, 'MALE', 4, 'LEVEL_3', '대전광역시', '서구', FALSE, FALSE, FALSE, FALSE, 6, 180, TRUE, '2025-11-22 14:30:00'),
(NULL, '1970-01-05', 54, 'FEMALE', 1, 'LEVEL_1', '강원도', '춘천시', FALSE, FALSE, TRUE, TRUE, 21, 595, TRUE, '2025-12-02 11:15:00');

-- 9-10-4. 복지지도 이용 데이터 (관심 복지서비스)
INSERT INTO favorite_welfare_services (member_id, service_id, service_name, service_purpose, department, apply_method, support_type, created_at) VALUES
(4, 'WF001', '기초생활수급자 생계급여', '저소득층 가구의 기본적인 생활 보장', '보건복지부', '주민센터 방문', '현금지원', '2025-08-15 10:00:00'),
(7, 'WF002', '장애인연금', '중증장애인의 근로능력 상실로 인한 소득감소 보전', '보건복지부', '주민센터 방문', '현금지원', '2025-08-20 14:30:00'),
(11, 'WF003', '노인돌봄서비스', '독거노인 및 취약노인에 대한 돌봄서비스 제공', '보건복지부', '주민센터 방문', '서비스지원', '2025-09-05 09:15:00'),
(14, 'WF004', '한부모가족지원', '한부모가족의 자립능력 배양 및 생활안정 도모', '여성가족부', '온라인 신청', '현금지원', '2025-09-12 16:00:00'),
(18, 'WF005', '영유아보육료', '영유아 보육서비스 이용비용 지원', '보건복지부', '온라인 신청', '바우처', '2025-09-25 11:30:00'),
(22, 'WF006', '아동수당', '아동의 건강한 성장 환경 조성을 위한 지원', '보건복지부', '온라인 신청', '현금지원', '2025-10-03 10:45:00'),
(25, 'WF007', '장애인활동지원서비스', '장애인의 자립생활 및 사회참여 지원', '보건복지부', '주민센터 방문', '서비스지원', '2025-10-15 14:20:00'),
(30, 'WF008', '긴급복지지원', '위기상황에 처한 저소득층에 대한 신속한 지원', '보건복지부', '주민센터 방문', '현금지원', '2025-10-28 09:00:00'),
(33, 'WF009', '기초연금', '노인에게 안정적인 소득기반 제공', '보건복지부', '주민센터 방문', '현금지원', '2025-11-05 15:30:00'),
(38, 'WF010', '국민기초생활보장 의료급여', '저소득층 의료비 지원', '보건복지부', '주민센터 방문', '의료지원', '2025-11-12 11:00:00'),
(42, 'WF001', '기초생활수급자 생계급여', '저소득층 가구의 기본적인 생활 보장', '보건복지부', '주민센터 방문', '현금지원', '2025-11-20 10:30:00'),
(47, 'WF004', '한부모가족지원', '한부모가족의 자립능력 배양 및 생활안정 도모', '여성가족부', '온라인 신청', '현금지원', '2025-11-28 14:15:00'),
(51, 'WF006', '아동수당', '아동의 건강한 성장 환경 조성을 위한 지원', '보건복지부', '온라인 신청', '현금지원', '2025-12-05 09:45:00'),
(55, 'WF003', '노인돌봄서비스', '독거노인 및 취약노인에 대한 돌봄서비스 제공', '보건복지부', '주민센터 방문', '서비스지원', '2025-12-12 16:00:00'),
(58, 'WF009', '기초연금', '노인에게 안정적인 소득기반 제공', '보건복지부', '주민센터 방문', '현금지원', '2025-12-20 11:30:00'),
(62, 'WF002', '장애인연금', '중증장애인의 근로능력 상실로 인한 소득감소 보전', '보건복지부', '주민센터 방문', '현금지원', '2025-12-28 10:00:00'),
(66, 'WF007', '장애인활동지원서비스', '장애인의 자립생활 및 사회참여 지원', '보건복지부', '주민센터 방문', '서비스지원', '2025-11-05 14:45:00'),
(70, 'WF008', '긴급복지지원', '위기상황에 처한 저소득층에 대한 신속한 지원', '보건복지부', '주민센터 방문', '현금지원', '2025-11-15 09:30:00'),
(75, 'WF005', '영유아보육료', '영유아 보육서비스 이용비용 지원', '보건복지부', '온라인 신청', '바우처', '2025-11-25 15:00:00'),
(78, 'WF010', '국민기초생활보장 의료급여', '저소득층 의료비 지원', '보건복지부', '주민센터 방문', '의료지원', '2025-12-01 11:20:00');

-- 9-9. 기존 회원들을 위한 알림 설정 초기 데이터 (모든 알림 활성화)
INSERT INTO notification_settings (member_id, event_notification, donation_notification, volunteer_notification, faq_answer_notification)
SELECT
    member_id,
    TRUE,
    TRUE,
    TRUE,
    TRUE
FROM member
WHERE member_id NOT IN (SELECT member_id FROM notification_settings)
ON DUPLICATE KEY UPDATE setting_id=setting_id;

-- ========================================================================
-- PART 10: 데이터베이스 설정 복원
-- ========================================================================

SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 1;

COMMIT;

-- ========================================================================
-- PART 11: 유틸리티 뷰 (View) 생성
-- ========================================================================

-- 11-1. 활성 회원만 조회하는 뷰
CREATE OR REPLACE VIEW active_members AS
SELECT * FROM member WHERE deleted_at IS NULL AND status = 'ACTIVE';

-- 11-2. 진행 중인 봉사활동 뷰
CREATE OR REPLACE VIEW active_volunteer_activities AS
SELECT * FROM volunteer_activities
WHERE status = 'RECRUITING' AND activity_date >= CURDATE()
ORDER BY activity_date ASC;

-- 11-3. 최근 기부 내역 뷰 (최근 30일)
CREATE OR REPLACE VIEW recent_donations AS
SELECT * FROM donations
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
ORDER BY created_at DESC;

USE springmvc;

ALTER TABLE member
ADD COLUMN last_login_fail_at TIMESTAMP NULL COMMENT '마지막 로그인 실패 일시' AFTER login_fail_count;

ALTER TABLE member
ADD COLUMN account_locked_until TIMESTAMP NULL COMMENT '계정 잠금 해제 시간' AFTER last_login_fail_at;
 ALTER TABLE volunteer_applications MODIFY COLUMN activity_id      
  BIGINT UNSIGNED NULL COMMENT '봉사 활동 ID (일반 신청의 경우      
  NULL)';
   -- birth를 NULL 허용으로 변경
  ALTER TABLE member MODIFY COLUMN birth DATE NULL;

  -- gender를 NULL 허용으로 변경
  ALTER TABLE member MODIFY COLUMN gender ENUM('MALE', 'FEMALE',
   'OTHER') NULL DEFAULT 'OTHER';

 USE springmvc;

  CREATE TABLE IF NOT EXISTS calendar_events (
      -- 기본키
      event_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY
  COMMENT '일정 ID',

      -- 외래키
      member_id BIGINT UNSIGNED NOT NULL COMMENT '회원 
  고유번호',

      -- 일정 정보
      title VARCHAR(200) NOT NULL COMMENT '일정 제목',
      description TEXT NULL COMMENT '일정 설명',
      event_date DATE NOT NULL COMMENT '일정 날짜',
      event_time TIME NULL COMMENT '일정 시간',
      event_type ENUM('PERSONAL', 'DONATION', 'VOLUNTEER',
  'ETC') NOT NULL DEFAULT 'PERSONAL' COMMENT '일정 유형',

      -- 알림 설정
      reminder_enabled BOOLEAN NOT NULL DEFAULT TRUE COMMENT        
  '알림 활성화 여부',
      remind_before_days INT UNSIGNED NOT NULL DEFAULT 1 COMMENT    
   '며칠 전 알림 (기본 1일)',

      -- 상태
      status ENUM('SCHEDULED', 'COMPLETED', 'CANCELLED') NOT        
  NULL DEFAULT 'SCHEDULED' COMMENT '일정 상태',

      -- 시스템 정보
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP       
  COMMENT '등록일',
      updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON    
   UPDATE CURRENT_TIMESTAMP COMMENT '수정일',

      INDEX idx_member_id (member_id),
      INDEX idx_event_date (event_date),
      INDEX idx_event_type (event_type),
      INDEX idx_status (status),
      INDEX idx_composite_member_date (member_id, event_date),      

      CHECK (remind_before_days <= 30),

      FOREIGN KEY (member_id) REFERENCES member(member_id) ON       
  DELETE CASCADE
  ) ENGINE=InnoDB COMMENT='캘린더 일정 테이블';

-- 8. 사용자 질문 테이블 (FAQ)
CREATE TABLE user_questions (
    -- 기본키
    question_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '질문 ID',

    -- 작성자 정보
    user_id VARCHAR(255) NULL COMMENT '로그인 사용자 ID (email, 비회원은 NULL)',
    user_name VARCHAR(100) NOT NULL COMMENT '작성자 이름',
    user_email VARCHAR(255) NOT NULL COMMENT '작성자 이메일',

    -- 질문 정보
    category VARCHAR(50) NOT NULL COMMENT '질문 카테고리',
    title VARCHAR(200) NOT NULL COMMENT '질문 제목',
    content TEXT NOT NULL COMMENT '질문 내용',

    -- 답변 정보
    answer TEXT NULL COMMENT '답변 내용',
    answered_by VARCHAR(255) NULL COMMENT '답변자 ID',
    answered_at TIMESTAMP NULL COMMENT '답변 일시',

    -- 상태 정보
    status ENUM('pending', 'answered') NOT NULL DEFAULT 'pending' COMMENT '답변 상태',
    views INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '조회수',

    -- 시스템 정보
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',

    INDEX idx_user_email (user_email),
    INDEX idx_user_id (user_id),
    INDEX idx_category (category),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at DESC)
) ENGINE=InnoDB COMMENT='사용자 질문 테이블 (FAQ)';


-- 알림 설정 테이블 확인 스크립트

USE springmvc;

-- 1. 테이블 존재 확인
SELECT
    TABLE_NAME,
    TABLE_ROWS,
    CREATE_TIME,
    UPDATE_TIME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'springmvc'
AND TABLE_NAME = 'notification_settings';

-- 2. 테이블 구조 확인
DESC notification_settings;

-- 3. 데이터 확인
SELECT * FROM notification_settings;

-- 4. 테이블이 없을 경우 생성
CREATE TABLE IF NOT EXISTS notification_settings (
    setting_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '설정 ID',
    member_id BIGINT UNSIGNED NOT NULL COMMENT '회원 고유번호',
    event_notification BOOLEAN NOT NULL DEFAULT TRUE COMMENT '일정 알림',
    donation_notification BOOLEAN NOT NULL DEFAULT TRUE COMMENT '기부 알림',
    volunteer_notification BOOLEAN NOT NULL DEFAULT TRUE COMMENT '봉사 활동 알림',
    faq_answer_notification BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'FAQ 답변 알림',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    UNIQUE INDEX idx_member_id (member_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='회원별 알림 설정 테이블';

-- 5. 기존 회원 초기 데이터 생성
INSERT INTO notification_settings (member_id, event_notification, donation_notification, volunteer_notification, faq_answer_notification)
SELECT member_id, TRUE, TRUE, TRUE, TRUE
FROM member
WHERE member_id NOT IN (SELECT member_id FROM notification_settings)
ON DUPLICATE KEY UPDATE setting_id=setting_id;

-- 6. 최종 확인
SELECT
    ns.*,
    m.email,
    m.name
FROM notification_settings ns
JOIN member m ON ns.member_id = m.member_id
ORDER BY ns.member_id;


-- ========================================
-- 알림 설정 테이블 생성 및 초기화 스크립트
-- ========================================

USE springmvc;

-- 1. notification_settings 테이블이 존재하는지 확인
SELECT
    IF(COUNT(*) > 0, 'notification_settings 테이블이 이미 존재합니다.', 'notification_settings 테이블이 존재하지 않습니다. 아래 CREATE TABLE을 실행하세요.') AS status
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'springmvc'
AND TABLE_NAME = 'notification_settings';

-- 2. notification_settings 테이블 생성 (테이블이 없을 경우에만 실행)
CREATE TABLE IF NOT EXISTS notification_settings (
    setting_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '설정 ID',
    member_id BIGINT UNSIGNED NOT NULL COMMENT '회원 고유번호',
    event_notification BOOLEAN NOT NULL DEFAULT TRUE COMMENT '일정 알림',
    donation_notification BOOLEAN NOT NULL DEFAULT TRUE COMMENT '기부 알림',
    volunteer_notification BOOLEAN NOT NULL DEFAULT TRUE COMMENT '봉사 활동 알림',
    faq_answer_notification BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'FAQ 답변 알림',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    UNIQUE INDEX idx_member_id (member_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='회원별 알림 설정 테이블';

-- 3. 기존 회원들의 알림 설정 초기 데이터 생성
INSERT INTO notification_settings (member_id, event_notification, donation_notification, volunteer_notification, faq_answer_notification)
SELECT
    member_id,
    TRUE,  -- 기본값: 모든 알림 활성화
    TRUE,
    TRUE,
    TRUE
FROM member
WHERE deleted_at IS NULL  -- 탈퇴하지 않은 회원만
AND member_id NOT IN (SELECT member_id FROM notification_settings)
ON DUPLICATE KEY UPDATE setting_id = setting_id;  -- 이미 존재하면 업데이트하지 않음

-- 4. 테이블 구조 확인
DESC notification_settings;

-- 5. 생성된 데이터 확인 (최근 10개)
SELECT
    ns.setting_id,
    ns.member_id,
    m.email,
    m.name,
    ns.event_notification AS '일정알림',
    ns.donation_notification AS '기부알림',
    ns.volunteer_notification AS '봉사알림',
    ns.faq_answer_notification AS 'FAQ알림',
    ns.created_at AS '생성일',
    ns.updated_at AS '수정일'
FROM notification_settings ns
JOIN member m ON ns.member_id = m.member_id
WHERE m.deleted_at IS NULL
ORDER BY ns.created_at DESC
LIMIT 10;

-- 6. 통계 정보
SELECT
    '전체 회원 수' AS '구분',
    COUNT(*) AS '개수'
FROM member
WHERE deleted_at IS NULL

UNION ALL

SELECT
    '알림 설정이 있는 회원 수' AS '구분',
    COUNT(*) AS '개수'
FROM notification_settings ns
JOIN member m ON ns.member_id = m.member_id
WHERE m.deleted_at IS NULL;


  USE springmvc;

  -- 모든 기존 알림 삭제 (소프트 삭제)
  UPDATE notifications
  SET deleted_at = NOW()
  WHERE deleted_at IS NULL;
   SELECT
      member_id,
      email,
      pwd,
      CHAR_LENGTH(pwd) AS pwd_length,
      role
  FROM member
  WHERE email = 'admin@welfare24.com';
  
    UPDATE member
  SET
      pwd = '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
      login_fail_count = 0,
      last_login_fail_at = NULL,
      account_locked_until = NULL,
      status = 'ACTIVE'
  WHERE email = 'admin@welfare24.com';

-- ================================================
-- 공지사항 샘플 데이터
-- 프로젝트 컨셉에 맞는 현실적인 공지사항 데이터
-- ================================================

-- Safe mode 임시 비활성화
SET SQL_SAFE_UPDATES = 0;

-- 기존 공지사항 삭제 (테스트 데이터 정리)
DELETE FROM notices;

-- 관리자 member_id 조회 (동적으로 사용)
SET @admin_member_id = (SELECT member_id FROM member WHERE email = 'admin@welfare24.com' LIMIT 1);

-- 1. 긴급/중요 공지사항 (상단 고정)
INSERT INTO notices (admin_id, title, content, category, priority, is_pinned, published_at, created_at) VALUES
(@admin_member_id, '복지24 서비스 이용 안내',
'복지24는 복지 서비스 정보를 제공하는 플랫폼입니다.

주요 기능:
- 맞춤형 복지 혜택 검색
- 온라인 기부 및 봉사활동 신청
- 복지시설 위치 확인

회원가입 후 이용하실 수 있습니다.',
'SYSTEM', 'HIGH', TRUE, '2025-01-01 00:00:00', '2025-01-01 09:00:00'),

(@admin_member_id, '설 연휴 문의 안내',
'설 연휴 기간에는 문의 답변이 지연될 수 있습니다.

휴무 기간: 2025년 1월 28일 ~ 2월 1일
정상 운영: 2월 3일부터

긴급 문의는 이메일로 보내주시면 순차적으로 답변드리겠습니다.',
'GENERAL', 'URGENT', TRUE, '2025-01-20 00:00:00', '2025-01-20 14:30:00');

-- 2. 시스템 업데이트 공지
INSERT INTO notices (admin_id, title, content, category, priority, published_at, created_at) VALUES
(@admin_member_id, '2025년 복지 혜택 확대 안내',
'2025년부터 정부 복지 정책이 확대됩니다.

주요 변경사항:
1. 기초생활수급자 선정 기준 완화 (중위소득 30% → 32%)
2. 청년 주거급여 신설 (만 19~34세, 월 최대 30만원)
3. 한부모가정 지원 확대 (양육비 월 20만원 → 25만원)
4. 장애인 활동지원 시간 증가 (월 200시간 → 240시간)

복지 혜택 진단 메뉴에서 자세한 정보를 확인하세요.',
'UPDATE', 'HIGH', '2025-01-10 00:00:00', '2025-01-10 10:00:00'),

(@admin_member_id, '웹사이트 개선 안내',
'복지24 웹사이트가 개선되었습니다.

개선 내용:
- 검색 속도 향상
- 화면 디자인 개선
- 안정성 강화

더 편리하게 이용하실 수 있습니다.',
'UPDATE', 'NORMAL', '2025-01-15 00:00:00', '2025-01-15 11:00:00');

-- 3. 일반 공지사항
INSERT INTO notices (admin_id, title, content, category, priority, published_at, created_at) VALUES
(@admin_member_id, '회원가입 안내',
'복지24 회원가입 방법을 안내드립니다.

가입 방법:
1. 회원가입 버튼 클릭
2. 이메일과 비밀번호 입력
3. 기본 정보 입력
4. 가입 완료

로그인 후 모든 서비스를 이용하실 수 있습니다.',
'GENERAL', 'NORMAL', '2025-01-01 00:00:00', '2025-01-01 10:00:00'),

(@admin_member_id, '기부 및 봉사활동 안내',
'온라인으로 기부 및 봉사활동을 신청할 수 있습니다.

이용 방법:
- 기부: 기부하기 메뉴에서 금액 선택 후 신청
- 봉사활동: 봉사활동 메뉴에서 활동 검색 후 신청

기부금 영수증은 마이페이지에서 확인하실 수 있습니다.',
'GENERAL', 'NORMAL', '2025-01-05 00:00:00', '2025-01-05 14:00:00');

-- 4. 시스템 점검 공지
INSERT INTO notices (admin_id, title, content, category, priority, published_at, created_at) VALUES
(@admin_member_id, '서버 점검 안내',
'안정적인 서비스를 위해 서버 점검을 진행합니다.

점검 일시: 2025년 2월 10일(월) 02:00 ~ 06:00
점검 내용: 서버 점검 및 보안 업데이트

점검 시간 동안 서비스 이용이 불가능합니다.
이용에 불편을 드려 죄송합니다.',
'MAINTENANCE', 'NORMAL', '2025-02-01 00:00:00', '2025-02-01 15:00:00');

-- 5. 추가 공지사항
INSERT INTO notices (admin_id, title, content, category, priority, published_at, created_at) VALUES
(@admin_member_id, '개인정보 처리방침 변경 안내',
'개인정보 처리방침이 변경됩니다.

시행일: 2025년 2월 1일

주요 변경사항:
- 개인정보 보유기간 명시
- 제3자 제공 항목 추가
- 정보주체 권리 강화

자세한 내용은 홈페이지 하단에서 확인하실 수 있습니다.',
'SYSTEM', 'NORMAL', '2025-01-25 00:00:00', '2025-01-25 09:00:00'),

(@admin_member_id, '복지시설 위치 검색 기능 안내',
'지도에서 복지시설 위치를 검색할 수 있습니다.

이용 방법:
1. 지도 메뉴 선택
2. 지역 또는 시설명 검색
3. 상세 정보 확인

전국 복지시설 정보를 제공합니다.',
'GENERAL', 'NORMAL', '2025-01-12 00:00:00', '2025-01-12 13:00:00'),

(@admin_member_id, 'FAQ 이용 안내',
'자주 묻는 질문은 FAQ에서 확인하실 수 있습니다.

FAQ 주요 내용:
- 회원가입 방법
- 복지 서비스 신청 방법
- 기부금 영수증 발급
- 봉사활동 신청 방법

홈페이지 상단 FAQ 메뉴를 이용해주세요.',
'GENERAL', 'NORMAL', '2025-01-18 00:00:00', '2025-01-18 16:00:00'),

(@admin_member_id, '복지 혜택 신청 방법 안내',
'복지 혜택을 신청하는 방법을 안내드립니다.

신청 절차:
1. 복지 혜택 진단 실시
2. 해당되는 혜택 확인
3. 온라인 또는 방문 신청

자세한 내용은 각 복지 혜택 안내를 참고하세요.',
'GENERAL', 'NORMAL', '2025-01-08 00:00:00', '2025-01-08 14:00:00');

-- 조회수 임의 설정 (현실감 부여)
UPDATE notices SET views = 1523 WHERE title LIKE '%서비스 이용%';
UPDATE notices SET views = 892 WHERE title LIKE '%설 연휴%';
UPDATE notices SET views = 1247 WHERE title LIKE '%복지 혜택 확대%';
UPDATE notices SET views = 634 WHERE title LIKE '%웹사이트 개선%';
UPDATE notices SET views = 1089 WHERE title LIKE '%회원가입 안내%';
UPDATE notices SET views = 756 WHERE title LIKE '%기부 및 봉사%';
UPDATE notices SET views = 445 WHERE title LIKE '%서버 점검%';
UPDATE notices SET views = 567 WHERE title LIKE '%개인정보%';
UPDATE notices SET views = 823 WHERE title LIKE '%복지시설 위치%';
UPDATE notices SET views = 489 WHERE title LIKE '%FAQ%';
UPDATE notices SET views = 678 WHERE title LIKE '%복지 혜택 신청 방법%';

-- Safe mode 다시 활성화
SET SQL_SAFE_UPDATES = 1;

-- 봉사 신청 테이블에 시설 매칭 및 승인 관련 컬럼 추가
-- 관리자가 봉사 활동을 승인하고 시설을 매칭할 수 있도록 함
-- 참고: 컬럼이 이미 존재하면 오류가 발생하므로 조건부 실행

USE springmvc;

-- 컬럼 존재 여부 확인 후 추가하는 프로시저
DELIMITER //
DROP PROCEDURE IF EXISTS add_volunteer_columns//
CREATE PROCEDURE add_volunteer_columns()
BEGIN
    -- approved_by 컬럼이 없으면 추가
    IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS
                   WHERE TABLE_SCHEMA = 'springmvc' AND TABLE_NAME = 'volunteer_applications' AND COLUMN_NAME = 'approved_by') THEN
        ALTER TABLE volunteer_applications ADD COLUMN approved_by BIGINT UNSIGNED NULL COMMENT '승인한 관리자 ID';
    END IF;

    -- approved_at 컬럼이 없으면 추가
    IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS
                   WHERE TABLE_SCHEMA = 'springmvc' AND TABLE_NAME = 'volunteer_applications' AND COLUMN_NAME = 'approved_at') THEN
        ALTER TABLE volunteer_applications ADD COLUMN approved_at TIMESTAMP NULL COMMENT '승인 일시';
    END IF;

    -- assigned_facility_name 컬럼이 없으면 추가
    IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS
                   WHERE TABLE_SCHEMA = 'springmvc' AND TABLE_NAME = 'volunteer_applications' AND COLUMN_NAME = 'assigned_facility_name') THEN
        ALTER TABLE volunteer_applications ADD COLUMN assigned_facility_name VARCHAR(200) NULL COMMENT '배정된 복지시설명';
    END IF;

    -- assigned_facility_address 컬럼이 없으면 추가
    IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS
                   WHERE TABLE_SCHEMA = 'springmvc' AND TABLE_NAME = 'volunteer_applications' AND COLUMN_NAME = 'assigned_facility_address') THEN
        ALTER TABLE volunteer_applications ADD COLUMN assigned_facility_address VARCHAR(500) NULL COMMENT '배정된 시설 주소';
    END IF;

    -- assigned_facility_lat 컬럼이 없으면 추가
    IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS
                   WHERE TABLE_SCHEMA = 'springmvc' AND TABLE_NAME = 'volunteer_applications' AND COLUMN_NAME = 'assigned_facility_lat') THEN
        ALTER TABLE volunteer_applications ADD COLUMN assigned_facility_lat DECIMAL(10, 8) NULL COMMENT '시설 위도';
    END IF;

    -- assigned_facility_lng 컬럼이 없으면 추가
    IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS
                   WHERE TABLE_SCHEMA = 'springmvc' AND TABLE_NAME = 'volunteer_applications' AND COLUMN_NAME = 'assigned_facility_lng') THEN
        ALTER TABLE volunteer_applications ADD COLUMN assigned_facility_lng DECIMAL(11, 8) NULL COMMENT '시설 경도';
    END IF;

    -- admin_note 컬럼이 없으면 추가
    IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS
                   WHERE TABLE_SCHEMA = 'springmvc' AND TABLE_NAME = 'volunteer_applications' AND COLUMN_NAME = 'admin_note') THEN
        ALTER TABLE volunteer_applications ADD COLUMN admin_note TEXT NULL COMMENT '관리자 메모';
    END IF;

    SELECT 'volunteer_applications 컬럼 확인/추가 완료' AS message;
END//
DELIMITER ;

-- 프로시저 실행
CALL add_volunteer_columns();
DROP PROCEDURE IF EXISTS add_volunteer_columns;

-- 인덱스 추가 (존재하면 무시)
-- CREATE INDEX IF NOT EXISTS 문법이 MySQL 8.0+에서만 지원됨
-- 인덱스는 수동으로 확인 후 추가

-- 확인
DESCRIBE volunteer_applications;


-- 회원 상태 변경 이력 테이블 생성
-- 이 테이블은 관리자가 회원 상태를 변경할 때 이력을 기록합니다.

USE springmvc;

-- 기존 테이블이 있다면 삭제
DROP TABLE IF EXISTS member_status_history;

-- 회원 상태 변경 이력 테이블 생성
CREATE TABLE member_status_history (
    -- 기본키
    history_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '이력 ID',

    -- 외래키
    member_id BIGINT UNSIGNED NOT NULL COMMENT '회원 고유번호',
    admin_id BIGINT UNSIGNED NULL COMMENT '처리한 관리자 ID',

    -- 상태 변경 정보
    old_status ENUM('ACTIVE', 'SUSPENDED', 'DORMANT') NOT NULL COMMENT '변경 전 상태',
    new_status ENUM('ACTIVE', 'SUSPENDED', 'DORMANT') NOT NULL COMMENT '변경 후 상태',
    reason VARCHAR(500) NULL COMMENT '변경 사유',

    -- 시스템 정보
    ip_address VARCHAR(45) NULL COMMENT '변경 시 IP 주소',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '변경 일시',

    -- 인덱스
    INDEX idx_member_id (member_id),
    INDEX idx_admin_id (admin_id),
    INDEX idx_created_at (created_at),

    -- 외래키 제약조건
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES member(member_id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='회원 상태 변경 이력 테이블';

-- 초기 데이터 확인
SELECT 'member_status_history 테이블이 성공적으로 생성되었습니다.' AS message;
SELECT COUNT(*) AS total_count FROM member_status_history;

-- volunteer_applications 테이블의 컬럼 확인
USE springmvc;

-- 테이블 구조 확인
DESCRIBE volunteer_applications;

-- 특정 컬럼 존재 여부 확인
SELECT COLUMN_NAME, DATA_TYPE, COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'springmvc'
  AND TABLE_NAME = 'volunteer_applications'
  AND COLUMN_NAME IN ('approved_by', 'approved_at', 'assigned_facility_name', 'assigned_facility_address', 'assigned_facility_lat', 'assigned_facility_lng', 'admin_note')
ORDER BY ORDINAL_POSITION;


-- ========================================================================
-- 하드코딩된 FAQ를 DB로 이동
-- project_faq.jsp의 하드코딩된 FAQ 10개를 faqs 테이블에 삽입
-- ========================================================================

-- 기존 FAQ 데이터 삭제 (중복 방지)
DELETE FROM faqs WHERE faq_id < 100;

-- FAQ 카테고리 확인 및 삽입 (이미 존재하면 무시)
INSERT IGNORE INTO faq_categories (category_code, category_name, display_order) VALUES
('WELFARE', '복지혜택', 1),
('SERVICE', '서비스이용', 2),
('ACCOUNT', '계정관리', 3),
('DONATION', '기부/후원', 4),
('VOLUNTEER', '봉사활동', 5),
('ETC', '기타', 99);

-- 하드코딩된 FAQ 10개 삽입
-- category_id: WELFARE=1, SERVICE=2, ACCOUNT=3, ETC=6
INSERT INTO faqs (category_id, question, answer, order_num, is_active, views, helpful_count) VALUES
-- 1. 복지혜택 - 복지 혜택은 어떻게 찾나요?
(1, '복지 혜택은 어떻게 찾나요?',
'메인 페이지에서 ''복지 혜택 찾기'' 메뉴를 클릭하시면 간단한 정보 입력 후 맞춤형 복지 혜택을 추천받으실 수 있습니다. 나이, 가구 구성, 소득 수준 등의 정보를 입력하시면 AI가 자동으로 적합한 복지 서비스를 매칭해 드립니다.',
1, TRUE, 0, 0),

-- 2. 복지혜택 - 복지 혜택 신청은 어떻게 하나요?
(1, '복지 혜택 신청은 어떻게 하나요?',
'복지 혜택 검색 결과에서 원하는 혜택의 ''신청하기'' 버튼을 클릭하시면 해당 기관의 신청 페이지로 이동합니다. 온라인 신청이 가능한 경우 바로 신청이 가능하며, 방문 신청이 필요한 경우 주변 시설 정보를 안내해 드립니다.',
2, TRUE, 0, 0),

-- 3. 서비스이용 - 복지 지도는 어떻게 사용하나요?
(2, '복지 지도는 어떻게 사용하나요?',
'''복지 지도'' 메뉴에서 현재 위치 또는 주소를 입력하시면 주변의 복지시설을 지도에서 확인하실 수 있습니다. 복지관, 주민센터, 상담센터 등 다양한 시설의 위치, 연락처, 운영시간 정보를 제공합니다.',
1, TRUE, 0, 0),

-- 4. 계정관리 - 회원가입은 필수인가요?
(3, '회원가입은 필수인가요?',
'복지 혜택 검색과 정보 조회는 회원가입 없이도 가능합니다. 다만, 맞춤형 추천 서비스와 신청 내역 관리를 위해서는 회원가입이 필요합니다. 회원가입 시 더욱 편리하게 서비스를 이용하실 수 있습니다.',
1, TRUE, 0, 0),

-- 5. 계정관리 - 비밀번호를 잊어버렸어요
(3, '비밀번호를 잊어버렸어요',
'로그인 페이지에서 ''비밀번호 찾기''를 클릭하시면 가입 시 등록한 이메일 또는 휴대폰 번호로 임시 비밀번호를 발송해 드립니다. 임시 비밀번호로 로그인 후 마이페이지에서 새로운 비밀번호로 변경해 주세요.',
2, TRUE, 0, 0),

-- 6. 복지혜택 - 저소득층 기준은 어떻게 되나요?
(1, '저소득층 기준은 어떻게 되나요?',
'저소득층 기준은 정부 정책에 따라 변동될 수 있으며, 일반적으로 기준 중위소득의 일정 비율 이하를 기준으로 합니다. 정확한 기준은 복지 혜택 찾기에서 소득 정보 입력 시 자동으로 판단되어 적용됩니다.',
3, TRUE, 0, 0),

-- 7. 서비스이용 - 개인정보는 안전한가요?
(2, '개인정보는 안전한가요?',
'복지24는 개인정보보호법에 따라 모든 개인정보를 암호화하여 안전하게 관리하고 있습니다. 수집된 정보는 복지 서비스 매칭 목적으로만 사용되며, 제3자에게 제공되지 않습니다. 자세한 내용은 개인정보 처리방침을 참고해 주세요.',
2, TRUE, 0, 0),

-- 8. 기타 - 서비스 이용 중 오류가 발생했어요
(6, '서비스 이용 중 오류가 발생했어요',
'서비스 이용 중 오류가 발생하신 경우 페이지를 새로고침하거나 브라우저 캐시를 삭제해 보세요. 문제가 계속되는 경우 고객센터(1544-1234)로 문의하시거나 온라인 채팅 상담을 이용해 주세요.',
1, TRUE, 0, 0),

-- 9. 서비스이용 - 봉사 활동은 어떻게 참여하나요?
(2, '봉사 활동은 어떻게 참여하나요?',
'메인 메뉴에서 ''봉사활동'' 메뉴를 선택하시면 다양한 봉사 활동 정보를 확인하실 수 있습니다. 원하시는 활동을 선택한 후 신청 양식을 작성하시면 됩니다. 봉사 완료 후에는 후기를 작성하실 수 있으며, 마이페이지에서 봉사 이력을 관리하실 수 있습니다.',
3, TRUE, 0, 0),

-- 10. 복지혜택 - 기부는 어떻게 하나요?
(1, '기부는 어떻게 하나요?',
'메인 메뉴에서 ''기부하기''를 선택하시면 다양한 기부 분야와 금액을 선택하실 수 있습니다. 정기 기부와 일시 기부 중 선택 가능하며, 신용카드, 계좌이체, 간편결제 등 다양한 결제 수단을 지원합니다. 기부금 영수증 발급도 가능하며, 모든 기부 내역은 마이페이지에서 확인하실 수 있습니다.',
4, TRUE, 0, 0);

-- 삽입 완료 확인
SELECT
    f.faq_id,
    fc.category_name,
    f.question,
    f.order_num,
    f.is_active
FROM faqs f
JOIN faq_categories fc ON f.category_id = fc.category_id
ORDER BY fc.display_order, f.order_num;


-- ========================================================================
-- 봉사활동 카테고리별 신청률 차트 데이터 다양화
-- 노인돌봄 카테고리에 추가 데이터 삽입하여 차트를 더 다양하게 표현
-- ========================================================================

USE springmvc;

-- 노인돌봄 추가 (25건 추가 - 총 55건으로 증가, 약 40%)
INSERT INTO volunteer_applications (activity_id, member_id, applicant_name, applicant_email, applicant_phone, selected_category, volunteer_date, volunteer_time, status, created_at) VALUES
(1, 3, '박민호', 'user03@welfare24.com', '01011111003', 'ELDERLY', '2025-07-10', '10:00-14:00', 'COMPLETED', '2025-07-05 09:00:00'),
(1, 5, '정우진', 'user05@welfare24.com', '01011111005', 'ELDERLY', '2025-07-15', '10:00-14:00', 'COMPLETED', '2025-07-10 10:30:00'),
(1, 8, '윤하은', 'user08@welfare24.com', '01011111008', 'ELDERLY', '2025-07-20', '10:00-14:00', 'COMPLETED', '2025-07-15 11:00:00'),
(1, 12, '오지아', 'user12@welfare24.com', '01011111012', 'ELDERLY', '2025-07-25', '10:00-14:00', 'COMPLETED', '2025-07-20 14:20:00'),
(1, 15, '배정훈', 'user15@welfare24.com', '01011111015', 'ELDERLY', '2025-07-30', '10:00-14:00', 'COMPLETED', '2025-07-25 09:45:00'),
(1, 19, '문성민', 'user19@welfare24.com', '01011111019', 'ELDERLY', '2025-08-05', '10:00-14:00', 'COMPLETED', '2025-08-01 13:00:00'),
(1, 24, '안예림', 'user24@welfare24.com', '01011111024', 'ELDERLY', '2025-08-08', '10:00-14:00', 'COMPLETED', '2025-08-03 10:15:00'),
(1, 28, '류아영', 'user28@welfare24.com', '01011111028', 'ELDERLY', '2025-08-12', '10:00-14:00', 'COMPLETED', '2025-08-08 15:30:00'),
(1, 31, '노현우', 'user31@welfare24.com', '01011111031', 'ELDERLY', '2025-08-18', '10:00-14:00', 'COMPLETED', '2025-08-14 11:45:00'),
(1, 36, '심우빈', 'user36@welfare24.com', '01011111036', 'ELDERLY', '2025-08-22', '10:00-14:00', 'COMPLETED', '2025-08-18 09:00:00'),
(1, 39, '탁서영', 'user39@welfare24.com', '01011111039', 'ELDERLY', '2025-08-28', '10:00-14:00', 'COMPLETED', '2025-08-24 14:00:00'),
(1, 43, '길지민', 'user43@welfare24.com', '01011111043', 'ELDERLY', '2025-09-02', '10:00-14:00', 'COMPLETED', '2025-08-29 10:30:00'),
(1, 47, '빈다은', 'user47@welfare24.com', '01011111047', 'ELDERLY', '2025-09-08', '10:00-14:00', 'COMPLETED', '2025-09-04 16:00:00'),
(1, 52, '도현준', 'user52@welfare24.com', '01011111052', 'ELDERLY', '2025-09-14', '10:00-14:00', 'COMPLETED', '2025-09-10 09:20:00'),
(1, 56, '석재원', 'user56@welfare24.com', '01011111056', 'ELDERLY', '2025-09-18', '10:00-14:00', 'COMPLETED', '2025-09-14 13:45:00'),
(1, 60, '강승민', 'user60@welfare24.com', '01011111060', 'ELDERLY', '2025-09-25', '10:00-14:00', 'COMPLETED', '2025-09-21 11:00:00'),
(1, 64, '한시원', 'user64@welfare24.com', '01011111064', 'ELDERLY', '2025-10-03', '10:00-14:00', 'COMPLETED', '2025-09-29 15:30:00'),
(1, 68, '배준혁', 'user68@welfare24.com', '01011111068', 'ELDERLY', '2025-10-10', '10:00-14:00', 'COMPLETED', '2025-10-06 10:15:00'),
(1, 73, '양지유', 'user73@welfare24.com', '01011111073', 'ELDERLY', '2025-10-18', '10:00-14:00', 'COMPLETED', '2025-10-14 14:00:00'),
(1, 77, '안지안', 'user77@welfare24.com', '01011111077', 'ELDERLY', '2025-10-25', '10:00-14:00', 'COMPLETED', '2025-10-21 09:45:00'),
(1, 81, '류다온', 'user81@welfare24.com', '01011111081', 'ELDERLY', '2025-11-01', '10:00-14:00', 'COMPLETED', '2025-10-28 13:30:00'),
(1, 87, '권준서', 'user87@welfare24.com', '01011111087', 'ELDERLY', '2025-11-08', '10:00-14:00', 'COMPLETED', '2025-11-04 11:20:00'),
(1, 93, '임서윤', 'user93@welfare24.com', '01011111093', 'ELDERLY', '2025-11-15', '10:00-14:00', 'COMPLETED', '2025-11-11 16:00:00'),
(1, 97, '박하영', 'user97@welfare24.com', '01011111097', 'ELDERLY', '2025-11-22', '10:00-14:00', 'COMPLETED', '2025-11-18 10:30:00'),
(1, 99, '국지민', 'user99@welfare24.com', '01011111099', 'ELDERLY', '2025-11-29', '10:00-14:00', 'COMPLETED', '2025-11-25 14:45:00');

-- 카테고리별 분포 확인 (차트 데이터 검증용)
-- 예상 결과: ELDERLY 40%, CHILD 17%, ENVIRONMENT 15%, DISABLED 11%, COMMUNITY 9%, EDUCATION 8%
SELECT
    selected_category,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM volunteer_applications), 1) as percentage
FROM volunteer_applications
GROUP BY selected_category
ORDER BY count DESC;

-- ========================================================================
-- 봉사 후기 샘플 데이터
-- volunteer_reviews 테이블에 후기 데이터 삽입
-- ========================================================================

INSERT INTO volunteer_reviews (member_id, application_id, reviewer_name, title, content, rating, is_visible, helpful_count, created_at) VALUES
-- 노인돌봄 봉사 후기
(4, 1, '이서연', '어르신들과 함께한 따뜻한 하루',
'처음 봉사활동에 참여했는데 정말 뜻깊은 시간이었습니다. 어르신들께서 손주처럼 반겨주셔서 마음이 따뜻해졌어요. 말벗이 되어드리고 함께 산책도 하면서 보람찬 하루를 보냈습니다. 다음에도 꼭 참여하고 싶습니다!',
5, TRUE, 23, '2025-08-16 18:30:00'),

(7, 2, '강지훈', '보람찬 노인복지관 봉사',
'복지관에서 어르신들과 함께 체조도 하고 점심 배식 봉사도 했습니다. 처음에는 어색했지만 어르신들께서 먼저 말씀 걸어주셔서 금방 친해질 수 있었어요. 봉사 후 뿌듯함이 오래 남았습니다.',
5, TRUE, 18, '2025-08-22 17:45:00'),

(11, 3, '한승우', '의미있는 시간이었습니다',
'요양원에서 어르신들의 식사를 도와드리고 대화를 나눴습니다. 평소에 가족들과 떨어져 계시는 분들이 많아서인지 저희가 오니까 정말 반가워하셨어요. 짧은 시간이었지만 서로에게 힘이 되는 시간이었습니다.',
4, TRUE, 15, '2025-09-06 16:20:00'),

(17, 4, '유태양', '어르신들의 웃음이 최고의 보상',
'경로당에서 어르신들과 윷놀이도 하고 노래도 함께 불렀습니다. 제가 해드린 것보다 받은 게 더 많은 것 같아요. 어르신들의 인생 이야기를 듣고 많은 것을 배웠습니다. 정기적으로 참여할 예정입니다.',
5, TRUE, 31, '2025-09-14 19:00:00'),

-- 아동교육 봉사 후기
(6, 37, '최수빈', '아이들과 함께한 행복한 시간',
'지역아동센터에서 아이들에게 영어를 가르쳤습니다. 아이들이 "선생님 또 오세요!"라고 할 때 정말 뿌듯했어요. 처음에는 수업 진행이 어려웠지만 아이들의 밝은 에너지 덕분에 즐겁게 할 수 있었습니다.',
5, TRUE, 27, '2025-08-20 18:15:00'),

(10, 38, '송예진', '아이들의 꿈을 응원하며',
'초등학생들에게 수학을 가르치는 봉사를 했습니다. 어려운 문제를 이해하고 "아하!" 하는 아이들을 보면 저도 모르게 웃음이 나와요. 교육 봉사의 매력에 푹 빠졌습니다.',
5, TRUE, 22, '2025-08-27 17:30:00'),

(14, 39, '권민서', '미래의 주인공들과 함께',
'청소년 진로 멘토링 봉사에 참여했습니다. 제 경험을 나누고 아이들의 고민을 들어주는 시간이었어요. 아이들이 자신감을 갖게 되는 모습을 보니 저도 힘이 났습니다.',
4, TRUE, 19, '2025-09-10 16:45:00'),

-- 환경보호 봉사 후기
(5, 63, '정우진', '깨끗한 환경을 위한 첫걸음',
'한강 플로깅 봉사에 참여했습니다. 쓰레기를 줍다 보니 환경 문제의 심각성을 실감했어요. 함께 참여한 분들과 이야기도 나누고 운동도 되어서 일석이조였습니다. 환경을 위해 더 노력해야겠다는 다짐을 했습니다.',
5, TRUE, 35, '2025-08-24 14:00:00'),

(9, 64, '임도현', '자연과 함께하는 봉사',
'산림 정화 봉사활동을 했습니다. 등산도 하면서 쓰레기도 줍고 일석이조였어요. 팀원들과 협력하면서 뿌듯함도 두 배가 되었습니다. 다음 달에도 참여할 예정입니다!',
4, TRUE, 16, '2025-09-08 15:30:00'),

(15, 65, '배정훈', '해변 정화로 보람찬 주말',
'해운대 해변 정화 봉사에 참여했습니다. 생각보다 많은 쓰레기에 놀랐지만, 깨끗해진 해변을 보니 보람을 느꼈어요. 바다를 지키는 작은 행동이 모여 큰 변화를 만든다고 생각합니다.',
5, TRUE, 28, '2025-09-23 16:00:00'),

-- 의료봉사 후기
(8, 84, '윤하은', '따뜻한 손길이 되어',
'장애인 복지관에서 보조 봉사를 했습니다. 처음에는 어떻게 도와드려야 할지 몰라 당황했지만, 담당 선생님의 안내로 잘 적응할 수 있었어요. 작은 도움이라도 누군가에게 힘이 된다는 것을 배웠습니다.',
5, TRUE, 24, '2025-09-12 17:20:00'),

(12, 85, '오지아', '함께하는 기쁨을 느끼며',
'장애 아동들과 함께 미술 활동을 했습니다. 아이들의 순수한 미소가 오래도록 기억에 남아요. 봉사를 통해 제가 더 많은 것을 배워가는 것 같습니다.',
5, TRUE, 20, '2025-09-26 18:00:00'),

-- 재난구호 봉사 후기
(13, 100, '신준혁', '이웃을 위한 작은 실천',
'수해 지역 복구 봉사에 참여했습니다. 힘든 상황에서도 서로를 격려하는 이재민 분들을 보며 많은 것을 느꼈습니다. 앞으로도 어려운 이웃을 위한 봉사에 적극 참여하겠습니다.',
5, TRUE, 42, '2025-09-20 19:30:00'),

(20, 101, '양지은', '함께라서 할 수 있었던 봉사',
'태풍 피해 지역에서 정리 봉사를 했습니다. 여러 봉사자들과 함께해서 큰 힘이 되었어요. 피해 주민분들께서 감사 인사를 해주실 때 눈물이 났습니다.',
5, TRUE, 38, '2025-10-04 17:00:00'),

-- 문화행사 봉사 후기
(16, 113, '조유나', '문화로 하나되는 순간',
'지역 축제 안내 봉사를 했습니다. 다양한 연령대의 방문객들을 안내하면서 소통 능력도 키우고 즐거운 시간을 보냈어요. 축제의 활기찬 분위기 속에서 봉사하니 저도 신이 났습니다!',
4, TRUE, 14, '2025-09-27 20:00:00'),

(32, 114, '성다인', '예술과 함께하는 봉사',
'미술관 전시 도슨트 보조 봉사를 했습니다. 관람객들에게 작품을 설명하는 것이 처음에는 떨렸지만, 점점 재미있어졌어요. 예술의 가치를 나누는 뜻깊은 경험이었습니다.',
4, TRUE, 11, '2025-10-11 18:30:00'),

-- 추가 후기들
(23, 5, '백동혁', '정기 봉사의 보람',
'매달 참여하는 노인돌봄 봉사입니다. 이제는 어르신들이 제 이름을 기억해주시고 반겨주셔서 더 뿌듯합니다. 꾸준히 하는 봉사가 주는 특별한 기쁨이 있어요.',
5, TRUE, 33, '2025-09-22 17:15:00'),

(27, 6, '고민재', '봉사로 시작하는 하루',
'주말 아침 봉사활동으로 하루를 시작했습니다. 어르신들과 함께 아침 체조를 하고 산책을 했어요. 건강한 하루의 시작이 되어서 기분이 좋았습니다.',
5, TRUE, 17, '2025-10-03 12:00:00'),

(33, 7, '차승호', '첫 봉사활동 후기',
'친구 추천으로 처음 봉사활동에 참여했습니다. 처음이라 긴장했는데 다들 친절하게 안내해주셔서 잘 적응할 수 있었어요. 앞으로도 자주 참여할 예정입니다!',
4, TRUE, 9, '2025-10-10 16:30:00');

-- 후기 데이터 확인
SELECT
    vr.review_id,
    vr.reviewer_name,
    vr.title,
    vr.rating,
    vr.helpful_count,
    va.selected_category,
    vr.created_at
FROM volunteer_reviews vr
JOIN volunteer_applications va ON vr.application_id = va.application_id
ORDER BY vr.created_at DESC;


-- ========================================================================
-- 사용자 질문(FAQ) 테스트 데이터 삽입
-- 포트폴리오 테스트용 - 다양한 상태(답변완료/대기중)와 카테고리 포함
-- ========================================================================

USE springmvc;

-- 기존 테스트 데이터 삭제 (중복 방지)
DELETE FROM user_questions WHERE question_id < 100;

-- 사용자 질문 10개 삽입 (답변완료 5개, 답변대기 5개)
INSERT INTO user_questions (user_id, user_name, user_email, category, title, content, answer, answered_by, answered_at, status, views, created_at) VALUES

-- 1. 답변완료 - 복지혜택 (회원 질문)
('user01@welfare24.com', '김민수', 'user01@welfare24.com', '복지혜택',
'기초생활수급자 신청 자격이 궁금합니다',
'안녕하세요. 현재 1인 가구로 생활하고 있는 30대 직장인입니다. 최근 실직하여 경제적으로 어려운 상황인데, 기초생활수급자 신청 자격이 어떻게 되는지 궁금합니다. 소득과 재산 기준이 어떻게 되나요?',
'안녕하세요, 복지24입니다.\n\n기초생활수급자 자격 기준은 다음과 같습니다:\n\n1. 소득인정액 기준: 기준 중위소득의 30~50% 이하\n2. 부양의무자 기준: 부양의무자가 없거나 부양능력이 없는 경우\n3. 재산 기준: 대도시 6,900만원, 중소도시 4,200만원, 농어촌 3,500만원 이하\n\n자세한 상담은 주소지 관할 주민센터를 방문하시거나 복지로(www.bokjiro.go.kr)에서 모의계산을 해보실 수 있습니다.\n\n추가 문의사항이 있으시면 언제든 질문해 주세요.',
'admin@welfare24.com', '2025-11-20 10:30:00', 'answered', 45, '2025-11-18 09:15:00'),

-- 2. 답변완료 - 서비스이용 (비회원 질문)
(NULL, '이영희', 'yhlee@gmail.com', '서비스이용',
'복지 지도에서 주변 복지관을 찾을 수 없어요',
'복지 지도 기능을 이용하려고 하는데, 제 주변에 복지관이 표시되지 않습니다. 위치 권한도 허용했는데 왜 안 나오는 건가요? 서울 강남구에 살고 있습니다.',
'안녕하세요, 복지24입니다.\n\n복지 지도 이용에 불편을 드려 죄송합니다. 다음 사항을 확인해 주세요:\n\n1. 브라우저 캐시 삭제 후 페이지 새로고침\n2. 다른 브라우저(Chrome, Edge 등)로 시도\n3. 위치 서비스가 정상적으로 활성화되어 있는지 확인\n\n강남구 지역의 복지관은 정상적으로 등록되어 있으며, 위 방법으로도 해결되지 않으시면 고객센터(1544-1234)로 연락 주시면 원격으로 도움 드리겠습니다.\n\n감사합니다.',
'admin@welfare24.com', '2025-11-22 14:20:00', 'answered', 32, '2025-11-21 16:45:00'),

-- 3. 답변완료 - 계정관리 (회원 질문)
('user05@welfare24.com', '박지현', 'user05@welfare24.com', '계정관리',
'비밀번호 변경이 안됩니다',
'마이페이지에서 비밀번호를 변경하려고 하는데 "현재 비밀번호가 일치하지 않습니다"라는 오류가 계속 나옵니다. 분명히 맞게 입력했는데 왜 그런 건가요?',
'안녕하세요, 복지24입니다.\n\n비밀번호 변경 시 오류가 발생하는 경우 다음을 확인해 주세요:\n\n1. Caps Lock이 켜져 있지 않은지 확인\n2. 한/영 전환 상태 확인\n3. 복사-붙여넣기 시 앞뒤 공백이 포함되지 않았는지 확인\n\n위 방법으로도 해결되지 않으시면, 로그아웃 후 "비밀번호 찾기" 기능을 통해 임시 비밀번호를 발급받으신 후 새로운 비밀번호로 설정해 주세요.\n\n추가 도움이 필요하시면 말씀해 주세요.',
'admin@welfare24.com', '2025-11-25 11:00:00', 'answered', 28, '2025-11-24 08:30:00'),

-- 4. 답변완료 - 기타 (비회원 질문)
(NULL, '최준호', 'jhchoi1990@naver.com', '기타',
'봉사활동 시간 인증서 발급은 어떻게 하나요?',
'복지24를 통해 봉사활동을 했는데, 학교에 제출할 봉사시간 인증서가 필요합니다. 어디서 발급받을 수 있나요? 그리고 발급까지 얼마나 걸리나요?',
'안녕하세요, 복지24입니다.\n\n봉사활동 시간 인증서 발급 방법을 안내드립니다:\n\n1. 로그인 후 마이페이지 > 봉사활동 내역 메뉴 접속\n2. 해당 봉사활동 우측의 "인증서 발급" 버튼 클릭\n3. PDF 파일로 즉시 다운로드 가능\n\n※ 인증서는 봉사활동 완료 후 담당자 승인이 완료되면 발급 가능합니다.\n※ 승인은 보통 봉사 완료 후 1-3일 이내에 처리됩니다.\n\n비회원으로 활동하셨다면 회원가입 후 동일한 이메일로 로그인하시면 활동 내역이 연동됩니다.\n\n감사합니다.',
'admin@welfare24.com', '2025-11-28 09:45:00', 'answered', 56, '2025-11-27 14:20:00'),

-- 5. 답변완료 - 복지혜택 (회원 질문)
('user12@welfare24.com', '정수아', 'user12@welfare24.com', '복지혜택',
'한부모가족 지원금 신청 방법',
'이혼 후 아이 둘을 혼자 키우고 있는 한부모입니다. 한부모가족 지원금이 있다고 들었는데, 어떤 지원을 받을 수 있고 어떻게 신청하면 되나요?',
'안녕하세요, 복지24입니다.\n\n한부모가족 지원 내용을 안내드립니다:\n\n【지원 대상】\n- 만 18세 미만 자녀를 양육하는 한부모가족\n- 소득인정액이 기준 중위소득 60% 이하\n\n【주요 지원 내용】\n1. 아동양육비: 자녀 1인당 월 20만원\n2. 추가 아동양육비: 조손가족, 미혼 한부모 추가 지원\n3. 학용품비: 연 8.3만원\n4. 생활보조금: 한부모가족복지시설 입소자 월 5만원\n\n【신청 방법】\n- 주소지 관할 주민센터 방문 또는 복지로 온라인 신청\n- 필요서류: 신분증, 가족관계증명서, 소득증빙서류 등\n\n추가 문의사항이 있으시면 말씀해 주세요.',
'admin@welfare24.com', '2025-11-30 16:30:00', 'answered', 73, '2025-11-29 10:00:00'),

-- 6. 답변대기 - 서비스이용 (회원 질문)
('user08@welfare24.com', '강동원', 'user08@welfare24.com', '서비스이용',
'기부금 영수증 재발급 요청',
'작년에 기부한 내역에 대해 기부금 영수증을 재발급 받고 싶습니다. 마이페이지에서 확인했는데 다운로드 버튼이 비활성화되어 있네요. 연말정산에 필요해서 급합니다. 빠른 답변 부탁드립니다.',
NULL, NULL, NULL, 'pending', 12, '2025-12-01 11:20:00'),

-- 7. 답변대기 - 복지혜택 (비회원 질문)
(NULL, '윤서연', 'sy.yoon@hanmail.net', '복지혜택',
'장애인 등록 절차와 혜택이 궁금합니다',
'안녕하세요. 어머니께서 최근 뇌졸중으로 거동이 불편해지셨습니다. 장애인 등록을 하면 어떤 혜택을 받을 수 있는지, 등록 절차는 어떻게 되는지 알고 싶습니다. 서류는 뭐가 필요한가요?',
NULL, NULL, NULL, 'pending', 8, '2025-12-01 15:45:00'),

-- 8. 답변대기 - 계정관리 (회원 질문)
('user15@welfare24.com', '임재혁', 'user15@welfare24.com', '계정관리',
'회원 탈퇴 후 재가입 문의',
'이전에 탈퇴했던 계정으로 다시 가입하려고 하는데, "이미 사용 중인 이메일입니다"라고 나옵니다. 탈퇴한 지 2개월 정도 됐는데 언제 다시 가입할 수 있나요?',
NULL, NULL, NULL, 'pending', 5, '2025-12-02 09:30:00'),

-- 9. 답변대기 - 기타 (비회원 질문)
(NULL, '한소희', 'sohee.han@gmail.com', '기타',
'복지24 앱이 있나요?',
'웹사이트 말고 모바일 앱으로도 이용할 수 있나요? 스마트폰으로 복지 정보를 확인하고 싶은데, 앱스토어에서 검색해도 안 나와서요. 앱 출시 계획이 있는지 궁금합니다.',
NULL, NULL, NULL, 'pending', 15, '2025-12-02 14:10:00'),

-- 10. 답변대기 - 서비스이용 (회원 질문)
('user20@welfare24.com', '송민지', 'user20@welfare24.com', '서비스이용',
'복지 진단 결과가 너무 적게 나와요',
'복지 진단을 받았는데 추천되는 복지 서비스가 2개밖에 안 나왔어요. 제가 30대 1인 가구 직장인인데, 받을 수 있는 혜택이 이것밖에 없는 건가요? 다른 조건을 입력하면 더 많이 나올까요?',
NULL, NULL, NULL, 'pending', 22, '2025-12-03 08:00:00');

-- 삽입 완료 확인
SELECT
    question_id,
    user_name,
    category,
    title,
    status,
    DATE_FORMAT(created_at, '%Y-%m-%d %H:%i') as created_at,
    CASE WHEN answer IS NOT NULL THEN 'O' ELSE 'X' END as has_answer
FROM user_questions
ORDER BY created_at DESC;