-- ========================================================================
-- 알림 기능 디버깅 스크립트
-- ========================================================================
-- 이 스크립트는 알림 기능이 왜 작동하지 않는지 확인하는 용도입니다.
-- ========================================================================

USE springmvc;

-- ========================================================================
-- 1. 로그인한 사용자의 member_id와 email 확인
-- ========================================================================
-- 본인의 이메일을 입력하여 member_id 확인
SELECT '=== 사용자 정보 확인 ===' AS '단계';
SELECT
    member_id,
    email,
    name,
    status,
    deleted_at
FROM member
WHERE email = 'your-email@example.com'  -- 여기에 본인 이메일 입력
  AND deleted_at IS NULL;

-- member_id를 변수에 저장 (위 결과에서 확인한 값으로 변경)
SET @my_member_id = 1;  -- 본인의 member_id로 변경!
SET @my_email = 'your-email@example.com';  -- 본인의 이메일로 변경!

-- ========================================================================
-- 2. 오늘/내일 날짜 확인
-- ========================================================================
SELECT '=== 날짜 확인 ===' AS '단계';
SELECT
    CURDATE() AS '오늘',
    DATE_ADD(CURDATE(), INTERVAL 1 DAY) AS '내일';

SET @today = CURDATE();
SET @tomorrow = DATE_ADD(CURDATE(), INTERVAL 1 DAY);

-- ========================================================================
-- 3. 정기 기부 데이터 확인
-- ========================================================================
SELECT '=== 정기 기부 데이터 확인 ===' AS '단계';
SELECT
    donation_id,
    member_id,
    amount,
    donation_type,
    regular_start_date,
    payment_status,
    created_at,
    CASE
        WHEN regular_start_date = @tomorrow THEN '✅ 내일 (알림 대상)'
        WHEN regular_start_date = @today THEN '✅ 오늘 (알림 대상)'
        WHEN regular_start_date IS NULL THEN '❌ 날짜 없음'
        ELSE '❌ 다른 날짜'
    END AS '알림 여부'
FROM donations
WHERE member_id = @my_member_id
  AND donation_type = 'REGULAR'
ORDER BY regular_start_date DESC
LIMIT 10;

-- 알림 대상 기부 카운트
SELECT
    COUNT(*) AS '알림 대상 정기 기부 개수'
FROM donations
WHERE member_id = @my_member_id
  AND donation_type = 'REGULAR'
  AND regular_start_date IN (@today, @tomorrow)
  AND payment_status = 'COMPLETED';

-- ========================================================================
-- 4. 봉사 활동 신청 데이터 확인
-- ========================================================================
SELECT '=== 봉사 활동 신청 데이터 확인 ===' AS '단계';
SELECT
    application_id,
    member_id,
    activity_id,
    selected_category,
    volunteer_date,
    status,
    created_at,
    CASE
        WHEN volunteer_date = @tomorrow THEN '✅ 내일 (알림 대상)'
        WHEN volunteer_date = @today THEN '✅ 오늘 (알림 대상)'
        WHEN volunteer_date IS NULL THEN '❌ 날짜 없음'
        ELSE '❌ 다른 날짜'
    END AS '알림 여부'
FROM volunteer_applications
WHERE member_id = @my_member_id
ORDER BY volunteer_date DESC
LIMIT 10;

-- 알림 대상 봉사 카운트
SELECT
    COUNT(*) AS '알림 대상 봉사 활동 개수'
FROM volunteer_applications
WHERE member_id = @my_member_id
  AND volunteer_date IN (@today, @tomorrow)
  AND status IN ('APPLIED', 'CONFIRMED');

-- ========================================================================
-- 5. 생성된 알림 확인
-- ========================================================================
SELECT '=== 생성된 알림 확인 ===' AS '단계';
SELECT
    notification_id,
    notification_type,
    title,
    message,
    related_id,
    is_read,
    created_at,
    DATEDIFF(CURDATE(), DATE(created_at)) AS '며칠 전 생성'
FROM notifications
WHERE member_id = @my_member_id
ORDER BY created_at DESC
LIMIT 20;

-- 오늘 생성된 알림만 확인
SELECT
    COUNT(*) AS '오늘 생성된 알림 개수',
    SUM(CASE WHEN notification_type = 'DONATION_REMINDER' THEN 1 ELSE 0 END) AS '기부 알림',
    SUM(CASE WHEN notification_type = 'VOLUNTEER_REMINDER' THEN 1 ELSE 0 END) AS '봉사 알림'
FROM notifications
WHERE member_id = @my_member_id
  AND DATE(created_at) = CURDATE();

-- ========================================================================
-- 6. 알림 테이블 존재 여부 확인
-- ========================================================================
SELECT '=== 알림 테이블 확인 ===' AS '단계';
SHOW TABLES LIKE 'notifications';

-- 알림 테이블 구조 확인
DESCRIBE notifications;

