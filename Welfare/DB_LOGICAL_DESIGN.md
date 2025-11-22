# 복지24 데이터베이스 논리적 설계

**프로젝트**: 복지24 (Welfare 24)
**DBMS**: MySQL 8.3.0
**스키마**: springmvc

---

## 1. 회원 (member)

**설명**: 회원가입, 이메일 로그인, 권한관리, 회원정보 조회

```
회원 고유번호	이메일	비밀번호	이름	전화번호	생년월일	성별	권한	계정상태	보안질문	보안답변	로그인실패횟수	선행온도	프로필이미지	마지막로그인일시	마지막로그인IP	가입일	수정일	탈퇴일
member_id	email	pwd	name	phone	birth	gender	role	status	security_question	security_answer	login_fail_count	kindness_temperature	profile_image_url	last_login_at	last_login_ip	created_at	updated_at	deleted_at
BIGINT UNSIGNED	VARCHAR(100)	VARCHAR(255)	VARCHAR(100)	CHAR(11)	DATE	ENUM	ENUM	ENUM	VARCHAR(200)	VARCHAR(255)	INT UNSIGNED	DECIMAL(5,2)	VARCHAR(500)	TIMESTAMP	VARCHAR(45)	TIMESTAMP	TIMESTAMP	TIMESTAMP
PRIMARY KEY	UNIQUE KEY	NOT NULL	NOT NULL	NULL	NULL	NULL	NOT NULL	NOT NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NOT NULL	NOT NULL	NULL
AUTO_INCREMENT	-	-	-	-	-	NULL	'USER'	'ACTIVE'	-	-	0	36.50	-	-	-	CURRENT_TIMESTAMP	ON UPDATE	-
```

---

## 2. 기부 카테고리 마스터 (donation_categories)

**설명**: 기부 분야 관리, 카테고리 정규화

```
카테고리ID	카테고리코드	카테고리명	정렬순서	활성화여부	등록일
category_id	category_code	category_name	display_order	is_active	created_at
INT UNSIGNED	VARCHAR(30)	VARCHAR(50)	INT UNSIGNED	BOOLEAN	TIMESTAMP
PRIMARY KEY	UNIQUE KEY	NOT NULL	NULL	NULL	NOT NULL
AUTO_INCREMENT	-	-	0	TRUE	CURRENT_TIMESTAMP
```

---

## 3. 기부 (donations)

**설명**: 기부 접수, 결제 관리, 영수증 발급

```
기부ID	회원고유번호	카테고리ID	기부금액	기부유형	패키지명	메시지	후원자명	후원자이메일	후원자전화번호	결제수단	결제상태	트랜잭션ID	영수증URL	영수증발급여부	세액공제대상	기부일	수정일	환불일
donation_id	member_id	category_id	amount	donation_type	package_name	message	donor_name	donor_email	donor_phone	payment_method	payment_status	transaction_id	receipt_url	receipt_issued	tax_deduction_eligible	created_at	updated_at	refunded_at
BIGINT UNSIGNED	BIGINT UNSIGNED	INT UNSIGNED	DECIMAL(15,2)	ENUM	VARCHAR(100)	TEXT	VARCHAR(100)	VARCHAR(100)	CHAR(11)	ENUM	ENUM	VARCHAR(100)	VARCHAR(500)	BOOLEAN	BOOLEAN	TIMESTAMP	TIMESTAMP	TIMESTAMP
PRIMARY KEY	FK → member	FK → donation_categories	NOT NULL	NOT NULL	NULL	NULL	NOT NULL	NOT NULL	NULL	NOT NULL	NOT NULL	NULL	NULL	NULL	NULL	NOT NULL	NOT NULL	NULL
AUTO_INCREMENT	-	-	-	-	-	-	-	-	-	'CREDIT_CARD'	'COMPLETED'	-	-	FALSE	TRUE	CURRENT_TIMESTAMP	ON UPDATE	-
```

---

## 4. 기부 후기 (donation_reviews)

**설명**: 기부 후기 작성, 평점 관리

