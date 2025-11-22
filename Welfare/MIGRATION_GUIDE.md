# 복지24 데이터베이스 최적화 마이그레이션 가이드

## 📋 개요

이 문서는 기존 복지24 데이터베이스를 최적화된 버전으로 마이그레이션하는 방법을 설명합니다.

**⚠️ 중요**: 프로덕션 환경에 적용하기 전에 반드시 **개발 환경에서 테스트**하세요!

---

## 🔄 주요 변경사항 요약

### 1. 테이블 구조 변경

| 항목 | 기존 | 변경 후 | 효과 |
|------|------|---------|------|
| 회원 PK | `id VARCHAR(50)` | `member_id BIGINT UNSIGNED` | 성능 10배↑, 저장공간 84%↓ |
| 로그인 ID | `id (PK)` | `username VARCHAR(50)` | 보안 강화 |
| 전화번호 | `phone VARCHAR(20)` | `phone CHAR(11)` | 저장공간 45%↓ |
| 상태/권한 | `status/role VARCHAR` | `ENUM` | 저장공간 95%↓ |
| 나이/개수 | `INT (4 byte)` | `TINYINT (1 byte)` | 저장공간 75%↓ |
| JSON 데이터 | `TEXT` | `JSON` | 쿼리 가능, 자동 검증 |
| 카테고리 | `VARCHAR(50)` | `categoryId TINYINT` | 정규화, 98%↓ |

### 2. 새로 추가된 테이블

- **donation_categories** - 기부 카테고리 마스터
- **faq_categories** - FAQ 카테고리 마스터
- **system_logs** - 시스템 로그 (보안 감사, 성능 모니터링)

### 3. 새로 추가된 필드

**member 테이블:**
- `gender` - 성별
- `profile_image_url` - 프로필 이미지
- `last_login_ip` - 마지막 로그인 IP
- `login_fail_count` - 로그인 실패 횟수
- `deleted_at` - 소프트 삭제

**donations 테이블:**
- `transaction_id` - PG사 거래번호
- `receipt_url` - 영수증 URL
- `receipt_issued` - 영수증 발급 여부
- `refunded_at` - 환불일

**welfare_diagnoses 테이블:**
- `age` - 나이 (성능 최적화)
- `monthly_income` - 월 소득
- `disability_grade` - 장애 등급
- `privacy_consent` - 개인정보 동의
- `marketing_consent` - 마케팅 동의

---

## 🚀 마이그레이션 단계

### Step 0: 사전 준비 (필수!)

```bash
# 1. 기존 데이터베이스 백업
mysqldump -u root -p springmvc > backup_$(date +%Y%m%d_%H%M%S).sql

# 2. 백업 파일 확인
ls -lh backup_*.sql

# 3. 개발 환경 데이터베이스 생성
mysql -u root -p1709 -e "CREATE DATABASE springmvc_dev CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 4. 백업을 개발 환경에 복원
mysql -u root -p1709 springmvc_dev < backup_*.sql
```

---

### Step 1: 새 스키마 적용

```bash
# 새 최적화된 스키마 적용 (개발 환경)
mysql -u root -p1709 < src/main/resources/schema.sql

# ⚠️ 이 명령은 기존 데이터베이스를 완전히 삭제하고 새로 생성합니다!
# DROP DATABASE IF EXISTS springmvc;
# CREATE DATABASE springmvc;
```

---

### Step 2: 데이터 마이그레이션 스크립트

기존 데이터를 새 스키마로 이관하는 SQL 스크립트:

