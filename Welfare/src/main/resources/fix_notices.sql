-- ================================================
-- notices 테이블 수정 스크립트 (Safe Mode 대응)
-- ================================================

-- Safe update mode 해제
SET SQL_SAFE_UPDATES = 0;

USE springmvc;

-- 1. 기존 외래키 삭제 (있으면)
ALTER TABLE notices DROP FOREIGN KEY IF EXISTS notices_ibfk_1;
ALTER TABLE notices DROP FOREIGN KEY IF EXISTS fk_notices_member;

-- 2. notices 테이블 임시로 이름 변경
RENAME TABLE notices TO notices_old;

-- 3. notices 테이블 새로 생성 (VARCHAR admin_id)
CREATE TABLE notices (
    notice_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    admin_id VARCHAR(50) NOT NULL COMMENT '작성한 관리자 ID',
    title VARCHAR(200) NOT NULL COMMENT '제목',
    content TEXT NOT NULL COMMENT '내용',
    views INT DEFAULT 0 COMMENT '조회수',
    is_pinned BOOLEAN DEFAULT FALSE COMMENT '상단 고정 여부',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_admin_id (admin_id),
    INDEX idx_created_at (created_at),
    INDEX idx_is_pinned (is_pinned)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='공지사항 테이블';

-- 4. 샘플 데이터 삽입
INSERT INTO notices (admin_id, title, content, is_pinned) VALUES
('admin', '복지24 서비스 오픈 안내', '복지24가 새롭게 오픈했습니다. 많은 이용 부탁드립니다.', TRUE),
('admin', '2025년 복지 혜택 업데이트', '2025년 새로운 복지 혜택 정보가 업데이트 되었습니다.', FALSE);

-- 5. 외래키 연결
ALTER TABLE notices
ADD CONSTRAINT fk_notices_member
FOREIGN KEY (admin_id) REFERENCES member(id) ON DELETE CASCADE;

-- 6. 기존 테이블 삭제
DROP TABLE IF EXISTS notices_old;

-- Safe update mode 다시 활성화
SET SQL_SAFE_UPDATES = 1;

SELECT 'notices 테이블 수정 완료!' AS status;
