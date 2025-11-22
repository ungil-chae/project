-- 빠른 데이터베이스 수정 (기존 데이터 유지)
-- MySQL Workbench에서 실행하세요

USE springmvc;

-- 1. kindness_temperature 컬럼이 없으면 추가
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'springmvc'
    AND TABLE_NAME = 'member'
    AND COLUMN_NAME = 'kindness_temperature');

SET @query = IF(@col_exists = 0,
    'ALTER TABLE member ADD COLUMN kindness_temperature DECIMAL(5, 2) DEFAULT 36.50 COMMENT "선행 온도" AFTER security_answer',
    'SELECT "kindness_temperature 컬럼이 이미 존재합니다" AS info');

PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 1-1. last_login_fail_at 컬럼이 없으면 추가
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'springmvc'
    AND TABLE_NAME = 'member'
    AND COLUMN_NAME = 'last_login_fail_at');

SET @query = IF(@col_exists = 0,
    'ALTER TABLE member ADD COLUMN last_login_fail_at TIMESTAMP NULL COMMENT "마지막 로그인 실패 일시" AFTER login_fail_count',
    'SELECT "last_login_fail_at 컬럼이 이미 존재합니다" AS info');

PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 1-2. account_locked_until 컬럼이 없으면 추가
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'springmvc'
    AND TABLE_NAME = 'member'
    AND COLUMN_NAME = 'account_locked_until');

SET @query = IF(@col_exists = 0,
    'ALTER TABLE member ADD COLUMN account_locked_until TIMESTAMP NULL COMMENT "계정 잠금 해제 시간" AFTER last_login_fail_at',
    'SELECT "account_locked_until 컬럼이 이미 존재합니다" AS info');

PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. 모든 기존 회원의 kindness_temperature 기본값 설정
UPDATE member
SET kindness_temperature = 36.50
WHERE kindness_temperature IS NULL;

-- 3. 보안 질문이 없는 모든 기존 회원에게 기본 보안 질문 추가
UPDATE member
SET security_question = '어머니의 성함은?',
    security_answer = '변경필요'
WHERE security_question IS NULL OR security_question = '';

-- 4. 결과 확인
SELECT
    COUNT(*) AS total_members,
    SUM(CASE WHEN security_question IS NOT NULL THEN 1 ELSE 0 END) AS with_security_question,
    SUM(CASE WHEN kindness_temperature IS NOT NULL THEN 1 ELSE 0 END) AS with_temperature
FROM member;

-- 5. 새 컬럼 확인
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'springmvc'
AND TABLE_NAME = 'member'
AND COLUMN_NAME IN ('login_fail_count', 'last_login_fail_at', 'account_locked_until', 'last_login_at', 'kindness_temperature')
ORDER BY ORDINAL_POSITION;

-- 6. 샘플 계정 확인
SELECT email, name, security_question, security_answer, kindness_temperature, login_fail_count
FROM member
LIMIT 5;

SELECT '✅ 데이터베이스 수정 완료!' AS result;