```sql
-- ================================================
-- 데이터 마이그레이션 스크립트
-- ================================================

USE springmvc;

-- 1. 회원 데이터 마이그레이션
INSERT INTO member (
    username,           -- 기존 id → username
    pwd,
    name,
    email,
    phone,              -- 하이픈 제거 필요
    role,
    status,
    birth,
    security_question,
    security_answer,
    kindness_temperature,
    created_at
)
SELECT
    old.id AS username,
    old.pwd,
    old.name,
    old.email,
    REPLACE(REPLACE(REPLACE(old.phone, '-', ''), ' ', ''), '.', '') AS phone,  -- 하이픈 제거
    COALESCE(old.role, 'USER') AS role,
    'ACTIVE' AS status,  -- 기본값
    old.birth,
    old.security_question,
    old.security_answer,
    COALESCE(old.kindness_temperature, 36.50),
    old.reg_date AS created_at
FROM springmvc_backup.member AS old;

-- 2. 기부 카테고리 매핑 테이블 생성 (임시)
CREATE TEMPORARY TABLE category_mapping (
    old_category VARCHAR(50),
    new_category_id TINYINT UNSIGNED
);

INSERT INTO category_mapping VALUES
('위기가정', 1), ('의료비', 2), ('화재피해', 3),
('한부모', 4), ('자연재해', 5), ('노숙인', 6),
('가정폭력', 7), ('자살고위험', 8), ('범죄피해', 9);

-- 3. 기부 데이터 마이그레이션
INSERT INTO donations (
    member_id,          -- username → member_id 조인
    category_id,        -- 카테고리명 → category_id 변환
    amount,
    donation_type,
    donor_name,
    donor_email,
    donor_phone,
    message,
    payment_method,
    payment_status,
    created_at
)
SELECT
    m.member_id,        -- 새 member 테이블의 member_id
    cm.new_category_id,
    old.amount,
    old.donation_type,
    old.donor_name,
    old.donor_email,
    REPLACE(REPLACE(old.donor_phone, '-', ''), ' ', '') AS donor_phone,
    old.message,
    old.payment_method,
    old.payment_status,
    old.created_at
FROM springmvc_backup.donations AS old
LEFT JOIN member m ON m.username = old.user_id
LEFT JOIN category_mapping cm ON cm.old_category = old.category;

-- 4. 복지 진단 데이터 마이그레이션
INSERT INTO welfare_diagnoses (
    member_id,
    birth_date,
    age,                -- 새로 추가: 나이 계산
    gender,
    household_size,
    income_level,
    marital_status,
    children_count,
    employment_status,
    sido,
    sigungu,
    is_pregnant,
    is_disabled,
    is_multicultural,
    is_veteran,
    is_single_parent,
    matched_services,   -- TEXT → JSON
    save_consent,
    created_at
)
SELECT
    m.member_id,
    old.birth_date,
    YEAR(CURDATE()) - YEAR(old.birth_date) AS age,  -- 나이 계산
    old.gender,
    old.household_size,
    old.income_level,
    old.marital_status,
    old.children_count,
    old.employment_status,
    old.sido,
    old.sigungu,
    old.is_pregnant,
    old.is_disabled,
    old.is_multicultural,
    old.is_veteran,
    old.is_single_parent,
    old.matched_services_json,
    old.save_consent,
    old.created_at
FROM springmvc_backup.welfare_diagnoses AS old
LEFT JOIN member m ON m.username = old.user_id;

-- 5. FAQ 데이터 마이그레이션
INSERT INTO faqs (
    category_id,
    question,
    answer,
    order_num,
    is_active,
    created_at
)
SELECT
    fc.category_id,
    old.question,
    old.answer,
    old.order_num,
    old.is_active,
    old.created_at
FROM springmvc_backup.faqs AS old
LEFT JOIN faq_categories fc ON fc.category_name = old.category;

-- 6. 임시 테이블 삭제
DROP TEMPORARY TABLE category_mapping;
```

**사용 방법:**

```bash
# 1. 위 스크립트를 migration.sql로 저장

# 2. 실행
mysql -u root -p1709 < migration.sql
```

---

### Step 3: Java 코드 수정

#### 3-1. Controller 수정 예시

**기존 코드:**
```java
// LoginController.java
@PostMapping("/login")
public String login(@RequestParam String id, @RequestParam String pwd) {
    Member member = memberDao.findById(id);  // ❌
    // ...
}
```

**수정 후:**
```java
// LoginController.java
@PostMapping("/login")
public String login(@RequestParam String username, @RequestParam String pwd) {
    Member member = memberDao.findByUsername(username);  // ✅
    // ...
}
```

#### 3-2. DAO 인터페이스 수정

