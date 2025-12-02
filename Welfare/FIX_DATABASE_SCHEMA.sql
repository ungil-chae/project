-- ========================================
-- 데이터베이스 스키마 수정 SQL
-- 실행 방법: MySQL에서 이 파일을 실행하세요
-- ========================================

USE springmvc;

-- 1. notifications 테이블에 deleted_at 컬럼 추가 (소프트 삭제용)
ALTER TABLE notifications
ADD COLUMN deleted_at TIMESTAMP NULL COMMENT '삭제일 (소프트 삭제)'
AFTER created_at;

-- 2. deleted_at 컬럼에 인덱스 추가 (쿼리 성능 향상)
ALTER TABLE notifications
ADD INDEX idx_deleted_at (deleted_at);

-- 3. 스키마 변경 확인
DESCRIBE notifications;

-- 4. 기존 알림 데이터 확인 (중복 체크용)
SELECT
    n.notification_id,
    n.member_id,
    m.email,
    n.notification_type,
    n.title,
    n.event_date,
    n.is_read,
    n.deleted_at,
    n.created_at
FROM notifications n
LEFT JOIN member m ON n.member_id = m.member_id
ORDER BY n.created_at DESC
LIMIT 20;

-- 5. (선택사항) 기존 알림을 모두 삭제하고 새로 시작하려면 아래 주석 해제
-- 주의: 이 명령은 모든 알림 데이터를 삭제합니다!
-- TRUNCATE TABLE notifications;

SELECT '데이터베이스 스키마 업데이트 완료!' AS status;
