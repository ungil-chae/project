-- ================================================
-- 샘플 봉사 후기 10개 생성 스크립트
-- ================================================

USE springmvc;

-- Safe update mode 해제
SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;

-- ================================================
-- 1. 테스트 사용자 추가 (없으면)
-- ================================================
INSERT IGNORE INTO member (id, pwd, name, email, phone, role, birth) VALUES
('admin', 'admin123', '관리자', 'admin@welfare24.com', '010-0000-0000', 'ADMIN', '1985-03-15'),
('user1', 'test123', '김민수', 'minsu@test.com', '010-1111-1111', 'USER', '1990-05-20'),
('user2', 'test123', '이지은', 'jieun@test.com', '010-2222-2222', 'USER', '1992-08-14'),
('user3', 'test123', '박서준', 'seojun@test.com', '010-3333-3333', 'USER', '1988-11-30'),
('user4', 'test123', '최유나', 'yuna@test.com', '010-4444-4444', 'USER', '1995-02-28'),
('user5', 'test123', '정태영', 'taeyoung@test.com', '010-5555-5555', 'USER', '1987-09-10'),
('user6', 'test123', '강수진', 'sujin@test.com', '010-6666-6666', 'USER', '1993-12-05'),
('user7', 'test123', '윤재호', 'jaeho@test.com', '010-7777-7777', 'USER', '1991-04-22'),
('user8', 'test123', '한소희', 'sohee@test.com', '010-8888-8888', 'USER', '1994-07-18'),
('user9', 'test123', '조민기', 'mingi@test.com', '010-9999-9999', 'USER', '1989-01-25'),
('user10', 'test123', '송하늘', 'haneul@test.com', '010-1010-1010', 'USER', '1996-06-12');

-- ================================================
-- 2. 봉사 신청 내역 생성 (completed 상태로, 과거 날짜)
-- ================================================
INSERT INTO volunteer_applications
(user_id, applicant_name, applicant_phone, applicant_email, applicant_address, volunteer_experience, selected_category, volunteer_date, volunteer_end_date, volunteer_time, status, created_at, completed_at)
VALUES
('user1', '김민수', '010-1111-1111', 'minsu@test.com', '서울시 강남구', '1-3년', '노인 복지', '2025-01-10', '2025-01-10', '오전 9시-12시', 'completed', '2025-01-05 10:00:00', '2025-01-10 12:00:00'),
('user2', '이지은', '010-2222-2222', 'jieun@test.com', '서울시 서초구', '1년미만', '아동 복지', '2025-01-12', '2025-01-12', '오후 2시-5시', 'completed', '2025-01-06 14:30:00', '2025-01-12 17:00:00'),
('user3', '박서준', '010-3333-3333', 'seojun@test.com', '서울시 송파구', '3년이상', '환경 보호', '2025-01-08', '2025-01-08', '오전 9시-12시', 'completed', '2025-01-02 09:15:00', '2025-01-08 12:00:00'),
('user4', '최유나', '010-4444-4444', 'yuna@test.com', '서울시 마포구', '없음', '장애인 복지', '2025-01-15', '2025-01-15', '오후 1시-4시', 'completed', '2025-01-10 11:20:00', '2025-01-15 16:00:00'),
('user5', '정태영', '010-5555-5555', 'taeyoung@test.com', '서울시 용산구', '1-3년', '노인 복지', '2025-01-09', '2025-01-09', '오전 10시-1시', 'completed', '2025-01-04 16:40:00', '2025-01-09 13:00:00'),
('user6', '강수진', '010-6666-6666', 'sujin@test.com', '서울시 강동구', '1년미만', '아동 복지', '2025-01-13', '2025-01-13', '오후 3시-6시', 'completed', '2025-01-08 13:50:00', '2025-01-13 18:00:00'),
('user7', '윤재호', '010-7777-7777', 'jaeho@test.com', '서울시 성북구', '3년이상', '환경 보호', '2025-01-11', '2025-01-11', '오전 8시-11시', 'completed', '2025-01-05 08:30:00', '2025-01-11 11:00:00'),
('user8', '한소희', '010-8888-8888', 'sohee@test.com', '서울시 관악구', '1년미만', '노인 복지', '2025-01-14', '2025-01-14', '오후 2시-5시', 'completed', '2025-01-09 15:20:00', '2025-01-14 17:00:00'),
('user9', '조민기', '010-9999-9999', 'mingi@test.com', '서울시 영등포구', '1-3년', '장애인 복지', '2025-01-07', '2025-01-07', '오전 9시-12시', 'completed', '2025-01-03 10:10:00', '2025-01-07 12:00:00'),
('user10', '송하늘', '010-1010-1010', 'haneul@test.com', '서울시 종로구', '없음', '아동 복지', '2025-01-16', '2025-01-16', '오후 1시-4시', 'completed', '2025-01-11 12:30:00', '2025-01-16 16:00:00');