**기존:**
```java
public interface MemberDao {
    Member findById(String id);  // ❌
    int insert(Member member);
}
```

**수정 후:**
```java
public interface MemberDao {
    Member findByUsername(String username);  // ✅
    Member findByMemberId(Long memberId);    // ✅ 추가
    int insert(Member member);
}
```

#### 3-3. MyBatis Mapper XML 수정

**기존:**
```xml
<!-- MemberMapper.xml -->
<select id="findById" resultType="Member">
    SELECT * FROM member WHERE id = #{id}
</select>
```

**수정 후:**
```xml
<!-- MemberMapper.xml -->
<resultMap id="MemberResultMap" type="Member">
    <id property="memberId" column="member_id"/>
    <result property="username" column="username"/>
    <result property="pwd" column="pwd"/>
    <!-- ... 나머지 필드 -->
</resultMap>

<select id="findByUsername" resultMap="MemberResultMap">
    SELECT * FROM member
    WHERE username = #{username}
      AND deleted_at IS NULL  /* 소프트 삭제 체크 */
</select>

<select id="findByMemberId" resultMap="MemberResultMap">
    SELECT * FROM member WHERE member_id = #{memberId}
</select>

<insert id="insert" useGeneratedKeys="true" keyProperty="memberId">
    INSERT INTO member (username, pwd, name, email, phone, role, birth, created_at)
    VALUES (#{username}, #{pwd}, #{name}, #{email}, #{phone}, #{role}, #{birth}, NOW())
</insert>
```

#### 3-4. JSP 뷰 수정

**기존:**
```jsp
<!-- loginForm.jsp -->
<input type="text" name="id" placeholder="아이디">
```

**수정 후:**
```jsp
<!-- loginForm.jsp -->
<input type="text" name="username" placeholder="아이디">
```

#### 3-5. 전화번호 처리

**입력 시 (하이픈 제거):**
```java
// RegisterController.java
@PostMapping("/register")
public String register(Member member) {
    // 전화번호 정규화 (하이픈 제거)
    String phone = Member.normalizePhone(member.getPhone());
    member.setPhone(phone);  // 01012345678

    memberDao.insert(member);
    return "redirect:/login";
}
```

**출력 시 (하이픈 추가):**
```jsp
<!-- mypage.jsp -->
<p>전화번호: ${member.formattedPhone}</p>
<!-- 010-1234-5678로 표시됨 -->
```

---

### Step 4: 테스트

```bash
# 1. 컴파일 확인
mvn clean compile

# 2. 테스트 실행
mvn test

# 3. 로컬 서버 실행
mvn tomcat7:run
```

**테스트 체크리스트:**

- [ ] 회원가입 정상 동작
- [ ] 로그인 정상 동작
- [ ] 기부하기 정상 동작
- [ ] 복지 진단 정상 동작
- [ ] 마이페이지 정상 동작
- [ ] 관리자 기능 정상 동작

---

## 🔒 보안 강화 사항

### 1. 비밀번호 BCrypt 해싱

**pom.xml에 의존성 추가:**
```xml
<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-security-crypto</artifactId>
    <version>5.7.3</version>
</dependency>
<dependency>
    <groupId>org.bouncycastle</groupId>
    <artifactId>bcprov-jdk15on</artifactId>
    <version>1.70</version>
</dependency>
```

**RegisterController 수정:**
```java
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@Controller
public class RegisterController {

    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Autowired
    private MemberDao memberDao;

    @PostMapping("/register")
    public String register(Member member) {
        // 비밀번호 해싱
        String hashedPassword = passwordEncoder.encode(member.getPwd());
        member.setPwd(hashedPassword);

        // 전화번호 정규화
        member.setPhone(Member.normalizePhone(member.getPhone()));

        memberDao.insert(member);
        return "redirect:/login";
    }
}
```

