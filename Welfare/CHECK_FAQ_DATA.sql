-- FAQ 데이터 확인 쿼리
USE springmvc;

-- 1. 전체 FAQ 데이터 확인
SELECT '=== 전체 FAQ 데이터 ===' AS '';
SELECT
    faq_id,
    category,
    question,
    SUBSTRING(answer, 1, 50) AS answer_preview,
    is_active
FROM faqs
ORDER BY faq_id;

-- 2. "복지" 키워드가 포함된 FAQ 확인
SELECT '=== "복지" 검색 결과 ===' AS '';
SELECT
    faq_id,
    category,
    question,
    CASE
        WHEN question LIKE '%복지%' THEN 'O'
        ELSE ''
    END AS question_match,
    CASE
        WHEN answer LIKE '%복지%' THEN 'O'
        ELSE ''
    END AS answer_match
FROM faqs
WHERE is_active = TRUE
  AND (
      question LIKE '%복지%'
      OR answer LIKE '%복지%'
      OR category LIKE '%복지%'
  )
ORDER BY
    CASE
        WHEN question = '복지' THEN 1
        WHEN question LIKE CONCAT('복지', '%') THEN 2
        WHEN question LIKE CONCAT('%', '복지', '%') THEN 3
        WHEN answer LIKE CONCAT('복지', '%') THEN 4
        ELSE 5
    END;

-- 3. 카테고리별 개수
SELECT '=== 카테고리별 FAQ 개수 ===' AS '';
SELECT
    category,
    COUNT(*) AS count
FROM faqs
GROUP BY category;

-- 4. 활성화된 FAQ 개수
SELECT '=== 활성화 상태 ===' AS '';
SELECT
    is_active,
    COUNT(*) AS count
FROM faqs
GROUP BY is_active;
