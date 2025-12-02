-- ========================================================================
-- 주소 저장 문제 확인 스크립트
-- ========================================================================

USE springmvc;

-- 1. 본인의 이메일로 회원 정보 확인
SELECT
    member_id,
    email,
    name,
    postcode,
    address,
    detail_address,
    updated_at
FROM member
WHERE email = 'your-email@example.com'  -- 본인 이메일로 변경
  AND deleted_at IS NULL;

-- 2. 최근 업데이트된 회원 목록 (updated_at 기준)
SELECT
    member_id,
    email,
    name,
    postcode,
    address,
    detail_address,
    updated_at,
    TIMESTAMPDIFF(MINUTE, updated_at, NOW()) AS '업데이트된_지_몇_분'
FROM member
WHERE deleted_at IS NULL
ORDER BY updated_at DESC
LIMIT 10;

-- 3. 주소가 있는 회원 수
SELECT
    COUNT(*) AS '주소가_있는_회원_수',
    COUNT(CASE WHEN postcode IS NOT NULL THEN 1 END) AS '우편번호_있음',
    COUNT(CASE WHEN address IS NOT NULL THEN 1 END) AS '기본주소_있음',
    COUNT(CASE WHEN detail_address IS NOT NULL THEN 1 END) AS '상세주소_있음'
FROM member
WHERE deleted_at IS NULL;

-- 4. member 테이블 구조 확인
DESCRIBE member;

-- 5. 수동으로 주소 업데이트 테스트 (테스트용)
/*
UPDATE member
SET postcode = '12345',
    address = '서울시 강남구 테헤란로 123',
    detail_address = '4층',
    updated_at = NOW()
WHERE email = 'your-email@example.com';

-- 업데이트 확인
SELECT postcode, address, detail_address, updated_at
FROM member
WHERE email = 'your-email@example.com';
*/