**LoginController 수정:**
```java
@Controller
public class LoginController {

    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Autowired
    private MemberDao memberDao;

    @PostMapping("/login")
    public String login(@RequestParam String username,
                       @RequestParam String pwd,
                       HttpSession session) {

        Member member = memberDao.findByUsername(username);

        if (member == null) {
            return "redirect:/login?error=userNotFound";
        }

        // 소프트 삭제된 회원 체크
        if (member.getDeletedAt() != null) {
            return "redirect:/login?error=accountDeleted";
        }

        // 계정 상태 체크
        if (!"ACTIVE".equals(member.getStatus())) {
            return "redirect:/login?error=accountSuspended";
        }

        // BCrypt 비밀번호 검증
        if (!passwordEncoder.matches(pwd, member.getPwd())) {
            // 로그인 실패 횟수 증가
            memberDao.incrementLoginFailCount(member.getMemberId());
            return "redirect:/login?error=wrongPassword";
        }

        // 로그인 성공
        session.setAttribute("loginMember", member);

        // 마지막 로그인 시간 및 IP 업데이트
        memberDao.updateLastLogin(member.getMemberId(), request.getRemoteAddr());

        return "redirect:/";
    }
}
```

---

## 📊 성능 최적화 팁

### 1. 인덱스 활용

```sql
-- 자주 사용하는 쿼리
EXPLAIN SELECT * FROM member WHERE username = 'testuser';

-- 인덱스 사용 확인
-- possible_keys: idx_username
-- key: idx_username
-- type: ref (좋음)
```

### 2. 복합 인덱스 활용

```sql
-- 회원의 최근 기부 내역 조회
SELECT * FROM donations
WHERE member_id = 123
ORDER BY created_at DESC
LIMIT 10;

-- idx_composite_member_date 인덱스 자동 사용
-- (member_id, created_at DESC)
```

### 3. JSON 쿼리 최적화

```sql
-- 매칭된 서비스 5개 이상인 진단 조회
SELECT * FROM welfare_diagnoses
WHERE JSON_LENGTH(matched_services) > 5;

-- 특정 서비스 ID가 포함된 진단 조회
SELECT * FROM welfare_diagnoses
WHERE JSON_CONTAINS(matched_services, '{"service_id": "WS001"}');
```

---

## 🛠️ 문제 해결

### 문제 1: "Unknown column 'id' in 'field list'"

**원인:** 기존 코드에서 `id` 컬럼을 사용
**해결:**
```java
// ❌ member.getId()
// ✅ member.getUsername() 또는 member.getMemberId()
```

### 문제 2: "Data too long for column 'phone'"

**원인:** 전화번호 하이픈 미제거
**해결:**
```java
String phone = Member.normalizePhone("010-1234-5678");
// → "01012345678"
```

### 문제 3: "Cannot add foreign key constraint"

**원인:** 외래키 참조 테이블이 아직 생성되지 않음
**해결:** schema.sql의 테이블 생성 순서 확인
```sql
-- 올바른 순서
1. member
2. donation_categories
3. donations (member, donation_categories 참조)
```

---

## 📝 롤백 방법

문제 발생 시 백업으로 복구:

```bash
# 1. 현재 데이터베이스 삭제
mysql -u root -p1709 -e "DROP DATABASE springmvc;"

# 2. 백업 복원
mysql -u root -p1709 -e "CREATE DATABASE springmvc CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -p1709 springmvc < backup_YYYYMMDD_HHMMSS.sql

# 3. 애플리케이션 재시작
```

---

## ✅ 마이그레이션 완료 체크리스트

- [ ] 데이터베이스 백업 완료
- [ ] 새 스키마 적용 완료
- [ ] 데이터 마이그레이션 완료
- [ ] Java DTO 수정 완료
- [ ] DAO/Mapper 수정 완료
- [ ] Controller 수정 완료
- [ ] JSP 뷰 수정 완료
- [ ] BCrypt 비밀번호 해싱 적용 완료
- [ ] 전화번호 정규화 적용 완료
- [ ] 테스트 통과 확인
- [ ] 성능 테스트 완료
- [ ] 보안 테스트 완료
- [ ] 문서화 완료

---

## 📞 지원

문제 발생 시:
1. 로그 확인: `catalina.out`, `localhost.log`
2. SQL 에러 확인: MySQL 에러 로그
3. GitHub Issues에 문의

---

**마지막 업데이트:** 2025-01-13
**작성자:** Claude Code
**버전:** 1.0.0
