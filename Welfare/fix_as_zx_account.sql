-- as@zx.com 계정에 보안 질문 추가
USE springmvc;

UPDATE member
SET security_question = '어머니의 성함은?',
    security_answer = '테스트답변'
WHERE id = 'as@zx.com';

-- 확인
SELECT id, email, name, security_question, security_answer
FROM member
WHERE id = 'as@zx.com';