-- ================================================
-- 3. 방금 삽입한 application_id 조회
-- ================================================
SET @app_id_1 = (SELECT application_id FROM volunteer_applications WHERE user_id = 'user1' AND volunteer_date = '2025-01-10' LIMIT 1);
SET @app_id_2 = (SELECT application_id FROM volunteer_applications WHERE user_id = 'user2' AND volunteer_date = '2025-01-12' LIMIT 1);
SET @app_id_3 = (SELECT application_id FROM volunteer_applications WHERE user_id = 'user3' AND volunteer_date = '2025-01-08' LIMIT 1);
SET @app_id_4 = (SELECT application_id FROM volunteer_applications WHERE user_id = 'user4' AND volunteer_date = '2025-01-15' LIMIT 1);
SET @app_id_5 = (SELECT application_id FROM volunteer_applications WHERE user_id = 'user5' AND volunteer_date = '2025-01-09' LIMIT 1);
SET @app_id_6 = (SELECT application_id FROM volunteer_applications WHERE user_id = 'user6' AND volunteer_date = '2025-01-13' LIMIT 1);
SET @app_id_7 = (SELECT application_id FROM volunteer_applications WHERE user_id = 'user7' AND volunteer_date = '2025-01-11' LIMIT 1);
SET @app_id_8 = (SELECT application_id FROM volunteer_applications WHERE user_id = 'user8' AND volunteer_date = '2025-01-14' LIMIT 1);
SET @app_id_9 = (SELECT application_id FROM volunteer_applications WHERE user_id = 'user9' AND volunteer_date = '2025-01-07' LIMIT 1);
SET @app_id_10 = (SELECT application_id FROM volunteer_applications WHERE user_id = 'user10' AND volunteer_date = '2025-01-16' LIMIT 1);

-- ================================================
-- 4. 봉사 후기 10개 생성
-- ================================================
INSERT INTO volunteer_reviews (user_id, application_id, title, content, rating, created_at)
VALUES
('user1', @app_id_1, '따뜻한 마음을 나눈 하루',
'어르신들과 함께 시간을 보내며 많은 것을 배웠습니다. 혼자 계신 어르신들께 도시락을 전달하며 나눈 대화가 정말 의미 있었어요. 처음에는 어색했지만, 어르신들의 환한 웃음을 보며 보람을 느꼈습니다. 다음에도 꼭 참여하고 싶습니다!',
5, '2025-01-11 14:00:00'),

('user2', @app_id_2, '아이들의 웃음이 최고의 선물',
'지역아동센터에서 아이들과 함께 공부하고 놀아주는 시간이 너무 즐거웠습니다. 아이들의 순수한 눈망울과 천진난만한 웃음소리가 하루 종일 귓가에 맴돕니다. 수학 문제를 풀어주고 "선생님 고마워요!"라는 말을 들었을 때 정말 행복했어요. 봉사가 아니라 오히려 제가 더 많이 받아간 것 같습니다.',
5, '2025-01-13 10:30:00'),

('user3', @app_id_3, '깨끗한 환경, 건강한 미래',
'올림픽공원 주변 환경 정화 활동에 참여했습니다. 쓰레기를 줍고 분리수거하는 단순한 작업이었지만, 점점 깨끗해지는 공원을 보며 뿌듯함을 느꼈습니다. 함께한 봉사자분들과 협력하며 더 큰 보람을 느낄 수 있었어요. 우리가 사는 환경을 지키는 일에 작은 힘이라도 보탤 수 있어서 좋았습니다.',
4, '2025-01-09 16:00:00'),

('user4', @app_id_4, '처음이지만 의미있는 경험',
'첫 봉사 활동이라 많이 긴장했지만, 센터 직원분들이 친절하게 안내해주셔서 금방 적응할 수 있었습니다. 장애인분들과 함께 산책하고 이야기 나누며 그분들의 삶에 대해 많이 배웠습니다. 작은 도움이지만 누군가에게 필요한 존재가 될 수 있다는 게 정말 감사했어요. 앞으로도 계속 참여하고 싶습니다!',
5, '2025-01-16 09:20:00'),

