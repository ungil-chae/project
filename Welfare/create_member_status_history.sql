-- 회원 상태 변경 이력 테이블 생성

CREATE TABLE IF NOT EXISTS member_status_history (
    -- 기본키
    history_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '이력 ID',

    -- 외래키
    member_id BIGINT UNSIGNED NOT NULL COMMENT '회원 고유번호',
    admin_id BIGINT UNSIGNED NULL COMMENT '처리한 관리자 ID (시스템 자동 처리 시 NULL)',

    -- 변경 정보
    old_status ENUM('ACTIVE', 'SUSPENDED', 'DORMANT') NOT NULL COMMENT '변경 전 상태',
    new_status ENUM('ACTIVE', 'SUSPENDED', 'DORMANT') NOT NULL COMMENT '변경 후 상태',
    reason VARCHAR(500) COMMENT '변경 사유',

    -- 추적 정보
    ip_address VARCHAR(45) COMMENT '요청 IP 주소',

    -- 시스템 정보
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '변경 일시',

    INDEX idx_member_id (member_id),
    INDEX idx_admin_id (admin_id),
    INDEX idx_created_at (created_at DESC),
    INDEX idx_new_status (new_status),
    INDEX idx_composite_member_date (member_id, created_at DESC),

    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES member(member_id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='회원 상태 변경 이력 테이블';
