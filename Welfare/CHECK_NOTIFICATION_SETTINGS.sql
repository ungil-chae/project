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