('user5', @app_id_5, '어르신들의 지혜를 배우다',
'요양원에서 어르신들과 함께 시간을 보냈습니다. 어르신들의 인생 이야기를 들으며 많은 지혜를 얻었어요. 특히 한 할머니께서 들려주신 6.25 전쟁 당시 이야기가 인상 깊었습니다. "젊은 친구가 찾아와 주니 세상이 따뜻하구나"라는 말씀에 가슴이 뭉클했습니다. 단순히 도움을 드리는 게 아니라 서로 배우고 나누는 시간이었습니다.',
5, '2025-01-10 18:00:00'),

('user6', @app_id_6, '아이들에게 배운 긍정의 힘',
'방과후 교실에서 아이들의 숙제를 도와주고 함께 놀아줬어요. 아이들의 무한한 에너지와 긍정적인 마인드에 오히려 제가 힐링을 받았습니다. 특히 한 아이가 "언니 다음에도 또 와줘!"라며 안아주던 순간이 가장 기억에 남아요. 작은 나눔이 누군가에게는 큰 행복이 될 수 있다는 걸 깨달았습니다.',
4, '2025-01-14 11:45:00'),

('user7', @app_id_7, '새벽부터 시작한 보람찬 하루',
'한강 주변 쓰레기 수거 활동에 참여했습니다. 새벽 일찍 시작해서 조금 힘들었지만, 봉사가 끝나고 깨끗해진 한강을 보니 피로가 싹 가셨어요. 오랜 기간 봉사 활동을 해왔지만, 매번 새로운 보람을 느낍니다. 자연을 사랑하는 마음으로 시작한 봉사가 이제는 제 삶의 일부가 되었습니다. 함께해주신 모든 분들께 감사드립니다!',
5, '2025-01-12 13:30:00'),

('user8', @app_id_8, '할머니들의 따뜻한 손길',
'독거노인 돌봄 봉사에 참여했습니다. 청소와 말벗 서비스를 제공했는데, 할머니들께서 오히려 저를 손자처럼 챙겨주셔서 감동받았어요. 직접 담근 김치도 주시고, "자주 와야 한다"며 손을 꼭 잡아주셨습니다. 봉사를 하러 갔다가 오히려 사랑을 듬뿍 받고 왔네요. 다음에도 꼭 찾아뵙겠다고 약속드렸습니다.',
5, '2025-01-15 15:10:00'),

('user9', @app_id_9, '함께여서 더 행복한 시간',
'장애인 스포츠 활동 보조 봉사를 했습니다. 처음에는 제가 도움을 드린다고 생각했는데, 오히려 장애를 극복하고 열심히 운동하시는 분들의 모습에서 큰 용기를 얻었습니다. 특히 휠체어 농구를 하시는 분들의 열정이 대단했어요. "장애는 한계가 아니라 다른 가능성"이라는 말이 계속 생각납니다. 정말 의미 있는 하루였습니다!',
4, '2025-01-08 17:40:00'),

('user10', @app_id_10, '꿈을 키워가는 아이들과 함께',
'저소득층 아동 멘토링 봉사에 참여했어요. 아이들의 꿈 이야기를 들으며 저도 초심으로 돌아갈 수 있었습니다. 한 아이는 의사가 되고 싶다며 열심히 공부하더라고요. "누나 덕분에 수학이 재밌어졌어요!"라는 말에 정말 뿌듯했습니다. 처음 하는 봉사여서 걱정했는데, 아이들의 밝은 에너지 덕분에 즐겁게 활동할 수 있었어요. 다음에도 꼭 참여할 거예요!',
5, '2025-01-17 10:00:00');

-- ================================================
-- 5. 결과 확인
-- ================================================
SELECT '=== 봉사 신청 내역 ===' AS status;
SELECT
    application_id,
    user_id,
    applicant_name,
    volunteer_experience,
    selected_category,
    volunteer_date,
    status
FROM volunteer_applications
ORDER BY application_id DESC
LIMIT 10;

SELECT '=== 봉사 후기 목록 ===' AS status;
SELECT
    vr.review_id,
    vr.user_id,
    m.name AS user_name,
    va.volunteer_experience,
    va.selected_category AS activity_name,
    vr.title,
    SUBSTRING(vr.content, 1, 50) AS content_preview,
    vr.rating,
    vr.created_at
FROM volunteer_reviews vr
INNER JOIN member m ON vr.user_id = m.id
LEFT JOIN volunteer_applications va ON vr.application_id = va.application_id
ORDER BY vr.created_at DESC
LIMIT 10;

-- Safe update mode 다시 활성화
SET SQL_SAFE_UPDATES = 1;
SET FOREIGN_KEY_CHECKS = 1;

SELECT '=== 샘플 데이터 삽입 완료 ===' AS status;
SELECT COUNT(*) AS total_reviews FROM volunteer_reviews;
