-- member 테이블에 status 컬럼 추가
-- status 값: 'ACTIVE' (활성), 'SUSPENDED' (정지)

ALTER TABLE member
ADD COLUMN status VARCHAR(20) DEFAULT 'ACTIVE' NOT NULL
COMMENT '계정 상태 (ACTIVE: 활성, SUSPENDED: 정지)';

-- 기존 데이터 모두 ACTIVE로 설정
UPDATE member SET status = 'ACTIVE' WHERE status IS NULL;

-- 인덱스 추가 (선택사항, 성능 향상)
CREATE INDEX idx_member_status ON member(status);