```
후기ID	회원고유번호	기부ID	작성자명	제목	내용	별점	익명여부	노출여부	도움됨카운트	신고횟수	작성일	수정일	삭제일
review_id	member_id	donation_id	reviewer_name	title	content	rating	is_anonymous	is_visible	helpful_count	report_count	created_at	updated_at	deleted_at
BIGINT UNSIGNED	BIGINT UNSIGNED	BIGINT UNSIGNED	VARCHAR(100)	VARCHAR(200)	TEXT	INT UNSIGNED	BOOLEAN	BOOLEAN	INT UNSIGNED	INT UNSIGNED	TIMESTAMP	TIMESTAMP	TIMESTAMP
PRIMARY KEY	FK → member	FK → donations	NOT NULL	NULL	NOT NULL	NOT NULL	NULL	NULL	NULL	NULL	NOT NULL	NOT NULL	NULL
AUTO_INCREMENT	-	-	-	-	-	-	FALSE	TRUE	0	0	CURRENT_TIMESTAMP	ON UPDATE	-
```

---

## 5. 복지 진단 결과 (welfare_diagnoses)

**설명**: 복지 혜택 진단, 사용자 정보 수집, 서비스 매칭

```
진단ID	회원고유번호	생년월일	나이	성별	가구원수	결혼상태	자녀수	소득수준	월소득	취업상태	시도	시군구	임신여부	장애여부	장애등급	다문화가정	보훈대상	한부모가정	독거노인여부	저소득층여부	매칭된서비스JSON	매칭된서비스수	전체매칭점수	저장동의	개인정보동의	마케팅동의	IP주소	사용자에이전트	유입경로	진단일
diagnosis_id	member_id	birth_date	age	gender	household_size	marital_status	children_count	income_level	monthly_income	employment_status	sido	sigungu	is_pregnant	is_disabled	disability_grade	is_multicultural	is_veteran	is_single_parent	is_elderly_living_alone	is_low_income	matched_services	matched_services_count	total_matching_score	save_consent	privacy_consent	marketing_consent	ip_address	user_agent	referrer_url	created_at
BIGINT UNSIGNED	BIGINT UNSIGNED	DATE	INT UNSIGNED	ENUM	INT UNSIGNED	ENUM	INT UNSIGNED	ENUM	DECIMAL(12,2)	ENUM	VARCHAR(50)	VARCHAR(50)	BOOLEAN	BOOLEAN	INT UNSIGNED	BOOLEAN	BOOLEAN	BOOLEAN	BOOLEAN	BOOLEAN	JSON	INT UNSIGNED	INT UNSIGNED	BOOLEAN	BOOLEAN	BOOLEAN	VARCHAR(45)	VARCHAR(500)	VARCHAR(500)	TIMESTAMP
PRIMARY KEY	FK → member	NOT NULL	NULL	NULL	NULL	NULL	NULL	NOT NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NOT NULL
AUTO_INCREMENT	-	-	-	-	-	-	0	-	-	-	-	-	FALSE	FALSE	-	FALSE	FALSE	FALSE	FALSE	FALSE	-	0	0	TRUE	FALSE	FALSE	-	-	-	CURRENT_TIMESTAMP
```

---

## 6. 공지사항 (notices)

**설명**: 시스템 공지, 이벤트 안내

```
공지사항ID	관리자ID	제목	내용	카테고리	중요도	조회수	상단고정여부	게시시작일	게시종료일	작성일	수정일	삭제일
notice_id	admin_id	title	content	category	priority	views	is_pinned	published_at	expired_at	created_at	updated_at	deleted_at
BIGINT UNSIGNED	BIGINT UNSIGNED	VARCHAR(200)	TEXT	ENUM	ENUM	INT UNSIGNED	BOOLEAN	TIMESTAMP	TIMESTAMP	TIMESTAMP	TIMESTAMP	TIMESTAMP
PRIMARY KEY	FK → member	NOT NULL	NOT NULL	NULL	NULL	NULL	NULL	NULL	NULL	NOT NULL	NOT NULL	NULL
AUTO_INCREMENT	-	-	-	'GENERAL'	'NORMAL'	0	FALSE	-	-	CURRENT_TIMESTAMP	ON UPDATE	-
```

---

## 7. FAQ 카테고리 마스터 (faq_categories)

**설명**: FAQ 분류 관리

