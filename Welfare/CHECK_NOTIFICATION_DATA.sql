-- ================================================
-- 알림 생성을 위한 데이터 확인 SQL
-- ================================================

USE springmvc;

-- 1. 로그인 사용자 확인
SELECT '=== 회원 정보 ===' AS section;
SELECT member_id, email, name, created_at
FROM member
WHERE deleted_at IS NULL
LIMIT 5;

-- 2. 정기 기부 확인 (오늘 또는 내일이 시작일인 기부)
SELECT '=== 정기 기부 (오늘/내일 시작일) ===' AS section;
SELECT
    d.donation_id,
    d.member_id,
    m.email,
    m.name AS donor_name,
    d.amount,
    d.donation_type,
    d.regular_start_date,
    d.payment_status,
    d.created_at,
    DATEDIFF(d.regular_start_date, CURDATE()) AS days_until_start
FROM donations d
LEFT JOIN member m ON d.member_id = m.member_id
WHERE d.donation_type = 'REGULAR'
  AND d.payment_status = 'COMPLETED'
  AND d.regular_start_date IN (CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 DAY))
ORDER BY d.regular_start_date;

-- 3. 모든 정기 기부 확인 (디버깅용)
SELECT '=== 모든 정기 기부 ===' AS section;
SELECT
    d.donation_id,
    d.member_id,
    m.email,
    d.amount,
    d.donation_type,
    d.regular_start_date,
    d.payment_status,
    DATEDIFF(d.regular_start_date, CURDATE()) AS days_until_start
FROM donations d
LEFT JOIN member m ON d.member_id = m.member_id
WHERE d.donation_type = 'REGULAR'
ORDER BY d.regular_start_date DESC
LIMIT 10;

-- 4. 봉사 활동 신청 확인 (오늘 또는 내일 활동일)
SELECT '=== 봉사 활동 (오늘/내일 활동일) ===' AS section;
SELECT
    va.application_id,
    va.member_id,
    m.email,
    m.name AS applicant_name,
    va.volunteer_date,
    va.selected_category,
    va.status,
    DATEDIFF(va.volunteer_date, CURDATE()) AS days_until_activity
FROM volunteer_applications va
LEFT JOIN member m ON va.member_id = m.member_id
WHERE va.status IN ('APPLIED', 'CONFIRMED')
  AND va.volunteer_date IN (CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 DAY))
ORDER BY va.volunteer_date;

-- 5. 모든 봉사 활동 신청 확인 (디버깅용)
SELECT '=== 모든 봉사 활동 신청 ===' AS section;
SELECT
    va.application_id,
    va.member_id,
    m.email,
    va.volunteer_date,
    va.selected_category,
    va.status,
    DATEDIFF(va.volunteer_date, CURDATE()) AS days_until_activity
FROM volunteer_applications va
LEFT JOIN member m ON va.member_id = m.member_id
WHERE va.status IN ('APPLIED', 'CONFIRMED')
ORDER BY va.volunteer_date DESC
LIMIT 10;

-- 6. 생성된 알림 확인
SELECT '=== 최근 생성된 알림 ===' AS section;
SELECT
    n.notification_id,
    n.member_id,
    m.email,
    n.notification_type,
    n.title,
    n.message,
    n.event_date,
    n.is_read,
    n.is_sent,
    n.created_at
FROM notifications n
LEFT JOIN member m ON n.member_id = m.member_id
ORDER BY n.created_at DESC
LIMIT 20;
