-- ========================================
-- 기존 알림 삭제 스크립트
-- ========================================
-- 목적: 알림 설정 기능 추가 전에 생성된 알림들을 삭제
-- 실행 시기: 알림 설정 기능이 처음 추가될 때 한 번만 실행
-- ========================================

USE springmvc;

-- 1. 현재 알림 개수 확인
SELECT
    '삭제 전 알림 현황' AS '구분',
    COUNT(*) AS '전체 알림 수',
    SUM(CASE WHEN is_read = false THEN 1 ELSE 0 END) AS '읽지 않은 알림 수',
    SUM(CASE WHEN deleted_at IS NULL THEN 1 ELSE 0 END) AS '활성 알림 수'
FROM notifications;

-- 2. 알림 타입별 개수 확인
SELECT
    notification_type AS '알림 타입',
    COUNT(*) AS '개수',
    SUM(CASE WHEN is_read = false THEN 1 ELSE 0 END) AS '읽지 않은 수'
FROM notifications
WHERE deleted_at IS NULL
GROUP BY notification_type
ORDER BY COUNT(*) DESC;

-- 3. 기존 알림 소프트 삭제 (선택사항)
-- 주의: 이 쿼리를 실행하면 모든 기존 알림이 삭제됩니다!
-- 필요한 경우에만 주석을 해제하고 실행하세요.

/*
UPDATE notifications
SET deleted_at = NOW()
WHERE deleted_at IS NULL;
*/

-- 4. 특정 회원의 알림만 삭제 (선택사항)
-- 특정 이메일의 알림만 삭제하려면 아래 쿼리를 사용하세요
-- 예: cwil123789@gmail.com 회원의 알림 삭제

/*
UPDATE notifications
SET deleted_at = NOW()
WHERE member_id = (SELECT member_id FROM member WHERE email = 'cwil123789@gmail.com')
AND deleted_at IS NULL;
*/

-- 5. 특정 타입의 알림만 삭제 (선택사항)
-- 캘린더 알림만 삭제
/*
UPDATE notifications
SET deleted_at = NOW()
WHERE notification_type IN ('CALENDAR_EVENT', 'event', 'calendar')
AND deleted_at IS NULL;
*/

-- 기부 알림만 삭제
/*
UPDATE notifications
SET deleted_at = NOW()
WHERE notification_type IN ('DONATION_REMINDER', 'DONATION', 'donation')
AND deleted_at IS NULL;
*/

-- 봉사 알림만 삭제
/*
UPDATE notifications
SET deleted_at = NOW()
WHERE notification_type IN ('VOLUNTEER', 'volunteer', 'VOLUNTEER_REMINDER')
AND deleted_at IS NULL;
*/

-- 6. 삭제 후 확인
SELECT
    '삭제 후 알림 현황' AS '구분',
    COUNT(*) AS '전체 알림 수',
    SUM(CASE WHEN deleted_at IS NULL THEN 1 ELSE 0 END) AS '활성 알림 수',
    SUM(CASE WHEN deleted_at IS NOT NULL THEN 1 ELSE 0 END) AS '삭제된 알림 수'
FROM notifications;