```
카테고리ID	카테고리코드	카테고리명	정렬순서	활성화여부	등록일
category_id	category_code	category_name	display_order	is_active	created_at
INT UNSIGNED	VARCHAR(30)	VARCHAR(50)	INT UNSIGNED	BOOLEAN	TIMESTAMP
PRIMARY KEY	UNIQUE KEY	NOT NULL	NULL	NULL	NOT NULL
AUTO_INCREMENT	-	-	0	TRUE	CURRENT_TIMESTAMP
```

---

## 8. FAQ (faqs)

**설명**: 자주 묻는 질문 관리

```
FAQ_ID	카테고리ID	질문	답변	정렬순서	조회수	도움됨카운트	활성화여부	작성일	수정일
faq_id	category_id	question	answer	order_num	views	helpful_count	is_active	created_at	updated_at
BIGINT UNSIGNED	INT UNSIGNED	VARCHAR(500)	TEXT	INT UNSIGNED	INT UNSIGNED	INT UNSIGNED	BOOLEAN	TIMESTAMP	TIMESTAMP
PRIMARY KEY	FK → faq_categories	NOT NULL	NOT NULL	NULL	NULL	NULL	NULL	NOT NULL	NOT NULL
AUTO_INCREMENT	-	-	-	0	0	0	TRUE	CURRENT_TIMESTAMP	ON UPDATE
```

---

## 9. 봉사 활동 마스터 (volunteer_activities)

**설명**: 봉사활동 프로그램 관리

```
봉사활동ID	봉사활동명	활동설명	카테고리	봉사장소	상세주소	시도	시군구	봉사날짜	시작시간	종료시간	봉사시간	최대인원	현재신청인원	최소연령	최대연령	모집상태	담당자명	담당자전화번호	등록일	수정일
activity_id	activity_name	description	category	location	location_detail	sido	sigungu	activity_date	start_time	end_time	duration_hours	max_participants	current_participants	min_age	max_age	status	contact_person	contact_phone	created_at	updated_at
BIGINT UNSIGNED	VARCHAR(200)	TEXT	ENUM	VARCHAR(200)	VARCHAR(500)	VARCHAR(50)	VARCHAR(50)	DATE	TIME	TIME	INT UNSIGNED	INT UNSIGNED	INT UNSIGNED	INT UNSIGNED	INT UNSIGNED	ENUM	VARCHAR(100)	CHAR(11)	TIMESTAMP	TIMESTAMP
PRIMARY KEY	NOT NULL	NULL	NULL	NOT NULL	NULL	NULL	NULL	NOT NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NOT NULL	NOT NULL
AUTO_INCREMENT	-	-	-	-	-	-	-	-	-	-	-	0	0	-	-	'RECRUITING'	-	-	CURRENT_TIMESTAMP	ON UPDATE
```

---

## 10. 봉사 신청 (volunteer_applications)

**설명**: 봉사활동 신청 접수, 참가자 관리

```
신청ID	봉사활동ID	회원고유번호	신청자명	이메일	전화번호	생년월일	성별	주소	봉사경험	선택봉사분야	지원동기	봉사시작날짜	봉사종료날짜	봉사시간대	신청상태	출석확인여부	실제봉사시간	취소사유	거절사유	신청일시	수정일	봉사완료일시	취소일시
application_id	activity_id	member_id	applicant_name	applicant_email	applicant_phone	applicant_birth	applicant_gender	applicant_address	volunteer_experience	selected_category	motivation	volunteer_date	volunteer_end_date	volunteer_time	status	attendance_checked	actual_hours	cancel_reason	reject_reason	created_at	updated_at	completed_at	cancelled_at
BIGINT UNSIGNED	BIGINT UNSIGNED	BIGINT UNSIGNED	VARCHAR(100)	VARCHAR(100)	CHAR(11)	DATE	ENUM	VARCHAR(255)	ENUM	VARCHAR(100)	TEXT	DATE	DATE	VARCHAR(50)	ENUM	BOOLEAN	INT UNSIGNED	TEXT	TEXT	TIMESTAMP	TIMESTAMP	TIMESTAMP	TIMESTAMP
PRIMARY KEY	FK → volunteer_activities	FK → member	NOT NULL	NULL	NOT NULL	NULL	NULL	NULL	NULL	NOT NULL	NULL	NOT NULL	NULL	NOT NULL	NULL	NULL	NULL	NULL	NULL	NOT NULL	NOT NULL	NULL	NULL
AUTO_INCREMENT	-	-	-	-	-	-	-	-	-	-	-	-	-	-	'APPLIED'	FALSE	-	-	-	CURRENT_TIMESTAMP	ON UPDATE	-	-
```

