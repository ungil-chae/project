-- 기존 as@sd.com 계정에 보안 질문 추가
-- MySQL Workbench에서 실행하세요

USE springmvc;

-- 1. 현재 상태 확인
SELECT id, email, name, security_question, security_answer, kindness_temperature
FROM member
WHERE id = 'as@sd.com';

-- 2. 보안 질문 및 선행 온도 추가
UPDATE member
SET security_question = '어머니의 성함은?',
    security_answer = '테스트답변',
    kindness_temperature = 36.50
WHERE id = 'as@sd.com';

-- 3. 업데이트 확인
SELECT id, email, name, security_question, security_answer, kindness_temperature
FROM member
WHERE id = 'as@sd.com';

-- 완료 메시지
SELECT '보안 질문이 성공적으로 추가되었습니다!' AS result;
