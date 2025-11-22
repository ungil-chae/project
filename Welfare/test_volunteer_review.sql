-- 봉사 후기 테스트 데이터 삽입 스크립트
-- MySQL Workbench나 명령줄에서 실행하세요

USE springmvc;

-- 1. member 테이블에 테스트 사용자가 있는지 확인
SELECT * FROM member LIMIT 5;

-- 2. 봉사 신청 내역이 있는지 확인
SELECT * FROM volunteer_applications LIMIT 5;

-- 3. 기존 후기 확인
SELECT * FROM volunteer_reviews ORDER BY created_at DESC LIMIT 5;

-- 4. 테스트용 봉사 신청 데이터 삽입 (member 테이블에 'admin' 사용자가 있다고 가정)
INSERT INTO volunteer_applications
(user_id, applicant_name, applicant_phone, applicant_email, applicant_address,
volunteer_experience, selected_category, volunteer_date, volunteer_end_date, volunteer_time, status, created_at)
VALUES
('admin', '홍길동', '010-1234-5678', 'admin@test.com', '서울시 강남구',
'1년미만', '노인 복지', '2025-01-15', '2025-01-15', '오전 9시-12시', 'completed', NOW());

-- 방금 삽입한 application_id 확인
SET @last_app_id = LAST_INSERT_ID();
SELECT @last_app_id AS application_id;

-- 5. 테스트용 봉사 후기 데이터 삽입
INSERT INTO volunteer_reviews
(user_id, application_id, title, content, rating, created_at)
VALUES
('admin', @last_app_id, '따뜻한 봉사 경험', '어르신들을 도와드리면서 보람을 느꼈습니다. 다음에도 꼭 참여하고 싶습니다.', 5, NOW());

-- 6. 후기가 정상적으로 삽입되었는지 확인 (member와 JOIN)
SELECT
    vr.review_id,
    vr.user_id,
    m.name AS user_name,
    vr.application_id,
    va.selected_category AS activity_name,
    vr.title,
    vr.content,
    vr.rating,
    vr.created_at
FROM volunteer_reviews vr
INNER JOIN member m ON vr.user_id = m.id
LEFT JOIN volunteer_applications va ON vr.application_id = va.application_id
ORDER BY vr.created_at DESC
LIMIT 5;

-- 7. API가 반환할 데이터와 동일한 형식으로 확인
SELECT
    vr.review_id,
    vr.user_id,
    m.name AS user_name,
    vr.application_id,
    va.selected_category AS activity_name,
    vr.title,
    vr.content,
    vr.rating,
    vr.created_at
FROM volunteer_reviews vr
INNER JOIN member m ON vr.user_id = m.id
LEFT JOIN volunteer_applications va ON vr.application_id = va.application_id
ORDER BY vr.created_at DESC;
