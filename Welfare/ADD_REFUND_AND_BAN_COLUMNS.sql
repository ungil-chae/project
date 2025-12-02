-- 기부 환불 및 봉사활동 취소 관련 스키마 변경
-- 실행 전 백업을 권장합니다.

-- 1. members 테이블에 봉사 신청 금지 날짜 컬럼 추가
-- 24시간 이내 봉사활동 취소 시 1주일간 봉사 신청 금지
ALTER TABLE members
ADD COLUMN IF NOT EXISTS volunteer_ban_until DATETIME NULL DEFAULT NULL
COMMENT '봉사활동 신청 금지 해제일시 (24시간 이내 취소 시 1주일 제한)';

-- 2. donations 테이블에 환불 관련 컬럼 추가
-- 환불 금액 (10% 수수료 제외)
ALTER TABLE donations
ADD COLUMN IF NOT EXISTS refund_amount INT NULL DEFAULT NULL
COMMENT '환불 금액 (수수료 제외)';

-- 환불 수수료 (24시간 이후 환불 시 10%)
ALTER TABLE donations
ADD COLUMN IF NOT EXISTS refund_fee INT NULL DEFAULT NULL
COMMENT '환불 수수료 (24시간 이후 10%)';

-- 환불 처리 일시
ALTER TABLE donations
ADD COLUMN IF NOT EXISTS refunded_at DATETIME NULL DEFAULT NULL
COMMENT '환불 처리 일시';

-- 3. volunteer_applications 테이블에 취소 관련 컬럼 확인
-- 이미 있을 수 있으므로 IF NOT EXISTS 사용
ALTER TABLE volunteer_applications
ADD COLUMN IF NOT EXISTS cancel_reason VARCHAR(500) NULL DEFAULT NULL
COMMENT '취소 사유';

ALTER TABLE volunteer_applications
ADD COLUMN IF NOT EXISTS cancelled_at DATETIME NULL DEFAULT NULL
COMMENT '취소 일시';

-- 4. donation_reviews 테이블에 title 컬럼 추가
ALTER TABLE donation_reviews
ADD COLUMN IF NOT EXISTS title VARCHAR(200) NULL DEFAULT NULL
COMMENT '리뷰 제목' AFTER donation_id;

-- 5. 인덱스 추가 (성능 최적화)
-- 봉사 금지 확인을 위한 인덱스
CREATE INDEX IF NOT EXISTS idx_members_volunteer_ban
ON members(volunteer_ban_until);

-- 환불 상태 확인을 위한 인덱스
CREATE INDEX IF NOT EXISTS idx_donations_payment_status
ON donations(payment_status);

-- 6. payment_status ENUM 값에 REFUNDED 추가 (이미 있을 수 있음)
-- MySQL에서 ENUM 수정은 조심해야 함 - 기존 값 확인 필요
-- ALTER TABLE donations MODIFY COLUMN payment_status ENUM('PENDING', 'COMPLETED', 'CANCELLED', 'REFUNDED') DEFAULT 'PENDING';

-- 확인 쿼리
SELECT 'Schema update completed!' AS status;

-- 테이블 구조 확인
DESCRIBE members;
DESCRIBE donations;
DESCRIBE volunteer_applications;
DESCRIBE donation_reviews;
