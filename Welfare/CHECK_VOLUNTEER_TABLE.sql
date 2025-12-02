-- volunteer_applications 테이블의 컬럼 확인
USE springmvc;

-- 테이블 구조 확인
DESCRIBE volunteer_applications;

-- 특정 컬럼 존재 여부 확인
SELECT COLUMN_NAME, DATA_TYPE, COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'springmvc'
  AND TABLE_NAME = 'volunteer_applications'
  AND COLUMN_NAME IN ('approved_by', 'approved_at', 'assigned_facility_name', 'assigned_facility_address', 'assigned_facility_lat', 'assigned_facility_lng', 'admin_note')
ORDER BY ORDINAL_POSITION;
