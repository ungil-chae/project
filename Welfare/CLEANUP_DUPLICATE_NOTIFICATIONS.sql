-- ==========================================
-- 중복 알림 정리 SQL
-- ==========================================
-- 이 스크립트는 이전에 중복 체크 로직이 없을 때 생성된
-- 중복 알림들을 정리합니다.
-- ==========================================

-- 1. 현재 중복 알림 현황 확인
SELECT
    notification_type,
    title,
    related_id,
    member_id,
    COUNT(*) as duplicate_count,
    GROUP_CONCAT(notification_id ORDER BY created_at) as notification_ids
FROM notifications
GROUP BY notification_type, title, related_id, member_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- 2. 중복 알림 삭제 (각 그룹에서 가장 최신 것만 남기고 나머지 삭제)
-- 주의: 이 쿼리는 실제 데이터를 삭제합니다. 먼저 위의 SELECT로 확인 후 실행하세요.

DELETE n1 FROM notifications n1
INNER JOIN (
    SELECT
        notification_type,
        title,
        related_id,
        member_id,
        MAX(notification_id) as keep_id
    FROM notifications
    GROUP BY notification_type, title, related_id, member_id
    HAVING COUNT(*) > 1
) n2 ON n1.notification_type = n2.notification_type
    AND n1.title = n2.title
    AND n1.related_id = n2.related_id
    AND n1.member_id = n2.member_id
    AND n1.notification_id < n2.keep_id;

-- 3. 삭제 후 결과 확인
SELECT
    notification_type,
    COUNT(*) as total_notifications
FROM notifications
GROUP BY notification_type
ORDER BY total_notifications DESC;

-- 4. (선택사항) 특정 날짜 이전의 오래된 알림 전체 삭제
-- 예: 7일 이전 알림 삭제
-- DELETE FROM notifications
-- WHERE created_at < DATE_SUB(NOW(), INTERVAL 7 DAY);

-- 5. (선택사항) 읽은 알림 중 30일 이상 지난 것 삭제
-- DELETE FROM notifications
-- WHERE is_read = TRUE
-- AND read_at IS NOT NULL
-- AND read_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