---

## 11. 봉사 후기 (volunteer_reviews)

**설명**: 봉사활동 후기 작성, 평가 관리

```
후기ID	회원고유번호	봉사신청ID	작성자명	제목	내용	별점	이미지URL배열	노출여부	도움됨카운트	신고횟수	작성일	수정일	삭제일
review_id	member_id	application_id	reviewer_name	title	content	rating	image_urls	is_visible	helpful_count	report_count	created_at	updated_at	deleted_at
BIGINT UNSIGNED	BIGINT UNSIGNED	BIGINT UNSIGNED	VARCHAR(100)	VARCHAR(200)	TEXT	INT UNSIGNED	JSON	BOOLEAN	INT UNSIGNED	INT UNSIGNED	TIMESTAMP	TIMESTAMP	TIMESTAMP
PRIMARY KEY	FK → member	FK → volunteer_applications	NOT NULL	NOT NULL	NOT NULL	NULL	NULL	NULL	NULL	NULL	NOT NULL	NOT NULL	NULL
AUTO_INCREMENT	-	-	-	-	-	-	-	TRUE	0	0	CURRENT_TIMESTAMP	ON UPDATE	-
```

---

## 12. 관심 복지 서비스 (favorite_welfare_services)

**설명**: 사용자가 관심 등록한 복지 서비스 관리 (복합 기본키)

```
회원고유번호	복지서비스ID	서비스명	서비스목적	소관부처	신청방법	지원유형	생애주기코드	메모	등록일
member_id	service_id	service_name	service_purpose	department	apply_method	support_type	lifecycle_code	memo	created_at
BIGINT UNSIGNED	VARCHAR(100)	VARCHAR(500)	TEXT	VARCHAR(200)	VARCHAR(100)	VARCHAR(100)	VARCHAR(50)	TEXT	TIMESTAMP
PRIMARY KEY, FK → member	PRIMARY KEY	NOT NULL	NULL	NULL	NULL	NULL	NULL	NULL	NOT NULL
-	-	-	-	-	-	-	-	-	CURRENT_TIMESTAMP
```

---

## 13. 복지 서비스 캐시 (welfare_services_cache)

**설명**: 외부 API 복지 서비스 데이터 캐싱, 조회수 추적

```
복지서비스ID	서비스명	서비스목적	소관부처	신청방법	지원유형	생애주기코드	서비스상세정보JSON	조회수	관심등록수	신청횟수	활성화여부	마지막동기화시간	동기화상태	등록일	수정일
service_id	service_name	service_purpose	department	apply_method	support_type	lifecycle_code	service_details	view_count	favorite_count	application_count	is_active	last_synced	sync_status	created_at	updated_at
VARCHAR(100)	VARCHAR(500)	TEXT	VARCHAR(200)	VARCHAR(100)	VARCHAR(100)	VARCHAR(50)	JSON	INT UNSIGNED	INT UNSIGNED	INT UNSIGNED	BOOLEAN	TIMESTAMP	ENUM	TIMESTAMP	TIMESTAMP
PRIMARY KEY	NOT NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NOT NULL	NOT NULL
-	-	-	-	-	-	-	-	0	0	0	TRUE	-	'PENDING'	CURRENT_TIMESTAMP	ON UPDATE
```

---

## 14. 복지 진단 매칭 결과 (diagnosis_results)

**설명**: 복지 진단별 매칭된 서비스 상세 점수 저장 (복합 기본키)

