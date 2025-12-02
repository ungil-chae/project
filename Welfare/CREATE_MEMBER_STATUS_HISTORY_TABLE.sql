-- 회원 상태 변경 이력 테이블 생성
-- 이 테이블은 관리자가 회원 상태를 변경할 때 이력을 기록합니다.

USE springmvc;

-- 기존 테이블이 있다면 삭제
DROP TABLE IF EXISTS member_status_history;

-- 회원 상태 변경 이력 테이블 생성
CREATE TABLE member_status_history (
    -- 기본키
    history_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '이력 ID',

    -- 외래키
    member_id BIGINT UNSIGNED NOT NULL COMMENT '회원 고유번호',
    admin_id BIGINT UNSIGNED NULL COMMENT '처리한 관리자 ID',

    -- 상태 변경 정보
    old_status ENUM('ACTIVE', 'SUSPENDED', 'DORMANT') NOT NULL COMMENT '변경 전 상태',
    new_status ENUM('ACTIVE', 'SUSPENDED', 'DORMANT') NOT NULL COMMENT '변경 후 상태',
    reason VARCHAR(500) NULL COMMENT '변경 사유',

    -- 시스템 정보
    ip_address VARCHAR(45) NULL COMMENT '변경 시 IP 주소',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '변경 일시',

    -- 인덱스
    INDEX idx_member_id (member_id),
    INDEX idx_admin_id (admin_id),
    INDEX idx_created_at (created_at),

    -- 외래키 제약조건
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES member(member_id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='회원 상태 변경 이력 테이블';

-- 초기 데이터 확인
SELECT 'member_status_history 테이블이 성공적으로 생성되었습니다.' AS message;
SELECT COUNT(*) AS total_count FROM member_status_history;
