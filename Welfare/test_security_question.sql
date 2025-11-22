-- 보안 질문 테스트 및 수정 SQL

-- 1. member 테이블 구조 확인
DESCRIBE member;

-- 2. security_question, security_answer 컬럼이 존재하는지 확인
SHOW COLUMNS FROM member LIKE 'security%';

-- 3. 기존 as@sd.com 계정에 보안 질문 추가
UPDATE member
SET security_question = '어머니의 성함은?',
    security_answer = '테스트답변'
WHERE id = 'as@sd.com';

-- 4. 업데이트 확인
SELECT id, email, name, security_question, security_answer
FROM member
WHERE id = 'as@sd.com';

-- 5. 만약 security_question 컬럼이 없다면 실행:
-- ALTER TABLE member ADD COLUMN security_question VARCHAR(200);
-- ALTER TABLE member ADD COLUMN security_answer VARCHAR(200);
