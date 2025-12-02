-- =========================================================
-- notification_type ENUM 수정 SQL
-- FAQ_ANSWER, VOLUNTEER_APPROVED 타입 추가
-- =========================================================

USE springmvc;

-- notifications 테이블의 notification_type ENUM에 새 값 추가
ALTER TABLE notifications
MODIFY COLUMN notification_type
ENUM('DONATION_REMINDER', 'VOLUNTEER_REMINDER', 'CALENDAR_EVENT', 'GENERAL', 'FAQ_ANSWER', 'VOLUNTEER_APPROVED')
NOT NULL
COMMENT '알림 유형';

-- 수정 결과 확인
SHOW COLUMNS FROM notifications WHERE Field = 'notification_type';

-- 확인용: 알림 테이블 데이터 조회
SELECT notification_id, member_id, notification_type, title, message, created_at
FROM notifications
ORDER BY created_at DESC
LIMIT 10;
