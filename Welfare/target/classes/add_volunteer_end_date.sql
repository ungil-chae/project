-- volunteer_applications 테이블에 volunteer_end_date 컬럼 추가
-- 이미 존재하면 오류가 발생하지만 무시하고 진행

-- 먼저 컬럼이 존재하는지 확인
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'springmvc'
  AND TABLE_NAME = 'volunteer_applications'
  AND COLUMN_NAME = 'volunteer_end_date';

-- 컬럼이 없으면 아래 명령어를 실행하세요:
ALTER TABLE volunteer_applications
ADD COLUMN volunteer_end_date DATE NULL COMMENT '봉사 종료 날짜' AFTER volunteer_date;

-- 기존 데이터에 대해 종료일을 시작일과 동일하게 설정
UPDATE volunteer_applications
SET volunteer_end_date = volunteer_date
WHERE volunteer_end_date IS NULL;
