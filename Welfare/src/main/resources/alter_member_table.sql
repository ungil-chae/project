-- ================================================
-- member 테이블에 phone, role 컬럼 추가
-- MySQL 8.3.0
-- ================================================

USE springmvc;

-- phone 컬럼 추가 (이미 있으면 무시)
ALTER TABLE member
ADD COLUMN IF NOT EXISTS phone VARCHAR(20) COMMENT '전화번호' AFTER email;

-- role 컬럼 추가 (이미 있으면 무시)
ALTER TABLE member
ADD COLUMN IF NOT EXISTS role VARCHAR(10) DEFAULT 'USER' COMMENT '사용자 권한: USER, ADMIN' AFTER phone;

-- 기존 데이터에 기본값 설정
UPDATE member SET role = 'USER' WHERE role IS NULL;

-- 관리자 계정 생성 (이미 있으면 무시)
INSERT IGNORE INTO member (id, pwd, name, email, phone, role, birth, sns)
VALUES ('admin', 'admin123', '관리자', 'admin@welfare24.com', '010-0000-0000', 'ADMIN', '1990-01-01', '');

-- 테스트 사용자 계정
INSERT IGNORE INTO member (id, pwd, name, email, phone, role, birth, sns)
VALUES ('testuser', 'test123', '테스트유저', 'test@test.com', '010-1234-5678', 'USER', '1995-05-15', '');

COMMIT;

-- 확인
SELECT * FROM member;
