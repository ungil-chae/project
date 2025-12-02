-- 봉사 신청 테이블에 시설 매칭 및 승인 관련 컬럼 추가
-- 관리자가 봉사 활동을 승인하고 시설을 매칭할 수 있도록 함

USE springmvc;

-- 관리자 승인 정보
ALTER TABLE volunteer_applications
ADD COLUMN approved_by BIGINT UNSIGNED NULL COMMENT '승인한 관리자 ID' AFTER reject_reason,
ADD COLUMN approved_at TIMESTAMP NULL COMMENT '승인 일시' AFTER approved_by;

-- 시설 매칭 정보
ALTER TABLE volunteer_applications
ADD COLUMN assigned_facility_name VARCHAR(200) NULL COMMENT '배정된 복지시설명' AFTER approved_at,
ADD COLUMN assigned_facility_address VARCHAR(500) NULL COMMENT '배정된 시설 주소' AFTER assigned_facility_name,
ADD COLUMN assigned_facility_lat DECIMAL(10, 8) NULL COMMENT '시설 위도' AFTER assigned_facility_address,
ADD COLUMN assigned_facility_lng DECIMAL(11, 8) NULL COMMENT '시설 경도' AFTER assigned_facility_lat,
ADD COLUMN admin_note TEXT NULL COMMENT '관리자 메모' AFTER assigned_facility_lng;

-- 인덱스 추가
ALTER TABLE volunteer_applications
ADD INDEX idx_approved_by (approved_by),
ADD INDEX idx_approved_at (approved_at DESC);

-- 외래키 추가
ALTER TABLE volunteer_applications
ADD CONSTRAINT fk_volunteer_applications_approved_by
FOREIGN KEY (approved_by) REFERENCES member(member_id) ON DELETE SET NULL;

-- 확인
SELECT 'volunteer_applications 테이블이 성공적으로 수정되었습니다.' AS message;
DESCRIBE volunteer_applications;