-- ========================================================================
-- 7. 중복 알림 체크 (오늘 이미 생성된 알림)
-- ========================================================================
SELECT '=== 중복 알림 체크 ===' AS '단계';
SELECT
    n.notification_id,
    n.notification_type,
    n.related_id,
    n.title,
    DATE(n.created_at) AS '생성일',
    CASE
        WHEN d.donation_id IS NOT NULL THEN CONCAT('기부 ID: ', d.donation_id, ' (', d.regular_start_date, ')')
        WHEN v.application_id IS NOT NULL THEN CONCAT('봉사 ID: ', v.application_id, ' (', v.volunteer_date, ')')
        ELSE '관련 데이터 없음'
    END AS '관련 정보'
FROM notifications n
LEFT JOIN donations d ON n.related_id = d.donation_id AND n.notification_type = 'DONATION_REMINDER'
LEFT JOIN volunteer_applications v ON n.related_id = v.application_id AND n.notification_type = 'VOLUNTEER_REMINDER'
WHERE n.member_id = @my_member_id
  AND DATE(n.created_at) = CURDATE()
ORDER BY n.created_at DESC;

-- ========================================================================
-- 8. 스케줄러 실행 로그 확인 (없을 수 있음)
-- ========================================================================
-- Spring 로그를 확인해야 합니다. 콘솔 또는 로그 파일에서 다음을 찾으세요:
-- "일일 알림 자동 생성 스케줄러 시작"
-- "회원 <email> 알림 생성 중..."
-- "일일 알림 생성 완료"

-- ========================================================================
-- 9. 문제 진단
-- ========================================================================
SELECT '=== 문제 진단 ===' AS '단계';

-- 1) 알림 대상 데이터가 있는가?
SELECT
    CASE
        WHEN EXISTS (
            SELECT 1 FROM donations
            WHERE member_id = @my_member_id
              AND donation_type = 'REGULAR'
              AND regular_start_date IN (@today, @tomorrow)
              AND payment_status = 'COMPLETED'
        ) OR EXISTS (
            SELECT 1 FROM volunteer_applications
            WHERE member_id = @my_member_id
              AND volunteer_date IN (@today, @tomorrow)
              AND status IN ('APPLIED', 'CONFIRMED')
        )
        THEN '✅ 알림 대상 데이터 있음'
        ELSE '❌ 알림 대상 데이터 없음'
    END AS '데이터 확인';

-- 2) 오늘 알림이 생성되었는가?
SELECT
    CASE
        WHEN EXISTS (
            SELECT 1 FROM notifications
            WHERE member_id = @my_member_id
              AND DATE(created_at) = CURDATE()
        )
        THEN '✅ 오늘 알림 생성됨'
        ELSE '❌ 오늘 알림 생성 안 됨'
    END AS '알림 생성 확인';

-- 3) 스케줄러 실행 시간 확인
SELECT
    '⚠️ 스케줄러는 매일 오전 9시에 실행됩니다.' AS '스케줄러 정보',
    CONCAT('현재 시각: ', NOW()) AS '현재 시각',
    CASE
        WHEN HOUR(NOW()) < 9 THEN '⏰ 아직 오전 9시 이전 - 스케줄러 미실행'
        WHEN HOUR(NOW()) >= 9 THEN '✅ 오전 9시 이후 - 스케줄러 실행되었어야 함'
    END AS '스케줄러 실행 여부';

-- ========================================================================
-- 10. 테스트: 수동으로 알림 생성해보기
-- ========================================================================
SELECT '=== 수동 알림 생성 테스트 ===' AS '단계';

-- 테스트용 알림 수동 생성 (스케줄러가 작동하지 않을 때)
-- 주의: 이미 알림이 있으면 실행하지 마세요!

/*
INSERT INTO notifications (
    member_id,
    notification_type,
    title,
    message,
    related_id,
    action_url,
    is_read,
    created_at
)
SELECT
    @my_member_id,
    'DONATION_REMINDER',
    '내일은 정기 기부 예정일입니다',
    CONCAT('내일 ', amount, '원의 정기 기부가 예정되어 있습니다. 감사합니다!'),
    donation_id,
    '/bdproject/project_mypage.jsp',
    FALSE,
    NOW()
FROM donations
WHERE member_id = @my_member_id
  AND donation_type = 'REGULAR'
  AND regular_start_date = @tomorrow
  AND payment_status = 'COMPLETED'
LIMIT 1;

-- 생성 확인
SELECT * FROM notifications WHERE member_id = @my_member_id ORDER BY created_at DESC LIMIT 1;
*/

-- ========================================================================
-- 결과 해석
-- ========================================================================
/*
문제 1: "알림 대상 데이터 없음"이 나오면
- 봉사 신청이나 정기 기부를 내일/오늘 날짜로 생성해야 합니다.
- TEST_NOTIFICATION_SETUP.sql 스크립트를 실행하세요.

문제 2: "알림 대상 데이터 있음"인데 "오늘 알림 생성 안 됨"이면
- 스케줄러가 실행되지 않은 것입니다.
- 서버 로그를 확인하세요.
- root-context.xml에 <task:annotation-driven />이 있는지 확인하세요.
- 현재 시각이 오전 9시 이전이면 기다려야 합니다.

문제 3: 알림이 생성되었는데 화면에 표시되지 않으면
- 브라우저를 새로고침하세요.
- 로그인한 이메일이 @my_email과 일치하는지 확인하세요.
- 알림 표시 JavaScript가 작동하는지 확인하세요.
*/
