-- ========================================================================
-- FAQ 데이터베이스 상태 확인 스크립트
-- ========================================================================

-- 1. FAQ 카테고리 테이블 확인
SELECT '=== FAQ 카테고리 확인 ===' AS '';
SELECT * FROM faq_categories ORDER BY display_order;

-- 2. FAQ 데이터 확인 (카테고리와 조인)
SELECT '=== FAQ 데이터 확인 (카테고리 조인) ===' AS '';
SELECT
    f.faq_id,
    fc.category_name AS category,
    f.question,
    SUBSTRING(f.answer, 1, 50) AS answer_preview,
    f.order_num,
    f.is_active,
    f.created_at
FROM faqs f
LEFT JOIN faq_categories fc ON f.category_id = fc.category_id
ORDER BY fc.display_order, f.order_num;

-- 3. 활성화된 FAQ만 확인 (실제 API 쿼리와 동일)
SELECT '=== 활성화된 FAQ (API 쿼리와 동일) ===' AS '';
SELECT
    f.faq_id,
    fc.category_name AS category,
    f.question,
    SUBSTRING(f.answer, 1, 50) AS answer_preview,
    f.order_num,
    f.is_active
FROM faqs f
LEFT JOIN faq_categories fc ON f.category_id = fc.category_id
WHERE f.is_active = TRUE
ORDER BY f.order_num ASC, f.created_at DESC;

-- 4. 카테고리별 FAQ 개수 확인
SELECT '=== 카테고리별 FAQ 개수 ===' AS '';
SELECT
    fc.category_name,
    COUNT(f.faq_id) AS faq_count
FROM faq_categories fc
LEFT JOIN faqs f ON fc.category_id = f.category_id AND f.is_active = TRUE
GROUP BY fc.category_id, fc.category_name
ORDER BY fc.display_order;

-- 5. 문제가 있는 FAQ 확인 (카테고리가 null인 경우)
SELECT '=== 문제가 있는 FAQ (카테고리 null) ===' AS '';
SELECT
    f.faq_id,
    f.category_id,
    f.question,
    '카테고리가 없습니다!' AS problem
FROM faqs f
LEFT JOIN faq_categories fc ON f.category_id = fc.category_id
WHERE fc.category_id IS NULL;