```
진단ID	복지서비스ID	서비스명	소관부처	매칭점수	생애주기매칭점수	가구유형매칭점수	지역매칭점수	온라인신청가능여부	매칭일
diagnosis_id	service_id	service_name	department	matching_score	lifecycle_match_score	household_match_score	region_match_score	is_online_available	created_at
BIGINT UNSIGNED	VARCHAR(100)	VARCHAR(500)	VARCHAR(200)	INT UNSIGNED	INT UNSIGNED	INT UNSIGNED	INT UNSIGNED	BOOLEAN	TIMESTAMP
PRIMARY KEY, FK → welfare_diagnoses	PRIMARY KEY	NOT NULL	NULL	NOT NULL	NULL	NULL	NULL	NULL	NOT NULL
-	-	-	-	-	-	-	-	FALSE	CURRENT_TIMESTAMP
```

---

## 15. 후기 도움됨 (review_helpfuls)

**설명**: 후기 '도움됨' 클릭 이력 관리 (중복 방지)

```
도움됨ID	후기ID	회원고유번호	후기유형	IP주소	추천일
helpful_id	review_id	member_id	review_type	ip_address	created_at
BIGINT UNSIGNED	BIGINT UNSIGNED	BIGINT UNSIGNED	ENUM	VARCHAR(45)	TIMESTAMP
PRIMARY KEY	NOT NULL	FK → member	NULL	NOT NULL	NOT NULL
AUTO_INCREMENT	-	-	'DONATION'	-	CURRENT_TIMESTAMP
```

---

## 16. 시스템 로그 (system_logs)

**설명**: 시스템 활동 로그 기록, 감사 추적

```
로그ID	회원ID	로그유형	액션설명	IP주소	사용자에이전트	요청URL	HTTP메서드	응답코드	응답시간ms	에러메시지	로그생성시간
log_id	member_id	log_type	action	ip_address	user_agent	request_url	request_method	response_status	response_time_ms	error_message	created_at
BIGINT UNSIGNED	BIGINT UNSIGNED	ENUM	VARCHAR(200)	VARCHAR(45)	VARCHAR(500)	VARCHAR(500)	ENUM	INT UNSIGNED	INT UNSIGNED	TEXT	TIMESTAMP
PRIMARY KEY	FK → member	NOT NULL	NOT NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NOT NULL
AUTO_INCREMENT	-	-	-	-	-	-	-	-	-	-	CURRENT_TIMESTAMP
```

---

## 데이터 타입 최적화

- **BIGINT UNSIGNED**: 회원, 기부, 진단 등 대용량 데이터 (최대 18경)
- **INT UNSIGNED**: 카운트, 점수, 카테고리 등 (최대 42억)
- **CHAR(11)**: 전화번호 고정길이 (하이픈 제거)
- **ENUM**: 상태값, 카테고리 (저장공간 최소화, 데이터 무결성)
- **DECIMAL**: 금액 (정확한 계산)
- **JSON**: 동적 데이터 (매칭 결과, 이미지 URL 등)
- **VARCHAR(45)**: IP 주소 (IPv6 지원)

---

## 주요 제약 조건

### CHECK 제약
- 회원: `kindness_temperature BETWEEN 0.00 AND 100.00`, `birth <= CURDATE()`, `login_fail_count <= 10`
- 기부: `amount > 0 AND amount <= 999999999999.99`
- 후기: `rating BETWEEN 1 AND 5`, `report_count <= 100`
- 복지진단: `household_size > 0`, `age BETWEEN 0 AND 150`, `disability_grade BETWEEN 1 AND 6`
- 봉사활동: `current_participants <= max_participants`, `min_age <= max_age`, `end_time > start_time`
- 매칭결과: `matching_score <= 170`, `lifecycle_match_score <= 30`, `household_match_score <= 40`

### UNIQUE 제약
- 회원: email
- 기부: transaction_id
- 카테고리: category_code
- 후기 도움됨: (review_id, review_type, member_id), (review_id, review_type, ip_address)

---

## ER 관계 요약

- **member (1)** → **donations (N)** → **donation_reviews (N)**
- **member (1)** → **welfare_diagnoses (N)** → **diagnosis_results (N)**
- **member (1)** → **volunteer_applications (N)** → **volunteer_reviews (N)**
- **donation_categories (1)** → **donations (N)**
- **faq_categories (1)** → **faqs (N)**
- **volunteer_activities (1)** → **volunteer_applications (N)**
- **member (1)** → **favorite_welfare_services (N)** (복합키)
